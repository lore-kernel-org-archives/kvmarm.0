From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Wed, 14 Oct 2015 10:48:46 +0200
Message-ID: <561E16EE.10707@linaro.org>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <20151010153744.GH29128@cbox> <561BBFC1.4070200@arm.com>
 <00dc01d10501$46352810$d29f7830$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00dc01d10501$46352810$d29f7830$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, 'Andre Przywara' <andre.przywara@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre, Pavel
On 10/12/2015 05:18 PM, Pavel Fedin wrote:
>  Hello!
> 
>> Also what is the status of Eric's IRQ routing support? Should this go in
>> first now?
> 
>  I'd say without vITS there's nothing to use IRQ routing with. It could go in and just lay around
> silently, so that it's not forgotten, but for example current qemu just knows that with GICv2m it
> should use hardcoded linear MSI->SPI mapping.
Currently the gsi routing applies on top of ITS emulation series. I am
going to rebase it soon. It can go in 4.5 with ITS emulation series.

Best Regards

Eric
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 

