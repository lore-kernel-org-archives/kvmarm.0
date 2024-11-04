Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4F3137C35
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727143; cv=none; b=FP9J1kZLVOGlp/bg+Vn9ZxV/VcExI9Pq5X8yb4Ufkd+NmrhI3Qz+WAbWkCFdzAhgMHqC3gN0xdwqKJOxXJD4z0clrnoyKuch5hK/2YLxvtWWI0JrNmYlf8g9fk0qKdiHgrao8EbBlNyCqjobBIHFfhv1//dW6yrinhmXDhD7kuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727143; c=relaxed/simple;
	bh=8Ka3uHmCTynLgF2f84rI4B+GMS/jz9B90udr8d7Wndo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VoPwzctTu2f40+ftT85eSpsXjWozM97E+nziHzuDjda3FA85PK81eYMULUmrZ+lJA50f6AObNTEnnCEPNLy/3j8XaEwmHrhXi6SvQTh1UDF+wPIyY6OgA32kWD2WQ1jAbq2CqfyVXSIY4vxfW9r65hJ5fN8T1uGoOY7b5znsy+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yMrcspZV; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yMrcspZV"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a9a2c3e75f0so301284466b.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727140; x=1731331940; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zp5y0+Rq0WHrDia4bvFK9Du9WgLZRQc3oKl++fsdJMA=;
        b=yMrcspZVqhujfrryhzjYRy6aIEfw02vMix4oHCvLiypbD+WK5/3xK1xXWDQFpQT8YW
         /w5XdhzA1YH91tR7SSX8MaTJmQizANkrHgWRF0q68SjDvRWdeGNxeRiP7VHvM1R8Ks10
         HOD8BjSLEebb6rA5YF5+AnLaj6fnnaF6+b7zI9CL0PAj5yQoFApBVAVsVvY/z2Lxqey+
         qgUotR+UWOk7Q+JDBx1pw36vcTi7Ej5pOPypAEpI+c6MI66SBTy7hlPHZTLp6WXMAvnd
         DWSzgU7Czvh3tGx21sniclAl72cZ33UO3eAqAw0ABHHnUgK0dTRb1njrHxgS21RSJh4B
         R83g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727140; x=1731331940;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zp5y0+Rq0WHrDia4bvFK9Du9WgLZRQc3oKl++fsdJMA=;
        b=EUQTjc03TT9b7WmaIhaRyLy5HuIe9XG69+6RtqchR4/Vdm5Ax4WzDdH/zDKHdfJFHC
         RStk7+v+3ziYwdKvN7W485N28o4BYd4GzJV8v8A8Mk2Va6BdQwoOeb2e8PEhUzbX8A5M
         /3eCyd6HirKnZued3vP2Sh2bKO4MRA9q+soUvkhZFxVRwuOcI4bH9QRfapnBPlDV0yRK
         epPEU2i5GPcmemwMNrjDDClXvw+e7Z47HelFOZjjbRbeWZU0VMGBomJHU+MWvhSxH10c
         ZngR+lAnBpoyWTHn0kJ428FBRuV7EvXK7Sc8mheaJbfrjDSrtuBpY4ev4sm4q3EjwteV
         HP8g==
X-Forwarded-Encrypted: i=1; AJvYcCXWn3SklCeCu5cD1a82h97s/x3ea+OesuuDQJmo7aoJJGrdXpJLAxSWxaN8haPHHLy3peBlu90=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFSgFkGR8WW3N9Br5ny0vbpFX2eFFZ/Faskd1xOGvS798Nrzpd
	5QlXPrq+C9cv5+UzLfJhoX9E+7DFZ4WSWvRxbmc+EPpGthTj699rgsSdAfyqZgNbYYEnMVWifYS
	TLEcqcQ==
X-Google-Smtp-Source: AGHT+IGu3UcssODTNd0NubVJlZtWwwslOS4Fc2l45eu0iucEanXM8xQBrQzJXKGVO4SXDuAu4FLnrjRPKE4G
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:906:ca0b:b0:a99:f617:af50 with SMTP id
 a640c23a62f3a-a9e6581e0ebmr285966b.10.1730727139947; Mon, 04 Nov 2024
 05:32:19 -0800 (PST)
Date: Mon,  4 Nov 2024 13:31:51 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-6-qperret@google.com>
Subject: [PATCH 05/18] KVM: arm64: Pass walk flags to kvm_pgtable_stage2_mkyoung
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_pgtable_stage2_mkyoung currently assumes that it is being called
from a 'shared' walker, which will not be true once called from pKVM.
To allow for the re-use of that function, make the walk flags one of
its parameters.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 7 +++----
 arch/arm64/kvm/mmu.c                 | 3 ++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 03f4c3d7839c..442a45d38e23 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -669,6 +669,7 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
+ * @flags:	Flags to control the page-table walk (ex. a shared walk)
  *
  * The offset of @addr within a page is ignored.
  *
@@ -677,7 +678,8 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
  *
  * Return: The old page-table entry prior to setting the flag, 0 on failure.
  */
-kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
+kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
+				     enum kvm_pgtable_walk_flags flags);
 
 /**
  * kvm_pgtable_stage2_test_clear_young() - Test and optionally clear the access
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11bcebac908..fa25062f0590 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1245,15 +1245,14 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 					NULL, NULL, 0);
 }
 
-kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
+kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
+				     enum kvm_pgtable_walk_flags flags)
 {
 	kvm_pte_t pte = 0;
 	int ret;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				       &pte, NULL,
-				       KVM_PGTABLE_WALK_HANDLE_FAULT |
-				       KVM_PGTABLE_WALK_SHARED);
+				       &pte, NULL, flags);
 	if (!ret)
 		dsb(ishst);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0f7658aefa1a..27e1b281f402 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1708,6 +1708,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 	kvm_pte_t pte;
 	struct kvm_s2_mmu *mmu;
 
@@ -1715,7 +1716,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	read_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
-	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
+	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa, flags);
 	read_unlock(&vcpu->kvm->mmu_lock);
 
 	if (kvm_pte_valid(pte))
-- 
2.47.0.163.g1226f6d8fa-goog

