Return-Path: <SRS0=tVNh=FB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D42C63777
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 11:21:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05D0F21534
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 11:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCn5yoOc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05D0F21534
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ED4A4BE7B;
	Fri, 27 Nov 2020 06:21:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V0DjMGslwj7d; Fri, 27 Nov 2020 06:21:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D34B34BE79;
	Fri, 27 Nov 2020 06:21:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B85BF4BE7B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 06:21:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oH+8SLYYHC7m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2020 06:21:22 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9767A4BE75
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 06:21:22 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0DF2420B80;
 Fri, 27 Nov 2020 11:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606476081;
 bh=fS6mF1IDPaTZHP4+FiQm7nj4O1emt6KtMrKo/Vv9QOc=;
 h=From:To:Cc:Subject:Date:From;
 b=kCn5yoOc6ucB2MaxXimiA11mtBW5b7w5jKlVWS+s12qCYG6LSHjmiqy+k2ejZBkv3
 XElrP4//E0eXdoRXTavH98gI/PnZRvEgzpQ4Y/ln8xpg4QBUKyoGXnql/wf9OLMk/+
 zBphLzrdbtGS3HJvO13T9ICBUY2NsoWmCV/Fr1Ro=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kiboU-00E2fR-Nq; Fri, 27 Nov 2020 11:21:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.10, take #4
Date: Fri, 27 Nov 2020 11:20:59 +0000
Message-Id: <20201127112101.658224-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com,
 eric.auger@redhat.com, jamie@nuviainc.com, zhukeqian1@huawei.com,
 will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Jamie Iles <jamie@nuviainc.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

Hi Paolo,

This is hopefully the last set of fixes for 5.10. We have a linker
script fix addressing the alignment requirement for the way we now
build the EL2 code, and a fix for a long standing bug affecting
userspace access to the GICR_TYPER registers.

Please pull,

	M.

The following changes since commit ed4ffaf49bf9ce1002b516d8c6aa04937b7950bc:

  KVM: arm64: Handle SCXTNUM_ELx traps (2020-11-12 21:22:46 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-4

for you to fetch changes up to 23bde34771f1ea92fb5e6682c0d8c04304d34b3b:

  KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace (2020-11-17 18:51:09 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for v5.10, take #4

- Fix alignment of the new HYP sections
- Fix GICR_TYPER access from userspace

----------------------------------------------------------------
Jamie Iles (1):
      KVM: arm64: Correctly align nVHE percpu data

Zenghui Yu (1):
      KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace

 arch/arm64/kvm/hyp/nvhe/hyp.lds.S  |  5 +++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 22 ++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
