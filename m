Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EBE3D75BC
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247579; cv=none; b=QzRtJIb9GO+hMaInzALJnPkz3jHrgFbFfo/jwg1P3gU6zHFdGHaCu+n1qWRyTuI9LjLsfuVr/2H1eEfipgkONM6fx4rmVCE2u0yRatoVRyhB+5ZQEpceqDX3SonqoTUd2eb/lm7rUp+cMkNYikcgPrShigtulDL6jXiRCVf85Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247579; c=relaxed/simple;
	bh=sRfTcsxroH2oLEruvCbf0VDMRBouZkr/XhuvaRHwJN8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zt2PChOp7L3yQnIASNfdTtn66MvI25Nq/5CW/j5NX5D00AXHTQpoGeAsP/TbHIlOrkn1SiY17XSDFbG9mO2t6wXoRj/d65oB3ZYVorvTxnQZko+LN5oGa7euqrO6vZtoeUZeRns0RRLozYYBJfNR7bcWqlQWYYXTMOugF20RVrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=beSqCNa3; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="beSqCNa3"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b4d3d3e6so3970595e9.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247575; x=1781852375; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5fZWED7+strAr60xfenjKYZKpvQ8pXiqF/YOTUO0ZIw=;
        b=beSqCNa3b9iMVY/auzQ6XmnYAxl/mR+vQhXZSNLKvm9AFRqCiv+Qlfh0PiYFunfi9I
         vdjO55oNi1yi1vnOGF2y70efXfOghW5YGDrfZ9+k5eeHcH/4Ld7Bae4NNKYFG9Wyz0v7
         5JlhMm38APqPwysgHurYAoB167zu0GAziosmnWPfsA5kWQHeh/MHcA2On2sWcnl7y7tX
         /lF9O89fQ1lE8S5TYV84205balIYqGUKFo21ZXrfYQSO+BqXjyp8pkpprWgMkbuWUGNn
         BMzcClXewx4LVoXCtSO93UYWgt0BuCm8lK+G+DVgk4WTFVOAmC/ae7pt/WLfj7Hhip4m
         f3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247575; x=1781852375;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5fZWED7+strAr60xfenjKYZKpvQ8pXiqF/YOTUO0ZIw=;
        b=jBHv7tkJ9/LWjF2WQ9sj1dmOid2Iy3C0gRYCyaNkdSFqqJF7H5cUD7hOxehzQmQ54Z
         TQ6RhQWcYjfvuJ3fjTRxOgABTobHX0Y+lfNtiebEBpseXHYPDRLLrYRBmm2x1hHVy3TS
         UzNTq9oYFHV0KhKbksYZtt/nUraXyoBCqoQ0BZK1aWk/ez2MqAtgRVo2BgrtKeh+bRZ7
         +Ym7tI+aDU9hcqyVLuSWq6lO3yRUv2qODmstDlAf2NYExMoxcENFaMk2jxIvoa9GIoDw
         fKXB2wZ6M7T3uzfA5hwhSOT9PVIdB+qnSEynbElUZzpOrz3Lka1gLMMv1uBJNBMausQn
         FKLQ==
X-Forwarded-Encrypted: i=1; AFNElJ/w16uyHDfbVt0+AMBntaYhI4TYgg4Hjfoh8E9lY4mpxsFY5vwJMWLghXbe3EFQt1IS/8Iu/xA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy90i6RFkH2N1w8hJ/xsGgiC5iH7DrhMdHo8auXnGUSkAnsm5uw
	DCNXF4+TFPb68jJ6+4V4D36ol7YKJNIbJ3rRPfZWF8nkiVr7U2vcQl6p0Q8DdM5rJLdhRmbjB/s
	ijg==
X-Received: from wmti3.prod.google.com ([2002:a05:600c:8b83:b0:490:ab10:cd32])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5942:b0:490:47e3:929a
 with SMTP id 5b1f17b1804b1-490ec4cd289mr10397555e9.6.1781247575054; Thu, 11
 Jun 2026 23:59:35 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:22 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-9-tabba@google.com>
Subject: [PATCH v1 08/11] KVM: arm64: Add host and hypervisor vCPU lookup primitives
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
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
index 06db299c37a8..420fb19a6476 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -195,14 +195,45 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
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
@@ -214,23 +245,16 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
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
2.54.0.1136.gdb2ca164c4-goog

