import React from "react";
import type { IconProp } from "@fortawesome/fontawesome-svg-core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

interface ButtonProps {
    icon: IconProp;
    onClick: () => void;
}

const Button = ({ icon, onClick }: ButtonProps): React.JSX.Element => {
    return (
        <button type="button" className="button" onClick={onClick}>
            <FontAwesomeIcon icon={icon} size="lg" color="black"/>
        </button>
    )
}

export default Button;
