Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05B635DA42
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852719; cv=none; b=HJiNr8WsNkp8apQzRSZRVzcK7Tg22xDyzQyvoJ+uigJujHCYEbzA2yAka3sj2KQ61xmBWl8+rzWgSe7ot/y/hLUuPnCCKddPbW/O3W9Hudi7SfJApABSNcI/99iv3vYoVAs73x0w4cguXfrYV5M3GVpHfIppYR4JHS2fdjiNdmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852719; c=relaxed/simple;
	bh=BZ3bxurJBOF4Xe5fK3RqTc48q2YtrMKRyNLoR9ECWUk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jcv+J2hUgzCwQzpDEWFfQwFVpKejjLgiGGPbAjUUc0BGVHEX8dbc1KV2lGdPhIQfvujSN0n1OjScP65bE3IJ2pmKvN/mPMuLBta3oRYKkBOT29qHXubpkigepmnM4YUnoBRblcW37H9q2oqJIqj73GHVBy8U6lzs+6w2a9dwFgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L1iYTuz2; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L1iYTuz2"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45eee3f9f03so2152367f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852716; x=1782457516; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9tQfxVsIaeS+jOhIrhpINETdsAt58seT+ojTMVLuce4=;
        b=L1iYTuz2+/wOHiYxwQyxTNZ10zYJUgyiQqOJdskYPDnk1oT5clV5JA+fgwNdM6jmsb
         zCplDzDxzRgHfkgpu6k8F7/rw2P/cZJSz5VNF628Z51xmoY+KvWr5qzSZeiFmBrfpZT7
         yQ1NK6P22CxrLec5S+DJbEetC1MLvkhg1lXpqRhtNLfLjAIPP1CZ3SE6sx81I9A4b8/s
         5dyEwVG5YoPBvzLArN0bsOpwFQYXiBaW9g9l+RBbdp6+mBhRhENbnCAW0jtn3lE8a6QF
         zb9tRhN+hmcp/eShw+EeOeIzBMnf88aQhqwgOXp9HtclPDyuwrxHCxdEvv+5Um7Jsu1x
         gaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852716; x=1782457516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tQfxVsIaeS+jOhIrhpINETdsAt58seT+ojTMVLuce4=;
        b=tF0ETZOZLW6H3qsb95AVLcEU9xY23u217Kw92lgJT6n84e7twjFAWAl1vZDcr9DEmY
         iax4GCeBuptHjbcl86zbNN13dr9Ie+JzyadjXDfKSBAbbflvINikgzmGqCqCop3UUonv
         0/1HrEq8MWoVsyKKALx9E17PZMF/7rj8jeNl4Yj/w4el69z+16ldqS3TjzpLFChZlHkr
         HmjU8Me+Zs9HSZB0cWu+RmWH5/VqtrjUoc0VXujpdz9O4N+V3DTWMZF/nBzt5uc4N0nu
         OmvAnue643/sM0Ilk1G8GSpDokzp/hWqUvN3dH8hFmHfl5zGhkn7EdetkiN/420yKejj
         dJUQ==
X-Forwarded-Encrypted: i=1; AFNElJ/nN1H54eGYbpnZxIi86rDczNDEXpAZtuUIIKPUKh/TscWdGCiM6/dcDS485Uq6pWm64jnUrnQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwT7s0ERMdXKAQysqusW+ATRBFGKDQth64kbN8uWdmgKks1fDI3
	YqAXxrVoEhL2y2hNcrnQKtVCLwHZXJ4UW+ydmdS//6FFm7+iBKK/5qssV0mJJI7/yFE4FNojNyk
	pWQ==
X-Received: from wrup11.prod.google.com ([2002:a5d:638b:0:b0:462:5359:f2e5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64e7:0:b0:45e:739b:3e43
 with SMTP id ffacd0b85a97d-464fd2fdc18mr4912063f8f.0.1781852716104; Fri, 19
 Jun 2026 00:05:16 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:05:05 +0100
In-Reply-To: <20260619070508.802802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070508.802802-6-tabba@google.com>
Subject: [PATCH 5/8] KVM: arm64: Add host and hypervisor vCPU lookup primitives
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

