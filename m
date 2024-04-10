Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4B217F37D
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712771722; cv=none; b=YEx3orUv62tZjGNjxTcd7RKfDUzh/kvKlEDkkJ5hUqIZBx8HEQB6l2XPbX3rhFQgTGO21LIovCEtKdtLnnRFSPlJ2guqqINaNve6gGdmd1QhWTwk6/H4Jow9fZV2BfixzNFWtyiu7je6CgAfvB5sQsQKJrCUpLRfF8RVXFDm7dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712771722; c=relaxed/simple;
	bh=c5vOu3wln/bzFkI50zK54TLDDdF576q5OSt+R4RYCW0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=krVTRqHq8W3oAe85Vm8Le8/bE7kEP9ph39+VH2wV0ekHB7GxL2vH53BXCTEqZ+rmxjytfIPV7mrZxC0J91j4Kf5vtHODhDx1Ve5z5Rze+QXMGeJJPQInov9ksZmmGxbaWZp0fi1oX+oYYwloyYgEcO8yC3y3Jyn93fwCEm3bqOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XDVBsEmN; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XDVBsEmN"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcdc3db67f0so118092276.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 10:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712771718; x=1713376518; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oTRds48YQAuzki9smTU0zbOfJX16SMcTfKd42zPqGTw=;
        b=XDVBsEmN/FrQIJbANBYPdVYz8/FJeNoF3K7q1eBfjxv+F0NrWeF2oKq4Jxf5fC4OAC
         aY87gBFFs9pIuHTAhYgc4bj513yGU7tGuNg6Uyw+bZrEfTEpFgeozqstQ0Sn3sbmD3VT
         IqSNYQeYXVOhYq3c8nMyUbtipIwXiJzXUm4ID1toz381prTV0Q3DK/sgTI7lc42L94rs
         RY/qTjj+xv56fO/93/l8Ma7N+81aIB6vfgbB0qbW9X/wCE6iiF4BhcPZjkMSWt7UnNnR
         7s+faFzwxXgtwWptEd7CcuYIp91pKx38f9ApiipeZ8uDQSJmSYBYuLTiJXaKgJYsdXnW
         mI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712771718; x=1713376518;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oTRds48YQAuzki9smTU0zbOfJX16SMcTfKd42zPqGTw=;
        b=QpvP1r66jqoOjb0vbIMonhlJBbujpXOT8ux+ITwbqallEcenRKtGlbbrHYN9CRbKJO
         vvLDCQPeIUYKH37csnbFnmsqKQdORfyPf9iE4DyNH0yIM8xt9BD0cOqAujFFRkahRBCf
         EmEE2bawQpFFMerpfL2ADoWK3c9325MDLmMWqOcX4H/eaiSmBiy6c103jAgsAjB6BYf+
         /B2HlC28AVTtJB+zzzs1holIXOaDl8zFLWriJSzwwzZ2QsZ7PdcVxcF3eooJ8p1Qmko6
         dSZj9wt+WaPPHF8o66Derf+vQVlxdD44RuyvZ7w0QvZMXH51KpGk1/lwwXZ2facRm4Zi
         SkQA==
X-Forwarded-Encrypted: i=1; AJvYcCX9LzfQ9SbRn8rm4pQd6eYaBYpQoNEOTrqOL3xwSzsbqPcO2Yr8RXTIjymuJw9LZ94yE+ZqfUhznF+oDvMDGBxxoxe6mQQm
X-Gm-Message-State: AOJu0YzbQpPSLYAIiaufQnxU8n5Hv3HDnMuxIjIXCySyKR1yfpCuCQmZ
	GTkKzEbxpU2NyAcoY6eAa78iM9rrZDBUEoHH7UNRetFXS8PbwP3pJtPoR/e5wxcEOYMynu4Euyu
	AWhi80rk4YnXL5C5MeumHxA==
X-Google-Smtp-Source: AGHT+IFGk/yictiXP/bmh1HJDKurTfI9OfoF/LDokYTgZALVerLy33LdKx5oD0s+3wIFHKHy3OTGRtA6WddrXew0Eg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1148:b0:dd9:20c1:85b6 with
 SMTP id p8-20020a056902114800b00dd920c185b6mr109753ybu.2.1712771718281; Wed,
 10 Apr 2024 10:55:18 -0700 (PDT)
Date: Wed, 10 Apr 2024 17:54:37 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240410175437.793508-1-coltonlewis@google.com>
Subject: [PATCH v3] KVM: arm64: Add early_param to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add an early_param to control WFx (WFI or WFE) trapping. This is so
interrupts can be passed through if the CPU has support for direct
interrupt injection, a feature of GICv4. This is described as an
enumeration with three possible behaviors, always passthrough (never
trap), never passthrough (always trap), or default (trap if more than
one task is running. Default matches the current behavior.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
v3:
* Changed control mechanism to an early_param on Marc's advice this should be
  a system level decision and not exposed via uapi
* Reduced behavior to an enum from an integer as there are only a few options
  that make logical sense
* Limit option for always passthrough to systems with GICv4 since the primary
  case for always passthrough is systems with direct interrupt injection

v2:
https://lore.kernel.org/kvmarm/20240319164341.1674863-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvmarm/20240129213918.3124494-1-coltonlewis@google.com/

arch/arm64/include/asm/kvm_host.h |  7 +++++++
 arch/arm64/kvm/arm.c              | 30 +++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..e9225b1d0e9b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -67,6 +67,13 @@ enum kvm_mode {
 	KVM_MODE_NV,
 	KVM_MODE_NONE,
 };
+
+enum kvm_interrupt_passthrough {
+	KVM_INTERRUPT_PASSTHROUGH_DEFAULT,
+	KVM_INTERRUPT_PASSTHROUGH_ALWAYS,
+	KVM_INTERRUPT_PASSTHROUGH_NEVER,
+};
+
 #ifdef CONFIG_KVM
 enum kvm_mode kvm_get_mode(void);
 #else
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..5d0ea6b2c652 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -46,6 +46,7 @@
 #include <kvm/arm_psci.h>

 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
+static enum kvm_interrupt_passthrough kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_DEFAULT;

 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);

@@ -456,7 +457,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);

-	if (single_task_running())
+	if ((kvm_interrupt_passthrough == KVM_INTERRUPT_PASSTHROUGH_ALWAYS
+	     && kvm_vgic_global_state.has_gicv4) ||
+	    (kvm_interrupt_passthrough == KVM_INTERRUPT_PASSTHROUGH_DEFAULT
+	     && single_task_running()))
 		vcpu_clear_wfx_traps(vcpu);
 	else
 		vcpu_set_wfx_traps(vcpu);
@@ -2654,6 +2658,30 @@ static int __init early_kvm_mode_cfg(char *arg)
 }
 early_param("kvm-arm.mode", early_kvm_mode_cfg);

+static int __init early_kvm_interrupt_passthrough_cfg(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (strcmp(arg, "always") == 0) {
+		kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_ALWAYS;
+		return 0;
+	}
+
+	if (strcmp(arg, "never") == 0) {
+		kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_NEVER;
+		return 0;
+	}
+
+	if (strcmp(arg, "default") == 0) {
+		kvm_interrupt_passthrough = KVM_INTERRUPT_PASSTHROUGH_DEFAULT;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+early_param("kvm-arm.interrupt-passthrough", early_kvm_interrupt_passthrough_cfg);
+
 enum kvm_mode kvm_get_mode(void)
 {
 	return kvm_mode;
--
2.44.0.478.gd926399ef9-goog
