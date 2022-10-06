Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7322DC4332F
	for <kvmarm@archiver.kernel.org>; Thu,  6 Oct 2022 00:34:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8515401D7;
	Wed,  5 Oct 2022 20:34:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pdnwjvq8Kuwp; Wed,  5 Oct 2022 20:34:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76A6941071;
	Wed,  5 Oct 2022 20:34:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D21E340E06
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Oct 2022 20:34:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pVuiMRCm2W7g for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Oct 2022 20:34:14 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C83E40DE6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Oct 2022 20:34:14 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 g15-20020a25af8f000000b006bcad4bf46aso358089ybh.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Oct 2022 17:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=GIXZqz4S9gWDgXZeKdFPnqIjPobn5Yc/nbFocXqDJu0u/B8V1ytiYjkCX6m76Ina1t
 MIofXCTex3iATgPRgZIGFO68aYlK2coaXvGzovgYAu/unO0Dkwx+TRWDehuPmyOdAmes
 1phy2LsaSuGZlWvM1kNcCZN4QhKtdJuThyJ4VitLh64X1wpfvO/zYaQaiZFbF0xRSXWK
 Z3ViSk7BrTlqVTqRytgv7Ke6H6ruIOSQuDW9nq1CirdnMh1ojFTmr31NTeBuRDQKWUtq
 ZrrBY9e3/BWlv3Z8+ciA/KdS+E8cUT80fo6lVHlavUplaV2S8j/ZzY+G1cJoTpeEq/OY
 Gvkw==
X-Gm-Message-State: ACrzQf28QfbnJl1+KlPL4QgTs6S7bXkNZEruWmUQTHN1cVF82K1PyjIq
 3+9IwTip+mPDi/1N+CGiurj5ItsLGAQ=
X-Google-Smtp-Source: AMsMyM5GoF0VwOlSnE1/Af4DhxMzGTCQS3omOdlhLBZkXBmerEM6VVh7882ZBLcBagfLbnLAIrgnQoTB6v4=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad13:0:b0:6bd:9745:a428 with SMTP id
 y19-20020a25ad13000000b006bd9745a428mr2331326ybi.563.1665016454054; Wed, 05
 Oct 2022 17:34:14 -0700 (PDT)
Date: Thu,  6 Oct 2022 00:34:02 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006003409.649993-1-seanjc@google.com>
Subject: [PATCH v6 0/7] KVM: selftests: Implement ucall "pool" (for SEV)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Marc Zyngier <maz@kernel.org>, 
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: llvm@lists.linux.dev, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Tom Rix <trix@redhat.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 Peter Gonda <pgonda@google.com>, linux-kselftest@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 linux-riscv@lists.infradead.org, Andrew Jones <andrew.jones@linux.dev>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
