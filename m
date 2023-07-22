Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50606AA8
	for <kvmarm@lists.linux.dev>; Sat, 22 Jul 2023 02:22:58 +0000 (UTC)
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-6b886e8c29cso5652940a34.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 19:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992578; x=1690597378;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ub1b4RkH+SiNL7JMG3rpDZe3A40I4dIIMSmDo0IlQzA=;
        b=C/VOe+HyWigQOD8Z0Nev5iX/p6atEnTdO0Jeq/PtULGuaHrhuLNhdm21BGz/8CY0tD
         iss+SO3j6UMQdC32icOU/L4aipKWKAbAG2m4AEZ0eWxYlZ5dStpt4lyQUxp1f221ANnx
         rofTuy4MoQ5gA75/K76/D+lHaxDP4JGjK6CkofS8SaAYeMDNnMUITgvBbx8WDGXS7jWw
         lnlMhFPftUV/HQgbj8Se2PGayWpWGXpzQjeEY9yzuiQi7E5QysEMYqYT5R3m/jHd365r
         uglIFMgrH+URryb9XtIlschpTQPc17pSLqTG8uy4NxK1X8so9KtfBc92p5Jt8eaCAVHl
         xIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992578; x=1690597378;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ub1b4RkH+SiNL7JMG3rpDZe3A40I4dIIMSmDo0IlQzA=;
        b=CZJggYcwfWPKjhuWTSLR5Z2jBVMa2E9PEI2tsBGTSBvuiZhD5S0Ax+Xgqeh5r+ZAZz
         RDT6Mwa5OByxCGsNqtsCVbSKW5WVctrHji2d2zwchRtwpWlqUEeIhWbBRphxYJSRq2WG
         eM4UzXZtS/B2r5US/fx93A3rj4hv9Nu2pXFTXNqZBS2uzKyV/VglBhJVJoMzVlc6qHAE
         tbkDaH4IZdp20ZHydLjhxFtPDW0N8LZlCW5jF4EBg+mxD2tDrRbOgXagpVPrEZ/Hi1Qs
         QDmWKk0v+tH+TlvilLTvTq/Vp+6NEN1VjWROEqG78q2kXpJvpZbG3re7OoZ4GQ8JYIt1
         wzAA==
X-Gm-Message-State: ABy/qLYJ7mUtKe7di+mAD5b6/rR7tH9IM6Pfi0gAUGWL0PTs8uqyCUWJ
	z0IdHilLQEsaR/qkrGpkk0QcxyBNCbom
X-Google-Smtp-Source: APBJJlFePHecSR1HloqjDSzzI/2i9CNM4+/1NwLnWrMA4yKuyKZVLYbN6w7CAOZHg5mvVOxwFFo83RQaKDLL
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a9d:6d03:0:b0:6b9:cf90:87a6 with SMTP id
 o3-20020a9d6d03000000b006b9cf9087a6mr2197907otp.1.1689992577845; Fri, 21 Jul
 2023 19:22:57 -0700 (PDT)
Date: Sat, 22 Jul 2023 02:22:42 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-4-rananta@google.com>
Subject: [PATCH v7 03/12] KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_arch_flush_remote_tlbs() or CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
are two mechanisms to solve the same problem, allowing
architecture-specific code to provide a non-IPI implementation of
remote TLB flushing.

Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
all architectures on kvm_arch_flush_remote_tlbs() instead of
maintaining two mechanisms.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 virt/kvm/Kconfig    | 3 ---
 virt/kvm/kvm_main.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index b74916de5183..484d0873061c 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -62,9 +62,6 @@ config HAVE_KVM_CPU_RELAX_INTERCEPT
 config KVM_VFIO
        bool
 
-config HAVE_KVM_ARCH_TLB_FLUSH_ALL
-       bool
-
 config HAVE_KVM_INVALID_WAKEUPS
        bool
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e5479797ac..d6b050786155 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -345,7 +345,6 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 }
 EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 
-#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
 	++kvm->stat.generic.remote_tlb_flush_requests;
@@ -366,7 +365,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		++kvm->stat.generic.remote_tlb_flush;
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
-#endif
 
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
-- 
2.41.0.487.g6d72f3e995-goog

