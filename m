Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818D7C32792
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 03:21:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1D614C25B;
	Tue, 23 Aug 2022 23:21:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9G5iZxbWVlub; Tue, 23 Aug 2022 23:21:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85F144C282;
	Tue, 23 Aug 2022 23:21:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 295F34C25B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 23:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AnUVrDlCB1u3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 23:21:19 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 01A9D4C259
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 23:21:18 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 ay17-20020a056a00301100b00536546075b3so3862065pfb.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 20:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
 bh=0PgRhcNFQ7wUH/xHyENNgGO5Y68ff82pBwc9ifNEyXw=;
 b=cqHjEyrC8/5Ptg3s0VemFx6Afe05DyCrV8I1WrMH2BuvEwwsDY1YsrbGXctw65VldG
 fAmhyiPz7pkRXrbwBZ38vyCPLv5QBCP4oH+/gu1mKhgYTPOR+Ya+5b3VA+2WH98XQmBq
 1FOvFOP3tIyLS9BehwIqIBtCj8lM/BvWhTdiI/ce9pRiN9eKP9sHPyAITpNwOJ3sO+2N
 4YCabFxHGqjIDcC9CP17NKHtJTtA5CdGAUad7ynG0wNtC4Vfe2QJX6PECaOymuHUk10t
 PuRSnM35P9sTAO+sSnGlTY4exlZjjiMPgXiy+eydM2ZxalQexAZSKP4RIGtkmpgCQfsB
 7euw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:reply-to
 :x-gm-message-state:from:to:cc;
 bh=0PgRhcNFQ7wUH/xHyENNgGO5Y68ff82pBwc9ifNEyXw=;
 b=EedHtFfXYfJp8zy0wHeUGk1zXFETiqkOkNNCO7JSpL5R3jzuHHadG7BUifOorYIdY3
 Gc8QloJBQK96ZqF/G9PXbbimYRidqanKfAL1C1CvygI+OrBv6rD/5YRQ69DzE9LlRM9t
 q+5cCC9wTd/No/Dk59UTCVu5T8z8c2+ofbL0TPTZ54EDxPsQpBqFtPTOoUswt0pPwPaK
 jA34AztyVUsjODxRfnxKByzjDOYui7oq3V5oxiHvJNz3p1G4sIZNykmEkHbbbDro2mkb
 IkbcSio0EQ9Bq7s9wFJ04MgIahGb4UqEdQ6yQyqskAMdkhBfSRVIS+RA92AauJX2JTmV
 Gc5g==
X-Gm-Message-State: ACgBeo33JEthqNPl5PT3qvxAG6/qYY0k/G0AH9a9m+ncg4g6BzJhttoP
 AsXPywY8fuovZlFisVDzlXBietnCYYM=
X-Google-Smtp-Source: AA6agR63ilrlfg+EIittKBqsUyfiZ4SJp+plrm1tSJz8p5Jon3Gzg8eg5LcSRgWaSK1dHMSOxMnJUkNlhh0=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ba8e:b0:172:ddb9:fe45 with SMTP id
 k14-20020a170902ba8e00b00172ddb9fe45mr14718860pls.86.1661311277642; Tue, 23
 Aug 2022 20:21:17 -0700 (PDT)
Date: Wed, 24 Aug 2022 03:21:09 +0000
Message-Id: <20220824032115.3563686-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v4 0/6] KVM: selftests: Implement ucall "pool" (for SEV)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: llvm@lists.linux.dev, Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Tom Rix <trix@redhat.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
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

This is "v4" of Peter's SEV series, minus the actual SEV tests.  My plan
is to get this queued sooner than later so that Peter can build on top.

Non-KVM folks, y'all got pulled in because of the atomic_test_and_set_bit()
patch.

Rework the ucall infrastructure to use a pool of ucall structs to pass
memory instead of using the guest's stack.  For confidential VMs with
encrypted memory, e.g. SEV, the guest's stack "needs" to be private memory
and so can't be used to communicate with the host.

Convert all implementations to the pool as all of the complexity is hidden
in common code, and supporting multiple interfaces adds its own kind of
complexity. 

Tested on x86 and ARM, compile tested on s390 and RISC-V.

Peter Gonda (2):
  tools: Add atomic_test_and_set_bit()
  KVM: selftests: Add ucall pool based implementation

Sean Christopherson (4):
  KVM: selftests: Consolidate common code for populating ucall struct
  KVM: selftests: Consolidate boilerplate code in get_ucall()
  KVM: selftests: Automatically do init_ucall() for non-barebones VMs
  KVM: selftests: Make arm64's MMIO ucall multi-VM friendly

 tools/arch/x86/include/asm/atomic.h           |   7 ++
 tools/include/asm-generic/atomic-gcc.h        |  12 ++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/arch_timer.c        |   1 -
 .../selftests/kvm/aarch64/debug-exceptions.c  |   1 -
 .../selftests/kvm/aarch64/hypercalls.c        |   1 -
 .../testing/selftests/kvm/aarch64/psci_test.c |   1 -
 .../testing/selftests/kvm/aarch64/vgic_init.c |   2 -
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   1 -
 tools/testing/selftests/kvm/dirty_log_test.c  |   2 -
 .../selftests/kvm/include/kvm_util_base.h     |  16 +++
 .../selftests/kvm/include/ucall_common.h      |  13 +-
 .../selftests/kvm/kvm_page_table_test.c       |   1 -
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 101 +++-------------
 tools/testing/selftests/kvm/lib/kvm_util.c    |  11 ++
 .../selftests/kvm/lib/perf_test_util.c        |   2 -
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  40 ++----
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  37 ++----
 .../testing/selftests/kvm/lib/ucall_common.c  | 114 ++++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  37 ++----
 .../testing/selftests/kvm/memslot_perf_test.c |   1 -
 tools/testing/selftests/kvm/rseq_test.c       |   1 -
 tools/testing/selftests/kvm/steal_time.c      |   1 -
 .../kvm/system_counter_offset_test.c          |   1 -
 24 files changed, 213 insertions(+), 192 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
