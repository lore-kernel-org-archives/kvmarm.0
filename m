Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED092A93E
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 17:36:09 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id b9-20020a170903228900b00194a0110d7bso1733496plh.6
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 09:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YXwKcERxaLuVKb5nhPV+CPBgH/1CDOfYUJatcNI9Lps=;
        b=OTqsYX12neD7rYwEWRn8ph1+Ivtv7Ny3gNRUzRN4gpl2Eo4fWlPbPU6In/4jxn719a
         2slMyQuQUGYeMW/mBJE87s2KFofWL2A+b2t0AGtJWafNEsGMAYWeQipZoQ1wuc/AwP98
         q6x1X0TMG1Ad+kT9cWeSraqE2aVQjTFYY8XrvpXdV5XrOCH5Z0/4P8kT8Gk2C8Whx2FG
         81gR4+aJciehqPLB3q7y9lYytTmBxQ2kqUF/pcLWKVy8x5Z3rc4oYcrFbsLGgX3dj310
         jjv6aYJuXYmn/PCkMZw8+4RuZGYn5ZS3Cw5swhmMDgbV/Bu5G0pBJ9SOJXuv6t7ZXXHT
         rVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YXwKcERxaLuVKb5nhPV+CPBgH/1CDOfYUJatcNI9Lps=;
        b=mxvA8R7iUkIfLKWjfFJto8fqvRGXwQI78nvxJR/O9YpXUJXZxOG08Yrfvu8mrRscLs
         1EBJXRJdAJLNDDiklj00lPD3/fiXohC4CLeHc8sIIvYn65dbAxXdduJZveTS8VqxXPDW
         +eokMTujbawOH1I+sN/77WKuIE/nsXzbaoG5uHhurO2yzFFQQLCajNpAnmLz8hMs5B/y
         oSMqrxyswm6/+IA8AHS1j2Y5KJ1DEgHyL3PrDZgRu7JMBhuBJwlXiWTI2YcJtToVfpqb
         GMeZ2b7bav2xgtgIT4djrJv10FHt725oUQ/KkgyIgG3Y2mq34h9ruws535u5q7WPkr+a
         +ihQ==
X-Gm-Message-State: AFqh2kprb3aUlr+ZlZ+HQxV9F1w7etfrrO4qQUhDjD+op2bcOtR1wWz/
	kkA2UTJyDCNNjeay7xXPc6syR8MZviMB2g==
X-Google-Smtp-Source: AMrXdXuXExC+O9r6ly79uchmV3y9bAojfkYhjynfBp2nNUiPyiTU/esa3EM+EgTfMCGZFP3dGppk25OULxh7DA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:24d4:b0:58b:a320:29b9 with SMTP
 id d20-20020a056a0024d400b0058ba32029b9mr1062701pfv.38.1674149769306; Thu, 19
 Jan 2023 09:36:09 -0800 (PST)
Date: Thu, 19 Jan 2023 09:35:52 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-1-dmatlack@google.com>
Subject: [PATCH 0/7] KVM: Add a common API for range-based TLB invalidation
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

This series introduces a common API for performing range-based TLB
invalidation. This is then used to supplant
kvm_arch_flush_remote_tlbs_memslot() and pave the way for two other
patch series:

1. https://lore.kernel.org/kvm/20230109215347.3119271-1-rananta@google.com/

  Adds ARM support for range-based TLB invalidation and needs a
  mechanism to invoke it from common code. This series provides such a
  mechanism via kvm_arch_flush_remote_tlbs_range().

2. https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/

  Refactors the TDP MMU into common code, which requires an API for
  range-based TLB invaliation.

This series is based on patches 29-33 from (2.), but I made some further
cleanups after looking at it a second time.

Tested on x86_64 and ARM64 using KVM selftests.

Cc: Raghavendra Rao Ananta <rananta@google.com>

David Matlack (7):
  KVM: Rename kvm_arch_flush_remote_tlb() to
    kvm_arch_flush_remote_tlbs()
  KVM: arm64: Use kvm_arch_flush_remote_tlbs()
  KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}()
    together
  KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
  KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
  KVM: Allow range-based TLB invalidation from common code
  KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common code

 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/Kconfig            |  1 -
 arch/arm64/kvm/arm.c              |  6 ---
 arch/arm64/kvm/mmu.c              |  6 +--
 arch/mips/include/asm/kvm_host.h  |  4 +-
 arch/mips/kvm/mips.c              | 12 ++----
 arch/riscv/kvm/mmu.c              |  6 ---
 arch/x86/include/asm/kvm_host.h   |  7 +++-
 arch/x86/kvm/mmu/mmu.c            | 68 ++++++++++---------------------
 arch/x86/kvm/mmu/mmu_internal.h   |  2 -
 arch/x86/kvm/mmu/paging_tmpl.h    |  4 +-
 arch/x86/kvm/mmu/tdp_mmu.c        |  7 ++--
 arch/x86/kvm/x86.c                |  2 +-
 include/linux/kvm_host.h          | 20 ++++++---
 virt/kvm/kvm_main.c               | 35 +++++++++++++---
 15 files changed, 87 insertions(+), 96 deletions(-)


base-commit: de60733246ff4545a0483140c1f21426b8d7cb7f
prerequisite-patch-id: 42a76ce7cec240776c21f674e99e893a3a6bee58
prerequisite-patch-id: c5ef6bbef252706b7e65b76dc9bd92cf320828f5
prerequisite-patch-id: c6e662cb6c369a47a027c25d3ccc7138a19b17f5
prerequisite-patch-id: 15a58bec64bf1537e6c9e2f52179fac652d441f7
prerequisite-patch-id: d5b6fea4724f4f2c3408b95d7ce5acdd4b528b10
-- 
2.39.0.246.g2a6d74b583-goog

