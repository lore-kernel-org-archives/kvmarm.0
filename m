Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CDB349CF8
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852850; cv=none; b=QaWJxBLe2Y88cIWeIC+rLqkbSisnKRoF3Rh3NYWsbF9qxWkZgTt8GSnZIBggWD9d/4OzAbsSI0Qr6Tb/u6uTbtqUzwbHHGFblIoRNgw3qH6QZnAcS8CkSfhvMt4OlgAOMhKLkFSEM1Bakjj3WZ0uz1BjPk/uP9kej9hUONoG8+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852850; c=relaxed/simple;
	bh=BZ3bxurJBOF4Xe5fK3RqTc48q2YtrMKRyNLoR9ECWUk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gHQvAfowspDXh7lK9k2sM/QQPPPPN6Z2es7Ixs/ejl8piT9ZyCcNTQHthscidH7yoPnP+DP80f6pWVCLrYEXN2nG58VjTW4vW65ywoMC6bvPMQPqr/KEZXtb1BbtA99fsgQJRFiAhDN4mSiHsrhZoUxI0n235dsYQ8AAWZsz0Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tTnjE0Gb; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tTnjE0Gb"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-69681505eabso828838a12.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852847; x=1782457647; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9tQfxVsIaeS+jOhIrhpINETdsAt58seT+ojTMVLuce4=;
        b=tTnjE0GbKZldD11yHkiCMApjfg3DmoOpbWfyPu0/qqmPtWF/m2E01rb/MFmwEA1tCe
         Wqp4wqAJFUa6UrqSDe37qQQnZONV9Dght4XDMA7Wm8Pr9NFg1uEG9miRYX85/xBibaYx
         Or8qf8F548/wAtIwlP75yn6AboFDyrWalKAl7DH1SjGk/F+sgmJLaw3TeE4HnSQP+8S9
         GVvA6Q9Y+P5gmdTKu16aitmq8dpbRi0S4yW9inWZ00JI53wtxmczOUlJA9Jsw5XWDjJY
         jBvUG6n3JORj9Pq1RXcM/H+Jwu32bGTmdjr39TXXPX/yZ+2lml85rm8ave+Hb1PNn+xM
         pyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852847; x=1782457647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tQfxVsIaeS+jOhIrhpINETdsAt58seT+ojTMVLuce4=;
        b=l4B3ofDty7lKLAgKycRS4/9xgeMakh80GoljwaWtAvcm3COrSAqF3BjtHkQAFFTNFV
         G4+5PF/SRokKhgDjpBlLgWvGQ5BGz1/AxrvJ8k7eO+JCe2K1Gp9ogtvDZpfkXq3j3+LK
         TJ/G6+Y0DA5PgKp1YRlSMAhITKZiWNc5jSClOOEbNxghvqIwcdUiSjfoXC8TpAI4iriE
         NQGGpYpSm2T/Lr5/+mwPA/m4vCDAF3WJoL9tQcMH7zz7n7kP5UbaCW2GafH2G1XaBMoK
         MnAcniTKCJxjFP9JkSenLU3d1dup3nZP2MrtNCAGZt6G/UET4HAHy6xmruknJoSfUj7W
         NALA==
X-Forwarded-Encrypted: i=1; AFNElJ9IzEZLo2wQEhNvLyw3b3ViJ2jaesm5r/nTM2uKE3qGEq8zqeSS49gsfcjNtMywrIFzk9Cc3TU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzilZGk3yeBZqYLpaXvveiVQ3Up2LPMiWHsep4j7xvwJnPSiHPo
	JMCb5w10hBMa/54PJcxe/YUA2s3rLiJOK1BE6JkZz+Zif9/RnsfUls2AyYb9Hs9gXH0b3FQKl9P
	Vtg==
X-Received: from edds9.prod.google.com ([2002:a05:6402:5209:b0:673:4f43:5f4b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4589:b0:67f:e9d0:d819
 with SMTP id 4fb4d7f45d1cf-696e521d903mr1212311a12.22.1781852846765; Fri, 19
 Jun 2026 00:07:26 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:07:16 +0100
In-Reply-To: <20260619070719.812227-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070719.812227-6-tabba@google.com>
Subject: [PATCH v2 5/8] KVM: arm64: Add host and hypervisor vCPU lookup primitives
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

The nVHE hypervisor repeatedly resolves a host vCPU into the EL2
address space and validates that the loaded hyp vCPU matches it, with
that logic open-coded in each handler.

Add __get_host_hyp_vcpus() and the get_host_hyp_vcpus() macro, which
translate the host vCPU into the hypervisor's address space and, when
pKVM is enabled, also return the loaded hyp vCPU if it matches. If pKVM
is enabled but the loaded hyp vCPU does not correspond to the requested
host vCPU, both the host and hyp vCPU are returned as NULL. Convert
handle___kvm_vcpu_run() to use it.

No functional change intended.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 52 ++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1d01c6e547f5..8923f594c264 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -212,14 +212,45 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
 		pkvm_put_hyp_vcpu(hyp_vcpu);
 }
 
-static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
+static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
+					     struct pkvm_hyp_vcpu **hyp_vcpup)
 {
-	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
-	int ret;
+	struct kvm_vcpu *host_vcpu = kern_hyp_va(arg);
+	struct pkvm_hyp_vcpu *hyp_vcpu = NULL;
 
 	if (unlikely(is_protected_kvm_enabled())) {
-		struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+		hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
+		if (!hyp_vcpu || hyp_vcpu->host_vcpu != host_vcpu) {
+			hyp_vcpu = NULL;
+			host_vcpu = NULL;
+		}
+	}
+
+	*hyp_vcpup = hyp_vcpu;
+	return host_vcpu;
+}
+
+#define get_host_hyp_vcpus(ctxt, regnr, hyp_vcpup)			\
+	({								\
+		DECLARE_REG(struct kvm_vcpu *, __vcpu, ctxt, regnr);	\
+		__get_host_hyp_vcpus(__vcpu, hyp_vcpup);		\
+	})
+
+static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct kvm_vcpu *host_vcpu;
+	int ret;
+
+	host_vcpu = get_host_hyp_vcpus(host_ctxt, 1, &hyp_vcpu);
+
+	if (!host_vcpu) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (unlikely(hyp_vcpu)) {
 		/*
 		 * KVM (and pKVM) doesn't support SME guests for now, and
 		 * ensures that SME features aren't enabled in pstate when
@@ -231,23 +262,16 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 			goto out;
 		}
 
-		if (!hyp_vcpu) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		flush_hyp_vcpu(hyp_vcpu);
 
 		ret = __kvm_vcpu_run(&hyp_vcpu->vcpu);
 
 		sync_hyp_vcpu(hyp_vcpu);
 	} else {
-		struct kvm_vcpu *vcpu = kern_hyp_va(host_vcpu);
-
 		/* The host is fully trusted, run its vCPU directly. */
-		fpsimd_lazy_switch_to_guest(vcpu);
-		ret = __kvm_vcpu_run(vcpu);
-		fpsimd_lazy_switch_to_host(vcpu);
+		fpsimd_lazy_switch_to_guest(host_vcpu);
+		ret = __kvm_vcpu_run(host_vcpu);
+		fpsimd_lazy_switch_to_host(host_vcpu);
 	}
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

