Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1158C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7DF7C6321B
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7DF7C6321B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EA2D4B134;
	Wed, 17 Nov 2021 01:53:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gjL1NGbk9yiO; Wed, 17 Nov 2021 01:53:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 968B74B0F5;
	Wed, 17 Nov 2021 01:53:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3926E4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CLnk5UdkPQ3G for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:22 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 492BD4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:22 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 l14-20020a170903120e00b00143cc292bc3so580622plh.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qC/eXS2nFGbe5LWPRqIYtTbFYtBHmQ7GJKQdVVP+A0A=;
 b=ghbQ96p4mvC9twAH0Tuj9lFaRHB0m+8uJQPFzZ/CIBytnHC1y3VVqa5GIPtE6fyT9m
 +nnTxOjPfBRykrURArKpX2lWueXwUYmbzzd1B19UzxxMpqE4r5tms+Hsh7VPek4W+Kh3
 w3pKoJUfdsAarCISRa5BiPct5PvoCMPMOX+U7d+0giU2WFUZ06dfLr+8kseGJABiQtfO
 uIN6ChXyDtLWyDwej87qXdsZippbWA6S84KHonLZMfYhMIK4+n/AZWFLeoAqSGsIDWoP
 OGFO9nIob2MxsERrirI2PCI8fIqEfdqOZGLzdc5U3v0awu3fxsk7lv4JAfnpteT3tp1Z
 CymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qC/eXS2nFGbe5LWPRqIYtTbFYtBHmQ7GJKQdVVP+A0A=;
 b=CRhLHr3gwQf3UYFGCLLv1lXx5KhS/fXAdmSedOqLG5VHpq6hxyUOr3DwbOPNCn21Z2
 T64Vy2a5+EcEIqlcroUauwV9bJabIAWcF+3LnxWoZMDGvit8el5hho+ngHXLI7pFkpFn
 ngvBvu24DnpKIH981FuKQ5PmC/RCWvob0u/10Sluv1l3A56hpopmu49gVZ25Z0DkGZdD
 CuR+tbSZa9eSNCVSHTioBlkW7lERV/noNKSXGE3+koxOol0FTdFFmpHwuvLthaIsJdbB
 rN7m1cKEklD0k2XbXdsLc7B5oL75LkjEbBlB2YvVYsqmw129FDyvDkQmgTCACRVlqR1P
 zfIw==
X-Gm-Message-State: AOAM533/FNGAgkze+adgfcgqWzJ559Dx4B/kSb5Vj3TJiMAPmQ2cG3Gj
 dMl1mkSai+WWPWJekbJEOp9HCXlCpVs=
X-Google-Smtp-Source: ABdhPJwC4wjg1VuToYTvSJudxfPpKWjHgt+8qmyxs2CKjFyvyU3SEzO1OSgLiJ1kbIUegF9tuwn3xYxJOOg=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:748c:b0:142:5f2f:1828 with SMTP id
 h12-20020a170902748c00b001425f2f1828mr52715009pll.4.1637132001549; Tue, 16
 Nov 2021 22:53:21 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:42 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-13-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 12/29] KVM: arm64: Make ID_DFR1_EL1 writable
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

This patch adds id_reg_info for ID_DFR1_EL1 to make it writable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fbd335ac5e6b..dda7001959f6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -859,6 +859,11 @@ static struct id_reg_info id_dfr0_el1_info = {
 	.get_reset_val = get_reset_id_dfr0_el1,
 };
 
+static struct id_reg_info id_dfr1_el1_info = {
+	.sys_reg = SYS_ID_DFR1_EL1,
+	.ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -869,6 +874,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
