Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD3F1474C5
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 18:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389968; cv=none; b=mgxx+XybML9znXhSq1W94snFLz0JwqOzGSDIiQ/aTatlJYfVx4KwAMXbYNACHwSz0EDf3wRMapT+L8QH4PnFTseNj0birVgAMb1SqanO37VXlsEs0x8DwwzIEE5W3mgp0uWsUWjxt+Pv08H98RuCxAFukKbJ8sYj2FaCiXxFh5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389968; c=relaxed/simple;
	bh=kWHXfiW/eWv847hDdyNDPfVjaGDkYdtb8A2LHmGvu2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=um0AJagkNk8861a003L7yI0wwJg5beKzbMtKl6wClP8W527XhqipP1A4QB5bLFgD85raKZ0qPV8DzkWZO37qNyBJ4zxR+0YOi8JviZmHK2d+ht+QgMAt+DybSL8VjGtgUue/VIJu5k9wQrMxtJQ116q7O0YrOjSDpzI8KlItTMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TbWo6WoK; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TbWo6WoK"
X-Envelope-To: sebott@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718389963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bfjAgyWtBbRxONbdiKFFSvpzW16ct8ELGbCI1RgaYDo=;
	b=TbWo6WoK1irRzuNAiIl8Od4+Hy08BlCQJoKsWrUFVp96WCEIXacnZGW5V8snVx167JFiyo
	LoH7xl7Os41ZevbeY/1nDDIpa04sLSc500zOFXzatRhoCrqVGfXtvXY0j9PYgxdnRgbiNT
	iQjWcGIV0uhvq4anf8OpW6dOY1sTdE4=
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
Date: Fri, 14 Jun 2024 18:32:37 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: add emulation for CTR_EL0 register
Message-ID: <ZmyMxRoKN5VhUW7J@linux.dev>
References: <20240603130507.17597-1-sebott@redhat.com>
 <20240603130507.17597-4-sebott@redhat.com>
 <ZmtwjLbP283ra0Xq@linux.dev>
 <Zmty99X4hnYwtRS4@linux.dev>
 <0b148e21-1714-f4f7-bc77-2a12b990572d@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b148e21-1714-f4f7-bc77-2a12b990572d@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 14, 2024 at 05:31:37PM +0200, Sebastian Ott wrote:

[...]

> Hm, but in that case we'd use reset_vm_ftr_id_reg() meaning we would have
> to make IDREG() work for this reg. Either by adding special handling to
> that macro or by increasing kvm->arch.id_regs[] a lot - both options don't
> sound very appealing.

Hiding some of the ugly details behind IDREG() isn't the worst thing,
IMO. The feature ID registers are not laid out contiguously in the
architecture, so it'd make sense that the corresponding KVM code not be
brittle to this.

The other benefit is we initialize kvm->arch.ctr_el0 exactly once, just
like the other ID registers. I believe there's a quirk with this patch
where an initialization that happens after a KVM_SET_ONE_REG on CTR_EL0
will clobber the userspace value.

So, here's where I'm at locally, I'll work it a bit more and try to
densely pack CTR_EL0 into the id_regs array. I also have some (untested)
changes to get CTR_EL0 to show up in the debugfs interface we now have.

Mind if I post what I have afterwards?

commit 6bf81bd50dc16309a627863948d49cfeeb00897e
Author: Sebastian Ott <sebott@redhat.com>
Date:   Mon Jun 3 15:05:03 2024 +0200

    KVM: arm64: Treat CTR_EL0 as a VM feature ID register
    
    Signed-off-by: Sebastian Ott <sebott@redhat.com>
    Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
    Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 212ae77eefaf..e5b8cdd70914 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -327,10 +327,20 @@ struct kvm_arch {
 	 */
 #define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
 #define IDX_IDREG(idx)		sys_reg(3, 0, 0, ((idx) >> 3) + 1, (idx) & Op2_mask)
-#define IDREG(kvm, id)		((kvm)->arch.id_regs[IDREG_IDX(id)])
+#define IDREG(kvm, id)								\
+(*({										\
+	u64 *__reg;								\
+	if ((id) == SYS_CTR_EL0)						\
+		__reg = &(kvm)->arch.ctr_el0;					\
+	else									\
+		__reg = &((kvm)->arch.id_regs[IDREG_IDX(id)]);			\
+	__reg;									\
+}))
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
+	u64 ctr_el0;
+
 	/* Masks for VNCR-baked sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dfabf7aec2c7..1ab2cbbc7a76 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1583,6 +1583,9 @@ static bool is_feature_id_reg(u32 encoding)
  */
 static inline bool is_vm_ftr_id_reg(u32 id)
 {
+	if (id == SYS_CTR_EL0)
+		return true;
+
 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
 		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
 		sys_reg_CRm(id) < 8);
@@ -1886,7 +1889,7 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	p->regval = IDREG(vcpu->kvm, SYS_CTR_EL0);
 	return true;
 }
 
@@ -2475,7 +2478,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
-	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
+	ID_WRITABLE(CTR_EL0, CTR_EL0_DIC_MASK |
+			     CTR_EL0_IDC_MASK |
+			     CTR_EL0_DminLine_MASK |
+			     CTR_EL0_IminLine_MASK),
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
@@ -3714,18 +3720,11 @@ FUNCTION_INVARIANT(midr_el1)
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
-static u64 get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
-{
-	((struct sys_reg_desc *)r)->val = read_sanitised_ftr_reg(SYS_CTR_EL0);
-	return ((struct sys_reg_desc *)r)->val;
-}
-
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
 	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
 	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
 	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
-	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
 };
 
 static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)

-- 
Thanks,
Oliver
