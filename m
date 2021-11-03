Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7057C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F54861177
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F54861177
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 364894B14C;
	Wed,  3 Nov 2021 02:28:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wlcs5Q7Shbv2; Wed,  3 Nov 2021 02:28:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BBAB4B090;
	Wed,  3 Nov 2021 02:28:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FF6E4B165
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oiq8U0HpqUoU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:16 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF6B24B090
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:16 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 y125-20020a25dc83000000b005c2326bf744so2633037ybe.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VrJ07b06nc9KbJLXSj5zehnLehuxuLDRP/US8C6hfE0=;
 b=ZAVnIZTP+LHKUx7NfjJFSSU8Rs4NWQlt+WSmFir11XcrpVf8vIvANzLB94WHJ6Bf60
 k5sOQZOlmPiZcIyPnZc5h1IMa4HEIbaZcPfZylu7pLpRq3Wo7z+BnTX0y7I5wYkCFuoG
 +eGMgfwCzcXcJHpSeGXyJ+tSsUCHmpwt6ur6pHCiVAdNfjEHT3yYhu+lsxVQ5D2V2KIC
 qvaK+4T5DbMnZpK3Z7YkucwN2EtSX/SR0NY/oCqRV2gxlQCjWzPRe4HiWqu2PEQkt71B
 aKqnarAD6+0QHqmgo1zo2USfPJbv7FQerLfy1iC4jnm1iC7S985cSaZMnGyUSznXz1F/
 su2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VrJ07b06nc9KbJLXSj5zehnLehuxuLDRP/US8C6hfE0=;
 b=ZFJi/PUgyoABmtkLMYulXw40aAlRFEtzAJA2Rer8K9Aa1Ky5qG2IYvU+a8elQHKkzE
 vJHpKVKMkdf1lkGWlVPO0jlr4ITqEHsFeTy8I0KgM1kbdvf+ghnHW7X9qabgDDqJjuTp
 Hb42ieaQs+ujhCabwDUxfIRCkk41++6BxguaQPcoCtZZ7diWToIJE+cg8OURsLMvWUC+
 pSZg4Nf32h5j9Q/ecyG122dW9f8CkV2i48MeuHPU+LsX4z4stYe5vcQQ2s2usnDZZ8Au
 cy8hDYtqaYpgJktY5ANuxCoQ7UYx77ii6mg7LlTTVvuRf3W+5YtO4Y3vGp21kQ8JGq/G
 WtsQ==
X-Gm-Message-State: AOAM532feJ3/KcvnUmuiOSkqqVlO+fg1U4w7ywqpn8QktNf+f7F4hUyu
 toUZNzGegumE2jqwuVCI1w/zAldNw24=
X-Google-Smtp-Source: ABdhPJynSsKsRymAV6oD+adfOhHtjHV5sbxdoRvZmrjUVSSHvV6cZcysjNYwYVj1A9HptlBdbRlQUwIXynU=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:5d08:: with SMTP id
 r8mr43342773ybb.227.1635920896128; 
 Tue, 02 Nov 2021 23:28:16 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:05 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-14-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 13/28] KVM: arm64: Make ID_DFR1_EL1 writable
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
index 8abd3f6fd667..f04067fdaa85 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -835,6 +835,11 @@ static struct id_reg_info id_dfr0_el1_info = {
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
@@ -845,6 +850,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
