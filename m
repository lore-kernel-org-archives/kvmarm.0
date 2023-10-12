Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC8B266DC
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 12:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97B2B152B;
	Thu, 12 Oct 2023 05:35:51 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14DB23F5A1;
	Thu, 12 Oct 2023 05:35:09 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	kvmarm@lists.linux.dev
Subject: [PATCH v1 2/2] KVM: arm64: POR{E0}_EL1 do not need trap handlers
Date: Thu, 12 Oct 2023 13:34:59 +0100
Message-Id: <20231012123459.2820835-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231012123459.2820835-1-joey.gouly@arm.com>
References: <20231012123459.2820835-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These will not be trapped by KVM, so don't need a handler.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d449..0afd6136e275 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2122,8 +2122,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
-	{ SYS_DESC(SYS_PIRE0_EL1), access_vm_reg, reset_unknown, PIRE0_EL1 },
-	{ SYS_DESC(SYS_PIR_EL1), access_vm_reg, reset_unknown, PIR_EL1 },
+	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1 },
+	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1 },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
 
 	{ SYS_DESC(SYS_LORSA_EL1), trap_loregion },
-- 
2.25.1

