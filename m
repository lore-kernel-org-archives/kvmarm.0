From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 22/38] KVM: arm64: Handle PSCI call via smc from the
 guest
Date: Tue, 18 Jul 2017 11:58:48 -0500
Message-ID: <1500397144-16232-23-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D774540A80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n6CBoOJOZcfo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:26 -0400 (EDT)
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com
 [209.85.214.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0841449C1B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:26 -0400 (EDT)
Received: by mail-it0-f54.google.com with SMTP id a62so23798327itd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:14 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

VMs used to execute hvc #0 for the psci call if EL3 is not implemented.
However, when we come to provide the virtual EL2 mode to the VM, the
host OS inside the VM calls kvm_call_hyp() which is also hvc #0. So,
it's hard to differentiate between them from the host hypervisor's point
of view.

So, let the VM execute smc instruction for the psci call. On ARMv8.3,
even if EL3 is not implemented, a smc instruction executed at non-secure
EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than being treated as
UNDEFINED. So, the host hypervisor can handle this psci call without any
confusion.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/handle_exit.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d19e253..6cf6b93 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -53,8 +53,28 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	kvm_inject_undefined(vcpu);
-	return 1;
+	int ret;
+
+	/* If imm is non-zero, it's not defined */
+	if (kvm_vcpu_hvc_get_imm(vcpu)) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
+
+	/*
+	 * If imm is zero, it's a psci call.
+	 * Note that on ARMv8.3, even if EL3 is not implemented, SMC executed
+	 * at Non-secure EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than
+	 * being treated as UNDEFINED.
+	 */
+	ret = kvm_psci_call(vcpu);
+	if (ret < 0) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+
+	return ret;
 }
 
 /*
-- 
1.9.1
