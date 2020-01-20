Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60791C33CAA
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 13:59:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D64D6217F4
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 13:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1GjV258"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D64D6217F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A1484AEC3;
	Mon, 20 Jan 2020 08:59:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kn0-bbjcmIRb; Mon, 20 Jan 2020 08:59:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 305504AEF1;
	Mon, 20 Jan 2020 08:59:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11D654AEF1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 08:59:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g2Aaz4WuPJeX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 08:59:48 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D52164AEC3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 08:59:47 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B5A2D217F4;
 Mon, 20 Jan 2020 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579528786;
 bh=igQFmPoiZFVlkBvmT/PwXmP0Kk7D/FPyAdDPnpZIre0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=K1GjV258FqS+3P0h9s2XLC12FVVO/SBMI5fwbqXf8VR5eOxwjLBWZkNKdMVlVpC0u
 0AWgXqmG6ddPRvN5pemGBcK8Xv/e/j+PNKVHNnjRg5CZkP6jnGHs1VB1/UKeMfvnEb
 DqTwJnel4pjr1fiLd3I+26+FGiD367+fDdD85IiY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1itXaj-000HeI-26; Mon, 20 Jan 2020 13:59:45 +0000
MIME-Version: 1.0
Date: Mon, 20 Jan 2020 13:59:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] arm64: KVM: Add XXX UAPI notes for swapped registers
In-Reply-To: <20200120135129.tgucvvwbeef2q3js@kamzik.brq.redhat.com>
References: <20200120130825.28838-1-drjones@redhat.com>
 <99903fdb3e0d34cb7957981b484fc28c@kernel.org>
 <20200120135129.tgucvvwbeef2q3js@kamzik.brq.redhat.com>
Message-ID: <773360494fdacfbade4b1cc611bc0082@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org,
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

On 2020-01-20 13:51, Andrew Jones wrote:
> On Mon, Jan 20, 2020 at 01:26:32PM +0000, Marc Zyngier wrote:
>> Hi Andrew,
>> 
>> Many thanks for this. Comments below.
>> 
>> On 2020-01-20 13:08, Andrew Jones wrote:
>> > Two UAPI system register IDs do not derive their values from the
>> > ARM system register encodings. This is because their values were
>> > accidentally swapped. As the IDs are API, they cannot be changed.
>> > Add XXX notes to point them out.
>> >
>> > Suggested-by: Marc Zyngier <maz@kernel.org>
>> > Signed-off-by: Andrew Jones <drjones@redhat.com>
>> > ---
>> >  Documentation/virt/kvm/api.txt    |  8 ++++++++
>> >  arch/arm64/include/uapi/asm/kvm.h | 11 +++++++++--
>> >  2 files changed, 17 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/Documentation/virt/kvm/api.txt
>> > b/Documentation/virt/kvm/api.txt
>> > index ebb37b34dcfc..11556fc457c3 100644
>> > --- a/Documentation/virt/kvm/api.txt
>> > +++ b/Documentation/virt/kvm/api.txt
>> > @@ -2196,6 +2196,14 @@ arm64 CCSIDR registers are demultiplexed by
>> > CSSELR value:
>> >  arm64 system registers have the following id bit patterns:
>> >    0x6030 0000 0013 <op0:2> <op1:3> <crn:4> <crm:4> <op2:3>
>> >
>> > +XXX: Two system register IDs do not follow the specified pattern.
>> > These
>> > +     are KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT, which map to
>> > +     system registers CNTV_CVAL_EL0 and CNTVCT_EL0 respectively.  These
>> > +     two had their values accidentally swapped, which means TIMER_CVAL
>> > is
>> > +     derived from the register encoding for CNTVCT_EL0 and TIMER_CNT is
>> > +     derived from the register encoding for CNTV_CVAL_EL0.  As this is
>> > +     API, it must remain this way.
>> 
>> Is 'XXX' an establiched way of documenting this kind of misfeature?
>> I couldn't find any other occurrence in Documentation, but I haven't
>> searched very hard.
> 
> I didn't find anything claiming it was the standard way of doing it. I
> also considered using 'NOTE', but I was afraid it wouldn't stand out
> as a "problem" enough. And, even though 'BUG' would certainly stand 
> out,
> I felt it implied we should be posting a fix.
> 
> Anyway, I'd be happy to change it to whatever the consensus is.

My personal preference would be for a big fat "*WARNING*" (with
an optional <blink> attribute), and a link to a picture of me
wearing a brown paper bag on my head.

But maybe "WARNING" is enough. Dunno. Anyway, if nobody comes up
with a better idea by tomorrow, I'll take it as is.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
