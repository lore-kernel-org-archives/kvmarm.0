From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 16/21] arm64: KVM: Add compatibility aliases
Date: Wed, 02 Dec 2015 15:23:56 +0000
Message-ID: <565F0D0C.9010801@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com> <1448650215-15218-17-git-send-email-marc.zyngier@arm.com> <20151202114920.GB18376@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151202114920.GB18376@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 02/12/15 11:49, Christoffer Dall wrote:
> On Fri, Nov 27, 2015 at 06:50:10PM +0000, Marc Zyngier wrote:
>> So far, we've implemented the new world switch with a completely
>> different namespace, so that we could have both implementation
>> compiled in.
>>
>> Let's take things one step further by adding weak aliases that
>> have the same names as the original implementation. The weak
>> attributes allows the new implementation to be overriden by the
>> old one, and everything still work.
> 
> Do I understand correctly that the whole point of this is to keep
> everything compiling nicely while at the same time being able to split
> the patches so that you can have an isolated "remove old code" patch
> that doesn't have to change the callers?

Exactly.

> If so, I think explaining this rationale would be helpful in the commit
> message in case we have to go back and track these changes in connection
> with a regression and don't remember why we did things this way.

Fair enough. I'll update the commit message (possibly by stealing a
large part of the above text!).

> Maybe I'm being over-cautious though...
> 
> Otherwise:
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
