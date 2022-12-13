Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4CBC4167B
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15B0B4B948;
	Mon, 12 Dec 2022 19:17:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TsTWrDxNaDPL; Mon, 12 Dec 2022 19:17:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E63A54B960;
	Mon, 12 Dec 2022 19:17:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFF764B946
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TLAoGl5oe9vh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:04 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69C814B92A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:04 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 j21-20020a63fc15000000b00476d6932baeso8625558pgi.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=iaggZY6D6UfFXqqTQeav5mkn69NNdHNCOFauIZUnoGM=;
 b=czhUe/RM1vX8uC3ixSupn81mlVxf2Ti23rxzwMQmgEMrXpHHtjLMqdVrkGTwwBD6/u
 jCkHjupPCQ8QI7uPi9QYeehzrvpk0pgW7ENARmJG0E+H98nz8hzcUkkFDNOrltUuRpl6
 PWQ07kMRSvcWyxmMGEAhMKe/Y3AbuOWf7REE0o7BoR2ePGqsOfLHv6t6CtSWzEw6V2UQ
 8ffChaMMLsSyYSqf++EMVfTePDxU8dVE5I5DIWaQn17NmTORPN8BZJjaDqATMLSn8nXo
 kOHsSwoOvSwnPxgC0U6NWgsNSglGMhUsvGKWl8UsOEFi1mrJQaWoypOzvt4LqNHWJV8d
 5+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=iaggZY6D6UfFXqqTQeav5mkn69NNdHNCOFauIZUnoGM=;
 b=oQ4nUUjBt8O0ZjmenNBqOZ2dje/B7jzEMR+UNdbunj1oaT2tvkF8xQ4DHJ6dHj8rLo
 SI0+NlBkrCSRTvVtneHhoDl0xJMjH6YAZyMi7UbU/qEVG2Cq13iaVDmU5JCoJikgT5p8
 GDMtNQ8DFEnqndWoxe2tcPdT6mjJK65+PeL0m+ck8npShJB2t04SErIqpFkpKOf0XWVn
 Z0NsmDGfCBgiw2YgZn/+ZMnf0TgWrMDVrfgVlCVKz3JQfmSHlBsqgOYxruYYXq/bG/QY
 cfPClG6+n3ET6H7RfBJRbFtBoH0IiPNAi2ByuVIs+eOLVKKA2hX4E76rF6jSZ8NJZQXi
 bQGA==
X-Gm-Message-State: ANoB5plTCLl9Maln9Wtupnyw4hHCrc+kiWZ3fBBluKFjB0f1PxwDK3ZL
 7y1ij6l659nKSJk0F01wedJdnb3xLT0=
X-Google-Smtp-Source: AA0mqf423P0K3F775j7XRU0bNQseuIHeq8Bl9zlGMEI+Slu8o9KGU81MdqivvnEry1U+9Xe7aVS/pd3oOHM=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec92:b0:189:cdc8:725c with SMTP id
 x18-20020a170902ec9200b00189cdc8725cmr23371937plg.162.1670890623569; Mon, 12
 Dec 2022 16:17:03 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:43 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-5-seanjc@google.com>
Subject: [PATCH 04/14] KVM: selftests: Use pattern matching in .gitignore
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

Use pattern matching to exclude everything except .c, .h, .S, and .sh
files from Git.  Manually adding every test target has an absurd
maintenance cost, is comically error prone, and leads to bikeshedding
over whether or not the targets should be listed in alphabetical order.

Deliberately do not include the one-off assets, e.g. config, settings,
.gitignore itself, etc as Git doesn't ignore files that are already in
the repository.  Adding the one-off assets won't prevent mistakes where
developers forget to --force add files that don't match the "allowed".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore | 91 ++------------------------
 1 file changed, 6 insertions(+), 85 deletions(-)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 6ce8c488d62e..6d9381d60172 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,86 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
-/aarch64/aarch32_id_regs
-/aarch64/arch_timer
-/aarch64/debug-exceptions
-/aarch64/get-reg-list
-/aarch64/hypercalls
-/aarch64/page_fault_test
-/aarch64/psci_test
-/aarch64/vcpu_width_config
-/aarch64/vgic_init
-/aarch64/vgic_irq
-/s390x/memop
-/s390x/resets
-/s390x/sync_regs_test
-/s390x/tprot
-/x86_64/amx_test
-/x86_64/cpuid_test
-/x86_64/cr4_cpuid_sync_test
-/x86_64/debug_regs
-/x86_64/exit_on_emulation_failure_test
-/x86_64/fix_hypercall_test
-/x86_64/get_msr_index_features
-/x86_64/kvm_clock_test
-/x86_64/kvm_pv_test
-/x86_64/hyperv_clock
-/x86_64/hyperv_cpuid
-/x86_64/hyperv_evmcs
-/x86_64/hyperv_features
-/x86_64/hyperv_ipi
-/x86_64/hyperv_svm_test
-/x86_64/hyperv_tlb_flush
-/x86_64/max_vcpuid_cap_test
-/x86_64/mmio_warning_test
-/x86_64/monitor_mwait_test
-/x86_64/nested_exceptions_test
-/x86_64/nx_huge_pages_test
-/x86_64/platform_info_test
-/x86_64/pmu_event_filter_test
-/x86_64/set_boot_cpu_id
-/x86_64/set_sregs_test
-/x86_64/sev_migrate_tests
-/x86_64/smaller_maxphyaddr_emulation_test
-/x86_64/smm_test
-/x86_64/state_test
-/x86_64/svm_vmcall_test
-/x86_64/svm_int_ctl_test
-/x86_64/svm_nested_soft_inject_test
-/x86_64/svm_nested_shutdown_test
-/x86_64/sync_regs_test
-/x86_64/tsc_msrs_test
-/x86_64/tsc_scaling_sync
-/x86_64/ucna_injection_test
-/x86_64/userspace_io_test
-/x86_64/userspace_msr_exit_test
-/x86_64/vmx_apic_access_test
-/x86_64/vmx_close_while_nested_test
-/x86_64/vmx_dirty_log_test
-/x86_64/vmx_exception_with_invalid_guest_state
-/x86_64/vmx_invalid_nested_guest_state
-/x86_64/vmx_msrs_test
-/x86_64/vmx_preemption_timer_test
-/x86_64/vmx_set_nested_state_test
-/x86_64/vmx_tsc_adjust_test
-/x86_64/vmx_nested_tsc_scaling_test
-/x86_64/xapic_ipi_test
-/x86_64/xapic_state_test
-/x86_64/xen_shinfo_test
-/x86_64/xen_vmcall_test
-/x86_64/xss_msr_test
-/x86_64/vmx_pmu_caps_test
-/x86_64/triple_fault_event_test
-/access_tracking_perf_test
-/demand_paging_test
-/dirty_log_test
-/dirty_log_perf_test
-/hardware_disable_test
-/kvm_create_max_vcpus
-/kvm_page_table_test
-/max_guest_memory_test
-/memslot_modification_stress_test
-/memslot_perf_test
-/rseq_test
-/set_memory_region_test
-/steal_time
-/kvm_binary_stats_test
-/system_counter_offset_test
+*
+!/**/
+!*.c
+!*.h
+!*.S
+!*.sh
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
