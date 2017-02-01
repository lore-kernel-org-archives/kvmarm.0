From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 05/10] KVM: arm/arm64: Initialize the emulated EL1
 physical timer
Date: Wed, 1 Feb 2017 10:08:01 +0000
Message-ID: <619cc856-b268-df3b-d064-e511fa54afe0@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-6-git-send-email-jintack@cs.columbia.edu>
 <86wpde83xn.fsf@arm.com> <20170130145816.GC16459@cbox>
 <57b57b31-b8ad-f5c8-a1fc-4cde9a564dd2@arm.com> <20170130190450.GF16459@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 070DE40692
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 05:07:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PVlOX9p8cedN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 05:07:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EE6B40284
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 05:07:44 -0500 (EST)
In-Reply-To: <20170130190450.GF16459@cbox>
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
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/17 19:04, Christoffer Dall wrote:
> On Mon, Jan 30, 2017 at 05:44:20PM +0000, Marc Zyngier wrote:

>> Wventually, we'll have to support an offset-able
>> physical counter to support nested virtualization, but this can come at
>> a later time.
>>
> Why do we need the offset-able physical counter for nested
> virtualization?  I would think for nested virt we just need to support
> respecting how the guest hypervisor programs CNTVOFF?

Ah, I see what you mean. Yes, once the guest hypervisor is in control of
its own CNTVOFF, we get everything we need. So let's just ignore this
for the time being, and we should be pretty good for this series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
