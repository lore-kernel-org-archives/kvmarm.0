From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Fri, 8 Sep 2017 13:33:06 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F2015F55E9@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: James Morse <james.morse@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "vladimir.murzin@arm.com" <vladimir.murzin@arm.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "shankerd@codeaurora.org" <shankerd@codeaurora.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhanghaibin (Euler)" <zhanghaibin7@huawei.com>, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

> 
> On 08/09/17 10:05, gengdongjiu wrote:
> > Marc,
> >    Thanks for reply.
> >
> > On 2017/9/8 16:21, Marc Zyngier wrote:
> >>> Marc,
> >>>
> >>> sorry I have another question for the PAN.
[...]
> There cannot be any userspace mapping at EL2 when non-VHE, so there cannot be any valid PAN setting. I repeat: there is not such thing as
> PAN at EL2 when HCR_EL2.E2H==0. This bit *has no effect*. Just read the documentation (ARM DDI 0487B.a, D4.4.2).

Thanks Marc's comments, I completely agree with you, I understand the architecture, in non-VHE, user space mapping only exists at EL1 and pointed by the ttbr0_el1.
In the EL1, it uses ttbr0_el1 to point userspace page table, uses ttbr1_el1 to point kernel mapping.
In the EL2, it uses ttbr0_el2 or vttbr_el2 for address translation, cannot use the ttbr0_el1. 

> 
> If you're going to change this kind of code, please start by understanding the architecture.

OK, so I plant to remove the PAN setting at EL2 in non-VHE.

> 
> 	M.
> --
> Jazz is not dead. It just smells funny...
