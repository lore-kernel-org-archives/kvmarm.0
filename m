From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 7/7] ARM: KVM: Unlock vgic-v3 support
Date: Tue, 6 Sep 2016 14:23:16 +0100
Message-ID: <57CEC344.7030706@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-8-git-send-email-vladimir.murzin@arm.com>
 <20160905112927.GL26366@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BEC149B51
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:14:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QysUcIlEfp63 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 09:14:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A9A049B50
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:14:54 -0400 (EDT)
In-Reply-To: <20160905112927.GL26366@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


Sorry, missed this one

On 05/09/16 12:29, Christoffer Dall wrote:
>>  
>> > +static bool __hyp_text __has_useable_gicv3_cpuif(void)
>> > +{
>> > +	if (IS_ENABLED(CONFIG_ARM_GIC_V3) && (read_sysreg(ID_PFR1) >> 28))
> Do we have a define for bit 28 we could use?

I'll check it.

> 
> Does this actually work on all v7 boards?  The v7 ARM ARM seems to state
> that this bitfield is Reserved, UNK.  Does that somehow mean 'is going
> to be zero'?

It is how v7ARM ARM I have defines UNK

An abbreviation indicating that software must treat a field as
containing an UNKNOWN value. Hardware must implement the bit as read as
0, or all 0s for a bit field. Software must not rely on the field
reading as zero.

It seems goes under 'is going to be zero' case, no?

Cheers
Vladimir
