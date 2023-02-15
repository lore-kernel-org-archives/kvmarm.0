Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D0D7B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:41:00 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-52ec8c88d75so200251227b3.12
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2aQfWdKPXuFG6NSbYocOUPq5yC9G6Tl83wDoUvzVHnI=;
        b=Ua5IO7vGngB3DNTztZZETtTDciYiE4ZSiNpD2944my3OwRFQUckvrgPt2B78tyOqXi
         F5kKqBAoj6U1HKy1VTJEhvlYGW3FWgCNy4cvKT9FHRcMvJ8MHnHbjozdlzOln7nl9oyg
         JRgPMkCocBqDVJTgdXR/qsVvybn4hlHa1C7dOwtMVjOGWyj9O6BBdiYwnsaSH4EMjiEV
         jllLlMJozi4joV+FdfhpVn2jSts0h8cnkwTnWayt7Lsoj3eUqLy1i0CczBm48omZvZoK
         z7ebDlIWrmJBod1cOC40C4r+VfkG6cyJNX8DgPgLiy4QiEKKoE0Oc9WE/2rBp1QnS8hz
         Zr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2aQfWdKPXuFG6NSbYocOUPq5yC9G6Tl83wDoUvzVHnI=;
        b=GhOFEfP8tpL8XbYzjEUxenZyvocMUC/6K+Bx67lFppQw1wqsr+xD+pomc/JIp65+hn
         gx9/6jblOTzQLFvbkgvDOUQe2c4jB5wyeqZ2b6/vfIRWk8INdChTsTeRPaMAFy237Xnb
         Tyi71lGJcU5qqXHKjcNXvUE7mR34oOvGGP/Jveln19mfYrZuWEUIDeq7wURyrLSkVKb1
         YpjMaxHjF5I9lzMAY3etyX0f5uvTjIMS2uUqhsZmfUjFLNmP4WEFXCO4wAKmejBiCihZ
         z0d64CTzL5BRBqKo4Ijj/hyzQRPvX0XX+5dlUNo+uR2iM6lLZwNAurMNWy97ouL/vSUR
         8/OA==
X-Gm-Message-State: AO0yUKVvP/l30Cgke7xwLc6UltK2gq//7NUJOQuK0V+l8hr6/x+QGCiZ
	blZb1AyfOK79QwCvazZmqo6TB20G/HCrhg==
X-Google-Smtp-Source: AK7set9UpWTD9Hf0MbU51HmGeZZNYgY6nfTTY6vNSaQoP2nvyZ6+CLZ7Rwm9HKLf3iyzgtqf832vzhg6ZxuPMg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:dfcf:0:b0:886:23d6:1b4f with SMTP id
 w198-20020a25dfcf000000b0088623d61b4fmr347924ybg.115.1676482860031; Wed, 15
 Feb 2023 09:41:00 -0800 (PST)
Date: Wed, 15 Feb 2023 17:40:40 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-7-ricarkol@google.com>
Subject: [PATCH v3 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
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
2.39.1.637.g21b0678d19-goog

