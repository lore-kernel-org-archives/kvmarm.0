Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF757C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 990344B173;
	Fri, 15 Apr 2022 17:59:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9JmpfxLpsKtx; Fri, 15 Apr 2022 17:59:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 681A84B11B;
	Fri, 15 Apr 2022 17:59:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 639C24B129
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AB7819AmQWX0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:21 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B3A949F46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:19 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 k20-20020a5e9314000000b00649d55ffa67so5416084iom.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ukSikfLZPySq7lKrWdQC3W4tZRZDdV+TXwwmzbO5VKE=;
 b=UFQNViFm5ywOL6fUUgUmBF2pMIllmvYSsEmxRVNh1gzD1izmJ3LtYUTbQoVRVd6R7/
 jqzms2/UXzy9A1cKXaPCa6uGhs2jB4kYpL25R2bC00CDonStKGhvdJ4YVdoFWKmexTi/
 QkfTtuq7/OrDuIAAqPw+yUALYUDmuCCrGRxB9F24yb275VyW2/5r9d7nu5//Jrfs1gyU
 bBbceIMSX7GVKPd/CqxGaga7ODuF8yOc8fr/uf+kbuofz35ev3lh9BLs/jGFbUXJ/kkj
 2mjW+x4bwKEomG8LlUwv7ZO+oESMs9ddaaWpZvG/caTzJIQruvv70SZXMOewJ76h8qCh
 w+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ukSikfLZPySq7lKrWdQC3W4tZRZDdV+TXwwmzbO5VKE=;
 b=ywjdgpaHUkYRvpRsEFiNjkcDKFCNlKIxWd0v5j26oTsjk115MJZiAddJecawOIX1JF
 5RYIOaIqkVkKGM++9/gSpA0JFq2l8y7dfCZoAI1YeOMHr/SW4S2u2ebVV5FS1Tw+X9EW
 92BRvF0bVbg4s2EiTKSuI5Z19rzpmFrKHDdZZFwjQlPCaWkziIWqxXaDcKfv7jNO0oJV
 sbMLsfWvej2LDy8EA3Zox778BI20YW6Teqy3R1rgA3Zky+/Ua/I38aR84Q2Xug9BBGN1
 uY9Jt2POUEWqqEJ3ZL7NJOElf3gXNFsPAVm4fbM6XEw6jkLsidfGvbmAMP+cRU1il3xj
 nB2w==
X-Gm-Message-State: AOAM531Rx/BMDH6noSo43/cY+Ma/uNrbakJcsDo4lQqywSjpxWrVzFKq
 hNYwQOT5NfDFU7JQGqD4qmo+YztAaqmiCeucxstJbWRSm37vJXM63MkoGJ3ikHwxdH1s0rhpKBM
 jvEzPE5gigZCEm7YWvS2l/vnKbySxTi9HMOHvQ63y8RNy49MzlfVkdiKjV3vRAK7LgXyUcg==
X-Google-Smtp-Source: ABdhPJw3+rg28SXpnYzElP/Fh1mOEN5FS2KtRHWJcXruhJlFqtNNF+kNgwwNT/3GJfepUrZ+VWNiihmiJLs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1a4f:b0:2c7:a4c8:25f5
 with SMTP id
 u15-20020a056e021a4f00b002c7a4c825f5mr334502ilv.64.1650059958943; Fri, 15 Apr
 2022 14:59:18 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:55 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-12-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 11/17] KVM: arm64: Move MMU cache init/destroy into helpers
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  2 ++
 arch/arm64/kvm/arm.c             |  4 ++--
 arch/arm64/kvm/mmu.c             | 10 ++++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 74735a864eee..3bb7b678a7e7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -172,6 +172,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(u32 *hyp_va_bits);
+void kvm_mmu_vcpu_init(struct kvm_vcpu *vcpu);
+void kvm_mmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 static inline void *__kvm_vector_slot2addr(void *base,
 					   enum arm64_hyp_spectre_vector slot)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..f7862fec1595 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -320,7 +320,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+	kvm_mmu_vcpu_init(vcpu);
 
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
@@ -349,7 +349,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_vcpu_destroy(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 53ae2c0640bc..f29d5179196b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1601,6 +1601,16 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 	return err;
 }
 
+void kvm_mmu_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+}
+
+void kvm_mmu_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+}
+
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
