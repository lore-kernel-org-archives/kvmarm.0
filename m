From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/5] arm/arm64: KVM: Don't BUG_ON if IT bits are set in
 ARM mode
Date: Thu, 1 Sep 2016 13:21:23 +0100
Message-ID: <57C81D43.4020606@arm.com>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
 <1471610295-1456-2-git-send-email-marc.zyngier@arm.com>
 <20160901115616.GD10162@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21DC7410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 08:13:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nkbReh89WpNM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 08:13:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F2840BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 08:13:15 -0400 (EDT)
In-Reply-To: <20160901115616.GD10162@cbox>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 01/09/16 12:56, Christoffer Dall wrote:
> On Fri, Aug 19, 2016 at 01:38:11PM +0100, Marc Zyngier wrote:
>> The ARM ARM asserts that having the IT bits set in ARM mode is
>> unpredictable. But should a CPU do that (and still be able to
>> run correctly), we shouldn't kill the system.
>>
>> So let's drop the BUG_ON that checks for this, as it is not
>> very helpful.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> not sure how this relates to the series, but looks fine otherwise:

In the following patch, I'm moving the whole function to be an inline
that will be used in HYP as well. A BUG_ON in HYP is a pretty tasteless
thing to do, so I opted for removing it here.

But your remark on the following patch makes more sense over all. I'll
follow up there.

> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
