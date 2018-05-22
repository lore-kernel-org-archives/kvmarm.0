From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PULL v8] KVM: arm64: Optimise FPSIMD context switching
Date: Tue, 22 May 2018 13:04:10 +0100
Message-ID: <20180522120357.GE13470@e103592.cambridge.arm.com>
References: <20180516104942.GS7753@e103592.cambridge.arm.com>
 <20180520141441.3d999f16@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5E9B4059B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 07:54:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C3A7ngO5Seal for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 May 2018 07:53:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A00D4A0D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 07:53:38 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180520141441.3d999f16@why.wild-wind.fr.eu.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, May 20, 2018 at 02:14:41PM +0100, Marc Zyngier wrote:
> On Wed, 16 May 2018 11:49:42 +0100
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> Hi Dave,
> 
> > Hi Marc,
> > 
> > This is a trivial update to the previously posted v7 [1].  The only
> > changes are a couple of minor cosmetic changes requested by reviewers,
> > on-list and the addition of Acked-by/Reviewed-by tags received since the
> > series was posted.
> > 
> > Let me know if you need anything else on this.
> 
> So I've taken this, merged in Linus' top of tree, started a guest on a
> dual A53 board, and immediately hit the following:
> 
> root@sy-borg:~# [  287.226184] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> [  287.231672] Mem abort info:
> [  287.234537]   ESR = 0x96000044
> [  287.237674]   Exception class = DABT (current EL), IL = 32 bits
> [  287.243765]   SET = 0, FnV = 0
> [  287.246900]   EA = 0, S1PTW = 0
> [  287.250126] Data abort info:
> [  287.253083]   ISV = 0, ISS = 0x00000044
> [  287.257025]   CM = 0, WnR = 1
> [  287.260076] user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000b8483f75
> [  287.266882] [0000000000000000] pgd=0000000000000000
> [  287.271903] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> [  287.277636] Modules linked in:
> [  287.280776] CPU: 1 PID: 3098 Comm: kworker/u4:3 Not tainted 4.17.0-rc5-00166-gd84e81cca249 #136
> [  287.289730] Hardware name: Globalscale Marvell ESPRESSOBin Board (DT)
> [  287.296364] pstate: 40000085 (nZcv daIf -PAN -UAO)
> [  287.301301] pc : fpsimd_save_state+0x0/0x54
> [  287.305595] lr : fpsimd_save+0x50/0x100
> [  287.309531] sp : ffff00000dde3af0
> [  287.312936] x29: ffff00000dde3af0 x28: ffff000008cd565c 
> [  287.318401] x27: ffff800078ee9c80 x26: ffff80007b207628 
> [  287.323867] x25: ffff0000093f9000 x24: 0000000000000001 
> [  287.329333] x23: ffff0000093d4000 x22: ffff80007b207000 
> [  287.334798] x21: ffff80007efd7d80 x20: ffff80007b207000 
> [  287.340264] x19: 0000000000000000 x18: 0000000000040f0b 
> [  287.345729] x17: 0000ffffb70752b8 x16: 0000ffffb708e008 
> [  287.351195] x15: 0000000000000000 x14: 0000000000000400 
> [  287.356661] x13: 0000000000000001 x12: 0000000000000001 
> [  287.362127] x11: 0000000000000001 x10: 0000000000000000 
> [  287.367592] x9 : 0000000000000253 x8 : ffff80007b207200 
> [  287.373057] x7 : ffff80007b207100 x6 : ffff80007c378f18 
> [  287.378523] x5 : 00000042c2094c00 x4 : 0000000000000000 
> [  287.383990] x3 : 00000042e0033450 x2 : 0000000000000000 
> [  287.389454] x1 : 0000800075bf6000 x0 : 0000000000000000 
> [  287.394922] Process kworker/u4:3 (pid: 3098, stack limit = 0x00000000ca0dd8c6)
> [  287.402358] Call trace:
> [  287.404873]  fpsimd_save_state+0x0/0x54
> [  287.408813]  fpsimd_thread_switch+0x28/0xa0
> [  287.413114]  __switch_to+0x1c/0xd0
> [  287.416609]  __schedule+0x1b8/0x730
> [  287.420191]  preempt_schedule_common+0x24/0x48
> [  287.424760]  preempt_schedule.part.23+0x1c/0x28
> [  287.429419]  preempt_schedule+0x1c/0x28
> [  287.433363]  _raw_spin_unlock+0x34/0x48
> [  287.437308]  flush_old_exec+0x45c/0x6a0
> [  287.441250]  load_elf_binary+0x324/0x1198
> [  287.445372]  search_binary_handler+0xac/0x230
> [  287.449851]  do_execveat_common.isra.14+0x508/0x6e0
> [  287.454867]  do_execve+0x28/0x30
> [  287.458185]  call_usermodehelper_exec_async+0xdc/0x140
> [  287.463468]  ret_from_fork+0x10/0x18
> [  287.467143] Code: a9425bf5 a8c37bfd d65f03c0 d65f03c0 (ad000400) 
> [  287.473414] ---[ end trace c4346b99cc877f8e ]---
> 
> It happened just after having loaded the guest kernel, so I presume
> we're missing some kind of initialization. I couldn't subsequently
> reproduce it  on the same machine, and the same kernel is doing
> absolutely fine on a Seattle box.
> 
> I can't immediately see how st would be NULL, unless we somehow are
> missing some state tracking somewhere...
> 
> Any idea?

