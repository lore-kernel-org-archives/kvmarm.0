Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E4B312812
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405311; cv=none; b=iR9AwEHKQfcREGVifXZzVQmE0ZMY0ceDwPb7ZcwFwhmOMtod+yJconKgWkxTJKYxc36WvthtQWTWQZtiZFCXyRdkDmcvtaZz0jaiVkQwX7N99O2KHipiBFeY2vAgXbJaz6ChyxixnJUyNNt1DWAl5WZFoOmFUkdw67vZ+XB0DPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405311; c=relaxed/simple;
	bh=2Y9643ZngljQl47Ad+xEoXXZjIjmeGyFMzazpt4UT+Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aJhky5zMxPpNAEjzooiMgmYX8Ljmy7hP2yZLZ3PO1d0dfohoKArqVtHRZBxCaiAzzM5rdHbzIHrCdU519UYmgn7RWTw34CinUzAwr7H2JNhXJQiGPR9WdqwNXL2ET8cJD3987+IzIt7AtJHAz+I+SDlesqOtAU39SFsOjU2R2AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PI5dLT8b; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PI5dLT8b"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47797caba11so11032685e9.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405308; x=1764010108; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ud78eB0arPLfokP7b6+iOXM9DvD6Lviy96UJdE9HiHk=;
        b=PI5dLT8bIVN+DY8NxJlLUGsflrCH8gAl1R+KNKE/phDlvkd2E5gkcZFSgeeonK9IUy
         FYcZtUfXG0s4eXwft+lmlcEtAbQ6WM7aSGlkGLHFbTfacR0cNFtQLg/r5EZqZ0TRe9x3
         VNk17LPOSSm6Vb1JgX+1Q7gvFUQPzeMqeyj4oUdraXt2tQSQeaSUJl+MOnbLqTrh6TqE
         ahx66/GlcWSt+AvTV2C+zqoGK6CMcgTqw6OU9U4P+P//NvUyjk7Y7FdTpek6AuSISNhg
         U0wZC366z6lXGtyznO00gYAvwZy4BulhM30ZoiAyRMe5iYfpwN54KOMb3jHRnqg/GgqF
         WH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405308; x=1764010108;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ud78eB0arPLfokP7b6+iOXM9DvD6Lviy96UJdE9HiHk=;
        b=mEXoZw1mPll5xtK/9qTNvYNZBEyTAJFVeyAoUxvuJyuDBgBCNlEg3+0IEU7V2lvYHW
         c1oXAi3n1oqnsepIPM4yswTAJsLfOtumHSRoVOideXXas4WsSwY7lU/iwrT7/H332Mxu
         2gEmv9oPZv7YK+UdvdCEVQqx6kSntkT2mMuezAeuv2WHF9Psgb78dWXVTaQSofACvLTi
         WDygwmGUcigsSltfZy0xiUDgutOXkXyRoeKJi3VICezVwYWtGotVLbrgvFF5TSc4vxrZ
         0sEINqyb+zlf/5vDYmk1R7+bmYfALIini5Rs0qI4BUp0PG7iu34i7/Vvm4o+F+r1nkg5
         CERQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFh1/P3dCYtIlUFG90UY1gGrsasvI9hvbxd74tSmdJsS8e5yy/1fRK4Z5OlTZbtaJnImVJ/Fg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkWF6OrYp9tteTNlsuR2StqeJ+IeyH1LSF1/UcgFAQe6Uei0f4
	QMjd29Skwf8kQyivt90tEwO7tcWheAPwRVAPyUpFDiWDLqFwnxBU03z0c7Xdjm0MCWBOaiyQ06D
	hYGP5uK+5R2EjbQ==
