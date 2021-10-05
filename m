Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D70DC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:02:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 101AA6137C
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 101AA6137C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A62B04B2F7;
	Tue,  5 Oct 2021 05:02:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QBK6HkvXY21a; Tue,  5 Oct 2021 05:02:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CF9C4B2B4;
	Tue,  5 Oct 2021 05:02:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8505B4B2A7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:02:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zZdkeebLWVRP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 05:02:49 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8ADBF4B267
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:02:49 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 k1-20020ac80201000000b002a7200b449eso10965766qtg.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 02:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BRCd6xIpsgQc9eCz6F1JrzlncYMqd0ZDK8+iJvlZVJo=;
 b=eoms1aGPDoZgsVnFaKlK88PDymci86vDBDF+xpLuhD4qRv4yjbK6MS+XMDcxmX2mhT
 fgbaP9dV4z9gdlvq+7Qnj7zD1fNCJvMC5gBV1BQ5bQj+CJg/A5BDHLJfzKr7juldFle5
 tqsKSX4WAyBid12mJRJ5+InxIOS9kOaooUAC7ZFDWD6MaU/IdxKsjHTHteTc/0qdf7CF
 yDapp7qFLhC2XJRz2ybl+Gu9J1TAiKjekb85hy6ruk7XqutZ/OFku32TSh39dY0ycTpk
 nrfZWm0ri8fofKVYDANqtE9KNlYx3xv7i4BOgCgUTMMSdNZYhGPd5rXVs+GA4fnKlIUG
 1Zww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BRCd6xIpsgQc9eCz6F1JrzlncYMqd0ZDK8+iJvlZVJo=;
 b=u1pad5vApvCqlKORLsL6rYMdOSTADaiER9wFHYjmbaS1cFQ1w05amcc0+FO0lWvw9j
 W9fDcUI61U6ZZHnzEtYcVLEpnmckPGDsH02pGTH8KkWLMUfQrMP9KqZ8q/WM7oFnhD9f
 8fQzQ0dtdbxdHU4IdQFSw9Z+QpXJ9195sV7P/CjHUtm0kC9dD/kI1ZbVBDyrWqGWU9LY
 IIP0st91regc6egJdXI5sG99Swpe5AXdZ24/4RC8LLDdLPKr3p7CcXBQkkMLhmatooUI
 XLV0w68jzzKAE0EcSowi3HgIKMoFz2smGUITpH6drOTNqH0ssNCTTBC8IrvDbEZvBRvH
 HQpw==
X-Gm-Message-State: AOAM530wXzThE7Nb5eeMgazIxOZgppfH7PVRAPwE/zqjH/x7DdD3umMI
 CXU4bgwOVhiTI+3rYpoZBarvuGdXrjui
X-Google-Smtp-Source: ABdhPJxxbyIyPiVtJmWA8AbltOJZ3/N/M8K+WP9ITkiGix8jD8rU+MjhGEj3spZgJYPGfDeZ5XI8MbtDYdpe
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:5700:9128:3106:b389])
 (user=qperret job=sendgmr) by 2002:a05:6214:11a5:: with SMTP id
 u5mr6027804qvv.39.1633424569158; Tue, 05 Oct 2021 02:02:49 -0700 (PDT)
Date: Tue,  5 Oct 2021 10:01:40 +0100
In-Reply-To: <20211005090155.734578-1-qperret@google.com>
Message-Id: <20211005090155.734578-4-qperret@google.com>
Mime-Version: 1.0
References: <20211005090155.734578-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v2 0/2] A couple of EL2 refcounts fixes
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
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

Hi all,

This is v2 of the series previously posted here:

https://lore.kernel.org/kvmarm/20211004090328.540941-1-qperret@google.com/

This addresses a couple of issues Will has found with the refcounting of
page-tables at EL2. Patch 01 fixes a nasty bug, and probably wants to go
in -stable. Patch 02 fixes a small inconsistency which made it harder to
find refcount-related bugs at EL2.

Changes since v1:
 - applied Acked-by from Will;
 - better comment + commit message for patch 01 (Marc).

Thanks!
Quentin

Quentin Perret (2):
  KVM: arm64: Fix host stage-2 PGD refcount
  KVM: arm64: Report corrupted refcount at EL2

 arch/arm64/kvm/hyp/include/nvhe/gfp.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 13 ++++++++++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 15 +++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
