From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 1/2] kvm: Do not pause already paused vcpus
Date: Fri, 19 Oct 2018 10:36:30 +0100
Message-ID: <1539941791-40118-2-git-send-email-julien.thierry@arm.com>
References: <1539941791-40118-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30EF84A2BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 05:36:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Iu74SNE2NCA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 05:36:47 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2819B4A2BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 05:36:47 -0400 (EDT)
In-Reply-To: <1539941791-40118-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

With the following sequence:
	kvm__pause();
	kvm__continue();
	kvm__pause();

There is a chance that not all paused threads have been resumed, and the
second kvm__pause will attempt to pause them again. Since the paused thread
is waiting to own the pause_lock, it won't write its second pause
notification. kvm__pause will be waiting for that notification while owning
pause_lock, so... deadlock.

Simple solution is not to try to pause thread that had not the chance to
resume.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 kvm-cpu.c | 4 +---
 kvm.c     | 5 ++++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index cc8385f..4107841 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -148,10 +148,8 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 		kvm_cpu__enable_singlestep(cpu);
 
 	while (cpu->is_running) {
-		if (cpu->paused) {
+		if (cpu->paused)
 			kvm__notify_paused();
-			cpu->paused = 0;
-		}
 
 		if (cpu->needs_nmi) {
 			kvm_cpu__arch_nmi(cpu);
diff --git a/kvm.c b/kvm.c
index 05ad0b6..052c6e8 100644
--- a/kvm.c
+++ b/kvm.c
@@ -63,6 +63,8 @@ extern struct kvm_ext kvm_req_ext[];
 
 static char kvm_dir[PATH_MAX];
 
+extern __thread struct kvm_cpu *current_kvm_cpu;
+
 static int set_dir(const char *fmt, va_list args)
 {
 	char tmp[PATH_MAX];
@@ -521,7 +523,7 @@ void kvm__pause(struct kvm *kvm)
 	if (pause_event < 0)
 		die("Failed creating pause notification event");
 	for (i = 0; i < kvm->nrcpus; i++) {
-		if (kvm->cpus[i]->is_running)
+		if (kvm->cpus[i]->is_running && kvm->cpus[i]->paused == 0)
 			pthread_kill(kvm->cpus[i]->thread, SIGKVMPAUSE);
 		else
 			paused_vcpus++;
@@ -545,5 +547,6 @@ void kvm__notify_paused(void)
 		die("Failed notifying of paused VCPU.");
 
 	mutex_lock(&pause_lock);
+	current_kvm_cpu->paused = 0;
 	mutex_unlock(&pause_lock);
 }
-- 
1.9.1
