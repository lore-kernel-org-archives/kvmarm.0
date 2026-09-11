Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6ED486B8F
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134679; cv=none; b=f+K2q61dEVs9LjethA3VksshBmQ+3O8GQFN6OWhgkWF+SW7y0cvXO+yhH7UTQu5Ao4bp2K9yb1gB2iJZKCIrBX9eXZt3ErRlCvv10ye5mjdNPs6qRLY2wbCI6EYu36YJfXqnqPa8Nq7SIDgTNUrpaoXiS+OkHGtJnlUiyBC1wQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134679; c=relaxed/simple;
	bh=ZMmZWuGFN4WrASq0DCbrl5Prikid2rPBYBSUJBsEEYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CJuRRstcBis8WHMwZ4w1C4FrvVrlg2gD3IgEyZp+PZY3tzfL+BQoarv+ECtUUPj/DCgcGLY3LiTWSPgjIuKwzpvUNsC54aqF6R/HibjPNvl2EBgJ6G8ItSa+dRAavjus8YKO8UiJYAyTOUME1PdGiJaywRpoWHzo7YKdMkgCUiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vICeI8Ah; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vICeI8Ah"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1c4715cf0eso79858566b.2
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134676; x=1789739476; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FmITuOpAyp0txJ9LywM67xGVsoOppp+O+NKFqqQhmo0=;
        b=vICeI8AhxCiaYJfnEQnEUBggkN2kBUtcCCicVIGbQjMvnNEuV+iWeY2X2W2+g36itt
         h7VHg+vTnR9I4z/MKWtN6DCe4fscNuonCJVkr7H9VgErLPZxlQ+adZrmgsyDnze6rmU8
         j6+WihyIBuH3a4lNIEqH9UpcHV/FxyHwdR7oLyvWJT0p77ZTnzQnosGxNhq8NVOIg1CR
         MBMTK9TOzoiwR449R6xHnosgaju/4siZ6owaSaahu/YBzIVWyhUf9BIXv8XNSY0feCc1
         wQvJdtiVDhgUTJPbhlk779g3cf+XFwO296tU6cL2pe54eOsJ+TgVTZnAsfdcigB5bVFm
         lEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134676; x=1789739476;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FmITuOpAyp0txJ9LywM67xGVsoOppp+O+NKFqqQhmo0=;
        b=C1W1I7X7hHnx1Sk8oidp7bx14rFURFBahYXYalJwisE2RJ/wge/vZfq2ufCYkBnnwF
         GslsUyYyXu2BOA8Kd+DM4lg7YpSHzZm9oLpcrahZ6/Ao9shvcB+tSzx95W5EbNxYonXU
         0iS38kcxMHSoVXbvEDnTvUfuhLCIK+MGsoRjq2PF3u7wDlNf/RlbR97INwma/vN19Z7H
         w1cjG2Ob4DZk+6KpmB6QpQl6Fwef5qMwKIsvr3lu/irLYJ6YYRlcD+DTTdM5p3xvFn64
         ZueAWxf9Z6G6FvAMuW89Lgo10+Y3a7sxbqgc3qH/yK76PxvSDTwQtQNQX72fqoLbb86G
         OENg==
X-Forwarded-Encrypted: i=1; AKwUvBwC24QYRzEwuLAee14d74qsL8z7pPthUsLLHmJCnbTRTs50dVZmfDd+X0z8nqDtovgERgcjFvk=@lists.linux.dev
X-Gm-Message-State: AFuF++mgfDmLm5wU7gvzZjljFDumIDG6YXT6JFemmtBrmF80jlkMpDl8
	zIKXy+GPrPHYgu7Q6rI4tdkbXWvSgXAYEfBbkwZ3BcVZhyOVQlmCMHUbMlH8pNh1G8ATQOjpYHu
	QQ1xL9fSybEGJGfEyr4rFVA==
X-Received: from ejoy6.prod.google.com ([2002:a17:906:4486:b0:c29:4be1:5ff0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:874f:b0:c26:1649:47a8 with SMTP id a640c23a62f3a-c29666bb6a7mr174063166b.30.1789134675826;
 Fri, 11 Sep 2026 06:51:15 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:43 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-13-vdonnefort@google.com>
Subject: [PATCH v2 12/22] KVM: arm64: Handle huge mappings in __pkvm_host_force_reclaim_page_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
allow __pkvm_host_force_reclaim_page_guest() to work with PMD_SIZE
mappings.  As this HVC is called from a non-preemptible context, it is
not possible to rely on the host pkvm_mappings tree to get the mapping
size. Instead, use the actual host stage-2 mapping size and compare it
with the guest stage-2.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 33 +++++++++++++++++----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 7e6882ce51f6..674159736495 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1317,7 +1317,7 @@ static void hyp_poison_range(phys_addr_t phys, u64 size)
 	__apply_guest_page(__hyp_va(phys), size, __hyp_poison_page);
 }
 
-static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
+static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_hyp_vm **vm,
 				      u64 *gfn)
 {
 	enum pkvm_page_state state;
@@ -1345,34 +1345,43 @@ static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
 	if (ret)
 		return ret;
 
-	if (WARN_ON(level != KVM_PGTABLE_LAST_LEVEL))
-		return -EINVAL;
+	/* We only support either PAGE_SIZE or PMD_SIZE */
+	if (level < KVM_PGTABLE_LAST_LEVEL - 1)
+		return -E2BIG;
 
-	return host_stage2_decode_gfn_meta(pte, vm, gfn);
+	ret = host_stage2_decode_gfn_meta(pte, vm, gfn);
+	if (ret)
+		return ret;
+
+	*size = kvm_granule_size(level);
+
+	return 0;
 }
 
 int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 {
+	u64 gfn, ipa, pa, size;
 	struct pkvm_hyp_vm *vm;
-	u64 gfn, ipa, pa;
 	kvm_pte_t pte;
 	int ret;
 
-	phys &= PAGE_MASK;
-
 	hyp_spin_lock(&vm_table_lock);
 	host_lock_component();
 
-	ret = host_stage2_get_guest_info(phys, &vm, &gfn);
+	ret = host_stage2_get_guest_info(phys, &size, &vm, &gfn);
 	if (ret)
 		goto unlock_host;
 
 	ipa = hyp_pfn_to_phys(gfn);
+
 	guest_lock_component(vm);
-	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &pa);
+	ret = get_valid_guest_pte(vm, ipa, size, &pte, &pa);
 	if (ret)
 		goto unlock_guest;
 
+	phys = ALIGN_DOWN(phys, size);
+	pa = ALIGN_DOWN(pa, size);
+
 	WARN_ON(pa != phys);
 	if (guest_get_page_state(pte, ipa) != PKVM_PAGE_OWNED) {
 		ret = -EPERM;
@@ -1380,14 +1389,14 @@ int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 	}
 
 	/* We really shouldn't be allocating, so don't pass a memcache */
-	ret = kvm_pgtable_stage2_annotate(&vm->pgt, ipa, PAGE_SIZE, NULL,
+	ret = kvm_pgtable_stage2_annotate(&vm->pgt, ipa, size, NULL,
 					  KVM_GUEST_INVALID_PTE_TYPE_POISONED,
 					  0);
 	if (ret)
 		goto unlock_guest;
 
-	hyp_poison_range(phys, PAGE_SIZE);
-	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
+	hyp_poison_range(phys, size);
+	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HOST));
 unlock_guest:
 	guest_unlock_component(vm);
 unlock_host:
-- 
2.55.0.1007.g17ff1f9808-goog

