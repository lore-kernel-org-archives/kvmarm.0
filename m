From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 14/15] KVM: arm64: implement MSI injection in ITS
 emulation
Date: Mon, 24 Aug 2015 15:14:19 +0100
Message-ID: <55DB26BB.7090703@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-15-git-send-email-andre.przywara@arm.com>
 <55BB7678.5080105@linaro.org> <55BE7BA1.40403@arm.com>
 <00a201d0cdb7$70a623f0$51f26bd0$@samsung.com> <55BF2F51.6020701@linaro.org>
 <00f101d0cdcd$146a6090$3d3f21b0$@samsung.com> <55BF8AB8.5050408@linaro.org>
 <55BF9FB0.6070804@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55BF9FB0.6070804@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 03/08/15 18:06, Marc Zyngier wrote:
> On 03/08/15 16:37, Eric Auger wrote:
>> Andre, Pavel,
>> On 08/03/2015 11:16 AM, Pavel Fedin wrote:
>>>  Hello!
>>>
>>>> Again the case that leaves me uncomfortable is the one where the
>>>> userspace does not provide the devid whereas it must (GICv3 ITS case).
>>>
>>>  Hypothetical broken userland which does not exist for now ?
>> Yes but that's the rule to be not confident in *any* userspace, isn't it?

Well, that's only regarding safety, not regarding functionality, right?
So if we could break the kernel by not providing the flag and/or devid,
this needs to be fixed. But if it just doesn't work, that's OK.

>>
>> As of now I prefer keeping the flags at uapi level and propagate it
>> downto the kernel, as long as I don't have any answer for the unset
>> devid discrimination question. Please apologize for my stubbornness ;-)
> 
> I think this flag should be kept, as it really indicates what is valid
> in the MSI structure. It also has other benefits such as making obvious
> what userspace expects, which can then be checked against the kernel's
> own expectations.

I agree on this. Usually this kind of redundancy leads to strange code,
but this does not seem to apply here, since we can at least still guard
the assignments to demonstrate that the devid field needs to go along
with the flag.

Cheers,
Andre.
