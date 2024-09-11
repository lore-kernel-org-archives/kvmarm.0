Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0F51A7AD2
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065460; cv=none; b=IEU0W3saLRqR4j81TSJ1wbx9h/zBlErwXhVRDLSz+XCZscXOzGtcKTUCiqoJxV5Sd4vijwXVv9Gj8ZxpAXL0Zf6xdxh3uFHocy8FTJc3OcrtMqAT7cXOb9BtK7NiHanw8OFSuc2OdWG36Jwbx9jaiSk8xgHTvC5ZCj1h5nIgSnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065460; c=relaxed/simple;
	bh=Q/B5vpJYxuN6CqXDgq2jT5wdTrhKkZw6PP0jxEciucc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Do2NL7IBglwJ2CScoWHOP+Yo73bPeRMK5VCRrKjEtPvF9EYvFjy/lhZ7AQxH4h7esdrDROER03E9DyBuEyV78eB92p+jBSqgX6wLgWFHDkXN9soxJ6OVjece6+LX50DdwyFXmcWcjzpay9IMA213NIahQ33+bOke2YIK6OcAYpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=tmWeFfmB; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="tmWeFfmB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726065458; x=1757601458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ttqjEP9NZOH/UBgVCbYLfsAknImtx66onLISyRd5NFM=;
  b=tmWeFfmBv6rY9UiSCQMfebPMwcgFBjqEW51h5ro2W50MS5T19rJmWpMq
   LbuNxdct8JX4YGvhU9hu+mSuY0otMVerq2wc4ERt90BxBihK79y62HRa4
   +WnNs1UA0YlZZ3RR536/g1KeOa94wODlGAYJgkhTA9AkfjuRq3rzcgnmW
   s=;
X-IronPort-AV: E=Sophos;i="6.10,220,1719878400"; 
   d="scan'208";a="329956727"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 14:37:36 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:3852]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.38.136:2525] with esmtp (Farcaster)
 id ac0f2d97-7ed9-430d-a2d7-58bab541e8ef; Wed, 11 Sep 2024 14:37:35 +0000 (UTC)
X-Farcaster-Flow-ID: ac0f2d97-7ed9-430d-a2d7-58bab541e8ef
Received: from EX19D007EUB001.ant.amazon.com (10.252.51.82) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:37:33 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUB001.ant.amazon.com (10.252.51.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 11 Sep 2024 14:37:33 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (10.253.79.181)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Wed, 11 Sep 2024 14:37:30 +0000
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
Subject: [RFC PATCH 6/7] arm64: KVM: Refactor C-code to access vCPU fp-registers through macros
Date: Wed, 11 Sep 2024 14:34:05 +0000
Message-ID: <20240911143421.85612-7-faresx@amazon.de>
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

Unify how KVM accesses vCPU fp-regs by using vcpu_fp_regs(). This is a
prerequisite to move the fp-regs later to be dynamically allocated for vCPUs.

Signed-off-by: Fares Mehanna <faresx@amazon.de>
---
 arch/arm64/include/asm/kvm_host.h       | 2 ++
 arch/arm64/kvm/arm.c                    | 2 +-
 arch/arm64/kvm/fpsimd.c                 | 2 +-
 arch/arm64/kvm/guest.c                  | 6 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 4 ++--
 arch/arm64/kvm/reset.c                  | 2 +-
 7 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 23a10178d1b0..e8ed2c12479f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -968,6 +968,8 @@ static __always_inline struct user_pt_regs *ctxt_gp_regs(const struct kvm_cpu_co
 	return regs;
 }
 #define vcpu_gp_regs(v)		(ctxt_gp_regs(&(v)->arch.ctxt))
+#define ctxt_fp_regs(ctxt)	(&(ctxt).fp_regs)
+#define vcpu_fp_regs(v)		(ctxt_fp_regs(&(v)->arch.ctxt))
 
 /*
  * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 78c562a060de..7542af3f766a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2507,7 +2507,7 @@ static void finalize_init_hyp_mode(void)
 		for_each_possible_cpu(cpu) {
 			struct user_fpsimd_state *fpsimd_state;
 
-			fpsimd_state = &per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->host_ctxt.fp_regs;
+			fpsimd_state = ctxt_fp_regs(&per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->host_ctxt);
 			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->fpsimd_state =
 				kern_hyp_va(fpsimd_state);
 		}
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index c53e5b14038d..c27c96ae22e1 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -130,7 +130,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 		 * Currently we do not support SME guests so SVCR is
 		 * always 0 and we just need a variable to point to.
 		 */
-		fp_state.st = &vcpu->arch.ctxt.fp_regs;
+		fp_state.st = vcpu_fp_regs(vcpu);
 		fp_state.sve_state = vcpu->arch.sve_state;
 		fp_state.sve_vl = vcpu->arch.sve_max_vl;
 		fp_state.sme_state = NULL;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 821a2b7de388..3474874a00a7 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -170,13 +170,13 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
 		off -= KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]);
 		off /= 4;
-		return &vcpu->arch.ctxt.fp_regs.vregs[off];
+		return &vcpu_fp_regs(vcpu)->vregs[off];
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
-		return &vcpu->arch.ctxt.fp_regs.fpsr;
+		return &vcpu_fp_regs(vcpu)->fpsr;
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
-		return &vcpu->arch.ctxt.fp_regs.fpcr;
+		return &vcpu_fp_regs(vcpu)->fpcr;
 
 	default:
 		return NULL;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d2ed0938fc90..1444bad519db 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -319,7 +319,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
-			    &vcpu->arch.ctxt.fp_regs.fpsr,
+			    &vcpu_fp_regs(vcpu)->fpsr,
 			    true);
 
 	/*
@@ -401,7 +401,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);
 	else
-		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
+		__fpsimd_restore_state(vcpu_fp_regs(vcpu));
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f43d845f3c4e..feb1dd37f2a5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -32,7 +32,7 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
 	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr, true);
+	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu_fp_regs(vcpu)->fpsr, true);
 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
 }
 
@@ -71,7 +71,7 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	if (vcpu_has_sve(vcpu))
 		__hyp_sve_save_guest(vcpu);
 	else
-		__fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
+		__fpsimd_save_state(vcpu_fp_regs(vcpu));
 
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 0b0ae5ae7bc2..5f38acf5d156 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -229,7 +229,7 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
-	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
+	memset(vcpu_fp_regs(vcpu), 0, sizeof(*vcpu_fp_regs(vcpu)));
 	vcpu->arch.ctxt.spsr_abt = 0;
 	vcpu->arch.ctxt.spsr_und = 0;
 	vcpu->arch.ctxt.spsr_irq = 0;
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

