From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] arm64: kvm: set cpsr before spsr on fault injection
Date: Fri, 22 Jul 2016 18:10:51 +0200
Message-ID: <20160722161051.sboe75mlgg34xfm7@kamzik.localdomain>
References: <1469198326-27345-1-git-send-email-drjones@redhat.com>
 <57923DBF.90003@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57923DBF.90003@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 22, 2016 at 04:37:35PM +0100, Marc Zyngier wrote:
> On 22/07/16 15:38, Andrew Jones wrote:
> > We need to set cpsr before determining the spsr bank, as the bank
> > depends on the target exception level of the injection, not the
> > current mode of the vcpu. Normally this is one in the same (EL1),
> > but not when we manage to trap an EL0 fault. It still doesn't really
> > matter for the 64-bit EL0 case though, as vcpu_spsr() unconditionally
> > uses the EL1 bank for that. However the 32-bit EL0 case gets fun, as
> > that path will lead to the BUG() in vcpu_spsr32()
> > 
> > This patch fixes the assignment order and also modifies some white
> > space in order to better group pairs of lines that have strict order.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> Ouch. Nice catch. Can you find what's the earliest release this would
> cleanly apply to? Definitely deserves a CC stable.

stable/linux-4.5.y, which is the first to contain 8fc153cda9c9 "arm64:
KVM: Fix AArch64 guest userspace exception injection"

Thanks,
drew
