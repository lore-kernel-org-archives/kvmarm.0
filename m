Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F9078F4A
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 06:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773729477; cv=none; b=WylTgfgR+bSawWOJ/1C9i/DinhyVZBjjcrq0ztTcghqkiYSmCITl71dYB7wxN+Rdp9riZmiVS1nUzQf5+lzoUTTB7t3ZOV7IHK7u5pDMW1rpersMfEnnbVxfp3bUVz1ZHslKk34SBy/3DsCVUGEQO/HLxo1605LdQ3EBL/CUEfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773729477; c=relaxed/simple;
	bh=6pigEJb6MjU5WOzv3cHoV2MRbx3gnmposFMAjl091HA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Aaha2o4JWFIzBEjOyPrz2UU+Qt3ijRk5masEGlMmk0RfRm+h2S8tl3rZkJ5oQ409h6apAk8v4uHx1kiLJEB0oWnmkHJdHjYXgq4S8H43rzCli2VldwNaI7P8oYutAMVFE/8NaDQzXb90ndIdPezJe0b0rsB/YqZ4oFHNSbszqXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Uv38ahS0 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Uv38ahS0"
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 62H6aoNl004343
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 17 Mar 2026 15:37:00 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=Vpu164nWx4WQH4ej/oGZKppmfZaoPsbjbattGAiYgSg=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1773729421; v=1;
        b=Uv38ahS0027vqQrbNp5ZXxqFQJvRmc6zUg9PFzYvYXNYliRYhrmFcZqez911WSTt
         YU8glRax61lZJrhDsMgPp8n07hqRkpqTbop74N4FLPE7dvMCz8MowA8r4mALFVsO
         JGxcOisqxHRHL/++Ft1vC3ztegZmSIsu65KH0sBBAiCTzo5VQbEbdYh/vFljChNf
         10/G+rd9RyrEaBDP27L5GmSCyjcVrdwp3L48ejT9N3fVaGgcDHt35bj3BEfO1ZCe
         ySAt1VbtwJXS5bKI9CT3i/P0BcIpRCSkl8TBS1aZPj97/9wj6wCFUGF5Ip4r7ZwW
         aoVywVNUh42j4C8eys+HQg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 17 Mar 2026 15:36:49 +0900
Subject: [PATCH v4 1/4] KVM: arm64: PMU: Add kvm_pmu_enabled_counter_mask()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-hybrid-v4-1-bd62bcd48644@rsg.ci.i.u-tokyo.ac.jp>
References: <20260317-hybrid-v4-0-bd62bcd48644@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260317-hybrid-v4-0-bd62bcd48644@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-5ab4c

This function will be useful to enumerate enabled counters.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/pmu-emul.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab..59ec96e09321 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -619,18 +619,24 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	}
 }
 
-static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
+static u64 kvm_pmu_enabled_counter_mask(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	unsigned int mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
+	u64 mask = 0;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx)))
-		return false;
+	if (__vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_HPME)
+		mask |= kvm_pmu_hyp_counter_mask(vcpu);
 
-	if (kvm_pmu_counter_is_hyp(vcpu, pmc->idx))
-		return mdcr & MDCR_EL2_HPME;
+	if (kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)
+		mask |= ~kvm_pmu_hyp_counter_mask(vcpu);
+
+	return __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+}
+
+static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
+{
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 
-	return kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E;
+	return kvm_pmu_enabled_counter_mask(vcpu) & BIT(pmc->idx);
 }
 
 static bool kvm_pmc_counts_at_el0(struct kvm_pmc *pmc)

-- 
2.53.0

