From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: can we define a KVM_REG_ARM encoding bit for NonSecure/Secure ?
Date: Tue, 6 Mar 2018 13:59:27 +0000
Message-ID: <6ee3ff1c-7324-6fcf-651d-bc3404613330@arm.com>
References: <CAFEAcA8MEp0Uw3NFUVfy7wm--wpTZ591SsjhRgVjrPST47f5Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9170440170
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Mar 2018 08:52:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Poj3a7glLQtp for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Mar 2018 08:52:18 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 387F140259
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Mar 2018 08:52:18 -0500 (EST)
In-Reply-To: <CAFEAcA8MEp0Uw3NFUVfy7wm--wpTZ591SsjhRgVjrPST47f5Wg@mail.gmail.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/03/18 14:01, Peter Maydell wrote:
> Hi; I've just noticed a bug in QEMU where we weren't migrating
> Secure-bank register state for AArch32 emulated guest correctly, which
> turns out to be intertwined with how KVM defines its index values for
> cp15 registers in the KVM_REG_ARM_* encoding.
> 
> The problem is that QEMU defines the on-the-wire migration format
> for system registers using the KVM encoding. This is fine when we're
> using KVM (because all guest visible registers for KVM are non-secure),
> but if we're using emulation, we might have to migrate both secure and
> non-secure register state, so we need to be able to define ID values
> that distinguish them.
> 
> I could just borrow a currently-spare bit in the encoding to indicate
> S/NS, but this seems liable to future breakage if the bit gets defined
> to have some meaning for the kernel, so it would be nice if we could
> define a bit officially, something like:
> 
> #define KVM_REG_ARM_SECURE_MASK 0x0000000010000000
> 
> in arch/arm/include/uapi/asm/kvm.h
> 
> Does this seem like a good idea? (We could alternatively steal a bit
> from the top of the rather-over-specified 12 bit field for copro
> number, but AFAIK bit 28 isn't used currently so is free.)

I guess that'd be fine. If we ever have KVM running in S-EL2 on a v8.4
core, we'd be able to make use of this bit. Let's hope it never happens
though.

Would you be able to write a patch for this please?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
