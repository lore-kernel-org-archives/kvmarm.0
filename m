From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Fri, 8 Sep 2017 09:21:55 +0100
Message-ID: <20170908092155.4d90862b@why.wild-wind.fr.eu.org>
References: <1504763684-30128-1-git-send-email-gengdongjiu@huawei.com>
        <1bcd0c1e-c3b5-aac4-bb4f-83ee14b1d1ab@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1bcd0c1e-c3b5-aac4-bb4f-83ee14b1d1ab@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: James Morse <james.morse@arm.com>, christoffer.dall@linaro.org, vladimir.murzin@arm.com, rkrcmar@redhat.com, catalin.marinas@arm.com, shankerd@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zhanghaibin7@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 8 Sep 2017 15:19:21 +0800
gengdongjiu <gengdongjiu@huawei.com> wrote:

> On 2017/9/7 23:23, Marc Zyngier wrote:
> > On 07/09/17 16:03, gengdongjiu wrote:  
> >>> On 07/09/17 12:49, gengdongjiu wrote:  
> >>>>  
> [...]
> 
> > 
> > I really cannot think of a good reason why we'd want to do that. Playing
> > with set_fs() is almost universally wrong, and I'm certainly going to
> > oppose to any change in that area unless the code that calls set_fs()
> > has been made public and properly reviewed. Until then, UAO/PAN will
> > stay as they are unless you prove that our current code is wrong.  
> 
> Marc,
> 
> sorry I have another question for the PAN.
> 
> In the non-VHE mode, The host kernel is running in the EL1. Before
> host kernel enter guest, host OS will call 'HVC' instruction to do
> the world-switch, and the pstate.PAN will be saved into the SPSR_EL2.
> When world-switch back to host kernel from EL2, it will call 'eret'
> instruction to EL1 host, this 'eret' instruction will restore the
> SPSR_EL2 to the PSTATE. so the PSTATE.PAN will be restored.
> 
> For the Non-VHE mode, in the EL2 where mainly have word-switch code,
> do you think it needs to reset the PSTATE.PAN? From the spec, it does
> not provide SCTLR_EL2.SPAN bit for non-VHE mode, so reset the
> PSTATE.PAN does not sure whether it is needed or whether affects the
> performance. If you think it is needed for El2 in Non-VHE mode,
> moving the reset PSTATE.PAN to the exception entry to EL2 may be
> better, such as "el1_sync", because host can also call 'hvc'
> instruction without guest running.

So let's see if I correctly understand your question:

You're worried that we don't set/reset PSTATE.PAN at EL2 in non-VHE?
In non-VHE, there is no user-space mapping that is present at the
same time as the hypervisor mappings. Actually, we hardly have any
mapping other than the HYP text/data and the vcpu/vm structures.

So how is PAN relevant in this context? What does it even mean?
If you have a ARMv8.0 behaviour, PAN doesn't even seem to *exist* at
EL2.

Or am I completely missing the point here?

	M.
-- 
Without deviation from the norm, progress is not possible.
