Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08179C4741F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 21:09:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2EB4820809
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 21:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9CtSTBI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EB4820809
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 998E34B68A;
	Thu, 29 Oct 2020 17:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jwl89iaIaczP; Thu, 29 Oct 2020 17:09:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E54E4B690;
	Thu, 29 Oct 2020 17:09:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81E3F4B68A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 17:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vR-6zh2JS810 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 17:09:28 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 533144B67B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 17:09:28 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 233742087D;
 Thu, 29 Oct 2020 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604005767;
 bh=md/yxiXBCp+bY6aWAkEWs1aEmMQAJ/pIyKT56uFmYnQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=B9CtSTBIWxKLYc6r46/Jz1kFl1zGDRzNZOCAxl5fxVJm6IMfP9jm9pgd/ZZP+HX2w
 GZx7fKhXj2vVhCqi0gFhqfG+FfzAGuFwE4HadWrUFyk76Ob26MCXD/o4GIuw7Ce6Au
 CIVnNVbty5Fz/6o6TG9C13zmI2YakIQzPKfe65fA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYFAj-005YNy-90; Thu, 29 Oct 2020 21:09:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, Gavin Shan <gshan@redhat.com>,
 Santosh Shukla <sashukla@nvidia.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] KVM: arm64: fix the mmio faulting
Date: Thu, 29 Oct 2020 21:09:16 +0000
Message-Id: <160400571841.9348.6030696223991954457.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1603711447-11998-1-git-send-email-sashukla@nvidia.com>
References: <1603711447-11998-1-git-send-email-sashukla@nvidia.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, gshan@redhat.com,
 sashukla@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, will@kernel.org, suzuki.poulose@arm.com,
 mcrossley@nvidia.com, kwankhede@nvidia.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, cjia@nvidia.com,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: mcrossley@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 linux-arm-kernel@lists.infradead.org, shan.gavin@gmail.com, will@kernel.org
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

On Mon, 26 Oct 2020 16:54:06 +0530, Santosh Shukla wrote:
> Description of the Reproducer scenario as asked in the thread [1].
> 
> Tried to create the reproducer scenario with vfio-pci driver using
> nvidia GPU in PT mode, As because vfio-pci driver now supports
> vma faulting (/vfio_pci_mmap_fault) so could create a crude reproducer
> situation with that.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Force PTE mapping on fault resulting in a device mapping
      commit: 91a2c34b7d6fadc9c5d9433c620ea4c32ee7cae8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
