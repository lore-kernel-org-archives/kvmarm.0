Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7280AC3DA7A
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 20:09:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2026B4B2A3;
	Tue, 20 Dec 2022 15:09:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dAnytqMl4FQo; Tue, 20 Dec 2022 15:09:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E51E4B634;
	Tue, 20 Dec 2022 15:09:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1CCA4B5E8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 15:09:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nmxDRupgoEdP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Dec 2022 15:09:32 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7AAF4B59D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 15:09:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 244666156F;
 Tue, 20 Dec 2022 20:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C026C433EF;
 Tue, 20 Dec 2022 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671566971;
 bh=ttZ6e5p6ormRoOUb3KNmacnIPErZGsezf9pYZ4H2bkY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hJAwdY9F1XD0MJyw2UIzvqlfmtJ88j3RmQuM/E56LTVkngx0Tdbe3lyOU8nkkRiq9
 VAGP3ViLfWwnMLZYq9XXPsnmpLpflXVCxPNz78bkyKpquXBgxSQWxCZzqbS6YnrVSe
 HVsgx94HVgPdroRvgwz/tAolACt/BL4LwN4Lj8Nkg4X2amAc8zrDlf+hQUTTt4OeoE
 OsvVNmo8UXwqex3DK53xYO4WDD2yZ/8Fv5bafuX1fiD2xsLtsRYo3y/FTCzz36dNTN
 56mZMTjBu/QYjdHjGV+EF5W/fco8SATQzRBF+PvqzrfRJVLYEXuWkUnenQqUT9+wSW
 DFYeKw4cc9LLw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1p7ivZ-00Dzct-Po;
 Tue, 20 Dec 2022 20:09:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] KVM: arm64: Handle S1PTW translation with TCR_HA set as a
 write
Date: Tue, 20 Dec 2022 20:09:22 +0000
Message-Id: <20221220200923.1532710-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220200923.1532710-1-maz@kernel.org>
References: <20221220200923.1532710-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 ardb@kernel.org, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

As a minor optimisation, we can retrofit the "S1PTW is a write
even on translation fault" concept *if* the vcpu is using the
HW-managed Access Flag, as setting TCR_EL1.HA is guaranteed
to result in an update of the PTE.

However, we cannot do the same thing for DB, as it would require
us to parse the PTs to find out if the DBM bit is set there.
This is not going to happen.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fd6ad8b21f85..4ee467065042 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -374,6 +374,9 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		unsigned int afdb;
+		u64 mmfr1;
+
 		/*
 		 * Only a permission fault on a S1PTW should be
 		 * considered as a write. Otherwise, page tables baked
@@ -385,12 +388,27 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 		 * to map the page containing the PT (read only at
 		 * first), then a permission fault to allow the flags
 		 * to be set.
+		 *
+		 * We can improve things if the guest uses AF, as this
+		 * is guaranteed to result in a write to the PTE. For
+		 * DB, however, we'd need to parse the guest's PTs,
+		 * and that's not on. DB is crap anyway.
 		 */
 		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
 		case ESR_ELx_FSC_PERM:
 			return true;
 		default:
-			return false;
+			/* Can't introspect TCR_EL1 with pKVM */
+			if (kvm_vm_is_protected(vcpu->kvm))
+				return false;
+
+			mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+			afdb = cpuid_feature_extract_unsigned_field(mmfr1, ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
+
+			if (afdb == ID_AA64MMFR1_EL1_HAFDBS_NI)
+				return false;
+
+			return (vcpu_read_sys_reg(vcpu, TCR_EL1) & TCR_HA);
 		}
 	}
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
