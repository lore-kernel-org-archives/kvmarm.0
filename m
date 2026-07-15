Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3105644C654
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116760; cv=none; b=POUxOLSQosVQttbO/2pLBZHLt3XWxkTWjVB+X5oUdd8gWPopEoIhQKVVTvN/CjLkk4UVYyIKjoUzeM6okDLDDke99WEUpJzT80Xbyq83oJsAKWvYwhbUZjZC2uhJMvGQzCvRQU1U1NVrI38Gya41XV+KfyR0ER0NRdz710jvmR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116760; c=relaxed/simple;
	bh=Ep2a0G/52eGsYrTUgu5RVlmketd92FEfjFvjwS2XdcA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lfwM1ABjZnUg0PnveFCJbQK32EMz/xAQqu1k9AY1aTtWCYNDkv6XVG/s7wbpX9NLr1FJUz6x0dZzX3jog+TgWS9G3aFGpm5HDTcR6nPXWmmHA1nFw5GclF2XKAEd2NUchYA0fCq31F+Q//+1kR4i8wjC8DOgPhsGWLrCyE75D/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KAnAtEoe; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KAnAtEoe"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490a767b782so14695595e9.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116755; x=1784721555; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=M3eZs1fgfcJqE0urG21tDoGKs0yo1icKieB+aaaZBxk=;
        b=KAnAtEoe3e+YV4/sZS2A1isiZ5UjVOPGlkaqdt2OdX+icS5/kyDWpajKgORfQElNuW
         7l+dJlkWqq6xJTR1GFGLMzNZJTM65ctWQ4/+AVZrXbJ38qQ7iVWg65MObXTSBGMxQskk
         fmCg2599lL6jQ20r99+6h09U5it+bf/eDTCLryIYZkjl7k3Fi2xdenwZJf/VGW4bHMxn
         ksZQ8ZbVOyjE9AxIrnGHK2k9b5mc0PJ7zyi6DfoEuxWOqyOGanhiP000Zj1NQ3uvXNuX
         0fG2JUiYq1/3c4Dx41r0UXb1PHkakTDIqpeNYcIXvxvcIcW42W56Iq9UKGBpJTuLSBde
         xPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116755; x=1784721555;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M3eZs1fgfcJqE0urG21tDoGKs0yo1icKieB+aaaZBxk=;
        b=eWPss5hxc3U7MbNjL+AqZ7S10KuZI0qOQJCKG4cV+Ce56X5agDaLssvayGyDAP0AGk
         4D0sqNDEwH0B3Ute0EyOkb5Xww40AAfHVvghz3jaiE+2dd6lfRSFBrLmLgBmc0M3EN+J
         UeicF5aouLZ6g1xn4NLYXz5jzeGZ0o4BegX7nJF9T1efyiSbXW8SlLEv7WZdO/8sw/3d
         aswlFc9cdB5Xt8jSMOWR3JC4pE+gaq6ji2Ur/fD/JC9UPSrxtoVrUbrSxu53C4buKmLE
         OhrCDfoSSKURNCAWsuwuDk18Tgroddm8qqEQCzV8iXFdRIsMszqp3/MRiBoeVpbLyftu
         t3ow==
X-Forwarded-Encrypted: i=1; AHgh+RoiaIsxwpOGhTYuXXHnmo594IYpwgiCPcwlBxLtUqzabUOc0f0CdNBO646NjSYETKiZK7jN/qY=@lists.linux.dev
X-Gm-Message-State: AOJu0YynBN4kuvwlEf/PjluIYX7uIKeX7XoxUSPqDJABi58pdNjha/E+
	x7f6B8h69lihAL8D1pMT1w3oErwLp5ntXA1uhHW83plr8aPgKQbzwCHsUX9qEhBRgRnQ9zDM+QU
	AWlxFm+6wttwwhw==
X-Received: from wmdn11.prod.google.com ([2002:a05:600c:294b:b0:494:415:3ecd])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:621b:b0:493:faf3:3ead with SMTP id 5b1f17b1804b1-4952cc3c566mr74288995e9.4.1784116755156;
 Wed, 15 Jul 2026 04:59:15 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:43 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-3-smostafa@google.com>
Subject: [PATCH v7 02/24] KVM: arm64: Donate MMIO to the hypervisor
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
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
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  7 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 91 ++++++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c                  | 11 +--
 3 files changed, 102 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm=
/hyp/include/nvhe/mem_protect.h
index 29935c7da1de..51b0eb3844a9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -36,6 +36,13 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, =
u64 gfn);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
+/*
+ * Donate MMIO range to the hypervisor, it will be mapped in the hyperviso=
r's
+ * private range and unmapped from the host stage-2.
+ */
+int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned lo=
ng *haddr);
+/* Remaps MMIO range in the host, typically used in error path. */
+int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvh=
e/mem_protect.c
index 4e329e39a695..d803b3dd4cb4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -378,7 +378,11 @@ static int host_stage2_unmap_dev_all(void)
 	u64 addr =3D 0;
 	int i, ret;
=20
-	/* Unmap all non-memory regions to recycle the pages */
+	/*
+	 * Unmap all non-memory regions to recycle the pages.
+	 * That relies on kvm_pgtable_stage2_unmap() not clearing
+	 * counted PTEs which include hypervisor MMIO.
+	 */
 	for (i =3D 0; i < hyp_memblock_nr; i++, addr =3D reg->base + reg->size) {
 		reg =3D &hyp_memory[i];
 		ret =3D kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
@@ -1119,6 +1123,91 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
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
+	if (!PAGE_ALIGNED(addr | size) ||
+	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
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
+	if (!PAGE_ALIGNED(addr | size) ||
+	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
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
index 91a7dfad6686..3073184cf6ad 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1161,13 +1161,12 @@ static int stage2_unmap_walker(const struct kvm_pgt=
able_visit_ctx *ctx,
 	kvm_pte_t *childp =3D NULL;
 	bool need_flush =3D false;
=20
-	if (!kvm_pte_valid(ctx->old)) {
-		if (stage2_pte_is_counted(ctx->old)) {
-			kvm_clear_pte(ctx->ptep);
-			mm_ops->put_page(ctx->ptep);
-		}
+	/*
+	 * That also ignores stage2_pte_is_counted() instead of clearing
+	 * the PTE as the MMIO can be owned by the hypervisor.
+	 */
+	if (!kvm_pte_valid(ctx->old))
 		return 0;
-	}
=20
 	if (kvm_pte_table(ctx->old, ctx->level)) {
 		childp =3D kvm_pte_follow(ctx->old, mm_ops);
--=20
2.55.0.141.g00534a21ce-goog

