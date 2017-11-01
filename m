From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v1 3/3] KVM: arm64: add ESB in exception handler entry and
 exit.
Date: Thu, 2 Nov 2017 03:14:57 +0800
Message-ID: <1509563697-6359-4-git-send-email-gengdongjiu@huawei.com>
References: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3979D49D5E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Nov 2017 07:08:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mx9Wxt8PJ4cB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Nov 2017 07:08:46 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDDEE40A74
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Nov 2017 07:08:45 -0400 (EDT)
In-Reply-To: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: catalin.marinas@arm.com, will.deacon@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, james.morse@arm.com, mark.rutland@arm.com, ard.biesheuvel@linaro.org, robin.murphy@arm.com, cov@codeaurora.org, Dave.Martin@arm.com, gengdongjiu@huawei.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Some hardware platform can support RAS Extension instead
of support IESB, so software need to insert Synchronization
Barrier operations at exception handler entry and exit.

In the __guest_exit(), it added a ESB instruction, but can
not cover the path which is not guest exit. For example, if
EL1 host call HVC instruction enter to hypervisor, it will
not call __guest_exit().

In the kvm_arm_vhe_guest_enter(), it synchronised any host
RAS errors for VHE mode, but it can not handle the non-VHE
mode. For example, if EL1 host is pending a SError, the error
can be propagated to guest without error synchronization
operation.

Only add the ESB in the important exception handler path to
reduce the impact on performance.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/kvm/hyp/entry.S     | 2 ++
 arch/arm64/kvm/hyp/hyp-entry.S | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 96caa53..fce6806 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -84,6 +84,8 @@ ENTRY(__guest_enter)
 	// Restore guest reg x18
 	ldr	x18,      [x18, #CPU_XREG_OFFSET(18)]
 
+	// synchronize host pending asynchronous error
+	error_synchronize
 	// Do not touch any register after this!
 	eret
 ENDPROC(__guest_enter)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5170ce1..ac85029 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -54,6 +54,7 @@ ENTRY(__vhe_hyp_call)
 ENDPROC(__vhe_hyp_call)
 
 el1_sync:				// Guest trapped into EL2
+	error_synchronize
 	stp	x0, x1, [sp, #-16]!
 
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-- 
1.9.1
