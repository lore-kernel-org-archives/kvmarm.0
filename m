Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FEDC43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 13:47:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 65ABF21D43
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 13:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="eg6ePeAP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65ABF21D43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEB1A4B219;
	Tue, 15 Sep 2020 09:47:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q-PJ0fpNes6z; Tue, 15 Sep 2020 09:47:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72CB14B245;
	Tue, 15 Sep 2020 09:47:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F11F4B229
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 09:47:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6OixZapojpn0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 09:47:28 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9E964B21C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 09:47:28 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7526521D24;
 Tue, 15 Sep 2020 13:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600177647;
 bh=An8bUf+cWpAG/u+1BnVioiDw+Pkkf8LhEX7EXD3eUOg=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=eg6ePeAPhBgUAbixIOW8IWWLC8APZSEGurkIj/fSTZexULVYQUIQk4GDVuFJrqpOk
 ui3ImEmzJPD4Rf7C2nJnjxlHlRwM7PsnG3Ik4qYvbcCVKRlXG+iCkB2Jdk/a4qRnab
 uvgI8RZosMzMQnZGtMyzaTIKhYv8kSZzH8RW8Wd0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kIBIr-00C1a8-EQ; Tue, 15 Sep 2020 14:47:25 +0100
MIME-Version: 1.0
Date: Tue, 15 Sep 2020 14:47:25 +0100
From: Marc Zyngier <maz@kernel.org>
To: Xiaofei Tan <tanxiaofei@huawei.com>
Subject: Re: [PATCH] KVM: arm64: fix doc warnings in mmu code
In-Reply-To: <1600175890-7435-1-git-send-email-tanxiaofei@huawei.com>
References: <1600175890-7435-1-git-send-email-tanxiaofei@huawei.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <7bcb5fd9b6490e98cfa8aa22496a8a71@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: tanxiaofei@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linuxarm@huawei.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Xiaofei,

On 2020-09-15 14:18, Xiaofei Tan wrote:
> Fix following warnings caused by mismatch bewteen function parameters
> and comments.
> arch/arm64/kvm/mmu.c:119: warning: Function parameter or member
> 'pudp'not described in 'stage2_dissolve_pud'
> arch/arm64/kvm/mmu.c:119: warning: Excess function parameter 'pud'
> description in 'stage2_dissolve_pud'

[...]

Most of this code is being deleted. If you want to fix comments,
please look at what is in -next.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
