Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9088BEE
	for <kvmarm@lists.linux.dev>; Wed,  1 Mar 2023 21:09:42 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id q9-20020a17090a9f4900b00237d026fc55so257777pjv.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 13:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FD7uNwpEYF9RsVYatisVMtB7W3/05QCRhc5pQD1utdg=;
        b=GKbeHEhd81x4RT0NRiaNegia/D4yGXeprV1zo45q3lUMhN8Jd0I5JPlSf0CNvA0/+e
         XBbcwBZiGpFyfRO88xezpgSDQzv1xFoV6nXnPYjkBOHhGox/VP2VPJkn1S9XYhf6d52P
         nz3VuQCoHgfWyD+YD8NffwGbJRhosrREg0eRLtc6DgoR3C+EWBi6LGrEsTgA11q0L/CG
         xRHJHbXfg67Sc9Sp0OFyUoKPaeqtXDtK8zQE2OVXSldXJnGaPNPXIzDm7BMv+9TKgg1d
         mcprn81G4KfeaX08Uthza5kJIwnmIUGcuozOci+gMx9fix/o98HhRJux7SLwShphnMSt
         hLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FD7uNwpEYF9RsVYatisVMtB7W3/05QCRhc5pQD1utdg=;
        b=PPEdEKmkW8F+DL9JDkuA1UgBFwRYwC8agaObCYIjGmpOJnuBvJ4oMs5wdGWB2/3fK3
         0dYyYtV3DZ718gT4zToadQDG17Y3+OPf4OMbP1+37wJviImpDDYTBKG4BPxNN6uR883j
         SqAtxo5hyYxIOP4RWYK3w5Nigur5Z4HeZK88v5zey1geVKimW4fl23Sw74ynn2CmHFon
         xxCoaJXYwu+i+kpdrRGG3QKYGyxDukV8pRS4IunfgGnrPGOgPWFIbS/4iJ509bWx3m+Z
         ZVMVXoYzHOK73o1u+FhBlepQDwnentUtnNOmde7OWaSh9vh5uhEFxYvb4HPWmbiTmiUU
         j+Wg==
X-Gm-Message-State: AO0yUKVAymXQAyXv6VEJqOixUF5QYUccmsvRslhu+cPvvDICm4K/fmgG
	qLXoq++wv2vzoJP+mQmgvRgCQfLAq7LTqw==
X-Google-Smtp-Source: AK7set8BFQJrdcP7LxWyeTBzLMdsUZBctkkgkT8+/5jkqM87wF7FFCh3sVs/KW+w4RyY6le5Sdo6CkLY3bMq2A==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:381d:0:b0:503:7c81:4599 with SMTP id
 f29-20020a63381d000000b005037c814599mr2229087pga.11.1677704981897; Wed, 01
 Mar 2023 13:09:41 -0800 (PST)
Date: Wed,  1 Mar 2023 21:09:22 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-7-ricarkol@google.com>
Subject: [PATCH v5 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
future commit will add some more things to do inside of
kvm_uninit_stage2_mmu().

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 1 +
 arch/arm64/kvm/mmu.c             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e4a7e6369499..058f3ae5bc26 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -167,6 +167,7 @@ void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
+void kvm_uninit_stage2_mmu(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d2c5e6992459..812633a75e74 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -766,6 +766,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return err;
 }
 
+void kvm_uninit_stage2_mmu(struct kvm *kvm)
+{
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+}
+
 static void stage2_unmap_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
@@ -1855,7 +1860,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_uninit_stage2_mmu(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.39.2.722.g9855ee24e9-goog

