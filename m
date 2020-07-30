Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEA7C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 13:58:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1B4920829
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 13:58:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bm9nVVGj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1B4920829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B0A24B4FE;
	Thu, 30 Jul 2020 09:58:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vMXGuhRCdkgY; Thu, 30 Jul 2020 09:58:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92D804B4F9;
	Thu, 30 Jul 2020 09:58:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91E544B4F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 09:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Br6rgtSgUdLh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 09:58:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 697B44B4F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 09:58:05 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 368962074B;
 Thu, 30 Jul 2020 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596117484;
 bh=I4VtO+RvTl5dHcnmis2rhMN15keqAvYuB5FZEdImv3A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bm9nVVGjGZ7XYNnFoyAkAmwjyW5kA9q1IsWKYLKaXwYx5CxsIH156XdZeWk+HBeOn
 nkjkN6aIgkq/OSSDn08riSiwgRXr2P9h+M3dHPFJmZk2HRzvSiuVcc3IOnBZLRq4lG
 bbcdjhffeKKlT7hQJnfY11YZKzgeDrmUju2alRl8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k194M-00GH3a-Mo; Thu, 30 Jul 2020 14:58:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm: Add trace name for ARM_NISV
Date: Thu, 30 Jul 2020 14:57:56 +0100
Message-Id: <159611742543.1691243.7923791390001583960.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200730094441.18231-1-graf@amazon.com>
References: <20200730094441.18231-1-graf@amazon.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: graf@amazon.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 xypron.glpk@gmx.de, linux-kernel@vger.kernel.org, christoffer.dall@arm.com,
 kvmarm@lists.cs.columbia.edu, vkuznets@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
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

On Thu, 30 Jul 2020 11:44:41 +0200, Alexander Graf wrote:
> Commit c726200dd106d ("KVM: arm/arm64: Allow reporting non-ISV data aborts
> to userspace") introduced a mechanism to deflect MMIO traffic the kernel
> can not handle to user space. For that, it introduced a new exit reason.
> 
> However, it did not update the trace point array that gives human readable
> names to these exit reasons inside the trace log.
> 
> [...]

Applied to kvm-arm64/misc-5.9, thanks!

[1/1] KVM: arm: Add trace name for ARM_NISV
      commit: 1ccf2fe35c30f79102ad129c5aa71059daaaed7f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
