Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E785EC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A50C84B242;
	Tue, 19 Apr 2022 02:57:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ilbupnHwC7Qm; Tue, 19 Apr 2022 02:57:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C62B74B1FB;
	Tue, 19 Apr 2022 02:57:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BDFA4B1D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 36UkT5qf9SWO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:37 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8570F4B1D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:34 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 f2-20020a17090a120200b001cbae0449edso10135964pja.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kOtruObnAwr73tGi5MZAsEqpA/uKhtQAPuGoRa00WMc=;
 b=mTJ21013PiSwkw5o3Gbtoin1gGUFTC2f11xhWGdUiETUkhecccbVgbMOAwtXaKBtqw
 34ltnUdfLnvlsCBfBtytLBYdcq3Iprqi6xqpEewEB0sE+o7KVrPiafcRnuf2v6WzOaVz
 PEWZt6iQR+LcBRGuArYRWNqjokJGWZTYDaUxQIXIY/pYCFOQmIuyIaTXxmw/sbJbbr1C
 yyBD3zGKzxr9xv8DPDiQ998Qbyf/SibU/rYcpFowvPKU2y/xz0ceqb+fEZe2ToqdztS9
 zbY7kgN2a91vAerHogjHLztkGGHsfqbki1OYpRjBk4DLs/AKRYh2bDlAC/YTvmeNZDxM
 WRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kOtruObnAwr73tGi5MZAsEqpA/uKhtQAPuGoRa00WMc=;
 b=XNf/qic8T+EPVCtu4evUqqGCtDD4MvkxLQPx1cBzLaYxCK5f9mZgSWbiYSXAsMRo94
 8uHmGAbvv5W8gACmEdOEvY6Rvrqdkq46Dq2GfTSdEuZiv5ZIi3mJM6Mt7DcmpfI6Ocnj
 egLwGHDafBg89Ez+0qVM4KWODbaXE3feNZRZN5j2u/f+xFIAMiay2FBpaFOF50A6e0S2
 5gcs2bivN1dmGQ+1UMQe+W9ranXZSWPgWVO1Cvmm+2CaQNAPZqRxxFGumZFeTeEp/jwY
 WbgllXkGL6Bci0P9c1FpJOsVWnOYOH8Ju5SriA/bJorfRuyntnEprmKp2bbX/yO1BrBi
 3KYw==
X-Gm-Message-State: AOAM5316v/ZS9DyHxNmoOAhUff0LDuzv4hesgYJL1qCrZDObt9RiKuGQ
 oxVDpArYEZ18tWD66Bf8bZ7Auyf5qg4=
X-Google-Smtp-Source: ABdhPJx6qDbSnrgYvhJroWf4jBAE01A6EcpohDsqf8ebCgDlStR+vqVIies+oFNL6BLxOeYZEqyR+y7SKVI=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr276854pjb.1.1650351453576; Mon, 18 Apr
 2022 23:57:33 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:23 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-18-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 17/38] KVM: arm64: KVM: arm64: Make ID_MMFR0_EL1 writable
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

This patch adds id_reg_desc for ID_MMFR0_EL1 to make it writable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3892278deb09..dfcf95eee139 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4149,6 +4149,14 @@ static struct id_reg_desc id_dfr1_el1_desc = {
 	},
 };
 
+static struct id_reg_desc id_mmfr0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_MMFR0_EL1),
+	.ftr_bits = {
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_MMFR0_OUTERSHR_SHIFT, 0xf),
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_MMFR0_INNERSHR_SHIFT, 0xf),
+	},
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -4156,6 +4164,7 @@ static struct id_reg_desc id_dfr1_el1_desc = {
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
+	ID_DESC(ID_MMFR0_EL1, &id_mmfr0_el1_desc),
 
 	/* CRm=3 */
 	ID_DESC(ID_DFR1_EL1, &id_dfr1_el1_desc),
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
