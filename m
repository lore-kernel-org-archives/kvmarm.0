Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3768C2D25A
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 23:44:56 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ba88ec544ddso2980179276.1
        for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 16:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685144695; x=1687736695;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M3AF7fBmc1xnJAMOiZdfCsfXZHiS6oPk41ReBM4zbdo=;
        b=yrD5cypjwj76oGySeMKoL+EObdL+VlHBR0ZE4dlUQxoYbTEWiiVpSKdOJmkcaaiF/Z
         4zilNg4E7S1qiA0OC/fMHUKvaq4lLe3h3XrcfBRajVZEzuTWsMjYGvjMBJ/wRyLbmfd/
         x0p59R3lRKLAmUF0+sTBQhD8rRciT1hrCi2rbco+ObNSFPCgz7YI6gzDi295X90OlgMM
         zrJNip6i/8aKO3FHb/HgogYFOfPOgx60+DOedoHxymQQDAPdmrus+K28IPt1M7E0g0cI
         asbBmGj30I6PgAgE5VquUWTvHUX2/5VYaFLlsw0xBC7qUsoM7lDeTwedn+JU6nSVVIPC
         w2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685144695; x=1687736695;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M3AF7fBmc1xnJAMOiZdfCsfXZHiS6oPk41ReBM4zbdo=;
        b=S458Mv7SVA/VM6A94ab3rwFKnRLuADeumDxNC8ETmUfDTvD+e/d6ZQAXVyXTZ/weUK
         wFpWmetUwT3vPY8AskMdMvV/3hF9QLMwtVkW+5EFDhDsFoW/heeiGKJu39mjdwuSjA04
         JroHq0XKffBCkIt8tN7hBTWUSt5P/8wPv8RDfmtrOkFNY1+9ItkScqtFUAvDiNhmbb34
         DS/SntYzBh0owZatY9XPaTRFoNcOsOvDwe87C5Hku/livQG9NiDYgPiMpNNIQfbU2i3Q
         DN+c5BY0CFVzzDOg1RcmfW27LI/0Mu5h2Nf/HgAIBeCpWwr0V6Dkt6OHKvktD51oCTfo
         drgQ==
X-Gm-Message-State: AC+VfDy8nszrScq1S9PLnrAVfMk1l9hwEMV4nUfcAyf+X7gbOfYW/XoS
	8/F+7+b6oFtEdA02yBMYSAOVVOCivYw=
X-Google-Smtp-Source: ACHHUZ4QgTvrucO0Q6McE6sU/ZYyF1Ujw9/eAceyjgq3u2aouYR16g/56Sc2t/zSHX7sxuPwIu+K0d0WjYg=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:910f:8a15:592b:2087])
 (user=yuzhao job=sendgmr) by 2002:a05:6902:1341:b0:bac:6bb:2549 with SMTP id
 g1-20020a056902134100b00bac06bb2549mr1840571ybu.7.1685144695170; Fri, 26 May
 2023 16:44:55 -0700 (PDT)
Date: Fri, 26 May 2023 17:44:34 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230526234435.662652-10-yuzhao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Subject: [PATCH mm-unstable v2 09/10] kvm/x86: add kvm_arch_test_clear_young()
From: Yu Zhao <yuzhao@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Ben Gardon <bgardon@google.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Gaosheng Cui <cuigaosheng1@huawei.com>, 
	Gavin Shan <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michael Larabel <michael@michaellarabel.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Paul Mackerras <paulus@ozlabs.org>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@google.com, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_test_clear_young() to support the fast path in
mmu_notifier_ops->test_clear_young().

It focuses on a simple case, i.e., TDP MMU sets the accessed bit in
KVM PTEs and VMs are not nested, where it can rely on RCU and
clear_bit() to safely clear the accessed bit without taking
kvm->mmu_lock. Complex cases fall back to the existing slow path
where kvm->mmu_lock is then taken.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 34 +++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 753c67072c47..d6dfdebe3d94 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2223,4 +2223,11 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
+static inline bool kvm_arch_has_test_clear_young(void)
+{
+	return IS_ENABLED(CONFIG_X86_64) &&
+	       (!IS_REACHABLE(CONFIG_KVM) || (tdp_mmu_enabled && shadow_accessed_mask));
+}
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 08340219c35a..6875a819e007 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1232,6 +1232,40 @@ bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
 }
 
+bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	struct kvm_mmu_page *root;
+	int offset = ffs(shadow_accessed_mask) - 1;
+
+	if (kvm_shadow_root_allocated(kvm))
+		return true;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
+		struct tdp_iter iter;
+
+		if (kvm_mmu_page_as_id(root) != range->slot->as_id)
+			continue;
+
+		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
+			u64 *sptep = rcu_dereference(iter.sptep);
+
+			VM_WARN_ON_ONCE(!page_count(virt_to_page(sptep)));
+
+			if (!(iter.old_spte & shadow_accessed_mask))
+				continue;
+
+			if (kvm_should_clear_young(range, iter.gfn))
+				clear_bit(offset, (unsigned long *)sptep);
+		}
+	}
+
+	rcu_read_unlock();
+
+	return false;
+}
+
 static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 			 struct kvm_gfn_range *range)
 {
-- 
2.41.0.rc0.172.g3f132b7071-goog

