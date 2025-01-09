Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C650C198A32;
	Thu,  9 Jan 2025 22:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736462339; cv=none; b=uH0H1F3lAh/NkwhWsYZ1o2eHdd/J5zGn/4bh6Oip7StzfhTuQqP73Lxp0KYGuySMbs5PvxljKza0aHp/I7dW3WCmSqqXSSR6BWKx7fHVBLfKZ5+3byB3CP38J1J3iiphazqC48SfnqR+6qrct0A32g8aw63OU3iiaVIOTPPtmkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736462339; c=relaxed/simple;
	bh=u9tRbb9joTkBrv5uTYIVoS7cPhgcAnfwGtXhLaCQmdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fjXda3aHDIvLDBAr3OUtTvYwYxxAVHoxv+hJU08fXgFVDJ46xXRIo+PDypYP9CxJTdgu6G82FuKAixvGfS7vz7k898wb8fDDKmqtxI8NWpIn6VKsMU/Jj2RRpcw3rQRIk1DVa6M+McgqqSpoKy6uh6SQClDUXgwJtCjKhhsVXDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KSPRf2Ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSPRf2Ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3941EC4CED2;
	Thu,  9 Jan 2025 22:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736462339;
	bh=u9tRbb9joTkBrv5uTYIVoS7cPhgcAnfwGtXhLaCQmdQ=;
	h=From:To:Cc:Subject:Date:From;
	b=KSPRf2DsN86DG4BtdFwintfzn/Hd6oIuL3Co8GvBQBja2IgKwhHnvj9SSROXMmHkK
	 Mwk+ngmqryvXqhslWgGN4ulJO+XOERp/Bjz83qNgZ8TBhVXh4yrWQeOSIOJoG2GymG
	 b21TrnGWGlKQnH3URURfRxFjIBDftL5AwZbZYPQCgPfpQofo1MnYPLz/oIp6+xLBLl
	 qtxBmuAasWS0ZAHQJIxQUykAX7ISOM8yyLJ7lNEwb+vXc3MQdWOxu141qlC/jZ6pDu
	 AIupBZSxeOIAQkKpBugrkuTZHH3Ld0/BuFxrpGCm+EaUr/MJiucpbFcpV1mylbdIOB
	 xjk21aA+dxGTw==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Explicitly handle BRBE traps as UNDEFINED
Date: Thu,  9 Jan 2025 16:38:36 -0600
Message-ID: <20250109223836.419240-1-robh@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Rutland <mark.rutland@arm.com>

The Branch Record Buffer Extension (BRBE) adds a number of system
registers and instructions which we don't currently intend to expose to
guests. Our existing logic handles this safely, but this could be
improved with some explicit handling of BRBE.

KVM currently hides BRBE from guests: the cpufeature code's
ftr_id_aa64dfr0[] table doesn't have an entry for the BRBE field, and so
this will be zero in the sanitised value of ID_AA64DFR0 exposed to
guests via read_sanitised_id_aa64dfr0_el1().

KVM currently traps BRBE usage from guests: the default configuration of
the fine-grained trap controls HDFGRTR_EL2.{nBRBDATA,nBRBCTL,nBRBIDR}
and HFGITR_EL2.{nBRBINJ_nBRBIALL} cause these to be trapped to EL2.

Well-behaved guests shouldn't try to use the registers or instructions,
but badly-behaved guests could use these, resulting in unnecessary
warnings from KVM before it injects an UNDEF, e.g.

| kvm [197]: Unsupported guest access at: 401c98
|  { Op0( 2), Op1( 1), CRn( 9), CRm( 0), Op2( 0), func_read },
| kvm [197]: Unsupported guest access at: 401d04
|  { Op0( 2), Op1( 1), CRn( 9), CRm( 0), Op2( 1), func_read },
| kvm [197]: Unsupported guest access at: 401d70
|  { Op0( 2), Op1( 1), CRn( 9), CRm( 2), Op2( 0), func_read },
| kvm [197]: Unsupported guest access at: 401ddc
|  { Op0( 2), Op1( 1), CRn( 9), CRm( 1), Op2( 0), func_read },
| kvm [197]: Unsupported guest access at: 401e48
|  { Op0( 2), Op1( 1), CRn( 9), CRm( 1), Op2( 1), func_read },
| kvm [197]: Unsupported guest access at: 401eb4
|  { Op0( 2), Op1( 1), CRn( 9), CRm( 1), Op2( 2), func_read },
| kvm [197]: Unsupported guest access at: 401f20
|  { Op0( 2), Op1( 1), CRn( 9), CRm( 0), Op2( 2), func_read },
| kvm [197]: Unsupported guest access at: 401f8c
|  { Op0( 1), Op1( 1), CRn( 7), CRm( 2), Op2( 4), func_write },
| kvm [197]: Unsupported guest access at: 401ff8
|  { Op0( 1), Op1( 1), CRn( 7), CRm( 2), Op2( 5), func_write },

As with other features that we know how to handle, these warnings aren't
particularly interesting, and we can simply treat these as UNDEFINED
without any warning. Add the necessary fine-grained undef configuration
to make this happen, as suggested by Marc Zyngier:

  https://lore.kernel.org/linux-arm-kernel/86r0czk6wd.wl-maz@kernel.org/

At the same time, update read_sanitised_id_aa64dfr0_el1() to hide BRBE
from guests, as we do for SPE. This will prevent accidentally exposing
BRBE to guests if/when ftr_id_aa64dfr0[] gains a BRBE entry.

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
Based on discussion with Marc, I think this doesn't need to wait on BRBE
support in perf, so sending it now by itself.
---
 arch/arm64/kvm/sys_regs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 83c6b4a07ef5..bc91ddc75487 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1806,6 +1806,9 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 	/* Hide SPE from guests */
 	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
 
+	/* Hide BRBE from guests */
+	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
+
 	return val;
 }
 
@@ -4972,6 +4975,14 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
 						  HAFGRTR_EL2_RES1);
 
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP)) {
+		kvm->arch.fgu[HDFGRTR_GROUP] |= (HDFGRTR_EL2_nBRBDATA  |
+						 HDFGRTR_EL2_nBRBCTL   |
+						 HDFGRTR_EL2_nBRBIDR);
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_nBRBINJ |
+						HFGITR_EL2_nBRBIALL);
+	}
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.45.2

