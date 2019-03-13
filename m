From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Set ICH_HCR_EN in guest anyway when using
 gicv4
Date: Wed, 13 Mar 2019 16:31:05 +0000
Message-ID: <09a615e5-9dce-d194-6290-b8897abd5d12@arm.com>
References: <F348A9E21A573744858FF7E5D32E29D81FEFA462@DGGEMI529-MBX.china.huawei.com>
 <3993685d-a78f-2e73-e22a-8ade3b6a6279@arm.com>
 <d97bd073-8775-f0cf-637a-ea1b04afbd8f@arm.com>
 <5FC3163CFD30C246ABAA99954A238FA839311C4F@lhreml524-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5FC3163CFD30C246ABAA99954A238FA839311C4F@lhreml524-mbs.china.huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Tangnianyao (ICT)" <tangnianyao@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, "james.morse@arm.com" <james.morse@arm.com>, "julien.thierry@arm.com" <julien.thierry@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "alex.bennee@linaro.org" <alex.bennee@linaro.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "andre.przywara@arm.com" <andre.przywara@arm.com>, Zhangshaokun <zhangshaokun@hisilicon.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.colum>
Cc: Linuxarm <linuxarm@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 13/03/2019 15:59, Shameerali Kolothum Thodi wrote:

Hi Shameer,

>> Can you please give the following patch a go? I can't test it, but hopefully
>> you can.
> 
> Thanks for your quick response. I just did a quick test on one of our platforms
> with VHE+GICv4 and it seems to fix the performance issue we were seeing
> when GICv4 is enabled.
> 
> Test setup:
> 
> Host connected to a PC over a 10G port.
> Launch Guest with an assigned vf dev.
> Run iperf from Guest,
> 
> 5.0 kernel:
> [ ID]  Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  1.30 GBytes  1.12 Gbits/sec
> 
> +Patch:
> 
> [ ID] 	Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  10.9 GBytes  9.39 Gbits/sec

Ah, that looks much better! I'll try to write it properly, as I think
what we have today is slightly bizarre (we write ICH_HCR_EL2 from too
many paths, and I need to remember how the whole thing works).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
