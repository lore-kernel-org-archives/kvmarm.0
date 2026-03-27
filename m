Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DAA37BE88;
	Fri, 27 Mar 2026 11:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611385; cv=none; b=l3A8IfspXEC8XDUqneJunrX/skPgeFA7j28kPW/PXJVBtYqTjYr8y6uzoi8zYOwNezdOgclNmYDS5TujtNUpU7sEgmcU7Qn7HFHLn2vhgQuTKkCj6TTFAt/9fGB9b/sAUvRDT2JGrcfOnYJBap8ndNzb6kboZiza36B1lBR9YUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611385; c=relaxed/simple;
	bh=bC61XAT5f24Q6uazjH9bN98/WFRDLM2026JAuAM3igY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXAMoT50PyqBGAzXW3C1K2X465e2YuZqzEHgvb/pPjCGPh4A7eJ5maS1FBjp3FYwk3XkgqJNH4Z2dSlRxZwqSAwLaPCgZfzxnMoHzW3PSunN9FpAeMFxDDKKm+hJPmHaBnWx5RWyqQSZ825SfeRq2xgcNcZ294nJsr2aYRRRofk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtDpr2sG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtDpr2sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0F8C4AF09;
	Fri, 27 Mar 2026 11:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611385;
	bh=bC61XAT5f24Q6uazjH9bN98/WFRDLM2026JAuAM3igY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtDpr2sGrjnJwuQv/ncDHqG/JmX6w6XhZD+NyTZZwPBBvNTmewkgYupcdvZWqWeeY
	 ZqnJSPFwaG+m7h+K1k+MUIsLvaigAozHSbXSZBqOV7WpZA/zGVmkNmwrcwmcv0f1JU
	 vwZkhvBg5QfA8UGnhTrmlFZL5iaKH5HtfWI/wWSILK+pEqKbD+2H9ElBP71lZLd0jM
	 3bgiQEpfwpiRJlNAIGyoS8qGGc+lU9uTQbIK+G9vLzsgnwxklJfjy46xc/z5hR/y2a
	 eXkyvq0q6gCwquU1KoJ8Gx8jTAEwoM46f1d27Y7BnxjgxxY51aMIbLECT65fh9+Fv/
	 lM1woZE1fEZew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UF-00000006K4a-3GCB;
	Fri, 27 Mar 2026 11:36:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 07/30] KVM: arm64: Simplify nested VMA shift calculation
Date: Fri, 27 Mar 2026 11:35:55 +0000
Message-ID: <20260327113618.4051534-8-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Fuad Tabba <tabba@google.com>

In the kvm_s2_resolve_vma_size() helper, the local variable vma_pagesize
is calculated from vma_shift, only to be used to bound the vma_pagesize
by max_map_size and subsequently convert it back to a shift via __ffs().

Because vma_pagesize and max_map_size are both powers of two, we can
simplify the logic by omitting vma_pagesize entirely and bounding the
vma_shift directly using the shift of max_map_size. This achieves the
same result while keeping the size-to-shift conversion out of the helper
logic.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 164f1160ea33d..5572b127f8663 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1646,7 +1646,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 				     bool *force_pte, phys_addr_t *ipa)
 {
 	short vma_shift;
-	long vma_pagesize;
 
 	if (*force_pte)
 		vma_shift = PAGE_SHIFT;
@@ -1677,8 +1676,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
 	}
 
-	vma_pagesize = 1UL << vma_shift;
-
 	if (nested) {
 		unsigned long max_map_size;
 
@@ -1703,8 +1700,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 			max_map_size = PAGE_SIZE;
 
 		*force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
-		vma_shift = __ffs(vma_pagesize);
+		vma_shift = min_t(short, vma_shift, __ffs(max_map_size));
 	}
 
 	return vma_shift;
-- 
2.47.3

