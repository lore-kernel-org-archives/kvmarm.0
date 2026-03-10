Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC57C40DFC5
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146986; cv=none; b=l5txxl4rFOyVIx9eZwrq1QXTfdEO6igFZCHGvVA+FniZM7SR/QXeIZGA/zEGkvBgQj4SMTPCUFo8j+LYvILWl/k3dWU0Utrb+tUBxDLq/L+Qx9hcXfPDwZuPHA9wBMAi2SxO/WnVQ2JML2sKOJCr8ae0Wk9++z0BP1cxWqPRQdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146986; c=relaxed/simple;
	bh=XMezVaG2jrFsqhtuwUE0Kf1BC2hXXFsGiwJ8k7oxih4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DMBl5e0ybZ8kkw68i6mzWcEoY4xPGhlpYABIps3f5tWsFHmhJ2afwp06yhgWrAHpWvrywJoD4y8H7uu/I5XkSjWkztkFLnYgpZTkbhVpRR0V+t9+Tn6iF0vCGoi7quftJqhaAn6fEvHPt3KV1jgtqIdR9bPX6vHvsQQ+5c+nxiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KIrjOpDq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KIrjOpDq"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-485397788b3so24575425e9.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146983; x=1773751783; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p112r6vXdhUi4U6D+bqdMKbRGwHW3a/qIYzeua87t30=;
        b=KIrjOpDqtwwnc3CPOQbtmmP9N/8bih/IezKXs0+qOhTVI7Uncqx0MYbr+BzOzqJ/F4
         t6TBYCSqkxUCQxj0LRgT9LTDFT34Pq08pVjzQCtrwgahCnlGNDmsflpYw7yyGGkXHGf7
         fxO6q8RmtqHM0BAzQ0PfrNnfqhbCMmkV+IDLD5vSLOiRJNCkiMxqfTH4raPrFE3bc1AS
         fleqFJKcNsHVPX+apQ0C4QRkI7jgZ0an15ZwZIjEZd+9GBKAk/SaWcdb5mqOdB8FMs+G
         K+X+T2O6EwwjYpSZG+tsbV9F8AeN0CABuSBS8i81Gjr+i2IqGLJGB8Bm47MUhbb+L9It
         kMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146983; x=1773751783;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p112r6vXdhUi4U6D+bqdMKbRGwHW3a/qIYzeua87t30=;
        b=JBQa49040zY4uriqCekI85lgWOrOuhYkwOIZbwmRDX8HeMiOA53GFktJm5ShZfmJ9T
         D9So31yly+lGpIRTPv/JN/kNM+CKHFoLtULGQmFmZxFDLUqJg4XKJUI/S3hLKq7DXsyY
         /hqqgh7UwqSD0wcfo6UIW4TdRWJwnF5uBLdGxVYbivXYAHIesW7Gls2oeeZ/qwDXZ5BR
         YKnoAlNKsbeuFooBAc3vfeggvliPMx4QBUQj0RQoaovmN/6hrlbU4gWdNz0pbfLUayCF
         LWZHrfYLeiyEEOJ1Qm9WxZRRPNK8Cf6w5EqA0W6ciFvdJud+DcmjRLL1Yp/4TtQNpP/Z
         zHRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxfUwn5L0Yq9di7MMB4cWErHyZhHR3gouZZKBN31hyJoGwfKlKGpiYKlaP3uXDBZNNtNWZwBA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMQ/XIrW6Srk4Z6bOpZzbSqkHNwy3c/DygsbAGg2zvzsDf4n53
	E30uzfMFL1b7Gw8komhJNyg0XJvD8nxFgz18QZL8I0/4y+GoxaSaXDmRkDem68S2JBLy4EkJTSO
	M4VeUsPmLbFuzUckBEM93+RuGh7OVIw==
X-Received: from wmbfp26.prod.google.com ([2002:a05:600c:699a:b0:485:29bb:91fc])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8485:b0:485:3fe6:2209 with SMTP id 5b1f17b1804b1-4853fe622dcmr81484045e9.11.1773146983096;
 Tue, 10 Mar 2026 05:49:43 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:20 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-2-sebastianene@google.com>
Subject: [PATCH 01/14] KVM: arm64: Donate MMIO to the hypervisor
From: Sebastian Ene <sebastianene@google.com>
To: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com, 
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	perlarsen@google.com, qperret@google.com, rananta@google.com, 
	sebastianene@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Mostafa Saleh <smostafa@google.com>

Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
drivers can use that to protect the MMIO of IOMMU.
The initial attempt to implement this was to have a new flag to
"___pkvm_host_donate_hyp" to accept MMIO. However that had many problems,
it was quite intrusive for host/hyp to check/set page state to make it
aware of MMIO and to encode the state in the page table in that case.
Which is called in paths that can be sensitive to performance (FFA, VMs..)

As donating MMIO is very rare, and we don=E2=80=99t need to encode the full
state, it=E2=80=99s reasonable to have a separate function to do this.
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
index 5f9d56754e39..8b617e6fc0e0 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -31,6 +31,8 @@ enum pkvm_component_id {
 };
=20
 extern unsigned long hyp_nr_cpus;
+int __pkvm_host_donate_hyp_mmio(u64 pfn);
+int __pkvm_hyp_donate_host_mmio(u64 pfn);
=20
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvh=
e/mem_protect.c
index 38f66a56a766..0808367c52e5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -784,6 +784,96 @@ int __pkvm_host_unshare_hyp(u64 pfn)
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
 	u64 phys =3D hyp_pfn_to_phys(pfn);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9b480f947da2..d954058e63ff 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1152,13 +1152,8 @@ static int stage2_unmap_walker(const struct kvm_pgta=
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
2.53.0.473.g4a7958ca14-goog

