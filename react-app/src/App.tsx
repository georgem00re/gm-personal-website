import './App.css'
import {faFilePdf} from "@fortawesome/free-solid-svg-icons";
import {faGithub, faLinkedin} from "@fortawesome/free-brands-svg-icons";
import Button from "./components/Button.tsx";
import Sprite from "./components/Sprite.tsx";

function App() {
    const navigate = (url: string) => {
        window.open(url, "_blank");
    }

    return (
    <>
        <h1 className="text-white font-avenir-medium">George Moore</h1>
        <p className="text-white m-2 font-avenir">Software Engineer</p>
        <Sprite/>
        <div className="flex flex-wrap justify-center">
            <Button icon={faLinkedin} onClick={() => navigate("https://uk.linkedin.com/in/george-moore-275087217")}/>
            <Button icon={faGithub} onClick={() => navigate("https://github.com/georgem00re")}/>
            <Button icon={faFilePdf} onClick={() => navigate("./curriculum_vitae.pdf")}/>
        </div>
    </>
    )
}

export default App
