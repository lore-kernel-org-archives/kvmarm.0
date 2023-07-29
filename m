Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE9C7C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:36:47 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5844e92ee6bso26604687b3.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591006; x=1691195806;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMhJ/b6DMkuq/YdDrUWNaUZgSpR6tSiB89ISkM72Wx4=;
        b=uDNZSukByS7JyZ2jTEcrBQl7mGqhWoKqA2jPxWizvz2EyIAtNwjBDsbWnq8K25aP1c
         aGUNlsQCf/llPt5k93kDpL4/X2KOWZMToFa5soFdm8SQZ80FiVSihf9oTl/ob06d4uLB
         A89y28pB2flFbHcOhZSaDKEr1iY46y9zNb3+YdGFthAy7fQZVnSH2+uJlM3jA3U9b+s0
         1lob8zXM5sLoRCYLPUaqo5Y8s5wf+iEZDOMb/VHGGR5MKtEIbQJv8IwQ6aUQjSQXD4nL
         iyyyuFW0dkdEnlSBWkk1bEMBBgfS5s9+l9tIhsWOiBjr/xL04hP/43Ge/C3IBQpzoNAN
         hyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591006; x=1691195806;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dMhJ/b6DMkuq/YdDrUWNaUZgSpR6tSiB89ISkM72Wx4=;
        b=FVqxjrgoI/jhzXvVVpGzZgm+TDNdf1czo/SW8i6mnP9/+HZCu2ZQtnmhnlyhOlDjuN
         GvOOk41bbwS313gZxIbrHy9XBvnKg2JK6BaYHO/K/4DIHhpnWZqVL1BZpiR1QiJDgxu4
         zxSU/pcXERwg+2va4IIXZNlgAmh7pXLNuVMuc5nZtozIqA9ytqlXgytG4U9mkhlL5Itc
         7uhEuVGs9La+2zByfMn/OYxqmSIEsCZK1zUFZpHF6X3sNVm9dxsp21xzRb4C6veb8FF3
         Gd7sQtSzn7abx/kcLGO34azoMqGfkTZXqPDbvHr/hcUU3Ynwy+FfyfISghxwFKVzY9kb
         YxkA==
X-Gm-Message-State: ABy/qLbSQhIcpA+KQtVmQp/GC+TQBSzeZ80cKgyJhcdgP5hHruP2cj30
	db+njtFg+ZhgRVKrm5fPCZgWT/SFgGs=
X-Google-Smtp-Source: APBJJlF8MZMONjBAnx6gWcIkUk+d8DyxD4xCa+6q0yvO/BGd+aR/kU76AQtPV98ljgxWdHS1cmKtERBcZkE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:19c2:0:b0:d0d:1563:58f2 with SMTP id
 185-20020a2519c2000000b00d0d156358f2mr17145ybz.2.1690591006063; Fri, 28 Jul
 2023 17:36:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:09 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-1-seanjc@google.com>
Subject: [PATCH v4 00/34] KVM: selftests: Guest printf and asserts overhaul
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This is effectively v4 of Aaron's series to add printf capabilities to
the guest[*].  I also pulled in Thomas' patch to rename ASSERT_EQ() to
TEST_ASSERT_EQ(), mainly so that we can decide on a common output format
for both host and guest asserts in a single series, but also so that all
these basically treewide patches are contained in a single series.

Note, Aaron did all of the heavy lifting, I just mopped up.  The core code
is pretty much unchanged from Aaron's v3, v4 massages the assert code a
bit and converts all the tests.

