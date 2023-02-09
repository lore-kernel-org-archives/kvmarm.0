Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D93FA925
	for <kvmarm@lists.linux.dev>; Thu,  9 Feb 2023 17:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EDBC433A0;
	Thu,  9 Feb 2023 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675965528;
	bh=a4UTVb8UOXSxNKd8O8XlH8cthygH6vXj5ampEKLLkJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4+3jXGEvfatcuRYDY8UKABnGlUdFMLHVyd+/NaMv5xPa3lCwywRWNsKtOKWIp5MD
	 nEDLtI8cI/mAN5cr50+po6YrsS3KH+1s1Foe6dVWfXa95QSZXxfOo6BHciOF54p5TE
	 4UKCQzGN0fBMOubGa9Cx7SMq9s5zlD1JjFOsmtsuNUzJAgVrID8vMCYvQigy+xPj9H
	 amqkrr7DzwhGtFE5qPvVbaUwIxLw0o4fTjcRf5pApObS711vwhgDeFKIN9aCSCm3qz
	 2tpEri/5fx+BYcxBCnA+KoWFqDFiw6XvihSp+G9/FA5V9f6/zBKaZ++XfF93MjNutx
	 hcGR+Y8SxdGDw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pQBC2-0093r7-Sr;
	Thu, 09 Feb 2023 17:58:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 05/18] KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
Date: Thu,  9 Feb 2023 17:58:07 +0000
Message-Id: <20230209175820.1939006-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Christoffer Dall <christoffer.dall@linaro.org>

We were not allowing userspace to set a more privileged mode for the VCPU
than EL1, but we should allow this when nested virtualization is enabled
for the VCPU.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5626ddb540ce..63643c98e6c3 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -24,6 +24,7 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
 #include <asm/sigcontext.h>
 
 #include "trace.h"
@@ -253,6 +254,11 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			if (!vcpu_el1_is_32bit(vcpu))
 				return -EINVAL;
 			break;
+		case PSR_MODE_EL2h:
+		case PSR_MODE_EL2t:
+			if (!vcpu_has_nv(vcpu))
+				return -EINVAL;
+			fallthrough;
 		case PSR_MODE_EL0t:
 		case PSR_MODE_EL1t:
 		case PSR_MODE_EL1h:
-- 
2.34.1

