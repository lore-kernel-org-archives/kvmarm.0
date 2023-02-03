Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FAE10E6
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 04:23:26 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-4b34cf67fb6so39904147b3.6
        for <kvmarm@lists.linux.dev>; Thu, 02 Feb 2023 20:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HBCz7z4MHncYI2KSfyYRfjQx9Mlcxqfcto8G8RgoI+M=;
        b=WofD4bhyrBhdRY20IdvABnvAxrZJGDg14FMZs4aRUuxFzcyyJNLD8BNBBOaCBqFvKm
         b+adIuQveo0NZ2IyySWJTMXaRtjsGVoB9q9vxBIimzF8cOvUB73PMiVm5IqyYRtpWWV7
         U1/MCwDf1QXL9F7T53pC+otZQ9ZT48w+Eh2gtY2UNGgo+v7tL3ENLIOci92h5nA1fwTO
         WmmAW0qdiBcWdAT9FsPT+2fUjjG5gputhLsp4bqaRCALKB2qk0fjiArKzUnIeEKPymXU
         +V9Vcf87R4tkBTJO0TS/VlrxUAGw+6IidvTOCHVsMgkNg4kwnDRKBO4/MwXxSoKUkA2n
         CcHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HBCz7z4MHncYI2KSfyYRfjQx9Mlcxqfcto8G8RgoI+M=;
        b=qVmUfN///InaGbI5DrtiN2ViEX2t9LM1biqHuRRkQTq6ZM8lWVlJC6oHxsCK1Je5i5
         ukjfi5yZlJ23Ja1NUeuM5FSSEWr5pbaE6wiAwTgVPVhGI3mqGmI8Crda9CteIE1hYcjs
         hTYvrQhnTqi7F9N/ElLdU9KmpqO/sp8bPLpHlwmv3SgDIxVzcN5PM+q24jME6ZFbVz/v
         m3CRQ4msFbtdUU/ZRRgwb78X3bQ9AhHUwQu9GAvVqskPizQtw67QH0nuW1ZF33MZ71eD
         teVJxKXoQY6B0bUn/PTcA1O57I3In5ZiOri0/OKtHX/ns0Dc73E4YO+a067mhDJ8RQms
         SJWA==
X-Gm-Message-State: AO0yUKUrJvcnIqU0AuhBl/kwdYXRHm65FuhHEn2yj48WkmAqTcMAQV66
	5hUfymhLM1yR2Ho+8lVARsSNE48Y2/s=
X-Google-Smtp-Source: AK7set/t8pe6lygSGCd7T7jks2ZMy/qqzT75Fgk2uLNRlJkG/RDtkFqloigxMAKyLeMC43xNsHeIvtJtJq8=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:cad4:0:b0:855:fd13:bc37 with SMTP id
 a203-20020a25cad4000000b00855fd13bc37mr4ybg.6.1675398205745; Thu, 02 Feb 2023
 20:23:25 -0800 (PST)
Date: Thu,  2 Feb 2023 20:20:48 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-5-reijiw@google.com>
Subject: [PATCH v3 06/14] KVM: arm64: PMU: Don't define the sysreg reset() for PM{USERENR,CCFILTR}_EL0
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Reiji Watanabe <reijiw@google.com>
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
2.39.1.519.gcb327c4b5f-goog

