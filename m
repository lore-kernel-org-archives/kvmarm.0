Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C79C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F6EC4BA63;
	Thu,  8 Dec 2022 14:40:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aEaUi2KFBTKh; Thu,  8 Dec 2022 14:40:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8834BA80;
	Thu,  8 Dec 2022 14:39:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFF494BA1E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3EJRQSNy3YXV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:54 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80EA94BA8A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:49 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 203-20020a2502d4000000b006f94ab02400so2551930ybc.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=PeJRMD1iiEfAcW0wse8YvMRXDysx/LxLCpDqGqOGbOE=;
 b=it3ha/1H2vQVcMvrwLK2XI6kFW9SfZwdQ0HxxUSc3Ag107nHhiqTSUqlouPQ69hlpA
 gVlMznc/cXRCFulmlBil4kKdWgDSAUCR93SntgLaDJWCpUTB7FzwaETswPW9lX1yNG07
 0tWWOwYFihDwyLqkpiOMrsIryZ3SjYTTI8b4R1X9oFZnj7/UyRLh3XP6ECDzERPz2C+i
 B3prUkRr3KEH0wVuRrtyBo09IY2F7MxhaUoLo7LOK5D3eYUuVBFYj36vL7P7ZiNQEA7c
 1QUJk9A2erTf8dkQPtJhbcBzs55NBkUNAK3ruLZHLQeHsz23ls2YGKCDBr5v8J7edZjj
 uhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=PeJRMD1iiEfAcW0wse8YvMRXDysx/LxLCpDqGqOGbOE=;
 b=o/ZJUVEsqEEhja5aJ82Djk2dvln6Ul7zkxtze9N6yejivMTP89K9rMV5I2sIWdS3Sy
 ZnWlZ3bKz7U6GJLTeSQgXWLmzClugGZsE0RBOiRW5vr0cajGY0z0SWYj84cgkSLiXrRD
 vWt6qj6B6yrJc38q0dK12Ocozpqmg8CxbkbYWLn3Zu1SkWEqK/3gNy3eS8wEbyzj5ZUP
 L4eNRfFRhYSqDVJQk6Ws5hpmhGfS6Q8F3lgWgk7U8jDROVC5uUAjBhWQXGT3jKBEC0NN
 SdJSmQEMHhxLwrLU/3LccZjHvaF2ASK9nDZUo4DmyJxrteRTVLjJYbGNEAHCto5D+1mr
 es9g==
X-Gm-Message-State: ANoB5pnElM1CzNtgzgDMmTiHGjq90NNXIZYnt5srCJX/ghHTATA2wt4G
 N0bY67WynzC0EpVhmQpyExkKcBABCPNjwQ==
X-Google-Smtp-Source: AA0mqf42i4HuA7nX3hyDm6T4qhjEe3EzuwVfCeNTiMqXBDpZ0EVA3TMnNfFvR5iVyImke8GmCkOtSd5OsKu+oA==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:6602:0:b0:6f9:890c:6468 with SMTP id
 a2-20020a256602000000b006f9890c6468mr39021311ybc.610.1670528389040; Thu, 08
 Dec 2022 11:39:49 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:45 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-26-dmatlack@google.com>
Subject: [RFC PATCH 25/37] KVM: x86/mmu: Pass root role to
 kvm_tdp_mmu_get_vcpu_root_hpa()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
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

Pass the root role from the caller rather than grabbing it from
vcpu->arch.mmu. This will enable the TDP MMU to be moved to common code
in a future commit by removing a dependency on vcpu->arch.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.h | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9307608ae975..aea7df3c2dcb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3612,7 +3612,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 
 	if (tdp_mmu_enabled) {
-		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
+		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, mmu->root_role);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e6708829714c..c5d1c9010d21 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -301,9 +301,9 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu,
+				    union kvm_mmu_page_role role)
 {
-	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index e6a929089715..897608be7f75 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,8 @@
 int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu,
+				    union kvm_mmu_page_role role);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
