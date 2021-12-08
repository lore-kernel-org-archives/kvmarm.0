Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384EFC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 19:33:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1EBD4B130;
	Wed,  8 Dec 2021 14:33:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ategQqowbevn; Wed,  8 Dec 2021 14:33:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8564B0B9;
	Wed,  8 Dec 2021 14:33:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBD0E406E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 14:33:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U-UNBHTOgnRS for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 14:33:04 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A47B4B13A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 14:33:04 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 l6-20020a05600c4f0600b0033321934a39so1729228wmq.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 11:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=orQ7ZF16VDHAO9DX2FGNmm5JMj3bbdSygx9yBqTArn4=;
 b=ffJo8eB8eiaDtL7uQagzdPht9HIHgtZYAGLHtiiBnJIW34eX3C6+Ze22M9ddJ/jSis
 PWruhaZxKnI7JhuN2HMCifAshRxTZV5gvCbn2Yj1CNSasgFwQrodUajtCtlhKDteSrok
 CFrCFadBY7Ji3kKQkhitoJsum5TjZAKYJQKXimCQoGqdRL4Q/mDrD2nrUmI2c5ch0YCY
 Ur1nvnuy5A5Xv7bZN44i7IDgab6EVC73hMQCNVYGwSrQrhMofx5A0mAoZ4ctCjzfiXov
 +TE5ZH1l1m0VyckaHrLF3rZtEKviYj/F3NTXzS9P+qMSabBuylrLWH0z2YGR8UjYAGFK
 LAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=orQ7ZF16VDHAO9DX2FGNmm5JMj3bbdSygx9yBqTArn4=;
 b=f+pE/EB5zVe9LIAszBvhcVGHN8A2P8nUZ5kRCbW4iIgCLLNOzw2fFDYSI4wgqJtv78
 Zh/ZSyUwqYtbGd8XcH8ShxWjLBZuXOaB5dWRDwKddSBnqPk0LLZUVcbWEecqUvEN/xCr
 nklCY/6pGxKYpaZkln7xO0R858blzuAVt9PYjdyI5baqYAR4gmI0idGeTWuTmtMuhrZu
 0kdssKh+M9HoD4L3KYuzXzt3iX83RkshsnnobgJJ+CtflStJtpsORehUwWWRa7LSahSW
 xnW4PTes/e3wd8pOT2C7aeMWl6QC6n70000CaaQ2rowHXzLFuG/N95bAdXsC9iyHkbvT
 hp8Q==
X-Gm-Message-State: AOAM533r032uM7htVK82APAjV+CMAwt7rKEV7IZUNAWF4WNPCGA2IxZd
 e/T890tbLSYfEUldaXaK6Z3HMKnyk+Dt1oRio3P5be/Z9lrKOdvxxiehxZNQEIuWfo8f++6+kEp
 B+WlUDlMYxYR4CzV5OzMqfPuYNC/IQHuS5MFfSdWrc+OArYWWTflHTTbX909A4wMl8Y8=
X-Google-Smtp-Source: ABdhPJzeX6cNyXAhhWxHk+ELyMhYU6ymc16HB+V4NE+ybFUaPtepGEtWrtn6S9EM+E8R9BQZbtBBgC/YVg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:4d8:: with SMTP id
 207mr783884wme.23.1638991983807; 
 Wed, 08 Dec 2021 11:33:03 -0800 (PST)
Date: Wed,  8 Dec 2021 19:32:57 +0000
In-Reply-To: <20211208193257.667613-1-tabba@google.com>
Message-Id: <20211208193257.667613-3-tabba@google.com>
Mime-Version: 1.0
References: <20211208193257.667613-1-tabba@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 2/2] KVM: arm64: Fix comment on barrier in kvm_psci_vcpu_on()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, will@kernel.org
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

The barrier is there for power_off rather than power_state.
Probably typo in commit 358b28f09f0ab074 ("arm/arm64: KVM: Allow
a VCPU to fully reset itself").

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/psci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 74c47d420253..9b82d6878aac 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -109,7 +109,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 	/*
 	 * Make sure the reset request is observed if the change to
-	 * power_state is observed.
+	 * power_off is observed.
 	 */
 	smp_wmb();
 
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
