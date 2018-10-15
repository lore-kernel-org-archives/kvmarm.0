From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V4 2/15] KVM/MMU: Add tlb flush with range helper function
Date: Mon, 15 Oct 2018 14:02:58 +0200
Message-ID: <fc78b7f2-70aa-29fa-95ca-d599f76c8f1a@redhat.com>
References: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
 <20181013145406.4911-3-Tianyu.Lan@microsoft.com>
 <4D709C3A-A91C-4CA7-922A-E77618EF21B4@oracle.com>
 <alpine.DEB.2.21.1810141014350.1438@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1810141014350.1438@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Liran Alon <liran.alon@oracle.com>
Cc: lantianyu1986@gmail.com, Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, rkrcmar@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, devel@linuxdriverproject.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 14/10/2018 10:16, Thomas Gleixner wrote:
>>> +static inline bool kvm_available_flush_tlb_with_range(void)
>>> +{
>>> +	return kvm_x86_ops->tlb_remote_flush_with_range;
>>> +}
>> Seems that kvm_available_flush_tlb_with_range() is not used in this patch…
> What's wrong with that? 
> 
> It provides the implementation and later patches make use of it. It's a
> sensible way to split patches into small, self contained entities.

That's true, on the other hand I have indeed a concerns with this patch:
this series is not bisectable at all, because all the new code is dead
until the very last patch.  Uses of the new feature should come _after_
the implementation.

I don't have any big problem with what Liran pointed out (and I can live
with the unused static functions that would warn with -Wunused, too),
but the above should be fixed in v5, basically by moving patches 12-15
at the beginning of the series.

Paolo
