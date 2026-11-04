Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801190;
	b=XDyCb9uAtn2B4C3njuu/e3HCG4byJoOA8QWWr1/I4o/uk5OwA5RWMSHXAhC10Com86ic
	 qmvnf/N4pGmnNUXq++k4K31Gui6RXUofTVKainqKM+oKkriDGl6xDtxTQhJw+gLMadmI+
	 1h3VyksfNtSzUg9nAJuixR9FSS45Fag+uJSekVUUwPJ2cvczjYXItXxuXjJily95SWF2G
	 jwJ96mMYOZ7wv5TXv9Ilzd4fpDwgMVhexNxgt/4bIPtyglOcr433TX8MNTBcLFr0+KZPb
	 jaHVkhVq8WIMQBTyliFGu9zybO4Yj6DbofTRW7Cxon+CInVtBvgRiMP1CkBBVGnn0vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=oR4eJtwvtcfj1GI1NI+nTmmxoOSHKaXhB8PQvEukb9k=;
	b=FiX/5x2kwRxtMjld6QBpvgNVsNHSR4qOnrUZ0kngRm+k5qS4INzI8rMYWptsOFbN5L12
	 5iu6iNc3nxkEy9r+1mFs0jS9cVmInGQwkny6AB+LQEuDojVUX3NCOUdEewmrqd62zfyHM
	 hgO69orPQvJfwaa5E2aIIUi8cVIAne1eN/twjT87dXnfHIRwLBSbxaHW1uT5W4ZhFN2ec
	 x3tLmKZYDssc9yOlNWBjqCe4wVaaDQGMnZbjeF5xTLBhXmCzd6JaeucqjPpxeYd3+5MJD
	 VqIS1GjklWsPeboB72UT6ipqIWdqjYtLdrgXpFWWLUT4E8h/HyeJpZ9p5FoEOcKt4uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IxasOZ+Z;
	arc=none smtp.remote-ip=209.85.221.70
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E6E606A31B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 14:06:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4E6E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IxasOZ+Z
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-490d2ac331bso120049f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Nov 2026 06:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793801188; x=1794405988; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oR4eJtwvtcfj1GI1NI+nTmmxoOSHKaXhB8PQvEukb9k=;
        b=IxasOZ+ZsJNlwyNkyP0rX/jd8HbN/stXGgp3k4JjUcoEjnPMYwGdOs2fMHWBs1nhzh
         Rf8jLMHHYF8maeXJqIh57QSbQ++2xiZnvuVor73c3WNadXYKoRfepiBJsD3OoVUKzZ6D
         DKGsAAEo7ikSk601mCtrv6D3kPXnE/eFd825D91ETBgHwxVUTAAg0U7os4owdnWnzemc
         9v/c78hhgd1NA7TJZBxEhrzLkh5E6YS4KCKzGhNL7Q7hP3UQOhkB3aE8NhQ2e+f/tqhP
         9NoSs7glDSKHp1fsugTRQJ5Wh1SEfIQnfVVYLMISpNROYoH2V40sJTmwg4XpQvzmBTYj
         oXLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801188; x=1794405988;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oR4eJtwvtcfj1GI1NI+nTmmxoOSHKaXhB8PQvEukb9k=;
        b=WB0odKW5A5sJkm7up0yS93h+M1QSCk9s7ZPX4OpslxMD9ZvDcqW3BpbiS/vl2tvyf+
         IzBzWlajvjHOSEMBQN18r4GnVwZIcvTzrEC4X5Iak5US4MCnHKMoIvn2MoyG6INugMWn
         dGzm48fOtDW7nyqTIZbDfzCWid8CaG1xOwkUqD7K7CNdTxbB+iVBcWPXfm/DtOJxxPzA
         pv0Li83F9vOU4fHDJEpoVLRp9wKDckm/voZjTP84Km0G5pdzbhZ0tBYahTRl6MpaoHPu
         Wix8tL5Jb8LF5gV6vtxY6+NW3bzvgKVBcfdtrDNN+eMLuK8fo7PK8WB12uUnsRwYMtWu
         lFWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwbN6xr+jO7gVpMoGvA5m6GUop9OV35Nf6RXlvQYOyiwjauT0TcxR9lNXKI5DWW2o+Roj2Z1iw=@lists.linux.dev
