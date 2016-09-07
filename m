From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 7/7] ARM: KVM: Unlock vgic-v3 support
Date: Wed, 7 Sep 2016 14:58:56 +0200
Message-ID: <20160907125856.GP23592@cbox>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-8-git-send-email-vladimir.murzin@arm.com>
 <20160905112927.GL26366@cbox> <57CEC344.7030706@arm.com>
 <20160906165527.GG23592@cbox> <57CFF094.5000704@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8EA149B53
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 08:48:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1vMVFyY-xZGv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2016 08:48:00 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DBB349B50
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 08:48:00 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id 1so30749301wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Sep 2016 05:56:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57CFF094.5000704@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 07, 2016 at 11:48:52AM +0100, Vladimir Murzin wrote:
> On 06/09/16 17:55, Christoffer Dall wrote:
> > On Tue, Sep 06, 2016 at 02:23:16PM +0100, Vladimir Murzin wrote:
> >>
> >> Sorry, missed this one
> >>
> >> On 05/09/16 12:29, Christoffer Dall wrote:
> >>>>  
> >>>>> +static bool __hyp_text __has_useable_gicv3_cpuif(void)
> >>>>> +{
> >>>>> +	if (IS_ENABLED(CONFIG_ARM_GIC_V3) && (read_sysreg(ID_PFR1) >> 28))
> >>> Do we have a define for bit 28 we could use?
> >>
> >> I'll check it.
> >>
> >>>
> >>> Does this actually work on all v7 boards?  The v7 ARM ARM seems to state
> >>> that this bitfield is Reserved, UNK.  Does that somehow mean 'is going
> >>> to be zero'?
> >>
> >> It is how v7ARM ARM I have defines UNK
> >>
> >> An abbreviation indicating that software must treat a field as
> >> containing an UNKNOWN value. Hardware must implement the bit as read as
> >> 0, or all 0s for a bit field. Software must not rely on the field
> >> reading as zero.
> >>
> >> It seems goes under 'is going to be zero' case, no?
> >>
> > The last sentence is disturbing to me, and feels slightly contradicting
> > itself.  Reading the UNKNOWN description doesn't help much either.
> > 
> > Perhaps you can ask around internally and figure out what the precise
> > answer to this is?
> 
> Since it is kind of implementation dependant thing the precise answer
> from here hardly help, IMO. We still have non-zero chance to see
> something scary.

Well, if the precise answer is: This will actually always return 0
because of X and Y, then your code is fine.

If the answer is:  It's implementation defined and may return something
bogus, then it's dodgy.  At the very least we should know that for all
boards with virt support out there, the read actually does return 0.

> 
> OTOH, why do we care of all v7 boards if none of them have
> CONFIG_ARM_GIC_V3 defined?
> 

I think it's pretty bad to have a multiarch config where running KVM
crashes your system, if this can be avoided.

If our way out is CONFIG_ARM_GIC_V3, then that config option should say
"May crash your system if you don't actually have a GICv3 and try to run
KVM on there".

Thanks,
-Christoffer
