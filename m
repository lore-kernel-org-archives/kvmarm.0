From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/RFT PATCH 2/3] arm64: KVM: mangle MAIR register to prevent
 uncached guest mappings
Date: Thu, 19 Feb 2015 10:54:45 +0000
Message-ID: <1424343286-6792-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B29B845FE0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 05:49:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EvGvh2FUZOjU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Feb 2015 05:49:38 -0500 (EST)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
 [209.85.212.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82A3545FE7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 05:49:38 -0500 (EST)
Received: by mail-wi0-f171.google.com with SMTP id hi2so47083396wib.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 02:55:06 -0800 (PST)
In-Reply-To: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lersek@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Mangle the memory attribute register values at each write to MAIR_EL1
so that regions that the guest intends to map as device or uncached are
in fact mapped as cached instead. This avoids incoherency issues when
the guest bypassed the caches to access memory that the host has mapped
as cached.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1e170eab6603..bde2b49a7cd8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -110,6 +110,39 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_mair(struct kvm_vcpu *vcpu,
+			const struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	unsigned long val, mask;
+
+	BUG_ON(!p->is_write);
+
+	val = *vcpu_reg(vcpu, p->Rt);
+
+	if (!p->is_aarch32) {
+		/*
+		 * Mangle val so that all device and uncached attributes are
+		 * replaced with cached attributes.
+		 * For each attribute, check whether any of bit 7, bit 5 or bit
+		 * 4 are set. If not, it is a device or outer non-cacheable
+		 * mapping and we override it with inner, outer write-through,
+		 * read+write-allocate (0xbb).
+		 * TODO: handle outer cacheable inner non-cacheable
+		 */
+		mask = ~(val >> 7 | val >> 5 | val >> 4) & 0x0101010101010101UL;
+		val = (val & ~(mask * 0xff)) | (mask * 0xbb);
+
+		vcpu_sys_reg(vcpu, r->reg) = val;
+	} else {
+		if (!p->is_32bit)
+			vcpu_cp15_64_high(vcpu, r->reg) = val >> 32;
+		vcpu_cp15_64_low(vcpu, r->reg) = val & 0xffffffffUL;
+	}
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			const struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -371,7 +404,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* MAIR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0010), Op2(0b000),
-	  access_vm_reg, reset_unknown, MAIR_EL1 },
+	  access_mair, reset_unknown, MAIR_EL1 },
 	/* AMAIR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0011), Op2(0b000),
 	  access_handled_at_el2, reset_amair_el1, AMAIR_EL1 },
-- 
1.8.3.2
