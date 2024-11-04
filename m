Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BA02AE90
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727145; cv=none; b=WG1U4KFHCwz5A1y9xWEMS1F8uWyEIuLDQM1+rsVj436SUNrY/0F/vtn2Mql2kmXk4Urq9Kmsxq8fVv2nEHECDW1d2QRXAZriCWCMSu6fu6YlQcwYxpiFJ8aw2CrK11Jic9s9kgiXUhtBPp4Xde2qtef+hbRt5ARg1ZOYMuCpLxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727145; c=relaxed/simple;
	bh=a7E7iuuoMcAM1cFQoN6CJyo0hgjTkoNCThbcK8GYogE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l1SMhM3mmvolbCMdO0P5tNoELV+KbB4F606JTP4PgudK5X4+M6+J78kQR7LXQATXhI0EiUAIypdxWiAm7M7tycdDI9gutgz6M5fmMuNgx/RLj2cH0Es+X8KiOEzc4vIH12I1HawrRkUXRpI6ffIYT94HP5cnv5znYPmP+PfFay0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qyK0+fO6; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qyK0+fO6"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30ba241e7eso7606673276.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727143; x=1731331943; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CVlLw2VsW1NEYgyhjgZsv6w0k6EmJDYLHCvZ5J3b7lU=;
        b=qyK0+fO6zgINBP2l0Xn671ebfzu2VB2qmmvuYAe26IVwOGa5pvj7CRE9e9xEZ4LToO
         iAYrWMMNjJ7mPpTn09D73kohirrv+ZWrDts9MGxaBuv+9R2s38FVtROvqP4y9XC8mu2v
         tLSSqXS7QOGfbbZB60jQHBrfHlysWFb8vy0FfyCDRYwLz17JXSbjRu+HBIGKi6nUYK75
         jMfwF9KMGckgg9HkP24DrK6GI61feje4UgXzCkORWEnITctFDlpsZcEe/iYDIRZmB6Y1
         ABIGmympyNefO2Xvl0KPTM8aFvh1C+fwQAx14vO+MtVCDRF2JCWiRV6Al+lo1oVdNcAw
         LLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727143; x=1731331943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CVlLw2VsW1NEYgyhjgZsv6w0k6EmJDYLHCvZ5J3b7lU=;
        b=D0WY+Iedw+wvoKNvlowkTd6eOM5PfbDsAzN7YWliIhysmsIV7Ox7Xa+ErQHP8KdD1h
         RCdFr/0t9ElxnPyy5PXGBSiZ5e7rhJMtf5wDaHpCOA14qss8MYR8Wut6U8yXUtPmfhWx
         9bFK0F/vC7GTM2pYpcEGF15MG8W0v2TZpBm+NM1tlzF1C/N9pIoYlm6pqAj9QJ61dY+Y
         HysiU0igfeGVfxXswH/RZ9qbCanm8GesQq9i25p8tK1kqqjLVfbCvPfg73jgzUcLZTK1
         rcMGMey/A11jyPax2RW9iywF6ZwtNHq3cL1KFeOS36JumSk7qgd1s0sC7DnvZsjVewfW
         2RvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfVQTvbQzlrmjZOIhNKP4qU/5exP1qMaAzeIKcDZY171tpSdANBSpvko6dNNGRczQhK8Cw0Jk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFS2cgY0i6jrl9hB++WKivl6zRnL/dKR50Or81FEw8EKiUIfsY
	PuO39NJoEt/IMKev+DzZk8aoJSRHO90yxidFvPp6B9vB/EF7pDbvWAsBnJK21CSgcq49RzwlbxT
	X1Huo7A==
X-Google-Smtp-Source: AGHT+IGaIdjKw90MUAD6f3zhsAl5Ou4eqg/HHU1QzYnDITqGlaaCQnGFAV9PmmYFtFHG3tgEwpSpmlOm/Ebd
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a25:ed07:0:b0:e1d:912e:9350 with SMTP id
 3f1490d57ef6-e3087bc765dmr65574276.6.1730727142628; Mon, 04 Nov 2024 05:32:22
 -0800 (PST)
Date: Mon,  4 Nov 2024 13:31:52 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-7-qperret@google.com>
Subject: [PATCH 06/18] KVM: arm64: Pass walk flags to kvm_pgtable_stage2_relax_perms
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

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 6 ++----
 arch/arm64/kvm/mmu.c                 | 7 +++----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 442a45d38e23..f52fa8158ce6 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -709,6 +709,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
  * @prot:	Additional permissions to grant for the mapping.
+ * @flags:	Flags to control the page-table walk (ex. a shared walk)
  *
  * The offset of @addr within a page is ignored.
  *
@@ -721,7 +722,8 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
-				   enum kvm_pgtable_prot prot);
+				   enum kvm_pgtable_prot prot,
+				   enum kvm_pgtable_walk_flags flags);
 
 /**
  * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index fa25062f0590..ee060438dc77 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1310,7 +1310,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
 }
 
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
-				   enum kvm_pgtable_prot prot)
+				   enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
 	s8 level;
@@ -1328,9 +1328,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
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
index 27e1b281f402..80dd61038cc7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1440,6 +1440,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1683,13 +1684,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
2.47.0.163.g1226f6d8fa-goog

