Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258C1275864
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725216; cv=none; b=PZUtbwbZY6DyMAOZr6YKXFWw8D/hKHAARNCVZaEjYMw++3Q1+2EjhZ4i6IlAUqr8Z2j6GxE7f+Tst4q6qzh3ExRiXiOKEtzKxxPBEijDverAvEcxSSqLh6qAj5RYAvwHG/Z8IiaZIHCnfbuGPS+VubM2hgHBYWpekWab5bUVHmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725216; c=relaxed/simple;
	bh=nRn9Dsf3QfyBnEBl4Hr7BBBiduTa1EIYJ+DzHW4mP0E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UY9oA0tJtFrW3Gzupo5gdYJx3LmdKX5/KZJDcMVaw1W05LGq1LYoTzTmha6Du8V5uCzYRSEo3bp5suzadXGzEY0wsajhXitu0XQSJmrQfCIinGqZxhTa7A59iClRNBIOiFG3bChR5f9J0QO+Dwtcm9/1z8qpUHz6dbLks9QPbJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZjzUNSUE; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZjzUNSUE"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4fabcafecso1884615f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725213; x=1754330013; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UBRRf2ok05qV4V10RyprFxOV/7isNWPsP0/960vxN5o=;
        b=ZjzUNSUELLJYwwejcJB9JtEoU0EIaAigohaBACm2hO3FkMRwxBw4G5DQseBlXyzVY5
         nLCtfupONT4xtcgQ8nDEHILNo/zhkwuaHeKnzXc5i+spbg6rzEKvnbDiVOnApTh6SvnH
         eyw/qKpxyEW+myIjn/to8pBiMku9Djsvuln3tlc1uBjt5D/z4dxypr+naE4zYk3i7PuX
         9InLrRmW73yRv38dsoXRsF6VemjL6xMmH+oebe/nq8t4p5vdMJ7a9hQCv+EG8SU4n0/u
         foVl+FrfFCIqkwVFCQ158XOtTaL6+n09NJ6yRHhebdXF0HMMwwr+6T03U5XcmdjN0aWG
         Kjyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725213; x=1754330013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UBRRf2ok05qV4V10RyprFxOV/7isNWPsP0/960vxN5o=;
        b=ctrx+fxM2KusjGhth60NEVMs7WSg7Q22Fb9dF8/qpZOJTjgfFdAAOHiquC8+R/hbyf
         usCyLKzrWh+lif2JsEyqIaDVdNUQ8fYAARZ+uygQS7OiXo6+uP9D8Syd1JVtBWx7Wz+W
         rKusRZKp36BPHq9A/eOU2xA6A40E8iGalF/iWDVlfrS82CgpdnSkekbhdEDQR9XLUWIH
         tI2ERZ1seHVX8+BSC8WArdtmLKbxaxO6cwGiqvEQ6IQIFCvaT18MtoNsGy02pmND4i7t
         dVSp9bcVr4ac8DQ3KNOoaZs9AxMGYvLDb7fzJ/jV7ACAEZIe+mvfm7QfZl8dWV6FnF8G
         k+/A==
X-Forwarded-Encrypted: i=1; AJvYcCVC3qMN/hSooAQ8PoreIovEwRNFDJOzJA06yCRqCLHtpZ0vZa29gCTdjoqdLu5XXAqt7j6SpCg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz10bD1ufvH951KxZMo3wM8I+mIoMxk47EA6brfCum4z6jsbXPA
	5RmKBd0bJp5hxOAelWXyGXOs/cfM2q76o1mYOtKS49m9PPXk7eTVPonNXZNPO3cHis3KGzQ02ET
	hgg4BBsnum45czw==
X-Google-Smtp-Source: AGHT+IEdo5UmQraGXTZJ9gCaHcWtxJIv/tFc5vNP8HwnzGiRANkg0buplE/XnYHC6sojxb0f1IZVCz/ntN1JZg==
X-Received: from wmbji2.prod.google.com ([2002:a05:600c:a342:b0:456:214c:845d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:290d:b0:3b5:f93a:bcc with SMTP id ffacd0b85a97d-3b77675be5amr9578336f8f.35.1753725213520;
 Mon, 28 Jul 2025 10:53:33 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:52:50 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-4-smostafa@google.com>
Subject: [PATCH v3 03/29] KVM: arm64: pkvm: Add pkvm_time_get()
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a function to return time in us.

This can be used from IOMMU drivers while waiting for conditions as
for SMMUv3 TLB invalidation waiting for sync.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/setup.c        |  4 ++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c     | 33 ++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index ce31d3b73603..6c19691720cd 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -87,4 +87,6 @@ bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
 
+int pkvm_timer_init(void);
+u64 pkvm_time_get(void);
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index a48d3f5a5afb..ee6435473204 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -304,6 +304,10 @@ void __noreturn __pkvm_init_finalise(void)
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
+	ret = pkvm_timer_init();
+	if (ret)
+		goto out;
+
 	ret = fix_host_ownership();
 	if (ret)
 		goto out;
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index ff176f4ce7de..e166cd5a56b8 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -11,6 +11,10 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/pkvm.h>
+
+static u32 timer_freq;
+
 void __kvm_timer_set_cntvoff(u64 cntvoff)
 {
 	write_sysreg(cntvoff, cntvoff_el2);
@@ -68,3 +72,32 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 
 	sysreg_clear_set(cnthctl_el2, clr, set);
 }
+
+static u64 pkvm_ticks_get(void)
+{
+	return __arch_counter_get_cntvct();
+}
+
+#define SEC_TO_US 1000000
+
+int pkvm_timer_init(void)
+{
+	timer_freq = read_sysreg(cntfrq_el0);
+	/*
+	 * TODO: The highest privileged level is supposed to initialize this
+	 * register. But on some systems (which?), this information is only
+	 * contained in the device-tree, so we'll need to find it out some other
+	 * way.
+	 */
+	if (!timer_freq || timer_freq < SEC_TO_US)
+		return -ENODEV;
+	return 0;
+}
+
+#define pkvm_time_ticks_to_us(ticks) ((u64)(ticks) * SEC_TO_US / timer_freq)
+
+/* Return time in us. */
+u64 pkvm_time_get(void)
+{
+	return pkvm_time_ticks_to_us(pkvm_ticks_get());
+}
-- 
2.50.1.552.g942d659e1b-goog

