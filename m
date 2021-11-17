Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03866C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A619063231
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A619063231
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B7DD4B103;
	Wed, 17 Nov 2021 01:53:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pza4TjpYu0zs; Wed, 17 Nov 2021 01:53:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B90AA4B0F5;
	Wed, 17 Nov 2021 01:53:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE1649FE6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XX8+ci+RvDb1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:29 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8B64406E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:29 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 l3-20020a170902f68300b00142892d0a86so560791plg.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ypuzSw/4IsFfP8hg4NDwxw7HgMl3eu3z0C9tC8AgYeo=;
 b=siCkxe7qZ1oXtFSP6PtWcHf9JCEx5P8MAKaxj8jRAZjR8TfN4niqzdgqkLMpfQaN0M
 rdSPyeCBX127qnv7K5czfSo/LvwTRLRDcXnzdNgvwE5IRGkZ8xGT03jhc8dwV/2RgR8P
 AWe670/xztmm7gjkaEv9Pa6NhvqJFPjCrCMYUmExN16V2e37k0q7bIznyTmf4bnI7Aap
 r46yZAFdRIAih428DLTPDiNrKorKOddvISj9yDv4t6ecov2NQayo4OZUfHgvYMaVQF3C
 3mdP1/hAF5VI6iemKG4j4BoxYnitUxtZwT4DfeyfxKH3tSqDswy3euhaPi9Bxg2V5kZI
 Zxdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ypuzSw/4IsFfP8hg4NDwxw7HgMl3eu3z0C9tC8AgYeo=;
 b=AkJYXKnh4RMwJX1IsLsWQUZXxSa/11MAC6PwYNiYcvCPVJatN6LPLz57S1jEMPEPqI
 PeTMxs0RxGC6a99pnS6WeGfE3cxtwpEl9NpHjAe3FofnmlfFvNN2CtnqyWtvvGneeJHm
 UzGP2HQ3XKjRscydFNLCbWgF0oC/WOti4OQWAR4/O44hm0wlc44L124J/ednzs6c242z
 iCIXGsDsSyfWJiDfzrPB4Ave31tQiRui+tTR09cgiNxExJItuQZxDtCYWRFTOihN/yPR
 +QU2h0qTXarKFcB9qLh+5AaTSF8cKTuuiW7wQbs4iJZZ+7HXAJmyAgujs5IR7dDXYAvv
 dmsw==
X-Gm-Message-State: AOAM532Wy3TdfZZiUycCheHbI1P2+c1ytFz7LWjInDbssJy8BTtE/dHZ
 roPa6xsBkdEuyh8e7i1P4plOdEukv1M=
X-Google-Smtp-Source: ABdhPJwI9+DJbTQSPl234ZhGbVm/QrbU+RAS+b9ok3vE7uJCrhlFZeqke6v/rSWf7WrZlyw307Ylal6Fomo=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:21c2:b0:44c:fa0b:f72 with SMTP id
 t2-20020a056a0021c200b0044cfa0b0f72mr4939021pfj.13.1637132008899; Tue, 16 Nov
 2021 22:53:28 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:43 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-14-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 13/29] KVM: arm64: Make ID_MMFR0_EL1 writable
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This patch adds id_reg_info for ID_MMFR0_EL1 to make it writable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dda7001959f6..5b16d422b37d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -864,6 +864,12 @@ static struct id_reg_info id_dfr1_el1_info = {
 	.ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
 };
 
+static struct id_reg_info id_mmfr0_el1_info = {
+	.sys_reg = SYS_ID_MMFR0_EL1,
+	.ftr_check_types = S_FCT(ID_MMFR0_INNERSHR_SHIFT, FCT_LOWER_SAFE) |
+			   S_FCT(ID_MMFR0_OUTERSHR_SHIFT, FCT_LOWER_SAFE),
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -874,6 +880,7 @@ static struct id_reg_info id_dfr1_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_ID_MMFR0_EL1)] = &id_mmfr0_el1_info,
 	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
