Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D784D19F11A
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 14:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065468; cv=none; b=KGo1/EX5F2RjDdzDIjx0TkzcY8QKctuzu/oagdwy3+AqPHb3H1e6k2mDg5CT/xArRFBWXeac1UaeNXo+VAhlr2cMRUlopNFwVHKfZM9QAhGoj0evTv+GfWohtegMymRV2tMEmloEU+MdT/0COZRAQAzCnusPuDculK70tquH4nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065468; c=relaxed/simple;
	bh=feRSGJHJU4EXR47b3J41bw3N15CyZRe4CKUQtrdHZqY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FHLoS5KYGe7LHaNhH0xqd74k7FUVSGT9JbRoZcbIcCOkpKipHho4NRckcTbselMapu1NMT1qTsTplB/UFpMo4uZ0nIdxtCnRuCp2OtEw7reVEfmswm1JQWQM1DV84E6aKtM6jVvolfm2MzIC1Y/hv46ogrmwtabGJDsFMRIPUBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=fP/foVYv; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="fP/foVYv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726065467; x=1757601467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rCn+xTWUjnpsWnBBnpI3iR0NNWrWMHIE+UutE4x6c8o=;
  b=fP/foVYvIedlOjkxTffZG9ffRlV5MWod3Keodu7uiEvWZFZkwI6A1tVy
   Wl41huZOdJk2H6huy5WaSPO23dIISv/Hukne75pgeGkm3mvQXR/PqDqLX
   gD5sIrdv1bBmS/Pcb3LMrB5BOEZ84FpiLE72GlV/6oJcUqEfGF5syqPJa
   c=;
X-IronPort-AV: E=Sophos;i="6.10,220,1719878400"; 
   d="scan'208";a="452953260"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 14:36:30 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:20048]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.13.80:2525] with esmtp (Farcaster)
 id 337e7469-1cf4-42a1-a92c-28b8d968fd53; Wed, 11 Sep 2024 14:36:28 +0000 (UTC)
