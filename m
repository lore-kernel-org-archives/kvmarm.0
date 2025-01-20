Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C2B1B6D0A
	for <kvmarm@lists.linux.dev>; Mon, 20 Jan 2025 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737386123; cv=none; b=AIzAJMQJkn5jvWBVCSmPzKvELwlpuwa7aNFsqoCQso4YCWPwP+dqJm2EjLSohHNL6OPJPttWILVijdYrO4IokpY3b8nxyXoltArjO3hUTNscF/+xWHCh8msF+QVVbwsIBq6MDRiH3qwXZS8mDo8KRWLJuU/yT4GUrLdNPE1mDFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737386123; c=relaxed/simple;
	bh=BqC0qCVrWXgZU8Sm8kqI7/RRsqLAwQ0bXKWKROaQIwU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QOeXsKfqBJIMUHChA1UAMFKTIvs7lXvz/73a4FR0F9ftDBgY2xHrUGFw6Q3diYgZjnDYK9orqrqfpIY0tXl6ZVbLTqYVClfJm9btWToUjboLWtGlAO9sGEwul1xI2u/9bNt4X2NvMDKt02w1fWoKk/2YorsAFFkwziSliuJSBgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--lokeshvutla.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nM3O0YtN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lokeshvutla.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nM3O0YtN"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216750b679eso62852275ad.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Jan 2025 07:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737386121; x=1737990921; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4TuVoRxbmBAi8V9yz3BH7EQYWTzmh03R9kdlOoAvRf4=;
        b=nM3O0YtNRklyCQD5jGFExidHbG1ZWJuEQh5qjaivn2FZV5ldRpHYyQcbaIEFvQfSCf
         H8am9sQ90UEN7GXM6kkZ+sQPgMN2wCMrTKxRVSyg6pX7wUz4yFxWs2JtFFhi1vc5hRp3
         wrPSm36wHKDGg3Y3ewIeyESM8+6/iQp/w6xQTsnxi4w94t6TcCpZYlbTdj4CS4SOt7Hs
         oMR5nyLZjWD1xgK435CMZKK18/pxiCCXCdTq13qbXD/LMwqUhVwiq/lTGtmRzuHsMt7D
         xuCl6HQyiltp7reF2SWIjnUIbzAf/rthYIlBgsRGc0UpYce9a6HqwOoppwAnCPKQIOn2
         qw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737386121; x=1737990921;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4TuVoRxbmBAi8V9yz3BH7EQYWTzmh03R9kdlOoAvRf4=;
        b=HbV8bFBKOpxzEZThjJ9WE+dkIRTJS5ZONfSES+sbyZoSTAeuWgFcD/mbB17RqN3FSX
         mpg4QQ1q5Af19nZgcJ56ScVc5EP3W4jSZB1+B3hHrRGeYLW6VAnsj8ZwVfa+XiC93z37
         z2ulkiU+abp1WPhGJfYK59erHvKejYlH+6avakesZ09LIBQnBjU9EW5oXDw48MBDpG95
         YudpTdN/B+I3HZfEm+ziRoN/CE7z3MCmO5DE6AfKCeX+TB3oqPhMyMczIf2g12noNaLs
         L8OSXbH0BXGiXcT5L1hBDwhNyV6/tbgZkPl8h+r8no2rFRxQV6JOFjyFvJIaRu9xLSSx
         f+Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUUJOj/zPOEBVsC93oknoc3D8w0ccAqYNy19ce/nM9HUpy7TLYzDW27spVQG4fQ1lsnOPGwFHo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2hB+XPkkuGJVA6XtmHaTazRVoOvyR4V40kon3aONHtdncgq05
	iwSUQDGuXfyV34QB8Q8k0Dk9RLtMjcrHSF4QkpRIDBZ8oElXe7R9gpCMtj5fsCgkCe5napOMsvD
	At8HECgBU/zkfPlRIlEc1lA==
