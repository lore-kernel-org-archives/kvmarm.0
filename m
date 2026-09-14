Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4045D46AA79;
	Mon, 14 Sep 2026 12:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388828; cv=none; b=XlLKcIvbQfn8bzo+DDG2CpbgKgISBODjpBv23udAgM7q1/pCwCkFovzbWAPhpBnSblRM3DPyfxXylyBAWlVCwfVEv7zQmDrGAlnEQqEDdNJV2XpQyignbTk0xpgFbxT8NLVs2sxMhJU7FVdklACjPx3Cj8lU8PYhNr0RMG3PPG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388828; c=relaxed/simple;
	bh=7h5BNF2TyNFGKTZFDAT77YrYi9+yuhGSKydMX9EZVMo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LyAj+X7rcwuSoT6Sld/Q9opJq+RI6Qosgz6RIvuRkRk2qTj33L/VXWP58EsGfgUmuMKiJ2rdudN58ezXX3ivg3u+rsKK3obyjqMW1rNDY0SzQAe7WZfqGWoJfaphBYAx7+latOeOmh3UZsgHN2uydDFi4vWPeggqjO522x0PMmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0IwcxuX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0IwcxuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667981F00893;
	Mon, 14 Sep 2026 12:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388825;
	bh=kfg0Uz8+KztBDtg3H0+qNEem9pKDqqYVBa07KrFCXCA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y0IwcxuX0w/WvGSBZT3ojW/ME7dow3oCVDawD0flWeh6jWWkI8QWODZUzZMmjwe/B
	 4VU4fHsHZc0zyXnmq868pX14HRYBiITiw8MW2ugWOITzNFdGYpjogtppY0ixIguo5U
	 3YNMESJ4llRoHzSJt6IwGjLIZTj81ZUdHosnMZavRsiYirgqHHmrnbdbZpBTbE+t0e
	 cDfpNXMTZ8DEbCe2uA3r9EEIrXHVeNA3yurCq4oQqpnXcaI6fGuvvuPm7zcntOJkIr
	 TXCADD8sujBUmxChcp5FBfa/WxOYkxnkVduYpNseGiDJqvEcxHPOaPa8AaMP9t2wlZ
	 sWDZuCq9S6lyw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 13:26:16 +0100
Subject: [PATCH v2 05/13] KVM: arm64: Propagate and use kvm_s2_fault_result
 on S2 fault
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-kvm-arm-prefault-v2-5-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
In-Reply-To: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4228; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7h5BNF2TyNFGKTZFDAT77YrYi9+yuhGSKydMX9EZVMo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWP/86OaVhwydvpoC2R3t2vPXcX80gaHMmc16puUTH3
 fajd+1aO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjAR192MDCsEvqkdEtT7Ncsi
 0/fLOS+2ZEn/RaI7PWu62SaouqzvSGdkeNvM3+i0/vYDa6aQpUe5rqfc/O9u8jXcMyxswwJeZwN
 hTgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

When stage 2 page tables fault the net result may either be that a page is
mapped, an error occurred or the fault should be retried (-EAGAIN).

When a fault succeeds it may be upgraded to a PMD size via
transparent_hugepage_adjust().

In order to support KVM pre-faulting the outcome of the fault and the
mapping size must be recorded.

Track the mapping size via new kvm_s2_fault_result struct, which is
threaded through gmem_abort(), user_mem_abort() and kvm_s2_fault_map().

PKVM and SEA aren't relevant to synthetic pre-faulting so neither
kvm_inject_sea() nor pkvm_mem_abort() are altered.

Actual hardware faulting doesn't require this information, so
kvm_handle_guest_abort() simply passes NULL kvm_s2_fault_result to
gmem_abort() and user_mem_abort().

A non-NULL result also tells the abort handlers that the caller is
pre-faulting rather than a vcpu, in which case -EAGAIN is propagated to the
caller to allow the pre-fault to be retried.

No functional change intended.

Suggested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f402481e8a4e..13541218cadb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1607,6 +1607,10 @@ struct kvm_s2_fault_desc {
 	struct kvm_s2_mmu	*mmu;
 };
 
+struct kvm_s2_fault_result {
+	unsigned long mapping_size;
+};
+
 static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
 {
 	return esr_fsc_is_permission_fault(s2fd->esr);
@@ -1632,7 +1636,8 @@ static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
 }
 
-static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
+static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
+		      struct kvm_s2_fault_result *result)
 {
 	bool write_fault, exec_fault;
 	bool perm_fault = kvm_s2_fault_is_perm(s2fd);
@@ -1714,7 +1719,13 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
 		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
 
-	return ret != -EAGAIN ? ret : 0;
+	if (ret == -EAGAIN)
+		return result ? ret : 0;
+
+	if (result && !ret)
+		result->mapping_size = PAGE_SIZE;
+
+	return ret;
 }
 
 struct kvm_s2_fault_vma_info {
@@ -2038,7 +2049,8 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 			    const struct kvm_s2_fault_vma_info *s2vi,
 			    enum kvm_pgtable_prot prot,
-			    void *memcache)
+			    void *memcache,
+			    struct kvm_s2_fault_result *result)
 {
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	bool writable = prot & KVM_PGTABLE_PROT_W;
@@ -2117,12 +2129,17 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
 	}
 
-	if (ret != -EAGAIN)
-		return ret;
-	return 0;
+	if (ret == -EAGAIN)
+		return result ? ret : 0;
+
+	if (result && !ret)
+		result->mapping_size = mapping_size;
+
+	return ret;
 }
 
-static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
+			  struct kvm_s2_fault_result *result)
 {
 	bool perm_fault = kvm_s2_fault_is_perm(s2fd);
 	struct kvm_s2_fault_vma_info s2vi = {};
@@ -2161,7 +2178,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		return ret;
 	}
 
-	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache);
+	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
 }
 
 /* Resolve the access fault by making the page young again. */
@@ -2440,9 +2457,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
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

