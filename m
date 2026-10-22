Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792677734;
	b=mZpv84TXBKbfHBKwcwiUOKLbPggRL/GybFF/OEGnzTpSfGMeBB1NtTPp8D203hMW6/z8
	 O5/TsOKaUkLIiCgO5IkUKv3rQCrAXzJBj581uQfv1Hz9DJxcgzrXsQ4aPrcUALQgml5pc
	 cOf374htkRHqLZ/OkKYllGgMEBNdPntDdcF5zR5ZYyyzEp17Q4+uRdM5dXqHHS3BgD+Y7
	 ARsPWhUN0OYKsHCV1i3R7tTT4S9LKXjSLHaBhjsGmC/8HbY/5ND7YnsngUVD/2DZ7dCJl
	 oyyqBilRzHcJTgUZ5lwYFnY+qUJCJhlO5t8jvSJ/eFiPeAqMcBgvRO1tifTc9uPx+Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792677734;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=hfltIMqe1DPYXUB6u6RGh5+LsUMaEBkzsWt9Y8g2MJ0=;
	b=FgxMrDq0e58l2ZilHGx3F/kRNYMlX3RGEs+QmYicGp5OC0Ua75iGZE+dR6GRAy/zoNUp
	 1Xnms0LbTm+Kn+kWE4r8UrIWpz/OcJ/iFnzbp7R2vifQuYshXNvN1HS0DeubdDQM/n5kk
	 ghmZ+7vVM8IMZk0utev+k9FEcsqKeeoeTa1bq1Xdn1DiqCcsisZUTKvldTdY9IyRvmuyk
	 JAyTmHWvg1bh3KKXFUMapS+dYRXgu7qQ7FQKgzADeuF0zVq/O4xwBJepsZ2jPbt3IJW12
	 HLqgQyaWV+dC56z7w5+/EEJZVBgk7effRDMzBbUYEMOM2DX41MYBTee3u+31POJxxaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=B1aiLpfN;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4105606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 14:02:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4105606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=B1aiLpfN
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a1e295b702so18679255e9.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 07:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792677732; x=1793282532; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hfltIMqe1DPYXUB6u6RGh5+LsUMaEBkzsWt9Y8g2MJ0=;
        b=B1aiLpfNJydtgmOY5Wwh+cH/WU8DVz60+EAjv04GwewfCzpEARoqMTi+SlwqHnokcX
         pm8hTyNM0RSC8PsVbBcol/6q8IY/eDg5TxIRuK4kotDVu6xG9xuSVTkPJgJvxIk6s56x
         Eu6BpZ/BhxIq64nYLAPFN/N3EDWUuWGemD1tEi8Rp4cnr8wc0Tie1Ltz8xVLyaFCA+bF
         h/tlcSCY/0vzpb8wBoRIyHPkI+WHGan69CyJ3bymiJzGYA61CMDUnhKEPIHSXbFuA3ck
         7TSe0XQETUni1Yr3vLImk6OvgGSvCn7y4W69Vr+Sl8mNh8kf3u094kdheXjKJzUNaSPI
         lyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792677732; x=1793282532;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hfltIMqe1DPYXUB6u6RGh5+LsUMaEBkzsWt9Y8g2MJ0=;
        b=eSakDiWG7lO3pk7WOHgRsdKcCuqJaXD3lWCR3VHoRFtgyLcuXRvqMcKUIBz3UpyCMH
         vqTKgclbCszp1E/TYxjlWOtu0NNR5UWDd/AfyjwkI7Yho8Ne2kh3zp6RAWzXZ3Pa1EqB
         xieM0lqyo8Erj2Qnu4z8OhTUSB47WCL2pAVWJniUEpPvvHmJkS7SN/XleH7M2/uAgpx/
         ZPofhHfzYZnRF4jtoP0Qm7UXzqfxpEpVQSnjdIQDM+t1OmFfnuo1dEbaUXT9hmajbFgm
         J0SyzlAfX+4TDAQdfQZNkpsRJixIWvFouTuR2p3+7RP/u3GZB0KwZHD5Vq8l4BzCDqsy
         nnVw==
X-Forwarded-Encrypted: i=1; AKwUvByjrdPU1dP0dthmAVSUpmSE79zKb2PYkIhSbbExj4vPHtyQGxsqigQVtmr9jrtmY5NU+2hCdjw=@lists.linux.dev
X-Gm-Message-State: AFq9FYKwBCQUwXuApoyMJrJhucoEKtHdeCkn4E6OFAPi4NvS23KqWpG9
	v3IAEZVzG6EQTZj6PFLZPD//OmwQw6zNx6M60fJ8drBkFzDHTc0yvRr6f/VV3ZfINc723hxil08
	5oDnF/xUTWErSimuGihIS1A==
X-Received: from wroa12.prod.google.com ([2002:adf:ed0c:0:b0:48d:ef8e:e575])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc8:b0:4a1:bd69:526f with SMTP id 5b1f17b1804b1-4a1fd8a7d9dmr118418955e9.4.1792677732158;
 Thu, 22 Oct 2026 07:02:12 -0700 (PDT)
