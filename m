Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FD73043AD
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313550; cv=none; b=sW6UzrojpU8bm2InT9/PK1ClfKk/8t5ya93+yTMpqva/H6dJdyQd0TPz1EKVsKE1A8jCOOPGrFkJ24Nxw7Cj5rz/CiDT1x3rCMRYjHf0SuDTBSzOMIQee3BwKGo0zslB8t7tX0xZD/px+EdHRrIuwh/hyacJSkLGoRxAPJfabOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313550; c=relaxed/simple;
	bh=ufztQXXkn+enKVKuetQXwknrlXBaIadx4vWFFqCK2Jw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jyo8fpFs+1ZGTiSYuA3IhNf6SUnrY8VzYatgD3dv2q3NYhs4Rszb5/x+lGEbupiQWk+bhY3mgT96eyc+yCEXsX3iua97TJEJd6DEUIqfCfpY88AO98c7hcStfaFkCV1c/VNbFBTq2URfGBw99HAugUN1yBHDGUv7vVExrgSHDZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MUpPNQC/; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MUpPNQC/"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-450d5d26c0fso5860751b6e.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313547; x=1765918347; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o/qVm7syXSBwzXKPW3sV0twUobJ0+qc96Rj5NT8NWwc=;
        b=MUpPNQC/EuZ0IpLXdqU7dzPccq/FjoNfqiE7/E+PbxJGWt+Rxrz1kbJ6voRslrOZjO
         xF+1LE21ySgUpuSUmec4Plzsot3SQZVWE5sNCv0q3jiBInslcXK4cr1xGEzsk+cd/9j/
         CFcOaGD6HTJVTIzIinDn1x+viJcCaaK/rGDsoVma2njIU9nvvsGoImqzcsylYqdGwdts
         51LLg2YXu7hPSvWR6DxhqdzmtQZB0xS8PYkZltDbEAcpPap2GLB1rljixLn4Z+gNRVSd
         u0iHVu3a9ZvHv+Q7jGGfbD5c+GnmT+Ke8ro4ngXLF+ftJS+uQTkLsXj/TUL8iGWupVxj
         RQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313547; x=1765918347;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o/qVm7syXSBwzXKPW3sV0twUobJ0+qc96Rj5NT8NWwc=;
        b=UqHu8tz9SZfmA3MQwQc64H9tkpse59QXtXPWz5ODWcVXMLz6ng+WG2puQ47mZdYVzf
         EptAmfLnco8gQHVRx9n9625jgo7+ClPVESvqQV9DWFwjuxJRW0B/RcQjUM84JIBJkQ1z
         8qESLlhWHgQHxVjoGQnchEXUP1jkLfhFPx17edbnvfQLxsE9yNW5/gJ9L7I402ndpzg0
         SD6ppSZAiBIpzvSfTSeo4nh6GBtySkW4qwla0If9TnzdRqu8jEAQmppl7dpAfpZdyEaM
         9qQLwXOoOZ3J4Y3eeUAiq7Bg2VFcToL4WXkGR6YOTenRXIrz9CMoq4fFR6qtDyoPZHzl
         Ei0g==
X-Forwarded-Encrypted: i=1; AJvYcCViMdtrDSPTjm+bkKz/SmSaNtwmPYvlPpWmn+/rgrxrZ2cf2JMzx41vXdk3bKnla/GZdEaKsKk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAn0QOhwKGjHOAzLfIqujNWDDZzjl8w29ZpUR1PQPrM84xqyns
	TeK5uEZxCMR5NR/e+QMKM2dcFfNskGlanefE1ewG/Ofcxs7yAC13E8yIIuhyShB2FlRRdrq4rs+
	X07aHWthxsjllg9bjdPY3HlxMoQ==
X-Google-Smtp-Source: AGHT+IGMEEiWlIsLcKC8hs4P3z7HH8vM6u4+YJjjWTz9UxE62QKo9QFa3+4D81wsK3WwLqL+Ey8kAtFXETIm5Pw36Q==
X-Received: from oibcg5.prod.google.com ([2002:a05:6808:3285:b0:450:c419:c769])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:13d4:b0:450:7fc9:3709 with SMTP id 5614622812f47-455864f476emr131219b6e.48.1765313547501;
 Tue, 09 Dec 2025 12:52:27 -0800 (PST)
Date: Tue,  9 Dec 2025 20:50:59 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-3-coltonlewis@google.com>
Subject: [PATCH v5 02/24] KVM: arm64: Move arm_{psci,hypercalls}.h to an
 internal KVM path
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Anish Ghulati <aghulati@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Anish Ghulati <aghulati@google.com>

Move arm_hypercalls.h and arm_psci.h into arch/arm64/kvm now that KVM
no longer supports 32-bit ARM, i.e. now that there's no reason to make
the hypercall and PSCI APIs "public".

