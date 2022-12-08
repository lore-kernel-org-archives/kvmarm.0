Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68E78F71
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:47 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id e37-20020a635025000000b00476bfca5d31so1609042pgb.21
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1a1z/b3owkRfttdiEuiESfzblYsje7V7GrYJ8kI0Po8=;
        b=F0XYX+U7NiHCkK7bsbIKwHt4xn5xSLrANWygs7k8NFHbu1R2R/rmJKDDnvUWdIHP92
         Ly2IYp0NOWTwXh63NaBMZcPqgDrfFaYYlcINvpDuRoegsyJJVoxOj7s7XDFnwq4W8GTC
         f+4upgVNo5G4bbwSbrkVhi3YHBvy4jYzsDFUG9wwYOpDkZx7UBWzJoj2myxNLvIdqZ4W
         pfI5REShGLM7+b3RergwOgWIMIsTPACWYsmBoNyo8t79eVgzWxxkGk1mGWxh5mVT27dB
         xSUuXJrP+ASrLLbWhs1/6bZw6Zgr2IKK/y+UkG+xQAvodbxK4QFJj/l93proPVAsOFHJ
         1lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1a1z/b3owkRfttdiEuiESfzblYsje7V7GrYJ8kI0Po8=;
        b=JtozOyH9lEW2Yo6qoRKiz1j9hkqcNCN9LOYO2CzzkKzCz0ELvPXW7N4H6uBw+aqRHs
         b+SEwhOI5G5lgTmyn7YcxYMDEqKpJvSXbIl2hovXaRp8zBqwfVugdHXpxOUXayaDaXqC
         k+JVJVjxJfk63okcYLm4iEtutP8T+pvubO1wtB5lR8AUhOszfvje+IfISiEgGvArFaL5
         ySkWEDTD7pSnPQPALHVFA+SgfZnXXcgZEIofkwZMDGXc9g/Z8e/HLJzF61vd+R9zq6MJ
         +MGQ7gtVE1n3vX3ZHlyOFDofPYjFBQ/1r0k2O4Tk3Y2E4+jWfxfvFRhxv1DuA5vsnbrB
         +xyg==
X-Gm-Message-State: ANoB5pnuEs1FqgtHR8P+gtfNQFE3e41QfWCXcb2xdVHnkwC5hVrAAkJH
	OfygezA0nT+Z+rtPUl1OnHj6TuFcrdn+3Q==
X-Google-Smtp-Source: AA0mqf5kngnEG6TtWra1+xFIY37aBRwogffq20uJpUzBVyAWsE1WUGsuHoa/DzL+7L0/Sgg0ER4DuRQldLsQMw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1997:b0:219:8ee5:a226 with SMTP
 id mv23-20020a17090b199700b002198ee5a226mr29019577pjb.13.1670528387307; Thu,
 08 Dec 2022 11:39:47 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:44 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-25-dmatlack@google.com>
Subject: [RFC PATCH 24/37] KVM: x86/mmu: Move kvm_mmu_hugepage_adjust() up to
 fault handler
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
Message-ID: <20221208193844.BnFX0VQWMNRb-RSZmJoGrWG8u2CiY5aU_Zi4sz6ObV0@z>

Move the call to kvm_mmu_hugepage_adjust() up to the fault handler
rather than calling it from kvm_tdp_mmu_map(). Also make the same change
to direct_map() for consistency. This reduces the TDP MMU's dependency
on an x86-specific function, so that it can be moved into common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 2 --
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0593d4a60139..9307608ae975 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3151,8 +3151,6 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	int ret;
 	gfn_t base_gfn = fault->gfn;
 
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
 	trace_kvm_mmu_spte_requested(fault);
 	for_each_shadow_entry(vcpu, fault->addr, it) {
 		/*
@@ -4330,6 +4328,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		goto out_unlock;
 
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
 	r = direct_map(vcpu, fault);
 
 out_unlock:
@@ -4408,6 +4408,8 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
 	r = kvm_tdp_mmu_map(vcpu, fault);
 
 out_unlock:
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b997f84c0ea7..e6708829714c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1157,8 +1157,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
 
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
 	trace_kvm_mmu_spte_requested(fault);
 
 	rcu_read_lock();
-- 
2.39.0.rc1.256.g54fd8350bd-goog

