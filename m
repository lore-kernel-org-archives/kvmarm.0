From: Auger Eric <eric.auger@redhat.com>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 11:05:01 +0200
Message-ID: <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, daniel.thompson@linaro.org, Robert Richter <robert.richter@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 21/10/2016 10:45, Marc Zyngier wrote:
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
> 
>> Investigating KVM code ...
> 
> What is the failure syndrome? Do you see it crashing? Locking up? What
> is the PC at that stage?
No guest crash. the guest just locks up. No traces output.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
