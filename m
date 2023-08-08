Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F47029AB
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 23:13:38 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d4db064e4e2so4240950276.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 16:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536417; x=1692141217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fF9z3Q1T3iKa1+NaqgmsAKQ9ZnVImh9YcGmD8OzK9j4=;
        b=Ld1x0UAAPCU2iNVMHuMjG6B0mRqC01G5XmrR49OD5ekBM+hQ47Lz1vPTQOE9Tr5Br5
         BX4nU2fyQoGGqakeZ7MocsuWSlLwxNgdhGBwiNTVlmTbC+b+hhEmvF5KQzcDGXQHniHf
         dyBlM/h1HcV1T3N3V+nLOLW7Ezrkt/Pno3Kgysbh2Q6+afbzKckk0AnL00fLjdc2sRnT
         VlzSKBNqhrU3kXNgERrGdXMA6yHTAQeK1SKxpS4/hFwjbsJV3fXh7O3sMLhqgXSqH2/5
         7bx3QZPwlmmukhHDNyNKKv+4o0fEeYSAzOCOzLhRc8WynuLwSpq0v0AjFElLDtSI3e7L
         E4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536417; x=1692141217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fF9z3Q1T3iKa1+NaqgmsAKQ9ZnVImh9YcGmD8OzK9j4=;
        b=HFSDnkFoCpMXnyJH+/6ORwR9xTfDtH1DUqE2ztpzMH4J2ydVbDdpUyrUb++EMU4meE
         0QlrUfEZ4UqgdHi9LblG3LchXO0xzMSN8f5I56YfoI7inAQZrb6dk8bF4G+CdCAAIjzl
         1waP/17R+Cak70gp6tjbBJz9gQGfbnwI318KQVbJWs+9J0hVbcV9PjJGBTBhOO0cCHbW
         QauVy+mJoXQ6t7pUe70b+lh4EBJMS2eJ2fIlp7LGVmXAAdz5gQxI1eMMSFNM1j6hkm1Z
         3B4rnBgrbw4ROwm0IAg9hO0GAXQsYw6d7PvkQawj4/Vqh4xpc4pmUfV55gbEVjwNRR1D
         71tA==
X-Gm-Message-State: AOJu0YynfX1leeuDmIYUXBvcY5lx3UpHL6Av0ClpDU01Rug+AYcFtOF6
	eeew3pTPBLOw2TZ86JuS9b+hnkcLoQyj
X-Google-Smtp-Source: AGHT+IEkNRtlsA4ms3b9+CUTzSiCBd52BXOcAxUcg/jLLvdvbtpcQ/Jup7ZubXa24xkvWpmhph0yYPJIU1oJ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:3288:0:b0:d44:585f:dfa8 with SMTP id
 y130-20020a253288000000b00d44585fdfa8mr21095yby.0.1691536417147; Tue, 08 Aug
 2023 16:13:37 -0700 (PDT)
Date: Tue,  8 Aug 2023 23:13:18 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-3-rananta@google.com>
Subject: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
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
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

There's no reason for the architectures to declare
kvm_arch_flush_remote_tlbs() in their own headers. Hence to
avoid this duplication, make the declaration global, leaving
the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
as needed.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/mips/include/asm/kvm_host.h | 1 -
 include/linux/kvm_host.h         | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 9b0ad8f3bf327..54a85f1d4f2c8 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -897,6 +897,5 @@ static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
-int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
 #endif /* __MIPS_KVM_HOST_H__ */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e3f968b38ae97..ade5d4500c2ce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	return -ENOTSUPP;
 }
+#else
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 #endif
 
 #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
-- 
2.41.0.640.ga95def55d0-goog

