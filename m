From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Wed, 30 Mar 2016 13:07:06 +0100
Message-ID: <56FBC16A.7040404@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <56FA7F29.4060005@arm.com> <56FBBBC2.6010602@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56FBBBC2.6010602@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/03/16 12:42, Vladimir Murzin wrote:
> On 29/03/16 14:12, Vladimir Murzin wrote:
>> Hi Andre,
>>
>> On 25/03/16 02:04, Andre Przywara wrote:
>>> Please have a look at the series, review it and give the code some
>>> serious testing (and possibly debugging). All feedback is appreciated.
>>
>> I see that with the new vgic implementation kvmtool starts throwing:
>>
>> kvm [1273]: Unable to register VGICv3 redist MMIO regions
>>
> 
> It comes from kvm_io_bus_register_dev()
> 
> if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
> 	return -ENOSPC;
> 
> with bus->dev_count being 1000

Ouch. That's a consequence of having one "device" per actual register
set, I believe. So either we bump this limit up by a factor 10 (at
least), or we switch back to the old way of handling access to the GIC
regions (big "catch-all", and further demuxing).

Thoughts?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
