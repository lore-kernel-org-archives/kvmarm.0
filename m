From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] help guest boot up on AArch64 host with GICv2
Date: Fri, 29 Jan 2016 18:55:44 +0000
Message-ID: <56ABB5B0.4090900@arm.com>
References: <56995068.9050207@ezchip.com> <569CB034.1060307@arm.com>
 <56A7DA7C.8090202@ezchip.com> <56A88A0E.40002@arm.com>
 <56AA7618.8030406@ezchip.com> <56ABA74A.3080500@arm.com>
 <56ABAF80.4090400@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 910CC40B40
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2016 13:50:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kUxieKM3ESdP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Jan 2016 13:50:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DE66407A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2016 13:50:40 -0500 (EST)
In-Reply-To: <56ABAF80.4090400@ezchip.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Chris Metcalf <cmetcalf@ezchip.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/16 18:29, Chris Metcalf wrote:
> On 01/29/2016 12:54 PM, Marc Zyngier wrote:
>> By the look of it, you're trying to use a GICv3 firmware, and pass a
>> GICv2 DT to the kernel. Do not do that. Either you use a GICv2 firmware
>> (having spoken to the ATF guys, there is a GICv2 driver in there that
>> should work for your case) and pass a GICv2 DT, or you go GICv3 all the way.
>>
>> A mix of the two things is completely unsupported on the model, and
>> solidly places you in the UNPREDICTABLE category when running that on
>> actual HW...
> 
> Once we upgrade to ATF 1.2 we will remove all of our GICv2
> stuff and see if everything works smoothly; till then, at least, we
> seem to have a workaround in place for development that will
> let us keep moving forward.
> 
>  From the ATF docs it does seem that using a v3 GIC in v2
> compatibility mode should be supported, but it's not pressing
> from our side to drill any deeper to try to see why it's not
> actually working correctly for us (though I'd be happy to try
> any further testing in this configuration if that's helpful).

That's what I've been told as well - the GICv2 code in ATF 1.2 should do
the trick out of the box.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
