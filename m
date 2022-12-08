Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2E88F71
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:15 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-3b4eb124be5so24644827b3.19
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=Yq7wfLP8Yad2TzceUUkstgkLPJUwBJqZupn9kh3CptPxIbmQIZQUEoFw5VXb+dBxSJ
         5zwMJNWkaApKdQsm3dabPgolj8JiBi0t9G+ouI21fPZeAYquuFRe36XwjjiaosLjTN4a
         lgvarFo6nTW/wlI532yQ5nshT2wmtN2XXucr0gmOfUm0EQQRXqQcQxoZg7oRIo4dVJLb
         ayFUpJ4ep9R/fGQMY/uyGiPa5KKKXvYHGdPDSFJgrI0xlR6cBAatajbGfGYfnTi9CQG1
         lKb1Heyzjbw5xNe/8flkwBr4kL0bupsgYF2BuBy2ciDQs8R4QLhHlhlEfcuUmi7PXnTe
         O+Mg==
X-Gm-Message-State: ANoB5pkC2glc6v2R/iXW8lw9qBDLjFKXvBiCD1lfj8MQz3Lb5f3W1Th4
	aHWLUQ1lyaqrYLEgv+cwa/CQb/ThA2f6Fw==
X-Google-Smtp-Source: AA0mqf7CjJBroe1GU5lusLDR6DJkiCylX/dWdqQ1e2UjuKyXk5ZPZTZv3qlpbJO/f2YNw2OZIgu/a4kIbkSpkQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:2184:0:b0:6ea:e952:4d4a with SMTP id
 h126-20020a252184000000b006eae9524d4amr80656342ybh.120.1670528354217; Thu, 08
 Dec 2022 11:39:14 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:24 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-5-dmatlack@google.com>
Subject: [RFC PATCH 04/37] KVM: x86/mmu: Invert sp->tdp_mmu_page to sp->shadow_mmu_page
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Nadav Amit <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221208193824.3JWvaMXH74WEarphaX3ZweHk6kkwpu7bP_JGgN5uzvk@z>

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

