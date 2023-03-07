Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5AD36E
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:11 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id m9-20020a17090a7f8900b0023769205928so7404223pjl.6
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gvJNj0mQeIAybmV+sHqcHxeWw8+9xyXfDJ8xf/pLTCA=;
        b=KuFR4KTgeSooNzN/+zGbVnqYq4wq4kyTAhwmrHbGurV9+8hMkG2Qc8H09cvvDcqzGg
         j/IhFToTxYiAmo9iNXaSMdkUN2ylaxTvtcDiqK1cz3ReHAa/BXICOcoEB/nNoZXnmO83
         fA4ikyiPQ6H04H0L3HO2zkDhxVnZLuXMeyTlhbpa96jztGxSaIUxSLgRyxLwkANp6p8L
         MDDxBGPTa0u7fv3JEfFSYSuBU6MtxwgbdmLsuS2e7KQ9y4T4vqq+u5IppD4sU2Zqelud
         Iib8XjYPWsrMBWHKGQGSKZ9OpEvD3mqpeRtMdBhtaOVQJp+9izt59WrnPkhKhmT4hFUd
         veTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvJNj0mQeIAybmV+sHqcHxeWw8+9xyXfDJ8xf/pLTCA=;
        b=nQZlkKcUqcGmETgOj3nurxF8WH6LsVYwxnwXSwuoEG7KoLDDbjhyN8LOSu6rjrSmhK
         KcS9S2lwrPSNy1oLNE1zIrINqJA55ZwoO4vn51JA/QxWo2yh0i8IKj/M490H2qMs1jI8
         EUgRXVd3Tsh02YF5njQc6l5krS5l0GLh2J1OJPGqTbBwwAXybe3FFwyAAkZs8/8uYpc4
         qatPOgKNAIKcBLecmQOS3x1zVj5IYAqMIkIEJr9Vp87C8PqzULuerSt2Um54AwqJsioN
         imJBhiamkzPeijHJ8cWy6bovyvszf1OqpVdT361W2FrF7J0cbCV1sc02qW1UT5ZJhHZf
         TJCA==
X-Gm-Message-State: AO0yUKXODAW75PNSCHNvCoKY6THgyZXnR/6fF1w6p6PQz2uGgtF4YjmY
	M8E3Js/XSvQ7U0kz8pzBnrcFrhWFB7UQbw==
X-Google-Smtp-Source: AK7set9SV3zCXNwHWNNDJ8yWRWTV0zHQlV0Jsaxr1Bj4VcYs8eaYZCCL4+YdsU8YvpCLjZQiLrjrMF14QfO+CQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:ef95:b0:19b:8be:33dc with SMTP id
 iz21-20020a170902ef9500b0019b08be33dcmr5059517plb.6.1678160771101; Mon, 06
 Mar 2023 19:46:11 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:51 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-9-ricarkol@google.com>
Subject: [PATCH v6 08/12] KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add a capability for userspace to specify the eager split chunk size.
The chunk size specifies how many pages to break at a time, using a
single allocation. Bigger the chunk size, more pages need to be
allocated ahead of time.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 Documentation/virt/kvm/api.rst    | 26 ++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h | 19 +++++++++++++++++++
 arch/arm64/kvm/arm.c              | 22 ++++++++++++++++++++++
 arch/arm64/kvm/mmu.c              |  3 +++
 include/uapi/linux/kvm.h          |  1 +
 5 files changed, 71 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 62de0768d6aa..872dae7cfbe0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8380,6 +8380,32 @@ structure.
 When getting the Modified Change Topology Report value, the attr->addr
 must point to a byte where the value will be stored or retrieved from.
 
+8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
+---------------------------------------
+
+:Capability: KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
+:Architectures: arm64
+:Type: vm
+:Parameters: arg[0] is the new chunk size.
+:Returns: 0 on success, -EINVAL if any memslot has been created.
+
+This capability sets the chunk size used in Eager Page Splitting.
+
+Eager Page Splitting improves the performance of dirty-logging (used
+in live migrations) when guest memory is backed by huge-pages.  This
+optimization is enabled by default on arm64. It avoids splitting
+huge-pages (into PAGE_SIZE pages) on fault, by doing it eagerly when
+enabling dirty logging (with the KVM_MEM_LOG_DIRTY_PAGES flag for a
+memory region), or when using KVM_CLEAR_DIRTY_LOG.
+
+The chunk size specifies how many pages to break at a time, using a
+single allocation for each chunk. Bigger the chunk size, more pages
+need to be allocated ahead of time. A good heuristic is to pick the
+size of the huge-pages as the chunk size.
+
+If the chunk size (arg[0]) is zero, then no eager page splitting is
+performed. The default value PMD size (e.g., 2M when PAGE_SIZE is 4K).
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a1892a8f6032..b7755d0cbd4d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -158,6 +158,25 @@ struct kvm_s2_mmu {
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
+#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT	PMD_SIZE
+	/*
+	 * Memory cache used to split
+	 * KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE worth of huge pages. It
+	 * is used to allocate stage2 page tables while splitting huge
+	 * pages. Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE
+	 * influences both the capacity of the split page cache, and
+	 * how often KVM reschedules. Be wary of raising CHUNK_SIZE
+	 * too high.
+	 *
+	 * A good heuristic to pick CHUNK_SIZE is that it should be
+	 * the size of the huge-pages backing guest memory. If not
+	 * known, the PMD size (usually 2M) is a good guess.
+	 *
+	 * Protected by kvm->slots_lock.
+	 */
+	struct kvm_mmu_memory_cache split_page_cache;
+	uint64_t split_page_chunk_size;
+
 	struct kvm_arch *arch;
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..3468fee223ae 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -91,6 +91,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
 		break;
+	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
+		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->slots_lock);
+		/*
+		 * To keep things simple, allow changing the chunk
+		 * size only if there are no memslots created.
+		 */
+		if (!kvm_are_all_memslots_empty(kvm)) {
+			r = -EINVAL;
+		} else {
+			r = 0;
+			kvm->arch.mmu.split_page_chunk_size = cap->args[0];
+		}
+		mutex_unlock(&kvm->slots_lock);
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -288,6 +304,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = system_has_full_ptr_auth();
 		break;
+	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
+		if (kvm)
+			r = kvm->arch.mmu.split_page_chunk_size;
+		else
+			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a2800e5c4271..898985b09321 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -756,6 +756,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
+	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
+	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	return 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d77aef872a0a..af43acdc7901 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1184,6 +1184,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
+#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 227
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

