Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7F5C352BE
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 14:08:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7012C21D6C
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 14:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="HyVnhYSo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7012C21D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 194FB4B282;
	Fri, 17 Apr 2020 10:08:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mUtwe0jxOdfN; Fri, 17 Apr 2020 10:08:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2676D4B21B;
	Fri, 17 Apr 2020 10:08:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A1C44B277
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 10:08:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yMaJSXsKxD5f for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 10:08:32 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70C724B1FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 10:08:31 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id d17so1044108wrr.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 07:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rDuNKPGRL3vlZnVh4lYSsVCxAOT22UOYZHuPQqCxKfw=;
 b=HyVnhYSodpFC9ONtMniUJYW+EBgkEJnMYrmfWcNBaVeMrT7X+sJh14v8Iy43rWuiOx
 Bj9KfdCYh9k/LO3kTbnFuCA+kNE7ccKn83eSehfoJPlwhODV/ozMa3ZA8jN5oGjJpoil
 8T6KguAr2zureocNRnxfyiqncnBE7fxriSuwu5NXobC9PQTK/gY0TxYtzhfnHD1aqRfv
 e3ztNBsl9EGCdXfnL+xs+XFXwQgghG9HHKvUlAwZeNzyy7Cx9q+vhUVC2VMoO/4OZE0H
 4Ni1FX2CEosehfnPOxmWyZwncTyKhZFc3HJ4ZEUm38S0fpHSdHAXsKX1XGyghNBxFlAD
 5Kcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rDuNKPGRL3vlZnVh4lYSsVCxAOT22UOYZHuPQqCxKfw=;
 b=mZeBdmDENpWC7nanUgIeKf0SqQ2x4Bb069kulUIuwtL/ar7CP62ni+zd7gcHiIApJt
 c33V1MXUVDlu9576qZd9HwMQCypphkS/Ya4XlnVPfFJEXX0o9V1X8a50RRg9QKbJiiaP
 tvjCF88k7iLFE2HKtLY9tHmBFjuAyIvczEkAuC3qPjGDU8OrjbooKyaddbuXzCidNkgo
 JzHlQp51JBfHoI/pMdo818jSPxHg+I6gfryRQqLApIY9gjpIkQgQ329aTMICQyBxc7xh
 C4pRAAS0zPgnsIvOrOBKTz6ZGYyM6VR6gRs8sXbtEqPkXYpa3X5ibhF7BADmdZafzGle
 U+Iw==
X-Gm-Message-State: AGi0PuY/0mCuPGNfEE4e5VHzDiiCjjzL0CP080Xw+rjqSf3rlyyZGiZw
 +cvl7VFWDkqOWr6t63p/SuBrfMabSw==
X-Google-Smtp-Source: APiQypJ4PzEFjiF2vrW2052UAVnDFyRCr+vwkd+/PLK1xOhWz8vhglIccJvHJgW0zDyqvAUtWOmST4TCdA==
X-Received: by 2002:a5d:6305:: with SMTP id i5mr4223977wru.203.1587132510446; 
 Fri, 17 Apr 2020 07:08:30 -0700 (PDT)
Date: Fri, 17 Apr 2020 15:08:19 +0100
In-Reply-To: <20200417140821.89974-1-tabba@google.com>
Message-Id: <20200417140821.89974-3-tabba@google.com>
Mime-Version: 1.0
References: <20200417140821.89974-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v3 2/4] KVM: arm64: Update help text
From: Fuad Tabba <tabba@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, julien.thierry.kdev@gmail.com, 
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu
Cc: will@kernel.org
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

From: Will Deacon <will@kernel.org>

arm64 KVM supports 16k pages since commit 02e0b7600f83
("arm64: kvm: Add support for 16K pages"), so update the Kconfig help
text accordingly.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ce724e526689..d2cf4f099454 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -44,8 +44,6 @@ config KVM
 	select TASK_DELAY_ACCT
 	---help---
 	  Support hosting virtualized guest machines.
-	  We don't support KVM with 16K page tables yet, due to the multiple
-	  levels of fake page tables.
 
 	  If unsure, say N.
 
-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
