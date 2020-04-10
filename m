Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05758C2BA2B
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:49:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B17C206F7
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQ9vml3b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B17C206F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E3684B194;
	Fri, 10 Apr 2020 03:49:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tGTcVVEdhRjA; Fri, 10 Apr 2020 03:49:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 206354B181;
	Fri, 10 Apr 2020 03:49:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CFE24B15A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 03:49:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PLHJrwuejV2q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 03:49:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9185D4B158
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 03:49:10 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 68E29206F7;
 Fri, 10 Apr 2020 07:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586504949;
 bh=/o4MJjPAlTLNfcD2ikCDJYX0S8Gr3CyOaOCNkkDz0Jc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=NQ9vml3bCC4VDaG2BqN645+mMUE6sKKHbLVCUvwUCf51HE/GyRO4f88ruKh/oPVLG
 wanjjheIR0E/367gnxUADdTUUR0vZLn0jQZmoA0cGx25d8GH2zafWTx7Kso1tq4Hlu
 irLlS3fqI3joTgr6nvTTo/mzEDlCXXl5bMokQwfI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jMoPT-0027iL-GW; Fri, 10 Apr 2020 08:49:07 +0100
MIME-Version: 1.0
Date: Fri, 10 Apr 2020 08:49:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: Javier Romero <xavinux@gmail.com>
Subject: Re: Contribution to KVM.
In-Reply-To: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
Message-ID: <548a7864dce9aaf132f90fbb67bd3f52@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: xavinux@gmail.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Javier,

On 2020-04-09 22:29, Javier Romero wrote:
> Hello,
> 
>  My name is Javier, live in Argentina and work as a cloud engineer.
> 
> Have been working with Linux servers for the ast 10 years in an
> Internet Service Provider and I'm interested in contributing to KVM
> maybe with testing as a start point.
> 
> If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at 
> disposal.

Testing is great (although the RPi-3 isn't the most interesting platform 
due
to its many hardware limitations). If you are familiar with the ARM 
architecture,
helping with patch review is also much appreciated.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
