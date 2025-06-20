Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44372571A2
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457939; cv=none; b=N0Q0znCkwUR54KQBPwZ/0KXn+4CEbLq6J1kbOMadcO6OiYiCVmR2fseDh714h32aNU0DxT1GmXva+v24H6dp1N378qkJ/AaeHnuizW1KLeP4m8TgkuOhC4lcAXB7cRmYR92SanuSZVOu13IMwE40KWHGA2qrmZID9HjqOYXc+Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457939; c=relaxed/simple;
	bh=y1VZ87bDMvhFxKKb8KOnkNsslQVDRlVgHyTOA2XQMHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ONMuJumqS0yg39lMT4eytj7qmEGMPSlnk4jiRbbQ0NHDUgax8rsAAtmAZzIL2p5wl27AmT3Iu4dlF0GN3kYrxZVuW87WCxJM7qpA2NHET5pXtPtu/4pHqgbNWfzvQVeb73qSWl1DoNfTvDGm228Uw5UfM+2tQqYqdeX4EgjuVXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=09haUUqj; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="09haUUqj"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-876074516b3so400472339f.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457935; x=1751062735; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lCeKccnUmGK0t6piLYL2X+QAR4eGmRxuwVO46fLii9o=;
        b=09haUUqjjYUgOhf9VAwx0VcVawyMfH37FqOJubpQ6bGdUyVPi6xVIZ12WsmnYcgzSV
         4wQIAEPnXpH0kfL/wBnXdAUIDH/NkS52E5axYN6sCfxonsz1INswE/v/JaqWTQqQJnQV
         FlAUM9tTNAErg2rhaFhHFNDCx/DkUhXslQRM8ima0OBWe1wMnBI/Z215+hIQ94si1AS7
         vNQ+XyGE1/RRmIl2zETcQynIyxBgUAnkb/UUxNe+5+6f33OO5seRE3MXxrnrL86HeyWx
         4YxadTiNfXG34gPaDSGoHuFVTHv3tQDZlmqNqRCAYpL4IRJdD5OE6DTQ3mkbS77R0N/d
         V6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457935; x=1751062735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lCeKccnUmGK0t6piLYL2X+QAR4eGmRxuwVO46fLii9o=;
        b=gCs2LZFW9/RqFKTkkKCmKNUU+VBWHzaQtkiVf3dz5785o0ppdR4uMzSsuUqzIM4pWB
         Xg0nTwiP6fCRtfG1fIBv3mcGqSePxbSET6rgdArIzucJLTO2Xpos/W89l2oxsi7IlRV2
         NY20cIrsoXAYqix74By8KRQA76JtBR3HN5442D2duHyxNHcJ7SRjxx81zwdvzTxjbTPC
         jz7W6Nl/FT8K5Yp2JpntNN31ohB0Ifrxs9X2yq7ij/joKgrrS6xY1z6vTlr0MFJnpolX
         fJyT62hrJkYCy+jZnCT0ZbCNe7ge4K8QyWoew6ZQK/HmkNpO2HZ/Zn219AdId3FrC1S+
         +AuA==
X-Forwarded-Encrypted: i=1; AJvYcCUC629Y4vRytUbTpA26evE6s2YGcn1iEc4MdcsYurrYvlXS9aJ0P7PkRhXghndCnH8WyC0cOQM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzI6TVEAF/L19JLjyor5B2PZXr6frBWwv6x/CJFG6o2X2x2wRdU
	NE6CVsaajGLf/ybg6x4MiZ6aIEJssBkgWBjobAQLKmRetHA5lYOVweerfdmoApAE+WpwdG83VUv
	reAawBiy001AS13LYDXgoW9xRRQ==
X-Google-Smtp-Source: AGHT+IGAgAXt4VAt9nwcok51fvIV/dFkwYe009yCTofFAGBTMKz3erZRuxZTNNWRigmqT+1olC2QwZa0BzFYekCXXQ==
X-Received: from ilbdi5.prod.google.com ([2002:a05:6e02:1f85:b0:3dd:754f:1dc4])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1fc9:b0:3dd:edef:894c with SMTP id e9e14a558f8ab-3de38cc04cfmr43152805ab.14.1750457935204;
 Fri, 20 Jun 2025 15:18:55 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:18 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-19-coltonlewis@google.com>
Subject: [PATCH v2 17/23] KVM: arm64: Account for partitioning in PMCR_EL0 access
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

For some reason unknown to me, KVM allows writes to PMCR_EL0.N even
though the architecture specifies that field as RO. Make sure these
accesses conform to additional constraints imposed when the PMU is
partitioned.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c      | 2 +-
 arch/arm64/kvm/sys_regs.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 90fc088ce3d3..5f0847dc7d53 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -884,7 +884,7 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	u64 n = kvm_pmu_hpmn(vcpu);
+	u64 n = kvm_pmu_guest_num_counters(vcpu);
 
 	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
 		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1ea7d092ec59..b64b60e297bd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1266,7 +1266,9 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 */
 	if (!kvm_vm_has_ran_once(kvm) &&
 	    !vcpu_has_nv(vcpu)	      &&
-	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
+	    new_n <= kvm_arm_pmu_get_max_counters(kvm) &&
+	    (!kvm_vcpu_pmu_is_partitioned(vcpu) ||
+	     new_n <= kvm->arch.arm_pmu->hpmn_max))
 		kvm->arch.nr_pmu_counters = new_n;
 
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.50.0.714.g196bf9f422-goog

