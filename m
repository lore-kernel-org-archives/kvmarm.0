Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEA139D6EC
	for <kvmarm@lists.linux.dev>; Sun, 10 May 2026 14:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424864; cv=none; b=TlU/6YDE6jG45ZeAZ70981mOsUhF+WGN4RuaO5SfmbdIjij017TUxpI9tNQaKyzD1gETCHh71RaX+jHJbIFR2Orxk1pi/bG2eV0U8eYX5TVxwjLnx9mOc3pL+syd3gLr8G7lNpMUTSIZXy1FK4amALr3ryrJwZ0V/5PRg4fiLww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424864; c=relaxed/simple;
	bh=lwnpRiOgHSXv6Wdc+Q1IaXvZ4XNXi6T0Q1XkzBl0AqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkS5xt1JZ1qAg50TOLB3qsV/iFmfX5tmQwqBShNe+YUHHVR3CLw3wT5rCDgyD3TDO7UfmgNrnZY+Fmffp+B2KYTPoZwA23N5nuK6baZfqUyv/EnPSMN7orWJY5hUgh1G4X9lQ6eg/c/UUiMbZG1TAggJ6dbIRaGcqLSkrib7qKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=n+eSL8vZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="n+eSL8vZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CE5627B5;
	Sun, 10 May 2026 07:54:11 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74EA23F836;
	Sun, 10 May 2026 07:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778424856; bh=lwnpRiOgHSXv6Wdc+Q1IaXvZ4XNXi6T0Q1XkzBl0AqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+eSL8vZC3Yo8PcRWxnD55+5D0P+TgPrOL/fco4Em4zvoDbZin1x1JPbfJHL4/BuY
	 NYhbP8b1fhny6BbLMVVcMzYnJp1kuzrB5Bmu/8Pj6o5C0s7jx5JvA01oGaerU5zO25
	 sGMj7p7jy9Rt6cESpP6/92tuylxEIv+NKa7jxYXA=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 1/5] KVM: arm64: Use a variable for the canonical GPA in kvm_s2_fault_map()
Date: Sun, 10 May 2026 15:53:34 +0100
Message-ID: <20260510145338.322962-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260510145338.322962-1-weilin.chang@arm.com>
References: <20260510145338.322962-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a variable to store the canonical GPA, instead of calculating it
when needed. This will be useful when we need to use the canonical GPA
for the nested reverse map later.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d089c107d9b7..e4becd5cdf36 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1981,6 +1981,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	long mapping_size;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
+	phys_addr_t canonical_gpa;
 	int ret;
 
 	kvm_fault_lock(kvm);
@@ -1994,6 +1995,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	mapping_size = s2vi->vma_pagesize;
 	pfn = s2vi->pfn;
 	gfn = s2vi->gfn;
+	canonical_gpa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
 
 	/*
 	 * If we are not forced to use page mapping, check if we are
@@ -2012,6 +2014,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 				goto out_unlock;
 			}
 		}
+		canonical_gpa = ALIGN_DOWN(canonical_gpa, mapping_size);
 	}
 
 	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
@@ -2045,11 +2048,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	 * making sure we adjust the canonical IPA if the mapping size has
 	 * been updated (via a THP upgrade, for example).
 	 */
-	if (writable && !ret) {
-		phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
-		ipa &= ~(mapping_size - 1);
-		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
-	}
+	if (writable && !ret)
+		mark_page_dirty_in_slot(kvm, s2fd->memslot,
+					gpa_to_gfn(canonical_gpa));
 
 	if (ret != -EAGAIN)
 		return ret;
-- 
2.43.0

