Received: from out-196.mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801091B283
	for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 22:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bbw/z89w"
Date: Tue, 24 Oct 2023 22:41:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698187321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DSryayoirNu2u8X3Ok0uKcIUthQ11l2zHIdQh/RbHzM=;
	b=bbw/z89wfls1IcK9dYOBgLVNxd+FMt4F10IRWFJPvCngTrHMBMSfaKDzPXVugaunLmRyU5
	5FlaEtakYXBhnEcmXgywprzOlS7r+eAgxg599saFUPh9IwDESSnz6Fo1tWtf15R/ro66al
	pu3nWBThftcKTHFYjqzv7yF9sXKVqyY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Miguel Luis <miguel.luis@oracle.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Eric Auger <eric.auger@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 5/5] KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as
 RAZ/WI
Message-ID: <ZThINaAfNDNrIAqI@linux.dev>
References: <20231023095444.1587322-1-maz@kernel.org>
 <20231023095444.1587322-6-maz@kernel.org>
 <7DD05DC0-164E-440F-BEB1-E5040C512008@oracle.com>
 <86jzrc3pbm.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86jzrc3pbm.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 24, 2023 at 06:25:33PM +0100, Marc Zyngier wrote:
> On Mon, 23 Oct 2023 19:55:10 +0100, Miguel Luis <miguel.luis@oracle.com> wrote:
> > Also, could you please explain what is happening at PSTATE.EL == EL1
> > and if EL2Enabled() && HCR_EL2.NV == ‘1’  ?
> 
> We directly take the trap and not forward it. This isn't exactly the
> letter of the architecture, but at the same time, treating these
> registers as RAZ/WI is the only valid implementation. I don't
> immediately see a problem with taking this shortcut.

Ugh, that's annoying. The other EL2 views of AArch32 state UNDEF if EL1
doesn't implement AArch32. It'd be nice to get a relaxation in the
architecture to allow an UNDEF here.

Broadening the scope to KVM's emulation of AArch64-only behavior, I
think we should be a bit more aggressive in sanitising AArch32 support
from the ID registers. That way any AA64-only behavior in KVM is
architectural from the guest POV.

Maybe something like:

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 57c8190d5438..045f41900433 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1447,6 +1447,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			\
+({									\
+	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		\
+	(val) &= ~reg##_##field##_MASK;					\
+	(val) |= FIELD_PREP(reg##_##field##_MASK,			\
+			min(__f_val, (u64)reg##_##field##_##limit));	\
+	(val);								\
+})
+
+
 static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
@@ -1477,19 +1487,38 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 	}
 
+	/*
+	 * Hide AArch32 support if the vCPU wasn't configured for it. The
+	 * architecture requires all higher ELs to be AArch64-only in this
+	 * situation as well.
+	 */
+	if (!vcpu_el1_is_32bit(vcpu)) {
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64PFR0_EL1, EL1, IMP);
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64PFR0_EL1, EL2, IMP);
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64PFR0_EL1, EL3, IMP);
+	}
+
 	val &= ~ID_AA64PFR0_EL1_AMU_MASK;
 
 	return val;
 }
 
-#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
-({									       \
-	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
-	(val) &= ~reg##_##field##_MASK;					       \
-	(val) |= FIELD_PREP(reg##_##field##_MASK,			       \
-			min(__f_val, (u64)reg##_##field##_##limit));	       \
-	(val);								       \
-})
+static u64 set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       u64 val)
+{
+	/*
+	 * Older versions of KVM freely reported AArch32 support, even if the
+	 * vCPU was configured for AArch64.
+	 */
+	if (!vcpu_el1_is_32bit(vcpu)) {
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64PFR0_EL1, EL1, IMP);
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64PFR0_EL1, EL2, IMP);
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64PFR0_EL1, EL3, IMP);
+	}
+
+	return set_id_reg(vcpu, rd, val);
+}
 
 static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
@@ -2055,7 +2084,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
 	  .access = access_id_reg,
 	  .get_user = get_id_reg,
-	  .set_user = set_id_reg,
+	  .set_user = set_id_aa64pfr0_el1,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
 	  .val = ~(ID_AA64PFR0_EL1_AMU |
 		   ID_AA64PFR0_EL1_MPAM |

-- 
Thanks,
Oliver
