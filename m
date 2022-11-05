Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08B91C04
	for <kvmarm@lists.linux.dev>; Sat,  5 Nov 2022 07:23:42 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id k5so6331800pjo.5
        for <kvmarm@lists.linux.dev>; Sat, 05 Nov 2022 00:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yq52tAH/MxGM65Yx9zGEKaWPTvFueeiBIyUIbXR0M9Q=;
        b=bFB2F0dOk+7RmyqlODQN6AV4el3iyfkqJDX87HRZQndWourFb9NRcH/jeGdUNWvhhQ
         1Y3ToDkfdz0hTYXOxYzZo32ler1S0My6evWkO5zOa6+91gnb3qxnN7M30VMidZ7Y71v4
         fv9mQDDqwX+6BLqZgt96OY8pLxHRks3jScJxhXvzetgjf4hT+lV7J6MbZK2n3SbUzCN6
         UV80MP+Ij9HvNjBFttNcEo4irYujAbTkhW96yFlGTPGj3sWmVhvreoNbw/QF8V/xMzlR
         cmgP60deL5rIgHc0zXWnvRtIPsJTgLNYySxvzgzdts+vgbtK3Z7F8xnfCoZksNnav2dW
         hy3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yq52tAH/MxGM65Yx9zGEKaWPTvFueeiBIyUIbXR0M9Q=;
        b=pKOldWNmxJXw5mgKzRJUoN5Lk/D16Uw0kdRiDxW+1MxeVE57Ridg430Bl5XAnbPCrs
         Qmrurj4O8nd++zFSSboE1o+xmQ6pg5an0aftbQ5ByOsWqXGLMJ8uZz5ciw0nMot3Zrbr
         NqiKy4JmeOL+h3yZ6O/1lt8KPKY2yn0/Rvh6i9JzdbjnK2kHdKGK14QkdtVcYc1oZH6v
         MaTgTNPopObuAd2OXuAgXJ7FUz/xwlKB9o6eXHMENRVXtomCi0SYG7gOkfT90/GgEWjk
         cLSq/knFD+hQe/mJCpusHLW0IFwMWSoGpyqf5477+g+Sz5TSH10/26ulZwLep/LBEGpI
         V1SA==
X-Gm-Message-State: ACrzQf3qcDRwoyqtVN/1VAv64XCV5l5O4Df3TgYvoDWwT6KD32hqzjaS
	QCfG8SyVFfuvzBvwDl1wWgkI5g==
X-Google-Smtp-Source: AMsMyM4LKijNmkyOB/EbOSqn/NWSN8cvycYETzVLpnbzyZIBhOtJ7jYzZjEQ2n+eOgZwOZPCi5+YAw==
X-Received: by 2002:a17:90b:1c0d:b0:213:1a9c:5b1 with SMTP id oc13-20020a17090b1c0d00b002131a9c05b1mr55848573pjb.188.1667633022220;
        Sat, 05 Nov 2022 00:23:42 -0700 (PDT)
Received: from leoy-huangpu.lan (211-75-219-201.hinet-ip.hinet.net. [211.75.219.201])
        by smtp.gmail.com with ESMTPSA id w27-20020aa79a1b000000b00562ef28aac6sm698138pfj.185.2022.11.05.00.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 00:23:41 -0700 (PDT)
From: Leo Yan <leo.yan@linaro.org>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	John Garry <john.garry@huawei.com>,
	James Clark <james.clark@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v1 1/3] KVM: arm64: Dynamically register callback for tracepoints
Date: Sat,  5 Nov 2022 07:23:09 +0000
Message-ID: <20221105072311.8214-2-leo.yan@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221105072311.8214-1-leo.yan@linaro.org>
References: <20221105072311.8214-1-leo.yan@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221105072309.41TGvCW3wtIuFXcOHoPPpkDIRsqSjgwi3kSS8HE8xD0@z>

This commit doesn't change any functionality but only refactoring.

It registers callbacks for tracepoints dynamically, with this way, the
existed trace events (in this case kvm_entry and kvm_exit) are kept.
This is a preparation to add new trace events in later patch.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 arch/arm64/kvm/Makefile    |  2 +-
 arch/arm64/kvm/arm.c       |  4 ++--
 arch/arm64/kvm/trace.c     | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/trace_arm.h |  8 ++++++++
 4 files changed, 40 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/kvm/trace.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 5e33c2d4645a..4e641d2df7ad 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
-	 arch_timer.o trng.o vmid.o \
+	 arch_timer.o trng.o vmid.o trace.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..03ed5f6c92bc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -917,7 +917,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/**************************************************************
 		 * Enter the guest
 		 */
-		trace_kvm_entry(*vcpu_pc(vcpu));
+		trace_kvm_entry_tp(vcpu);
 		guest_timing_enter_irqoff();
 
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
@@ -974,7 +974,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_enable();
 
-		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		trace_kvm_exit_tp(ret, vcpu);
 
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, ret);
diff --git a/arch/arm64/kvm/trace.c b/arch/arm64/kvm/trace.c
new file mode 100644
index 000000000000..d25a3db994e2
--- /dev/null
+++ b/arch/arm64/kvm/trace.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/init.h>
+#include <linux/tracepoint.h>
+
+#include <asm/kvm_emulate.h>
+
+#include "trace_arm.h"
+
+static void kvm_entry_tp(void *data, struct kvm_vcpu *vcpu)
+{
+	if (trace_kvm_entry_enabled())
+		trace_kvm_entry(*vcpu_pc(vcpu));
+}
+
+static void kvm_exit_tp(void *data, int ret, struct kvm_vcpu *vcpu)
+{
+	if (trace_kvm_exit_enabled())
+		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
+			       *vcpu_pc(vcpu));
+}
+
+static int __init kvm_tp_init(void)
+{
+	register_trace_kvm_entry_tp(kvm_entry_tp, NULL);
+	register_trace_kvm_exit_tp(kvm_exit_tp, NULL);
+	return 0;
+}
+
+core_initcall(kvm_tp_init)
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 33e4e7dd2719..ef02ae93b28b 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -11,6 +11,10 @@
 /*
  * Tracepoints for entry/exit to guest
  */
+DECLARE_TRACE(kvm_entry_tp,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu));
+
 TRACE_EVENT(kvm_entry,
 	TP_PROTO(unsigned long vcpu_pc),
 	TP_ARGS(vcpu_pc),
@@ -26,6 +30,10 @@ TRACE_EVENT(kvm_entry,
 	TP_printk("PC: 0x%016lx", __entry->vcpu_pc)
 );
 
+DECLARE_TRACE(kvm_exit_tp,
+	TP_PROTO(int ret, struct kvm_vcpu *vcpu),
+	TP_ARGS(ret, vcpu));
+
 TRACE_EVENT(kvm_exit,
 	TP_PROTO(int ret, unsigned int esr_ec, unsigned long vcpu_pc),
 	TP_ARGS(ret, esr_ec, vcpu_pc),
-- 
2.34.1

