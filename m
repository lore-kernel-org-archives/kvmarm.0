Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0160C47257
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 15:45:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D8DC20746
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 15:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="p0GEzJWJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D8DC20746
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96DB74B276;
	Tue,  5 May 2020 11:45:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 07KOaCZa2u8N; Tue,  5 May 2020 11:45:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A26854B27F;
	Tue,  5 May 2020 11:45:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C62CC4B26D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 11:45:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JiieNTFyiUrj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 11:45:23 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 983D74B269
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 11:45:23 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id fe18so2601624qvb.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2020 08:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=DRQlRlFg9/YXW1K7HeMg/XHQoMMIT+SlW9vP0SsWr7I=;
 b=p0GEzJWJNTroc4p3pE+lx6A5ZC4ik9pzu3TrrG2axN0guVE9rRDYiXuNiSHBgx+7Sz
 Pk0nfnorzFdsSK/o59EqF40RcooZhDwwcJTtBD1OkbMwrJLRgeyiFbd4U5MQqpzu7GRZ
 SR7h5SgfDPKBpaRUlwj1teCv7AEsJDM65W0Bo0YN/8KkqAjtvWcV7dH8TcJMkPYekPde
 fFIOAHdo28Rp/JZdc02YpWaCLyU0jCD21wIXe4bE17cU+bcIfYYycXpQ+vaULQSjMR3J
 nCqFhuGTaE2OVOaK4YIaARP4LEHPiRywZp+wi4iG/s0usIie9WVzepwKfejIKkzU23FH
 LEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=DRQlRlFg9/YXW1K7HeMg/XHQoMMIT+SlW9vP0SsWr7I=;
 b=eqoYGtgtBedcTYzyrgSUBDcpO+DZhXx3bUmNBLq2igCsWLEXdczT0OGyr/AUCsJvcP
 JL+ndN13Y1wAhzjAQInNcQ/+vGw+BOZ1UpLnjHI6cfJ9Je0axJbWxUprGhDGx+UOImsb
 OvDgLZkUBUchGDJSsIJexz2ddQIcvytbN+q0DJaP2xvRvJ8xkh3lPL84zcrQwnS6r1fF
 hm/80Vm+Lq/pVvP9daRZz2qI2i8jUJI4Hj3IVzZOzVlnNavy8DlP8Xv1OQdW6c1sCNRd
 eQOXWshk2LoFzZtJdMdr49lnHwBiQiyvyTh7IFRwxtzBcVI3uWaSwLxTpAVFr/JYvCbc
 Z5Ug==
X-Gm-Message-State: AGi0PuZ5RbRxaXQAKnVHGInNIGkYYsl44oynvnpKUzeiAPsxu0lpU8bn
 zuYzR6zClI66vZNFA3DTyQ0VKiF3Xw==
X-Google-Smtp-Source: APiQypL4EOWRuSkSToyaq9+Ev409Duk0bBnAsjvTrr/siToyzx7DCiUtkOSyMV+OtYjEgaL+THo/tyMPXg==
X-Received: by 2002:a05:6214:18c9:: with SMTP id
 cy9mr3353718qvb.35.1588693522995; 
 Tue, 05 May 2020 08:45:22 -0700 (PDT)
Date: Tue,  5 May 2020 16:45:16 +0100
Message-Id: <20200505154520.194120-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH v5 0/4] KVM: arm64: Tidy up arch Kconfig and Makefiles
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
for consideration.  This series is a refresh on top of 5.7-rc1.
It depends on Marc's kvm-arm64/welcome-home branch [1] plus the
fix from Will [2].

Changes since V4 [3]:
  * Restore the KVM_ARM_PMU conditional for pmu-emul.o

Cheers,
/fuad

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/welcome-home

[2]
https://lists.cs.columbia.edu/pipermail/kvmarm/2020-April/040336.html

[3]
https://lists.cs.columbia.edu/pipermail/kvmarm/2020-April/040346.html


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
 arch/arm64/kvm/Makefile         | 42 ++++++++++++---------------------
 arch/arm64/kvm/hyp/Makefile     | 15 ++++--------
 6 files changed, 32 insertions(+), 53 deletions(-)


base-commit: 3dd059fcb44bae19f503377d14d7afff0a1ea229
-- 
2.26.2.526.g744177e7f7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
