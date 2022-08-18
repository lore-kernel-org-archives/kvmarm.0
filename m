Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7638FC32772
	for <kvmarm@archiver.kernel.org>; Thu, 18 Aug 2022 14:09:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B94B04D81C;
	Thu, 18 Aug 2022 10:09:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tf8kOvVdrjNO; Thu, 18 Aug 2022 10:09:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A1C4DC4C;
	Thu, 18 Aug 2022 10:09:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D8524D81C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 10:08:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NPsqwfSfR5no for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Aug 2022 10:08:58 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37FBD4D7E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 10:08:58 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D9B1FB821B9;
 Thu, 18 Aug 2022 14:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886A8C433D6;
 Thu, 18 Aug 2022 14:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660831735;
 bh=X1Q1sXj76atg/ztMAloIPiEyVV7Q9AK3llXhBBs0MmA=;
 h=From:To:Cc:Subject:Date:From;
 b=bo6wLDFENY/dx4DUWVormN+6hJ5A9pYQFMzpjuywKvF4lhCF+9O4x3tMACBV/BR3m
 e5TiY1hNZgAXb0IE1gePs0l4oShBGznPAUEDn/47qxNSqBAGSnbQ4LApjarbeeCC+4
 UuzzNcQAeNuJdPt5EV+Q+ztevu97V6mtbz6PlBfjaoT+3uxr5htsyLqoFRX9iyb7oe
 LfKQwU47K+rMc5ZHoN/GSKYZpcZqsO++RO34SjYhRaupsqeu5J5tJwA3aRS3kZvsWa
 VU2npwUtwjPxFtW+KFfVL3Z+HZrWQFuHisn+pCtqx27bmugcKoY9kS1B1kr8jzEGo+
 z7rAGjyS04eRA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oOgCb-0040U4-HY;
 Thu, 18 Aug 2022 15:08:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 6.0, take #1
Date: Thu, 18 Aug 2022 15:08:44 +0100
Message-Id: <20220818140844.2312534-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oliver.upton@linux.dev,
 yangyingliang@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Yang Yingliang <yangyingliang@huawei.com>, kvmarm@lists.cs.columbia.edu,
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

Paolo,

Here's a small set of KVM/arm64 fixes for 6.0, the most visible thing
being a better handling of systems with asymmetric AArch32 support.

Please pull,

	M.

The following changes since commit 0982c8d859f8f7022b9fd44d421c7ec721bb41f9:

  Merge branch kvm-arm64/nvhe-stacktrace into kvmarm-master/next (2022-07-27 18:33:27 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.0-1

for you to fetch changes up to b10d86fb8e46cc812171728bcd326df2f34e9ed5:

  KVM: arm64: Reject 32bit user PSTATE on asymmetric systems (2022-08-17 10:29:07 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.0, take #1

- Fix unexpected sign extension of KVM_ARM_DEVICE_ID_MASK

- Tidy-up handling of AArch32 on asymmetric systems

----------------------------------------------------------------
Oliver Upton (2):
      KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
      KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

Yang Yingliang (1):
      KVM: arm64: Fix compile error due to sign extension

 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/include/uapi/asm/kvm.h | 6 ++++--
 arch/arm64/kvm/arm.c              | 3 +--
 arch/arm64/kvm/guest.c            | 2 +-
 arch/arm64/kvm/sys_regs.c         | 4 ++--
 5 files changed, 12 insertions(+), 7 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
