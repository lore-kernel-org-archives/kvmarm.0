Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F359D3A9D8A
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805768; cv=none; b=tXBWHWRSIfBK+1TNiE/PRHLyJ40tZ2Bmcb25zjcOaEKle85hF1D9JFPyjpRnZdKgakiUiGeD/Fx/Vj3viAqJMJ30+WhD4Aq3FCJzXvI3IMGjS2W9xtShVLE9tfOByrHXBuvO3laTA+5sFhUk32e6Nfqk0RiFNW6+P4anZlWTiB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805768; c=relaxed/simple;
	bh=h1PHct1x/stm5rxYiib9C8v7vw/FQ3/w8rGWdwn8hBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A/JOrlAHJbNdIDZfDoXumdNWVmh01UU7Awr+7FC5Zmctglcld7BaXx4NaI8JgCLHigNlB6pE3nkHWyLYcM6Tg2fmNv/5qJeWwoRBvYBEeLOo/5i3lHTU6QNpEqwegsEJ9kyRfps6TsXoyaoOoxib2etTEVynBfXYItMPk6GtNj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YNk5NNff; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YNk5NNff"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-661420734b7so3068339a12.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805764; x=1773410564; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qBDvUPOUvZlIighyaRp+5oG5fBA2IhyoxKOHVs/vQh8=;
        b=YNk5NNffg4KQQ6MV32q5pi+2A3V5RKdEzimG9S4fES0lGTTxioCmK/eKkpD3ZieK1B
         plrrjhuy4h5B+UmAffO4kGf9MU9uvLkXp+y2MvNzlenrB14u+PxGnT0qlnfgds9FWTXI
         WzVAjcguK22miz0fYpCVaph/ysX7ap4qEURYXshu7o3ZpE5RIKlg9rxq2z5ptArsX5Rf
         9HpfuOufxkGm3PNJZK67CoYfq8pfrpuBsxXmuUdCgkBAWj1ezTZZrC7Lk4bwq67Jzwl8
         2DIYaHINKIWcPD/SvVg5MbgjwSOw0CyfB/NY/u29AmMwR3CiQs5iA45Cbb34rWCeAz1C
         0hUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805764; x=1773410564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBDvUPOUvZlIighyaRp+5oG5fBA2IhyoxKOHVs/vQh8=;
        b=t+Qjlw5Kow+GAbnC/Y/3G88obqRZVjdsMfGM1g17E0l0bkh7AjTpbMDRep33lh6qh+
         mgGoOEeFultA2Fz1Xl2fK2YkAdOLVmAB7dZCUGyx1jVTErGBEdzrAVHdW6+yz9v68HiZ
         NVGCahq/OgaXK0EgiURsS9ypmi7R3x4dqWIG8A3JKOB/Z3z5AXoKyIkLcCllYfW9XrJT
         3txKpnVns9NeH7DHNke+EOrl2tk2l+NjoHl5v207qc5si72LB4YhBZN5qt4L3gj0noFG
         jAwihBg6iyVkFnIfKEyRk6VE81JOBgiHt4WmXt8FW4AqsIJlu5h03PSPpFU2JqzktUUY
         GWGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJgc9UuMjlW1nU2y+CmPEgoSxWV2+2aL6EAjagsQCOCb4qg5fw1aKgkl8baO16pOOQDH1G5fM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzttn3xLchGkmnI8bddlijuYz+w6h6u47zFAeUEjVMqMBdE8Z1C
	mKHu7eDAoy9jwrMhdlVt43bELvj+XspjcBqe8cTn5xbWLd42rJItcdzN+N9JabXmYbsQl53z2yI
	p0w==
X-Received: from edev7-n2.prod.google.com ([2002:a05:6402:a2c7:20b0:660:afb7:89d6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1d4c:b0:658:e665:766c
 with SMTP id 4fb4d7f45d1cf-6619d46826dmr1250580a12.8.1772805763972; Fri, 06
 Mar 2026 06:02:43 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:27 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-9-tabba@google.com>
Subject: [PATCH v1 08/13] KVM: arm64: Remove redundant state variables from
 struct kvm_s2_fault
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Remove redundant variables vma_shift and vfio_allow_any_uc from struct
kvm_s2_fault as they are easily derived or checked when needed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 090a906d3a12..01f4f4bee155 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1721,10 +1721,8 @@ struct kvm_s2_fault {
 	bool mte_allowed;
 	bool is_vma_cacheable;
 	bool s2_force_noncacheable;
-	bool vfio_allow_any_uc;
 	unsigned long mmu_seq;
 	phys_addr_t ipa;
-	short vma_shift;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active;
@@ -1749,9 +1747,9 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 		return -EFAULT;
 	}
 
-	fault->vma_shift = kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot, fault->nested,
-						   &fault->force_pte, &fault->ipa);
-	fault->vma_pagesize = 1UL << fault->vma_shift;
+	fault->vma_pagesize = 1UL << kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot,
+							     fault->nested, &fault->force_pte,
+							     &fault->ipa);
 
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
@@ -1764,8 +1762,6 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 	fault->gfn = fault->ipa >> PAGE_SHIFT;
 	fault->mte_allowed = kvm_vma_mte_allowed(vma);
 
-	fault->vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
-
 	fault->vm_flags = vma->vm_flags;
 
 	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
@@ -1796,7 +1792,7 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 				       fault->write_fault ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
 	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(fault->hva, fault->vma_shift);
+		kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
 		return 0;
 	}
 	if (is_error_noslot_pfn(fault->pfn))
@@ -1874,7 +1870,7 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
 	if (fault->s2_force_noncacheable) {
-		if (fault->vfio_allow_any_uc)
+		if (fault->vm_flags & VM_ALLOW_ANY_UNCACHED)
 			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
 			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
@@ -1978,7 +1974,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		.logging_active = memslot_is_logging(memslot),
 		.force_pte = memslot_is_logging(memslot),
 		.s2_force_noncacheable = false,
-		.vfio_allow_any_uc = false,
 		.prot = KVM_PGTABLE_PROT_R,
 	};
 	struct kvm_s2_fault *fault = &fault_data;
-- 
2.53.0.473.g4a7958ca14-goog

