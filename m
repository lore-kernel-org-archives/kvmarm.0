Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C87EC2
	for <kvmarm@lists.linux.dev>; Sat, 19 Aug 2023 04:40:03 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-58f9cd8a01aso15370767b3.2
        for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 21:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692420002; x=1693024802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D2rf4521dR3zfDVxwsUnaZ4b3GIZAWIZe5mix3E7tmw=;
        b=qJS+3BP7OJziky4Ud3VEiJCDjUq1/v8p2/3so871pbftG1o6VhLmHaKAvxvc/L0/lL
         RvCeLG/sgdDmxuip/JLrWp8B5ZiIpGuDZEPzkKvGL7Wg3vYk6L9uI6IuPq4l5LgLmXfh
         kHGTifVOEVrb/wXei6Jui/bmc3s7YTqeQ3iYB4FfHQuFRL/6SeEAyyfKS00ArXonMIYv
         yjG0yYi24sKXP7HhYV217lmUt+h4sE9EqNuLUVdP89KEd4X8eS+fP0KCnAV0RyzQwsPf
         Q1uTjgegb1D7RycOUdaMzSEY8qtgpI3IBfGaExfyHzH6dTzWNciN2emzhZJovG6Ia+Da
         syjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692420002; x=1693024802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2rf4521dR3zfDVxwsUnaZ4b3GIZAWIZe5mix3E7tmw=;
        b=hOKdqQl01aJOWpHE7zqowvP9yYkBE4ekCiOLrCb/N6GbvNqPq1Wzgu4LKq/sW3xsDb
         YZFptvuoEtJAkk9UvaSZY0nHMhtZhAamQunEM+RsPFourIanng97T+9ORW4U+qoeISES
         +0+Ggx/vE9LeeGXgBwODkm3IIelcveiUvC2mQ6Ik4+K92qxHGRf0xV2VAx3kbzZ0a7p7
         EVtRfcBpdqKa7ocmqAxNVrhKP1MkkV2EyjJUZ3K7HLgLZEdAaewBoa5IaPliBrVEN8uI
         Si0AUcgomf/ol87Zun3Xe9QdwX2SNiceQzFA7Ef2jEPSmat9cIlY/1DRSDKUziPBdms8
         DeGQ==
X-Gm-Message-State: AOJu0YxPtl2L7Q+HFOE6dPrDcoiEFFnp5RJtPr1v3nXW/AJTJKv2LPwg
	ZJgMftAOTAm+fCpvT16iibF3IRGlWZo=
X-Google-Smtp-Source: AGHT+IELA4iR22cgCTDziZj26+U0sQqaJauKgJgwS++FJVq1RlXhGN+EUKXwl62A9kMl5bSyEq87t/VnBkY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:b71a:0:b0:56c:f8b7:d4fa with SMTP id
 v26-20020a81b71a000000b0056cf8b7d4famr9410ywh.7.1692420002422; Fri, 18 Aug
 2023 21:40:02 -0700 (PDT)
Date: Fri, 18 Aug 2023 21:39:46 -0700
In-Reply-To: <20230819043947.4100985-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230819043947.4100985-1-reijiw@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819043947.4100985-4-reijiw@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: PMU: Don't advertise the STALL_SLOT event
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, KVM hides the STALL_SLOT event for guests if the
host PMU version is PMUv3p4 or newer, as PMMIR_EL1 is handled
as RAZ for the guests. But, this should be based on the guests'
PMU version (instead of the host PMU version), as an older PMU
that doesn't support PMMIR_EL1 could support the STALL_SLOT
event, according to the Arm ARM. Exposing the STALL_SLOT event
without PMMIR_EL1 won't be very useful anyway though.

Stop advertising the STALL_SLOT event for guests unconditionally,
rather than fixing or keeping the inaccurate checking to
advertise the event for the case, where it is not very useful.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index eaeb8fea7971..b9633deff32a 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -761,8 +761,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
-			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
+		val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
 
-- 
2.42.0.rc1.204.g551eb34607-goog

