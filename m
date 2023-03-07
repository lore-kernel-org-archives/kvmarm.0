Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE3136E
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:09 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id k6-20020a25e806000000b00a623fca0d0aso12803450ybd.16
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN3sAgatY30dvS/hR4J9z2QVjgT8HvsLL4dUuJImQN8=;
        b=dAK6HETYeiYyond2AcQHrqGNItpAGjAxFodehdXpS0NSXe0LhO1tQRuhGDxUTLkj9c
         XLl9Jrkl5zjP3BlHNlbuGOfg57xfWfUU+nDEU29k8WZcrGPiIqTqhl7p3dlDBNZAkRyt
         2OdJWN38OBvXHQuBrMRr/71cvhTqRzaFxDrIaTYkC+F44z3RGpgwkvinNFnAa7qQ+ZLk
         sAeGXYEn0FYujWYUS0ycmOwjOPCOmv7Pi4jxikYP7aS1G4zCgW3sYmDnyZnKCJeqtmHX
         Fco+wrGTp+Qq40vEh8u0uKi0V99TasPxChnTEV85w2w2RyezJBH+n6pEohyteS4iqmom
         44pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN3sAgatY30dvS/hR4J9z2QVjgT8HvsLL4dUuJImQN8=;
        b=FTy54zVaHeSxJOcqPCJpRJWAln6S9sJaHySDts58Kibl3YFoJP3KTFith+gMmy7KIZ
         3hKsUi7/CUVL6tzmvDH6qQk/zG3f1OlDjuXfAMLSdfNhjSUTk7raoHbUKxs1UA2M4pBm
         3pmBtqT9cIN6ZVkcz4hnFR0PI2aTkhf5o0UQn5cNeMnVVZb7tVrfhBy4cU2BV6x3yDiL
         8aEsAbPiKWiqNSBx8RL4qtUR0HTU08jbLcmf5vkIe4GP84hL7Wbj8XIh2rjGcDndMZjo
         I2a311WGFtEGsLxdHcxqyuIhdaULMDjJEguiRdONZ6QWINursRR4aTq67zbl6YT41K5Q
         raGw==
X-Gm-Message-State: AO0yUKVvUgZDg7cTp9wwThgT2poV3b2jVkLNWTPwv1J0AAs8v4OpKfhY
	+lbEetKE6BZ9+ZwacUE30OvqFl/6Ysf+NQ==
X-Google-Smtp-Source: AK7set8ee95We8gb4rYyXJWSKJuRj4FB8E8hjjSXq3ql7PAhVhxEmqmhoG9N1QXJ7pfXVYz0MboxUFHbRuwhsw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:b243:0:b0:52e:d380:ab14 with SMTP id
 q64-20020a81b243000000b0052ed380ab14mr6675889ywh.3.1678160768167; Mon, 06 Mar
 2023 19:46:08 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:49 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-7-ricarkol@google.com>
Subject: [PATCH v6 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
future commit will add some more things to do inside of
kvm_uninit_stage2_mmu().

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 1 +
 arch/arm64/kvm/mmu.c             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 083cc47dca08..7d173da5bd51 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -168,6 +168,7 @@ void __init free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
+void kvm_uninit_stage2_mmu(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 37d7d2aa472a..a2800e5c4271 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -767,6 +767,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
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
2.40.0.rc0.216.gc4246ad0f0-goog