X-Gm-Message-State: APuU4Z+Rx96KZkWz6sL73OS6UyxJpUf3miZdwuFUJiOtJvCJ1/sFBU/K
	DiUmP4bcaiF+l9/6nJd6cJVZotzcf7Gt5jNtRFW5KwOCVzRVTfTBzbzSfv6lwgVAtTaFHOvACVe
	uPOkDNZY8KIrd43ksm+E++Q==
X-Received: from wmhn21.prod.google.com ([2002:a05:600c:3055:b0:4a2:a8e:2e95])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c088:b0:4ac:da92:2bd4 with SMTP id 5b1f17b1804b1-4acda922e24mr262532025e9.1.1793801187800;
 Wed, 04 Nov 2026 06:06:27 -0800 (PST)
Date: Wed,  4 Nov 2026 14:06:10 +0000
In-Reply-To: <20261104140612.137869-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261104140612.137869-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261104140612.137869-4-vdonnefort@google.com>
Subject: [PATCH v2 3/5] KVM: arm64: Add ESR class to the hyp_enter hyp event
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
value can be deduced based on a combination of the existing vcpu and
reason fields.

Finally, add a "to=" field to the hyp_exit event to mirror "hyp_enter",
allowing HYP_REASON_ERET_HOST and HYP_REASON_ERET_GUEST to be collapsed
into a single HYP_REASON_ERET.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_hypevents.h | 29 ++++++++------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  7 +---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c       |  6 ++-
 arch/arm64/kvm/hyp_trace.c             | 52 ++++++++++++++++++++------
 5 files changed, 66 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 3396deb1a1f8..7486d95455c5 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -3,22 +3,22 @@
 #if !defined(__ARM64_KVM_HYPEVENTS_H_) || defined(HYP_EVENT_MULTI_READ)
 #define __ARM64_KVM_HYPEVENTS_H_
 
+#include <asm/esr.h>
+
 #ifdef __KVM_NVHE_HYPERVISOR__
+#include <asm/kvm_hyp.h>
+
 #include <nvhe/trace.h>
 #endif
 
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
+	HYP_REASON_USE_ESR, /* trace_hyp_enter() only, resolved to ESR_EL2.EC */
 };
 #endif
 
@@ -29,10 +29,14 @@ HYP_EVENT(hyp_enter,
 		he_field(pid_t, vcpu)
 	),
 	HE_ASSIGN(
-		__entry->reason = reason;
+		__entry->reason = reason == HYP_REASON_USE_ESR ?
+			ESR_ELx_EC(read_sysreg_el2(SYS_ESR)) : reason;
 		__entry->vcpu = __tracing_get_vcpu_pid(host_ctxt);
 	),
-	HE_PRINTK("reason=%s vcpu=%d", __hyp_enter_exit_reason_str(__entry->reason), __entry->vcpu)
+	HE_PRINTK("from=%s reason=%s vcpu=%d",
+		  __hyp_enter_exit_str(__entry->reason, __entry->vcpu),
+		  __hyp_enter_exit_reason_str(__entry->reason),
+		  __entry->vcpu)
 );
 
 HYP_EVENT(hyp_exit,
@@ -45,7 +49,10 @@ HYP_EVENT(hyp_exit,
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
index 179d7c8277b8..28e0191e443f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1758,23 +1758,20 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
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
@@ -1782,5 +1779,5 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		BUG();
 	}
 
-	trace_hyp_exit(host_ctxt, HYP_REASON_ERET_HOST);
+	trace_hyp_exit(host_ctxt, HYP_REASON_ERET);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 48228991a7ba..c771c1d150c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -213,7 +213,7 @@ static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long
 	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
 	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
 
-	trace_hyp_exit(host_ctxt, HYP_REASON_ERET_HOST);
+	trace_hyp_exit(host_ctxt, HYP_REASON_ERET);
 	__host_enter(host_ctxt);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 89fb9dd351ad..afb672dda5e8 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -345,13 +345,15 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
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
+				HYP_REASON_IRQ : HYP_REASON_USE_ESR);
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index b9404496f977..ec97d412adfa 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -405,6 +405,7 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 	.enable_event		= hyp_trace_enable_event,
 };
 
+static const char *__hyp_enter_exit_str(u8 reason, pid_t vcpu);
 static const char *__hyp_enter_exit_reason_str(u8 reason);
 
 struct remote_event_format_hyp_printk;
@@ -412,21 +413,50 @@ static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, str
 
 #include "define_hypevents.h"
 
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
 
 static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq)
-- 
2.56.0.455.g6c5a503b38-goog

