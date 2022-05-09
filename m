Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4877EC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 12:03:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 003134B2E6;
	Mon,  9 May 2022 08:03:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s1pgCyX7R5xB; Mon,  9 May 2022 08:03:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 253764B2EB;
	Mon,  9 May 2022 08:03:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA38F4A36B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aX9XH89xJ3aN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 08:03:41 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D1494B2F6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:41 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 v124-20020a1cac82000000b003948b870a8dso1951926wme.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 05:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AP8BJD+QDHGic4f82rKNyxQyu5IcsR8wiJftz0kCt7w=;
 b=W11ZAb9BcG9FC5CiXzLMy3NvRJU0fY73utyk+2sxKwqh7oxt0JGbE3o+2OqGw1ZP7B
 Snzx+FZjjyoeeWvqA2rDLmWvt7aHk3+GdNkPuiMDfTMCXY5en2gPKcqaI345EMLz5HN3
 y/+BRqcIBawmTf6NMgUCFRt59jv97GtBRALFDfQvPLCdm0AveeEAmUG87L+hxhr5w+F7
 wL1mo2lw+xOLv0NDTJ8K7/F39Y66HNLIye1wupFitjjnlQ9w3KAbg0HFU7tcw0RgddO4
 E0ahmiWGfdDIb19XCz4vqt0pCSVBjuaAfaOtHNc3XDNXDbvwNl5hamcVeRca7l98CTEj
 bUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AP8BJD+QDHGic4f82rKNyxQyu5IcsR8wiJftz0kCt7w=;
 b=CBzAE+xXH/z2XMufSlC04n+gwBDw7de7Eqp+uWlKwfl8EmlquG44yQoS8b4/pmAglf
 cG+gFtO+qEDyv6EzDA9aXOkaEeNAX6bPOVbuaDNbp1Kh5EwMUSiK02j0hPDHpYQNmezl
 tshc8jKyu/ttwx/78/qBDMqrSaCGRxkJ1Vmrpr4CpyLnOPgmtzmlIiRU9MYvNvmegUc0
 4MIKCh44BKoZvVVCCMp4qKfGsfvEgc3TFkDeSrgg+H6cI8zC+0QUByoW/GDeRDWVj/Xd
 Jpgxlx9wzSIhla2Zq+1Ag7mBwPM6noX28pYALlbp98sBfaYoKp0kUIs4cElfHL8htgcD
 7OXw==
X-Gm-Message-State: AOAM533lAk7O+oOK0Ax2uH5wuNhbohadPIzx8SXukw/uBng6RvhdPVIE
 +IEccfa455ngV/2Zg+NHiorF4mnRZASZShxe4tcD03xWZjm5PrkFRDLLVdOWiwSjNu+RsC29PHO
 xNLH9IaMuyKS7LNX4WNFPLzCyhryjhCNHMt92kWTDId4f3CDC0L8ptX+5/m6GA0aiGhI=
X-Google-Smtp-Source: ABdhPJwemWETEq1o00ZMXUdhOoB7QdauU8SdFbTVGnRprJ6KJ0RRhEQq4CvyqFrJFc7AIjTkqjO43sRKhQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4e51:b0:394:513b:934
 with SMTP id
 e17-20020a05600c4e5100b00394513b0934mr15673131wmq.164.1652097820617; Mon, 09
 May 2022 05:03:40 -0700 (PDT)
Date: Mon,  9 May 2022 12:03:30 +0000
In-Reply-To: <20220509120330.3043773-1-tabba@google.com>
Message-Id: <20220509120330.3043773-5-tabba@google.com>
Mime-Version: 1.0
References: <20220509120330.3043773-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 4/4] KVM: arm64: Reenable pmu in Protected Mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
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

Now that the pmu code does not access hyp data, reenable it in
protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3dc990ac4f44..11c43bed5f97 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -774,8 +774,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
-	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF ||
-	    is_protected_kvm_enabled())
+	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF)
 		return;
 
 	mutex_lock(&arm_pmus_lock);
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
