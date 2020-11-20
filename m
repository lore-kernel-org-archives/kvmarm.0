Return-Path: <SRS0=rD/S=E2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D21C5519F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 11:26:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2678322253
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 11:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4zweIOj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2678322253
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 765DE4B2C0;
	Fri, 20 Nov 2020 06:26:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9+p5y2Z61C4k; Fri, 20 Nov 2020 06:26:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79AD04B3A8;
	Fri, 20 Nov 2020 06:26:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40C2D4B1EA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 06:26:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0GWI3LBjyU4O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Nov 2020 06:26:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44ABD4B11B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 06:26:41 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D34CC22244;
 Fri, 20 Nov 2020 11:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605871600;
 bh=e4dU3Fcu0n1ACqjkCBWzLMlbjaNYmEYYOuJTREFTOyk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=P4zweIOjwAsjb1amYtoKtfj/jkRrAFLkoeeYYASL4K06PAfVrCz8EBmM4MaS8UVpG
 6ofZjZ+zn163yCRFv6Cz2OShDj1yHal6yxrPgs6uM7NQao6/7mrJWVqWjqVRxnM3yI
 RzOntXJkFte54eXhHOWu4S2gBp3iTbL9cvXGVUuI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kg4Yn-00CEtr-Sh; Fri, 20 Nov 2020 11:26:37 +0000
MIME-Version: 1.0
Date: Fri, 20 Nov 2020 11:26:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 3/5] KVM: arm64: Patch kimage_voffset instead of
 loading the EL1 value
In-Reply-To: <20201119111454.vrbogriragp7zukk@google.com>
References: <20201109175923.445945-1-maz@kernel.org>
 <20201109175923.445945-4-maz@kernel.org>
 <20201119111454.vrbogriragp7zukk@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <2c47608f4326c8251ebd940f8ecb99a9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, ascull@google.com, will@kernel.org,
 qperret@google.com, ndesaulniers@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-19 11:14, David Brazdil wrote:
> Hey Marc,
> 
> Just noticed in kvmarm/queue that the whitespacing in this patch is 
> off.
> 
>> +.macro kimg_pa reg, tmp
>> +alternative_cb kvm_get_kimage_voffset
>> +       movz    \tmp, #0
>> +       movk    \tmp, #0, lsl #16
>> +       movk    \tmp, #0, lsl #32
>> +       movk    \tmp, #0, lsl #48
>> +alternative_cb_end
>> +
>> +       /* reg = __pa(reg) */
>> +       sub     \reg, \reg, \tmp
>> +.endm
> This uses spaces instead of tabs.
> 
>> +
>>  #else
> This added empty line actually has a tab in it.

Well spotted. Now fixed.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
