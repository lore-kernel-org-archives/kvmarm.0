Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D504368
	for <kvmarm@lists.linux.dev>; Thu,  6 Oct 2022 00:34:15 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-3562f0fb5a7so4287047b3.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Oct 2022 17:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aS/Wdb92KUsn+dSQWf+yYhnYTdFnVqHuKhKCKXyH9JU=;
        b=F2g4wdl3c+W55IiNBL1XgO+YOlTtL/Cjx1CGVdwkn3nnZikiuEYRXFu5+yxq8XvD8Q
         UnKjxO/Ihl2o7nKCs3Fyoj+597+kBPoBQydqP9spHLrAFp/AZkuV37eBUc24VeghkL8e
         haVbAgTXMwnfUeqSyaf7Qwgnc7VBxGWvMqqr4+HraCL4gw0nLFgfcM8h2qRhivdOmTbl
         xQjAAvTL/Xx+nRVqFB2hx/oPVgCumgax0xpgJ8zPH4AnDa+A0Era8LoseKjRTriNUs2+
         2sp1R3eQ6bZssw7ySWObtNTOd4+HTkPE6I6ZntqOMrN6qr4SUaYKMJUhxZG0gWES5RFm
         M2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aS/Wdb92KUsn+dSQWf+yYhnYTdFnVqHuKhKCKXyH9JU=;
        b=Fvae+RaEoTJVTpjYQe//5ZIQ7nOCReBGNZfptk7LlztVQbXbWzda10a0bAFEqVmbnY
         SxIUD8yfxA9/8pqau1YkWKUd1upXuTJVdl5nei8N6clTrXteUAhbLcjCSXCQ6By959EZ
         +DJ3VaDhvr+vxADSDXxXzHYhX8G9gMpDMhrrvroGVtfMygexxzc3FtIBE2nHl08R7Ekb
         +xGKb/yjUOw4pSW1YM2WA0wI9MGI1bj3e09y7MuHtCbYvTlcZ5vQDcrwSy7IBNYguF9O
         dqEy7DDjunjMuJD+6x1JIltDcNF8/c5gtdljriP8ApTuwbIz0xim0eOi6QjKjJ8+53vW
         uG+Q==
X-Gm-Message-State: ACrzQf1a0ahhLW6y8NdK07uMRBVEIroGPUpsE59GlIe1WFLWkxgad2ci
	3udjhuQgk5qSPoEYgT+keVckZTRx+5E=
X-Google-Smtp-Source: AMsMyM5GoF0VwOlSnE1/Af4DhxMzGTCQS3omOdlhLBZkXBmerEM6VVh7882ZBLcBagfLbnLAIrgnQoTB6v4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad13:0:b0:6bd:9745:a428 with SMTP id
 y19-20020a25ad13000000b006bd9745a428mr2331326ybi.563.1665016454054; Wed, 05
 Oct 2022 17:34:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  6 Oct 2022 00:34:02 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006003409.649993-1-seanjc@google.com>
Subject: [PATCH v6 0/7] KVM: selftests: Implement ucall "pool" (for SEV)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, Tom Rix <trix@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Peter Gonda <pgonda@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221006003402.Eoz7comrJxtxlKWR7v2bTTkaNNP5Umi3Tb0Uje-AS-E@z>

Rework the ucall infrastructure to use a pool of ucall structs to pass
memory instead of using the guest's stack.  For confidential VMs with
encrypted memory, e.g. SEV, the guest's stack "needs" to be private memory
and so can't be used to communicate with the host.

Convert all implementations to the pool as all of the complexity is hidden
in common code, and supporting multiple interfaces adds its own kind of
complexity. 

v6:
 - Collect tags. [Andrew, Peter]
 - Drop an unnecessary NULL check on in_use. [Andrew]

v5:
 - Use less convoluted method of writing per-VM "globals". [Oliver]
 - Add patch to drop ucall_uninit().

v4: https://lore.kernel.org/all/20220824032115.3563686-1-seanjc@google.com

Peter Gonda (2):
  tools: Add atomic_test_and_set_bit()
  KVM: selftests: Add ucall pool based implementation

Sean Christopherson (5):
  KVM: selftests: Consolidate common code for populating ucall struct
  KVM: selftests: Consolidate boilerplate code in get_ucall()
  KVM: selftests: Automatically do init_ucall() for non-barebones VMs
  KVM: selftests: Make arm64's MMIO ucall multi-VM friendly
  KVM: selftest: Drop now-unnecessary ucall_uninit()

 tools/arch/x86/include/asm/atomic.h           |   7 ++
 tools/include/asm-generic/atomic-gcc.h        |  12 ++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/arch_timer.c        |   1 -
 .../selftests/kvm/aarch64/debug-exceptions.c  |   1 -
 .../selftests/kvm/aarch64/hypercalls.c        |   1 -
 .../testing/selftests/kvm/aarch64/psci_test.c |   1 -
 .../testing/selftests/kvm/aarch64/vgic_init.c |   2 -
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   1 -
 tools/testing/selftests/kvm/dirty_log_test.c  |   3 -
 .../selftests/kvm/include/kvm_util_base.h     |  15 +++
 .../selftests/kvm/include/ucall_common.h      |  10 +-
 .../selftests/kvm/kvm_page_table_test.c       |   2 -
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 102 +++--------------
 tools/testing/selftests/kvm/lib/kvm_util.c    |  11 ++
 .../selftests/kvm/lib/perf_test_util.c        |   3 -
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  42 +------
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  39 +------
 .../testing/selftests/kvm/lib/ucall_common.c  | 103 ++++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  39 +------
 .../testing/selftests/kvm/memslot_perf_test.c |   1 -
 tools/testing/selftests/kvm/rseq_test.c       |   1 -
 tools/testing/selftests/kvm/steal_time.c      |   1 -
 .../kvm/system_counter_offset_test.c          |   1 -
 24 files changed, 190 insertions(+), 210 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c


base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 
2.38.0.rc1.362.ged0d419d3c-goog

