Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28CC633
	for <kvmarm@lists.linux.dev>; Sat, 18 Feb 2023 03:23:26 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id e83-20020a25e756000000b0086349255277so2755193ybh.8
        for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 19:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GBUZ1MvoHSzPOlntwcFWNJ7NDg9kNgKK6wVJ4q5z3So=;
        b=Pg7rxK6++ZYeD8KtaidJr0Wlm3ceogsYfwldGjTjvNz1HwY9odkMb5eIjO74WA6uF6
         q0aVxvuXklbDuKZF6u60OW8A97f/zWkg/cmBUzNHuOvkxwXhjall/kirQzn7IKrGS1Ib
         ztKTTjRT7Rgo/vYTI4A2YLDV9FjX0PeD2ZJMdXZwfXCcvam5YDHgtYFp0UA7JuQ8wq8k
         uYubfSdMLjySUAx4uKzh9UrLkIaN/vhK163zYJ8tUTKOgfDIniJFB2x8/SlYbcFJkNwy
         TQSKB/MxzkMyL9YJ6Won8+r4yWNQsLLj/UMUAVjUN6hRgwDwZ3w+G1fqBHAJYcj+gz1G
         aCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBUZ1MvoHSzPOlntwcFWNJ7NDg9kNgKK6wVJ4q5z3So=;
        b=BuBCqU8fW/Kh8k0KiG0ECPG0bQ2tSGyVMbZvTwGZBAcrv1eVTbiIkY9RSo4gcqgMCW
         Cxqx9GgpxKH4Bt8UWiyXi1m8QrxvO9AMe3jOwBQW2txwrYlgeIy+bDwi6EodA7P9In0S
         Jj22uai3x+8SluI2N1srigSyzlq529x0oF6oGrjFigvpjH0BuuWedTA4bLVGw95q4F69
         F+gYeEXUfFbsB5uMZqCJFO5XuPnuquj19RIafzsXo1otZMWXaVdDTD2YGttcX8NYDQ/o
         7G8uRrBXlMbkWTOGxDxps1GwkKySIR3PXSXj3grh6tpzqtlmHmwbWu/hDWqJUVsvRTra
         lxgg==
X-Gm-Message-State: AO0yUKVXbU6A6M24nZpK6KO4jiNkW6m0Es1Kp2b3aqKkFGo/n0z0DlE7
	7fLhsQPYdQSIcYVfu7LP6qvsp1wWlKa3Fw==
X-Google-Smtp-Source: AK7set988k9/1hvcxfifUIiwdm6LLPOaqIcWDkdvnEu0U/xKw1bqb0HuinJzSTR6CuyoTY6y5/u56D+2UWFkGQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9341:0:b0:8bb:dfe8:a33b with SMTP id
 g1-20020a259341000000b008bbdfe8a33bmr216446ybo.9.1676690606409; Fri, 17 Feb
 2023 19:23:26 -0800 (PST)
Date: Sat, 18 Feb 2023 03:23:08 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-7-ricarkol@google.com>
Subject: [PATCH v4 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
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
2.39.2.637.g21b0678d19-goog

