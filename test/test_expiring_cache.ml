let () =
  let max_age = 0.5 in
  let ec = Expiring_cache.create ~max_age (module Base.Int) in
  for i = 0 to 99 do
    Expiring_cache.set ec ~key:i ~data:(i + 1);
  done;
  Unix.sleepf (max_age +. 0.01);
  for i = 0 to 99 do
    (assert (Expiring_cache.mem ec ~key:i = false));
  done

let () =
  let max_age = 0.5 in
  let ec = Expiring_cache.create ~max_age (module Base.Int) in
  for i = 0 to 99 do
    Expiring_cache.set ec ~key:i ~data:(i + 1);
  done;
  Unix.sleepf (max_age /. 2.);
  for i = 0 to 99 do
    (assert (Expiring_cache.mem ec ~key:i = true));
  done
