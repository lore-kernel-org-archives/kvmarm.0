Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E32313283
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405312; cv=none; b=Yh6ABOqtGg9DWQc1dopArxO1/Pf+Mj+oPCeNwJV8Ot/S64K0XaddrJBZV7V8CGqOOnSqBdDhcYJHUsgKbmOEC9aamgrqIL5Ddy8Jqlf03bB8zeEZuivj9+3QHbSZ7zugzzRoqgAt2ps56nsWUV9FJ5uAzngAlA0RdGPSHNw/opI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405312; c=relaxed/simple;
	bh=S/1TCoG4iWrrYeaePo4/lgi9pJbViEDsshc6JJsQ2aA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZdcRn0colQ7JbCwNO74Et1wmJlUo7m+LfDehxL7seL1xnO6GMc1BKqi5s9ztoLE9GXUUyXJnG9VJhk5kHMhFyVLRrGYvziQiKy82bM1zZLVlj9WBQp4jYpZx3Ad1zAB4d4ys0n5RlvGR+NaBO4L8RpbyUl0mM561rrTCnn5xqSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R8znOBTH; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R8znOBTH"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779981523fso18860375e9.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405308; x=1764010108; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mdiIv9AzHH9LJUmk1x5XNuh2D17ItySFVQ+lpR2xjRw=;
        b=R8znOBTHKf9o693eEFoJDSXvyAd1y5y2yAs5g/u8a/OXaC/QUY7KSgbCwcFfz74QMh
         R7IMS20gB8A23N+Hfwi3S8c79n6NTpzQUqhqQVnrma11uuVwMZOY6+qDDHDhlZX5F4I1
         UlhuL0DLUlCIYVM0kvBIUDPrvFz9HlqZnjXdVtuVSC2n0YYAzaZb9OXv5z+IE+/aEwHb
         sYWNaZzNquBqk4h8/OJ91S7gxK2XcjBQIwV8FA7SBGenmGziLZMidruQYTAd6ciyZxpT
         JbEQ4CzcgJ4b2gSwxuc+qMDy6lvVDXKYBH8OViu2+RKzWHtH1WZ9EYWYuYfNb7YJW9Zm
         94qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405308; x=1764010108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mdiIv9AzHH9LJUmk1x5XNuh2D17ItySFVQ+lpR2xjRw=;
        b=O6SZtlZsu7fa8sAxHkmLQZeVY1Az6S8XVnBiypotbuLGUJ7B+XKVDYXivl6bTwgbmJ
         fkD3g3joMtf4mnXbZxJoDcOWCfE4YYLjf6R5IqoDbGt41AVh3lnMw/UsPLC8855gt2If
         KbTfKeLompPMAGU+ijXoqhLJ4FiGlhPJwIz5Ch/n8A4bXl2sDo/JnBu/HKWpZl6Wx1V3
         ys/Ruvu3wGDLHlrr6eXmOkxZNUmgTMcCjud92QqqfulgwuJV/9BfeMlmXldtcUndjjpc
         Zqk7F11BEys+/oYwfndNIW5JLUieu6Q39qwniRK4rw5r4ZtzPqbSKAx+j7FDwwgV5Z9f
         PjnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXV8xwiDCjoLZi+H5awP5z8h/v8gjIVr78EGYxXBjaAr4a1R4bkTAXQAS8JJTtKM5jGoOeZQt4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGDreAlL0+uNFkEOwnflk0BxZEypDBx61rxn/dfNOC26TlnFZO
	lkleOe6Zx04wDwWjSgdF6aNEbWEhk2wk/T0cANor6uDV/hDGKw/S7RQZ0JtsgYy7W2KoWmdZJGB
	3vn9eYvrlI1LWBQ==
X-Google-Smtp-Source: AGHT+IEIO6NZXXPWg9+hR4+SPtTpCKpBv3Ky3OdW45sXPemfU0CwllktSYR7niEb66Ks+RCqsCJfiR5agNLU5w==
X-Received: from wmbgx23.prod.google.com ([2002:a05:600c:8597:b0:477:a0a1:eae8])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b4b:b0:477:639d:bca2 with SMTP id 5b1f17b1804b1-4778fe51eb3mr117363365e9.4.1763405308662;
 Mon, 17 Nov 2025 10:48:28 -0800 (PST)
Date: Mon, 17 Nov 2025 18:47:50 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-4-smostafa@google.com>
Subject: [PATCH v5 03/27] KVM: arm64: pkvm: Add pkvm_time_get()
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a function to return time in us.

This can be used from IOMMU drivers while waiting for conditions as
for SMMUv3 TLB invalidation waiting for sync.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/setup.c        |  4 ++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c     | 32 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 184ad7a39950..2b065e048a35 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -89,4 +89,6 @@ bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
 
+int pkvm_timer_init(void);
+u64 pkvm_time_get(void);
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 90bd014e952f..eff76be89329 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -312,6 +312,10 @@ void __noreturn __pkvm_init_finalise(void)
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
index ff176f4ce7de..ce91719c876d 100644
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
@@ -68,3 +72,31 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 
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
+
+	/*
+	 * KVM will not initialize if FW didn't set cntfrq_el0, that is already
+	 * part of the boot protocol.
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
2.52.0.rc1.455.g30608eb744-goog

