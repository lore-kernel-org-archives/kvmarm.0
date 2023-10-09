Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86EE450FA
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 23:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J4tF9VJw"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-6bf0d513257so6910522a34.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Oct 2023 16:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892948; x=1697497748; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gqnG4RpBlXbew2IIW8/0Y16WbuRr1AUJcTSoXQ3GxWs=;
        b=J4tF9VJwKtUK1EXq0n/ylPDyPKSC+KV/zvDG13QoHyMW/RKZBWtpU8zUf06lhZBt7/
         kF74s4aooV60zami8wsEhRrz4YCL+Ha4RIVu9T97dnJww8L/pQhtrF6j+c+w0Gbhkr8E
         6M2fioiGk4SN/yxTxW7GaVhRZHeKGrBFP0ZE3qk/ZbYZQyA2gQU8sEzaqhKBtGkfEyBu
         8oTLieHNKkFrZVvDaL+Wnw0CiOC6U/UM102caFGQx/Ytj4F8m9QJKTCZAG2swboMOQqV
         lIVTwxFe39RnlIuFMbsWOAF0MmmseunmhLPlNAyjfPqQ2K7nqmGlwhiLlJn+pEFkA28X
         qngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892948; x=1697497748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gqnG4RpBlXbew2IIW8/0Y16WbuRr1AUJcTSoXQ3GxWs=;
        b=f4dnho2mUJH1O6JzY1KOcl8aLsgP4pU/MgU3q4eaGZ17Ksj1JUJDPUqNQwQ3bNlqho
         tHV+KOJDCxNIbXmrPRITNA2Fmzlftu5kGRpZsX4GmIqFe3MmAl2dsQ6VEf6U62J1b+Ii
         rxC2gVfYwwBrL6zkab8nXR1iBOO1gNKoBXIwjm60l+z4P3eZj/WY1tyuAgL+AJnZn99Q
         zjpF01CFWwW9bSUW3g+nFaAEGPMt8pNQF3xvBFdbJ5wEyKXN5TF/Rs7yDKwyVRuDEckw
         HMlz9RmnZj4OdqcP54HGUQ3GM1wJfQSfQz/b8FEdTtdFNkHCmIyhmDir646BHss9btmJ
         LShg==
X-Gm-Message-State: AOJu0YwOmBs1d1AW2EwhP9a0gpFuiDRCucb9zWnp5Fxena5xXgdear0I
	+TgSuB+qfOGmSJjUTLSxL27svLcP+208
X-Google-Smtp-Source: AGHT+IHZZh94mOKGfOCAtlgZAgd/+koLjHYW/Z6Xqzqw/ekKEsynPRD2lrKaZKtg4PoFRUM5ElzQFOQbafP8
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6870:7686:b0:1c8:f237:303a with SMTP
 id dx6-20020a056870768600b001c8f237303amr6171317oab.5.1696892948012; Mon, 09
 Oct 2023 16:09:08 -0700 (PDT)
Date: Mon,  9 Oct 2023 23:08:50 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-5-rananta@google.com>
Subject: [PATCH v7 04/12] KVM: arm64: PMU: Don't define the sysreg reset() for PM{USERENR,CCFILTR}_EL0
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Reiji Watanabe <reijiw@google.com>

The default reset function for PMU registers (defined by PMU_SYS_REG)
now simply clears a specified register. Use the default one for
PMUSERENR_EL0 and PMCCFILTR_EL0, as KVM currently clears those
registers on vCPU reset (NOTE: All non-RES0 fields of those
registers have UNKNOWN reset values, and the same fields of
their AArch32 registers have 0 reset values).

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3dbb7d276b0e..08af7824e9d8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2180,7 +2180,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0, },
 	{ PMU_SYS_REG(PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -2338,7 +2338,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0, },
 
 	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
 	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
-- 
2.42.0.609.gbb76f46606-goog

