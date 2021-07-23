Return-Path: <SRS0=3CJn=MP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D46C4320A
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 13:52:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C4D7A60F02
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 13:52:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C4D7A60F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65C074B157;
	Fri, 23 Jul 2021 09:52:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R3NtF76au51r; Fri, 23 Jul 2021 09:52:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CBB94B0F4;
	Fri, 23 Jul 2021 09:52:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B5214B08F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 09:52:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jOWamETjHmK6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Jul 2021 09:52:29 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3CB234B089
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 09:52:29 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4835F60EBD;
 Fri, 23 Jul 2021 13:52:28 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m6vbG-000VBj-B4; Fri, 23 Jul 2021 14:52:26 +0100
MIME-Version: 1.0
Date: Fri, 23 Jul 2021 14:52:26 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
In-Reply-To: <20210723133845.jwp3ljkfnupgv36i@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-11-maz@kernel.org>
 <20210721211743.hb2cxghhwl2y22yh@gator>
 <60d8e9e95ee4640cf3b457c53cb4cc7a@kernel.org>
 <20210723133845.jwp3ljkfnupgv36i@gator>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <6768b88a9119ea8b6e80d0d3e1935e42@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@android.com, vatsa@codeaurora.org,
 sdonthineni@nvidia.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, will@kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2021-07-23 14:38, Andrew Jones wrote:
> On Fri, Jul 23, 2021 at 02:30:13PM +0100, Marc Zyngier wrote:
> ...
>> > > +
>> > > +    ==============    ========
>> > > ======================================
>> > > +    Function ID:      (uint32)    0xC6000004
>> > > +    Arguments:        (uint64)    The base of the PG-sized IPA range
>> > > +                                  that is allowed to be accessed as
>> > > +				  MMIO. Must aligned to the PG size (r1)
>> >
>> > align
>> 
>> Hmmm. Ugly mix of tab and spaces. I have no idea what the norm
>> is here, so I'll just put spaces. I'm sure someone will let me
>> know if I'm wrong! ;-)
> 
> Actually, my comment wasn't regarding the alignment of the text. I was
> commenting that we should change 'aligned' to 'align' in the text. 
> (Sorry,
> that was indeed ambiguous.) Hmm, it might be better to just add 'be', 
> i.e.
> 'be aligned'.

*blink*. duh, of course.

> I'm not sure what to do about the tab/space mixing, but keeping it
> consistent is good enough for me.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