Date: Thu, 22 Oct 2026 15:00:46 +0100
In-Reply-To: <20261022140048.2522787-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261022140048.2522787-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022140048.2522787-3-vdonnefort@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The vGIC LRs are architecturally UNKNOWN when the CPU boots or resumes.
However, in protected mode, only the used ones are reset, because the
HVC __vgic_v3_init_lrs() is never called:

  * During boot, vgic_present is only set in init_subsystems(), after
    cpu_hyp_init() was called.

  * During CPU hotplug, kvm_arch_enable_virtualization_cpu() never calls
    it either because kvm_hyp_initialized is always set.

  * During CPU resume, no notifier is registered for pKVM.

First, return the error of __hyp_reset_vectors(). On an error, we know
the hypervisor doesn't allow a reset. Only re-init what the host has
access to, no matter the KVM configuration, which is the vGIC LRs.

Then, cpu_hyp_init() is only called from init_subsystems and
kvm_arch_enable_virtualization_cpu(). Remove the kvm_hyp_initialized
gate: when pKVM is enabled, the cpu_hyp_reset() will just return an
error while for other modes, we already know kvm_hyp_initialized is
false at this point.

Finally, enable the PM notifiers for pKVM, it is now safe to do so. It
will ensure the host properly configures the vGIC LRs regardless of the
KVM configuration.

Fixes: fa8c3d65538a ("KVM: arm64: Keep nVHE EL2 vector installed")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/virt.h |  2 +-
 arch/arm64/kvm/arm.c          | 51 +++++++++++++++++++----------------
 2 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index b546703c3ab9..a5bde8cc5df5 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -83,7 +83,7 @@ extern u32 __boot_cpu_mode[2];
 #define ARM64_VECTOR_TABLE_LEN	SZ_2K
 
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
-void __hyp_reset_vectors(void);
+int __hyp_reset_vectors(void);
 bool is_kvm_arm_initialised(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0576c2022ef5..4c4e2fb7b660 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2246,10 +2246,12 @@ static void cpu_init_hyp_mode(void)
 	}
 }
 
-static void cpu_hyp_reset(void)
+static int cpu_hyp_reset(void)
 {
 	if (!is_kernel_in_hyp_mode())
-		__hyp_reset_vectors();
+		return __hyp_reset_vectors() ? -EPERM : 0;
+
+	return 0;
 }
 
 /*
@@ -2300,32 +2302,39 @@ static void cpu_hyp_init_features(void)
 		kvm_timer_init_vhe();
 		kvm_debug_init_vhe();
 	}
-
-	if (vgic_present)
-		kvm_vgic_init_cpu_hardware();
 }
 
 static void cpu_hyp_reinit(void)
 {
-	cpu_hyp_reset();
-	cpu_hyp_init_context();
-	cpu_hyp_init_features();
+	if (!cpu_hyp_reset()) {
+		cpu_hyp_init_context();
+		cpu_hyp_init_features();
+	} else {
+		if (WARN_ON(!__this_cpu_read(kvm_hyp_initialized)))
+			return;
+	}
+
+	/*
+	 * Even if the hypervisor didn't allow resetting the vectors we can
+	 * reset what we have access to.
+	 */
+	if (vgic_present)
+		kvm_vgic_init_cpu_hardware();
 }
 
 static void cpu_hyp_init(void *discard)
 {
-	if (!__this_cpu_read(kvm_hyp_initialized)) {
-		cpu_hyp_reinit();
-		__this_cpu_write(kvm_hyp_initialized, 1);
-	}
+	cpu_hyp_reinit();
+	__this_cpu_write(kvm_hyp_initialized, 1);
 }
 
 static void cpu_hyp_uninit(void *discard)
 {
-	if (!is_protected_kvm_enabled() && __this_cpu_read(kvm_hyp_initialized)) {
-		cpu_hyp_reset();
+	if (!__this_cpu_read(kvm_hyp_initialized))
+		return;
+
+	if (!cpu_hyp_reset())
 		__this_cpu_write(kvm_hyp_initialized, 0);
-	}
 }
 
 int kvm_arch_enable_virtualization_cpu(void)
@@ -2353,8 +2362,7 @@ void kvm_arch_disable_virtualization_cpu(void)
 	kvm_timer_cpu_down();
 	kvm_vgic_cpu_down();
 
-	if (!is_protected_kvm_enabled())
-		cpu_hyp_uninit(NULL);
+	cpu_hyp_uninit(NULL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -2397,13 +2405,11 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
 
 static void __init hyp_cpu_pm_init(void)
 {
-	if (!is_protected_kvm_enabled())
-		cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
+	cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
 }
 static void __init hyp_cpu_pm_exit(void)
 {
-	if (!is_protected_kvm_enabled())
-		cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
+	cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
 }
 #else
 static inline void __init hyp_cpu_pm_init(void)
@@ -2526,8 +2532,7 @@ static int __init init_subsystems(void)
 	if (err)
 		hyp_cpu_pm_exit();
 
-	if (err || !is_protected_kvm_enabled())
-		on_each_cpu(cpu_hyp_uninit, NULL, 1);
+	on_each_cpu(cpu_hyp_uninit, NULL, 1);
 
 	return err;
 }
-- 
2.56.0.257.gf7497c7d27-goog

