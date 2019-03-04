From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 05/11] KVM: arm/arm64: Reset the VCPU without preemption
 and vcpu state loaded
Date: Mon, 4 Mar 2019 17:06:25 +0000
Message-ID: <ec205905-6b7b-2a6d-f70f-9bca574dd593@arm.com>
References: <20190207131843.157210-1-marc.zyngier@arm.com>
 <20190207131843.157210-6-marc.zyngier@arm.com>
 <f6928433-8ae6-6cae-d86d-b392f5b4fea6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 687B74A36D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Mar 2019 12:06:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S7T-YJiBKCuu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Mar 2019 12:06:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D63C49F94
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Mar 2019 12:06:29 -0500 (EST)
In-Reply-To: <f6928433-8ae6-6cae-d86d-b392f5b4fea6@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/03/2019 16:30, Julien Grall wrote:
> Hi,
> 
> I noticed some issues with this patch when rebooting a guest after using perf.
> 
> [  577.513447] BUG: sleeping function called from invalid context at 
> kernel/locking/mutex.c:908
> [  577.521926] in_atomic(): 1, irqs_disabled(): 0, pid: 2323, name: qemu-system aar
> [  577.529354] 1 lock held by qemu-system-aar/2323:
> [  577.533998]  #0: 00000000f4f96804 (&vcpu->mutex){+.+.}, at: 
> kvm_vcpu_ioctl+0x74/0xac0
> [  577.541865] Preemption disabled at:
> [  577.541871] [<ffff0000100cc82c>] kvm_reset_vcpu+0x1c/0x1d0
> [  577.550882] CPU: 6 PID: 2323 Comm: qemu-system-aar Tainted: G        W  5.0.0 
> #1277
> [  577.559137] Hardware name: AMD Seattle (Rev.B0) Development Board (Overdrive) 
> (DT)
> [  577.566698] Call trace:
> [  577.569138]  dump_backtrace+0x0/0x140
> [  577.572793]  show_stack+0x14/0x20
> [  577.576103]  dump_stack+0xa0/0xd4
> [  577.579412]  ___might_sleep+0x1e4/0x2b0
> [  577.583241]  __might_sleep+0x60/0xb8
> [  577.586810]  __mutex_lock+0x58/0x860
> [  577.590378]  mutex_lock_nested+0x1c/0x28
> [  577.594294]  perf_event_ctx_lock_nested+0xf4/0x238
> [  577.599078]  perf_event_read_value+0x24/0x60
> [  577.603341]  kvm_pmu_get_counter_value+0x80/0xe8
> [  577.607950]  kvm_pmu_stop_counter+0x2c/0x98
> [  577.612126]  kvm_pmu_vcpu_reset+0x58/0xd0
> [  577.616128]  kvm_reset_vcpu+0xec/0x1d0
> [  577.619869]  kvm_arch_vcpu_ioctl+0x6b0/0x860
> [  577.624131]  kvm_vcpu_ioctl+0xe0/0xac0
> [  577.627876]  do_vfs_ioctl+0xbc/0x910
> [  577.631443]  ksys_ioctl+0x78/0xa8
> [  577.634751]  __arm64_sys_ioctl+0x1c/0x28
> [  577.638667]  el0_svc_common+0x90/0x118
> [  577.642408]  el0_svc_handler+0x2c/0x80
> [  577.646150]  el0_svc+0x8/0xc
> 
> This is happening because the vCPU reset code is now running with preemption 
> disable. However, the perf code cannot be called with preemption disabled as it 
> is using mutex.
> 
> Do you have any suggestion on the way to fix this potential issue?

Given that the PMU is entirely emulated, it never has any state loaded
on the CPU. It thus doesn't need to be part of the non-preemptible section.

Can you please give this (untested) patchlet one a go? It's not exactly
pretty, but I believe it will do the trick.

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 54788eb9e695..16e773f3019f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -128,6 +128,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	int ret = -EINVAL;
 	bool loaded;

+	/* Reset PMU outside of the non-preemptible section */
+	kvm_pmu_vcpu_reset(vcpu);
+
 	preempt_disable();
 	loaded = (vcpu->cpu != -1);
 	if (loaded)
@@ -177,9 +180,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		vcpu->arch.reset_state.reset = false;
 	}

-	/* Reset PMU */
-	kvm_pmu_vcpu_reset(vcpu);
-
 	/* Default workaround setup is enabled (if supported) */
 	if (kvm_arm_have_ssbd() == KVM_SSBD_KERNEL)
 		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;


Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
