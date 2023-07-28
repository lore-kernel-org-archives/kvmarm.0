Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABDE1BB26
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 18:20:19 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5840ea40c59so25125047b3.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 11:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568418; x=1691173218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2xpjPS24yC6WEaeqRzU4H7WlQVocjOmJ6iEHs3rd81g=;
        b=sb2e2ZicSoE/37geVNg2mh/h4mq9S8CUzH9QMg9+39Ayh8kR7c1EYB4Rv3pgMM7fq2
         QAWPYWqDZ0lg+u3wNr50hD1JBmCXsagcMNol3qqVr9A0Vaea+UjBHyulaWRkhlkhQkjN
         GEfMqAftZfvBNVxT2Q25jJkD+pTC9PKkFy+XMJXNRl6qj2ev1nN4xMLBqXAy0Sx7PbTO
         1AcTIVQeGb4HHnP8u+0VTSD22iyXQFDSnjl1bKavsRMD562NrSOYP8OX+vPoK5rm51wU
         2JJFJzQFz4VzSFyooEzfTWRn/QQh0WwgNySDamrd97nPZoLr1WbDBpDtf1SlqKVsVSoT
         TmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568418; x=1691173218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2xpjPS24yC6WEaeqRzU4H7WlQVocjOmJ6iEHs3rd81g=;
        b=jTq8lAHqyOqyizjy8+6OlEjM/ZcBZAEpw89vVP6x6rHdF2Qhj1Krxk3UIBDwHHO93x
         YN6pMi49fkcbpxsgJQ0eXp4ImRjZQlWGDrzU6BuRcztm1gjd0p33uqZ/aZMekZjjAFpx
         ApVCVej53ZA1qjotdYpbcBdmT5EjjOnLiy9cDWf2RGY9CHfKyEV43N1MK685mG+8+NIh
         Zcb+KIDQUjjM3iyNqiKwS9tKjFfelrP8pM4wR7w7UtjLs9M27gexVh2p0qpNuAHIu4r9
         XECvUJDdNDDFpqvwrwzxMoKMa7+PPuq/sldJZWkMKE1Gj7htF6b7Ok+mZq6lx87By4n3
         htEA==
X-Gm-Message-State: ABy/qLbq0/clcm8B5gajTcfxXpRjefbp+ty0xfYqznx3WzZzNcbOpt8/
	2o7JdRW//4RFeY6CgrZ3Lc/ESjYjOzI=
X-Google-Smtp-Source: APBJJlGGMEKDyFVWW5wq3CmTjmWkAG6EK1Hulf1y3IEUhbUXkjIOZDJYusNOd29d4Wx+PcVgk7IhawHjcJc=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:690c:708:b0:583:96da:32dd with SMTP id
 bs8-20020a05690c070800b0058396da32ddmr20691ywb.0.1690568418572; Fri, 28 Jul
 2023 11:20:18 -0700 (PDT)
Date: Fri, 28 Jul 2023 11:19:07 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-6-reijiw@google.com>
Subject: [PATCH v2 5/5] KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}
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
index 68f44f893b44..47a27941163c 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -751,10 +751,12 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
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
2.41.0.585.gd2178a4bd4-goog

