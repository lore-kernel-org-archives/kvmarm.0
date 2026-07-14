Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1DF3386443
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 12:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030404; cv=none; b=Znzb/490bD1TB+WU3HkYEOa2myC/WtUW4zhwEjoHPNNQaDGp4AI8BHk7QA50Aft+KDe4BFQfUDyZ8JPMsE27/aAU2ZP3n8XcdX1nzofADaq8ea3dKUfHaMpkPaRfxYpCf61PvCiqSKjPGD1jy0lfzY9mLPNDku5S4gcpqbzfNqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030404; c=relaxed/simple;
	bh=RPfike1o9nuXZBOiQAjbQMhBFKE/+EBRVPOQI5nvn6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDB+DnOwZkLjz62mv2NUsf5lAHThtcSZ1B88/NOUvxyYwHrQI/UJH2Emmxv8aQzbZpD5TlYcITgdE4LzlNfAzwtHIThNGnHPWKmImIWdg6QUWUwO1mzaqCcc7tvzgS0rOKVohQVSv8A4U5WyjUsB7qyYP0VodflZP/CnLDcdnrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kzhJlb0n; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kzhJlb0n"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE7061476;
	Tue, 14 Jul 2026 04:59:57 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD06E3F93E;
	Tue, 14 Jul 2026 04:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784030402; bh=RPfike1o9nuXZBOiQAjbQMhBFKE/+EBRVPOQI5nvn6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzhJlb0nAI9smDy/4lMOJ0AcSAkvKnNWn2soWpbbvZtDl2ruR8Gb/+ENw6cqhjTIS
	 4bjzQe121JTL2/WPP0EtjvbCpOAkGafnLZVOMFpJ/LCgCDk1ONEC+x4fJh+4k0aM/Q
	 whm6MV7IF6jry9SjgmYOM6Ofc1FLFo6eBxRBlmh0=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v4 1/6] KVM: arm64: Use a variable for the canonical GPA in kvm_s2_fault_map()
Date: Tue, 14 Jul 2026 12:59:20 +0100
Message-ID: <20260714115926.2044757-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260714115926.2044757-1-weilin.chang@arm.com>
References: <20260714115926.2044757-1-weilin.chang@arm.com>
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
index 8811ad60cf72..54395a608fd3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2021,6 +2021,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	long mapping_size;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
+	phys_addr_t canonical_gpa;
 	int ret;
 
 	kvm_fault_lock(kvm);
@@ -2034,6 +2035,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	mapping_size = s2vi->vma_pagesize;
 	pfn = s2vi->pfn;
 	gfn = s2vi->gfn;
+	canonical_gpa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
 
 	/*
 	 * If we are not forced to use page mapping, check if we are
@@ -2052,6 +2054,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 				goto out_unlock;
 			}
 		}
+		canonical_gpa = ALIGN_DOWN(canonical_gpa, mapping_size);
 	}
 
 	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
@@ -2085,11 +2088,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
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

