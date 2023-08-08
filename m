Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E9229AB
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 23:13:39 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d60d944f40bso173621276.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 16:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536419; x=1692141219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rRsJm5KN8y0omlFlyBVh6FOC8Y/5Pdk4ttGOceHQNGg=;
        b=CQf/TxanV6OEd32ELCfkkts3XxnHA4pKxGHkzWqcVZLhDHcGXQK8pxhlEmtKwP/tpP
         UAyUov8OA4rqJcX0xB4frWPFkoC8zGz0reXRyqNoFb6QQc7uiAJt57EURlLsfXhtvSua
         dVYnrRYGo2ZXskRE7T0A21bujPL542X8vcR00OPyT91QR3v88w0f/6FbYWXk1Xzn0erM
         sTAg25XQTO1XYYl95Z33YL5N1hptl2XY6pPHEzG2zsJje3brq/4ttctRSjL4Be7i5xzH
         VbfCPWiV7RKvMZQeOm7dW2jfJtV7whha+buhr6WES83vayzqgg3bRBsrouX7l2lyMHB5
         9ejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536419; x=1692141219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rRsJm5KN8y0omlFlyBVh6FOC8Y/5Pdk4ttGOceHQNGg=;
        b=co7xXRI5FuQaZW4mthu9Nef2hX6PuHi3nmo7F1Rlv5fjfhQJz4fSvDd0nidLxaE+Pk
         +9ohjcaoYp8T1W/u0JI5SDDnN3Tzqbde6n0n06I6ZP5jDBvpAYGjwB3t3aYdGK6HciBQ
         ZQWGeuo1OTVv9xWV5rHCoKXogT0bwl80K1+aZAJBfE2nbI9JmYSpGwBRREk0Lr55+1sX
         igekL9uyabNwkb+DPfNz3SvyqGmQvCDavwRSF3RCa7U9LlraMXutY/1817bwgUlYpX60
         qDkPQi6xmkSKMmC20Rxs0v4LZP09i4E7aogsGLZm0XTmjPH4LpmhgDIvzi+R8qjk19UX
         3E8g==
X-Gm-Message-State: AOJu0YxsJHS4lirfSgOGo/LX9lG8vlkqArHH/ozfTg9ciWBpIIsCe+Io
	kyjCK0wlN1Hfa/NVqz5PfCAgsStnQn98
X-Google-Smtp-Source: AGHT+IFGVRqil1pLKlKZOPozuSk7xjlyKiysAnrSD74F/QH1sqvC3Ds73i/UAyOLkTltrm9Gi6kXcopawKrT
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6902:1788:b0:d45:1b81:1154 with SMTP
 id ca8-20020a056902178800b00d451b811154mr21428ybb.2.1691536419023; Tue, 08
 Aug 2023 16:13:39 -0700 (PDT)
Date: Tue,  8 Aug 2023 23:13:20 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-5-rananta@google.com>
Subject: [PATCH v8 04/14] KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
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

kvm_arch_flush_remote_tlbs() or CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
are two mechanisms to solve the same problem, allowing
architecture-specific code to provide a non-IPI implementation of
remote TLB flushing.

Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
all architectures on kvm_arch_flush_remote_tlbs() instead of
maintaining two mechanisms.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 virt/kvm/Kconfig    | 3 ---
 virt/kvm/kvm_main.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index b74916de5183a..484d0873061ca 100644
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
index 70e5479797ac3..d6b0507861550 100644
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
2.41.0.640.ga95def55d0-goog

