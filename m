Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A071561FFE
	for <kvmarm@lists.linux.dev>; Sat, 22 Feb 2025 00:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740185990; cv=none; b=qaGyNDNC7yia00zwEugj7hNg9ukmYqBRfvKPhmHhofMHsR0BPIyZCz/2Q47wkVaMA4x2XdvueU8+rUWczG1tNH8cj1F1ZHFwWpRqGMyGe+c0iLDDHEQ2SRwnOwOJGdbezVDfwI4APtJM9SEFonS3WG4dEaix8coSfy7gxLlJmO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740185990; c=relaxed/simple;
	bh=RD/60KEUKHeeAmpP+6lmvBKPq2HiHPkrfTCvHrYEQs0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kX1uFGUnR8GSmhGiE76KV4ia7CT84tIGaEbVkP+D6uzbuUTdFbkId5AaZtesk08ksTXKj3FwwoL4rbuP5oFAT31/h4781GA4LL1fsghyyKfv7cbj/U5UDHVwx1YnpTENAZ6g7OIYaWxqnmNASTjaQGm9HVeqxC9nIZ6S21Zu8A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cv0Cxdhx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cv0Cxdhx"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc4fc93262so5887629a91.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 16:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740185988; x=1740790788; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kBRd9F+mx4wFt4H+VE0Ydy83ogmyyqX60XghvKixac0=;
        b=Cv0CxdhxbrDZGHY0Rz/z/bSKe+wUkSsBTJ0o8X9lqHaiom5oiH4hVsoF0ygQKJELMK
         /ZRcAiszOZi9KpF37/VM2cBNQf71YTgt0CRz8HG6kwhQAekH3Rzv+WBzAIAj6ZcJfX60
         WHuRnLAbZS8x3z4KVBXzj7Mn3V5h08ngoCuh9Fd9uKOhQm3j7PdN9wfby+ljk8KaQM5D
         RelFMC4YSElWeNLwIUx/ZbuLpgEDE6K910PIeLWyYs9c026DpiQIe02KiFn8AWVXR4bw
         u3id/Ib6akvCShQ+3ch6y8nZa0OOETZik4EgTz9a+RBmQxpWULpVmQlKMFkauk+JPgOc
         vnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740185988; x=1740790788;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kBRd9F+mx4wFt4H+VE0Ydy83ogmyyqX60XghvKixac0=;
        b=CYtu2/CJi1MoruW9yOTsB2ZoGRPeu2J0wadvDFYGuJm5h2HCTj1NsIIX9lzIP/0Xnz
         2q6SvuDMTf0EWHZTazSFCHBYgSOjIZeQQCVJnm0OuhuxI3lVOc71boF8IB4XM6XgSTuY
         3t5DYEESeTNbjPcWKCXmQmqekAxb5nXcYEM/4lJtxPCsQ18/vTqudQeAqv5qoRBGpY3X
         s2iTA+hPw1is85INNoXEhHn4SQp6St2g8L7RUb6jUxPO3AVXPdbIq57IPNxjHIkML9qy
         v/z6CUFSbRVxsH+wlRmBrtBuqOl4xcTy0YVsTVWA/X7qXLGexevnTl1ZPh2mHIQK9ORf
         Sngw==
X-Forwarded-Encrypted: i=1; AJvYcCVPlEAjFZRWRx7Djz/YRoEkt3+FK20s+BYlVqW6HzTW1ftjWdQHmFW8iq7GUj8xbEjO8c5/5kI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzC0pEzy/8jo+oRhY01AUZe0uULYHkjVSCWVAspwrKuDaec5QSA
	Givoj7LKUGih8s4e+ozJjk42PlhKlqp9D5ITgIpTH0VDG51k43doLsDGoZk1dcQsawyfcyABRFE
	t26jfFw==
