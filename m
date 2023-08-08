Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEFB1BB4C
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 23:13:38 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d47a02fc63fso4747496276.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 16:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536418; x=1692141218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yofTwj8ZWcGjgw9v2JlEZNUSzmrec+LwekHHUJcpAoM=;
        b=dpvxAljlEqRicljPQxNOJb+MByUQynWkaoJYtNkwzaTYBVofoDLxhXQ4NUQQ/PzLSf
         NAtCKDbb8oJ0I+3uBtvhYWPM5zzVcZGZW3pDxQOMxKp+lvQ7BjdFrNc/q/apmXEYUx/b
         QhVGqmoFiocVQByOfmb4QZxlbWrg6Ieus4zhxHuCqIJKlof4GWqyS/gC4YZttzjEIT/h
         Whg24RDAmIE9PEXxBdCoM/i4l/H27VeCyO3o8GhqYAZYL0To+EyyDC+2J360ckq2AoBz
         pk0d/gNWDg05ec8YE3MwSGw7fdP5YwY4vaL8VuAGMAaNIrbzBVJmLTs6Pw2oc6uWyPcm
         NgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536418; x=1692141218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yofTwj8ZWcGjgw9v2JlEZNUSzmrec+LwekHHUJcpAoM=;
        b=WC8hIHi67pD4PkwkpUW20Jh2KxxcUrdUqfgIboqptTDqb3HJ5EtlxJBGS69pFIw//t
         Om54wSy82yCH2OXRrSKo/6BgHvtvtchFxF3qHYuR5tEjdao8RSCF9JrxvY43qY4Aka5F
         QoUeDhb1yuuFX6HPJxjarzz1xSCT4UQiyYjT9RxiH5he4p4fP8fKuS7ZOLgI5efrSF6H
         NdTq+fL7TC1nRDaKcj4wOW8H8naJsuxVpDzJ/ms2GOwvKsSqG2L1/7wK9G5tCAzt7DpS
         ZKuP7cqqDMpgDsARTDgza+PdzGdMqCdb7B6Fr62niDtGebDnjRA3Nh87NU1NniwbI31y
         4t9Q==
X-Gm-Message-State: AOJu0Yy2Auf1xJhgNqj9DfIFNVA4eNHj7o5dro59U3nvh7J3ttwOM6NX
	mHn0XbUZXgU9eBW35t7el0D35zeOnkVh
X-Google-Smtp-Source: AGHT+IEMoPWfeZ+OLCK2D9UT69oNcAo0brgl53831EkFIxzA/BaKPU3QvQO6q12mm6VixOduKcfqU57b7CIQ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:e90b:0:b0:d35:bf85:5aa0 with SMTP id
 n11-20020a25e90b000000b00d35bf855aa0mr23366ybd.4.1691536418029; Tue, 08 Aug
 2023 16:13:38 -0700 (PDT)
Date: Tue,  8 Aug 2023 23:13:19 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-4-rananta@google.com>
Subject: [PATCH v8 03/14] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Stop depending on CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL and opt to
standardize on kvm_arch_flush_remote_tlbs() since it avoids
duplicating the generic TLB stats across architectures that implement
their own remote TLB flush.

This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
path, but that is a small cost in comparison to flushing remote TLBs.

In addition, instead of just incrementing remote_tlb_flush_requests
stat, the generic interface would also increment the
remote_tlb_flush stat.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/Kconfig            | 1 -
 arch/arm64/kvm/mmu.c              | 6 +++---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b6096753740c..20f2ba149c70c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1111,6 +1111,8 @@ int __init kvm_set_ipa_limit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index f531da6b362e9..6b730fcfee379 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -25,7 +25,6 @@ menuconfig KVM
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
-	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_XFER_TO_GUEST_WORK
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6db9ef288ec38..0ac721fa27f18 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -161,15 +161,15 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 }
 
 /**
- * kvm_flush_remote_tlbs() - flush all VM TLB entries for v7/8
+ * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
  * @kvm:	pointer to kvm structure.
  *
  * Interface to HYP function to flush all VM TLB entries
  */
-void kvm_flush_remote_tlbs(struct kvm *kvm)
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
-	++kvm->stat.generic.remote_tlb_flush_requests;
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
+	return 0;
 }
 
 static bool kvm_is_device_pfn(unsigned long pfn)
-- 
2.41.0.640.ga95def55d0-goog

