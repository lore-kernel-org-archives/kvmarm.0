Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0769FC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 08:41:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1A2240B75;
	Fri,  8 Apr 2022 04:41:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qUicV6qgobwr; Fri,  8 Apr 2022 04:41:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A5EF4B175;
	Fri,  8 Apr 2022 04:41:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F061E40B6C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 04:41:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0V4Q+tMcg1ZM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 04:41:02 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBA874B15E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 04:41:01 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 s13-20020adfa28d000000b00205e049cff2so2022172wra.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 01:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Qfv1bEj/1FaZXZU3R+WtmBHPG36iPZiljshgmhtHSRY=;
 b=q/pdDMcK5gprrylAUTYuOJZsZkavUx9FZWlr6Hs4uzxrrgeJy35Zd+3fz60kJpOjMu
 dzbOB6q+f7xOq/kVh4PY2Mxr8iSJR5mFtc2hS3ixQy6nq0jWtNz/7x4mBeErP9DBsydD
 JLTWEWl9IT91vQUdT0mvUJMnPOil8xbOOWLJCDAItOiZ/+IRQpJVx3/THcnT+pGaRtuF
 ybDszdnnKKI0vbUzcs90ztabWpRLnf93OJRUDyI/OZSCUaGuA3wv+Cmnl9w+K7LRojNH
 5cszeXqxYCftWDslzXHt+RB9+227nWxefKDyCW3kn/UeoBlaRF+nD/ECzBghKNdn/BAr
 zkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Qfv1bEj/1FaZXZU3R+WtmBHPG36iPZiljshgmhtHSRY=;
 b=t9P/SPj/1+tCH+KUE2e46fso1qzbKiS3j1oe1IGTtyLu0+iH2mSVLo4LTIhtGhG9pp
 q5D0Jh13BYbviN5TWTVk9Nd+xBFWBryRXpqW9AO0ruHWOmXdICKAvj91dVI/Gkgg/LGB
 3gQlpVon5jyqJS4e/gRaQq1ThhwZRILP5W8VXZBuBLlDTZCcbdV3zAbF4VHBmfJnJBHh
 nVl7y4zW10uYwM9+CXtXHMYR2nXaPwTEF+Ippf7lVxKyQLelXXbGTFs2cTagnlFHF1Tv
 PHoyJOzY2omNrLdpqXTPC/OMAhTM05LEw3PhlCcJiPlORs3Kvh49TzaX/k1FGwuItnve
 V2Xw==
X-Gm-Message-State: AOAM533mDegXTl/K3dQEWe2C3UCQIDQaUMNZBjwO41eZmrlM79OIxlsI
 AR9O0Gxl/dwawE53aD5RQpwAsFUv9K6jsolIIyY+aNEo6boMt/YCAHND0GAsXnZ40NRsRgMv1dd
 J/4+jF6W0GAOECrBbnS59Z5UlNXH8MRLhD0XRa8yWpl0kLeaYFGQyOYxNLhugPP6cI5A=
X-Google-Smtp-Source: ABdhPJwmyP1B7N90b76cR/52rVQeb/UL9ovxCWsDFhyyeP+/wTKdRHU8ZL4uAjL3dvwe4mBAIoTQowRf5A==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:4e92:b0:38c:73e8:7dcd
 with SMTP id
 f18-20020a05600c4e9200b0038c73e87dcdmr16307000wmq.196.1649407260887; Fri, 08
 Apr 2022 01:41:00 -0700 (PDT)
Date: Fri,  8 Apr 2022 09:40:52 +0100
In-Reply-To: <20220408084052.3310931-1-tabba@google.com>
Message-Id: <20220408084052.3310931-4-tabba@google.com>
Mime-Version: 1.0
References: <20220408084052.3310931-1-tabba@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v1 3/3] KVM: arm64: Reenable pmu in Protected Mode
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

No functional change intended outside of protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 78fdc443adc7..dc1779d4c7dd 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -756,8 +756,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
-	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF ||
-	    is_protected_kvm_enabled())
+	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF)
 		return;
 
 	mutex_lock(&arm_pmus_lock);
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
