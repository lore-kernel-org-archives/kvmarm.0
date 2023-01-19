Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53989A93E
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 17:36:12 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id l7-20020a62be07000000b0058de3976793so1218830pff.18
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 09:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Im+iiLjR8kItTyPOE/eTt5JfrQ6vH6VP6QUOOm0Kk1I=;
        b=NDaypEfM14bF96rZQ8+HhBj+hk7vULL62aBgTYqOMJZbA/TFlcBoOs9sPPdVNfYfNe
         hy+wfSSH4BDSz1WThBSYqt2sAf1ehWletnOkE7HUQytb+gI9Re8OgzkWS2mo1I6jEgoP
         A5YK5ZDo9WyQsEjxWBT4rvnxMYwhUntLdJ3c9JnoqQ/mZ7YKkBJREatylJnm/6q91ADW
         UAGK49Ncp5vq94p02BqMu7KO0bKoiDBTYjkeh1wCPeC5Jistb1klwpTxOTnWW3mROQTd
         HXspEOaka5MwYa6n+2RX9A6Q2UndlbAAikglk4E+3jUfk4fiFTsd+YClS+rJmA2nHT4G
         mg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Im+iiLjR8kItTyPOE/eTt5JfrQ6vH6VP6QUOOm0Kk1I=;
        b=NRxsfcjjuEkRpoYU8F9WvMtd9Ni0mG6rilhPhhpE7OjlIAtcqHqRTSv6eGcGYioZga
         W3ZEQ27UO64c/ZUnQZHyFf3iM6B21jvnWMI/b8GcT1HlHORqU2gbVrJoNSZ8Dy4Gh++K
         ys5gmMcDVn0IQemtNFsguMvoROce37XF90JYr7DNMtdErUNmZTFN1b3KPAN0/LAbseqL
         Vq3+jpF205M9Jx2HUtPvOalTu0NYPG0PCHgJ9f5NTmknGoWVuyaKcWcXiBFZ95Qt3xj1
         3TYpdtXpIhl4UtLRxA5U/q2kfR6SlWQyEKORbZDMBtia0qGMdpZIoCgHYswtrt/ovfFu
         RWBw==
X-Gm-Message-State: AFqh2krxwm90pMSD09LabBNdS1plgdyRsYQCzXqn/+Tkc58837qqeJUc
	x07pAl8N0ehdXLYhLDgxachERriefGiDUw==
X-Google-Smtp-Source: AMrXdXsA1M5z0iLozIPBN4P/zxpeV5zGDay7QgahgmS5l1uDJTAuZVCtHiq4az1VYA3Tk0bmeBp7KsSDRfSGJg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:902:f24a:b0:192:ed88:bc8f with SMTP
 id j10-20020a170902f24a00b00192ed88bc8fmr1232044plc.25.1674149771693; Thu, 19
 Jan 2023 09:36:11 -0800 (PST)
Date: Thu, 19 Jan 2023 09:35:53 -0800
In-Reply-To: <20230119173559.2517103-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-2-dmatlack@google.com>
Subject: [PATCH 1/7] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
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
index 4d2bc08794e4..1bacc3de2432 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1789,8 +1789,8 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
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
index 109b18e2789c..76711afe4d17 100644
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
2.39.0.246.g2a6d74b583-goog

