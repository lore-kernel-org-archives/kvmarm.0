Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747224;
	b=1b/ruyYIXsWeUdIS6xrdRjdEHJxg/0RcJEBVwfUW9LT30vQTNYDBqgl/h67IfohIB6Mt
	 509iJOwyBXmbn8fD/eWSC6kq6KbkhmrdwCspE6uoXt4oGQD8dYy5IzdU3+vkwlxS/8XzD
	 kcAQ6UWYV2CGA72uVVGue8HJWiziOdgJaokoBhmBoYeA9yA354UTGHAbjoSeknu0OGI7C
	 5a6sRp6FcVTPAhoHJZi323W9NMwqAxXH5zeoOrw9JrUXeU1kUhTBI1O+Fo66a0bpkC5Eh
	 7xFlFCu1fbJ9q0iEO/K3MRfwgjqS8KEEd0dgFG6HB9/OpjUDF7j0k4SSwyW1yO6fX4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=TyVyCwMLOPMh9qEM6xS4GkadPPOB007k35JPfKls6WQ=;
	b=jYTvIn973lMxbJ4DPlUbN+ODzm0Z+OkpfFEAAfAdDQkpEnKCCkF51WcXm8juwYJSDcdB
	 GKBjfUJLzXOIRBW115bJGwU7RlC+9rf4SAkU02dQ2KIMvL2EVFGDEkWXNwvivmkpbQq6n
	 JfL7Q+FTwf0+oj3ieqVCPmtWjbjyJHfPKPhVAYxPzvL2Fb3lKAaU6Da65daXvZgW3nF+C
	 IJaKrJ/W0hGRJEsX484xNHNQVm9wAyf452ROLh1wUSwt9WPxG5ET/Y2DcZodYBkq/gEu/
	 zHhyuA13qshjs3Ipq1SnrRqLPuG38d3Did3832XP1avFFgX4k3ioz11S9RXY9KYiw3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=hsjkeUKT;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7205C606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 09:20:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7205C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=hsjkeUKT
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a027f2e364so4685325e9.3
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 02:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792747223; x=1793352023; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TyVyCwMLOPMh9qEM6xS4GkadPPOB007k35JPfKls6WQ=;
        b=hsjkeUKT36AGTtOVcvyfoMvd9PbwJFz8NVy3Ou3zD0W19b7doRQbUjAMOktIBdtm7R
         Jzmqrr6XkDwopnFrN9BEo6tTeh9qIoFGfK2tZuDaSQ1sCv85Kmc/atKSHfLvZ5CF7Pv5
         u5SCBPc7GssU7cV+GuPq2bKBJeFL4JP5Tc5M2URsnc3TrnFKIzIqXK4aJT4d2x5rP+i2
         xPGhO2F8sfjeoEXXtbxUzkyIglIcH7MYHBdiQ0peC7XL3oxei2KHsNuQFvSgXHag7pL0
         +C+eHiodwdrKxoCGbz045v+F5fhRLKIF1crkH0etcbhKrjqPrVXpSYhnqxxu6FH4Bm7j
         +JIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792747223; x=1793352023;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TyVyCwMLOPMh9qEM6xS4GkadPPOB007k35JPfKls6WQ=;
        b=Lk3nVwljv9+nbQWyugZ17FXHifp2TuKEqRibSQg7fgCUB/mX5+3y5v9Di9PcJ+6K4t
         8rK/35osrZ/Qg+HQZRexYed7ZdEKRV7cigaD//ujWLB7Ee1EhUNAT+9lYoAw/0marvzr
         GVxZwkqjKtyMPqavzF9Hmk3P1dc0RxW1LL4fZZ/VRYQDL8XqI3/LBNjrQBNPAfdhmXXt
         ekF+4/FxUMo7aq9At3cckWt3Ovo7T0WRLtEwcXmYWkWBC8OnxcgpSWqOU61JHXnAABrm
         X7GD4fD4ncPXNjSD3zVizcZyBqw+vjxZdjc5xpflFmChZ2Zzyj/zuOfeP1gYgDCk89xX
         CW1Q==
X-Forwarded-Encrypted: i=1; AKwUvByPABY+Bm5EiXaE5B8jQppZo+v8kKeIaZHSrT+hAl+zt17wXf0V/4TTgXj1+wMSWsdI+lniY1w=@lists.linux.dev
X-Gm-Message-State: AFq9FYKxW3RPA13aOI3jlQCEW8Pb9lDLQTNldraQnJvC1qDT9hmBpQL1
	y0y/eaaglMDJ9Gvk5df9+QQFsjKLLwGv8SWSXLzynTxfGIVQftgHU80NMPQup2PGCIjzfI95Awq
	AbViBAkZnqu5j8i4F6CE9Fw==
X-Received: from wmbel10.prod.google.com ([2002:a05:600c:3e0a:b0:4a2:d93:4c05])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a00c:b0:4a2:fd2:985d with SMTP id 5b1f17b1804b1-4a211ce1b34mr25517785e9.12.1792747222747;
 Fri, 23 Oct 2026 02:20:22 -0700 (PDT)
Date: Fri, 23 Oct 2026 10:20:07 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261023092007.3918848-1-vdonnefort@google.com>
Subject: [PATCH v1] KVM: arm64: Use the host kvm_host_data for nr_event_counters
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

nr_event_counters is only used by the host to populate mdcr_el2.
However, host_data_ptr() for pKVM switches between the hypervisor copy
of kvm_host_data before it is deprivileged to the host copy after.

So kvm_init_host_debug_data() initialises nr_event_counters in the
hypervisor's kvm_host_data, while kvm_arm_setup_mdcr_el2() reads the
host copy which is 0. With a HPMN of 0, this stops programmable event
counters from counting a non-protected guest.

Always use the host copy for nr_event_counters.

Fixes: 2417218f2f23 ("KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index f4d7b12045e8..a00771339c62 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -44,7 +44,7 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 * to disable guest access to the profiling and trace buffers
 	 */
 	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
-					 *host_data_ptr(nr_event_counters));
+					 __this_cpu_read(kvm_host_data.nr_event_counters));
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
 				MDCR_EL2_TTRF |
@@ -80,8 +80,8 @@ void kvm_init_host_debug_data(void)
 								   ID_AA64DFR0_EL1_PMUVer_SHIFT);
 
 	if (pmuv3_implemented(pmuver))
-		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
-							      read_sysreg(pmcr_el0));
+		__this_cpu_write(kvm_host_data.nr_event_counters,
+				 FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0)));
 
 	*host_data_ptr(debug_brps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
 	*host_data_ptr(debug_wrps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);

base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.56.0.257.gf7497c7d27-goog

