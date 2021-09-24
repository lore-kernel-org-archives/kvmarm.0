Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604DBC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1592761401
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1592761401
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C00C14B1C9;
	Fri, 24 Sep 2021 08:54:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eGkHph6F0cLO; Fri, 24 Sep 2021 08:54:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3746C4B1F4;
	Fri, 24 Sep 2021 08:54:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60CB44B1DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7p+s5f4UxhPI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:43 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC6594B1C9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:42 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 r15-20020adfce8f000000b0015df1098ccbso8022615wrn.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cwm3ilFA18I4Raa0wHdWLMhcRNJhs4J6mMJre+L2FYc=;
 b=je4bpz+fyu10bGVoeoi6Ty4HR9PtcbFNACuFRPupPpY0oUsa9yZ5kNeaIDZcv5QwY6
 CSWs6Xj0h0oAHbTrPGjEnrc19tjy+775oHQ7l2R+CvM0oc6tMMC6N5r96PgmOx00xdqu
 /v1NV17MqFCcglC9pHP1Qbu34U8sSzUZjeotVPNeCTqztX641tRp+ekL3lADIVhvVZgi
 oJRGASUfqkRJNbKb/8Affuh+LcyRMJm2VOkoMhL747e5fqGybD2S3VnDAbcslVNjbnLL
 V/H05WEymc21vdiftZeiBopLIXqyb5J/DJcRcrST4LHoIikUl1cR/NrRfsAcvyRUluMG
 Flyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cwm3ilFA18I4Raa0wHdWLMhcRNJhs4J6mMJre+L2FYc=;
 b=idIBm59DqqQdm9EFeWnbbq1HAmkqP9jUP0LmTpmzPesQ6+YbcOxgpsAgjNfqEY7t3y
 f8Gf0mthnvGUCZjCLxBLmBdzIOJ8pGdQf+N+YeRG1/8dcdvTkqGBcOebHgE5qy5l9hZa
 YvTS3rex4OXb8/RjCEaAZ3wh7QL2nCC4hBLSK64rNsNPmmbnUe4+A6AQg9zGaX4HGeUL
 2yZZTjJRF3trfAI/RwGAyBdrIsz+uRwnTVykEBq77yZy7Bgsf5wwbGmsFjsjOzP4pi4j
 KhNr7v0b8M6Ou5xPH9VxjtgThqkl9/RwvDqLHnRR4/csz6ZN4lUhBWLeSDueRj4T9Wov
 Kvqg==
X-Gm-Message-State: AOAM530N5Av86yaqZDs2ef6Mt1JZWpYGRtqpMk34NiL5eh9Y7OKybx7C
 g05La4IPJJqOxTxnvbTQCVeB4qUXyW8QA4svN0rVB/U/ZDF2xAa+Q0NVrbaRiuvMZQikvbcx/+X
 y4VkxF0aIvbG8XuJu83AbuEup718NBJwK+9ksWqcI4znpDrMO1JIyJulU4iaLvgI5mwQ=
X-Google-Smtp-Source: ABdhPJxkPO4x4XuJuQJSrvaVgGRJ8ovLrP7eMX40+ktCtEBAvOSg0HVW16gwA36lCjJ3bdNlORdKrvWRmA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c052:: with SMTP id
 u18mr1931373wmc.105.1632488081942; 
 Fri, 24 Sep 2021 05:54:41 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:48 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-20-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 19/30] KVM: arm64: change calls of get_loaded_vcpu to
 get_loaded_vcpu_ctxt
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

get_loaded_vcpu is used only as a NULL check.
get_loaded_vcpu_ctxt fills the same role and reduces the scope.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/entry.S     | 4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 996bdc9555da..1804be5b7ead 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -81,10 +81,10 @@ alternative_else_nop_endif
 
 SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
-	// vcpu x0-x1 on the stack
+	// vcpu ctxt x0-x1 on the stack
 
 	// If the hyp context is loaded, go straight to hyp_panic
-	get_loaded_vcpu x0, x1
+	get_loaded_vcpu_ctxt x0, x1
 	cbnz	x0, 1f
 	b	hyp_panic
 
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 2b23400e0fb3..7de2e8716f69 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -134,7 +134,7 @@ SYM_FUNC_END(__hyp_do_panic)
 	.align 7
 	/* If a guest is loaded, panic out of it. */
 	stp	x0, x1, [sp, #-16]!
-	get_loaded_vcpu x0, x1
+	get_loaded_vcpu_ctxt x0, x1
 	cbnz	x0, __guest_exit_panic
 	add	sp, sp, #16
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
