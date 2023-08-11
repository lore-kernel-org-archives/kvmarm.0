Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6381102
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 04:51:48 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-569e7aec37bso19868527b3.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 21:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729507; x=1692334307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oLpltBl1pXuOSkpdQMGZFCQJKBJp7Al35vzbWbo573Q=;
        b=ABgFIwVolq/6ag26A1K+kK7FXdPo3peqsgbFXc8qiwvbhPI3bZRUdLezxZ8tQik92l
         T+iaoKDZaDOv6IfoUeiWPTwxhMI85ie6LyPMFxNj8XDmursgFf3en60dEzF4dqf3h+RK
         WWx7VeXuvcWe37vd84r2WsEbYnf4b0bMiMo48syBpgvZj3Mksg0RwjMn5w1l5qhHm9a0
         rzrR9Pv0NaqoQijOdbcWJVVU6XHeWI2Lcm9tCQY3XKwKjOaLQmbXEehuzJJrIwVg3DQc
         UD1yUHkb20HLZXzkBKX91nLMJ4OeAFKhFEZgnnRUJwp6sPgDeXUVCPtkFFCTN0I7E6Kc
         DCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729507; x=1692334307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oLpltBl1pXuOSkpdQMGZFCQJKBJp7Al35vzbWbo573Q=;
        b=d6HIQbmIMZXzDRnoLRy0/Rgbk6f4DhT8arYnNCLQlBbycoZ6JjiCX7Ve4A37PerLC3
         Q+PhlAnRRITgu5AEadnt2L9T479XP9g0/cJ8Idyr9bEnrrmKQqrdhUs9Rqiu/Q/NBH5O
         WEh2VNN4RUHTvoIRuzQNt74PC28YyuAkKHu0RX3hHh3Z+UM/JNQCwsWPHZh41LM+8jtB
         1GPoZqwXzKgIMxr8OQTjvSxeQYD0BHi8Rwf8ELzYHDgfDEC7hl19xvY4Pqr7z1lf473A
         Hf3pCs1nCf+oJsU+jYuffhZjn5RRDjgrUcGvIniSLWaxPb6FuN78nUOuoXeDFNvLjxaP
         kwBQ==
X-Gm-Message-State: AOJu0YyRC9se8frweqtn5ABwdamf7FzY+H0KBevoUema52px91fGaVR2
	W9bbeazbLvriihQMOMnwKNg3tOvO7vsF
X-Google-Smtp-Source: AGHT+IEO0sAyUJ6vzJq2dvhSW/1XhcAzkAPBREyGCgte4h6OEGCasNix0f17CE/S4vT/rvUZ3pDeQps2/zyR
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:ad51:0:b0:583:a8dc:1165 with SMTP id
 l17-20020a81ad51000000b00583a8dc1165mr13228ywk.10.1691729507118; Thu, 10 Aug
 2023 21:51:47 -0700 (PDT)
Date: Fri, 11 Aug 2023 04:51:24 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-12-rananta@google.com>
Subject: [PATCH v9 11/14] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
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
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_flush_remote_tlbs_range() for arm64
to invalidate the given range in the TLB.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/mmu.c              | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 20f2ba149c70c..8f2d99eaab036 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1113,6 +1113,8 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0ac721fa27f18..702f8715f9fe7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -172,6 +172,14 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+				      gfn_t gfn, u64 nr_pages)
+{
+	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
+				gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
+	return 0;
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
-- 
2.41.0.640.ga95def55d0-goog

