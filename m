Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB1E79C8
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 16:01:50 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DD0A1042;
	Thu, 16 Feb 2023 08:02:33 -0800 (PST)
Received: from e126864.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E66D3F881;
	Thu, 16 Feb 2023 08:01:47 -0800 (PST)
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] KVM: arm64: hide MOPS from guests
Date: Thu, 16 Feb 2023 16:00:08 +0000
Message-Id: <20230216160012.272345-7-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216160012.272345-1-kristina.martsenko@arm.com>
References: <20230216160012.272345-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As FEAT_MOPS is not supported in guests yet, hide it from the ID
registers for guests.

The MOPS instructions are UNDEFINED in guests as HCRX_EL2.MSCEn is not
set in HCRX_GUEST_FLAGS, and will take an exception to EL1 if executed.

Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0bc7df55916e..3456205c6b92 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1213,6 +1213,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 				 ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3));
 		if (!cpus_have_final_cap(ARM64_HAS_WFXT))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS);
 		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
-- 
2.25.1

