From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 00/15] arm/arm64: KVM: Merge boot and runtime page tables
Date: Mon, 27 Jun 2016 15:12:55 +0100
Message-ID: <57713467.4060601@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <20160627132923.GH26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160627132923.GH26498@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 27/06/16 14:29, Christoffer Dall wrote:
> On Tue, Jun 07, 2016 at 11:58:20AM +0100, Marc Zyngier wrote:
>> Until now, we've been setting up KVM using two sets of page tables:
>> one for the "boot" where we perform the basic MMU setup, and one for
>> the runtime.
>>
>> Switching between the two was though to be safe, but we've recently
>> realized that it is not: it is not enough to ensure that the VA->PA
>> mapping is consistent when switching TTBR0_EL2, but we also have to
>> ensure that the intermediate translations are the same as well. If the
>> TLB can return two different values for intermediate translations,
>> we're screwed (TLB conflicts).
> 
> Just a clarification: Intermediate Translations here means the
> page table levels of translations for a single stage of translation?

It does indeed.

> Is there a valid reference to the arhictecture specification for this?

D4.7.1 (General TLB maintenance requirements) talks a bit about
intermediate caching. G4.9.5 (TLB conflicts abort) is also of interest.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
