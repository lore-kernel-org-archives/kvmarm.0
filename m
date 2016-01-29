From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH] help guest boot up on AArch64 host with GICv2
Date: Fri, 29 Jan 2016 13:29:20 -0500
Message-ID: <56ABAF80.4090400@ezchip.com>
References: <56995068.9050207@ezchip.com> <569CB034.1060307@arm.com>
 <56A7DA7C.8090202@ezchip.com> <56A88A0E.40002@arm.com>
 <56AA7618.8030406@ezchip.com> <56ABA74A.3080500@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05AEE40B58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2016 13:24:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PzA15OE7qevk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Jan 2016 13:24:28 -0500 (EST)
Received: from emea01-db3-obe.outbound.protection.outlook.com
 (mail-db3on0081.outbound.protection.outlook.com [157.55.234.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67041407A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2016 13:24:28 -0500 (EST)
In-Reply-To: <56ABA74A.3080500@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 01/29/2016 12:54 PM, Marc Zyngier wrote:
> By the look of it, you're trying to use a GICv3 firmware, and pass a
> GICv2 DT to the kernel. Do not do that. Either you use a GICv2 firmware
> (having spoken to the ATF guys, there is a GICv2 driver in there that
> should work for your case) and pass a GICv2 DT, or you go GICv3 all the way.
>
> A mix of the two things is completely unsupported on the model, and
> solidly places you in the UNPREDICTABLE category when running that on
> actual HW...

Once we upgrade to ATF 1.2 we will remove all of our GICv2
stuff and see if everything works smoothly; till then, at least, we
seem to have a workaround in place for development that will
let us keep moving forward.

 From the ATF docs it does seem that using a v3 GIC in v2
compatibility mode should be supported, but it's not pressing
from our side to drill any deeper to try to see why it's not
actually working correctly for us (though I'd be happy to try
any further testing in this configuration if that's helpful).

Thanks!

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
