Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228851A710
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2mTBcl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7B5C433C7;
	Mon, 27 Nov 2023 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701085566;
	bh=+V9YPjvEYXSSt60U3gViHm0Gqh4URgGIV2rxi/DYKhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2mTBcl1gv6m7LRzMsDkctB4ruZqxQxLcoB79jOVaRkl+4xcpfF9SlFbLg+AGSkp/
	 ioi+deqtQ74MtlTffgf1Dl6+RNsZwohHF/hLBaGa6wDJnl8KnYqZK5U4UoeKa5GRWZ
	 uWIJLtriT6t0zpmd6vfK8rRjBZykUhc/J3yh6FqD2wJzr5fNGFeSNRRi5aaVyxRQi2
	 gL8WunrOAbUjH7hP0wAwrNfp8F0jZNToiAuuoGlMSRZ5pV0TaiPOGXhXuS9IjDhpaf
	 PN469MkRTbNqZAhsPiQmdGNFd15iXHCKF1hjy9+QcSvu8B2azn3ISBmSg2xDtyGGqK
	 6c9EZGxSehR4Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7a3w-00GleL-Ij;
	Mon, 27 Nov 2023 11:46:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 03/13] arm64: cpufeature: Correctly display signed override values
Date: Mon, 27 Nov 2023 11:45:49 +0000
Message-Id: <20231127114559.990314-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231127114559.990314-1-maz@kernel.org>
References: <20231127114559.990314-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When a field gets overriden, the kernel indicates the result of
the override in dmesg. This works well with unsigned fields, but
results in a pretty ugly output when the field is signed.

Truncate the field to its width before displaying it.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index bc8787f28ffd..9c3ded9635dd 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -949,7 +949,8 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
 				pr_warn("%s[%d:%d]: %s to %llx\n",
 					reg->name,
 					ftrp->shift + ftrp->width - 1,
-					ftrp->shift, str, tmp);
+					ftrp->shift, str,
+					tmp & (BIT(ftrp->width) - 1));
 		} else if ((ftr_mask & reg->override->val) == ftr_mask) {
 			reg->override->val &= ~ftr_mask;
 			pr_warn("%s[%d:%d]: impossible override, ignored\n",
-- 
2.39.2

