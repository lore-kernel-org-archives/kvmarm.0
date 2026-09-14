Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6AE3E3D80
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789372732; cv=none; b=c8FDU/0neJMqwA9R64lYn0p+s+cU+fvqAYZqOBIKhpW5jJ8AP2ucJBxcb6GPc4Kuo0RWw7Jv6i8MhcaSrO0qubxbZ3kdAweiXG8rvAPKkRBL0ymjobVSzLBlntvi1jpCuL7BfyQj/EzxQzAV5KFbdTKGU6GGfUmJp6cLizX4V7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789372732; c=relaxed/simple;
	bh=YxjdY3ApxAl657ZYcLmnV37OsEai4cLam0ZXBfSyVOE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oDVcf95dptP31Tzf+8tm0EJQODg9BaIFTnB8OdqNVJ0Mrzb2wLyuXm2NVPQWuAHq04ivKrB0cPubMywja51oEFV7E/Pq+v07EsaVs/2EHQBFQshlnzWhYLs6Zi4V00CQeIDvl7/jEEdHWaPK1KEw9losYn6C26OGNs4MXtVxTh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=atCOfilU; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="atCOfilU"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4957287363bso17373555e9.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 00:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789372728; x=1789977528; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0g8YRTAfNpB/LIEJRW4htZZQabejSE3QJeAUYbefuTU=;
        b=atCOfilU82Z+yleE3mJd0vnjUYLkyUtp/pCYNiAQp+pWLlHAEThc2kU7E4kreI8sGz
         a2TGMMWFPvywIAyDUDDhxW/nC/6QjY92SabbDrdDR8S9g3E1XOIVOXS+BCg7iZHhEe/q
         iaOAL9ce7smQ5ZQW0NWvwhtTFbbXPtjs3ZPa7iUk0aVZi7xOJZdJStzIHZr/X5utP/vU
         cCoqLVKmvXdSn53inhSCPV4/eWrjHFkGevstfz6LzAhzA3HgwPVlqtHpX1PopHKMq7sN
         zgOI51vj/RBusdycdiwUTCK3OKOqTrjmE6HcKAwxERfOKxZn3GLGOMivIPNNk2PtRhe0
         B+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789372728; x=1789977528;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0g8YRTAfNpB/LIEJRW4htZZQabejSE3QJeAUYbefuTU=;
        b=dAG0uPp0FAHRTcy5U9u5GNbaU5WCzPh5K/0G/mV3IQvpezVCBY6c0SbwrW2sjVpg3U
         q0vK4xV56soihQSGm3QoXb+Q0JRXwT7tCpcRU4L6FyOwCyMeroWrrUzllEu42Kbs2Xh1
         ZMtsyhGNAG4sHTJsdL5DS+EyPS1GPu3avMDG0VspYQzZsVBczHPZPNE5lqq6/sWj1R9n
         WxjOOSbu9Ae5sYQsyYUkwS7p4mpRAwf4Tul+Yt/i/dGS6aPuy25huDWz8ELVX+2uewdX
         i3nXQJ+dlvV6IMWdGMTMtxiJ2NRD+hWdRS3j2U3ZcWm5VKl+JM68payBRXoXW1ZiHgpW
         3yEg==
X-Forwarded-Encrypted: i=1; AKwUvBzP5GkAY0SdTlzUrRR/GkqQuNDNupu7VMmLAsFaQ2kNUv5nH+hgwYEOL23GqNbpg3MGvGpjns0=@lists.linux.dev
X-Gm-Message-State: AFuF++np6DbpmJ+devDa5jHaMuZQ8bEYY5XF0rQWnTVuCpUIBOlKlKhx
	mOTfkitvBDr6xa18hcnxbpLvgfMC/P62IYgK+PLc2s9yuCIWZZTQBMyOeondYDRVUsR/6Wa2aiz
	WU686oiQVB9biCPUCF8UQzA==
X-Received: from wmfr12.prod.google.com ([2002:a05:600c:158c:b0:495:72a8:661f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6819:b0:499:8aff:59b6 with SMTP id 5b1f17b1804b1-49e7a655a2dmr16386405e9.14.1789372728554;
 Mon, 14 Sep 2026 00:58:48 -0700 (PDT)
Date: Mon, 14 Sep 2026 08:58:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260914075839.4019904-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Fix protected VM fault on system with pages
 larger than 4K
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Just like commit 08f97454b7fa ("KVM: arm64: Fix protected mode handling
of pages larger than 4kB") fixed the boot of non-protected VMs on system
larger than 4K pages, align the fault IPA down to the page-size for
protected VMs.

To paraphrase Marc, pkvm_pgtable_stage2_map() assumes the address passed
as a parameter is aligned to the size of the intended mapping, while
HPFAR_EL2 gives the IPA minus the bottom 12 bits, regardless of the
system page size configuration.

Add a check at the start of pkvm_pgtable_stage2_map() as we do not
support !PAGE_ALIGNED arguments and use the gfn as an argument in all
callers.

Fixes: ea03466e806f ("KVM: arm64: Handle aborts from protected VMs")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---

Changelog:

v2:
  - Use gfn_to_gpa(gfn)
  - Drop "phys" from the PAGE_ALIGNED check, it isn't a requirement.
  - Fix gmem_abort() as well (Sashiko)

v1: https://lore.kernel.org/all/20260913173516.3122436-1-vdonnefort@google.com/

 arch/arm64/kvm/mmu.c  | 7 ++++---
 arch/arm64/kvm/pkvm.c | 3 +++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4a..ee78201a44df 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1672,10 +1672,10 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		 * PTE, which will be preserved.
 		 */
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
 								 prot, flags);
 	} else {
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), PAGE_SIZE,
 							 __pfn_to_phys(pfn), prot,
 							 memcache, flags);
 	}
@@ -1710,6 +1710,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
 	struct kvm_vcpu *vcpu = s2fd->vcpu;
 	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	gfn_t gfn = gpa_to_gfn(s2fd->fault_ipa);
 	struct mm_struct *mm = current->mm;
 	struct kvm *kvm = vcpu->kvm;
 	void *hyp_memcache;
@@ -1756,7 +1757,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
+	ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(gfn), PAGE_SIZE,
 				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
 				      hyp_memcache, 0);
 	write_unlock(&kvm->mmu_lock);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec12..b7340c430ed6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -414,6 +414,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 end = addr + size;
 	int ret;
 
+	if (!PAGE_ALIGNED(addr | size))
+		return -EINVAL;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
 

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.55.0.1007.g17ff1f9808-goog

