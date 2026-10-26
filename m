Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793032793;
	b=bz60DbiaTp7zKDZZ/UKkTJ7fe4v+JDBk1VdIbFGAqA9CELaqszz/7R21Is4xCGxF9YbF
	 Up0TG3HBk8ECraao0KH7L7LPLdCzNUrYNZbi6LCbY9QOL/OS/34PvsdgOd78qMZjX4qeJ
	 0tgoEfTAoRaZmCTQ00y4gUMcSKQcokuZx78JDo73TTpUCgNpISYbx5HbGTvXotGa2aly3
	 bESwMyWaIekfC98+7thax/2HQYck510oisvbIrKSr1zZgNxNxrJn5XM8Cfp+9FvftZUMA
	 PgCDfkkvE6lWx5br3SEJ0vuIazVf0SMXs/Npm8/p2Wt8xiyfwRXCGNSJ5KgEUCEGPcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793032793;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=poQqnkjlBPuX9RdULowmTFcXX7UXKmqTRfjOTQXFTR8=;
	b=zUlM79wTtVjiqFGGkJsQ+nut6ix2ryTlMpqVsv51+iw5guzSQ/WiOihqAfou4nIa4/wN
	 bqjvbFJmFleax+LL5SkidEFJWNqA2TyVHXwIkYJG4U05HW9VAy5bBuHPmvNi/Q4WL+a9A
	 eWRDMVxzru3x/tKhgoHqQ7cWUsV4SEoi/MGmaJSasnm6nem2re9MyHI7L1ijDqtG7hNLM
	 /Wr4NrbDqZISMmc5ICckGKjjC6eWlWGqr3NVtBZ1djACMxAQIl4tDQ+h6Qy11zIUHHkJG
	 FJWFht99FZDHZfKoryvl9GdBwDFyjfIARdL9E162gcKdCvRO30Kz8yUOs/4sEmk/Ivg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=BkAScwhF;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C150D606A31E
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 16:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C150D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=BkAScwhF
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a028616bebso25710435e9.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 09:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793032791; x=1793637591; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=poQqnkjlBPuX9RdULowmTFcXX7UXKmqTRfjOTQXFTR8=;
        b=BkAScwhF8PbMze8ZauGG4hPh+VpsiNkobvqzbVDnOG4tfHubikwXQ7j4WhxCgG1sz3
         5WrYOc8sNjIdD/IsneSQoSDyZkeVgFopJl11q1EigZ8zFLfx4Dnv1F0yz8sRGck1tNZC
         xrc/U6KiLjGW8VBSDIKvArUMxIAjL3fstQXW7LltnG43p3Y4gfUHFja2rMfXNnW4U6NE
         hQRqGpz8WN/U/8P69HGY8nwxOJR+Wm0NczBQoHu5bnvazhmZnn5ueylu7igANZWEaMsH
         kRzAn+lpH5ZA00szIfzOtxvPtf0ryN+btXcD0pc2IAcxfgXNGBtZn1HdKG3uWY/SyJ7F
         721Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793032791; x=1793637591;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=poQqnkjlBPuX9RdULowmTFcXX7UXKmqTRfjOTQXFTR8=;
        b=a55Zwt+V+jU5QZe+WQ2FwW5YMUqfUoL3yQ7gl+gAp7+sYUYrPlGsHvBMV6w7eKtcin
         D67eA6rSlp/8yLWqpVEqkveELoU2lovt174jD1XVtjny5IuHpu7y1mWpYGnVEG1RGyAX
         6ZgxE+kiLeXR1pvDJuFvYwuzQ+WbP8ALf5AhEsLG/GLM6rYDtVBUZzGz0JMrT8EBWwEN
         SKFrMnT7z38N+VguHCNOLIQY3MMXGhYTCu3mj6eD59PVoEhN2ycRPVNkvZacLkZKR1AS
         R8QZLFtxeyqZadGmAlRwAT8PauW8AGFqurLgbtIXUk3PPqQRrrO6q8O+4Oljs+QEOFmy
         161w==
X-Forwarded-Encrypted: i=1; AKwUvBwCCLsN8dQglw/JdExM7fHsDTc8g6wCfswDbus4jjZE+9skxozaA7PKD8TcZta/A+USiQ+Bo6Y=@lists.linux.dev
X-Gm-Message-State: AFq9FYJilDC2cxmz2v0RVmaKnI9kM94fl6IU/t3XgU2o7ylrQcRZZ9sx
	dBenRrBKkyxZBcDNoQTxP5+OZimQdsIFbNadVdWh6D9JFWC+r3GHBaDdAAVkbPRdgx/XkLGJ039
	jds5cMs5grZ9GKCZgqyuW/w==
X-Received: from wmbhi16.prod.google.com ([2002:a05:600c:5350:b0:4a1:f1e1:c6d6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:e547:20b0:4a6:b49f:9ae5 with SMTP id 5b1f17b1804b1-4a6b49f9e0bmr33320305e9.34.1793032790938;
 Mon, 26 Oct 2026 09:39:50 -0700 (PDT)
Date: Mon, 26 Oct 2026 16:39:36 +0000
In-Reply-To: <20261026163937.963087-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261026163937.963087-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261026163937.963087-3-vdonnefort@google.com>
Subject: [PATCH v3 2/3] KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
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

If left uninitialised, those registers may inject spurious interrupts or
worse, if EOI is set, livelock the vCPU, since no one is in position to
clear it.

First, return the error of __hyp_reset_vectors(). On an error, we know
the hypervisor doesn't allow a reset. Only re-init what the host has
access to, no matter the KVM configuration, which is the vGIC LRs.

Then, cpu_hyp_init() is only called from init_subsystems() and
kvm_arch_enable_virtualization_cpu(). Remove the kvm_hyp_initialized
gate. It is possible because when pKVM is enabled, a CPU may already be
initialised but then cpu_hyp_reset() simply returns an error, so we know
we can skip the full init, while for the other modes, we know for sure
it is never initialised when it hits this path.

Finally, enable the PM notifiers for pKVM, it is now safe to do so. It
will ensure the host properly configures the vGIC LRs regardless of the
KVM configuration.

Fixes: fa8c3d65538a ("KVM: arm64: Keep nVHE EL2 vector installed")
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/virt.h |  2 +-
 arch/arm64/kvm/arm.c          | 50 +++++++++++++++++++----------------
 2 files changed, 28 insertions(+), 24 deletions(-)

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
index 0576c2022ef5..dca6b7a43e92 100644
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
@@ -2300,32 +2302,38 @@ static void cpu_hyp_init_features(void)
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
+	} else if (WARN_ON(!__this_cpu_read(kvm_hyp_initialized))) {
+		return;
+	}
+
+	/*
+	 * Even if the hypervisor didn't allow resetting the vectors we can
+	 * reset the LRs.
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
@@ -2353,8 +2361,7 @@ void kvm_arch_disable_virtualization_cpu(void)
 	kvm_timer_cpu_down();
 	kvm_vgic_cpu_down();
 
-	if (!is_protected_kvm_enabled())
-		cpu_hyp_uninit(NULL);
+	cpu_hyp_uninit(NULL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -2397,13 +2404,11 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
 
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
@@ -2526,8 +2531,7 @@ static int __init init_subsystems(void)
 	if (err)
 		hyp_cpu_pm_exit();
 
-	if (err || !is_protected_kvm_enabled())
-		on_each_cpu(cpu_hyp_uninit, NULL, 1);
+	on_each_cpu(cpu_hyp_uninit, NULL, 1);
 
 	return err;
 }
-- 
2.56.0.257.gf7497c7d27-goog

