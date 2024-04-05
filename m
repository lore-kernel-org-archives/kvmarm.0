Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1ECA144D0E
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 08:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712304046; cv=none; b=bwvNGSfXoOl7Sva3AXBZ2HywVxf5MyWKWVwe/1OWTR8IHJ+ael64v7JRF+BT7tFVHWibLHoFoKr9JWHSovwJ4xHZVsDf7lfu/W8SIR7nQGdS6GkhucqzPfDABtsyHmyb7JSr1vjl0BSXWiQvZT/30SdSBWxPmuXez+JmXBrc9yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712304046; c=relaxed/simple;
	bh=oZuhb1s6XFcdK4qhiPqywi4shXCxzFqbwESan+8EU2U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g/MO1v2ame2ab0NAvvQldX86MqcHYuDJlCOjOLWRXPAr/zhyLUT10bBADnnp8OoV/KMz3plOSa4rGS534Eom1x0N0AQbSCWvjfI7Er/QEugVs+SfMeq8NflDBMgQzlHRwVUc+DgUGJDhip5Qp9Z3mk5Hwt1VOCYz0O7PW+IcWmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E87611007;
	Fri,  5 Apr 2024 01:01:13 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.41.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 076453F64C;
	Fri,  5 Apr 2024 01:00:38 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 5/8] KVM: arm64: Explicitly handle MDSELR_EL1 traps as UNDEFINED
Date: Fri,  5 Apr 2024 13:30:05 +0530
Message-Id: <20240405080008.1225223-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240405080008.1225223-1-anshuman.khandual@arm.com>
References: <20240405080008.1225223-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently read_sanitised_id_aa64dfr0_el1() caps the ID_AA64DFR0.DebugVer to
ID_AA64DFR0_DebugVer_V8P8, resulting in FEAT_Debugv8p9 not being exposed to
the guest. MDSELR_EL1 register access in the guest, is currently trapped by
the existing configuration of the fine-grained traps.

As the register is not described in sys_reg_descs[] table emulate_sys_reg()
will warn that this is unknown access before injecting an UNDEFINED
exception into the guest. Any well-behaved guests shouldn't try to use this
register, but any badly-behaved guests could, thus resulting in unnecessary
warnings. To avoid such warnings, access to MDSELR_EL1 should be explicitly
handled as UNDEFINED via updating sys_reg_desc[] as required.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9f4f387155f..2956bdcd358e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2203,6 +2203,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_MDSCR_EL1), trap_debug_regs, reset_val, MDSCR_EL1, 0 },
 	DBG_BCR_BVR_WCR_WVR_EL1(2),
 	DBG_BCR_BVR_WCR_WVR_EL1(3),
+	{ SYS_DESC(SYS_MDSELR_EL1), undef_access },
 	DBG_BCR_BVR_WCR_WVR_EL1(4),
 	DBG_BCR_BVR_WCR_WVR_EL1(5),
 	DBG_BCR_BVR_WCR_WVR_EL1(6),
-- 
2.25.1