I initially did the conversion in one big patch (the flag is ugly), but
after hitting a nasty bug (see "Add a shameful hack to preserve/clobber
GPRs across ucall") that occurred purely due to the compiler using
registers differently, I decided splitting it up was probably for the best
(even though I still think it probably wasn't worth the effort).

Other maintainers, I want to get this into 6.6, hell or high water.  The
ability to use proper asserts in the guest is super nice, and given how
much selftests code is written via CTRL-C + CTRL-V, the sooner we switch
over the better.

My thought is to apply this whole thing to kvm-x86/selftests early next
week, and then create a tag to make that part of branch immutable.  That
would allow other architectures to pull the code into their trees, e.g.
if an arch is gaining a big selftest or something.

Apologies for not giving advance warning, I was originally thinking we
could leisurely convert to the printf-based asserts, but then realized
that we would probably never get rid of the old crud if we tried that
approach.

Any objections, or better ideas?

Thanks!

Oh, and tested on Intel, AMD, and whatever flavor of ARM we have.  Compile
tested on s390 and RISC-V.

[*] https://lore.kernel.org/all/20230607224520.4164598-1-aaronlewis@google.com

Aaron Lewis (5):
  KVM: selftests: Add strnlen() to the string overrides
  KVM: selftests: Add guest_snprintf() to KVM selftests
  KVM: selftests: Add additional pages to the guest to accommodate ucall
  KVM: selftests: Add string formatting options to ucall
  KVM: selftests: Add a selftest for guest prints and formatted asserts

Sean Christopherson (28):
  KVM: selftests: Make TEST_ASSERT_EQ() output look like normal
    TEST_ASSERT()
  KVM: selftests: Add a shameful hack to preserve/clobber GPRs across
    ucall
  KVM: selftests: Add formatted guest assert support in ucall framework
  KVM: selftests: Convert aarch_timer to printf style GUEST_ASSERT
  KVM: selftests: Convert debug-exceptions to printf style GUEST_ASSERT
  KVM: selftests: Convert ARM's hypercalls test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert ARM's page fault test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert ARM's vGIC IRQ test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert the memslot performance test to printf guest
    asserts
  KVM: selftests: Convert s390's memop test to printf style GUEST_ASSERT
  KVM: selftests: Convert s390's tprot test to printf style GUEST_ASSERT
  KVM: selftests: Convert set_memory_region_test to printf-based
    GUEST_ASSERT
  KVM: selftests: Convert steal_time test to printf style GUEST_ASSERT
  KVM: selftests: Convert x86's CPUID test to printf style GUEST_ASSERT
  KVM: selftests: Convert the Hyper-V extended hypercalls test to printf
    asserts
  KVM: selftests: Convert the Hyper-V feature test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert x86's KVM paravirt test to printf style
    GUEST_ASSERT
  KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest
    asserts
  KVM: selftests: Convert x86's nested exceptions test to printf guest
    asserts
  KVM: selftests: Convert x86's set BSP ID test to printf style guest
    asserts
  KVM: selftests: Convert the nSVM software interrupt test to printf
    guest asserts
  KVM: selftests: Convert x86's TSC MSRs test to use printf guest
    asserts
  KVM: selftests: Convert the x86 userspace I/O test to printf guest
    assert
  KVM: selftests: Convert VMX's PMU capabilities test to printf guest
    asserts
  KVM: selftests: Convert x86's XCR0 test to use printf-based guest
    asserts
  KVM: selftests: Rip out old, param-based guest assert macros
  KVM: selftests: Print out guest RIP on unhandled exception
  KVM: selftests: Use GUEST_FAIL() in ARM's arch timer helpers

Thomas Huth (1):
  KVM: selftests: Rename the ASSERT_EQ macro

 tools/testing/selftests/kvm/Makefile          |   3 +
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |   8 +-
 .../selftests/kvm/aarch64/arch_timer.c        |  22 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   8 +-
 .../selftests/kvm/aarch64/hypercalls.c        |  20 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |  17 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   3 +-
 .../testing/selftests/kvm/guest_print_test.c  | 221 +++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |  12 +-
 .../testing/selftests/kvm/include/test_util.h |  18 +-
 .../selftests/kvm/include/ucall_common.h      |  97 +++---
 .../testing/selftests/kvm/lib/guest_sprintf.c | 307 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   6 +-
 .../selftests/kvm/lib/string_override.c       |   9 +
 .../testing/selftests/kvm/lib/ucall_common.c  |  44 +++
 .../selftests/kvm/lib/x86_64/processor.c      |  18 +-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  32 +-
 .../selftests/kvm/max_guest_memory_test.c     |   2 +-
 .../testing/selftests/kvm/memslot_perf_test.c |   4 +-
 tools/testing/selftests/kvm/s390x/cmma_test.c |  62 ++--
 tools/testing/selftests/kvm/s390x/memop.c     |  13 +-
 tools/testing/selftests/kvm/s390x/tprot.c     |  11 +-
 .../selftests/kvm/set_memory_region_test.c    |  21 +-
 tools/testing/selftests/kvm/steal_time.c      |  20 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  12 +-
 .../x86_64/dirty_log_page_splitting_test.c    |  18 +-
 .../x86_64/exit_on_emulation_failure_test.c   |   2 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c   |   3 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |  29 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   8 +-
 .../selftests/kvm/x86_64/monitor_mwait_test.c |  35 +-
 .../kvm/x86_64/nested_exceptions_test.c       |  16 +-
 .../kvm/x86_64/recalc_apic_map_test.c         |   6 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   6 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c  |  22 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  34 +-
 .../selftests/kvm/x86_64/userspace_io_test.c  |  10 +-
 .../vmx_exception_with_invalid_guest_state.c  |   2 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |  31 +-
 .../selftests/kvm/x86_64/xapic_state_test.c   |   8 +-
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |  29 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |  20 +-
 42 files changed, 938 insertions(+), 331 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c
 create mode 100644 tools/testing/selftests/kvm/lib/guest_sprintf.c


base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.487.g6d72f3e995-goog

