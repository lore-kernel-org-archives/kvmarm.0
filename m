From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 31/50] arm: KVM: Inject a Virtual Abort if it was pending
Date: Tue, 27 Sep 2016 20:05:39 +0200
Message-ID: <20160927180558.14699-32-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE56F49B8D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2hG-S8eFBosV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:57 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBE1E49BA9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:53 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id l132so190651617wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:17 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

If we have caught an Abort whilst exiting, we've tagged the
exit code with the pending information. In that case, let's
re-inject the error into the guest, after having adjusted
the PC if required.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/handle_exit.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 863fdf4..4eacb5c 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -144,6 +144,25 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	exit_handle_fn exit_handler;
 
+	if (ARM_ABORT_PENDING(exception_index)) {
+		u8 hsr_ec = kvm_vcpu_trap_get_class(vcpu);
+
+		/*
+		 * HVC/SMC already have an adjusted PC, which we need
+		 * to correct in order to return to after having
+		 * injected the abort.
+		 */
+		if (hsr_ec == HSR_EC_HVC || hsr_ec == HSR_EC_SMC) {
+			u32 adj =  kvm_vcpu_trap_il_is32bit(vcpu) ? 4 : 2;
+			*vcpu_pc(vcpu) -= adj;
+		}
+
+		kvm_inject_vabt(vcpu);
+		return 1;
+	}
+
+	exception_index = ARM_EXCEPTION_CODE(exception_index);
+
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
 		return 1;
-- 
2.9.0
