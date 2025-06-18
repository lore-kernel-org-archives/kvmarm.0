Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634A882866
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220676; cv=none; b=hqXIhlnDQn/z4BY2bUZsv0VqUu3utapO7J4J3JtQ+kI3x7xlvAMNOepXCqIHH2K4gf8/GliNBXMCrI00KBzwomy7EL53+A8Ct/Aw32FJ1K+mSBk8t2Lce/e7ih+XLZISpg6FheHNyoECR+HgySy4JGwuNqay5tzTexrhXkziDv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220676; c=relaxed/simple;
	bh=Fd4SdpBpGMWqTpDQtVvgHQNQARLYxNkES4VtDZAj2OE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jrbL1qhDH9LE+60+gvowO+FvebXi8OTZgxJ5K8slZFPKHmMQjkx4m9a8nSZ4Vq8nYb8PLOomiTWJS3vIlHoQeD8eYalH9qeLs7cGDgffc0CJMTFEvH/gcoSccMYGFDk9Dj4DaxkwFYuifuvKwaepFXbq/P91U9CEGUQ/EW2Wd+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FcdIXJC4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FcdIXJC4"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234fedd3e51so59172695ad.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220675; x=1750825475; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=He9GMZwZGhbuABKsoN3wz9xUeb4JLf+qOIjtO6Uhl9c=;
        b=FcdIXJC4FTZw3NqyijsEuDEThu7xWGM//eWtwIotSgZLRpgztaTIAMPfn1ocbYwLF3
         va2Ck0pA3yhGHlGKNgD3focr8z2Wgme73GaVGCkTD+HQmbzbeOk2y0CuAeG1IRdMJqu7
         dEyIAEj9Iy/+QxyvQtprKpjIIwRJ7yWn49a8/BcFFHvP1j6n1maafTAOXQHvj9Ki1Iu6
         mvWlU2r26Qwajmq9+0f0o2N/vZXvYooY3pXuRFJWX88VM9JvU0CuG7h5KQFsT6CbuTre
         yfAPW1mzHAvMFVVDHus2dNFC0A5QVMH56EjvLf0LZzrjHVqTb5AyMxHUxgHBeLAAAHtW
         VnBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220675; x=1750825475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=He9GMZwZGhbuABKsoN3wz9xUeb4JLf+qOIjtO6Uhl9c=;
        b=Hx7fdO8jY59pwIw0upvowEyvg8KQiED3QOqNmDY0+FxyyGmrscRCjNhAxfcOT4dxvW
         4vYpxz6foVuZLNSS2YPEICr1V3m1UO4PheXFR5xuP3AO4OXyl9IpATUa2S4QhfY/JjaG
         PJJOEQ9uruld0acVFB7sA15fPFwlPAPNggCBo20B3Oc53+70zkNf1YXbBs+pZQdrZ4Dl
         Bh1yUXWG1bPFRDqZMHoMTsHBraVFmLTcYWEmgi7XwyF1QcjRM8UPBFijA71Yjtu+grHj
         ImwRYMHegy5WStewgUfZe7ZnAatDtiiguYeJuOzU0ajFHG3X37rA58oCxA1AY5/zXzXc
         MBmg==
X-Forwarded-Encrypted: i=1; AJvYcCXRzG1b45Vqs2Ys0cmKQGTgskk1qWIoYJdIjYQTwKXGI96HXUk/Co7bvnMP6uy/fWYkZ+WZusw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1pSwWOiLsJzlIaBcIWZzxmM0HcM/qEm9o7uqhjaxrHs99F8gA
	ZRqHqaMgasyehDQAo6DWLhVA7vdv5VHN2b3vQDeC6387Rj60g3pBgd1UhlAeJOhvhH+lra0BAMM
	t9zClHNDFQnmIDayJiFufnA==
X-Google-Smtp-Source: AGHT+IEz+sYmwmOj4IeHxcE6XX3uQvv4AyNEb1cpKl7A16mtz5cSX2RNnd2uZJbF+w+tZiQScGXmjNJtGrMaKECU
X-Received: from pjtd15.prod.google.com ([2002:a17:90b:4f:b0:30a:31eb:ec8e])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:dacc:b0:234:c8f6:1b05 with SMTP id d9443c01a7336-2366b3fe725mr232646505ad.52.1750220674878;
 Tue, 17 Jun 2025 21:24:34 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:14 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-6-jthoughton@google.com>
Subject: [PATCH v3 05/15] KVM: x86: Add support for KVM userfault exits
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Only a few changes are needed to support KVM userfault exits on x86:

1. Adjust kvm_mmu_hugepage_adjust() to force pages to be mapped at 4K
   while KVM_MEM_USERFAULT is enabled.
2. Return -EFAULT when kvm_do_userfault() when it reports that the page
   is userfault. (Upon failure to read from the bitmap,
   kvm_do_userfault() will return true without setting up a memory fault
   exit, so we'll return a bare -EFAULT).

For hugepage recovery, the behavior when disabling KVM_MEM_USERFAULT
should match the behavior when disabling KVM_MEM_LOG_DIRTY_PAGES; make
changes to kvm_mmu_slot_apply_flags() to recover hugepages when
KVM_MEM_USERFAULT is disabled.

Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c |  5 ++++-
 arch/x86/kvm/x86.c     | 27 +++++++++++++++++----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a4439e9e07268..49eb6b9b268cb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3304,7 +3304,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_error_noslot_pfn(fault->pfn))
 		return;
 
-	if (kvm_slot_dirty_track_enabled(slot))
+	if (kvm_slot_dirty_track_enabled(slot) || kvm_is_userfault_memslot(slot))
 		return;
 
 	/*
@@ -4522,6 +4522,9 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
+	if (kvm_do_userfault(vcpu, fault))
+		return -EFAULT;
+
 	if (fault->is_private)
 		return kvm_mmu_faultin_pfn_private(vcpu, fault);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b58a74c1722de..fa279ba38115c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13152,12 +13152,27 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	u32 new_flags = new ? new->flags : 0;
 	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
 
+	/*
+	 * Recover hugepages when userfault is toggled off, as KVM forces 4KiB
+	 * mappings when userfault is enabled.  See below for why CREATE, MOVE,
+	 * and DELETE don't need special handling.  Note, common KVM handles
+	 * zapping SPTEs when userfault is toggled on.
+	 */
+	if (change == KVM_MR_FLAGS_ONLY && (old_flags & KVM_MEM_USERFAULT) &&
+	    !(new_flags & KVM_MEM_USERFAULT))
+		kvm_mmu_recover_huge_pages(kvm, new);
+
+	/*
+	 * Nothing more to do if dirty logging isn't being toggled.
+	 */
+	if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
+
 	/*
 	 * Update CPU dirty logging if dirty logging is being toggled.  This
 	 * applies to all operations.
 	 */
-	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)
-		kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
+	kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
 
 	/*
 	 * Nothing more to do for RO slots (which can't be dirtied and can't be
@@ -13177,14 +13192,6 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	if ((change != KVM_MR_FLAGS_ONLY) || (new_flags & KVM_MEM_READONLY))
 		return;
 
-	/*
-	 * READONLY and non-flags changes were filtered out above, and the only
-	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
-	 * logging isn't being toggled on or off.
-	 */
-	if (WARN_ON_ONCE(!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)))
-		return;
-
 	if (!log_dirty_pages) {
 		/*
 		 * Recover huge page mappings in the slot now that dirty logging
-- 
2.50.0.rc2.692.g299adb8693-goog