X-Google-Smtp-Source: AGHT+IFtQM3E60fdG09G4db3NhGt1PCpbNSce99vQEOknynP4HtzybGxEOyhlaEXa2/I2J7fKVIRDAwQImwldQ==
X-Received: from wmbgx25.prod.google.com ([2002:a05:600c:8599:b0:477:a338:214b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4513:b0:477:2f7c:314f with SMTP id 5b1f17b1804b1-4778fe5c820mr145661085e9.10.1763405307962;
 Mon, 17 Nov 2025 10:48:27 -0800 (PST)
Date: Mon, 17 Nov 2025 18:47:49 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-3-smostafa@google.com>
Subject: [PATCH v5 02/27] KVM: arm64: Donate MMIO to the hypervisor
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
drivers can use that to protect the MMIO of IOMMU.
The initial attempt to implement this was to have a new flag to
"___pkvm_host_donate_hyp" to accept MMIO. However that had many problems,
it was quite intrusive for host/hyp to check/set page state to make it
aware of MMIO and to encode the state in the page table in that case.
Which is called in paths that can be sensitive to performance (FFA, VMs..)

As donating MMIO is very rare, and we don=E2=80=99t need to encode the full=
 state,
it=E2=80=99s reasonable to have a separate function to do this.
It will init the host s2 page table with an invalid leaf with the owner ID
to prevent the host from mapping the page on faults.

Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
stage-2 PTEs, as this can be triggered from recycle logic under memory
pressure. There is no code relying on this, as all ownership changes is
done via kvm_pgtable_stage2_set_owner()

For error path in IOMMU drivers, add a function to donate MMIO back
from hyp to host.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 90 +++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c                  |  9 +-
 3 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm=
/hyp/include/nvhe/mem_protect.h
index 52d7ee91e18c..98e173da0f9b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -37,6 +37,8 @@ int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot p=
rot);
+int __pkvm_host_donate_hyp_mmio(u64 pfn);
+int __pkvm_hyp_donate_host_mmio(u64 pfn);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvh=
e/mem_protect.c
index 434b1d6aa49e..c3eac0da7cbe 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -799,6 +799,96 @@ int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enu=
m kvm_pgtable_prot prot)
 	return ret;
 }
=20
+int __pkvm_host_donate_hyp_mmio(u64 pfn)
+{
+	u64 phys =3D hyp_pfn_to_phys(pfn);
+	void *virt =3D __hyp_va(phys);
+	int ret;
+	kvm_pte_t pte;
+
+	if (addr_is_memory(phys))
+		return -EINVAL;
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
+	if (ret)
+		goto unlock;
+
+	if (pte && !kvm_pte_valid(pte)) {
+		ret =3D -EPERM;
+		goto unlock;
+	}
+
+	ret =3D kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL);
+	if (ret)
+		goto unlock;
+	if (pte) {
+		ret =3D -EBUSY;
+		goto unlock;
+	}
+
+	ret =3D pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, PAGE_HYP_DEVI=
CE);
+	if (ret)
+		goto unlock;
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
+	WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt, phys=
,
+				PAGE_SIZE, &host_s2_pool, PKVM_ID_HYP));
+unlock:
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
+
+int __pkvm_hyp_donate_host_mmio(u64 pfn)
+{
+	u64 phys =3D hyp_pfn_to_phys(pfn);
+	u64 virt =3D (u64)__hyp_va(phys);
+	size_t size =3D PAGE_SIZE;
+	int ret;
+	kvm_pte_t pte;
+
+	if (addr_is_memory(phys))
+		return -EINVAL;
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret =3D kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL);
+	if (ret)
+		goto unlock;
+	if (!kvm_pte_valid(pte)) {
+		ret =3D -ENOENT;
+		goto unlock;
+	}
+
+	ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
+	if (ret)
+		goto unlock;
+
+	if (FIELD_GET(KVM_INVALID_PTE_OWNER_MASK, pte) !=3D PKVM_ID_HYP) {
+		ret =3D -EPERM;
+		goto unlock;
+	}
+
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) !=3D size);
+	WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt, phys=
,
+				PAGE_SIZE, &host_s2_pool, PKVM_ID_HOST));
+unlock:
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
+
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 {
 	return ___pkvm_host_donate_hyp(pfn, nr_pages, PAGE_HYP);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5db..ba06b0c21d5a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1095,13 +1095,8 @@ static int stage2_unmap_walker(const struct kvm_pgta=
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
2.52.0.rc1.455.g30608eb744-goog

