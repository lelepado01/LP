
let pure_val = 184.0;;

type conversion = {
    scale : string;
    to_c_scale : float -> float;
    from_c_scale : float -> float
    };;

let conversion_table = 
    [
        {
            scale = "Celsius";
            to_c_scale = (fun x -> x);
            from_c_scale = (fun x -> x);
        };
        {
            scale = "Kelvin";
            to_c_scale = (fun x -> x -. 273.1 );
            from_c_scale = (fun x -> x +. 273.1); 
        };
        {
            scale = "Fahrenheit";
            to_c_scale = (fun x -> x);
            from_c_scale = (fun x -> x);
        };
        {
            scale = "Newton";
            to_c_scale = (fun x -> x);
            from_c_scale = (fun x -> x);
        };
        {
            scale = "Rankine";
            to_c_scale = (fun x -> x);
            from_c_scale = (fun x -> x);
        };
    ];;

let to_celsius = fun scale temp ->
    let find_scale = fun el ->
        if el.scale = scale then true else false
    in (List.find find_scale conversion_table).to_c_scale temp;;

let celsius_to_all = fun value ->
    let print_vals = fun el ->
        Printf.printf "%f \n" (el.from_c_scale value) 
    in List.iter print_vals conversion_table;;


Printf.printf "%f\n" (to_celsius "Kelvin" pure_val);;

celsius_to_all 12.0;;
