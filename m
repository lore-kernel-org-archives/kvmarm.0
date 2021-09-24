Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4978C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F7DC61425
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7F7DC61425
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30BCB4B214;
	Fri, 24 Sep 2021 08:54:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 91J4s6x9ZFxq; Fri, 24 Sep 2021 08:54:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD814B191;
	Fri, 24 Sep 2021 08:54:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32C614B1BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tHB6I7Xz22TX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:52 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 508BE4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:52 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 s18-20020a05620a255200b00433885d4fa7so32697410qko.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AJoOKnLyUcMeZ4bJL08afGQB1XmHWoCmbvvxsT90R1w=;
 b=TMcksozilNhor18k73HxG4gyzfpGIMQctnpgCoaFfUQvCdISS/VjwUjfT8F/wp9IsG
 PSTiJU2S+0umLVLDZpYsMf1X3pMpaNn1K70khBdD2PsgT9nUFaSWbqDDz8wWIAjd3R4y
 /7Ix41f24yh5cDWqxan5dgEUP+g+Bo06EILO7FWcopUsktqWgXUJKfnWaJu6p5D5A487
 lIeMXBorGqKldcdOiUFmwoM5kyBRg8Qc7dDf/ZIiCMR3KJ7Uus5G7B0UWsPVzQESkXiF
 i4fjNfKyLfq1Hj9F3RZ2SsYLfw6L37gMokU2uTeaiLZVuxDA75sy3iTlTonCGSWvpuEB
 lnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AJoOKnLyUcMeZ4bJL08afGQB1XmHWoCmbvvxsT90R1w=;
 b=jZDWs/ztcVVVWD1XYi2ytfkuK1qUJlbZhtIwsjmIe3COA0pbz2lA2dwQlkOXtwlXlc
 KV0qowOYgVzeiOyBCkfrnhgNf7zqIe11cVgSLL9ym4DaromeMcD2YA6uf347g85IqyfN
 15sTp9DH82x+Vo4xfs7P1j1As7HQjEipJjimIbEDwGLx+1zKzVPW/FYhsWt/HOcIUIkn
 4TtRMO5zSM69dwQYzTWM+rlSNI9cgiwBnhtKQTKxolFJCHhvz0O6OEovBlWJYJVyovVG
 D5YQGit/CnggrpWZuZCFP0Egc0G0mrN6HFZjQok/eCWJn911Y0fqWCsIMtVYdpJBlPo9
 DxoQ==
X-Gm-Message-State: AOAM531YltvB9q+9tAUAYWg2jDQJn5QlthqXeaNeObRrj4AjUrT8smAV
 +L5nLDSYRUpnI3fR9UnbtAXPrI3B7Phbni4v2QM0mr4+sD/Q9Q9nlxzpG7vhnh/JjGjGb2GzBlS
 aGpE48qp0qvPvFEUQEuPxdLWzkhCLQ6F0fjl6UKCZL/OocIGun6Na4iOqXnlnoFEei+A=
X-Google-Smtp-Source: ABdhPJwRKEEdsILouY64mZAty9UzcrpjyOPrwEYFLAfse6nGd0/Ta0E8nqaALjj/ZCs3Dfp6mLzP+gYXZA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:492:: with SMTP id
 ay18mr9625511qvb.4.1632488091905; Fri, 24 Sep 2021 05:54:51 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:53 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-25-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 24/30] KVM: arm64: remove unused functions
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

__vcpu_write_spsr*() functions are not used anymore.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/exception.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index bb0bc1f5568c..fdfc809f61b8 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -67,21 +67,6 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	__ctxt_write_sys_reg(&vcpu_ctxt(vcpu), val, reg);
 }
 
-static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
-{
-	__ctxt_write_spsr(&vcpu_ctxt(vcpu), val);
-}
-
-static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
-{
-	__ctxt_write_spsr_abt(&vcpu_ctxt(vcpu), val);
-}
-
-static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
-{
-	__ctxt_write_spsr_und(&vcpu_ctxt(vcpu), val);
-}
-
 /*
  * This performs the exception entry at a given EL (@target_mode), stashing PC
  * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
