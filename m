From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V4 00/15] x86/KVM/Hyper-v: Add HV ept tlb range flush
 hypercall support in KVM
Date: Mon, 15 Oct 2018 14:04:43 +0200
Message-ID: <d9414a38-ca5c-4273-30dc-1fecd0f9268e@redhat.com>
References: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: lantianyu1986@gmail.com
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, benh@kernel.crashing.org, catalin.marinas@arm.com, christoffer.dall@arm.com, devel@linuxdriverproject.org, haiyangz@microsoft.com, hpa@zytor.com, jhogan@kernel.org, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org, kys@microsoft.com, linux-arm-kernel@lists.infradead.org, linux@armlinux.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org, marc.zyngier@arm.com, mingo@redhat.com, mpe@ellerman.id.au, paul.burton@mips.com, paulus@ozlabs.org, ralf@linux-mips.org, rkrcmar@redhat.com, sthemmin@microsoft.com, tglx@linutronix.de, will.deacon@arm.com, x86@kernel.org, michael.h.kelley@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 13/10/2018 16:53, lantianyu1986@gmail.com wrote:
> From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> 
> For nested memory virtualization, Hyper-v doesn't set write-protect
> L1 hypervisor EPT page directory and page table node to track changes 
> while it relies on guest to tell it changes via HvFlushGuestAddressLlist
> hypercall. HvFlushGuestAddressLlist hypercall provides a way to flush
> EPT page table with ranges which are specified by L1 hypervisor.
> 
> If L1 hypervisor uses INVEPT or HvFlushGuestAddressSpace hypercall to
> flush EPT tlb, Hyper-V will invalidate associated EPT shadow page table
> and sync L1's EPT table when next EPT page fault is triggered.
> HvFlushGuestAddressLlist hypercall helps to avoid such redundant EPT
> page fault and synchronization of shadow page table.

So I just told you that the first part is well understood but I must
retract that; after carefully reviewing the whole series, I think one of
us is actually very confused.

I am not afraid to say it can be me, but my understanding is that you're
passing L1 GPAs to the hypercall and instead the spec says it expects L2
GPAs.  (Consider that, because KVM's shadow paging code is shared
between nested EPT and !EPT cases, every time you see gpa/gfn in the
code it is for L1, while nested EPT GPAs are really what the code calls
gva.)

What's going on?

Paolo
