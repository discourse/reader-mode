import { apiInitializer } from "discourse/lib/api";
import readerModeToggle from "../components/reader-mode-toggle";

export default apiInitializer("1.8.0", (api) => {
  // api.headerIcons.add("book-reader", readerModeToggle, { before: "chat" });

  api.renderInOutlet("timeline-controls-before", readerModeToggle);
});
