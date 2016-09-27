From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 26/50] arm: KVM: Preserve pending Virtual Abort in world switch
Date: Tue, 27 Sep 2016 20:05:34 +0200
Message-ID: <20160927180558.14699-27-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1268D49BA9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z1wtaNeeIbFy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:52 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB09049BA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:48 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id l132so190647159wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:12 -0700 (PDT)
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

The HCR.VA bit is used to signal an Abort to a guest, and has
the peculiar feature of getting cleared when the guest has taken
the abort (this is the only bit that behaves as such in this register).

This means that if we signal such an abort, we must leave it in
the guest context until it disappears from HCR, and at which point
it must be cleared from the context.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/hyp/switch.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 37b3365..9da16fd 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -54,6 +54,15 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	u32 val;
 
+	/*
+	 * If we pended a virtual abort, preserve it until it gets
+	 * cleared. See B1.9.9 (Virtual Abort exception) for details,
+	 * but the crucial bit is the zeroing of HCR.VA in the
+	 * pseudocode.
+	 */
+	if (vcpu->arch.hcr & HCR_VA)
+		vcpu->arch.hcr = read_sysreg(HCR);
+
 	write_sysreg(0, HCR);
 	write_sysreg(0, HSTR);
 	val = read_sysreg(HDCR);
-- 
2.9.0
