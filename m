From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Fri, 26 Jun 2015 18:17:20 +0200
Message-ID: <558D7B10.9040508@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org> <5587CA18.6050101@arm.com> <5587D398.8040002@linaro.org> <558920F7.9090301@arm.com> <558956E4.2050700@linaro.org> <01b901d0ae78$2bed39a0$83c7ace0$@samsung.com> <558AAA8E.2010403@linaro.org> <009201d0af23$62b09440$2811bcc0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <009201d0af23$62b09440$2811bcc0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, 'Andre Przywara' <andre.przywara@arm.com>, eric.auger@st.com
Cc: christoffer.dall@linaro.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,
On 06/25/2015 10:46 AM, Pavel Fedin wrote:
>  Hi!
> 
>> But personally I would prefer we
>> check irqchip routing entries have flat mapping, ie gsi = irqchip.pin
>> since in any case we don't want/expect the userspace to play with that.
> 
>  Why? On x86 userspace perfectly can play with it. We can imagine some very new qemu version in
> future which has all arch-specific kludges like "direct mapping" removed and relying fully on
> routing which it sets up from scratch, in the same way as x86 qemu does this. Or we can imagine some
> new, legacy-free hypervisor implementation. The gsi == irqchip.pin limitation is just what we have
> now by default, for backwards compatibility. But by design we were never obliged to stick to this.
>  Well, it's just MHO...
OK I will get rid of the test. I think the most important is we clearly
state routing doesn't apply to KVM_IRQ_LINE.

Thanks

Eric


> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 