X-Google-Smtp-Source: AGHT+IEB6IUiwIoCs5Sc+DChuXGkEKi5mHklCEPpk0MnpLMCkgKj3oeKL3Yaotz5jBykfGlrNQfXbcL42khmPtQ73A==
X-Received: from pgbcm6.prod.google.com ([2002:a05:6a02:a06:b0:801:d783:5f1e])
 (user=lokeshvutla job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d510:b0:212:5786:7bbe with SMTP id d9443c01a7336-21c3550e908mr223507475ad.24.1737386121377;
 Mon, 20 Jan 2025 07:15:21 -0800 (PST)
Date: Mon, 20 Jan 2025 15:15:14 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250120151514.1769597-1-lokeshvutla@google.com>
Subject: [PATCH] KVM: arm64: Flush hyp bss section after initialization of
 variables in bss
From: Lokesh Vutla <lokeshvutla@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	lokeshvutla@google.com, sachinparekh@google.com
Content-Type: text/plain; charset="UTF-8"

To determine CPU features during initialization, the NVHE hypervisor
utilizes sanitized values of the host's CPU features registers. These
values, stored in u64 idaa64*_el1_sys_val variables are updated by the
kvm_hyp_init_symbols() function at EL1. To ensure EL2 visibility, the
data cache needs to be flushed after these updates. However,
individually flushing each variable using kvm_flush_dcache_to_poc() is
inefficient.

These cpu feature variables would be part of the bss section of
the hypervisor. Hence, flush the entire bss section of hypervisor
once the initialization is complete.

Motivation for this change:
* Since the existing variables are not flushed from EL1, the
  id_aa64pfr0_el1_sys_val is seen as 0 from EL2.
* based on this value check_override macro in hypervisor skips
  updating the sve (cpacr_el1) at finalise_el2_state.
* The default value for cpacr_el1 enables the sve traps to EL2.
* With sve enabled, during the context switch from EL0 -> EL1 (which is
  much later in the boot process), the sve registers are saved/restored.
* Since sve traps are enabled, accessing sve registers at EL1 caused a
  trap to EL2.
* However, hypervisor is not ready to handle sve traps at this stage
  causing the below kernel crash during the boot:

[    0.320850][    T1] Run /init as init process
[    0.321392][    T1] kvm [1]: nVHE hyp BUG at: [<ffffffc08112ee8c>] __kvm_nvhe_$x.24+0x254/0x254!
[    0.321522][    T1] kvm [1]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE
[    0.321635][    T1] kvm [1]: Hyp Offset: 0xffffff6e60000000
[    0.321710][    T1] Kernel panic - not syncing: HYP panic:
[    0.321710][    T1] PS:634023c9 PC:000000522112ee8c ESR:00000000f2000800
[    0.321710][    T1] FAR:0000000000000000 CPACR:0000000000310000 PAR:0000000000000800
[    0.321710][    T1] VCPU:0000000000000000
[...]
[    0.322251][    T1] Call trace:
[    0.322292][    T1]  dump_backtrace+0x100/0x180
[    0.322355][    T1]  show_stack+0x20/0x30
[    0.322410][    T1]  dump_stack_lvl+0x40/0x88
[    0.322471][    T1]  dump_stack+0x18/0x24
[    0.322523][    T1]  panic+0x13c/0x364
[    0.322578][    T1]  nvhe_hyp_panic_handler+0x148/0x1cc
[    0.322646][    T1]  do_sve_acc+0xec/0x260
[    0.322706][    T1]  el0_sve_acc+0x34/0x68

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Suggested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@google.com>
---
 arch/arm64/kvm/arm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..5d3b2069a2d5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2661,6 +2661,12 @@ static int __init init_hyp_mode(void)
 		}
 	}
 
+	/*
+	 * Flush entire BSS since part of its data is read while the MMU is off.
+	 */
+	kvm_flush_dcache_to_poc(kvm_ksym_ref(__hyp_bss_start),
+				kvm_ksym_ref(__hyp_bss_end) - kvm_ksym_ref(__hyp_bss_start));
+
 	return 0;
 
 out_err:
-- 
2.48.0.rc2.279.g1de40edade-goog

