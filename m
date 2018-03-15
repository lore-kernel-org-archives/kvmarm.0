From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v6 00/26] KVM/arm64: Randomise EL2 mappings (variant 3a
 mitigation)
Date: Thu, 15 Mar 2018 16:57:41 +0100
Message-ID: <20180315155741.7syqjajb77kh5vx2@kamzik.brq.redhat.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B2AB49EB8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 11:50:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 88rquM765LKo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Mar 2018 11:50:09 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4117402D6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 11:50:09 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180314165049.30105-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 14, 2018 at 04:50:23PM +0000, Marc Zyngier wrote:
> Whilst KVM benefits from the kernel randomisation via KASLR, there is
> no additional randomisation when the kernel is running at EL1, as we
> directly use a fixed offset from the linear mapping. This is not
> necessarily a problem, but we could do a bit better by independently
> randomizing the HYP placement.
> 
> This series proposes to randomise the offset by inserting a few random
> bits between the MSB of the RAM linear mapping and the top of the HYP
> VA (VA_BITS - 2). That's not a lot of random bits (on my Mustang, I
> get 13 bits), but that's better than nothing.
> 
> In order to achieve this, we need to be able to patch dynamic values
> in the kernel text. This results in a bunch of changes to the
> alternative framework, the insn library, and a few more hacks in KVM
> itself (we get a new way to map the GIC at EL2).
> 
> Another (and more recent) goal of this series is to work around what
> has been described as "variant 3a", which covers speculative reads of
> privileged system registers. Randomizing the location of the
> hypervisor would be pointless if one could simply obtain VBAR_EL2. In
> order to work around this, we place the vectors at a fairly static
> location (next to the idmap), independently of the hypervisor's own
> mappings. This ensures that we can leak VBAR_EL2 without disclosing
> much about HYP itself (and is similar to what the rest of the kernel
> does with KPTI). This is only enabled at runtime for Cortex-A57 and
> Cortex-A72.
> 
> This has been tested on the FVP model, Seattle (both 39 and 48bit VA),
> Mustang and Thunder-X. I've also done a sanity check on 32bit (which
> is only impacted by the HYP IO VA stuff).
>

I've smoke tested this series on a seattle with several busy VMs running
simultaneously. My host kernel configures 64K pages. I didn't see any
problems.

Thanks,
drew
