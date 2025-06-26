Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246812F0E53
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968367; cv=none; b=E5VWhqRgEbnUWh9t9rf+Gq2gVbj1P7fP/o7emwO5fgx22iHE05i2tNO5uuW4bL5XPMed0FFZAmznE0hLoM3uMce8nfmJ+5pQd4Oj6/1aLiILduy/x5RxEE21UmM/iqksyNprtoDKhs0LBvUnmff6Ul/Uu5lUzqh3GZkVgr+5reQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968367; c=relaxed/simple;
	bh=OXBsuzgQqKeH4go9scl3J2sCFEoZvJBcvtYLhQxD4UM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e59sC5FsBjnoz3Q1OJ7zaqY5WN+RZ32z808hU5zfLlVCNL3oM6lKnZiOrVGrQJNWJNPRKI88QmHLTgYx8MNJjekGN8u8gP37B0djTjyrnSELOWbQJF0lnb9OrX/865IfOyot2jZg4J8cUYV+Im5s0pMz6gQE5DfaETu+wlYG5ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=16GqOWhN; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="16GqOWhN"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddd03db21cso19204825ab.1
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968363; x=1751573163; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OjcjVqcT3PfYTwjN9wXAnWmKWncB0aK3QVDv0kRYNAs=;
        b=16GqOWhNGA8tKbJJhKKMURcAg3Tn1Q6ub2oCm0NhQpzfaHjz4+x/OURP/h0hcgravj
         uQldY7PLnHILOQ5Q1ROWDLSqy+/RW0w8VuoqiP8lhFvAop1QkjA5Wkh4fKR8w4mxAXib
         gUR3md3mk94jjo/THZqIBCnjbhhKKd+51YuKogjdx0phQUB4WuFk1JJQeZs/6F45CUnX
         1TRUACJ+IpGWK1yazxKo7qwTX2is0N0xHmjuVi24xBm7z+nA0OTfvOJi0SnYtPvPRb++
         bBgyZtMymJynW+im8GB3REjdNCVxA6zSAtJBEeIQB+UiLb96o6jNG7LBJMVG+shJF5m/
         9Nfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968363; x=1751573163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OjcjVqcT3PfYTwjN9wXAnWmKWncB0aK3QVDv0kRYNAs=;
        b=j+ZeibB2zM4HZPBk1R86o0v0lsZmfggDyRghBSxhEv07S/bB3T0m0NRXfkDbnsW4PF
         QgaBaTe3x9MiDgaBWmNexKcDProvX+sKrraSfmvlSIV6qI+8i3FOU1zfh+p+3C/7Nk+V
         IVKoAGIt5FSr1Rgb6EcKSZBUaEoYMxIYaTM5O0jLdPx9aQf0SzCdzbRervtppDcRGzL9
         /d0acOIpfTTvQXBHzND0TVSzJE9DND/SwLqLvoYdHSSsHe0Y9hnax7Ne26hyNHUjXa1+
         3G5aKbJo48UljGWc2P9vPFXqPriYuNHqjGu2Y396ASO8h1qdO8RJvKbJg3L+aWsgKJYM
         XZ5A==
X-Forwarded-Encrypted: i=1; AJvYcCXtM7sts/uy+ZzHM9e1TeQ/nFe02ZpBxKjGMKfViyhV5DTbxXb+llQK8G6ei/+lklhjzETsnhw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHycaVA9dW+GK/PCpeqL0WpV4HrDx3ScKEblx1jJlcvLW0dwGj
	8YoTPeOKjkgu3MAS3ZG4GknwSwf7LUT2Q4GeXbyKlMMxRPqyrCglaTwmAbK6G/jy0buuv/pfEJ/
	D2bD8fVsgdKKdvK0y9imUqXsV9A==
X-Google-Smtp-Source: AGHT+IFUddqpSua+e1bwkQXI4ID0eoYsJI6Flt9aCdAiBQPdjrY96T7W5A1qLJU1ATtwnMWwgss2F2B6rdL1cwzbcQ==
X-Received: from ilbec6.prod.google.com ([2002:a05:6e02:4706:b0:3df:16fc:af6f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1c03:b0:3df:3464:ab86 with SMTP id e9e14a558f8ab-3df4ab61d98mr11788385ab.9.1750968362685;
 Thu, 26 Jun 2025 13:06:02 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:47 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-12-coltonlewis@google.com>
Subject: [PATCH v3 11/22] KVM: arm64: Writethrough trapped PMEVTYPER register
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

With FGT in place, the remaining trapped registers need to be written
through to the underlying physical registers as well as the virtual
ones. Failing to do this means delaying when guest writes take effect.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eaff6d63ef77..49e8e3dcd306 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -18,6 +18,7 @@
 #include <linux/printk.h>
 #include <linux/uaccess.h>
 #include <linux/irqchip/arm-gic-v3.h>
+#include <linux/perf/arm_pmu.h>
 #include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
@@ -1037,6 +1038,30 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool writethrough_pmevtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				   u64 reg, u64 idx)
+{
+	u64 eventsel;
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
+	else
+		eventsel = p->regval & kvm_pmu_evtyper_mask(vcpu->kvm);
+
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
+		return false;
+
+	__vcpu_assign_sys_reg(vcpu, reg, eventsel);
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		write_pmccfiltr(eventsel);
+	else
+		write_pmevtypern(idx, eventsel);
+
+	return true;
+}
+
 static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
@@ -1063,7 +1088,9 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!pmu_counter_idx_valid(vcpu, idx))
 		return false;
 
-	if (p->is_write) {
+	if (kvm_vcpu_pmu_is_partitioned(vcpu) && p->is_write) {
+		writethrough_pmevtyper(vcpu, p, reg, idx);
+	} else if (p->is_write) {
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
-- 
2.50.0.727.gbf7dc18ff4-goog

