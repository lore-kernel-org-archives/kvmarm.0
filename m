From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 11:40:50 +0100
Message-ID: <5e2c7786-1d03-874c-9ed3-13cd7be0fbf5@linaro.org>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Auger Eric <eric.auger@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, Robert Richter <robert.richter@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 21/10/16 09:45, Marc Zyngier wrote:
> +Robert
>
> On 21/10/16 08:01, Auger Eric wrote:
>> Hi,
>>
>> I am not able to boot 4.9-rc1 as a guest on Cavium ThunderX (dt and acpi
>> mode). Bisecting the guest shows that the problem shows up at
>>
>> 91ef84428a86b75a52e15c6fe4f56b446ba75f93
>> irqchip/gic-v3: Reset BPR during initialization
>>
>> If I remove the write to the ICC_BPR1_EL1 register on guest, the VM boots.
>
> That's very odd. A ICC_BPR1_EL1 access when HCR_EL2.IMO is set only
> affects ICH_VMCR_EL2.VBPR1. It is not trapped, since we don't set
> ICH_HCR_EL2.TALL1. It is a very boring sysreg!
>
> So from a pure architectural point of view, I don't see how this can
> fail. I've just run the same configuration on my Freescale board (GICv3
> as well), and can't see any issue at all.

Wow. Of all the patches I written for arm64 this was not the one I 
regarded as especially risky [at least when compared to the others ;-)].

Of course it does rely on writing a zero being "an attempt to program 
the binary point field to a value less than the reset value" and "sets 
the field to the reset value." and from a silicon validation point of 
view that might be regarded as a interesting corner case...


Daniel.
