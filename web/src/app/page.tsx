import Sidebar from "@/components/Sidebar";
import SparkFeed from "@/components/SparkFeed";

export default function Dashboard() {
  return (
    <div className="flex min-h-screen">
      <Sidebar />
      <main className="flex-1 p-8">
        <div className="max-w-4xl mx-auto">
          <h2 className="text-2xl font-mono text-foreground-primary mb-8">
            Latest Sparks
          </h2>
          <SparkFeed />
        </div>
      </main>
    </div>
  );
}