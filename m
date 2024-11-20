Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F6654728
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 11:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732101350; cv=none; b=XfDD9j0iXvzdrjF8x38MGnJLpuq7WMipNH6o7oWeJ99Unk2CVNmlOGOZ4wu0zgxLDwcYen1HWiheWZmo+SQOuzHU8G/3SV/wWUfZBRmpPWGC4/UjMkUABuRW1pGmPkkgQATqW4WDgFpR+3APoRc7g4jHOnZA9kpEVM9C1A/Y8HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732101350; c=relaxed/simple;
	bh=y91D5lNm6Hn+KYnuzFx7xHJP7wTqgmllPYaNjCLOtWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TCfYCqckaK62poF14BvUMZBksDvaWkZxRe0ubXaJ1E0Wrnq2lhWY9HT7wZDtS1H3sZk1aY2RiQX2fkl2X1vheBwUs89vKtxl89jUd5b0Nom/+iQRnJz1NiDyLIBc/mCzbHm50/SJUMi0D1Vk2kTwQ9/YngE+ZFIjGt2WOdLSv2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pdgnMg/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pdgnMg/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECD2C4CECD;
	Wed, 20 Nov 2024 11:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732101350;
	bh=y91D5lNm6Hn+KYnuzFx7xHJP7wTqgmllPYaNjCLOtWQ=;
	h=From:To:Cc:Subject:Date:From;
	b=pdgnMg/rm5GOHulqQkgg7EWKGzUG0G3SImGxkHV7Z7p1+LasS9rmM+rDBXrw4vIYC
	 5V41yRvcjk7k0rGDdaEDnmUc0lGmBcqNuPRNHWZ82WToo2+E9RxxOa6Y+OHuJzyunH
	 pgJaLgEkb14OWxndLR8OXc8UhQkqXjVQXtmCRwo3e5Q7i+DsVWRge2BmMnmtO4sl/r
	 HdamNxnYfVm7BeFyQbd/aLOqcMTs8TR3ALz4DS/BJEBZDoRVBsRiQoq80nZ0h9pn9u
	 NEs6L6oO1asFsmSg83E+wevVT6fF7HHnXb9wueb15L94Oj9xzKzrkUskwpinn/f1P2
	 71wUqcuCPQfRg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tDigW-00ES7R-2F;
	Wed, 20 Nov 2024 11:15:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: arm64: Mark set_sysreg_masks() as inline to avoid build failure
Date: Wed, 20 Nov 2024 11:15:16 +0000
Message-Id: <20241120111516.304250-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, lkp@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When compiling with CONFIG_CC_OPTIMIZE_FOR_SIZE=y, set_sysreg_masks()
fails to compile thanks to:

	BUILD_BUG_ON(!__builtin_constant_p(sr));

as the compiler doesn't identify sr as a constant, despite all the
callers passing constants.

Fix the issue by always inlining this function, which allows GCC to
do the right thing.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411201857.ZNudtGJl-lkp@intel.com/
Fixes: a0162020095e2 ("KVM: arm64: Extend masking facility to arbitrary registers")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index aeaa6017ffd89..9b36218b48def 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -951,7 +951,7 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
 	return v;
 }
 
-static void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
+static __always_inline void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
 {
 	int i = sr - __SANITISED_REG_START__;
 
-- 
2.39.2

