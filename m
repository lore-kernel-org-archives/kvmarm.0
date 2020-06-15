Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDC7C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 08:20:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 147212068E
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 08:20:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWtLZGQy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 147212068E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B253F4B130;
	Mon, 15 Jun 2020 04:20:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DMxAch6fCUs0; Mon, 15 Jun 2020 04:20:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F8844B12D;
	Mon, 15 Jun 2020 04:20:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D5914B0D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 04:20:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N-3rRNMKpi+o for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 04:20:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C24804A551
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 04:20:05 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 81D2B2053B;
 Mon, 15 Jun 2020 08:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592209204;
 bh=rn6yKK06LpzRw/3dsq0h1xocnLbW3SUFTAd2Sa8+1Js=;
 h=From:To:Cc:Subject:Date:From;
 b=YWtLZGQyd7nbuuYsMvmTnST0IZDFzzhO9C/apw+MIVjPu8F//TT/q/odf8KcBnu/g
 kQRjs69i3amQsA177aT9+pF5TTUI85VSEjMlFL679jKIVBEIn9BlrjaJ1Qvbun4oL/
 UOZwW4WuBQ5zAmwPQLaPAf3q1FKAxQMcQCjeiQ4A=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jkkLb-0031ew-1k; Mon, 15 Jun 2020 09:20:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/4] KVM/arm64: Enable PtrAuth on non-VHE KVM
Date: Mon, 15 Jun 2020 09:19:50 +0100
Message-Id: <20200615081954.6233-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

Not having PtrAuth on non-VHE KVM (for whatever reason VHE is not
enabled on a v8.3 system) has always looked like an oddity. This
trivial series remedies it, and allows a non-VHE KVM to offer PtrAuth
to its guests.

In the tradition of not having separate security between host-EL1 and
EL2, EL2 reuses the keys set up by host-EL1. It is likely that, should
we switch to a mode where EL2 is more distrusting of EL1, we'd have
private keys there.

The last patch is just an optimisation which I've lobbed with the rest
of the series in order not to forget it.

Marc Zyngier (4):
  KVM: arm64: Enable Pointer Authentication at EL2 if available
  KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
  KVM: arm64: Allow PtrAuth to be enabled from userspace on non-VHE
    systems
  KVM: arm64: Check HCR_EL2 instead of shadow copy to swap PtrAuth
    registers

 arch/arm64/Kconfig                   |  4 +---
 arch/arm64/include/asm/kvm_ptrauth.h |  4 ++--
 arch/arm64/kvm/hyp-init.S            | 11 +++++++++++
 arch/arm64/kvm/reset.c               | 21 ++++++++++-----------
 4 files changed, 24 insertions(+), 16 deletions(-)

-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
