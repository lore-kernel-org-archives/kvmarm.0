Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599483AC28
	for <kvmarm@lists.linux.dev>; Wed, 24 Jul 2024 01:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783484; cv=none; b=lboWfF/yC30VMRti2vRo+bF9bYdcbsr18Us0L4MhRe/pZ39XgEVyjWbWALAS4QsgY79P9bVdAqGiqTMEN3v1O0jIW6qP0pstFfTt4Ek7hBpAi1vBA35ehRUCjCjtCnsduX8KOPQ+gbTxPdQJN+oQ0Nm02Ksh9vHuoKunivg2A3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783484; c=relaxed/simple;
	bh=ELbOSXsn2tl30guokJCMMpH45tyd+sOPH2P1Gsg+Zxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jyj5UDCAEgN/t6PjsUnjTNtqomm8J8j4wiU0L0mvZqVMFTMxHg0pjCz2Y8nYY0Fj2X5o+j9xFuD85rWjCpdm7hr+TBF4ui4ic/tRH+7+0lXqkiSV7z4362H+UmG7LFGYjT0WKTT4UfFNmPXtbNkJtjT9a69AEfkyrypiPa/sEvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mJUesfhC; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mJUesfhC"
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4929e47ae28so1414325137.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 18:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721783481; x=1722388281; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P6265Vr7ZBVKTm4Fxp+PtFVTNDBMV13LE1gmbTEV1Oo=;
        b=mJUesfhCBM4SB7uwNAXrcLQ354igkb6pB8n9MxfQMm+Dj6O1smYJ63VY2pSkaHjCP4
         zsX8llbyZjnz4VDTP+eO/TOtdiVnwESkHK+blFyn1l3pJUs8chyeOIz5a0ztS4liqIT2
         rL5E803NGMsNpIE+lSZ3F2cWfEdRSkQo4CH5k9zz2rpkjka4hzwaqzTHPgOqBqEpptUx
         JLu7OkmJ6dDjv1RxdxlFZzQVGXxut1ahsn0ovoKC1iRk+74wjwJiNYCQqf98Fut69E+o
         kFbeF5Qr4H79mrv1+PFIOjfPYKvcr49TuIe78J4B0oBabH1rKRLGH23+Wn5s//8wKE/o
         rs2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721783481; x=1722388281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6265Vr7ZBVKTm4Fxp+PtFVTNDBMV13LE1gmbTEV1Oo=;
        b=WV51yXIiZYD4pmkyq1eFRVhaKjuwuJVEBA2m/Dc3Spl41LK1uNJxIsopkrGVVghIrx
         1JDyeg+b46WGySlJCZZ+DCVimLhb/l8VTKkSdGnYREwEjmFGlqoqZua1I8aqmMZsMjfF
         P8AMwOIFYHp95HGdgOoqDv/jNW08MLM4rn6Zz6hXg4kusL/bSZ23YbDDNxZE0vkYD2la
         X0T06rQgUIqUACRWxsHLRHpbKwR79SC89mgQL7U+1hDujKh5cAufsn6Pb6LomG4Vf/uK
         99yucZqMQ/tO6fBkFc/S/vTmHpSiifYG0a3C7z8zqa4ahlZQl4IZ7Bo4toQQyKIdrhis
         BfEg==
X-Forwarded-Encrypted: i=1; AJvYcCVdpSWW44+QgXX9BaTcwR7i/UuFPOGwcvNLYFKe8q8sS48osFypUGsIi1/ADn+QzgCeMm+za8qo6K3oqJnfyXg1PZ5s+wGo
X-Gm-Message-State: AOJu0YypTpclD8Jtt6Gv6FOmnb4Hs8qiOckWDEGVFE4jANON2pNHSZOK
	xySy0vdfn0l3IAbTGS4azXunLsHVN1AKlmlxJWE0Q2dJrTOrmv5PyalVzEs7N7KK+dEXAqC6bZX
	2WPtl1jpG9shagHAQQw==
X-Google-Smtp-Source: AGHT+IGFz1kYjtJ2CB63i3kpIK8cbKQBNz86a9KHHAO5xzKcY+Rn5KgcFneR9rdE9iF/27GJgdzSYep0JZHDL1qb
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6102:358f:b0:48c:403d:4428 with
 SMTP id ada2fe7eead31-493c4b17e64mr40150137.4.1721783481412; Tue, 23 Jul 2024
 18:11:21 -0700 (PDT)
Date: Wed, 24 Jul 2024 01:10:34 +0000
In-Reply-To: <20240724011037.3671523-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240724011037.3671523-10-jthoughton@google.com>
Subject: [PATCH v6 09/11] KVM: x86: Implement fast_only versions of kvm_{test_,}age_gfn
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

These fast-only versions simply ignore the shadow MMU. We can locklessly
handle the shadow MMU later.

Set HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY for X86_64 only, as that is
the only case where the TDP MMU might be used. Without the TDP MMU, the
fast-only notifiers will always be no-ops. It would be ideal not to
report has_fast_only if !tdp_mmu_enabled, but tdp_mmu_enabled can be
changed at any time.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/Kconfig   | 1 +
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 6ac43074c5e9..ed9049cf1255 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
+	select HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY if X86_64
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 919d59385f89..3c6c9442434a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1641,7 +1641,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
 
-	if (kvm_has_shadow_mmu_sptes(kvm)) {
+	if (!range->arg.fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 		write_unlock(&kvm->mmu_lock);
@@ -1657,7 +1657,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
 
-	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {
+	if (!young && !range->arg.fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 		write_unlock(&kvm->mmu_lock);
-- 
2.46.0.rc1.232.g9752f9e123-goog

