Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F09031A053
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640349; cv=none; b=plokgrLWe40cV/962IS9WKYRCrH+mSdKDdXijLCU72T7KqP80mq/Z8HvR4EDs6Q8+FTpYIT/0any7QFjs3nE3K77kTWCky4LxmEe/FDIFu0RA2/CGUb7wgrrlMnSTJBQpoSWLKJJFjr+h74pqBsB7gevk5MKL+qNdpgCkfnacYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640349; c=relaxed/simple;
	bh=BD3OB//GZsI6wyE5tIICFFT0lSi+PCLS/mLJZoc5JA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lsyezYs56dj4O9YN094kwdFK3BcHvFsaZgBjErzUpe8Q2DFRzrkkrQKau+IdYhPGNFWCQz0tdijAiHkLvkIT1O9KbbL6oygxa4dFEDDv3l9wBFWdW+IoFM3w5odWrPtvYcbjytL8lO4Nw73i0gGoCG6glLFXe5uIKjxO9DOwYC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V8/nTwr4; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V8/nTwr4"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b05d31cso24102335e9.1
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640345; x=1756245145; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVz3Y9VpnYE4PVj2+x4ppZYRh/7u9Tfs4/CSD5zsJnw=;
        b=V8/nTwr47j/3ruCI8t2KoGHjiKHL6hRdtLnFu2nLa/xeUONKWsU9pDx05FwJG+vOZ+
         SnPwhB8kvwNrtwavDwsrZ7QC5LoEcxUXCJYn2MgnHPqHgROJHjDWBd1bbGQv6KAiozgj
         lmW5JDerJoxX9bIQ5OyryZByke8/NS8xrQXDM7aG8+K2YghGIQ/lrBmNakup8RSigzg4
         JnVZ5N5nDVK8uH/tF+F9NY04PqqbeIY5jqNsvr21CKE+61SFzu1Yg3et4yXlkhjDy6Vc
         4EUVwMVGfQicm5edq1P5HGzQzIdRr2i0XNVGn8uba2jizzqTMFDeMvJZuPLG29FYp7K4
         oOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640345; x=1756245145;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vVz3Y9VpnYE4PVj2+x4ppZYRh/7u9Tfs4/CSD5zsJnw=;
        b=pyixKB3D7MKdCrOhtVl9sRIBbvsXHjPrM5Lt/nvm9WIOyhK14Lt8I4JJ2H3eoLP8ea
         YYzX/Vu6yCo4lZcWih3bHdi0l4wsA7Qg7RqO+FwUzZcdY2qpAfqEoWEXv6az9MaaFANN
         jdfIzyKZ6GJ0G+g6/a2s0j+tNS3ZiqXAG7JzyLzdoOr6ZOjbKghuAATLy+ATxYnLlP1A
         EdiMska7vZys+2NjZLtTMBanZm517GRo5bHlDW+XdysV7mMjOv5FhAf9rFuMuF6jYRFS
         +zpkIjU5vwDIxqL1D3wvA0/ISmjMWXLEztmZE1r4DDaBqGrqe9xMb2v0Y65LZsqJzy8a
         P6tw==
X-Forwarded-Encrypted: i=1; AJvYcCWD7De0ICTwqrAdoydmk9U2Pc212a0z0Q2oHDbcFX1kFvls5cvJLi1mkeA8lwYQwlkefgzZ07Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKNoLe3f35pycRmjPwqPUiWn0+9zd8xT7jGks+FseQTWZ9eLGq
	GAPoxBPUWYvm15Ozur4T57oAh/QaSMYHg8qCG4RMnFasg7bbeIMZ5hXWpJXeH87iBwOq6cXkfnZ
	w0GdAqH414k07PA==
X-Google-Smtp-Source: AGHT+IE7z3JoHU46VhERaG2rUhWS+WRB2JYInik0I1QmJUrgMcHdJZz9Xytw3QMikJfteQ5I/RRwqWO+5o1F0Q==
X-Received: from wmbem12.prod.google.com ([2002:a05:600c:820c:b0:458:c0cd:291c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f0c:b0:43d:4e9:27ff with SMTP id 5b1f17b1804b1-45b4798a7bdmr3379925e9.7.1755640344849;
 Tue, 19 Aug 2025 14:52:24 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:30 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-3-smostafa@google.com>
Subject: [PATCH v4 02/28] KVM: arm64: Donate MMIO to the hypervisor
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
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
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 64 +++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c                  |  9 +--
 3 files changed, 68 insertions(+), 7 deletions(-)

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
index 861e448183fd..c9a15ef6b18d 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -799,6 +799,70 @@ int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enu=
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
+
+	host_lock_component();
+	hyp_lock_component();
+
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) !=3D size);
+	WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt, phys=
,
+				PAGE_SIZE, &host_s2_pool, PKVM_ID_HOST));
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return 0;
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
2.51.0.rc1.167.g924127e9c0-goog

