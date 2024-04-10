Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9597113D500
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 08:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737828; cv=none; b=U12r4we01G2N2Oau0vTQs6enbvLH2ZdprMMCUSaXdUCrEOrgeKmNWGaXeN7dCQFmzmgyJ/YuHcjfDXN20cVSLhx1UXPb8aoBJkrVMcsv27+58MoZIu+J2HlnSJEWPjkQfcPevC1NLgA1TqDSFFYwCiRZ1w/BoUNGkWQpp7j1r6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737828; c=relaxed/simple;
	bh=sjLo+2j08iLCyaP/ZrrXRs8M6s13hs4gKMe6/iy5SyA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FI0XFM9kSrLjIvWHPt7HHU9eh8FuiQkT6a/c+9dv6TQvDzRPlWnTdKJrwChrjb1AjmFnu0gHYhQwZ6klzKt+YZxkWlKs9J6zBWIrYdlgw1582yF9krwfbXWHVwgDpml5OppJ7RmHL7+WKDIPkdbwlbETFlDCYIQpy1jC+UZhk1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iMiB4t97; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iMiB4t97"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a46ea03c2a5so1070558466b.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 01:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737825; x=1713342625; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6DrtWKL4HFIVL/Z+tlpZfy75B2ArHvwYVgq7qkQ5Eg=;
        b=iMiB4t9751/1RF6ktbVecELsOlSXe0KBlyB3lRPKPgLYHBEa1RvdXzHgEmmIAlK68V
         Oy7EjJFwZL13sb5yLCExikgLNGibyu5xNBqjpBV8vg2VyqFQFJgPXMrRw9i0whA2xuXc
         deFHdBHAj7f18Z8A4mQ/pWAFz+XHgUrXVCeUcPvHRFVot4318pU472o3SpTLKkQ/K5lH
         TT3PDS7Bet9Csy/3pDwLIuESNV3QhwLHi6w1b1qxAwzxRet2DFFUseJl5C2jGq6CMBEo
         NdQc7ZKepOTnOqF2ckJg/fykrhEoSAZ70QeR4ZyR3N6Yr/dKx/kJ9oBNQB0YOElLdMGA
         KzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737825; x=1713342625;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v6DrtWKL4HFIVL/Z+tlpZfy75B2ArHvwYVgq7qkQ5Eg=;
        b=PBdeQ2LXcVM7DiHcmZK3HUxPoEdPGwcWoaZquvGy4A6uN/W8UAKzGIuv0Ve6d/4xBY
         4dc378YYy3sln+/DzyYdgz0KL8ri3qwyRQxVwMDVjjR6kLo5IOi0ES6SXgjjXRRzed6T
         rLPDnio8oibDEPUFMH520xQSswjVpPIcDnBduyCNvLp1dKrulhVCMsw7n1CtsXbo7I8G
         iCNTLV6Q8OG6ERydhLQPympcRLWzUxwmDdUjrS+byFQkoZV0SILPq4KsxPY55H0e290k
         F0tmKoyGiP9tKINBFnMl7LfcFdMXiuK+jzfHXQafo+aq2XpT5+XFOCjlbNDCvytedBVS
         qdHQ==
X-Gm-Message-State: AOJu0Yy67jOhTUk1QD4czot1vmlqwbXYVz8J3Hxf/3bjd7r9f6ZAdgsC
	/teDReZTgT8f1ZFSZtxvSqsypGUIwynUKCFkOm9DdRds4HLlfvqaPubPbWbaS6FhwDTZc04d0Hd
	mYQ==
X-Google-Smtp-Source: AGHT+IE+3bFNql+D7KkAv08EKtihoMoVNO9YFCZha/FUwb6uG6uieK7br/du5MzzN0cCL5aBqVM6xQ==
X-Received: by 2002:a17:907:8686:b0:a52:b70:454f with SMTP id qa6-20020a170907868600b00a520b70454fmr1429337ejc.15.1712737824552;
        Wed, 10 Apr 2024 01:30:24 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id de26-20020a056402309a00b0056c1cca33bfsm6129511edb.6.2024.04.10.01.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:30:24 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:30:20 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 10/12] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
Message-ID: <as6khq6ychznvsfhgcxb7ke6jkkqui5lddovd6qxz26fbjnjmb@lwzgdwx7aomk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

The compiler implements kCFI by adding type information (u32) above
every function that might be indirectly called and, whenever a function
pointer is called, injects a read-and-compare of that u32 against the
value corresponding to the expected type. In case of a mismatch, a BRK
instruction gets executed. When the hypervisor triggers such an
exception in nVHE, it panics and triggers and exception return to EL1.

Therefore, teach nvhe_hyp_panic_handler() to detect kCFI errors from the
ESR and report them. If necessary, remind the user that EL2 kCFI is not
affected by CONFIG_CFI_PERMISSIVE.

Pass $(CC_FLAGS_CFI) to the compiler when building the nVHE hyp code.

Use SYM_TYPED_FUNC_START() for __pkvm_init_switch_pgd, as nVHE can't
call it directly and must use a PA function pointer from C (because it
is part of the idmap page), which would trigger a kCFI failure if the
type ID wasn't present.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       |  6 ++++++
 arch/arm64/kvm/handle_exit.c       | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 2bcf216be376..9eb9e6aa70cf 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -391,6 +391,12 @@ static inline bool esr_is_data_abort(unsigned long esr)
 	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
 }
 
+static inline bool esr_is_cfi_brk(unsigned long esr)
+{
+	return ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
+	       (esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE;
+}
+
 static inline bool esr_fsc_is_translation_fault(unsigned long esr)
 {
 	/* Translation fault, level -1 */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 0bcafb3179d6..0db23a6304ce 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -383,6 +383,15 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+{
+	kvm_err("nVHE hyp CFI failure at: [<%016llx>] %pB!\n", panic_addr,
+		(void *)(panic_addr + kaslr_offset()));
+
+	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
+		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -413,6 +422,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 		else
 			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
 					(void *)(panic_addr + kaslr_offset()));
+	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
+		kvm_nvhe_report_cfi_failure(panic_addr);
 	} else {
 		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
 				(void *)(panic_addr + kaslr_offset()));
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 2250253a6429..2eb915d8943f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -89,9 +89,9 @@ quiet_cmd_hyprel = HYPREL  $@
 quiet_cmd_hypcopy = HYPCOPY $@
       cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
 
-# Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
-# This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
-KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
+# Remove ftrace and Shadow Call Stack CFLAGS.
+# This is equivalent to the 'notrace' and '__noscs' annotations.
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 # Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
 # when profile optimization is applied. gen-hyprel does not support SHT_REL and
 # causes a build failure. Remove profile optimization flags.
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 5a15737b4233..33fb5732ab83 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -5,6 +5,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/cfi_types.h>
 #include <linux/linkage.h>
 
 #include <asm/alternative.h>
@@ -268,8 +269,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
 /*
  * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
  *                             void (*finalize_fn)(void));
+ *
+ * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
+ * using a physical pointer without triggering a kCFI failure.
  */
-SYM_FUNC_START(__pkvm_init_switch_pgd)
+SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
 	/* Load the inputs from the VA pointer before turning the MMU off */
 	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
 	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre
