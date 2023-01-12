Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2201E79C9
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 15:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22A2C433EF;
	Thu, 12 Jan 2023 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673538490;
	bh=7ebo3KzxZI0/qmMWsRQv0UfHFLo4kAwrO3Vqt2URflU=;
	h=From:To:Cc:Subject:Date:From;
	b=lqiIu34w1EjZwwvyNmZMVmBVGHMvn/0zCDonOlxYqWEU8n1AHWNCuYuauP+Tc0MsU
	 9y47b9vz/E+6raZSvLUZOQeKzbiCiHHe4Hs/U0UGXv+eZaJegXvLuIpCTcMgKmTLVz
	 PidL7Dd+ejlmYxLs0x4LSEmOQwCpj/FQCTvv2r1WmvUJzG0A1ZlsChEayZHrwqpJXb
	 A5PxzLpJ8wYmX0X4KyuPsXKijlwDlCcITUcG8Ky6MtfDKxCB2uZNcDa6+MF6Ui8exu
	 z3TGyz3o7J8BPv4W1X2oBeV6hYV+IIbPLWLYhMC18KhzpKzHLxsoLP35vSOf3I/ckA
	 Miup+mT7qI+/g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pFzoG-001EcL-MZ;
	Thu, 12 Jan 2023 15:48:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Kill CPACR_EL1_TTA definition
Date: Thu, 12 Jan 2023 15:48:03 +0000
Message-Id: <20230112154803.1808559-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since the One True Way is to use the new generated definition,
kill the KVM-specific definition of CPACR_EL1_TTA, and move
over to CPACR_ELx_TTA, hopefully for the same result.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 1 -
 arch/arm64/kvm/hyp/vhe/switch.c  | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 26b0c97df986..8a6b5ca2cfc6 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -346,7 +346,6 @@
 	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
 	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
 
-#define CPACR_EL1_TTA		(1 << 28)
 #define CPACR_EL1_DEFAULT	(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |\
 				 CPACR_EL1_ZEN_EL1EN)
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1a97391fedd2..81bf236d9c27 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -40,7 +40,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	___activate_traps(vcpu);
 
 	val = read_sysreg(cpacr_el1);
-	val |= CPACR_EL1_TTA;
+	val |= CPACR_ELx_TTA;
 	val &= ~(CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN |
 		 CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN);
 
-- 
2.34.1

