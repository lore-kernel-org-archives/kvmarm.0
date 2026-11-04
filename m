Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801191;
	b=BouESWrIaAgbK6qbcAtBBPvbsybOSUoC5SLdFAu4eXdRq90/cQfK0O6AmBCweKSeCvSK
	 Wt5QTfvUsC+d/b33R0hV6QvIyczQ9MgsAzuEJ6U5wZ/R2Q0RgDFHy5gfNVtgoUipoXazV
	 dwwH5ZRkzEGSGv4A0aCwzaoeUqUAU9OUqnT198/vTu48DNrKpErP+hpDnHUR1F65nnGnM
	 Z3myA/hKhNhJKqcl1ckOBoc14B2vL/8zJH7avn0XYy6njfeTewaVJeeR21bne0t6EAJes
	 Jf3G6UC8OV5w0RPjAs148xgWQr/hzAyUV0vRtapM56aVMZKbobbf1iUNB7PJ0DEa4KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801191;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Otbpqb7SJFabxtkE4DZe7Wt61LA99tGboOBEZyTX8RM=;
	b=PkF6VYWTfd1lPRtJcBiunTg2GI3aRvlPOsrt64pHSXDlkEoUvDSmFv3aq3lzw75CQWHT
	 1Ka0rMOk40vXOw2gz6jYlRD2Xcso2jutJqEJJtObdM+EqK9sAb0QX09b56EnjYomdtKmh
	 PZDgPZPjm+0qx2qsk7NXGxlZ+/eErwqkZfRPdJ+spQVCZhsPCV1EbxROsgkqgCxljHj4I
	 1VxH2tQ5NGmIlaE7mlQLOkJRz1ZnOmGY2kfEz4fSa2ixry5bMPkgsv+f1s8gmvdna53+A
	 aU8iNwIx9ZqMRbTKmcI1i+LvRmXWUQ0yucNPRkRBErnUqwiREoH6gPermaHLNEeM0vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mwZAieDn;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF043606A330
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 14:06:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF043606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mwZAieDn
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e0389d6f9so539086f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Nov 2026 06:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793801189; x=1794405989; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Otbpqb7SJFabxtkE4DZe7Wt61LA99tGboOBEZyTX8RM=;
        b=mwZAieDnBsl0uSZVdfL+tsRY2l/Cv55A+ptZRJUmVkNooa9Too15u7iIv8UpN7SnHw
         xzbe++eLBRhfUzIO419f1cyn4oBOnFN00oEGN8b9wC/yu3hweBqoDEKM6b0jMGoXFEs6
         RNUk97+L1HRjRD6Q/30c/m8hhW1YHA4mKi01mCmNatVtojCkIbOUNXNciPNt7rj1x4oE
         PRCjEugDzS+Y5A6zy+kkT7mTUbnmQ0LjPeNN1Izuj695+KAw82G7OP7ukHlTxr4OB4nl
         eAgEfnpllmreAUdiWqQMcqFY/RNz33zhQ+kRgi3/oSAB0S0IgJLrRgFl1xwHzRHL26Pi
         09Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801189; x=1794405989;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Otbpqb7SJFabxtkE4DZe7Wt61LA99tGboOBEZyTX8RM=;
        b=oZjfUd+dLk1/J8b+EIxIXVsIfj8UD7pKZ5EhDr3IL7ecGVRS7d7FynBSEDF1gZg81O
         rNNaHuLffbVtWkhTM3BFeMqo6uPmzVzaKxNrPoHS8t/27+c9+QbuY/ymKY/brBFRZZZj
         m+iRg9BrirpwlDAp+aHFXOrk+y1eadxQNaFJEhkinOCwzNs4J79CHsWzcsfl1vI+H/p1
         QaKPNVeNL08NtavPl3FHUlFklIhCrop8VNccNxJnCbf30B7mKktlMkdjP1GxwwiTM5g1
         xvoUBJydiX9sCLOutsQaCWVSY0kqNLpvg7S/yE7KjdsJfP0Pn14LDhj1Hu2f8BYKg+H1
         ipEw==
X-Forwarded-Encrypted: i=1; AKwUvBy+kLVDpjl8zJdwZy7Y8pDEkNcrJfjjQMH57OgaKlavmizHI3Ou6fAusHk+yhJqlku0CcduwIM=@lists.linux.dev
X-Gm-Message-State: APuU4Z/BpDCjSABJXkK+a6BoYTrUf6bqkz7JnnwVypcCX6lASQRdt9b/
	HDnj0j4QoFi8FKjUkV1wVa9TvKypjAIgtdgDcYAgTCBcRFqq4/PzArUQfvhdg1egFKA5Al7uktc
	W+YNVO6RdirXrzxkdg8nMEg==
X-Received: from wrbgf8.prod.google.com ([2002:a05:6000:27c8:b0:48e:267d:cb0b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:26c3:b0:490:c68e:5d5d with SMTP id ffacd0b85a97d-490c68e5e13mr937960f8f.49.1793801188873;
 Wed, 04 Nov 2026 06:06:28 -0800 (PST)
Date: Wed,  4 Nov 2026 14:06:11 +0000
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
Message-ID: <20261104140612.137869-5-vdonnefort@google.com>
Subject: [PATCH v2 4/5] KVM: arm64: Add guest_hvc hyp event
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Protected VMs issue HVCs that are fully handled by the hypervisor. This
makes a failure hard to debug solely based on host information. Create a
guest_hvc hypervisor event for hypervisor handled HVCs and log the
return value, stored in x0.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_hypevents.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 12 ++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 7486d95455c5..63d98dd92cb0 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -66,6 +66,19 @@ HYP_EVENT(selftest,
 	RE_PRINTK("id=%llu", __entry->id)
 );
 
+HYP_EVENT(guest_hvc,
+	HE_PROTO(u32 id, u64 x0),
+	HE_STRUCT(
+		he_field(u32, id)
+		he_field(u64, x0)
+	),
+	HE_ASSIGN(
+		__entry->id = id;
+		__entry->x0 = x0;
+	),
+	HE_PRINTK("id=0x%x x0=0x%llx", __entry->id, __entry->x0)
+);
+
 /*
  * trace_hyp_printk() has too many specificities to be declared with HYP_EVENT().
  * However, we can use a REMOTE_EVENT macro to automatically do the declaration
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fc0475f0877d..df7bd34325de 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/spectre.h>
 
 #include <nvhe/alloc.h>
@@ -1445,11 +1446,12 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
 	u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
+	u32 fn = smccc_get_function(vcpu);
 	bool handled = true;
 	u32 feature;
 	uuid_t uuid;
 
-	switch (smccc_get_function(vcpu)) {
+	switch (fn) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		/* Nothing to be handled by the host. Go back to the guest. */
 		val[0] = ARM_SMCCC_VERSION_1_1;
@@ -1542,10 +1544,16 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		pkvm_memunshare_call(val, vcpu);
 		break;
 	default:
-		return pkvm_handle_psci(hyp_vcpu);
+		handled = pkvm_handle_psci(hyp_vcpu);
+		goto out;
 	}
 
 	if (handled)
 		smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
+
+out:
+	if (handled)
+		trace_guest_hvc(fn, vcpu_get_reg(vcpu, 0));
+
 	return handled;
 }
-- 
2.56.0.455.g6c5a503b38-goog

