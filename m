Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F994AE13B
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487008; cv=none; b=KrFxdUNzzgsAQt28c1tlY44p5X8mbmg0AYsZufctS96X+ORPfhMdMSTzppDCVhg17IZtjxRHESGdzZ2RbJi59eF8XpDaR5P6hTo4TEapVpjLbzWtJdjhWW6i05kGWNW9hvEDwFA5vgIt3f8llAObfa5LZ5YYoSdUEKXaVfeEM2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487008; c=relaxed/simple;
	bh=bZH0Iynr6p+MO32RA+61Q08tGhF1f84xWPwOzk0oSQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oH7Q6lYzrIsG6/a301cjS6+0xG34+6tgE7kcgjQDnejkmPKL1r92UBExIQyE4s/zGJTsFJDyWRYOkl+ZtFoRwOusNlzFVvpaiEjT8gjio+KMsEqsnxUvb4ls/Wn8fv03BG0miKGpayC/1tE97Wz5QwjO7GlHk46ezM65W3niHuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a9zfF35p; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a9zfF35p"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0754F15A1;
	Tue, 15 Sep 2026 08:43:22 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0DE353F882;
	Tue, 15 Sep 2026 08:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789487005; bh=bZH0Iynr6p+MO32RA+61Q08tGhF1f84xWPwOzk0oSQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9zfF35ptiQKPV6uAEtV4LGz/dwzssa8UXO1LXm+fFsAt50zgS1WS0p9R9WtTP0mv
	 ILZKF6wXaHJ4ubXDjbEBeJ2jpQbWYpqbllmxP7vXTiGTrU7rzgOAUfAlOXmt/UDVyS
	 enKUPDKPdh86GkKeqeortrsS7pg0S6hVelAx8/yA=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v6 1/7] KVM: arm64: Use a variable for the canonical IPA in kvm_s2_fault_map()
Date: Tue, 15 Sep 2026 16:42:59 +0100
Message-ID: <20260915154305.3852871-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915154305.3852871-1-weilin.chang@arm.com>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a variable to store the canonical IPA, instead of calculating it
when needed. This will be useful when we need to use the canonical IPA
for guest stage-2 tracking later.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4a..671e2941d619 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2021,6 +2021,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	bool writable = prot & KVM_PGTABLE_PROT_W;
 	struct kvm *kvm = s2fd->vcpu->kvm;
+	phys_addr_t canonical_ipa;
 	struct kvm_pgtable *pgt;
 	long perm_fault_granule;
 	long mapping_size;
@@ -2039,6 +2040,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	mapping_size = s2vi->vma_pagesize;
 	pfn = s2vi->pfn;
 	gfn = s2vi->gfn;
+	canonical_ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
 
 	/*
 	 * If we are not forced to use page mapping, check if we are
@@ -2057,6 +2059,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 				goto out_unlock;
 			}
 		}
+		canonical_ipa = ALIGN_DOWN(canonical_ipa, mapping_size);
 	}
 
 	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
@@ -2090,11 +2093,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
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
+					gpa_to_gfn(canonical_ipa));
 
 	if (ret != -EAGAIN)
 		return ret;
-- 
2.43.0

