Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BCC2E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="baMvsyNe"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e283ef6299so3147197b3.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548134; x=1703152934; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eUvF2Iqi7HYfXyk0bPF9d7e3j/8CjJsU7OLN3xwfaaQ=;
        b=baMvsyNesJH/ACu5tY6gSJwDIZcZq2K7uvkSyQ6IDdVe5ONvbbujDd2b9YfV+qZmAZ
         cxvIr0bmaKfdBQWJ7EX3k6D42IZ9JRCDdk3vKwWWyjd8uZ4QEYuoLys/YV8Ruw8Eoo7S
         LMdeqXpcjPTTrCdPu1LBnJ+HtJEFY7wSFzSCILR4gbt9XLvEijxAlADYVnOcHHuauzcQ
         tAvYE4qrdCTZe2RXk6mfRQf+ZOx+5Al0NpZMitSpo/uGkNEq7LfGymUq3I0dgpcYohsH
         yMA8wU4QkCdEyT97aZzcyqMF2WwzDtTwSZZAxMvjPFCuUYnvqOYqeyzwaDftnGfVmrIv
         Y+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548134; x=1703152934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eUvF2Iqi7HYfXyk0bPF9d7e3j/8CjJsU7OLN3xwfaaQ=;
        b=WGuGL4b6O58UFwxaNtbn0HnuhCFKrSkaBrSJ7ePI8oWAwuHKnp9DFcT3azWB8tH5fq
         OYGEtVs4JbKyPE+ERZOuLHgWd8Nr6jgkpaincSiT38hBPBbu/E2QDLQ5Bdb/EOB8Dya1
         GQOtbR0bPm1dlXVNuPwgltq9jrESGbgBhA5JrWugGreQD5/7m7+blYLNYc3oDCCW7fs7
         t25YSHeTVRLWGlU+LCoNQb9g0bcwRUFVfhhRnky/hqVW6iyweL0RDSIrey1yoEe3ADQ5
         NPOkHNs69szsJ8QWQnVM46vMgatA/4NXpXGEuXfCj43OUT06bmGbYhdQ3t1MQEspXlXP
         ODig==
X-Gm-Message-State: AOJu0Yw8r1LJcD9lA6oAwlFM2PMtjzngzD7xUjvXFWOGMdNrtNrejIy4
	EAFd9/LogmjP4yQZOTfoXd2NPw6lrQ3DRoL6EaWN9U2s4RK31LOAbbZxfrW2MX7cwpCqJ4g+T48
	dMd61CxuROP7+qq13aNz7qUXt1ZKBc80eOxb2lIs/Kr1XhT97o3YOVOHYabw=
X-Google-Smtp-Source: AGHT+IGtiqJ+ZIn5CNnbsNfDPH8yDHoyOvgqWr59kL6zpxpOMfsf2pGMh4bSAsKAtgDBenzZXZUzYblJHw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:3586:b0:5d3:d44a:578d with SMTP id
 fr6-20020a05690c358600b005d3d44a578dmr170258ywb.4.1702548133869; Thu, 14 Dec
 2023 02:02:13 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:46 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-7-tabba@google.com>
Subject: [PATCH v3 06/17] KVM: arm64: Add missing HFGxTR_EL2 FGT entries to
 nested virt
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the missing nested virt FGT table entries HFGxTR_EL2. Based
on DDI0601 2023-09.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/emulate-nested.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 06185216a297..8b473a1bbc11 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1042,10 +1042,20 @@ enum fg_filter_id {
 
 static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	/* HFGRTR_EL2, HFGWTR_EL2 */
+	SR_FGT(SYS_AMAIR2_EL1,		HFGxTR, nAMAIR2_EL1, 0),
+	SR_FGT(SYS_MAIR2_EL1,		HFGxTR, nMAIR2_EL1, 0),
+	SR_FGT(SYS_S2POR_EL1,		HFGxTR, nS2POR_EL1, 0),
+	SR_FGT(SYS_POR_EL1,		HFGxTR, nPOR_EL1, 0),
+	SR_FGT(SYS_POR_EL0,		HFGxTR, nPOR_EL0, 0),
 	SR_FGT(SYS_PIR_EL1,		HFGxTR, nPIR_EL1, 0),
 	SR_FGT(SYS_PIRE0_EL1,		HFGxTR, nPIRE0_EL1, 0),
+	SR_FGT(SYS_RCWMASK_EL1,		HFGxTR, nRCWMASK_EL1, 0),
 	SR_FGT(SYS_TPIDR2_EL0,		HFGxTR, nTPIDR2_EL0, 0),
 	SR_FGT(SYS_SMPRI_EL1,		HFGxTR, nSMPRI_EL1, 0),
+	SR_FGT(SYS_GCSCR_EL1,		HFGxTR, nGCS_EL1, 0),
+	SR_FGT(SYS_GCSPR_EL1,		HFGxTR, nGCS_EL1, 0),
+	SR_FGT(SYS_GCSCRE0_EL1,		HFGxTR, nGCS_EL0, 0),
+	SR_FGT(SYS_GCSPR_EL0,		HFGxTR, nGCS_EL0, 0),
 	SR_FGT(SYS_ACCDATA_EL1,		HFGxTR, nACCDATA_EL1, 0),
 	SR_FGT(SYS_ERXADDR_EL1,		HFGxTR, ERXADDR_EL1, 1),
 	SR_FGT(SYS_ERXPFGCDN_EL1,	HFGxTR, ERXPFGCDN_EL1, 1),
-- 
2.43.0.472.g3155946c3a-goog

