import { apiInitializer } from "discourse/lib/api";
import readerModeToggle from "../components/reader-mode-toggle";

export default apiInitializer("1.8.0", (api) => {
  api.renderInOutlet("timeline-controls-before", readerModeToggle);
});
