Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251DE1C04
	for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 04:00:29 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-45dd4fb5580so221993307b3.22
        for <kvmarm@lists.linux.dev>; Thu, 29 Dec 2022 20:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQL8LpFQbWC/4XZqubGHc3h5rf9RkGEx3SeQGahZOzI=;
        b=n+I2UUck4OlTqPy8zYXZ+xx/sIHj/NUhsraDP+JLn0MWryS27ueidGVOObK6RFGIwk
         BL6kbLfQLA6KOWwK/h1q2OpjhInRT7uNChsTZ5/PeTLsJCvsdDOxa+A2jCHpTinNJ36o
         4AMQUVLsLbIMbEvDGIzAH1yA79wByfLwDHDsMUrSYeb8+6im1q5TQgy5cw8HdrV+c7Zp
         GSl4E62BZMYznQzrGz11QM5NRL0h7M9r5fdcQMXfDnMsWIAhhGAPJcg2S3Hqn/uIIpyt
         yO820vWLVAzXwwQGgmhGRNoyqLCDoN8Cz8dERHFNmTgEw+U1IRdEHsHBMDezxOFoydPC
         8bHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQL8LpFQbWC/4XZqubGHc3h5rf9RkGEx3SeQGahZOzI=;
        b=Y/MCIf4NVycvoq1W87gka56YaZmEzNSLlWySREQtOYpmeYu5MfwyqXHeYaLDC3hLzq
         oT/BXdHDmZ6G3hVJMP5OSL0IILaS4GVIL2lK7IiTJZFCBuib9X4vZqrW4UYVe5tyjjh9
         FmNm6L+6MBJ5Kmf2vaz/It6+WP39xLVhRfrInne6detb5YS96yVPxUWs8+7u8RpmYa8x
         s56pCnLfbFOl2bq8n6u8T8If5oK+EBavGI95tmyP7g901kT9ZmVDSGdFQWDPjX3v1ziP
         j/iACFJvFtm5pZkwax01FQuG8rT7D+v214aS56FW3Hf37HQKjG3wT/QLriweICk4Twyy
         E88Q==
X-Gm-Message-State: AFqh2kryurly5ZjhOf+3nmcY0ucdyXxezZsmRtvhXozkhd7A1MiZ8WFJ
	fg1NbPsad4xOxibX9AGNnY5A+1Xp2Ms=
X-Google-Smtp-Source: AMrXdXvHWmdW4POEvsJkJXQsrQc//66oPLiXUgTOK4KT6ispQGJVgdJ41r+5ZfWiIhEAIgPbKE8yYf9Oybs=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:852:0:b0:711:6d3a:2b9d with SMTP id
 v18-20020a5b0852000000b007116d3a2b9dmr4131790ybq.133.1672372828203; Thu, 29
 Dec 2022 20:00:28 -0800 (PST)
Date: Thu, 29 Dec 2022 19:59:23 -0800
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-3-reijiw@google.com>
Subject: [PATCH 2/7] KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0
 and PMCCFILTR_EL0
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221230035923.5UlaHIx8295IVwN3k9gWi582L-xcWySSANRmDPlHNWk@z>

The default reset function for PMU registers (reset_pmu_reg())
now simply clears a specified register. Use that function for
PMUSERENR_EL0 and PMCCFILTR_EL0, since those registers should
simply be cleared on vCPU reset.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ec4bdaf71a15..4959658b502c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1747,7 +1747,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0 },
 	{ PMU_SYS_REG(SYS_PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -1903,7 +1903,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0 },
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
-- 
2.39.0.314.g84b9a713c41-goog