I have a reproducer now for something that resembles the above bug.
(Build test.c separately and run it from the target.)

In order for this particular bug to happen we need some kernel thread
or softirq in a kernel thread to use kernel-mode NEON (thus setting
fpsimd_last_state.st to NULL but leaving TIF_FOREIGN_FPSTATE clear),
then a kernel thread with no mm is scheduled in on the same cpu, then
that thread gans an mm and get scheduled out.

I don't force-affine anything in this test, but on an idle system it
seems to fire reliably.

There may be more plausible failure scenarios, but this is the
definite one that I've found.


There are two overlapping problems here: firstly the conditional
failure to set TIF_FOREIGN_FPSTATE in kernel_neon_begin() (which
was a latent bug prior to the VHE FPSIMD series), and secondly
the assumption that !TIF_FOREIGN_FPSTATE implies that current's
FPSIMD state is loaded (so fpsimd_last_state.st != NULL):
the latter is not true for kernel threads.

I will post patches shortly.  My current approach is to pull the
set_thread_flag(TIF_FOREIGN_FPSTATE) into fpsimd_flush_cpu_state()
(so that it can't be forgotten in this scenario), and to remove
the special-case handling of kernel threads in fpsimd.c: the only
requirement is to ensure TIF_FOREIGN_FPSTATE is set for the init task,
and remove the ->mm based "optimisation" that allows a wrong
TIF_FOREIGN_FPSTATE to be left behind on sched-in.

kernel threads never get any FPSIMD state loaded, but virtue of
never entering userspace.  They will now never save state either,
by virtue of TIF_FOREIGN_FPSTATE always being true for these
threads.

Cheers
---Dave


diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index b0d29b7..c85f4eb 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1314,3 +1314,10 @@ static int __init fpsimd_init(void)
 	return sve_sysctl_init();
 }
 core_initcall(fpsimd_init);
+
+void __fpsimd_print_state(char const *file, int line)
+{
+	pr_info("%s[%d]: %s:%d: current->mm = %p, fpsimd_last_state.st = %p, TIF_FOREIGN_FPSTATE = %d\n",
+		current->comm, task_pid_nr(current), file, line,
+		current->mm, this_cpu_read(fpsimd_last_state.st), test_thread_flag(TIF_FOREIGN_FPSTATE) ? 1 : 0);
+}
diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
index 72981ba..745f5f0 100644
--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -59,7 +59,9 @@ asmlinkage long sys_rt_sigreturn_wrapper(void);
  * The sys_call_table array must be 4K aligned to be accessible from
  * kernel/entry.S.
  */