X-Google-Smtp-Source: AGHT+IHFh+l8vBTEFEs3Y7eqKUizEgDHBm2dD/Rr3VO9twBVXR3MXf6pLXzxMgscxinv8InO1m/NzVZUfvdz
X-Received: from pjbdb16.prod.google.com ([2002:a17:90a:d650:b0:2fa:1b0c:4150])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b83:b0:2f8:b2c:5ef3
 with SMTP id 98e67ed59e1d1-2fce789cedamr10422060a91.14.1740185987890; Fri, 21
 Feb 2025 16:59:47 -0800 (PST)
Date: Fri, 21 Feb 2025 16:59:28 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250222005943.3348627-1-vipinsh@google.com>
Subject: [PATCH 0/2] Add KVM selftest runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

This series in continuation of the selftest runner discussion we had
some months ago.
https://lore.kernel.org/kvm/20240821223012.3757828-1-vipinsh@google.com/

Based on the discussion, this is phase 1 implementation of KVM selftest
runner. Patch 1 is providing the testcase files and patch 2 is runner
implementation which uses testcase files.

This version has following features:
- Parallel test execution.
- Dumping separate output for each test.
- Timeout for test execution
- Specify single test or a test directory.

Vipin Sharma (2):
  KVM: selftests: Add default testfiles for KVM selftests runner
  KVM: selftests: Create KVM selftest runner

 tools/testing/selftests/kvm/.gitignore        |  4 +-
 .../testing/selftests/kvm/runner/__main__.py  | 96 +++++++++++++++++++
 tools/testing/selftests/kvm/runner/command.py | 42 ++++++++
 .../testing/selftests/kvm/runner/selftest.py  | 49 ++++++++++
 .../selftests/kvm/runner/test_runner.py       | 40 ++++++++
 .../aarch64/aarch32_id_regs/default.test      |  1 +
 .../testcases/aarch64/arch_timer/default.test |  1 +
 .../arch_timer_edge_cases/default.test        |  1 +
 .../aarch64/debug-exceptions/default.test     |  1 +
 .../aarch64/get-reg-list/default.test         |  1 +
 .../testcases/aarch64/hypercalls/default.test |  1 +
 .../testcases/aarch64/no-vgic-v3/default.test |  1 +
 .../aarch64/page_fault_test/default.test      |  1 +
 .../testcases/aarch64/psci_test/default.test  |  1 +
 .../aarch64/set_id_regs/default.test          |  1 +
 .../aarch64/smccc_filter/default.test         |  1 +
 .../aarch64/vcpu_width_config/default.test    |  1 +
 .../testcases/aarch64/vgic_init/default.test  |  1 +
 .../testcases/aarch64/vgic_irq/default.test   |  1 +
 .../aarch64/vgic_lpi_stress/default.test      |  1 +
 .../aarch64/vpmu_counter_access/default.test  |  1 +
 .../access_tracking_perf_test/default.test    |  1 +
 .../testcases/coalesced_io_test/default.test  |  1 +
 .../testcases/demand_paging_test/default.test |  1 +
 .../dirty_log_perf_test/default.test          |  1 +
 .../kvm/testcases/dirty_log_test/default.test |  1 +
 .../testcases/guest_memfd_test/default.test   |  1 +
 .../testcases/guest_print_test/default.test   |  1 +
 .../hardware_disable_test/default.test        |  1 +
 .../kvm_binary_stats_test/default.test        |  1 +
 .../kvm_create_max_vcpus/default.test         |  1 +
 .../kvm_page_table_test/default.test          |  1 +
 .../max_guest_memory_test/default.test        |  1 +
 .../default.test                              |  1 +
 .../testcases/memslot_perf_test/default.test  |  1 +
 .../pre_fault_memory_test/default.test        |  1 +
 .../testcases/riscv/arch_timer/default.test   |  1 +
 .../testcases/riscv/ebreak_test/default.test  |  1 +
 .../testcases/riscv/get-reg-list/default.test |  1 +
 .../testcases/riscv/sbi_pmu_test/default.test |  1 +
 .../kvm/testcases/rseq_test/default.test      |  1 +
 .../testcases/s390x/cmma_test/default.test    |  1 +
 .../testcases/s390x/debug_test/default.test   |  1 +
 .../kvm/testcases/s390x/memop/default.test    |  1 +
 .../kvm/testcases/s390x/resets/default.test   |  1 +
 .../s390x/shared_zeropage_test/default.test   |  1 +
 .../s390x/sync_regs_test/default.test         |  1 +
 .../kvm/testcases/s390x/tprot/default.test    |  1 +
 .../s390x/ucontrol_test/default.test          |  1 +
 .../set_memory_region_test/default.test       |  1 +
 .../kvm/testcases/steal_time/default.test     |  1 +
 .../system_counter_offset_test/default.test   |  1 +
 .../testcases/x86_64/amx_test/default.test    |  1 +
 .../x86_64/apic_bus_clock_test/default.test   |  1 +
 .../testcases/x86_64/cpuid_test/default.test  |  1 +
 .../x86_64/cr4_cpuid_sync_test/default.test   |  1 +
 .../testcases/x86_64/debug_regs/default.test  |  1 +
 .../default.test                              |  1 +
 .../default.test                              |  1 +
 .../x86_64/feature_msrs_test/default.test     |  1 +
 .../x86_64/fix_hypercall_test/default.test    |  1 +
 .../x86_64/hwcr_msr_test/default.test         |  1 +
 .../x86_64/hyperv_clock/default.test          |  1 +
 .../x86_64/hyperv_cpuid/default.test          |  1 +
 .../x86_64/hyperv_evmcs/default.test          |  1 +
 .../hyperv_extended_hypercalls/default.test   |  1 +
 .../x86_64/hyperv_features/default.test       |  1 +
 .../testcases/x86_64/hyperv_ipi/default.test  |  1 +
 .../x86_64/hyperv_svm_test/default.test       |  1 +
 .../x86_64/hyperv_tlb_flush/default.test      |  1 +
 .../x86_64/kvm_clock_test/default.test        |  1 +
 .../testcases/x86_64/kvm_pv_test/default.test |  1 +
 .../x86_64/max_vcpuid_cap_test/default.test   |  1 +
 .../x86_64/monitor_mwait_test/default.test    |  1 +
 .../nested_exceptions_test/default.test       |  1 +
 .../x86_64/nx_huge_pages_test/default.test    |  1 +
 .../x86_64/platform_info_test/default.test    |  1 +
 .../x86_64/pmu_counters_test/default.test     |  1 +
 .../x86_64/pmu_event_filter_test/default.test |  1 +
 .../private_mem_conversions_test/default.test |  1 +
 .../private_mem_kvm_exits_test/default.test   |  1 +
 .../x86_64/recalc_apic_map_test/default.test  |  1 +
 .../x86_64/set_boot_cpu_id/default.test       |  1 +
 .../x86_64/set_sregs_test/default.test        |  1 +
 .../x86_64/sev_init2_tests/default.test       |  1 +
 .../x86_64/sev_migrate_tests/default.test     |  1 +
 .../x86_64/sev_smoke_test/default.test        |  1 +
 .../default.test                              |  1 +
 .../testcases/x86_64/smm_test/default.test    |  1 +
 .../testcases/x86_64/state_test/default.test  |  1 +
 .../x86_64/svm_int_ctl_test/default.test      |  1 +
 .../svm_nested_shutdown_test/default.test     |  1 +
 .../svm_nested_soft_inject_test/default.test  |  1 +
 .../x86_64/svm_vmcall_test/default.test       |  1 +
 .../x86_64/sync_regs_test/default.test        |  1 +
 .../triple_fault_event_test/default.test      |  1 +
 .../x86_64/tsc_msrs_test/default.test         |  1 +
 .../x86_64/tsc_scaling_sync/default.test      |  1 +
 .../x86_64/ucna_injection_test/default.test   |  1 +
 .../x86_64/userspace_io_test/default.test     |  1 +
 .../userspace_msr_exit_test/default.test      |  1 +
 .../x86_64/vmx_apic_access_test/default.test  |  1 +
 .../vmx_close_while_nested_test/default.test  |  1 +
 .../x86_64/vmx_dirty_log_test/default.test    |  1 +
 .../default.test                              |  1 +
 .../default.test                              |  1 +
 .../x86_64/vmx_msrs_test/default.test         |  1 +
 .../vmx_nested_tsc_scaling_test/default.test  |  1 +
 .../x86_64/vmx_pmu_caps_test/default.test     |  1 +
 .../vmx_preemption_timer_test/default.test    |  1 +
 .../vmx_set_nested_state_test/default.test    |  1 +
 .../x86_64/vmx_tsc_adjust_test/default.test   |  1 +
 .../x86_64/xapic_ipi_test/default.test        |  1 +
 .../x86_64/xapic_state_test/default.test      |  1 +
 .../x86_64/xcr0_cpuid_test/default.test       |  1 +
 .../x86_64/xen_shinfo_test/default.test       |  1 +
 .../x86_64/xen_vmcall_test/default.test       |  1 +
 .../x86_64/xss_msr_test/default.test          |  1 +
 118 files changed, 343 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/runner/__main__.py
 create mode 100644 tools/testing/selftests/kvm/runner/command.py
 create mode 100644 tools/testing/selftests/kvm/runner/selftest.py
 create mode 100644 tools/testing/selftests/kvm/runner/test_runner.py
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/arch_timer/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/arch_timer_edge_cases/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/debug-exceptions/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/get-reg-list/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/hypercalls/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/no-vgic-v3/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/page_fault_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/psci_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/set_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/smccc_filter/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vcpu_width_config/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vgic_init/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vgic_irq/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vgic_lpi_stress/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/aarch64/vpmu_counter_access/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/access_tracking_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/coalesced_io_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/demand_paging_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/dirty_log_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/dirty_log_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/guest_memfd_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/guest_print_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/hardware_disable_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/kvm_binary_stats_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/kvm_create_max_vcpus/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/kvm_page_table_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/max_guest_memory_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/memslot_modification_stress_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/memslot_perf_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/pre_fault_memory_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/riscv/arch_timer/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/riscv/ebreak_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/riscv/get-reg-list/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/riscv/sbi_pmu_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/rseq_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/cmma_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/debug_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/memop/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/resets/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/shared_zeropage_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/sync_regs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/tprot/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/s390x/ucontrol_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/set_memory_region_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/steal_time/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/system_counter_offset_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/amx_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/apic_bus_clock_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/cpuid_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/cr4_cpuid_sync_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/debug_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/dirty_log_page_splitting_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/exit_on_emulation_failure_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/feature_msrs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/fix_hypercall_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hwcr_msr_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_clock/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_cpuid/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_evmcs/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_extended_hypercalls/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_features/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_ipi/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_svm_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/hyperv_tlb_flush/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/kvm_clock_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/kvm_pv_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/max_vcpuid_cap_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/monitor_mwait_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/nested_exceptions_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/nx_huge_pages_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/platform_info_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/pmu_counters_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/pmu_event_filter_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/private_mem_conversions_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/private_mem_kvm_exits_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/recalc_apic_map_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/set_boot_cpu_id/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/set_sregs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/sev_init2_tests/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/sev_migrate_tests/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/sev_smoke_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/smaller_maxphyaddr_emulation_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/smm_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/state_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/svm_int_ctl_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/svm_nested_shutdown_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/svm_nested_soft_inject_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/svm_vmcall_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/sync_regs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/triple_fault_event_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/tsc_msrs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/tsc_scaling_sync/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/ucna_injection_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/userspace_io_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/userspace_msr_exit_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_apic_access_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_close_while_nested_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_dirty_log_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_exception_with_invalid_guest_state/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_invalid_nested_guest_state/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_msrs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_nested_tsc_scaling_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_pmu_caps_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_preemption_timer_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_set_nested_state_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/vmx_tsc_adjust_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xapic_ipi_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xapic_state_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xcr0_cpuid_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xen_shinfo_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xen_vmcall_test/default.test
 create mode 100644 tools/testing/selftests/kvm/testcases/x86_64/xss_msr_test/default.test


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.601.g30ceb7b040-goog

