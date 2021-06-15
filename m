Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84ADAC48BE5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C93961474
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C93961474
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF6E74B0F0;
	Tue, 15 Jun 2021 09:40:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zU1Gad7fH9H1; Tue, 15 Jun 2021 09:40:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 312174B0FA;
	Tue, 15 Jun 2021 09:40:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57B484B0C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sP7rk88eJVpO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:04 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58AB24B0F0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:04 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 g17-20020a0caad10000b029021886e075f0so30008248qvb.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=fFb5EdfjHO+ewt5HOuLeS1mR20gu2Eahh4MlZRHs87o=;
 b=uKaxyGfPO489RueaQxt7plGasBN2wxPBdDP9z18kBH5QsmXdJmOlWt8qsZ7fWyWg4Z
 Tf//G1/iiAP67NdxyLmKercnkJs0TK2St7DeUD7sP4JgqDPllgRUqSfADFSresHo9rjN
 wud6qkKNi/AzL/R29gFpKSs8mr3evLA2jhkf1U0LsfofKWt3WUTM4huvPRZKNg7JMURS
 g8WN+BbSuRdnqmj6vmI3a1aV5p7GQe3ZEnzBxVKUVIgfww3v3tYcGgraZK2GjWfl70hz
 T911O8r8pHnOkWSJPKIr2jDpYRn/XQw/O4TKpQDWBCCdG+uwAiVvLdEMYkWfKaQO5njr
 Am4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fFb5EdfjHO+ewt5HOuLeS1mR20gu2Eahh4MlZRHs87o=;
 b=QnBFQbBL6baw2eG6syQo7ZeB1r5DZESo5pmHlK1PsWc9YI/VY4YvNmtaOsdrnP5m/J
 Yg/4Qf1VdJDPQU7KzRNfxy/6VGc2aF7oonRMkC1HiKdDJdbRklXbc4EBxve0rwyREIO+
 USpsIekFTVJgeiEGhIfD3CDWLkiBbKdynpMOfuHpVVbcOGucSPosWMLMQsPAx5FbM9WI
 A3RENQQGNR0Bs9IwYi5BYe5l6RWzv+QItd20S4p1r4JthsXZd9jtDIqBLZMH79ojwuU8
 sjvVV5OQuMG/6cqap3P6+OtFnzzqAmsgwpD/QIYuj02blU3+EldgPtZ4qg7VKCnNTeXg
 kWYw==
X-Gm-Message-State: AOAM533vHPOSov5R5CLIHDUM9K2z8N0w6ohTQOSd5TgQ3k7grq3V/u9s
 E5wszZRBe/hg5nLHqgMDmG03BKsU2Nz9Jmr7rirFu3jDw8f9IVHTtIvY4eTz7lUC3Sy6NDh88sV
 0RzV45ud4dnFE9jwGXIii6OLiduBmdDVbY5cOc+1gYYeSsM93keK1qXLFHMJXw9/ceII=
X-Google-Smtp-Source: ABdhPJyIzj64ZU0rwOF1Tns2cDZxg6a1VMvSmsV4v/YREuu/92HJn1cyThLZrrOSb3o9FBNoCaWcDXZWqA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:c6b:: with SMTP id
 t11mr4873488qvj.31.1623764403740; Tue, 15 Jun 2021 06:40:03 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:42 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-6-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 05/13] KVM: arm64: Restore mdcr_el2 from vcpu
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

On deactivating traps, restore the value of mdcr_el2 from the
vcpu context, rather than directly reading the hardware register.
Currently, the two values are the same, i.e., the hardware
register and the vcpu one. A future patch will be changing the
value of mdcr_el2 on activating traps, and this ensures that its
value will be restored.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f7af9688c1f7..430b5bae8761 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -73,7 +73,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	___deactivate_traps(vcpu);
 
-	mdcr_el2 = read_sysreg(mdcr_el2);
+	mdcr_el2 = vcpu->arch.mdcr_el2;
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
