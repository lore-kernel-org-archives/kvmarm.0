Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AC3EC7
	for <kvmarm@lists.linux.dev>; Sat, 19 Aug 2023 04:40:04 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bef53ee9a8so19660505ad.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 21:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692420004; x=1693024804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AKUPjh6oK/AHt5DTbKeyntJhoH5vBBMqS9Q93jlsqh4=;
        b=BPxNSvzkcI0KKZBmZ9vQvp3Q195xCQ7XrW3Lauqrxtr/suDRr1vREqQ6vB0KZFVGix
         Bxkmn7EnM5GCcYKazSBbCKPV+sFDRs/+mMkUV2cVIR0H07p0pVTDSh346xHr3B1jj/qF
         8j6a0sb61kLuc3SOBP1x/1UMwSYQRmRPiyVh1zREs9bZlxecSC8WsR7qh9L+sC+N/K05
         kWCXI/PsQN2twFYHmk/cQKV0p0kWlPmLVsKhcDHr4hb2xWzVsDAMVK9Cjj3Zg4JKyWX+
         MHfewnRYEQUQAwbZ5umk4yK9/Xt7w+UZHhpnoHY4iCzxxE+48gCwKIzm4pTEwl43HG19
         av3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692420004; x=1693024804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKUPjh6oK/AHt5DTbKeyntJhoH5vBBMqS9Q93jlsqh4=;
        b=OxhbyncS0vkh0J7Udxk9MUIcP1dw4lPCgm6PPCBTWoqR9x2rady9Y/XmbORh4fSV7p
         24ZAoYh0ADurDF8emH7vfPmA6RqxarzCAdZANfIEL5z6B2mrTU/qOPtq5frswybaCt3U
         SWUBRcV0/SrRES8LABnlzBx0runbAt4jcsNaZ3yQL/mGplpyD14rG7ceR9vleLXi1pH6
         SqpLnj3hOJmcu8Vagxr7ga3wrUYX6i6ouEEBXMIV38HZneY1IZDbXnyzS5tRRdPzc8sR
         YqHNHPY8OaEaoizu3HIR6mQAv6xhmPqtqC/QnLm+asB/27RmuhPZ6i1w9HCUeVaBZnrc
         AxEA==
X-Gm-Message-State: AOJu0YwoMG17Ev7CaJcrQ4UNR5J+HNl9vMcH6PCP8HxKZldXEGwbRG6+
	Or90AIsx/nj0H3YXr2V1+DmxwF4Mq8E=
X-Google-Smtp-Source: AGHT+IGLxzRdP1MTKcNfYnDsSILLHW1aOrghtWBJGgIJIi7ddCSua7RomiZDF2YXdMVwaolTy42XkIptf6U=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:902:da87:b0:1bb:83ec:841 with SMTP id
 j7-20020a170902da8700b001bb83ec0841mr490814plx.6.1692420004335; Fri, 18 Aug
 2023 21:40:04 -0700 (PDT)
Date: Fri, 18 Aug 2023 21:39:47 -0700
In-Reply-To: <20230819043947.4100985-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230819043947.4100985-1-reijiw@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819043947.4100985-5-reijiw@google.com>
Subject: [PATCH v3 4/4] KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't advertise STALL_SLOT_{FRONT,BACK}END events to the guest,
similar to STALL_SLOT event, as when any of these three events
are implemented, all three of them should be implemented,
according to the Arm ARM.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b9633deff32a..6b066e04dc5d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -758,10 +758,12 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	} else {
 		val = read_sysreg(pmceid1_el0);
 		/*
-		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
+		 * Don't advertise STALL_SLOT*, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
+		val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
+			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
+			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
 		base = 32;
 	}
 
-- 
2.42.0.rc1.204.g551eb34607-goog

