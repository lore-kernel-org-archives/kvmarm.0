Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A78D340DB8
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 09:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763545106; cv=none; b=lCPOUxrRScBzOIYk49PIW1jXAHWdm+D9vU3xB8GWSl9Kbev+Wkt3dhQe1z6NvIxAPigzeoVOUZOe0/G3StCUS19eQA0f5PuaJrv+cnRxjRBQRnwP2Vfqn8dzprjQSYHcsYvJsVImOd7OqBpTbpCNf68QCra+A1R2V1EYfGsfkpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763545106; c=relaxed/simple;
	bh=5ngg8aev3ReZ4gjImuO7ZeBSRncyY+73A4WfXcnlEtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khjS44JovZoc/QbHEcIbjGjzTiHF/hTRG/lA7We0JZXQo5BpuYc73WIhSFNa5xwkicV/SM6LJeKLHJNBO5SpGauaVYtFSvnbzR9DJS7j6MbKcNeBVpv2p0mGmsSqPog1kqNkex1iBz95GfSx0e/k6JUoDCJcXFPZfnvvYjukZw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o40Yp+pm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o40Yp+pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC27C4AF10;
	Wed, 19 Nov 2025 09:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763545105;
	bh=5ngg8aev3ReZ4gjImuO7ZeBSRncyY+73A4WfXcnlEtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o40Yp+pmKvYtPgCBpt2anCo0vM+UHwawqRmE960GixOcM0OABBhTx5478qTc5VUyh
	 t3uC72jQYY+yEOHfSA8Jyf/pfc69p4Vz3rJkTXLbjbeoZa4sFBRLLOzJWAi9UkAz14
	 AFeM2wCrgxv0TOG7MLrXExtZzqqomQGRu3ifR6T0i3ZnBGUhcUD7iPEWv6LHLlhOJk
	 vb4ekmnjBS4up4eTmxVOAU/5Rzr1FFR6CjxexESgw7dTQ0M37mtGIxZktwA9wWkBxQ
	 TLL2ZwTwx/UNdgpIN9e4fNZ2EFz+5/GtucfKcl8BOdf1lvJyWoARq3HpNI/9j2byQo
	 9GeyiVkWdYSJw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 1/2] KVM: arm64: Drop useless __GFP_HIGHMEM from kvm struct allocation
Date: Wed, 19 Nov 2025 01:38:21 -0800
Message-ID: <20251119093822.2513142-2-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251119093822.2513142-1-oupton@kernel.org>
References: <20251119093822.2513142-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A recent change on the receiving end of vmalloc() started warning about
unsupported GFP flags passed by the caller. Nathan reports that this
warning fires in kvm_arch_alloc_vm(), owing to the fact that KVM is
passing a meaningless __GFP_HIGHMEM.

Do as the warning says and fix the code.

Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/kvmarm/20251118224448.GA998046@ax162/
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..e791fa52f874 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -440,7 +440,7 @@ struct kvm *kvm_arch_alloc_vm(void)
 	if (!has_vhe())
 		return kzalloc(sz, GFP_KERNEL_ACCOUNT);
 
-	return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_HIGHMEM | __GFP_ZERO);
+	return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
-- 
2.47.3

