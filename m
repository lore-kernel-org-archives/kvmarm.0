From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/4] arm64: KVM: Install stage-2 translation before
 enabling traps on VHE
Date: Thu, 8 Nov 2018 17:54:46 +0000
Message-ID: <0aba0f09-d299-2f65-9e08-63424776c29c@arm.com>
References: <20181105143617.120602-1-marc.zyngier@arm.com>
 <20181105143617.120602-4-marc.zyngier@arm.com>
 <20181106080657.GG12057@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08EEF4A339
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 12:54:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FxNgfUiI3JM1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Nov 2018 12:54:50 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBB4F4A330
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 12:54:50 -0500 (EST)
In-Reply-To: <20181106080657.GG12057@e113682-lin.lund.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/11/18 08:06, Christoffer Dall wrote:
> On Mon, Nov 05, 2018 at 02:36:15PM +0000, Marc Zyngier wrote:
>> It is a bit odd that we only install stage-2 translation after having
>> cleared HCR_EL2.TGE, which means that there is a window during which
>> AT requests could fail as stage-2 is not configured yet.
>>
>> Let's move stage-2 configuration before we clear TGE, making the
>> guest entry sequence clearer: we first configure all the guest stuff,
>> then only switch to the guest translation regime.
>>
>> Non-VHE doesn't have that kind of behaviour, and is left alone.
> 
> I'm a bit confused about this statement.  You can still issue a S12E1x
> AT instruction after activating traps (setting HCR_EL2.VM) on non-VHE
> and get at the same behavior, right?
> 
> Is the point here that we are not aware of any non-VHE implementations
> that speculate AT instructions in this window, or am I missing some
> architectural nugget that prevents problems on non-VHE systems?

You're right. This is not an issue on non-VHE so far because we don't
know of any such system that is broken in such a way (speculative AT
instruction leading to inconsistent TLBs).

> In any case, why not change the non-VHE code as well to preserve
> symmetry for both types of systems?

Happy to change that too.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
