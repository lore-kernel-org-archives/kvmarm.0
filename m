From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 2 Oct 2015 11:30:44 +0200
Message-ID: <560E4EC4.5050101@redhat.com>
References: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, 'Christoffer Dall' <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 02/10/2015 09:28, Pavel Fedin wrote:
>  2. Another possible approach, based on how device tree binding is handled by Linux. It is possible
> to remove virtual timer IRQ from the device tree, in this case the kernel reverts to using physical
> timer. When running under hypervisor, accesses to physical CP15 timer are trapped into HYP,
> therefore we can forward them to userspace using new exit code, something like KVM_EXIT_REG_ACCESS.
> In this case the timer would be also emulated by the userspace, which is slower, but allows better
> emulation. Also, this could be used in order to run some other guests which just expect physical
> timer to be there.
> 
>  Both approaches have their own limitations, but anyway this is much better than nothing. What do
> you think, and which approach do you like more?

I like the latter.  But I guess one could even do both?

Paolo
