From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 21/21] arm64: KVM: Remove weak attributes
Date: Wed, 02 Dec 2015 17:52:51 +0000
Message-ID: <565F2FF3.2030804@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-22-git-send-email-marc.zyngier@arm.com>
 <20151202114732.GA18376@cbox> <565F0C8D.9010505@arm.com>
 <20151202162134.GN18376@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA9604979C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 12:51:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Y-5JOEYwfeh for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 12:51:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F0D49630
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 12:51:25 -0500 (EST)
In-Reply-To: <20151202162134.GN18376@cbox>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/12/15 16:21, Christoffer Dall wrote:
> On Wed, Dec 02, 2015 at 03:21:49PM +0000, Marc Zyngier wrote:
>> On 02/12/15 11:47, Christoffer Dall wrote:
>>> On Fri, Nov 27, 2015 at 06:50:15PM +0000, Marc Zyngier wrote:
>>>> As we've now switched to the new world switch implementation,
>>>> remove the weak attributes, as nobody is supposed to override
>>>> it anymore.
>>>
>>> Why not remove the aliases and change the callers?
>>
>> This is likely to be a bigger patch, and it would affect the 32bit as
>> well. So far, I'm choosing to keep things the same. Another solution
>> would be to completely drop the aliases, and just rename the new
>> function to have the old names.
>>
>> I don't mind either way.
>>
> I didn't think of the 32-bit side.  I think eventually we should get rid
> of the aliases and just have the funcitons named as they are called, but
> there's no rush.  We can wait until we've the done the 32-bit side if
> you prefer.

Probably safest. We're already changing a lot of things. Hopefully for
4.6 I'll have the 32bit side sorted.

	M.
-- 
Jazz is not dead. It just smells funny...
