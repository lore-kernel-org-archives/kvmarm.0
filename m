From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 2/2] kvm-cpu: Pause vCPU in signal handler
Date: Fri, 19 Oct 2018 10:36:31 +0100
Message-ID: <1539941791-40118-3-git-send-email-julien.thierry@arm.com>
References: <1539941791-40118-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 037704A2DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 05:36:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h5bT+yOoQLzL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 05:36:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BA314A2C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 05:36:48 -0400 (EDT)
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

Currently, the handling a pause signal only sets a state that will be
checked at the begining of the CPU run loop. At the checking point the vCPU
sends the notification that it is actually paused allowing the pause
requester to confirm all vCPUs are paused.

Receiving the pause signal during a KVM_RUN ioctl will make KVM exit to
userspace. However, there is a small window between that check on
cpu->paused and the execution of KVM_RUN where the signal has been received
but the vCPU does not go back through the notification and starts KVM_RUN.
Since there is no guarantee the vCPU will come back to userspace, the
pause requester might deadlock.

Perform the pause directly from the signal handler. This relies on a vCPU
thread never receiving a pause signal while being pause, but such scenario
would have caused a deadlock for the pause requester anyway.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 kvm-cpu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index 4107841..7dec088 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -51,7 +51,19 @@ static void kvm_cpu_signal_handler(int signum)
 		if (current_kvm_cpu && current_kvm_cpu->is_running)
 			current_kvm_cpu->is_running = false;
 	} else if (signum == SIGKVMPAUSE) {
+		if (current_kvm_cpu->paused)
+			die("Pause signaled for already paused CPU\n");
+
+		/* pause_lock is held by kvm__pause() */
 		current_kvm_cpu->paused = 1;
+
+		/*
+		 * This is a blocking function and uses locks. It is safe
+		 * to call it for this signal as a second pause event should
+		 * not be send to this thread until it acquires and releases
+		 * the pause_lock.
+		 */
+		kvm__notify_paused();
 	}
 
 	/* For SIGKVMTASK cpu->task is already set */
@@ -148,9 +160,6 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 		kvm_cpu__enable_singlestep(cpu);
 
 	while (cpu->is_running) {
-		if (cpu->paused)
-			kvm__notify_paused();
-
 		if (cpu->needs_nmi) {
 			kvm_cpu__arch_nmi(cpu);
 			cpu->needs_nmi = 0;
-- 
1.9.1
