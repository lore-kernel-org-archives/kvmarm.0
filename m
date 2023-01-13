Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C010E638
	for <kvmarm@lists.linux.dev>; Fri, 13 Jan 2023 03:50:10 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id k20-20020aa792d4000000b0058347d2f5e3so9557611pfa.15
        for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=59+3RpyO/YTzkZC7kIC3ThLSoyfPtBgDOXegbo4OhfY=;
        b=bzNVzkNXtnTnahSLZkUEXB8tjP1blOh4M71aPnfiSROYzEkijWOQSg/o8bEsRpISoL
         IGZpGSYPfkIfFiOLuqYktNZfww01RF6+kCg9lJnQ1QwxbhHMhARNfh7tLWgh+bBVXHAt
         nvk9hMg1V/+lZ/rRL3ZJkcfqeLMSGtCuDUuAZPYorZFwjAv3eNeb85y878hTsfYlJ46j
         ClSyOuEfyi/rmURelRK4AMw3mSJnL4UM9p0qogq5ZoZya5petTYU4JNcIBvvRWx8ObqT
         EESysOg1CmDz34AfcByaXrN3h2d7sRytwcz7sXzP19mwSSmh0vMR21X/0SEfUz0+DB7f
         K2Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=59+3RpyO/YTzkZC7kIC3ThLSoyfPtBgDOXegbo4OhfY=;
        b=qdLh5UrMYEVdAld0ejneIl48MofxtESDUegx9AgY9EyMJ3JJFcGjtFRG0ZhwAyMa5J
         ZYoMVHjudcpoXNie7XbMzXVBeqfHt0mjOKcVh9I+01XQCd75rtW77KBpAejxDj3VpHeR
         o5uce87VKRdlPppVqycwkMGsWq0QiaWa5Irwxay72qQ6ulR2nPp03/g72xTenornlygo
         0WbP7J7K8lARAowsPoRRIZx3X4kAHAs5MufiVZ/aneqjXP9saWAE+SoYOnI7Pl/jakEJ
         L/jpCEZR0dYxpUATDSJknORNOx/vks93QdkB4XVAOmhpXTYNVRq3ClVCXhnHL4GZvvT2
         i5Rg==
X-Gm-Message-State: AFqh2kqG+zU7NoLQH7e+x+iXqveAtWqI460JLOoivyNNJLnahbSBGVno
	yurS7+VAgg4pQGYNQ/QAhktyBljTVpjdug==
X-Google-Smtp-Source: AMrXdXtCfy1jIMLXxGdkB1qRX4MoYXpbEzTbjEnEa1WpelHoYyJ+3tvm/1Xz/D7sg2og6hJcnmq08VBe0DG8Ug==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:22d2:b0:58b:a1bd:6aae with SMTP
 id f18-20020a056a0022d200b0058ba1bd6aaemr425501pfj.25.1673581810284; Thu, 12
 Jan 2023 19:50:10 -0800 (PST)
Date: Fri, 13 Jan 2023 03:49:56 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-6-ricarkol@google.com>
Subject: [PATCH 5/9] KVM: arm64: Add kvm_uninit_stage2_mmu()
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
index dbcd5d9bc260..700c5774b50d 100644
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
@@ -1852,7 +1857,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_uninit_stage2_mmu(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.39.0.314.g84b9a713c41-goog

