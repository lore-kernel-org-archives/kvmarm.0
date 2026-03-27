Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCA638551D;
	Fri, 27 Mar 2026 11:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611387; cv=none; b=X+u9lQXeI004S7xtb1ZmMKFn70hg1eSL0zrpJdJhVgzZm2kKEtmoNzFQ58kwMQTPD2MiriWtuyb00tAYFJyKlLMdmGXotwBotzHMuBKIQE3G8bF1tojBy0nAE/ZYMi+o8xiigXj1Ze8GiM8/p6VJk8o1LCxzMXU2p0Vf2N68yvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611387; c=relaxed/simple;
	bh=hIUGlkLWi3fTRHlufn3OSpHkefKXTw36L7/Tz0DM4Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=On5XKZUn51FDyFMIuUvtNCf4EzA3h8ot4bPrNym4fVLrwz3Aucv1dUoeV2S3pCU6ssR5p67+JVZu3mq5BF0iO4Zmi92qPd58EvA+h2pwowXJtWinqg8ZHfT7MJarhSi0j8vyTtAoann1LsA2xWel2Ae5hR2vdaScP2eSOkkkEz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UvhS8tj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UvhS8tj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DC6C2BC86;
	Fri, 27 Mar 2026 11:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611387;
	bh=hIUGlkLWi3fTRHlufn3OSpHkefKXTw36L7/Tz0DM4Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvhS8tj+y2RSuda17MFIegPJ/WFcNh+csVDJDbM15qzwMhd2EA9w0t3a593sxw+kb
	 4bYpr1uYSKlNxsXBKQvtf6z6YMdXtM4WiwUG23SinTcqVVTpby/EnqmZIbcKRk64Zq
	 6XplYiJ4hGtcJNMgaESmkEROzmO1Sw/ZtKlNzypcfy1b3MabJhiMHkCscbezxMFN65
	 aUUT0+LA/k1Lhk9wNCp3sW6u5q/ONgFtuqxwnoBh6xbOvnGNenq/JKWiJRNGF7vGRF
	 6gt3EtzuWDY5D8QT3AJkSbChRB/dPn8ceimab9xwcE8/FB0JUqiiByyK0D1pQfS5OY
	 lau+C3SQb9IRw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UH-00000006K4a-11HL;
	Fri, 27 Mar 2026 11:36:25 +0000
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
Subject: [PATCH v2 13/30] KVM: arm64: Clean up control flow in kvm_s2_fault_map()
Date: Fri, 27 Mar 2026 11:36:01 +0000
Message-ID: <20260327113618.4051534-14-maz@kernel.org>
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

Clean up the KVM MMU lock retry loop by pre-assigning the error code.
Add clear braces to the THP adjustment integration for readability, and
safely unnest the transparent hugepage logic branches.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ee2a548999b1b..c6cd6ce5254be 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1897,10 +1897,9 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 
 	kvm_fault_lock(kvm);
 	pgt = fault->vcpu->arch.hw_mmu->pgt;
-	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
-		ret = -EAGAIN;
+	ret = -EAGAIN;
+	if (mmu_invalidate_retry(kvm, fault->mmu_seq))
 		goto out_unlock;
-	}
 
 	/*
 	 * If we are not forced to use page mapping, check if we are
@@ -1908,16 +1907,17 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 	 */
 	if (fault->vma_pagesize == PAGE_SIZE &&
 	    !(fault->force_pte || fault->s2_force_noncacheable)) {
-		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE)
+		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE) {
 			fault->vma_pagesize = fault->fault_granule;
-		else
+		} else {
 			fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
 									  fault->hva, &fault->pfn,
 									  &fault->fault_ipa);
 
-		if (fault->vma_pagesize < 0) {
-			ret = fault->vma_pagesize;
-			goto out_unlock;
+			if (fault->vma_pagesize < 0) {
+				ret = fault->vma_pagesize;
+				goto out_unlock;
+			}
 		}
 	}
 
@@ -1951,7 +1951,9 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 	if (fault->writable && !ret)
 		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
 
-	return ret != -EAGAIN ? ret : 0;
+	if (ret != -EAGAIN)
+		return ret;
+	return 0;
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-- 
2.47.3

