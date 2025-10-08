import { apiInitializer } from "discourse/lib/api";
import readerModeToggle from "../components/reader-mode-toggle";

export default apiInitializer((api) => {
  api.renderInOutlet("timeline-controls-before", readerModeToggle);
});
