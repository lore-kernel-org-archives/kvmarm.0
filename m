Return-Path: <SRS0=wisL=6F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F09C54FCC
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 13:17:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C27B2076C
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 13:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="mdvrpxPd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C27B2076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F9EC4B137;
	Tue, 21 Apr 2020 09:17:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pHXvSFs9eWXT; Tue, 21 Apr 2020 09:17:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B01DF4B13D;
	Tue, 21 Apr 2020 09:17:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CE3E4B113
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 09:17:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yICHl8IG+ppL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2020 09:17:38 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 256BB4B111
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 09:17:38 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id f15so7514715wrj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 06:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=KensP4VfNbiSi+18/6T8zqAkG12sprIkzUnc1TbyDWU=;
 b=mdvrpxPdXxxl86V2uzaKRpsXev2p8SUs1Yo3iqDAiYbgy9AQDQ8G6AKVmwsL7qSe4K
 CnOn/y9Ji8v6OSyXY31cIH6l818wfoZRH4uYjFwQBzCPNg2BS1vRtN+8pK0zUfp/40po
 UQQPzSUYs/+0AXSHUgEuGaQeEgMx3JJQk8k1D2DeuKQtfuvEPcFV0hpCMCCVAaX5WhDx
 P3FM9UKx+Shwcvb6iYhZPLcRPPQ8CV7hckv7yl43JO0occllYiO/boZOmKxlmN2sC5eb
 6O7l+WGT6mo6uZL3TWKNhKnV2mWKGW0B81ZfcibyBgafhFlIUa6vZXgTiKVdZ3aW1Eo8
 z4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=KensP4VfNbiSi+18/6T8zqAkG12sprIkzUnc1TbyDWU=;
 b=Oz6AcU5iSOHl7p1d8cRUa7X+0CGLd8KGafZ7KqX49zcMZqTNWr/a9uV3dSVvF3cmYb
 ul0Wb2kucnWtymCRGoK0VhbAVzjVJEibb6D6ns4nLvEnsQF3aiAFiEIXhFp+NDKvo16Y
 0dOrw/6TPJM32a2l1TtPJrVhOJQCbxNnpHYba1dTq53FnBSqRKldJvGK/4woSGPkRkYs
 1XFiTEjMDh/WnZ9fLSFCgXDbGmqliH0a1ggAabeNeYzoOGWlgR1+UYedSmU7Mokgez9I
 T1GGOv9OPD3TIm1VuULHji8nOMWfAJuESrQVRlfL6ABWG74NlzB1D0qqS1/V7F8IhGlD
 E9Sg==
X-Gm-Message-State: AGi0PuYK1SIaWIehgfUVNx4lAXZYiGXuw+s9KCti6G8SBeaAaBH76HQu
 W7sWKzNMLLSzpz02L3xQ++MIAP53nA==
X-Google-Smtp-Source: APiQypL6yrDf4o8Oi+hh52WWFhEsJUjPTVFjvsnRtEsGi8HhDfS+h3IRnQ4UQoP9fEKvsdAo1LXr4cKyww==
X-Received: by 2002:a5d:480b:: with SMTP id l11mr26374022wrq.25.1587475056933; 
 Tue, 21 Apr 2020 06:17:36 -0700 (PDT)
Date: Tue, 21 Apr 2020 14:17:30 +0100
Message-Id: <20200421131734.141766-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v4 0/4] KVM: arm64: Tidy up arch Kconfig and Makefiles
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, julien.thierry.kdev@gmail.com, 
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

Hi,

This small patch series tidies up the arm64 KVM build system by
rejigging config options, removing some redundant help text, and
consolidating some of the Makefile rules.

The changes are cosmetic, but it seemed worthwhile to send this out
for consideration.  This series is a refrensh on top of 5.7-rc1.
It depends on Marc's kvm-arm64/welcome-home branch [1] plus the fix
from Will [2].

Changes since V3 [3]:
  * Rebased on top of Will's fix [2].
  * Added S-o-B to patches written by others.

Cheers,
/fuad

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/welcome-home

[2]
https://lists.cs.columbia.edu/pipermail/kvmarm/2020-April/040336.html

[3]
https://lists.cs.columbia.edu/pipermail/kvmarm/2020-April/040288.html


Fuad Tabba (1):
  KVM: arm64: Clean up kvm makefiles

Will Deacon (3):
  KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
  KVM: arm64: Update help text
  KVM: arm64: Change CONFIG_KVM to a menuconfig entry

 arch/arm64/kernel/asm-offsets.c |  2 +-
 arch/arm64/kernel/cpu_errata.c  |  2 +-
 arch/arm64/kernel/smp.c         |  2 +-
 arch/arm64/kvm/Kconfig          | 22 ++++++++---------
 arch/arm64/kvm/Makefile         | 44 +++++++++++----------------------
 arch/arm64/kvm/hyp/Makefile     | 15 +++--------
 6 files changed, 32 insertions(+), 55 deletions(-)

-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
