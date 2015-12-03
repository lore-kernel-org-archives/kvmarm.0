From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Correctly handle zero register in system
 register accesses
Date: Thu, 03 Dec 2015 11:36:49 +0000
Message-ID: <56602951.1040305@arm.com>
References: <cover.1449136209.git.p.fedin@samsung.com> <fff7d3cedc4d6ac0c81b089a4b2d7a992c83fb80.1449136209.git.p.fedin@samsung.com> <56601E36.5070700@arm.com> <00cd01d12dba$f14ac070$d3e04150$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00cd01d12dba$f14ac070$d3e04150$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/15 11:08, Pavel Fedin wrote:
> Hello!
> 
>>> diff --git a/arch/arm64/kvm/sys_regs.c
>>> b/arch/arm64/kvm/sys_regs.c index 87a64e8..a667228 100644 ---
>>> a/arch/arm64/kvm/sys_regs.c +++ b/arch/arm64/kvm/sys_regs.c @@
>>> -102,7 +102,7 @@ static bool access_vm_reg(struct kvm_vcpu
>>> *vcpu,
>>> 
>>> BUG_ON(!p->is_write);
>>> 
>>> -	val = *vcpu_reg(vcpu, p->Rt); +	val = *p->val;
>> 
>> Why does it have to be a pointer? You could just have "val =
>> p->val" if you carried the actual value instead of a pointer to the
>> stack variable holding that value.
> 
> There's only one concern for pointer approach. Actually, this
> refactor is based on my vGICv3 live migration API patch set: 
> http://www.spinics.net/lists/kvm/msg124205.html 
> http://www.spinics.net/lists/kvm/msg124202.html
> 
> It's simply more convenient to use a pointer for exchange with
> userspace, see vgic_v3_cpu_regs_access() and callers. I wouldn't like
> to refactor the code again. What's your opinion on this?

I still don't think this is a good idea. You can still store the value
as an integer in vgic_v3_cpu_regs_access(), and check the write property
to do the writeback on read. Which is the same thing I asked for in this
patch.

> And of course i'll fix up the rest.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
