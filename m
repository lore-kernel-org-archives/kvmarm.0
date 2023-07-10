Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6084614AB3
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:24:38 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c926075a50cso570560276.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 12:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017077; x=1691609077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NjXGqinFg6JbUCcCuD1314VDCv679WJcMyQaO6pNuqI=;
        b=riWsju77MCgLxcyPUA5zvABoTX1/n+uRhqXiNScFzay1HPX99z0tc697bB4UPgxFup
         v6vjFDK+OpdAh+ZfjD+AN7l24j6yRvX3XtBvROnruXBLFl2kWNA8PHx/58YzuBVEhk5A
         tzoGrsxzCwHBrSrfUBwlAu5r1zF87t1cTryo+Ov3gX8k5EDIk63Rk7uqhpoTmNfHtVXW
         iB6XkV+A/4mmcFig5KzmD1Tjd2NkDPiTGmGTlD/9MwaZtYufwCgye+a0Yei9/XK5XQg8
         xopGAsDxQTs9dWPaMe8zfQxyD4pigDfKPNFKYllHwZX0MpFq1iOzO70eUexC7njvYRQ6
         kegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017077; x=1691609077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NjXGqinFg6JbUCcCuD1314VDCv679WJcMyQaO6pNuqI=;
        b=aRtMrJvbSNnoxhK5zDgBhExavFsAPFVP4th9gNefSf5mpL/MGX7cVlpDVnOk22AV1I
         AkEHBxbMW1xetwZXeA/t/jBVOIaSk1B0kP9r0cTB4wGyFmjp1f7K9xYH4HvlTJqZrQJw
         kopQUIKVcDlZn+u9xMKghxQgBM7Wc121Y6SYootid+peUeAsQXT+aa09XyjSK10tPZoQ
         dzuKX5f/ozbqSkSK/l1RDcqWs/oXrGvovvTap2MCEr8LO3AKwP5loJn7iS0gRBBbp1TS
         zDkuA3MvOhLYEc1VQ3RGSOgbVa+KF1vUOCbmUvOgrqUfxjtKxyOS9ukgBRRJ4hO5UfqI
         iA9Q==
X-Gm-Message-State: ABy/qLbLgi84BQ8kdR9UjCl18Y5zx7Zzdv+tCZURjcuZ6/F0T1P7uowS
	k1f5jMbUG+7IfHWyzwfOPImmmBTyMDQ1Pvsvvw==
X-Google-Smtp-Source: APBJJlFU/3p3XZytGnnz4g0xxHNMZggWlz1mMLZ78y9fLOkMhIqS/5mIom3amLly/wcRCruQ7qwxSVnY/RznFpLozw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:ab90:0:b0:bc4:a660:528f with SMTP
 id v16-20020a25ab90000000b00bc4a660528fmr143365ybi.5.1689017077178; Mon, 10
 Jul 2023 12:24:37 -0700 (PDT)
Date: Mon, 10 Jul 2023 19:24:25 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-3-jingzhangos@google.com>
Subject: [PATCH v5 2/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
from usrespace with this change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c1a5ec1a016e..0160ef9cfe18 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1980,7 +1980,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2029,7 +2029,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.255.g8b1d071c50-goog

