Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9167022A7EF
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026710; cv=none; b=P+AJDkK1lc9VTtmPtT0FPG7hiSJG6797VTEXk6wwaXIC83hUm2OcS9wOg0VmPYzlz4lNz8ZbUCvsThu/07giYpVEBvyUob7P7DsE7+Hh6b/UiZ16IzvfLg7WFkavz0lwC8+BhKlUCZdxyeuCPTrcbhVesY2f2LNw50+8hQkiI9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026710; c=relaxed/simple;
	bh=RigQSl3gYtHUND7WnM8WqyROz8rALOea7rQDuWDs2Ew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p6Nw53whTgtjjExyg6He/+4A5eLIO4OszPlkRnstdB0kyLVPGSWDd2TzoLTtmxjOfaT5M/zVZwwjCSYjRGeSL9nmpCQwbjg2YqnR+8XNSPdDzQqptAyXEQ+/QUIZI5i5EdgrZICoJmSCaB/z4LO3MWljHUQgjf7c3zbYoLzcgfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bR+m2o/i; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bR+m2o/i"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-385e03f54d0so429499f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026707; x=1734631507; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kvcwClhLv6xGoczW4PJAIpjHHqg4M8M55H3dQR9JizI=;
        b=bR+m2o/iwYJkpa8AwrqOHS+m8N/tgwOhqZ2A2JoPcp9LmEtVZXGoClDXehaxVsfjiB
         lkwaoJSq8mgL0A1ztLbQTx+BHPD+X4zDzQcR+UHNq+CZ6NbEk7v/BrJUYF43wjRWTKvA
         LV0/nekXje5owzxz8rzLCPsq0U38T/Dydhhcl0UuBD3eXPULIP77N1ytOx5ipjsD8BIl
         i1xr33RHUI/2oIhBbJzr1ScDMYeQTpIKsaBgE9cdmjfhSg9qP7lVTlkrfVMpaXGK29Dp
         nI6ew5z+HN0XgYhrwaKcdJZOVyPLdlT3fF0+DMa4OmJLLi8JG9x/EuFLy0/Tt58Powoe
         geTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026707; x=1734631507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kvcwClhLv6xGoczW4PJAIpjHHqg4M8M55H3dQR9JizI=;
        b=SIBBLN8dLgnsaFYhj9fljVhT+ZDPhFK1ieUarlYtc2cKcMaD9VNTJifkh8HF39n6n5
         ZGKQtlxmljv9JOrdGod1bbASv1bp3U+31CNzSYaPkC/t+Ix/WHX37hbM8HM0nMXgWDnw
         +BdEWR0SmzSmEkmTZM30W7WDKwm7YXVyZOE05N4SrGuqpRLtR8ZlSR5B9/aEjvx0OtrS
         F4yuXabirqi51vgZnpMg6VcWlXct0ksU9UgQNWhCX9nksoUnyByqG7jJZQKy0Zq1Z2/S
         MhO81wgEx0OKRcgkiw4Vn/Ly4m8Aq30yBiPGbi1hARBtqVwqjzx+HpeGD3xLVB32PUXy
         ycKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZBhyQPbtjLEBlBve0N+dPE4YLLYpePwuBRbNVFiZdDS8dGF1DKtXUbChdmWfamm5/b1yf+PQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXRPSPY0nsO1c/cFvgYB5f1qrUabL9PL8RvozyrepZLu6Fhpcx
	TXsg9SPMr3cKFH/lhnF456SD6zjOXU1j43/Un7CIszP+j2wC0wdYMsNX9rgC2CNtcSevlAJaQTT
	IaIfID7X4IQ==
X-Google-Smtp-Source: AGHT+IE10scUEuEcCRD+5w6H2L6RFmN8j1xObFtBxLC8p2WLtJlxovv9B58XfdIQzXv891vozkqFrRDj+yh8bw==
X-Received: from wrvj17.prod.google.com ([2002:a05:6000:1bd1:b0:386:3835:9fda])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:280d:b0:385:ec89:2f07 with SMTP id ffacd0b85a97d-3864cea56c5mr4112209f8f.32.1734026707185;
 Thu, 12 Dec 2024 10:05:07 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:35 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-12-smostafa@google.com>
Subject: [RFC PATCH v2 11/58] KVM: arm64: pkvm: Add pkvm_udelay()
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Add a simple delay loop for drivers.

This could use more work. It should be possible to insert a wfe and save
power, but I haven't studied whether it is safe to do so with the host
in control of the event stream. The SMMU driver will use wfe anyway for
frequent waits (provided the implementation can send command queue
events).

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 ++
 arch/arm64/kvm/hyp/nvhe/setup.c        |  4 +++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c     | 42 ++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 3b515ce4c433..8a5554615e40 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -143,4 +143,7 @@ int pkvm_load_pvmfw_pages(struct pkvm_hyp_vm *vm, u64 ipa, phys_addr_t phys,
 			  u64 size);
 void pkvm_poison_pvmfw_pages(void);
 
+int pkvm_timer_init(void);
+void pkvm_udelay(unsigned long usecs);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 46dd68161979..9d09f5f471b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -356,6 +356,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = pkvm_timer_init();
+	if (ret)
+		goto out;
+
 	ret = fix_host_ownership();
 	if (ret)
 		goto out;
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 3aaab20ae5b4..732beb5fe24b 100644
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
@@ -60,3 +64,41 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 
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
+#define pkvm_time_us_to_ticks(us) ((u64)(us) * timer_freq / SEC_TO_US)
+
+void pkvm_udelay(unsigned long usecs)
+{
+	u64 ticks = pkvm_time_us_to_ticks(usecs);
+	u64 start = pkvm_ticks_get();
+
+	while (true) {
+		u64 cur = pkvm_ticks_get();
+
+		if ((cur - start) >= ticks || cur < start)
+			break;
+		/* TODO wfe */
+		cpu_relax();
+	}
+}
-- 
2.47.0.338.g60cca15819-goog

