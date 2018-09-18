From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 18/18] kvm: arm64: Allow tuning the physical address
 size for VM
Date: Tue, 18 Sep 2018 02:55:05 +0100
Message-ID: <CAFEAcA8eWYkzwFYHyP49dasK-NDVbbm=6DbEFNNPq9ZAdUM7JQ@mail.gmail.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-19-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A5B04A1DE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 21:55:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rHEOIvsNJ4cp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Sep 2018 21:55:26 -0400 (EDT)
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com
 [209.85.210.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 839B74A1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 21:55:26 -0400 (EDT)
Received: by mail-ot1-f67.google.com with SMTP id 36-v6so313544oth.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 18:55:26 -0700 (PDT)
In-Reply-To: <20180917104144.19188-19-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Dave P Martin <dave.martin@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17 September 2018 at 11:41, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -122,6 +122,14 @@ the default trap & emulate implementation (which changes the virtual
>  memory layout to fit in user mode), check KVM_CAP_MIPS_VZ and use the
>  flag KVM_VM_MIPS_VZ.
>
> +To configure the physical address space size for a VM (IPA size) on arm64,
> +check KVM_CAP_ARM_VM_PHYS_SHIFT (which returns the maximum limit for the
> +IPA shift) and use KVM_VM_TYPE_ARM_PHYS_SHIFT(PHYS_SHIFT). Bits[7-0] of the
> +machine type has been reserved for specifying the PHYS_SHIFT.
> +The supported range is [32...IPA_LIMIT], where IPA_LIMIT could be
> +identified by checking KVM_CAP_ARM_VM_PHYS_SHIFT. For backward compatibility
> +a value of 0 selects 40bits.
> +

Given this as the API documentation, I don't think I could figure out
what I as a userspace user of it need to do without looking at the
kernel code. Could I ask you to expand it so that it is a bit less
terse and a bit more detailed? (For instance, what is a PHYS_SHIFT
and why do I have to specify it rather than just telling the kernel
I want a 48 bit guest address space?)

thanks
-- PMM
