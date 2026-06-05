Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3621C84A6
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780673641; cv=none; b=HZiNLW4x+l+0PGMFz0vsUAQiIfH63B33Kh9eMmFpzR3JmSU8AnoIaia23xUilVue2TxS5xrd6B1HVrUN2xHNYi2E459KghA42gAWIa3XDINDTNcDRJgAhQIMrfxMo3mK3jB3kbOafViS15MbsMuGNWe6BZeuN9pBiCOLUffIzK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780673641; c=relaxed/simple;
	bh=441m7hF9vzIcO70ErwNiZK/0ZfRAnsJvOJUj0/9Y5c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMKRZQWqga/CX33gDUl/GkSnczHSut3IOPU3gGKIt5PsXTIfPpHk6/lOvnMP1aRmnClg0dHNxNmAcOet4QZp2voJOtuYV+ymLY4/BVCjLdWZOg4YdHI+YF9mt3gc68wN5pOCmhcs/6wZnNgEVRNHF22oGH3o4T+0LjAW46ZgyCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SdkdPb6R; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SdkdPb6R"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3CFD3514;
	Fri,  5 Jun 2026 08:33:50 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A2CB3F86F;
	Fri,  5 Jun 2026 08:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780673635; bh=441m7hF9vzIcO70ErwNiZK/0ZfRAnsJvOJUj0/9Y5c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdkdPb6RA0soTPSbhVCDtw0M7wsIDbW68oFLhCdvfymY4tq2RUHgMmXzfchljredi
	 U+V9IpQSmHMZw43LPWIzi+gcJy246YXXp9WBV8o8rWSxyktpvaITufjpy+06IepF8J
	 Fvz2iUmQFo2qsYmgCxEyjAP9lXcnhSDQgKa5Xwes=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 2/2] KVM: arm64: Remove superfluous aligning of gfn for dirty logging
Date: Fri,  5 Jun 2026 16:32:48 +0100
Message-ID: <20260605153248.2412064-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260605153248.2412064-1-weilin.chang@arm.com>
References: <20260605153248.2412064-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stage-2 mapping size is forced to PAGE_SIZE when dirty logging is
enabled for a memslot, therefore we don't need to align it down to
a possibly larger vma size or THP adjusted size, they won't happen.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/mmu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 06c46124d3e7..d1f6ff7c2943 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2050,13 +2050,12 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 
 	/*
 	 * Mark the page dirty only if the fault is handled successfully,
-	 * making sure we adjust the canonical IPA if the mapping size has
-	 * been updated (via a THP upgrade, for example).
+	 * mapping size is forced to PAGE_SIZE if dirty logging is enabled,
+	 * so we don't have to adjust the canonical IPA here.
 	 */
 	if (writable && !ret) {
-		phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
-		ipa &= ~(mapping_size - 1);
-		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
+		gfn_t canonical_gfn = get_canonical_gfn(s2fd, s2vi);
+		mark_page_dirty_in_slot(kvm, s2fd->memslot, canonical_gfn);
 	}
 
 	if (ret != -EAGAIN)
-- 
2.43.0

