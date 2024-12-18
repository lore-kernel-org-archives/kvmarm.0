Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE8A1FBC97
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550878; cv=none; b=rSBlkmOzEwfv5Ol2RwHesJQu7AiGFdWOkb7YFHVg0pU0f/XsOnNrRNQ4dMSZXVqDBGT9HIG5rAj8PDJ+CQFQyPIxeZ9qEh/wQbM1lVYHV3vXzFQKGGl/T6K2P2kCtZmqo6yINTsLgaAmjQOiMreHifxjfC6DFE/27Gwa2wTUZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550878; c=relaxed/simple;
	bh=7AIESUw6mMSUJQCn90MjLz83oGJmTgjvjEJnEGpsPuE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QVknOL9s779FQ0iMJNq59tf5mp18XBdOqWdErE9AEKzjjXa90POyyQLuJ7/o4EVyX6NrrSfOxN1fTHrJ334do/kBaRNK1Ocju2XTXRlJHqSh9/A2+Wg+FRCt7dQibmub9uE+fRjb2usZQb5HrJEvRhxRojAu2qm1Gp/0nP8p3TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hape6/pJ; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hape6/pJ"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3e4e09ae7so8220945a12.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550874; x=1735155674; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ugxEmd7a7WnD5rzj6dcj8iKmGlwGaXKl0uKILMdDIg=;
        b=hape6/pJMr00bBPizgINTyrK6a4Bcl0MxHy0IWkvcgxVYB1nKDZWf0ZLyWFX0SMjOA
         uo77C0iYmPxzNiO/brsf/od1PV8asX6RegVbT1R68Ckdo7/eP8HZB3pV5I5JA2gaVOqN
         gWWLaCOrVMZMIM9d42Yj+DsuIT6MpsOW1UuuvBdY/PXPPNF9yQtSDCv6223RqPvGWTWt
         TtDbx9RnODOxQJJXmMFlnqLHTCBVg2QBx+tugeJuRX9/24cuGocdO32eSeQAYrPAQwuo
         1Ilun0grghfc2gQh3s5KPSGyap5ZXxUrLovKZL8z8o3W4GG/Nb3piFIJlJ+o0KSnQela
         UIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550874; x=1735155674;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ugxEmd7a7WnD5rzj6dcj8iKmGlwGaXKl0uKILMdDIg=;
        b=ESQn5ZF03Rp+izlGGGzaFmHMyvHL2BhSBmS1jFwkTe8GgXr+kyWLmSUz8KFtrCmjiu
         MwOAUSl4tOCsQhEQnxXqlvJX5r4kP5sTQl/HLe8aIHVEb/Gtj6wFj1H4GDHYaS6QWyhj
         YGpZMfSu77v+jloXXMvlbTT4Am5PwZxmKKAs80RJOctYGVQZKWzP6S3jrtWQda99H2ew
         edwyYLbqIzrT5L67jqTfZ6v9dXhWgquGI+hicVfuX4dHiCkstEcDACR/R3CQuPJPpV1n
         PdHXh2hSCnk61b8KFy0f3Wq2gei7mf+Kj3u8gxC0x2UouS8+c/6d+2JQPmCJbJ81V4AO
         tKcw==
X-Forwarded-Encrypted: i=1; AJvYcCXAjY8VQIISysW+WJIPLNHP0fNc26KjMC060CpeUrEuYUcU9x4r6ApunXgJf17vOYwL0wWkTV8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfX1WIU7QxZQ4PmjJoCE6mWNfHFp0+fNw7bCUSigQrHEKcqSOI
	7IthJwCY2rgxgd3/pcI5gfQihKquBlynCde3EKZePvafVAbYYFi7Nu7uWR+tYt1GQz9WQ+r1TUU
	qa7daLw==
X-Google-Smtp-Source: AGHT+IFvLhkomwPsLLt4qoep3Va3P5u4/FTIVyNItlHOLlhdPmQivj6hJV4NPzFeQBdz1XX18dDRWVuBUpaz
X-Received: from edag5.prod.google.com ([2002:a05:6402:3205:b0:5d1:21a6:f033])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3584:b0:5d3:cfd0:8d46
 with SMTP id 4fb4d7f45d1cf-5d7ee4242dbmr3825137a12.30.1734550873767; Wed, 18
 Dec 2024 11:41:13 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:46 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-6-qperret@google.com>
Subject: [PATCH v4 05/18] KVM: arm64: Pass walk flags to kvm_pgtable_stage2_mkyoung
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

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 7 +++----
 arch/arm64/kvm/mmu.c                 | 3 ++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index aab04097b505..38b7ec1c8614 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -669,13 +669,15 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
+ * @flags:	Flags to control the page-table walk (ex. a shared walk)
  *
  * The offset of @addr within a page is ignored.
  *
  * If there is a valid, leaf page-table entry used to translate @addr, then
  * set the access flag in that entry.
  */
-void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
+				enum kvm_pgtable_walk_flags flags);
 
 /**
  * kvm_pgtable_stage2_test_clear_young() - Test and optionally clear the access
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 40bd55966540..0470aedb4bf4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1245,14 +1245,13 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 					NULL, NULL, 0);
 }
 
-void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
+				enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				       NULL, NULL,
-				       KVM_PGTABLE_WALK_HANDLE_FAULT |
-				       KVM_PGTABLE_WALK_SHARED);
+				       NULL, NULL, flags);
 	if (!ret)
 		dsb(ishst);
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9d46ad57e52..a2339b76c826 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1718,13 +1718,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
 
 	read_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
-	kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
+	kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa, flags);
 	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
-- 
2.47.1.613.gc27f4b7a9f-goog