Signed-off-by: Anish Ghulati <aghulati@google.com>
[sean: squash into one patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250611001042.170501-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/arm.c                         | 5 +++--
 {include => arch/arm64}/kvm/arm_hypercalls.h | 0
 {include => arch/arm64}/kvm/arm_psci.h       | 0
 arch/arm64/kvm/guest.c                       | 2 +-
 arch/arm64/kvm/handle_exit.c                 | 2 +-
 arch/arm64/kvm/hyp/Makefile                  | 6 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h      | 4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c             | 4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c              | 4 ++--
 arch/arm64/kvm/hypercalls.c                  | 4 ++--
 arch/arm64/kvm/psci.c                        | 4 ++--
 arch/arm64/kvm/pvtime.c                      | 2 +-
 arch/arm64/kvm/trng.c                        | 2 +-
 13 files changed, 20 insertions(+), 19 deletions(-)
 rename {include => arch/arm64}/kvm/arm_hypercalls.h (100%)
 rename {include => arch/arm64}/kvm/arm_psci.h (100%)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 052bf0d4d0b03..d1750d6058dfd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -41,9 +41,10 @@
 #include <asm/kvm_ptrauth.h>
 #include <asm/sections.h>
 
-#include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
-#include <kvm/arm_psci.h>
+
+#include "arm_hypercalls.h"
+#include "arm_psci.h"
 
 #include "sys_regs.h"
 
diff --git a/include/kvm/arm_hypercalls.h b/arch/arm64/kvm/arm_hypercalls.h
similarity index 100%
rename from include/kvm/arm_hypercalls.h
rename to arch/arm64/kvm/arm_hypercalls.h
diff --git a/include/kvm/arm_psci.h b/arch/arm64/kvm/arm_psci.h
similarity index 100%
rename from include/kvm/arm_psci.h
rename to arch/arm64/kvm/arm_psci.h
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1c87699fd886e..863b351ae1221 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -18,7 +18,6 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
-#include <kvm/arm_hypercalls.h>
 #include <asm/cputype.h>
 #include <linux/uaccess.h>
 #include <asm/fpsimd.h>
@@ -27,6 +26,7 @@
 #include <asm/kvm_nested.h>
 #include <asm/sigcontext.h>
 
+#include "arm_hypercalls.h"
 #include "trace.h"
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index cc7d5d1709cb8..66740520f2166 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -22,7 +22,7 @@
 #include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
 
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace_handle_exit.h"
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index d61e44642f980..b1a4884446c69 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -3,8 +3,8 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #
 
-incdir := $(src)/include
-subdir-asflags-y := -I$(incdir)
-subdir-ccflags-y := -I$(incdir)
+hyp_includes := -I$(src)/include -I$(srctree)/arch/arm64/kvm
+subdir-asflags-y := $(hyp_includes)
+subdir-ccflags-y := $(hyp_includes)
 
 obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index c5d5e5b86eaf0..6e8050f260f34 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -16,8 +16,6 @@
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/extable.h>
@@ -32,6 +30,8 @@
 #include <asm/processor.h>
 #include <asm/traps.h>
 
+#include "arm_psci.h"
+
 struct kvm_exception_table_entry {
 	int insn, fixup;
 };
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index d3b9ec8a7c283..5d626308952ac 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -13,8 +13,6 @@
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/kprobes.h>
@@ -28,6 +26,8 @@
 
 #include <nvhe/mem_protect.h>
 
+#include "arm_psci.h"
+
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9984c492305a8..0039e501a3cb7 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -13,8 +13,6 @@
 #include <linux/percpu.h>
 #include <uapi/linux/psci.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/kprobes.h>
@@ -28,6 +26,8 @@
 #include <asm/thread_info.h>
 #include <asm/vectors.h>
 
+#include "arm_psci.h"
+
 /* VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 58c5fe7d75727..05331389081f8 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -6,8 +6,8 @@
 
 #include <asm/kvm_emulate.h>
 
-#include <kvm/arm_hypercalls.h>
-#include <kvm/arm_psci.h>
+#include "arm_hypercalls.h"
+#include "arm_psci.h"
 
 #define KVM_ARM_SMCCC_STD_FEATURES				\
 	GENMASK(KVM_REG_ARM_STD_BMAP_BIT_COUNT - 1, 0)
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3b5dbe9a0a0ea..0566b59074978 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -13,8 +13,8 @@
 #include <asm/cputype.h>
 #include <asm/kvm_emulate.h>
 
-#include <kvm/arm_psci.h>
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
+#include "arm_psci.h"
 
 /*
  * This is an implementation of the Power State Coordination Interface
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 4ceabaa4c30bd..b07d250d223c0 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -8,7 +8,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/pvclock-abi.h>
 
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
 
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
index 99bdd7103c9c1..b5dc0f09797a3 100644
--- a/arch/arm64/kvm/trng.c
+++ b/arch/arm64/kvm/trng.c
@@ -6,7 +6,7 @@
 
 #include <asm/kvm_emulate.h>
 
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
 
 #define ARM_SMCCC_TRNG_VERSION_1_0	0x10000UL
 
-- 
2.52.0.239.gd5f0c6e74e-goog

