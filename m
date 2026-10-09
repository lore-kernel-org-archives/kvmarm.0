Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA573E5A32
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 08:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791535550; cv=none; b=D9ItJrhDMQfgtzPMwgn1H/3r3WI5E/ApESe9fzOW5oA6CGTHRdbjPbepDO6JcwL5pBz018rJf6HFvevnxVlZVcRc3OL0zW9lz4wM8efCQEUWqmOUYm8boWd70/prS8dfuVTux40E4ISS/46aYG5M0el/mC7Lf61zm6DhKJ9KRdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791535550; c=relaxed/simple;
	bh=bhYDZsy6q1hiUjVIRkuX64b3O4zJ7QLOr9WtRGm52Kc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t821fcYNp25y90Hlf2vK+ZgdBgVIrAlI6hItRpFtrlFsM+vT4RJyJjCKefwM3gWvhp97JUyV/seCNm+fF9NlE0SbN9+OtKZYDYuBtOFmDWkEGTyFU98w8xiLj6fLJ2Xo+M52fZzXZun0aRevqdvlY9bqluB2d8FrdXTye2KY9hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uzy8hHwN; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uzy8hHwN"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a16db51147so37132425e9.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 01:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791535547; x=1792140347; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qbz6//JmwfMRati7yJIqKJVh8kAD+ori3Lhbs5JEXXs=;
        b=uzy8hHwNrh5jfGaUWTnhBIXYwfb/jmmog3ZuQfdOblfBMTxvCL6bB8Y2czM9NfrUS/
         BJ51kSjTCOjeVDUPuWIjgORAl+PxR3J8sEKmYXlQ06wkPJPQlA0msyzQE5zB9MtOLdq+
         S+I01iZJCRsYQgl0C16XLuWl/63mqMYAbshPGOBSPyFbIXFPgf6hegYslc7aAXl16u/o
         T5LRIwpDh4ATRW57nPVT5DHUsInAut7HTNZg3qALJD2vHrq5SRRXNitx0tAMahTH91Zb
         ezT30L8u6S15UFTrSi7yba9jmGNZ4jDG6fXlgxr94WJ0BJxDemRQ0JSmXsSHWy6iULTC
         3AHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791535547; x=1792140347;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qbz6//JmwfMRati7yJIqKJVh8kAD+ori3Lhbs5JEXXs=;
        b=GIYbHNaE4xKu4pNNSEievTZQ+qnj62d5vQS6blVbrbasBjVhw/eSQP6Rlyejy5lUlO
         bKJNRjj5LSuJaabo5Q0MlaxZRwYZ60JfDZ3TO1knlOLPkIWQb41YyBkG9lIM9qnzlHND
         C9XwoFU/rBCtAW2g9P+55IWwcLr6nSHDKSbSAY75iqDAREd19KkBGKujYGEglNzKjZT/
         dunqRtrTxNV3S3wZ7fx9uCq2GyPyBUD2EqJMqMI2aY0tzmaj+llGLMgU25DFYRF1dZjC
         PcK+JF4yKmsvhi6TizdTBRzyJcRerJ5k96QskIPy829fAc/XqskAIedVsg8KAXc7aQxU
         rT1Q==
X-Forwarded-Encrypted: i=1; AKwUvBw+VDxTitYVZcoGNvLf/hbADxCpoIn1khfXs692H2CQWJwCQWVt4RyeMl5xCtc7C+Ci26bdiqs=@lists.linux.dev
X-Gm-Message-State: AFuF++lfZs3Y1nJ8q7Kpsg10VD3GS5GpjjhppdZ1wpT2tHJ/sNVgSZ6h
	bnXB5Ke2aeJt30QEVPe2Hjw0X3pQW/9DDVWOmrWcobku6mUdXJ4AzBPFylRlu+ihPGIcI8EckxP
	KF1H34iAH36M3T9DnN1kRGA==
