Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043254C93
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 18:40:42 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-506466c484fso29736357b3.13
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 10:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h/7CzzPaxtQW9FqsAkJDtgMVrAg2jNAu+hAw27KBMYo=;
        b=g8AX1ipZSIbLVD3gfe58wy2rTVB/dr2ealvgQbKCVGSLZetlE4PQ+KY9VjR6EUXkwp
         caVC4IOIK9MZHE98FrqmtKDHm3UwXI1YznTu7ZINOiTwL8n1tfMC7kDWmiTRS0bBdnBV
         NE+pkBhXOHkGFQeL6PBdUWp7shK46aAs1M0ZglUb+UtSTpNjCBRvN5d0tm5lZqs/Z73c
         hnZsNOAj5AfUZ5l5fXMro8gtq2IYMIXWYeRkjU6KCsqN/wPNKmzEx+P1yOM2G13pXj3A
         tmftnVodPMVKagV7IVRfrPCOx54L8LquGqGx7X6DDLutz07f3Ys2ykl7vlOP/pCGStdi
         aafg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h/7CzzPaxtQW9FqsAkJDtgMVrAg2jNAu+hAw27KBMYo=;
        b=JCAJb3hAm08W24QusiBZrZt98jsKIpVUhNtzlPgtydgX1bp8toU2t6vjac4rO/VZpb
         iRz8RzoyS+YP8OqlacI3EOty4Ac2EMFIh5P5440Abq+ZCfweXzUbHYppR7EKNN/8k1w4
         N8WZuoE9qLA6yEe9T0IV4puGwrtPkld0lLSB9r2XESbrlRqNgeYbwf/CBVqyojKA+odX
         YwGSVTu9m+BPZtczpeVok2Uun/Rss//NpdUMcmGbFs9upy95OLHfnms6+fwAULCCIwIW
         /4mvtBrXhEdAX0Or0WBtlcuG/QQUYiZSiH0XNKb1E6fcn86tT8Yj/F4TEPGOQInkDDkP
         ACHA==
X-Gm-Message-State: AO0yUKUY+OV4ByfmOyl1zUIWaeKz2am5OvhXFPsaN52tTv3SUPevDVra
	JPgXOGdRVh+P5flTdZ1pgz2Y83VpCGI2MA==
X-Google-Smtp-Source: AK7set8aHl/591d8oPPiS82D685GhQ220gmn327zcVGVq335UGZHfVeBBJY9cAh4v66Bi8yUKxNSXG9xQHgs6Q==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:7e4b:0:b0:506:4f19:740c with SMTP id
 p11-20020a817e4b000000b005064f19740cmr1073915ywn.383.1674758441976; Thu, 26
 Jan 2023 10:40:41 -0800 (PST)
Date: Thu, 26 Jan 2023 10:40:19 -0800
In-Reply-To: <20230126184025.2294823-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126184025.2294823-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126184025.2294823-2-dmatlack@google.com>
Subject: [PATCH v2 1/7] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	David Matlack <dmatlack@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_arch_flush_remote_tlb() and the associated macro
__KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() and
__KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.

Making the name plural matches kvm_flush_remote_tlbs() and makes it more
clear that this function can affect more than one remote TLB.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 arch/mips/kvm/mips.c             | 2 +-
 arch/x86/include/asm/kvm_host.h  | 4 ++--
 include/linux/kvm_host.h         | 4 ++--
 virt/kvm/kvm_main.c              | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 2803c9c21ef9..849eb482ad15 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -896,7 +896,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
-#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-int kvm_arch_flush_remote_tlb(struct kvm *kvm);
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
 #endif /* __MIPS_KVM_HOST_H__ */
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 36c8991b5d39..2e54e5fd8daa 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -981,7 +981,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
 }
 
-int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	kvm_mips_callbacks->prepare_flush_shadow(kvm);
 	return 1;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c837b06258f5..561d31d9a7da 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1806,8 +1806,8 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
 
-#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	if (kvm_x86_ops.tlb_remote_flush &&
 	    !static_call(kvm_x86_tlb_remote_flush)(kvm))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a7d6a6111f5e..9366fea46e30 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1477,8 +1477,8 @@ static inline void kvm_arch_free_vm(struct kvm *kvm)
 }
 #endif
 
-#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	return -ENOTSUPP;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..277507463678 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -363,7 +363,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	 * kvm_make_all_cpus_request() reads vcpu->mode. We reuse that
 	 * barrier here.
 	 */
-	if (!kvm_arch_flush_remote_tlb(kvm)
+	if (!kvm_arch_flush_remote_tlbs(kvm)
 	    || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
 		++kvm->stat.generic.remote_tlb_flush;
 }
-- 
2.39.1.456.gfc5497dd1b-goog

