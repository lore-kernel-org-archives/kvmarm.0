Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06ADC43334
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jun 2022 19:31:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 732684B20B;
	Wed, 15 Jun 2022 15:31:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AjDW71ovwcZM; Wed, 15 Jun 2022 15:31:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C78A4B329;
	Wed, 15 Jun 2022 15:31:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99BAA4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 15:31:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tW5oZu1BSvQN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jun 2022 15:31:33 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69CB54B0B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 15:31:33 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 b11-20020a5b008b000000b00624ea481d55so11147625ybp.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 12:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=ujbTuF7wHL3jgoldUstjeqPiNhEKNXNdkEJqhtwaExI=;
 b=X/jBqn6uHacP47ES/1gAqIxB1BLuNrKtdCWxFWndHzdGVJ8CGMxvoBpQtGR1dF8jJY
 9x83uNjezzB0p4JKVInBkOid09xuuh/T148qjwdf2VWuX8N0oZfxCG1qOObg/FVO5vLb
 h+3bWX9kSYf/OzwrbdZrZRNQgxiFWN5Tg1RbEl8/3AZYtXG91S6PSRpcGr7YcSkmrzZn
 Xc5V8ZuuGbcZfjJ59Dz5RBFpZpEtsYAhXqmwRSUnX82lYNN+2h6FqvbLW7P9PHvARocz
 PmOBEzFcj9pKEmqEP7tPXBj/7bnFRozP89ZaI3MP9GBoF0BGx8pDhG7Z3Dp2ZZgvZC9t
 nuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=ujbTuF7wHL3jgoldUstjeqPiNhEKNXNdkEJqhtwaExI=;
 b=VwxG3fO42KoIMlDG2qi6Kean7rLOzWvT8htTv6yoVmu5ah7eKsXlwFalFvs/bnlsJ6
 p/L/fQm34GB04GIxZ/u31Kc9qFlb++uRdVGnbLkhZDi/jpD96AUUBqeWzL2s+3OqvzPu
 Rq3ejvXCgCTjbBCS9o/Wp4blt4D/lV4MkjXO3kzKB9iRPdYGCITsGQqh6m6BH4NWWpmB
 PP3tVTlpk6NU//3OIHAY3ZmtIyegTPSC8rIKO2rvZkoMAd3akowHjzZo/d0YZE0bRlzT
 C5OlGqu6hZf0ngrMxJyz8Cpf+blKPJEtoYtaoWahkYqgM3tis62bxuO2zu/6h8eIgqs4
 gWLQ==
X-Gm-Message-State: AJIora+jjOeGcwCqVadlsNuYLTKmZJ9s1WbVvac2ZM12aXl92JgjPyN3
 vOZa0cxQEGO6mpV+RrgiMdKktobHU8wE34y13w==
X-Google-Smtp-Source: AGRyM1vyz33n7LCFcwa2kyZ9I73ns2dLaRfSiuOSvnRIOFvFpz87+8u9krZeJDJZaq+RGvfjSs+40qv8+W9wl30sgg==
X-Received: from coltonlewis-kvm.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1023:b0:665:12c1:b44d with
 SMTP id x3-20020a056902102300b0066512c1b44dmr1606396ybt.472.1655321492933;
 Wed, 15 Jun 2022 12:31:32 -0700 (PDT)
Date: Wed, 15 Jun 2022 19:31:12 +0000
Message-Id: <20220615193116.806312-1-coltonlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 0/4] Fix filename reporting in guest asserts
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
Cc: thuth@redhat.com, Colton Lewis <coltonlewis@google.com>, maz@kernel.org,
 vkuznets@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

Fix filename reporting in guest asserts by way of abstracting out
magic numbers and introducing new reporting macros to report
consistently with less duplication.

Colton Lewis (4):
  KVM: selftests: enumerate GUEST_ASSERT arguments
  KVM: selftests: Increase UCALL_MAX_ARGS to 7
  KVM: selftests: Write REPORT_GUEST_ASSERT macros to pair with
    GUEST_ASSERT
  KVM: selftests: Fix filename reporting in guest asserts

 .../selftests/kvm/aarch64/arch_timer.c        | 12 ++--
 .../selftests/kvm/aarch64/debug-exceptions.c  |  4 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  4 +-
 .../selftests/kvm/include/ucall_common.h      | 66 +++++++++++++++++--
 .../testing/selftests/kvm/memslot_perf_test.c |  4 +-
 tools/testing/selftests/kvm/steal_time.c      |  3 +-
 .../kvm/system_counter_offset_test.c          |  3 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c |  3 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  3 +-
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |  2 +-
 .../kvm/x86_64/emulator_error_test.c          |  3 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  3 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |  3 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |  6 +-
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  3 +-
 .../selftests/kvm/x86_64/kvm_clock_test.c     |  3 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  3 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  4 +-
 .../testing/selftests/kvm/x86_64/state_test.c |  3 +-
 .../selftests/kvm/x86_64/svm_int_ctl_test.c   |  2 +-
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |  2 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  4 +-
 .../selftests/kvm/x86_64/userspace_io_test.c  |  4 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |  5 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |  3 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c  |  2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  3 +-
 .../x86_64/vmx_invalid_nested_guest_state.c   |  2 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |  2 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c    |  3 +-
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |  2 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  2 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |  2 +-
 33 files changed, 100 insertions(+), 73 deletions(-)

-- 
2.36.1.476.g0c4daa206d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
