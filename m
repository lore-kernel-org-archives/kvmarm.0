Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC966184F
	for <kvmarm@lists.linux.dev>; Sun,  9 Apr 2023 06:30:15 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id li17-20020a17090b48d100b00244ae07573bso1158830pjb.4
        for <kvmarm@lists.linux.dev>; Sat, 08 Apr 2023 23:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021815; x=1683613815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1I0qN+j3qFL2imk4GAvstB9QkebvP0/XiCYPzHn1INg=;
        b=HNOJL+66yf/bP7wwCyPoau5OKtvop6LsWi/F7VDfjHL6WHG4tXRMvp55R5eF13eOCf
         LV3xQVWL16bfH3sfIiPzJ4nQY0nHusxPk0EDrU53sWuxSzFqLVQQI04jlAL9A86sLbwH
         7Wdr4Y/8drCTasNLIWjeqVPMfD/2emxEaeb7KMPS1t4Inp6Ema4KBHo8m8x3sbvqYkzg
         Mg0fUIbv07Oouxx8Shd0BQaxso893CF4/vSu+IvnA8FaLCNtJ9/Jr7obii3kvy8KNW4y
         xbn6Od5dbdZ7qYwsfYSAmdmPIrJnTXqA4jZx/dAIXPYepFw7T5xMD3BojzbLTPMYNB64
         smIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021815; x=1683613815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1I0qN+j3qFL2imk4GAvstB9QkebvP0/XiCYPzHn1INg=;
        b=gTX5clyn03opP7uI8ONVtXokTXuWWIOP0jE2hFu6tcB61wZVtWG7IDay+q+j65j8Wa
         suDWVfy+n1xXZoV48MocEBKo58u5F78HtyrbQryNpuiyJeDdGVTdTlUEUXsBbEMvRB92
         XEFTvB8E6LagKhwJWPO0YMcOn40eem4lruwSCF289iOuahN4JTOrl1H/kAUgJEQen6uI
         89QRHHZzJSF5B0kwvZsaTM0F6r5fzvuRNg0hiHjHtc7TScSwj9C0eTAt9juww6g29bAz
         RbEt7lDpvH780Oq8pQzkppCIzX3n6dzuBH7XmC71lO5/osEnfCoZU6QVqJRT9g+dRQ9U
         ymSA==
X-Gm-Message-State: AAQBX9fl1nLDW/Up4kIIpgaONOgUFNH7UglXMabeGizulBuJZ1yqrpRv
	YiJFuNuAw13wnSoNPciH/C2lYDNF06uRVQ==
X-Google-Smtp-Source: AKy350ZcYA5zcM2WU/yvBVYd6XWlLEBWkwbeWGFnJ4AGDD/0B+opvbdZpKjKSMq8iya2EoHUyGiIiCDWImLP4g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:2c4c:0:b0:513:90ed:3c22 with SMTP id
 s73-20020a632c4c000000b0051390ed3c22mr1695193pgs.2.1681021815334; Sat, 08 Apr
 2023 23:30:15 -0700 (PDT)
Date: Sun,  9 Apr 2023 06:29:54 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-8-ricarkol@google.com>
Subject: [PATCH v7 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 1 +
 arch/arm64/kvm/mmu.c             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 083cc47dca086..7d173da5bd51c 100644
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
index 37d7d2aa472ab..a2800e5c42712 100644
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
2.40.0.577.gac1e443424-goog

