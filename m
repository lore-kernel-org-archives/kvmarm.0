Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B43A3F
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 03:16:45 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id z9-20020a25ba49000000b007d4416e3667so6807319ybj.23
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 19:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=agf94AuTrHxCSXQaehK7Zl4P+40uGWhpn6X3L2a5GPA=;
        b=TFQ9QwV+p6zUCAWb8PQ0XUHpz7d7S20zrq4xFspgd62UPZ8ZwVLp4FZ7Ec0wXAGy5a
         mUxV/RSLDot3wPpar3LEfqAk4isVq7lujAAUEdQ+BVhpTKJfalBLcQFf73xu3sxW8ILJ
         OqJ6EygOpMRO/Ld2MC1q5qpUuvu2XVn00RDJtJBzH4okHXFIzloWw/Vs6rNNYaev3lry
         Gjxc5PFysYHP1T0QhyUXufhh2mmxWaRDlJFliqoDphGxMCC8l83XTNFqlwlGLxH7xHU0
         pMCa4lN0GmitdJIkqs0wtz9Cz/4owPsEdfJtJ2wHG3WV8DHTXA43OPrbrfXfRUEivPcA
         z9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=agf94AuTrHxCSXQaehK7Zl4P+40uGWhpn6X3L2a5GPA=;
        b=qUGnE0HwymS3e5K/T/J/wo9xXsduXL9yhH8aECZWPxWYqlYOdvJo+1oqFN94lrbzPs
         QV151KMlGfpUiSoNoTE3PyifuHCLXBaps1j2Gro+G0lzn13rchwzY/aeX5vLp7CEHzXu
         Cv5DJ9F+FSh07W802pXvP+oyEkFYf1dFEB4xM9rMYOa6LBa6PlCrYJmDXasyvjF+Rfxx
         MxtriDZ7O7HZvxKiCFYhGAYCqL3MYBXN84CcG6+xVhiIiBX+QeD+rF5QRik52zmeNhFC
         lU8ox+pFd9c4utzcVIEUwNAEg1AoWIjJWOda8EJlamUdrrt+dfxicwak7dh1C9fbJTS3
         jBwQ==
X-Gm-Message-State: AO0yUKXZzKbnZEVvZaDLTOxo7D3OKfqGqgk3dxW0PV6LdZYE+4wgCagV
	yhiLbyKZtsmc/MIwM4wUe1vz2YwJmco=
X-Google-Smtp-Source: AK7set9b7sVz+BIQF/Y69bLjTeuuu6haCf6tB27Fceumt1tmwKTb6i26DmdDPHoNuYujCvhTV68xnHmJoKo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:54a:b0:8bb:dfe8:a33b with SMTP id
 z10-20020a056902054a00b008bbdfe8a33bmr77ybs.9.1676085403814; Fri, 10 Feb 2023
 19:16:43 -0800 (PST)
Date: Fri, 10 Feb 2023 19:14:58 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-7-reijiw@google.com>
Subject: [PATCH v4 06/14] KVM: arm64: PMU: Don't define the sysreg reset() for PM{USERENR,CCFILTR}_EL0
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

The default reset function for PMU registers (defined by PMU_SYS_REG)
now simply clears a specified register. Use the default one for
PMUSERENR_EL0 and PMCCFILTR_EL0, as KVM currently clears those
registers on vCPU reset (NOTE: All non-RES0 fields of those
registers have UNKNOWN reset values, and the same fields of
their AArch32 registers have 0 reset values).

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e6e419157856..790f028a1686 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1752,7 +1752,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0 },
 	{ PMU_SYS_REG(SYS_PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -1908,7 +1908,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0 },
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
-- 
2.39.1.581.gbfd45094c4-goog

