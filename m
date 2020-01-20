Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14D5C2D0DB
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 11:56:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76E5B2087E
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 11:56:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yypSpKZT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76E5B2087E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DB2A4AEF6;
	Mon, 20 Jan 2020 06:56:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sCV-taN7jTgI; Mon, 20 Jan 2020 06:56:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66EF64AEF1;
	Mon, 20 Jan 2020 06:56:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B79A94AEB8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 06:56:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xkz0QoMfRbAB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 06:56:37 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EBAC4AEB2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 06:56:37 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4270D207FF;
 Mon, 20 Jan 2020 11:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579521396;
 bh=G5BjgiERIPgD2gmhgW49sz0utTOoaFQGf9Xe0v3nM94=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=yypSpKZTEYdwkcQzZT7E8+v22pWxs9mENCsNX0pUqHTAnjRfPEDL2pRw9TL5bPvs6
 lSYkudo8DfYGo8c5fI59pA4t1YAm6JyJolJVeH3r+wvItyzkWoraMiulpKysfuyB9h
 UGJHcoUZ3LzYQd5sjyKCJzW5BajPqZHbGEpp7QXI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1itVfW-000Fp6-Hy; Mon, 20 Jan 2020 11:56:34 +0000
MIME-Version: 1.0
Date: Mon, 20 Jan 2020 12:56:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH] ARM: virt: Relax arch timer version check during early
 boot
In-Reply-To: <38a43fed-1c7a-69ea-3662-e17f13ca74d6@arm.com>
References: <1579097798-106243-1-git-send-email-vladimir.murzin@arm.com>
 <eb889279-87f2-d674-9299-169794c285eb@arm.com>
 <d4b8bb91f95385682f20c9dc5c6f5e50@kernel.org>
 <38a43fed-1c7a-69ea-3662-e17f13ca74d6@arm.com>
Message-ID: <55fbdb33fc3e107385c12def941aa934@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: vladimir.murzin@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-01-20 12:34, Vladimir Murzin wrote:
> Hi Marc,
> 
> On 1/20/20 11:14 AM, Marc Zyngier wrote:
>> Hi Vladimir,
>> 
>> On 2020-01-20 11:46, Vladimir Murzin wrote:
>>> + Marc
>>> + kvmarm@lists.cs.columbia.edu
>>> 
>>> On 1/15/20 2:16 PM, Vladimir Murzin wrote:
>>>> Updates to the Generic Timer architecture allow ID_PFR1.GenTimer to
>>>> have values other than 0 or 1. At the moment, Linux is quite strict 
>>>> in
>>>> the way it handles this field at early boot and will not configure
>>>> arch timer if it doesn't find the value 1.
>>>> 
>>>> Since here use ubfx for arch timer version extraction (hyb-stub 
>>>> build
>>>> with -march=armv7-a, so it is safe)
>>>> 
>>>> To help backports (even though the code was correct at the time of 
>>>> writing)
>>>> Fixes: 8ec58be9f3ff ("ARM: virt: arch_timers: enable access to 
>>>> physical timers")
>>>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> 
>> I'm not opposed to such a change, but it'd be good to document what 
>> other values
>> are expected here, as the current (Rev E_a) ARM ARM only mentions 
>> values 0 and 1.
> 
> That true, ARM ARM doesn't mention it yet. OTOH, should we really care
> about exact values as soon it stays compatible?

That's for you to say, really. But given that you hint at some changes,
it'd be good to have at least a short sentence explaining that, for 
example,
"upcoming revisions of the architecture will allow different 
ID_PFR1.GenTimer
values while preserving backward compatibility".

Other than that, feel free to add my

Acked-by: Marc Zyngier <maz@kernel.org>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
