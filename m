Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E134AC4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CCA14BA1D;
	Thu,  8 Dec 2022 14:39:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8ygWvDPW4l6W; Thu,  8 Dec 2022 14:39:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C805F4BA13;
	Thu,  8 Dec 2022 14:39:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B82394BA19
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iTn8CZmqYGqQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:15 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4C8D4B994
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:14 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-348608c1cd3so25086197b3.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=HLrD3t5bH+2UVRBzeB4pMLD/le/gTmNW425ksyvCqFk=;
 b=Gz2UiZJQ4DZMvEnArLUIALIGxYLRWiZ17+uUATC7JW/9U1+U3CD+XxyUp4xTCXYyqm
 DDneOFTbuWB1kx+t4q0UHmlcS5n+bBhngCf182KgN6PPTjRQsSMq1oAQexRSMgVG39ZD
 WhmvaX0yvy8NFr4Zie7hieP7Qf0Cd9sbZbC0FQq7beeBSoCGOAI0ayUDbpD1ZJxACp3Y
 RsidsgionOp80YxgC6DQ4znzyHHQNpvrHQge9fW5yLMBKr5BHx+VLpdd/WsaXsD3cms0
 3Ph9MeTQfZs+riAoOSxWCz4/93fX3jbybIXAJwuXHBDPPpC+reEQ9lxn1c7vmVVnZgpl
 TQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=HLrD3t5bH+2UVRBzeB4pMLD/le/gTmNW425ksyvCqFk=;
 b=5afITdEhPExi6QG4hlVfqQ5dYCJbhXJcYucHnZ74EYUU3gGkJrODxWZvE5LDloxbgU
 rcjT81+bKYFIwDfqd2bhWRoGXg44aspjcvxAtmR18va1M3JMrNX1Qjeb8OTW3y8RdDLS
 MifUe0O9ac1pPCk+yWj2rhUOh2gQ4VsvfZBYaE5eZc6I+XwrpNHuu2uJRfQG7Hy62yXt
 4ZT5sF3+w5MfvEQjzfFGv7P7NlNB6yCMb/Mp2W/PlTnsSdF0SfGMrE+sbDwvfMKRqU0x
 dr5pKLOO2u/+1NFueLAvMTqzfoG3rnOT0ZRo5a0Lk5eMHV8VE/uoanmBy6UfacDYcUoo
 fdgA==
X-Gm-Message-State: ANoB5pmVtXtphcUUskgNrUBw1wGFhB7AX+5f0zMkIhBR09cX2/uaDMGb
 UaZnpKAOXqKINRBrZ5JSflZc1cfQ3yVeXA==
X-Google-Smtp-Source: AA0mqf7CjJBroe1GU5lusLDR6DJkiCylX/dWdqQ1e2UjuKyXk5ZPZTZv3qlpbJO/f2YNw2OZIgu/a4kIbkSpkQ==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:2184:0:b0:6ea:e952:4d4a with SMTP id
 h126-20020a252184000000b006eae9524d4amr80656342ybh.120.1670528354217; Thu, 08
 Dec 2022 11:39:14 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:24 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-5-dmatlack@google.com>
Subject: [RFC PATCH 04/37] KVM: x86/mmu: Invert sp->tdp_mmu_page to
 sp->shadow_mmu_page
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

Invert the meaning of sp->tdp_mmu_page and rename it accordingly. This
allows the TDP MMU code to not care about this field, which will be used
in a subsequent commit to move the TDP MMU to common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 1 +
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 3 ---
 arch/x86/kvm/mmu/tdp_mmu.h      | 5 ++++-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 355548603960..f7668a32721d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2180,6 +2180,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 
 	sp->gfn = gfn;
 	sp->role = role;
+	sp->shadow_mmu_page = true;
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (sp_has_gptes(sp))
 		account_shadowed(kvm, sp);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e32379c5b1ad..c1a379fba24d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -52,7 +52,7 @@ struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
 
-	bool tdp_mmu_page;
+	bool shadow_mmu_page;
 	bool unsync;
 	u8 mmu_valid_gen;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7ccac1aa8df6..fc0b87ceb1ea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -133,8 +133,6 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
 		return;
 
-	WARN_ON(!is_tdp_mmu_page(root));
-
 	/*
 	 * The root now has refcount=0.  It is valid, but readers already
 	 * cannot acquire a reference to it because kvm_tdp_mmu_get_root()
@@ -279,7 +277,6 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	sp->role = role;
 	sp->gfn = gfn;
 	sp->ptep = sptep;
-	sp->tdp_mmu_page = true;
 
 	trace_kvm_mmu_get_page(sp, true);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..18d3719f14ea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -71,7 +71,10 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 					u64 *spte);
 
 #ifdef CONFIG_X86_64
-static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp)
+{
+	return !sp->shadow_mmu_page;
+}
 #else
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 #endif
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
