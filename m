Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473BD39E6F5
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634396; cv=none; b=GoQK/W0ygxVBmpuHrq0npmNRnmL7mJKI/ZeL3W9Qpx771XHZjDIzixtlV8SpO620BgPqWZq9yetrTqEURStSGTHr26srmmZcfG4TjBNOXxt6RbvX6/1dfy7tOnoL4EWIOdStp3YqOyoO9mcoEdJ+3SF++HNSiyoNtiHbL4TswY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634396; c=relaxed/simple;
	bh=BmiEfuWtlBnKnC8QbqZfTTQw11BzMKVlOkGG+YAJ6JE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=thLlnr1C4+INkMpKlCQf0o6IJCslcXOEzLlHLa0o/kA6RxK5bX73gFIOk09U6sbJFzqDoUDkGpM4Nvc7L8wlXXlt1bML3DlIexC7ih4eibg2Gvc+W18iemwiEFPddk7gtlRbE4CSdPFpsv2ZhhvFAFV4tVDXJ1VgIKNxHi+yHPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OGAWCzz0; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OGAWCzz0"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44a56cf1466so476168f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634394; x=1778239194; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MJCtNul8s1oM/6GNPCvZ51Sl0VZ6ziIdGPUB2bbn4jI=;
        b=OGAWCzz0yTq5bzReFzMTIo7bHoLCRCSfvsW2gn4SimusNk7CX4R88RzZsz0EI46F6F
         DH6OWUSiLzbr1w9VbKExnrk+rYMZyZV0QbdQNz+NycrW05OzjsrC3Y7jxtICQcWUECsC
         eVvBLqO7P+VAvQMVwhlWZsV1hxN5flrzKbo6oX3Vh+TMv2rBU4po74YBfj1WEL9d6/OA
         ePdgaD3cUenA3KBjm9YkXbdceN84Y4rW/Jh7Jt6wOg+6XZHffG0TiRPYdC7tMFQdtHAF
         NWUJevW65RaTvZSsaa4Q+xvp6qs+CJaQA1Hj4Jmclq6LNV0QLJRiuFxuyxtzWiIRKI04
         rt5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634394; x=1778239194;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MJCtNul8s1oM/6GNPCvZ51Sl0VZ6ziIdGPUB2bbn4jI=;
        b=VD2mYNSdWiOvWPYy9R6Xd7mZq/6IY7LWWJoS/fpaLFwR6KR40Wy4lOiQr0GCQaBMuR
         t+G8T6IT54DggAVC+nDEwTA0vC920QjViuzrTa4D9QZlcb2mkJi6rRTP1xvR1TOu+Qzi
         yRJXQpT9e20qnvbk6mblz5MZA5XVBg3g0sCOPkDDsQ1kJiUSo9uWh4QgJJ27FqSxg1Wx
         hqSJQej1ojPEsrxkdICE2EgT8bsXndtf8hxiPY6ORb3BQ+e0lGABxYup5zB5VXKMkgO7
         U5leYO2HMOSCjas7x08jVkgG2ITYHy+yXQSk26+nyD9ppKJUwvqn1APBTkNJ+bzvzbZG
         p8XQ==
X-Forwarded-Encrypted: i=1; AFNElJ8oiOGIV+bYetly6OawH6Q4765eCmSmSNsew6QFwrPpm4ydhKkQfyVFgY15bgFi1ESTB8qwzHs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZXRr5ojsh5OY6VtXEHtu6O+6B8PnGobYsLv6dVM/LBEpOYciy
	lBfz7O2Hz/OhK4RIDOPt1VXDfO88kKbjYKG2BljQoxSO3oTiyWpasSjJvXzthjhTDYCJQRZ15CD
	OLao0JzUK5uahOg==
X-Received: from wmqy6.prod.google.com ([2002:a05:600c:3646:b0:488:a6d9:e91a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c170:b0:489:1a63:509c with SMTP id 5b1f17b1804b1-48a83d06bc3mr102554135e9.0.1777634393631;
 Fri, 01 May 2026 04:19:53 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:04 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-3-smostafa@google.com>
Subject: [PATCH v6 02/25] KVM: arm64: Donate MMIO to the hypervisor
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
drivers can protect and access the MMIO of IOMMUs.

As donating MMIO is very rare, and we don=E2=80=99t need to encode the full
state, it=E2=80=99s reasonable to have a separate function to do this.
It will init the host s2 page table with an invalid leaf with the owner ID
to prevent the host from mapping the page on faults.

Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
stage-2 PTEs, as this can be triggered from recycle logic under memory
pressure. There is no code relying on this, as all ownership changes is
done via kvm_pgtable_stage2_set_owner()

For the error path in IOMMU drivers, add a function to donate MMIO
back from hyp to host. However, that leaks the hypervisor virtual
address range which should be acceptable as this is quite rare and
it matches the behaviour of fix_map/block.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 119 +++++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c                  |   9 +-
 3 files changed, 121 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm=
/hyp/include/nvhe/mem_protect.h
index 3cbfae0e3dda..ff440204d2c7 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -36,6 +36,8 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u=
64 gfn);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
+int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned lo=
ng *haddr);
+int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvh=
e/mem_protect.c
index 28a471d1927c..2fb20a63a417 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -353,6 +353,38 @@ int __pkvm_prot_finalize(void)
 	return 0;
 }
