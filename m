Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97239C00145
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E74544B943;
	Mon, 12 Dec 2022 19:17:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7uXzzHDzaKhK; Mon, 12 Dec 2022 19:16:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50B514B92F;
	Mon, 12 Dec 2022 19:16:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C0D4B92A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:16:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lG7zDPt2PS6M for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:16:57 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D14A4B920
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:16:57 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-410f1a84ed2so82172777b3.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
 :subject:date:message-id:reply-to;
 bh=rrmKIRMf4Mq2msGAMjuH9G/DlO6PhwIb4et9Vyytf0s=;
 b=Y/SoLe17F+HoJZwya7YFOMVPVWxIyS8YXDXAdkZKURoZhYboc1qqDhxRYkM8qd/fyn
 zV4AKnvonZDIf4kBxS6BbqKkYvK++Z8SlakM9rrpZf/WnJthiD/WaPvC4mId1Hi85VXx
 HEnTLJKfq/AiMkE+A1lvFD7n5RUyEVn7KE12qMAkazwYdkxp/onbTYKAwGSZxx/+wvCu
 AkCHnFjwsiycANQDr7f8nJl13jr3Aq6KbcvSvBjixq+cK42hwQ3dC8wgvpt4LO7Wo9ul
 DCX6EzwtU8238LHHvhH1M16EyNBESvafX2Bsjx0/y3efzS0Lla4Z0vEPMEkwmHimVswS
 SmYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:reply-to
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=rrmKIRMf4Mq2msGAMjuH9G/DlO6PhwIb4et9Vyytf0s=;
 b=vu9vhlYkos0FMtSdR6yezKs0ehCOwuwy6bjqY1f6dfPfBjBcMTH7WnH8nnvP7Sk2IX
 2t3RTkCXmWUmy4n/8Qett0FRXow48cc5OqBhNhd0Dip3d5zekRIeG2mGA0BK3CHlcIN4
 /TZaeD38jj28kb6Nb4mAn3LThjIAqYPgrnIm/RDBNGm3CXgE4zc9Ek1/+tYz/eJHKwWE
 LykDgOh/1Qsnq3P7I8W0JkmGVGBq+I51DG77H28nNd73V2rvxuU+MTD9FX8910XPhb6j
 V2aRpyBFd+TS1mFMu9kAiTF1Uds4RWr9dCpHD2CBjnGR6Qao9CCy5309t0IbRCz5bG85
 6Asg==
X-Gm-Message-State: ANoB5pktiraLWWfIZ4s1FrzFWvgLdJ16IJrtldObzqYXrV7n2oyOd81e
 GwttshWVNhYAN1WJBAF4FWdmzliO22I=
X-Google-Smtp-Source: AA0mqf6/pKu0pWWW1KBsbsV+bRwkpXaD3AJngXQVdm+DqVUnownROWyJFsvs/+l4EXLP/kxHJtplxf44+Wk=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2397:0:b0:724:2a55:aadb with SMTP id
 j145-20020a252397000000b007242a55aadbmr1005565ybj.576.1670890616579; Mon, 12
 Dec 2022 16:16:56 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:39 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-1-seanjc@google.com>
Subject: [PATCH 00/14] KVM: selftests: Clang fixes, Makefile cleanup
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
 Tom Rix <trix@redhat.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
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

Fix a variety of KVM selftests issues exposed by clang, and rework the
Makefile and .gitignore to reduce the maintenance burden of selftests.

For the Makefile, programmatically generate the list of targets by
looking for .c files, and opt-out via a dummy macro in the source
instead of forcing architectures to opt-in.  The opt-out approach is
less error prone (harder to forget to add an arch), doesn't generate
unnecessary conflicts if multiple tests are added simultanesouly, and
makes it much easier to understand which tests aren't supported, e.g.

  $ git grep TEST_UNSUPPORTED | grep aarch64
  hardware_disable_test.c:TEST_UNSUPPORTED(aarch64);
  max_guest_memory_test.c:TEST_UNSUPPORTED(aarch64);
  system_counter_offset_test.c:TEST_UNSUPPORTED(aarch64);

This all started when trying to reproduce clang build errors reported by
Raghu and Aaron that were introduced by commit 6b6f71484bf4 ("KVM:
selftests: Implement memcmp(), memcpy(), and memset() for guest use").
Just getting selftests to compile with clang was a nightmare, as it took
me several hours to realize that "CC=clang make" and "make CC=clang"
aren't equivalent, and that the "include ../lib.mak" buried halfway through
the Makefile was overriding "CC=clang make".

After too many hours fighting to get clang working, my frustration with
the Makefile boiled over a bit...

Note, I have fixes for the RISC-V RSEQ bugs (outside of selftests/kvm) that
I'll post separately.

Tested on x86 and arm, build tested on s390x and RISC-V, all with both gcc
and clang.

Sean Christopherson (14):
  KVM: selftests: Define literal to asm constraint in aarch64 as
    unsigned long
  KVM: selftests: Delete dead code in x86_64/vmx_tsc_adjust_test.c
  KVM: selftests: Fix divide-by-zero bug in memslot_perf_test
  KVM: selftests: Use pattern matching in .gitignore
  KVM: selftests: Fix a typo in x86-64's kvm_get_cpu_address_width()
  KVM: selftests: Rename UNAME_M to ARCH_DIR, fill explicitly for x86
  KVM: selftests: Use proper function prototypes in probing code
  KVM: selftests: Probe -no-pie with actual CFLAGS used to compile
  KVM: selftests: Explicitly disable builtins for mem*() overrides
  KVM: selftests: Include lib.mk before consuming $(CC)
  KVM: selftests: Disable "gnu-variable-sized-type-not-at-end" warning
  KVM: selftests: Use wildcards to find library source files
  KVM: selftests: Use wildcards to find targets and test source files
  KVM: selftests: Enable RSEQ test for RISC-V

 tools/testing/selftests/kvm/.gitignore        |  91 +------
 tools/testing/selftests/kvm/Makefile          | 229 +++---------------
 .../selftests/kvm/aarch64/page_fault_test.c   |   2 +-
 .../selftests/kvm/access_tracking_perf_test.c |   3 +
 .../selftests/kvm/dirty_log_perf_test.c       |   3 +
 .../selftests/kvm/hardware_disable_test.c     |   4 +
 .../testing/selftests/kvm/include/test_util.h |  11 +
 .../selftests/kvm/lib/x86_64/processor.c      |   2 +-
 .../selftests/kvm/max_guest_memory_test.c     |   4 +
 .../kvm/memslot_modification_stress_test.c    |   3 +
 .../testing/selftests/kvm/memslot_perf_test.c |   6 +
 tools/testing/selftests/kvm/steal_time.c      |   3 +
 .../kvm/system_counter_offset_test.c          |   4 +
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |   5 -
 14 files changed, 80 insertions(+), 290 deletions(-)


base-commit: f1a1d3aff0cc2e68a9ebbd8810d7dcd8cfe2714b
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
