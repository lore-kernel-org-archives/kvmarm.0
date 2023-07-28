Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BE41641C
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 18:20:08 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d11f35a0d5cso2270628276.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 11:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568407; x=1691173207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=69C/ntI6f1AOmR1sB1xGfWOc1uE0vjjS6a/8TiFNaMY=;
        b=4imiPj/W9BwPalHOzSmw17NqttBRQo5o87hsgLVbMTlVmd/zBz0lRAimJvIDRV4WdE
         r+gxspdcXCtepHLMuOluphMantxnNzisQBUf88GFsz+BmYeK9BeB55+0okua86LKOxU+
         NjZvQoJhPEQWEkhKojZNYVyui45IbdRp/Ul8n0lbLS02iL2UhRDICNo1e4dohFmFUkbo
         lPfxWdqTRPZAb/6xg65Y1GZH5JvMfWX5HSpDppDP2c0EgAh19zghIogAY2iCtWeeSoYS
         mn5ojApZi7HdigofpZ+vY024pSWUwn8FwASrIWAb0U0bBw8UoN9K0mqtOWIev5TTR3A0
         t54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568407; x=1691173207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=69C/ntI6f1AOmR1sB1xGfWOc1uE0vjjS6a/8TiFNaMY=;
        b=NFXQhlbXzi+bRf87H2hOEfuPu0gsuiyRqbeynkS4laLjZAnlNBkCUllI3EK7yP5v90
         EjKfOMx6vCBkGc+NuVwe3Sr0oYIw/8UvFQc3P8pcui1EPX5CvsvN+wtJsBKDLfm12Mh5
         AfArdLnSXmkZe/XGFfUC5ieX93dLSx079YvwNCFVXfGeO8uOvZSGmYCfTcxMVMXRWZU2
         p/ckPN3E0+s0nkgahd5FI91t4T4/fzvIp5mWQ1+ruYyk1GlYaGwSLJ2w63Yu+rjvteSL
         5WWszXmxTVf4Gn/nm/aseSDr+cB9+eU1GHwTa2rjzepYYKPoSGDMMbA13o9soBvvOIp8
         lE+A==
X-Gm-Message-State: ABy/qLYy9ODVMnyk3JkzcScpVpoPglP276Apy125DEfyZgL9JRf64CNb
	AXG0aA1rrr4OLw7gzPhh/bjnM/kU1zE=
X-Google-Smtp-Source: APBJJlHrauGCVrlINhpGcDmzp09heYPiNXagZxSTvSvZvveFxIbf1oHobA+L0v+vSB3K7l2kPHKEOClCwfE=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:1611:b0:d0d:587c:e031 with SMTP id
 bw17-20020a056902161100b00d0d587ce031mr15462ybb.9.1690568407149; Fri, 28 Jul
 2023 11:20:07 -0700 (PDT)
Date: Fri, 28 Jul 2023 11:19:06 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-5-reijiw@google.com>
Subject: [PATCH v2 4/5] KVM: arm64: PMU: Don't advertise the STALL_SLOT event
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
index f0cbc9024bb7..68f44f893b44 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -754,8 +754,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
-			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
+		val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
 
-- 
2.41.0.585.gd2178a4bd4-goog

