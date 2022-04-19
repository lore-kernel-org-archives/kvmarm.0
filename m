Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1009C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 998194B1D2;
	Tue, 19 Apr 2022 02:57:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AG6GaP0gt7gO; Tue, 19 Apr 2022 02:57:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A51D14B1A3;
	Tue, 19 Apr 2022 02:57:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11379410BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gjcxf9Mm5hQ3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:35 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1D794B1ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:32 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 z88-20020a17090a6d6100b001cb89a1969fso10144773pjj.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+RIFV+GBe2M89AsHlXZMsb8M9PH2fcdCA31lX27Exl0=;
 b=jHfDWDQBRdFMX1KUZ7M8h7PpM144EBI9vT9022UC7DTugoUZgKVXh5XxcMJR3sxN70
 aoQkPuceSyyGP29G1menl9lnaI1m0kUA+fvRB7mzGNAWeYz5l/fUgvMoob1N9gab1My7
 UWCic2ZNLYXUgeFFIn4H97XVTt+viw27rpDxXWVHJgA1B6p2CmVNcKJ6TLveWXxE/xQk
 ydfiv5X53K1FVVmXor1T/C4gL3g0lIyJ9MLApM8nzmMIH6pNamH5H0+iUvJ4kqd03eXW
 b47bh5b8cCNcl9sSjgo+NkhW9d2Yibv3AQ7C9gI5XGp8J4zhObzXeuECjtA3WNtmsgOr
 Pefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+RIFV+GBe2M89AsHlXZMsb8M9PH2fcdCA31lX27Exl0=;
 b=qFzMHwXzNHicmB22kx21DP18tUZpE13O9jmHEnYSwevatzImR3XafhXIajz1U+aukV
 giWXjn++nHqRHbU49NQ8KS6xOG+wr6nb6gMfqYK4Gyvb+2DdwTZrLzQ6QulnxNZwIzQ6
 D8J1VwoEJ+3YUkUOCuvbgQqJFso2N2mcD1fFVFyP9+begEdcnD3zNwqFxTrx/+bulLlh
 aKUBeZsFkEf+A+eBlbF9nba4uclaOK3l94HbQAop6OtgWP7i6uhgYTrC2ka2UWxrwlkq
 qZtgMrYAnvBGdcll7Ct/x+ucSfcjrFmycEnDm3xIDx6Jcy9Xu5vFVB1zWynaq/wrR4lQ
 FMwg==
X-Gm-Message-State: AOAM532+NKET4KMNPXlLSux+uALLiAdQ/EzMkDVVQFclAcFdOwz8qnv/
 HeDn35lox6VadS8jtZZ9fMP0OiqQIOU=
X-Google-Smtp-Source: ABdhPJxyzd0FpvVmJHlsUoLjVst/BJV+186a7Jt7JsU7eedDcva2Fw/AIAC6p8ib5uPpHPfQ2iIiPlO8PG0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:234f:b0:4f6:f0c0:ec68 with SMTP id
 j15-20020a056a00234f00b004f6f0c0ec68mr16406433pfj.14.1650351451950; Mon, 18
 Apr 2022 23:57:31 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:22 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-17-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 16/38] KVM: arm64: KVM: arm64: Make ID_DFR1_EL1 writable
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

This patch adds id_reg_desc for ID_DFR1_EL1 to make it writable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9eca085886f5..3892278deb09 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4142,6 +4142,13 @@ static struct id_reg_desc id_dfr0_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_dfr0_el1,
 };
 
+static struct id_reg_desc id_dfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_DFR1_EL1),
+	.ftr_bits = {
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_DFR1_MTPMU_SHIFT, 0xf),
+	},
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -4150,6 +4157,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
 
+	/* CRm=3 */
+	ID_DESC(ID_DFR1_EL1, &id_dfr1_el1_desc),
+
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
