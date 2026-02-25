Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A5D3B5314
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041118; cv=none; b=aPUZtUUHsgl0EpNY0/yus+hyx14KxIEA9UgzlZvgdA4v+NXJ4U+MFME+v3Y6k0b9uocq7kV5c4II/gyIxfWTdjk+QCq5A9idpi6KHyyWnfL9cY/yLmgXPtVec+FtqzQAzKUuGMF9k0aq/wXhktON6nTWTZMiGnh1FmnV+Ly6X4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041118; c=relaxed/simple;
	bh=R/R3DcLkOIdIezNwV80BfBol7Z25b9yKegEl4ZzQ0N0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nPcdeT6r7GO1RluE7nxTlFghEkcCyy7txG9NVlEUU3tiwKiRyJTUlO4hgUBHcGNxWELaVfDstuW5+AYSNDcouYVB60P0PzX9Ag2RfJgoOzxvNQ2FLD9lWvYYrIDJ1E8ohr3mSOkbulY7Psp3SuSimkfBHVwtc4qHUIP6xBXvtAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cuq+Gfkl; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cuq+Gfkl"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7d1950b48f3so76601919a34.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 09:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772041115; x=1772645915; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FxE+A5J4HGPNO2s3hfVFIukZ/uILKNBM11tjPpp3P/Y=;
        b=Cuq+GfklBKMyVfSPEtXYJAAb7i4Zd3PbzEGrZrBz9DSUsRb1DMq7tNdseNHJL0kxXR
         4m58LAZP8yF6bKhi12fFKjx/H5cFXvmd67nxbaJHWLEuk2iNfTwyyoVHxXe/diLU9sNV
         8+q09Hc6SrsHyC6Xnn/AcZPFELvvRXCDPKshM6KSq8hYE0D/Ri1HDlBbLvwvNdw8Pu22
         8m+2msZfSv7n0DWEewIbfHxs3v2FPj9xV4JX6KRYQuWF2ewPGaw4v3acFQjfhUy6iho4
         wDXVBfFJ9A/cyaZ/lvOnjoOZBz5+K/N70KRDnuHUqg944c7kaEAnKJwwecrAKjF/MRyx
         YcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772041115; x=1772645915;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FxE+A5J4HGPNO2s3hfVFIukZ/uILKNBM11tjPpp3P/Y=;
        b=tLkoujByVGuiHgN0XhINNuhlfdfwdnM5LpHKLowgRUyA9NuiLeqXymd5jxDG1TcZs6
         I93f+B23AdH1LSXnIxEI0whPscNk4jEHOA+EfMBu8eJzxk9IR1eSnwp+whs614D2bjdF
         zfhsZpJWBaC4VLaYzB7IhfRoNzFGhtjF2Z7w0jmmhHmyZk/dEMAoUyi7fLr2iTo83eCy
         upQ9LKKkDW7lMtCy/B+l4lmkqbubOdWvdLsAkIw1AzXpCz5vag4vgatlaNuMes+4zhyd
         Huc6o5d08FMnyxJsYyY3mOrrE0cACEhKl8PjNFr77uH2c2hDVnnGP4qY6xCjJNVov6d0
         qa1w==
X-Forwarded-Encrypted: i=1; AJvYcCVndR0UVmuykONeOGPaQiVqgpeJ0Be3LpqTWF03k4C23l1ysmTz6v6jKesQ1FOiWtBDMZwCzWc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzdb4M5xd/51DlwRbd6jWOKRA9GSMUX8NclT0nxKRG80n+bR7gz
	WBznnpKOWXLl3AAY4n7rL+ayCZCmReiUGKbXW8KDultgwjZY9gPfIKA11WRMYDeJXmAI0N4Zgur
	Hzg/DbWgTeIJK9SJuQXYf/03QDw==
X-Received: from ilbcf6.prod.google.com ([2002:a05:6e02:2306:b0:447:81b5:ae34])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a4a:b68a:0:b0:679:dcd7:fbe6 with SMTP id 006d021491bc7-679dcd80797mr3115611eaf.31.1772041114890;
 Wed, 25 Feb 2026 09:38:34 -0800 (PST)
Date: Wed, 25 Feb 2026 17:37:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225173732.3135526-1-coltonlewis@google.com>
Subject: [RFC PATCH] arm: enable PMU partitioning
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	kvmarm@lists.linux.dev, qemu-arm@nongnu.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This sets the vCPU device attribute to unconditionally enable
partitioning when a PMU is available on an ARM host.

Note that this patch is experimental to demonstrate the API. That is
why it aborts immediately if the call does not succeed.

For the call to succeed, the host must be running a kernel with the
ARM64 PMU Partitioning feature [1] and set the kernel command line
arm_pmuv3.reserved_host_counters=n where n is between 0 and the number
of counters on the system, inclusive.

[1] https://lore.kernel.org/kvmarm/20260209221414.2169465-1-coltonlewis@google.com/

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 hw/arm/virt.c                 |  1 +
 linux-headers/asm-arm64/kvm.h |  2 ++
 target/arm/kvm-stub.c         |  5 +++++
 target/arm/kvm.c              | 18 ++++++++++++++++++
 target/arm/kvm_arm.h          |  1 +
 5 files changed, 27 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 50865e8115..29082df31c 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2234,6 +2234,7 @@ static void virt_post_cpus_gic_realized(VirtMachineState *vms,
                 if (kvm_irqchip_in_kernel()) {
                     kvm_arm_pmu_set_irq(ARM_CPU(cpu), VIRTUAL_PMU_IRQ);
                 }
+                kvm_arm_pmu_set_partition(ARM_CPU(cpu), true);
                 kvm_arm_pmu_init(ARM_CPU(cpu));
             }
             if (steal_time) {
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index 46ffbddab5..69309a182e 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -424,6 +424,8 @@ enum {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION	5
+
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index ea67deea52..afbfffe2cd 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -80,6 +80,11 @@ void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
     g_assert_not_reached();
 }
 
+void kvm_arm_pmu_set_partition(ARMCPU *cpu, bool partition)
+{
+    g_assert_not_reached();
+}
+
 void kvm_arm_pmu_init(ARMCPU *cpu)
 {
     g_assert_not_reached();
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ded582e0da..db1d564462 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1817,6 +1817,24 @@ void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
     }
 }
 
+void kvm_arm_pmu_set_partition(ARMCPU *cpu, bool partition)
+{
+    struct kvm_device_attr part_attr = {
+        .group = KVM_ARM_VCPU_PMU_V3_CTRL,
+        .attr = KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION,
+        .addr = (uint64_t)&partition
+    };
+
+    if (!cpu->has_pmu) {
+        return;
+    }
+
+    if (!kvm_arm_set_device_attr(cpu, &part_attr, "PMU partition")) {
+        error_report("failed to set PMU partition");
+        abort();
+    }
+}
+
 void kvm_arm_pvtime_init(ARMCPU *cpu, uint64_t ipa)
 {
     struct kvm_device_attr attr = {
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index cc0b374254..2b55f2956e 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -248,6 +248,7 @@ int kvm_arm_vgic_probe(void);
 
 void kvm_arm_pmu_init(ARMCPU *cpu);
 void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq);
+void kvm_arm_pmu_set_partition(ARMCPU *cpu, bool partition);
 
 /**
  * kvm_arm_pvtime_init:

base-commit: afe653676dc6dfd49f0390239ff90b2f0052c2b8
-- 
2.53.0.414.gf7e9f6c205-goog

