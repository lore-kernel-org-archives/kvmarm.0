Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105D6C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 998A8610C7
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 998A8610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49B4B4B0C2;
	Sun, 10 Oct 2021 10:56:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6j0g9-IwFGx6; Sun, 10 Oct 2021 10:56:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8674B0DB;
	Sun, 10 Oct 2021 10:56:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F5BF49F5F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WpZxZDd5eMgv for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 10:56:43 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F7994B0D0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:43 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 t15-20020ac8588f000000b002a777ee14d0so4341512qta.14
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 07:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2yxyszH2o0l7PmvxhJ6rJ+q2kN5pLUdYHnvLPGFqiZk=;
 b=T1apfSHiw0BEncB76X8A+leVkZjV5dDbjRgeJHlBhIbdjj2bwXGzl8IWHzCFzzg8FD
 tJyqCZ0TXhV1qEqmZ2+ldqCD6ABEh8d6In2njfTxPpEV5PJw8TA17PBGyCYqIBcKnTiT
 viT3TiZb/hUlhXGayVK5f9K0fTWc4MAzb8tCI/uVcmNFeTJ56BoWIUMpIHCad8UAWeO7
 kMVy6jmhuOKR+sP6odiKul8y/ToG3qSw2IEGC7GdcgcHg1/52z7eC1+R0/3bh14+m6YD
 s6HvrTz2NXnD5f0CenqdeA4ewPA81LYej1N3zS+AvIZ0hLag6ag1YvEZcFdEYxRw1C6n
 ZTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2yxyszH2o0l7PmvxhJ6rJ+q2kN5pLUdYHnvLPGFqiZk=;
 b=2bgsWbN7zEjrxuRX4DlQs5+20wH7nOAKeilFV3Aj0De+yQL67pH28zW1PWTmZHXJ9S
 jB0QS0ywSFCmJWGgN54ph+18HzJHGJkF6HQbL7wqcM85aarj1Ush4ijsjK6b9U0T6MZX
 6/Lu3Mh2Va6n39rJ+pto68FjjV91caNtmOBaWTOsYWsgeRPg8hvxMbetO9JgBxxmEHKh
 G+rg1Q6eitXWCl+L9fwDBKeD6peBvjyoYfT2G5cU9PNloevRqCC93biHLkqKwDFNgkqZ
 mtVDQCR60+RJPkoPWL6I8lxia7K4AWSVTfyxM26ZOk1bjrjWL5HuW2rOIy8d1P5qNc9Q
 5vNA==
X-Gm-Message-State: AOAM533czcgbmGKBxDvQZUqq0tltmXMqVvVJapommyrx+B+VTxpH7xd4
 V0BfWk7Rhb6O5vqqyROOANAO4lZYP8jlb4Lxqfee8u4UIskyk7rppQ2ibVeBDQRfBlkdNr5C/lV
 LCSpjwVGo+ujFcCHiKj0CW+wpYapqK6Dg0bzGy4DkFqkbxwW4jb3O3GPC3BdlNr0lM5o=
X-Google-Smtp-Source: ABdhPJzj3B4OpNfjLvAOsVB/XzS3C09XWa44/mwOZkz7b4EAq/m+irtZsK0VzwPEfzObqrs9x98Hz993Ow==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ac8:5bcf:: with SMTP id
 b15mr9860202qtb.178.1633877802740; 
 Sun, 10 Oct 2021 07:56:42 -0700 (PDT)
Date: Sun, 10 Oct 2021 15:56:27 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-3-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 02/11] KVM: arm64: Don't include switch.h into
 nvhe/kvm-main.c
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

From: Marc Zyngier <maz@kernel.org>

hyp-main.c includes switch.h while it only requires adjust-pc.h.
Fix it to remove an unnecessary dependency.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2da6aa8da868..8ca1104f4774 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,7 +4,7 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
-#include <hyp/switch.h>
+#include <hyp/adjust_pc.h>
 
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
