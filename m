From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 09/17] KVM: arm64: introduce ITS emulation file with
 MMIO framework
Date: Mon, 4 Jul 2016 16:15:38 +0200
Message-ID: <9fea837a-d45d-ae2b-6442-0a89db124946@redhat.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-10-andre.przywara@arm.com>
 <3fec9632-ce39-3508-2b71-4049fc959a64@redhat.com>
 <32d54016-731d-e4a9-272d-8b0934ebec31@arm.com>
 <8546ac45-f7cd-31af-a261-bb85ca7305ca@redhat.com>
 <33ff8f2c-89e0-5778-71a6-9d116e061752@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <33ff8f2c-89e0-5778-71a6-9d116e061752@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/07/2016 16:00, Andre Przywara wrote:
> Hi,
> 
> On 04/07/16 14:54, Auger Eric wrote:
>> Hi Andre,
>>
>> On 04/07/2016 15:38, Andre Przywara wrote:
>>> 2) on KVM_DEV_ARM_VGIC_GRP_ADDR check that "initialized" is false
>>> 3) on KVM_DEV_ARM_VGIC_CTRL_INIT check that "initialized" is false
>>> 4) after KVM_DEV_ARM_VGIC_CTRL_INIT set initialized to true
>>>
>>> I don't want to rely solely on vgic_its_base being ADDR_UNDEF, since I
>>> expect we extend that interface later by supporting more options (for
>>> instance to size the virtual ITS, in terms of devices, number of LPIs,
>>> collections, etc.)
>>>
>>> Does that make sense?
>>> Or do we need more here?
>>
>> So you will accept a call to KVM_DEV_ARM_VGIC_CTRL_INIT with an unset
>> address? I don't think this is relevant.
> 
> Ah, good point. Will fix this.
> 
> However I think we do the same on GICv2/GICv3 at the moment. CTRL_INIT
> will succeed, I guess we fail the first KVM_RUN then, right?
Yes the map_resources will fail with UNDEF addresses

Eric
> 
> Cheers,
> 
