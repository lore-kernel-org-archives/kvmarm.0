Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A07C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 12:40:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 298384B164;
	Mon, 13 Dec 2021 07:40:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qPh4DORg5NKW; Mon, 13 Dec 2021 07:40:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2291C4B1DD;
	Mon, 13 Dec 2021 07:40:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7C594B17D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 07:40:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hL2+njUarTme for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 07:40:00 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C91AB4B164
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 07:40:00 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 15D5DB80E11;
 Mon, 13 Dec 2021 12:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64BBC34602;
 Mon, 13 Dec 2021 12:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639399197;
 bh=SB0jcvOHaTcNlc7s5Hf+IsizApnbitVNk7rxPIE2TQo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Vy5p1Wjs8J0LF1PwNRBLB6DgbMuWO+mDZ9z5D1Ph2Ej0wWoFAbFmAWxgHRmf7K64R
 m0DEDE8e89LvSUkjoeqE9WWDlSfZLjpzWR0vITfono/qk/Y7F/+/ZjHb6+wA2PKfPt
 YaWt4TP4s3t5XAPw55chjdlBSrg23Ap+ESVsarKsKy5XviTVCV9xup9LLrhE5tAKSb
 6BN7O/McztSmDid9eE52AbDm/ha1kn4lQaExhkEiB2axsN7k0wp5MoymYPFMTTJhuc
 9ZM6hbebKJCHFr51Tb6+1KbyTW9mkgPksvSRhnFbCaMtvUF1zLhkL/lREeBcEKt0vR
 LVtfd4a7i4IDQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mwkcV-00BnLp-Lc; Mon, 13 Dec 2021 12:39:55 +0000
MIME-Version: 1.0
Date: Mon, 13 Dec 2021 12:39:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: Chenxu Wang <irakatz51@gmail.com>
Subject: Re: Some problems about TZASC configuration
In-Reply-To: <CAFLP=uDtS9fyg4nmA_tXx5dMWDMoT=ABZk_tRLyQS_toxUxZ-A@mail.gmail.com>
References: <CAFLP=uDtS9fyg4nmA_tXx5dMWDMoT=ABZk_tRLyQS_toxUxZ-A@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <d6fef1f0986a8b441cd270c29d2a7baa@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: irakatz51@gmail.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Wang,

On 2021-12-12 19:52, Chenxu Wang wrote:
> Hi all,
> 
> I have some problems about KVM+QEMU when it runs on a FVP with TZASC
> and VHE enabled.
> 
> If I configure some DRAM region as "secure only", will KVM generate
> some fault (e.g. SError) when creating a VM?

If the memory ends up being used by NS, then of course you'll get
a fault.

> 
> If yes, can we avoid it by restricting the physical memory region for
> creating a VM?
> 
> For example, I configure 0xa0000000-0xafffffff as secure only, then i
> ask KVM to create VMs in region 0x90000000-0x9fffffff, so no overlap
> between them.

You need to instruct the kernel that some of the memory isn't usable.
Usually, that's done by removing the secure memory from the memory
map altogether.

In general, the NS world has no business knowing about the secure
memory.

HTH,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
