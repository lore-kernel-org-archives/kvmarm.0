Return-Path: <SRS0=8enQ=NL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F66C4338F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Aug 2021 07:52:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9810161042
	for <kvmarm@archiver.kernel.org>; Fri, 20 Aug 2021 07:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9810161042
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A704B0C2;
	Fri, 20 Aug 2021 03:52:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c6lxelQYIvgR; Fri, 20 Aug 2021 03:52:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213414B0EA;
	Fri, 20 Aug 2021 03:52:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C2094B087
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:34:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rMKyDRj1HwaZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 18:34:12 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87EDD4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:34:12 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 r13-20020a17090a4dcdb0290176dc35536aso3113175pjl.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 15:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=bOOZsm5TnyY2OqO/UzAmnygEQIpds7n6pzsOsSOKjBo=;
 b=erQKmqzaST94afktv4i+np16BCzAXEK8mkPkEZqUXWbY2IpGlSRHpoHtvLy20knfB5
 MUa8wp5F7LZCR2p6/9cEOCAK204tRAaWU8Mt4CZxiiAEVQMxrttwaZDW2IVdfs5oStPm
 XNE8g1p4Pw2Zh408n+CKCdw7JRte0Yb3UZD7swn8yWDhv1GF87O20lxAJhlxkWVEKI8A
 EuDbz/VdjS8po5swSsNyTmYYrJ3WzOiAetCp4cz+HcHI3aIb3l/lGHcVuHh5lAFaRhf3
 AGGbkZ975qoY1uuyFtWjQ20PyjzCR2QDiQ/G7f+Xn3t+wH/tZIdPvlkEJUNuzIZajPnK
 I+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=bOOZsm5TnyY2OqO/UzAmnygEQIpds7n6pzsOsSOKjBo=;
 b=D3dkGYouUn5FSnBmx7nRyhAOiEvuXK7ip1chUSk2bMhMxUoAokoaZmTevLcle3YKr9
 F0GEpV0E7UeCAjWseyCsQMHFCYq6VYaHAThC3eSGIuQ3dV4PaFICgx2NyCPYsFy3HQTM
 Gq1fJfEwGJHISaur96yIyFRqajUYnnvmprG3/D+nfQAKVZtiezIZDU6myAGJPgHP6ef2
 Y5v7i2nQsBkLQigcPQh8XFZcEp9PkWhU50s4rbizeoagQDrG059M4qfpFG96Q87fM3ie
 Dbeh3czf9s/X1I/9SJotE6/KrehGQwM2/Tr8NzJtczOE05t+l+yfZZGB/QD+pN+IgQBl
 RhuQ==
X-Gm-Message-State: AOAM532Zb1GFUCtTCaPMsr4zjKIJlrZO+qldlONVbsL9I+IhPV9V1Pbk
 GOuWiZL24EnDiYyRU2QVVlebzOzxxTid
X-Google-Smtp-Source: ABdhPJznI71qPa7ZgpjTnaFxnj7Q9vZ3kYUNCCBWfozdXUGInR1VVtDc+5il7yJQk0NRx7nt4l7r7n7cAXKl
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:396:: with SMTP id
 ga22mr142795pjb.0.1629412451137; Thu, 19 Aug 2021 15:34:11 -0700 (PDT)
Date: Thu, 19 Aug 2021 22:34:06 +0000
Message-Id: <20210819223406.1132426-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] KVM: arm64: Ratelimit error log during guest debug exception
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
X-Mailman-Approved-At: Fri, 20 Aug 2021 03:52:30 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Raghavendra Rao Anata <rananta@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Potentially, the guests could trigger a debug exception that's
outside the exception class range. This could lead to an
excessive syslog flooding. Hence, ratelimit the error message.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/handle_exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 04ebab299aa4..c7cec7ffe93c 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -134,7 +134,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 	case ESR_ELx_EC_BRK64:
 		break;
 	default:
-		kvm_err("%s: un-handled case esr: %#08x\n",
+		kvm_pr_unimpl("%s: un-handled case esr: %#08x\n",
 			__func__, (unsigned int) esr);
 		ret = -1;
 		break;
-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
