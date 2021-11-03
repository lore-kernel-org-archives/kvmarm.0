Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D26C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE79261179
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CE79261179
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7299C4B199;
	Wed,  3 Nov 2021 02:28:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1x2YzFnfWPUL; Wed,  3 Nov 2021 02:28:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 285124B103;
	Wed,  3 Nov 2021 02:28:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C6F94B15A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eNvbOHPjjuen for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:20 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DB7D4B16F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:18 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 jx2-20020a17090b46c200b001a62e9db321so505717pjb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Esyigd24VZzPo59EpEVlVJ1Fgs9fgw4MXQuf865VkCM=;
 b=F+nZxkxoiWIyyns/e6YvCovwVFgHwrPCf4W/omxTTZKZxPeieOLU5DGarIx6iQBnRA
 AwDOAjRjA/RTb348aoIOxmxsGOLFGENIy+5whxqZNRq2weovTQtDpvjwDDS/X/bVB5Oc
 3Hksfyo6u3r8/r+WY1rwl3twBXaLZL30HbuxcePUi7SummLqW7NN8HBHD562Q92RPCB8
 IYHOfGZtQruMMArAwh5rkXIi6EftMSA9wzKz2yuC9O/WL/hANK5OkQecfL7Yf7PH4cld
 rUB0NfkdHf/CKIXzlxHKTBdEQoiAN6AGqNtwOmqQ1pzZzKBCXDxuE5wGgmn1Fd2VVxyD
 oggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Esyigd24VZzPo59EpEVlVJ1Fgs9fgw4MXQuf865VkCM=;
 b=mt9Xvoqi9dvhR13tbIRK1gBnb7GCIK3En0nOde6766H3Jqo8LuaFJC6vNetoxhksUc
 ir6gBI6u3viOP5BArHQSOwhMCGnLV/7Ai1ZcqvZcLL95BlaK4eMTPjoF2HolLz+BqbR1
 3JfUAiHbUrgEhI2u5NjPCobLgoFC0Kje7AfqGgYxVIvRZu7DKg5FXDb6RpDz2hirP/mz
 qFP3cnygF0neLnAUCyOL+aoHPkvztWjZMVS6oI4eYEStZuH1UVA7YxDIF9YsijV2SbR+
 C77mfZ2pdM+rRZ2Kd+pdItiEbvVw0xS7HuyykJezgud6aQyoLpL6mIgJ40TI/rQwrkbo
 ZrGA==
X-Gm-Message-State: AOAM530Evv8TLy3rFRUuCEe26q2pCNqsygrJe6eSdOfvqNCjHPfGnl5J
 2RcYBfabUqt8wKDntk0X2ntjo8vBWJM=
X-Google-Smtp-Source: ABdhPJy8zAxunqRArXzuJB5aGkOf3dPMAfmrH4e8aF0KnNXPQWSWpgHh4j0Xv7zu5BhBikqibRcVNu8SQBM=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:244d:b0:44d:c279:5155 with SMTP id
 d13-20020a056a00244d00b0044dc2795155mr41787826pfj.0.1635920897698; Tue, 02
 Nov 2021 23:28:17 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:06 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-15-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 14/28] KVM: arm64: Make ID_MMFR0_EL1 writable
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
index f04067fdaa85..cfa3624ee081 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -840,6 +840,12 @@ static struct id_reg_info id_dfr1_el1_info = {
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
@@ -850,6 +856,7 @@ static struct id_reg_info id_dfr1_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_ID_MMFR0_EL1)] = &id_mmfr0_el1_info,
 	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
