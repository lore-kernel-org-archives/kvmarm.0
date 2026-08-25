Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4872D46CE;
	Tue, 25 Aug 2026 16:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673692; cv=none; b=W8AdVFXl7JMx4W/rlYYovVdF8BhpfMRPXA8nqOoBe6lAZJEEFFQeJSDrKXSZqJxzEIWfKDWEGJnyZ81jU1xEZwZmF9Kv+mMEA1PuGSwbwi67+m0VAXnjK2ma/0qcNbcmSTbiSY2X9NFgIRUuNqmfrUG00a2KtsxfJjmyqUphdos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673692; c=relaxed/simple;
	bh=OK8qMkoBFUsKSDW1WXYaJvEYhrPVl7NXbf8oJ3V+T3w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a/EoAqdXL0u3nmCsuhbMMNq+P5mSAQaL2vZ03Z+NXiDLSoMMrpBTXT7uKQKFmBOZtR2LHK/2Jp1sfgTXQP2LgSKEbrMQq6eCyxBb7c1noYJO5rcVG2J6Mx3lewREKdKiaUIG7Uiz6TLv4ajvLwGPf9QV5PumnThfzO7mx9/b+nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHVqBfDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHVqBfDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A1A1F00A3A;
	Tue, 25 Aug 2026 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673691;
	bh=2n/GT1zNcErOZDVCRG/HrutbSxrG2jWsh4QWz8aUK78=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dHVqBfDStyFZhJftkYg6JAcTecPfldfshUIibfnQn0qeJVNaujjSLd6QcRAmlIRXf
	 tTdHX3/a0nT8Hf2scWZ/o2rQ6nx/67V89ay+ONEXUq6aQ8Rm4AxNd3m0NwOk3UYgJm
	 bVuEat7hL3MtjEf9FSh5iHr7SvtyvoQwT1X3z7olEPI7QlmA+rDexmL9ltF33TOOUD
	 NNfdSnAfxZ/FwY0G3aq6lRTN4hdvcVD/dmrDytX67c9FAGK/UkHwS2bgvzhSH6/sHB
	 Vl3QawoYBQfhM7anQ84gCbKoPubESoBoOX3vJukavt8xVf04nGHECoA8X8NeuIwjvk
	 Sl/WWQKBAa1UA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 25 Aug 2026 17:00:37 +0100
Subject: [PATCH 3/8] KVM: arm64: Propagate and use kvm_s2_fault_result on
 S2 fault
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-kvm-arm-prefault-v1-3-befe8947702e@kernel.org>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
In-Reply-To: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4633; i=ljs@kernel.org;
 h=from:subject:message-id; bh=OK8qMkoBFUsKSDW1WXYaJvEYhrPVl7NXbf8oJ3V+T3w=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJ69zgdV7sdlbN67b4bp9Qnd+2ZwBXv6ZRSMyWBYafTD
 6b1M/4+7ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE3kxnZHj/SLt2l/3/4Oen
 tq3p/dVhKHUs9ZhC9hflxkr29ZPaBBUZ/lmHSc57WP9DL7rR4+8NuSVptx/YJn6Purp10u1VqzY
 9fs0AAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

When stage 2 page tables fault the net result may either be that a page is
mapped, an error occurred or the fault should be retried (-EAGAIN).

When a fault succeeds it may be upgraded to a PMD size via
transparent_hugepage_adjust().

In order to support KVM pre-faulting the outcome of the fault and the
mapping size must be recorded.

Track this in the new kvm_s2_fault_result struct, which is threaded through
gmem_abort(), user_mem_abort() and kvm_s2_fault_map().

PKVM and SEA aren't relevant to synthetic pre-faulting so neither
kvm_inject_sea() nor pkvm_mem_abort() are altered.

Actual hardware faulting doesn't require this information, so
kvm_handle_guest_abort() simply passes NULL kvm_s2_fault_result to
gmem_abort() and user_mem_abort().

Faults are necessarily ephemeral and pre-faulting can't guarantee what may
happen in parallel, so do not store the GFN or PFN in
kvm_s2_fault_result. Pre-faulting only needs to know what was mapped in at
the point of the fault.

This struct could be replaced with a pointer to an unsigned long, however
it's clearer to separate out the mapped flag and having a struct allows us
to easily add additional fields in future as needed.

No functional change intended.

Suggested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 80cb520e25b9..da15da4e40e6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1607,6 +1607,11 @@ struct kvm_s2_fault_desc {
 	struct kvm_s2_mmu	*mmu;
 };
 
+struct kvm_s2_fault_result {
+	unsigned long mapping_size;
+	bool mapped;
+};
+
 static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
 {
 	return esr_fsc_is_permission_fault(s2fd->esr);
@@ -1632,7 +1637,17 @@ static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
 }
 
-static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
+static void populate_fault_result(struct kvm_s2_fault_result *result,
+				  unsigned long mapping_size)
+{
+	/* A THP upgrade may have altered mapping size. */
+	result->mapping_size = mapping_size;
+	/* -EAGAIN is swallowed so be explicit when we actually map. */
+	result->mapped = true;
+}
+
+static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
+		      struct kvm_s2_fault_result *result)
 {
 	bool write_fault, exec_fault;
 	const bool perm_fault = kvm_s2_fault_is_perm(s2fd);
@@ -1714,6 +1729,8 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
 		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
 
+	if (result && !ret)
+		populate_fault_result(result, PAGE_SIZE);
 	return ret != -EAGAIN ? ret : 0;
 }
 
@@ -2038,7 +2055,8 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 			    const struct kvm_s2_fault_vma_info *s2vi,
 			    enum kvm_pgtable_prot prot,
-			    void *memcache)
+			    void *memcache,
+			    struct kvm_s2_fault_result *result)
 {
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	bool writable = prot & KVM_PGTABLE_PROT_W;
@@ -2117,12 +2135,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
 	}
 
+	if (result && !ret)
+		populate_fault_result(result, mapping_size);
 	if (ret != -EAGAIN)
 		return ret;
 	return 0;
 }
 
-static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
+			  struct kvm_s2_fault_result *result)
 {
 	const bool perm_fault = kvm_s2_fault_is_perm(s2fd);
 	struct kvm_s2_fault_vma_info s2vi = {};
@@ -2161,7 +2182,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		return ret;
 	}
 
-	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache);
+	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
 }
 
 /* Resolve the access fault by making the page young again. */
@@ -2440,9 +2461,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 				!kvm_s2_fault_is_exec(&s2fd));
 
 		if (kvm_slot_has_gmem(memslot))
-			ret = gmem_abort(&s2fd);
+			ret = gmem_abort(&s2fd, NULL);
 		else
-			ret = user_mem_abort(&s2fd);
+			ret = user_mem_abort(&s2fd, NULL);
 	}
 
 	if (ret == 0)

-- 
2.55.0

