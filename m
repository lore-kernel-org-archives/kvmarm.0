From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Mon, 22 Jun 2015 07:47:59 +0100
Message-ID: <20150622074759.01d677a3@arm.com>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
	<55847C1F.1090606@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55847C1F.1090606@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Timur Tabi <timur@codeaurora.org>
Cc: Suzuki Poulose <Suzuki.Poulose@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "shankerd@codeaurora.org" <shankerd@codeaurora.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 19 Jun 2015 21:31:27 +0100
Timur Tabi <timur@codeaurora.org> wrote:

> On 06/17/2015 04:00 AM, Suzuki K. Poulose wrote:
> >   					  &genericv8_target_table);
> >   	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_XGENE_POTENZA,
> >   					  &genericv8_target_table);
> > +
> > kvm_register_target_sys_reg_table(KVM_ARM_TARGET_GENERIC_V8,
> > +					  &genericv8_target_table);
> >
> 
> Shouldn't you also remove all of the previous lines that return 
> &genericv8_target_table?

No. KVM_ARM_TARGET_* are part of the uapi, and existing userspace knows
about them. You can't just drop them.

What you *could* do would be to map the existing targets to the generic
one in a way that leaves userspace blissfully unaware of the underlying
change (for example, KVM_ARM_PREFERRED_TARGET should still return
KVM_ARM_TARGET_XGENE_POTENZA on an XGene platform, and
KVM_ARM_VCPU_INIT should still be accept it).

What would be the gain of such a mapping? Added complexity, hardly
anything else. We're much better off considering the generic target as
a new one, both inside the kernel and in the view we export to
userspace.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
--
To unsubscribe from this list: send the line "unsubscribe kvm" in
