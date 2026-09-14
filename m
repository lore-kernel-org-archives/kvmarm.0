Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8834457A3
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386171; cv=none; b=MW4/Z/AqPM/UQUhM5on18A8CT28YeCexHfJlsXowVPjY+kpN1ogw7jStDTaHJwk/TRtdvVYVAs7gmx6Ifd3TtU3fv7+p39Ow2Obi1Oy0FY96dPnhabkuahR2MeJphN1xxqbxqdT+22wcdbTMhR/BYOpfQOH3c2ACXOrP2nDY9XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386171; c=relaxed/simple;
	bh=OkvBLyzd2QOHEMuSfHYwvhh6JbY910F/L4YLee/eXFI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YJ368ggu1KmS1vW77UzYMazoXWQI2ffkc3uETgrMSe119lvMy8ZXGXHsxFmge0+Ej7Y6NTdq2ZmAezZqCXNjLYHbbhETgWVGv0wwCem0dWOnaYhN+DGryyvweMCFpQk8ap8Ekq/s35IOrpJczOgDFIhanl6czOOXEQyPSSr8308=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=MlGSDuk7; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="MlGSDuk7"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjs7084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:53 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=ZW/Tdj3bVLx1UwE3X/hNQWAdAvY+Hiob2QqqnLyGvfE=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386113; v=1;
        b=MlGSDuk7SKaQ8izN+dOvH2xaoA9UX8xpYXL54GdL6gVXgk+Sq1cdZsXlFr+sLJP0
         Qe4q4XvQ4br61fjmjNFy4z7DjrTMs0gCmj9wensbeYGIcITJFSa7mU8/Qi0myRfU
         b9PAuytGmopZpYAeJ0nHvUSkEdSn57IlXAcjoEl+Tol6GOyvu1eWFC5M/9S3k7FZ
         wvPNHtlvKvTAqPUdMqQ4z2dKSUIyzssHDTjkRT2prvxaheGDWEPIBfhHx/LYqYYq
         HkfaSzTIqoy8egRkA8s78Sd9FwkSksEJONbzUR60ZuRilx01PxhWTTz6y5FayXLJ
         fOdGInMWdYRNYywdreF6TA==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:44 +0900
Subject: [PATCH v10 05/20] KVM: arm64: PMU: Keep implemented counter mask
 EL-independent
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-5-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
        Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1575;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=OkvBLyzd2QOHEMuSfHYwvhh6JbY910F/L4YLee/eXFI=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu7kxU0pKhNqKfzIrGPgYPXZkDytU2X3GR0hBudl7l
 fsKI8GOUhYGMS4GWTFFlpSi3dwa0bWfChPiW2DmsDKBDGHg4hSAiWSdYvgfu6urzehA/b9Ej2Wc
 EZt6MzLvM9hH8/1S7+cQfRv428OZkeG4yDxhmwD9dP2QzfzbXz1ed6Fyv0aEouSxt2U256pfXGU
 CAA==
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

kvm_pmu_implemented_counter_mask() derives the counter count from
kvm_vcpu_read_pmcr(). For a nested vCPU outside EL2, PMCR_EL0.N reflects
MDCR_EL2.HPMN instead of the VM-wide counter count.

Consequently, processing a PMU reload while the saved context is L2 can
clear and fail to recreate state for counters reserved for EL2.

Build the implemented counter mask from nr_pmu_counters instead. Keep
the EL-dependent HPMN restriction in
kvm_pmu_accessible_counter_mask(), where it controls guest access.

Fixes: 600f6fa5c90c ("KVM: arm64: Let kvm_vcpu_read_pmcr() return an EL-dependent value for PMCR_EL0.N")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 950b7a349659..a5ccb6ae44d5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -317,12 +317,12 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 
 u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
-	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
+	u64 n = vcpu->kvm->arch.nr_pmu_counters;
 
-	if (val == 0)
+	if (n == 0)
 		return BIT(ARMV8_PMU_CYCLE_IDX);
 	else
-		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
+		return GENMASK(n - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
 }
 
 static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)

-- 
2.55.0

