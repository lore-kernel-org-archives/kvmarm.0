Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB2310F8
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 04:51:38 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-58667d06607so19955427b3.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 21:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729498; x=1692334298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FjqK2i9iNfdCdXxEpH6EmuQikOPCWBkIYlUFD/yGaDg=;
        b=r3i6w54chxe/m30aMtVSgvkKBw1KsUaf9mnPdfDF9T7G23UAZLBlzAbYwBcw+8/TEP
         TIXUprktoIJvbhghifoTokWKfb3fsWuJEGznw9UnxoxDzZASXjGptbwbxjCA6kWdWKbv
         1BXyNfas0RyElNo3kSpbNMxJzkQ5DV1JnViee3PvCsXKXzhyRRy66gQtf/gMlx6nPZLS
         W3ZvPJVBTfpDVbg4rpa+Yudvhp7wHsWOtEJhRLCCZ4ljXaPQ97jKH76YhbAKHzFA8haO
         RHWuu4Ft7sFeRAtPpG2uAYJ8O0PHxSXrSq3mACDc91bgObmkiHbVAYRiWp4aDtF5bXrr
         V1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729498; x=1692334298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FjqK2i9iNfdCdXxEpH6EmuQikOPCWBkIYlUFD/yGaDg=;
        b=cHnSRyC0jwJOX+7t/RT3yEl8oFX+R0FOWbiNJzzGQScJx0i6P0ux7y+ScI+CUWI36A
         /cYg1uj5CWpcDRd4UAOmxIhcPzkD+MUz/55xyfPw34F6gm2sJtDHniJuMuSdnwFmXhSc
         61QNq1uNVURjEJ4XChagOFSAQQXyDxHxAlYyCtFvnjhbMCyfI7qT6wTnF4WzvK0OAarm
         OGjK4P5LnNGg8ZSkewVoDWYCp3DAxzDdVNj7zBlFKr2YoR0cAO5jmD7mn8Azjv7hoATL
         XUlKrySM9AG8RsrqegFDWWA0iILoJ1WgH1MRsqQyCesx/QzbOyJuFRPRMB39o3I03PW+
         dodA==
X-Gm-Message-State: AOJu0YyVfvo9YoLfhIgcDwe9S9YQduafRdH8LiXPZPpOR3f10faxK6JN
	P3j2zcw1t5ZmGjmmuePegSRTHVUu0p48
X-Google-Smtp-Source: AGHT+IGBvRwTUndHgAap/N4BT+dWrSJMB4+V6DQ3W4WJT35AoKaFobGrZSBaBrpjzeE8RCoth/jJXPL4hWmQ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:ae0e:0:b0:576:8cb6:62a9 with SMTP id
 m14-20020a81ae0e000000b005768cb662a9mr13062ywh.6.1691729497878; Thu, 10 Aug
 2023 21:51:37 -0700 (PDT)
Date: Fri, 11 Aug 2023 04:51:15 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-3-rananta@google.com>
Subject: [PATCH v9 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
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

There's no reason for the architectures to declare
kvm_arch_flush_remote_tlbs() in their own headers. Hence to
avoid this duplication, make the declaration global, leaving
the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
as needed.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
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