=20
+/* Unmap MMIO region while skipping donated PTEs. */
+static int host_stage2_unmap_mmio_region(u64 start, u64 size)
+{
+	struct kvm_pgtable *pgt =3D &host_mmu.pgt;
+	u64 unmap_start =3D start;
+	u64 addr =3D start;
+	kvm_pte_t pte;
+	int ret =3D 0;
+	u8 level;
+
+	while (addr < start + size) {
+		ret =3D kvm_pgtable_get_leaf(pgt, addr, &pte, &level);
+		if (ret)
+			return ret;
+		if (!kvm_pte_valid(pte) && pte !=3D 0) {
+			if (addr > unmap_start) {
+				ret =3D kvm_pgtable_stage2_unmap(pgt, unmap_start,
+							       addr - unmap_start);
+				if (ret)
+					return ret;
+			}
+			addr +=3D kvm_granule_size(level);
+			unmap_start =3D addr;
+		} else {
+			addr +=3D kvm_granule_size(level);
+		}
+	}
+	if (addr > unmap_start)
+		ret =3D kvm_pgtable_stage2_unmap(pgt, unmap_start, addr - unmap_start);
+	return ret;
+}
+
 static int host_stage2_unmap_dev_all(void)
 {
 	struct kvm_pgtable *pgt =3D &host_mmu.pgt;
@@ -363,11 +395,11 @@ static int host_stage2_unmap_dev_all(void)
 	/* Unmap all non-memory regions to recycle the pages */
 	for (i =3D 0; i < hyp_memblock_nr; i++, addr =3D reg->base + reg->size) {
 		reg =3D &hyp_memory[i];
-		ret =3D kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
+		ret =3D host_stage2_unmap_mmio_region(addr, reg->base - addr);
 		if (ret)
 			return ret;
 	}
-	return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
+	return host_stage2_unmap_mmio_region(addr, BIT(pgt->ia_bits) - addr);
 }
=20
 /*
@@ -1087,6 +1119,89 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	return ret;
 }
=20
+int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned lo=
ng *haddr)
+{
+	kvm_pte_t pte;
+	u64 offset;
+	int ret;
+
+	/* Only before de-privilege. */
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		return -EPERM;
+
+	if (!PAGE_ALIGNED(addr | size))
+		return -EINVAL;
+
+	ret =3D __pkvm_create_private_mapping(addr, size, PAGE_HYP_DEVICE, haddr)=
;
+	if (ret)
+		return ret;
+
+	host_lock_component();
+	for (offset =3D 0; offset < size; offset +=3D PAGE_SIZE) {
+		if (addr_is_memory(addr + offset)) {
+			ret =3D -EINVAL;
+			goto unlock;
+		}
+		ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
+		if (ret)
+			goto unlock;
+		if (pte && !kvm_pte_valid(pte)) {
+			ret =3D -EPERM;
+			goto unlock;
+		}
+	}
+	/*
+	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
+	 * - host aborts: host_stage2_adjust_range() would fail for invalid non z=
ero PTEs.
+	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would cal=
l
+	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid pte=
s (counted).
+	 * - other MMIO donation: Would fail as we check that the PTE is valid or=
 empty.
+	 */
+	ret =3D host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
+			      addr, size, &host_s2_pool,
+			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
+			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
+unlock:
+	host_unlock_component();
+	return ret;
+}
+
+int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)
+{
+	kvm_pte_t pte;
+	u64 offset;
+	int ret =3D 0;
+
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		return -EPERM;
+
+	if (!PAGE_ALIGNED(addr | size))
+		return -EINVAL;
+
+	host_lock_component();
+	for (offset =3D 0; offset < size; offset +=3D PAGE_SIZE) {
+		if (addr_is_memory(addr + offset)) {
+			ret =3D -EINVAL;
+			goto unlock;
+		}
+		ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
+		if (ret)
+			goto unlock;
+		if (!pte || kvm_pte_valid(pte)) {
+			ret =3D -EINVAL;
+			goto unlock;
+		}
+		if (FIELD_GET(KVM_HOST_DONATION_PTE_OWNER_MASK, pte) !=3D PKVM_ID_HYP) {
+			ret =3D -EPERM;
+			goto unlock;
+		}
+	}
+	WARN_ON(host_stage2_idmap_locked(addr, size, PKVM_HOST_MMIO_PROT));
+unlock:
+	host_unlock_component();
+	return ret;
+}
+
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 {
 	u64 phys =3D hyp_pfn_to_phys(pfn);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0c1defa5fb0f..b64a50f9bfa8 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1159,13 +1159,8 @@ static int stage2_unmap_walker(const struct kvm_pgta=
ble_visit_ctx *ctx,
 	kvm_pte_t *childp =3D NULL;
 	bool need_flush =3D false;
=20
-	if (!kvm_pte_valid(ctx->old)) {
-		if (stage2_pte_is_counted(ctx->old)) {
-			kvm_clear_pte(ctx->ptep);
-			mm_ops->put_page(ctx->ptep);
-		}
-		return 0;
-	}
+	if (!kvm_pte_valid(ctx->old))
+		return stage2_pte_is_counted(ctx->old) ? -EPERM : 0;
=20
 	if (kvm_pte_table(ctx->old, ctx->level)) {
 		childp =3D kvm_pte_follow(ctx->old, mm_ops);
--=20
2.54.0.545.g6539524ca2-goog