X-Received: from wmco24.prod.google.com ([2002:a05:600c:a318:b0:4a1:8915:6ed2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:e557:20b0:49f:dd9f:6038 with SMTP id 5b1f17b1804b1-4a18e4bff94mr12611255e9.25.1791535547075;
 Fri, 09 Oct 2026 01:45:47 -0700 (PDT)
Date: Fri,  9 Oct 2026 09:45:27 +0100
In-Reply-To: <20261009084529.462577-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261009084529.462577-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009084529.462577-2-vdonnefort@google.com>
Subject: [PATCH v1 1/3] KVM: arm64: Add ESR class to the hyp_enter hyp event
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Give a more detailed reason the hyp has been entered by reading the ESR
class when relevant (that is on trap). Encode the ESR class directly
into the existing reason field.

To distinguish between a trap from host and from guest, add a "from="
field, which has 3 possibilities: "host", "vcpu" or "firmware". This
value can be deducted based on the existing vcpu field.

Finally, add a "to=" field to the hyp_exit event to mirror "hyp_enter".

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_hypevents.h | 21 ++++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  7 +---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c       |  6 ++-
 arch/arm64/kvm/hyp_trace.c             | 52 ++++++++++++++++++++------
 5 files changed, 59 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 5f6e6789d121..96985c93a15e 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -10,15 +10,10 @@
 #ifndef __HYP_ENTER_EXIT_REASON
 #define __HYP_ENTER_EXIT_REASON
 enum hyp_enter_exit_reason {
-	HYP_REASON_SMC,
-	HYP_REASON_HVC,
-	HYP_REASON_SYS,
+	HYP_REASON_SMC = ESR_ELx_EC_MAX + 1,
 	HYP_REASON_PSCI,
-	HYP_REASON_HOST_ABORT,
-	HYP_REASON_GUEST_EXIT,
-	HYP_REASON_ERET_HOST,
-	HYP_REASON_ERET_GUEST,
-	HYP_REASON_UNKNOWN	/* Must be last */
+	HYP_REASON_IRQ,
+	HYP_REASON_ERET,
 };
 #endif
 
@@ -32,7 +27,10 @@ HYP_EVENT(hyp_enter,
 		__entry->reason = reason;
 		__entry->vcpu = __tracing_get_vcpu_pid(host_ctxt);
 	),
-	HE_PRINTK("reason=%s vcpu=%d", __hyp_enter_exit_reason_str(__entry->reason), __entry->vcpu)
+	HE_PRINTK("from=%s reason=%s vcpu=%d",
+		  __hyp_enter_exit_str(__entry->reason, __entry->vcpu),
+		  __hyp_enter_exit_reason_str(__entry->reason),
+		  __entry->vcpu)
 );
 
 HYP_EVENT(hyp_exit,
@@ -45,7 +43,10 @@ HYP_EVENT(hyp_exit,
 		__entry->reason = reason;
 		__entry->vcpu = __tracing_get_vcpu_pid(host_ctxt);
 	),
-	HE_PRINTK("reason=%s vcpu=%d", __hyp_enter_exit_reason_str(__entry->reason), __entry->vcpu)
+	HE_PRINTK("to=%s reason=%s vcpu=%d",
+		  __hyp_enter_exit_str(__entry->reason, __entry->vcpu),
+		  __hyp_enter_exit_reason_str(__entry->reason),
+		  __entry->vcpu)
 );
 
 HYP_EVENT(selftest,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index ac64a036b0a9..76d08c503dc0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1112,23 +1112,20 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
 
+	trace_hyp_enter(host_ctxt, ESR_ELx_EC(esr));
 
 	switch (ESR_ELx_EC(esr)) {
 	case ESR_ELx_EC_HVC64:
-		trace_hyp_enter(host_ctxt, HYP_REASON_HVC);
 		handle_host_hcall(host_ctxt);
 		break;
 	case ESR_ELx_EC_SMC64:
-		trace_hyp_enter(host_ctxt, HYP_REASON_SMC);
 		handle_host_smc(host_ctxt);
 		break;
 	case ESR_ELx_EC_IABT_LOW:
 	case ESR_ELx_EC_DABT_LOW:
-		trace_hyp_enter(host_ctxt, HYP_REASON_HOST_ABORT);
 		handle_host_mem_abort(host_ctxt);
 		break;
 	case ESR_ELx_EC_SYS64:
-		trace_hyp_enter(host_ctxt, HYP_REASON_SYS);
 		if (handle_host_mte(esr))
 			break;
 		fallthrough;
@@ -1136,5 +1133,5 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		BUG();
 	}
 
-	trace_hyp_exit(host_ctxt, HYP_REASON_ERET_HOST);
+	trace_hyp_exit(host_ctxt, HYP_REASON_ERET);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index e20db999e328..c771c1d150c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -213,7 +213,7 @@ static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long
 	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
 	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
 
-	trace_hyp_exit(host_ctxt, HYP_REASON_PSCI);
+	trace_hyp_exit(host_ctxt, HYP_REASON_ERET);
 	__host_enter(host_ctxt);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7318e3e6a5f3..cf4de8287b97 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -324,13 +324,15 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__debug_switch_to_guest(vcpu);
 
 	do {
-		trace_hyp_exit(host_ctxt, HYP_REASON_ERET_GUEST);
+		trace_hyp_exit(host_ctxt, HYP_REASON_ERET);
 
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
-		trace_hyp_enter(host_ctxt, HYP_REASON_GUEST_EXIT);
+		trace_hyp_enter(host_ctxt,
+				ARM_EXCEPTION_CODE(exit_code) == ARM_EXCEPTION_IRQ ?
+				HYP_REASON_IRQ : ESR_ELx_EC(read_sysreg_el2(SYS_ESR)));
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 9644c424819b..e47b91bf3ae1 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -400,25 +400,55 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 	.enable_event		= hyp_trace_enable_event,
 };
 
+static const char *__hyp_enter_exit_str(u8 reason, pid_t vcpu);
 static const char *__hyp_enter_exit_reason_str(u8 reason);
 
 #include <asm/kvm_define_hypevents.h>
 
+static const char *__hyp_enter_exit_str(u8 reason, pid_t vcpu)
+{
+	switch (reason) {
+	case 0 ... ESR_ELx_EC_MAX:
+	case HYP_REASON_IRQ:
+	case HYP_REASON_ERET:
+		return vcpu ? "vcpu" : "host";
+	case HYP_REASON_SMC:
+	case HYP_REASON_PSCI:
+		return "firmware";
+	default:
+		return "unknown";
+	}
+}
+
 static const char *__hyp_enter_exit_reason_str(u8 reason)
 {
-	static const char strs[][12] = {
-		"smc",
-		"hvc",
-		"sys",
-		"psci",
-		"host_abort",
-		"guest_exit",
-		"eret_host",
-		"eret_guest",
-		"unknown",
+	static const struct trace_print_flags class[] = {
+		kvm_arm_exception_class
 	};
 
-	return strs[min(reason, HYP_REASON_UNKNOWN)];
+	if (reason <= ESR_ELx_EC_MAX) {
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(class); i++) {
+			if (class[i].mask == reason)
+				return class[i].name;
+		}
+
+		return "UNKNOWN_ESR";
+	}
+
+	switch (reason) {
+	case HYP_REASON_SMC:
+		return "SMC";
+	case HYP_REASON_PSCI:
+		return "PSCI";
+	case HYP_REASON_IRQ:
+		return "IRQ";
+	case HYP_REASON_ERET:
+		return "ERET";
+	default:
+		return "UNKNOWN_REASON";
+	}
 }
 
 static void __init hyp_trace_init_events(void)
-- 
2.56.0.385.gd3acb90ef8-goog

