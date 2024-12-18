Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862261FCFD3
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550881; cv=none; b=ApukQwxFcEOGUrB8fTebxXYuxL0nT36Q0wOsxO6/5NNbUMF1t3nmp8TufMWWC3/0T5pPy6GlTH/SIZYU+6qSpWgnW6IZ8zaq3NuKhB/P0b9jAvkORn7JTdfXCyE8DJdMiqB/v0DYqGWkv+NDGmAQ2awoiac/gZj+Q2UFCrjD7Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550881; c=relaxed/simple;
	bh=mJD4yWXbQfCVFxUs++pz/aE19rffZcKbfDbdSaBfXgo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HpV2i8IaiGeO+8DirP4W1EmiaspHgfP04va9uCqUiuamNRoeOizpg532+2TOI5KdsCPYKqX4Gc/GBwzGmli/uqAOjwFubqugjOWqw/bTC5QqoVny2EamWQ6QFhC9/ikzstoUj2G/Kh03uhvATB2SibSMM4QZUNapqV2RSWElKEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gBMboU2e; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gBMboU2e"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa6b904a886so523139066b.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550876; x=1735155676; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/S80FmDYKb1wMSZogthtihTZ2ow/iC1/VbK9O8uYM7w=;
        b=gBMboU2eK/j2J1UP6YXKNWmDvEDi3DqqqH9BLT+c14y7Uqk1Bijt9SEvlhPRVZLkxf
         seEUG8qej0pxQiEY/fAjlwgUPA5n3niIOIHHFoxUmxp+Wz6bQmOaC3OExmBrm3RmBUBe
         FZjCL9RiBVH5/gawiaNIx10ngoMAZC2kuVKln+GKGk1OL01GcBhtYfcbPVGruMpAFfqh
         JPG6lAomRbF793xdKLOsnnFR670fPdqTl3ZALlWbfg40/P1K6Z4kjLaIIjKW0OGm/H9l
         26wnNM0ZDK2mtwXrAKLSDHLhaMcmpIHXpfihhhbm1bG8bx8fg8psFqR13gn0ZuCv5oqv
         z4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550876; x=1735155676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/S80FmDYKb1wMSZogthtihTZ2ow/iC1/VbK9O8uYM7w=;
        b=iLyLHVMjXmRMK/f25s6VTznD80+LsMHF+SkqX1MRgVdclf0EiW6pq5tDUoalvHD5eO
         xevGKRdlCTPF5JXHmKlHOFrNiDk7ZPck1RTZEJK+L8f18oRQaTql3H7Ao60Bh6EztF25
         f4n2AJYMXcw7L6lYM9ZNS80EwiLZV2SuHQuO0tf6pXR2GsKeCl9jzT/a+tSsT9chuka8
         YbisRyjQHOvAH+T5fFk989NHdUwlS3+j1cHhiZCXSFkiBmoglKV/KPTdiB9Dy+2hrZIw
         2Rjlyo1N2I4hWDJMP2oxhd5A8YRSAgJ9YFOUvWvKxGt15RxKoj4O4ecJVOUoybGNeMF9
         bInw==
X-Forwarded-Encrypted: i=1; AJvYcCU5XxQe1SgB2AaYctXvaVSi4bEG5LyxBNQOosFITBy6+foRAimK+vN64OdZTufLM/gTY6nHhek=@lists.linux.dev
X-Gm-Message-State: AOJu0Yywx/XyTgUte6M013VMPcCwOZUwUJqbNStpeSYE2zQW8Z9wcYmM
	/6uoOyRmmVxQ66evVvEUOVTX7EHuo3GN91gLrJIs7oDYRJ+Zt9t6SOW7tOw4MXsrwbKW47i2bbS
	9KSC58g==
X-Google-Smtp-Source: AGHT+IGO+aoiY0pAX0txDmM56AhyGulUG5MWxWr8/SJsqYx74spHn0f9QQj9LlBmJWIaz8dI7mVe/cFIZAmV
X-Received: from ejchq16.prod.google.com ([2002:a17:907:3f10:b0:aa6:c227:374c])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6e90:b0:aa6:8bb4:5035
 with SMTP id a640c23a62f3a-aabf479ebadmr460491566b.31.1734550875904; Wed, 18
 Dec 2024 11:41:15 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:47 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-7-qperret@google.com>
Subject: [PATCH v4 06/18] KVM: arm64: Pass walk flags to kvm_pgtable_stage2_relax_perms
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_pgtable_stage2_relax_perms currently assumes that it is being called
from a 'shared' walker, which will not be true once called from pKVM. To
allow for the re-use of that function, make the walk flags one of its
parameters.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 6 ++----
 arch/arm64/kvm/mmu.c                 | 7 +++----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 38b7ec1c8614..c2f4149283ef 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -707,6 +707,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
  * @prot:	Additional permissions to grant for the mapping.
+ * @flags:	Flags to control the page-table walk (ex. a shared walk)
  *
  * The offset of @addr within a page is ignored.
  *
@@ -719,7 +720,8 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
-				   enum kvm_pgtable_prot prot);
+				   enum kvm_pgtable_prot prot,
+				   enum kvm_pgtable_walk_flags flags);
 
 /**
  * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0470aedb4bf4..b7a3b5363235 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1307,7 +1307,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
 }
 
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
-				   enum kvm_pgtable_prot prot)
+				   enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
 	s8 level;
@@ -1325,9 +1325,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
-	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
-				       KVM_PGTABLE_WALK_HANDLE_FAULT |
-				       KVM_PGTABLE_WALK_SHARED);
+	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
 	if (!ret || ret == -EAGAIN)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
 	return ret;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a2339b76c826..641e4fec1659 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1452,6 +1452,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1695,13 +1696,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * PTE, which will be preserved.
 		 */
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
+		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot, flags);
 	} else {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
-					     memcache,
-					     KVM_PGTABLE_WALK_HANDLE_FAULT |
-					     KVM_PGTABLE_WALK_SHARED);
+					     memcache, flags);
 	}
 
 out_unlock:
-- 
2.47.1.613.gc27f4b7a9f-goog

