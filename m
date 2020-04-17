Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB30C2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 13C08214AF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ZSwVBF6J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13C08214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8808B4B282;
	Fri, 17 Apr 2020 09:58:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WzGtbVnWanRs; Fri, 17 Apr 2020 09:58:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94BFE4B277;
	Fri, 17 Apr 2020 09:58:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B4044B195
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zw5kXL58mcDw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 09:58:06 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 067BA4B104
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:06 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id u11so843799wmc.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 06:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=BE22UuNZU0lMhx6IeWqx8rVDm7BRVLiiw4JmHJTk0D4=;
 b=ZSwVBF6J4AQZ7yydntt4yyCWz/fGouqOKl9YHHlmhXf2iF/B4Q+j5Hjpqu53HOTiCc
 LjHK3hkECEDasXULKMnSJjTIQryndW07HR8+JzsdVPE1As2EoL5FS+gcjP0z1L2NUpYL
 cyFnMSKVsATKHDYo80W/2UDHGSZSh0mujoZbnAdjsjABeMmHajR30e4HJBg76dbx5L4i
 Nfud0IGvhEZYKtXAuBo0NWZjJBnyJH7NKjHBUUJ4keRJp2Z5mQPWu6idlcM6FpMsmxvX
 /rSRCjlv5MzJOOjQ4oUBrc7kVGFFxg1JJ8Ia5Qpl1j6kM0nNyrDeIGdMGlA6AB9Ujs7F
 7uBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=BE22UuNZU0lMhx6IeWqx8rVDm7BRVLiiw4JmHJTk0D4=;
 b=A7ZAyLzPGKUys+nkXfdS49qlU1fbKwR7jZdLTPRSdnzib3SNQ7vApBED7ZuMuEsqqU
 6Nmjvc998eCppOLYKvnFmOt7nbQhDRKPRun6UmimSrQXnX9QsRat5lzyTcIi18XgS3hT
 0NWZiFey0DuF/Ru7bzoyyZsl8o+TIq16fxMwCnrrPaPexBGuLO3A5L+7rrMUJG0tLMVu
 MqwjL/eAOM6oljSBvck+X5ZHKhUcE//lN2l3JwdxoKEoW/ULn5jMc0v/3QCelOiSPmOo
 vTkVHWr9fDu9K6Yp8rnhawWRlrp7vXiwWN+59Dxm5tZpwxv/aZdfJRSENTjOr/Hg8Sav
 969Q==
X-Gm-Message-State: AGi0PuY9OEiqlYsAsOmInObMKJujyBjM2BsLdqY7CFm9bJ0BaAiabrql
 acQnZdcYedUwVWoSk/bjLjongxi8nA==
X-Google-Smtp-Source: APiQypLVq8o/IyJ2Ph8/8zd9ktTRVOFs3zfH1IjqmzLibNqh0pzPVFwaLqK4mYaxxqwQEI5OE7GVeltkjw==
X-Received: by 2002:adf:cd84:: with SMTP id q4mr3817248wrj.320.1587131884713; 
 Fri, 17 Apr 2020 06:58:04 -0700 (PDT)
Date: Fri, 17 Apr 2020 14:57:57 +0100
Message-Id: <20200417135801.82871-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v2 0/4] KVM: arm64: Tidy up arch Kconfig and Makefiles
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

Hi,

This small patch series tidies up the arm64 KVM build system by
rejigging config options, removing some redundant help text, and
consolidating some of the Makefile rules.

The changes are cosmetic, but it seemed worthwhile to send this out
for consideration.  This set is rebased on top of [1], which moves
the (now arm64-specific) code.

Cheers,
/fuad

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/welcome-home

Fuad Tabba (1):
  KVM: arm64: Clean up kvm makefiles

Will Deacon (3):
  KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
  KVM: arm64: Update help text
  KVM: arm64: Change CONFIG_KVM to a menuconfig entry

 arch/arm64/kernel/asm-offsets.c |  2 +-
 arch/arm64/kernel/smp.c         |  2 +-
 arch/arm64/kvm/Kconfig          | 22 ++++++++---------
 arch/arm64/kvm/Makefile         | 44 +++++++++++----------------------
 arch/arm64/kvm/hyp/Makefile     | 15 +++--------
 5 files changed, 31 insertions(+), 54 deletions(-)


base-commit: c9346fa274ada428631ded07eaba696cdf99ce4e
-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