+extern long arm64_ni_syscall(long nr);
+
 void * const sys_call_table[__NR_syscalls] __aligned(4096) = {
-	[0 ... __NR_syscalls - 1] = sys_ni_syscall,
+	[0 ... __NR_syscalls - 1] = arm64_ni_syscall,
 #include <asm/unistd.h>
 };
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 8bbdc17..a9a8589 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/bug.h>
+#include <linux/completion.h>
 #include <linux/signal.h>
 #include <linux/personality.h>
 #include <linux/kallsyms.h>
@@ -27,10 +28,13 @@
 #include <linux/kdebug.h>
 #include <linux/module.h>
 #include <linux/kexec.h>
+#include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/mmu_context.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/debug.h>
+#include <linux/sched/mm.h>
 #include <linux/sched/task_stack.h>
 #include <linux/sizes.h>
 #include <linux/syscalls.h>
@@ -43,6 +47,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/insn.h>
+#include <asm/neon.h>
 #include <asm/traps.h>
 #include <asm/smp.h>
 #include <asm/stack_pointer.h>
@@ -549,10 +554,92 @@ asmlinkage void __exception do_sysinstr(unsigned int esr, struct pt_regs *regs)
 
 long compat_arm_syscall(struct pt_regs *regs);
 
+struct grabber_data {
+	int err;
+	struct completion c, c2;
+	struct mm_struct *mm;
+};
+
+extern void __fpsimd_print_state(char const *, int);
+#define fpsimd_print_state() __fpsimd_print_state(__FILE__, __LINE__)
+
+static int grabber(void *data)
+{
+	struct grabber_data *g = data;
+
+	if (!mmget_not_zero(g->mm)) {
+		g->err = -ESRCH;
+		goto out;
+	}
+
+	fpsimd_print_state();
+
+	g->err = 0;
+
+	kernel_neon_begin();
+	kernel_neon_end();
+
+	fpsimd_print_state();
+
+	use_mm(g->mm);
+
+	fpsimd_print_state();
+
+	complete(&g->c);
+	wait_for_completion(&g->c2);
+
+	g->err = 0;
+out:
+	complete(&g->c);
+	return g->err;
+}
+
+static int do_trigger_bug(void)
+{
+	struct task_struct *kth;
+	struct grabber_data g;
+
+	pr_info("%s[%d]: do_trigger_bug() called\n",
+		current->comm, task_pid_nr(current));
+
+	init_completion(&g.c);
+	init_completion(&g.c2);
+	mmgrab(current->mm);
+	g.mm = current->mm;
+
+	kth = kthread_create(grabber, &g, "grabber[%d]", task_pid_nr(current));
+	if (IS_ERR(kth)) {
+		mmdrop(current->mm);
+		return PTR_ERR(kth);
+	}
+
+	wake_up_process(kth);
+	wait_for_completion(&g.c);
+	mmdrop(current->mm);
+	if (g.err) {
+		pr_info("%s: mm disappeared\n", __func__);
+		return g.err;
+	}
+
+	init_completion(&g.c);
+	complete(&g.c2);
+	wait_for_completion(&g.c);
+	return g.err;
+}
+
+long arm64_ni_syscall(long nr)
+{
+	if ((int)nr == 8888)
+		return do_trigger_bug();
+
+	return -ENOSYS;
+}
+
 asmlinkage long do_ni_syscall(struct pt_regs *regs)
 {
-#ifdef CONFIG_COMPAT
 	long ret;
+
+#ifdef CONFIG_COMPAT
 	if (is_compat_task()) {
 		ret = compat_arm_syscall(regs);
 		if (ret != -ENOSYS)
@@ -560,7 +647,7 @@ asmlinkage long do_ni_syscall(struct pt_regs *regs)
 	}
 #endif
 
-	return sys_ni_syscall();
+	return arm64_ni_syscall(regs->regs[8]);
 }
 
 static const char *esr_class_str[] = {
--- /dev/null	2017-09-27 16:25:00.179999999 +0100
+++ test.c	2018-05-22 11:59:58.671159660 +0100
@@ -0,0 +1,12 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+
+int main(void)
+{
+	if (syscall(8888) == -1)
+		perror("8888");
+
+	return 0;
+}


yielding

[  229.246349] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  229.246423] Mem abort info:
[  229.246474]   ESR = 0x96000046
[  229.246529]   Exception class = DABT (current EL), IL = 32 bits
[  229.246598]   SET = 0, FnV = 0
[  229.246652]   EA = 0, S1PTW = 0
[  229.246700] Data abort info:
[  229.246751]   ISV = 0, ISS = 0x00000046
[  229.246809]   CM = 0, WnR = 1
[  229.246871] user pgtable: 4k pages, 48-bit VAs, pgdp =         (ptrval)
[  229.246944] [0000000000000000] pgd=00000008fa6be003, pud=00000008fa6b5003, pmd=0000000000000000
[  229.247070] Internal error: Oops: 96000046 [#1] PREEMPT SMP
[  229.247130] Modules linked in:
[  229.247214] CPU: 0 PID: 1348 Comm: grabber[1347] Not tainted 4.17.0-rc3-00016-g885df5d-dirty #25
[  229.247296] Hardware name: FVP Base (DT)
[  229.247368] pstate: 40000085 (nZcv daIf -PAN -UAO)
[  229.247452] pc : fpsimd_save_state+0x0/0x54
[  229.247530] lr : fpsimd_save+0x54/0xe8
[  229.247586] sp : ffff00000ad13c10
[  229.247643] x29: ffff00000ad13c10 x28: 0000000000000000
[  229.247734] x27: 0000000000000000 x26: ffff80087ac7cc20
[  229.247830] x25: ffff000008a554f0 x24: ffff000009269b88
[  229.247926] x23: ffff00000924f010 x22: ffff80087ac7c600
[  229.248022] x21: ffff000009272a80 x20: ffff80087ac7c600
[  229.248115] x19: 0000000000000000 x18: 0000000000000010
[  229.248209] x17: 00000000d12b3c86 x16: 000000000be55560
[  229.248302] x15: 0000000000000400 x14: 0000000000000400
[  229.248395] x13: 0000000000000400 x12: 0000000000000001
[  229.248488] x11: 00000000000001bd x10: 0000000000000000
[  229.248580] x9 : 0000000002e79c03 x8 : 0000000000000000
[  229.248671] x7 : 0000000000000000 x6 : ffff80087ac7c730
[  229.248767] x5 : ffff80087ac7c600 x4 : 0000000000000000
[  229.248858] x3 : 0000000000000002 x2 : 0000000000000000
[  229.248951] x1 : 0000800876d64000 x0 : 0000000000000000
[  229.249050] Process grabber[1347] (pid: 1348, stack limit = 0x        (ptrval))
[  229.249119] Call trace:
[  229.249193]  fpsimd_save_state+0x0/0x54
[  229.249272]  fpsimd_thread_switch+0x28/0xc0
[  229.249353]  __switch_to+0x1c/0xd0
[  229.249426]  __schedule+0x1c0/0x5d0
[  229.249502]  schedule+0x38/0xa0
[  229.249580]  schedule_timeout+0x23c/0x338
[  229.249661]  wait_for_common+0x140/0x168
[  229.249741]  wait_for_completion+0x14/0x20
[  229.249824]  grabber+0x108/0x128
[  229.249897]  kthread+0x124/0x128
[  229.249970]  ret_from_fork+0x10/0x18
[  229.250058] Code: 94273d7b b9403fe1 f9401be0 17ffffe8 (ad000400)
[  229.250133] ---[ end trace b5b40d96060ea368 ]---
