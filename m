Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5573C22EE4
	for <kvmarm@lists.linux.dev>; Wed, 24 Jul 2024 01:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783483; cv=none; b=C8jVtcwABziBGmdh9fefbHz5Z0e16HfVYehl675HiqZbhNUzym2iBHV+xgAeAAS87roXTAphVyYJtMSKPWXtMzBbdEi1HCFhUx2zz7p1nnac071VKNe8JU8m29m52ucOGRBnBUESFFpquKN4CUR7OQsv1YBz/y9vbHGnTtNH5PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783483; c=relaxed/simple;
	bh=GzvrAe/cY3CTCsf2eL2JXn03bXEL3fKmbljP7UMpANQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FFP94dyD8WJ7g3sFguQtuGdNe+Ju2TnXFLpSuhCwn5p+YJeaUVcg8zg+pTQsPFX8frfNmhgOn/yt67YLEC2b8UtqV/lhvBB97AMbVAHHMC+mQ178Welk2HcPFSMvm1R220Rg7D5NKAYRRqPvm97MNRIp2OvUbPKKqhKQpUog3yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=enDt1Su/; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="enDt1Su/"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-672bea19dd3so3556567b3.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 18:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721783480; x=1722388280; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JW+jUUoqcXqadXhonZGbNsXZ7+Zma3rlwNzyePdiaMw=;
        b=enDt1Su/OcGcpfOCHk8BG1DuKernt2KklWFWSBHACX0UlweSoO79ZUF1g/kxAP8DeF
         LtMfbXaS0bFMnQ0Yx/T2gWjgi49bUqBwliWwiib6GrbBYBne6Im0y10uqfWeSKUvzIlN
         XTk0KwedoUmiP9U8S74lfP6X/Hnr3oeTWH+ljSSvuS61Xu5/8HX25ZgeDT9xKjVJvqq0
         3FuYPxqVvECK0XJkNlYRqsmMwzIOTTUWhOcbafhCHN39+vMlVi1NcZeMOBxaoBHNy26V
         gCgo9XC8OebYlmfRlq86ANhq+kOJqeiUyQREr5ieu5kMm77KHNuxWIhWYm18m/X/RkIo
         dYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721783480; x=1722388280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JW+jUUoqcXqadXhonZGbNsXZ7+Zma3rlwNzyePdiaMw=;
        b=HZBTF/RiLRV7QT4VWH5xFphfNrso0QXKCZ1y8ksXIEC1SQqkmKacYTEpwkWGDUSsO0
         KTv9+9p34Q6UPtmF2QhBV4W+b6xcQ3z6LvQ3tT8D9Yn+vxWjLLfK2STmbHiul6aSZ8Ug
         2j8h590QpHZC+sIMF/1pcSJy9Q2/hzsdkV3HKaHJzB60yCCTq7hiHtSHl3oFw040tgZj
         0iIZ5PwqhoV9YfPHQejFobXLeAc1fKMtieja8DFrorXOl1a3+/lJrz572Wn8OppRIkbX
         SHumgMoCOzFkZ375x6KB+mVcC+c2RTI1kpzvq5avw9e6moHrwI8jiSXgSk/oEnapaxKh
         M87A==
X-Forwarded-Encrypted: i=1; AJvYcCWtZjETaYeLivUbQKBVe/0ctS66fYtIgunlrGvdcHpAAtOXTIrg8J9GC+INn7MrGcBZRSQxkO6WsCsSehClBM2FfFRBHTwL
X-Gm-Message-State: AOJu0YzBmC0LSNAcytjKlHCTPPfV5mgKNP6U+kigr0tFIJr7hqNAjKRW
	wB59EKiGAKbONfYpXhyfEUpfMCLK6WDwLaYWMxca4pvnfjDkm4MI2AaQyqiioVtUUqXHwgyDgpa
	LwBYvKZo6eAQ+9QCjpA==
X-Google-Smtp-Source: AGHT+IHToUjK35hNR0etsZGQeAjUCPxr50Jqta5Si1cnS8NseXl88g/0Ew0GUmmAUp0HML6hFdfWagbQP5rsIFm/
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:102:b0:66b:fb2f:1c2 with SMTP
 id 00721157ae682-671f4e0a6damr821967b3.7.1721783480393; Tue, 23 Jul 2024
 18:11:20 -0700 (PDT)
Date: Wed, 24 Jul 2024 01:10:33 +0000
In-Reply-To: <20240724011037.3671523-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240724011037.3671523-9-jthoughton@google.com>
Subject: [PATCH v6 08/11] KVM: x86: Optimize kvm_{test_,}age_gfn a little bit
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the
shadow MMU by, rather than checking if our memslot has rmaps, check if
there are any indirect_shadow_pages at all.

Also, for kvm_test_age_gfn, reorder the TDP MMU check to be first. If we
find that the range is young, we do not need to check the shadow MMU.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7b93ce8f0680..919d59385f89 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1629,19 +1629,24 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 	__rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
 }
 
+static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
+{
+	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
+}
+
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm)) {
+	if (tdp_mmu_enabled)
+		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
+
+	if (kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (tdp_mmu_enabled)
-		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
-
 	return young;
 }
 
@@ -1649,15 +1654,15 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm)) {
+	if (tdp_mmu_enabled)
+		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
+
+	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (tdp_mmu_enabled)
-		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
-
 	return young;
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