X-Farcaster-Flow-ID: 337e7469-1cf4-42a1-a92c-28b8d968fd53
Received: from EX19D007EUB001.ant.amazon.com (10.252.51.82) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:36:22 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUB001.ant.amazon.com (10.252.51.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 11 Sep 2024 14:36:21 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (10.253.79.181)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Wed, 11 Sep 2024 14:36:19 +0000
From: Fares Mehanna <faresx@amazon.de>
To: 
CC: <nh-open-source@amazon.com>, Fares Mehanna <faresx@amazon.de>, "Marc
 Zyngier" <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, =?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=
	<ptosi@google.com>, Ard Biesheuvel <ardb@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Javier Martinez Canillas <javierm@redhat.com>, "Arnd
 Bergmann" <arnd@arndb.de>, Fuad Tabba <tabba@google.com>, Mark Brown
	<broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Kristina Martsenko
	<kristina.martsenko@arm.com>, Randy Dunlap <rdunlap@infradead.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, "Mike Rapoport (IBM)" <rppt@kernel.org>, "David
 Hildenbrand" <david@redhat.com>, Roman Kagan <rkagan@amazon.de>, "moderated
 list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
	<linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
 ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>, open list
	<linux-kernel@vger.kernel.org>, "open list:MEMORY MANAGEMENT"
	<linux-mm@kvack.org>
Subject: [RFC PATCH 3/7] arm64: KVM: Refactor C-code to access vCPU gp-registers through macros
Date: Wed, 11 Sep 2024 14:34:02 +0000
Message-ID: <20240911143421.85612-4-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240911143421.85612-1-faresx@amazon.de>
References: <20240911143421.85612-1-faresx@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Unify how KVM accesses vCPU gp-regs by using two macros vcpu_gp_regs() and
ctxt_gp_regs(). This is prerequisite to move the gp-regs later to be dynamically
allocated for vCPUs.

Signed-off-by: Fares Mehanna <faresx@amazon.de>
---
 arch/arm64/include/asm/kvm_emulate.h           |  2 +-
 arch/arm64/include/asm/kvm_host.h              |  3 ++-
 arch/arm64/kvm/guest.c                         |  8 ++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h        |  2 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h     | 10 +++++-----
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h |  2 +-
 6 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a601a9305b10..cabfb76ca514 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -170,7 +170,7 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 
 static inline bool vcpu_is_el2_ctxt(const struct kvm_cpu_context *ctxt)
 {
-	switch (ctxt->regs.pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
+	switch (ctxt_gp_regs(ctxt)->pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
 	case PSR_MODE_EL2h:
 	case PSR_MODE_EL2t:
 		return true;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..31cbd62a5d06 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -946,7 +946,8 @@ struct kvm_vcpu_arch {
 #define vcpu_clear_on_unsupported_cpu(vcpu)				\
 	vcpu_clear_flag(vcpu, ON_UNSUPPORTED_CPU)
 
-#define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
+#define ctxt_gp_regs(ctxt)	(&(ctxt)->regs)
+#define vcpu_gp_regs(v)		(ctxt_gp_regs(&(v)->arch.ctxt))
 
 /*
  * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 11098eb7eb44..821a2b7de388 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -134,16 +134,16 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
 		off -= KVM_REG_ARM_CORE_REG(regs.regs[0]);
 		off /= 2;
-		return &vcpu->arch.ctxt.regs.regs[off];
+		return &vcpu_gp_regs(vcpu)->regs[off];
 
 	case KVM_REG_ARM_CORE_REG(regs.sp):
-		return &vcpu->arch.ctxt.regs.sp;
+		return &vcpu_gp_regs(vcpu)->sp;
 
 	case KVM_REG_ARM_CORE_REG(regs.pc):
-		return &vcpu->arch.ctxt.regs.pc;
+		return &vcpu_gp_regs(vcpu)->pc;
 
 	case KVM_REG_ARM_CORE_REG(regs.pstate):
-		return &vcpu->arch.ctxt.regs.pstate;
+		return &vcpu_gp_regs(vcpu)->pstate;
 
 	case KVM_REG_ARM_CORE_REG(sp_el1):
 		return __ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 37ff87d782b6..d2ed0938fc90 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -649,7 +649,7 @@ static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu, u64 *exit_code
 	    ESR_ELx_EC(read_sysreg_el2(SYS_ESR)) == ESR_ELx_EC_PAC)
 		write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
 
-	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
+	vcpu_gp_regs(vcpu)->pstate = read_sysreg_el2(SYS_SPSR);
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 4c0fdabaf8ae..d17033766010 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -105,13 +105,13 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
+	ctxt_gp_regs(ctxt)->pc		= read_sysreg_el2(SYS_ELR);
 	/*
 	 * Guest PSTATE gets saved at guest fixup time in all
 	 * cases. We still need to handle the nVHE host side here.
 	 */
 	if (!has_vhe() && ctxt->__hyp_running_vcpu)
-		ctxt->regs.pstate	= read_sysreg_el2(SYS_SPSR);
+		ctxt_gp_regs(ctxt)->pstate = read_sysreg_el2(SYS_SPSR);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
@@ -202,7 +202,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 /* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
 static inline u64 to_hw_pstate(const struct kvm_cpu_context *ctxt)
 {
-	u64 mode = ctxt->regs.pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
+	u64 mode = ctxt_gp_regs(ctxt)->pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
 
 	switch (mode) {
 	case PSR_MODE_EL2t:
@@ -213,7 +213,7 @@ static inline u64 to_hw_pstate(const struct kvm_cpu_context *ctxt)
 		break;
 	}
 
-	return (ctxt->regs.pstate & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
+	return (ctxt_gp_regs(ctxt)->pstate & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
 }
 
 static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -235,7 +235,7 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 	if (!(mode & PSR_MODE32_BIT) && mode >= PSR_MODE_EL2t)
 		pstate = PSR_MODE_EL2h | PSR_IL_BIT;
 
-	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
+	write_sysreg_el2(ctxt_gp_regs(ctxt)->pc,	SYS_ELR);
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
index 45a84f0ade04..dfe5be0d70ef 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
@@ -11,7 +11,7 @@
 
 #include <asm/kvm_host.h>
 
-#define cpu_reg(ctxt, r)	(ctxt)->regs.regs[r]
+#define cpu_reg(ctxt, r)	(ctxt_gp_regs((ctxt))->regs[r])
 #define DECLARE_REG(type, name, ctxt, reg)	\
 				type name = (type)cpu_reg(ctxt, (reg))
 
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

