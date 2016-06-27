From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 00/15] arm/arm64: KVM: Merge boot and runtime page tables
Date: Mon, 27 Jun 2016 15:29:23 +0200
Message-ID: <20160627132923.GH26498@cbox>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E6EC41390
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 09:23:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eIXKdbYLy4H2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 09:23:29 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FC7E412D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 09:23:29 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id v199so100336655wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 06:28:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 07, 2016 at 11:58:20AM +0100, Marc Zyngier wrote:
> Until now, we've been setting up KVM using two sets of page tables:
> one for the "boot" where we perform the basic MMU setup, and one for
> the runtime.
> 
> Switching between the two was though to be safe, but we've recently
> realized that it is not: it is not enough to ensure that the VA->PA
> mapping is consistent when switching TTBR0_EL2, but we also have to
> ensure that the intermediate translations are the same as well. If the
> TLB can return two different values for intermediate translations,
> we're screwed (TLB conflicts).

Just a clarification: Intermediate Translations here means the
page table levels of translations for a single stage of translation?

Is there a valid reference to the arhictecture specification for this?

Thanks,
-Christoffer


> 
> At that point, the only safe thing to do is to never change TTBR0_EL2,
> which means that we need to make the idmap page part of the runtime
> page tables.
> 
> The series starts with a bit of brain dumping explaining what we're
> trying to do. This might not be useful as a merge candidate, but it
> was useful for me to put this somewhere. It goes on revamping the
> whole notion of HYP VA range, making it runtime patchable. It then
> always merge idmap and runtime page table into one set, leading to
> quite a lot of simplification in the init/teardown code. In the
> process, 32bit KVM gains the ability to teardown the HYP page-tables
> and vectors, which makes kexec a bit closer.
> 
> This has been tested on Seattle, Juno, the FVP model (both v8.0 and
> v8.1), Cubietruck and Midway, and is based on 4.7-rc2.
> 
> Thanks,
> 
> 	M.
> 
> Marc Zyngier (15):
>   arm64: KVM: Merged page tables documentation
>   arm64: KVM: Kill HYP_PAGE_OFFSET
>   arm64: Add ARM64_HYP_OFFSET_LOW capability
>   arm64: KVM: Define HYP offset masks
>   arm64: KVM: Refactor kern_hyp_va/hyp_kern_va to deal with multiple
>     offsets
>   arm/arm64: KVM: Export __hyp_text_start/end symbols
>   arm64: KVM: Runtime detection of lower HYP offset
>   arm/arm64: KVM: Always have merged page tables
>   arm64: KVM: Simplify HYP init/teardown
>   arm/arm64: KVM: Drop boot_pgd
>   arm/arm64: KVM: Kill free_boot_hyp_pgd
>   arm: KVM: Simplify HYP init
>   arm: KVM: Allow hyp teardown
>   arm/arm64: KVM: Prune unused #defines
>   arm/arm64: KVM: Check that IDMAP doesn't intersect with VA range
> 
>  arch/arm/include/asm/kvm_asm.h      |   2 +
>  arch/arm/include/asm/kvm_host.h     |  25 +++-----
>  arch/arm/include/asm/kvm_mmu.h      |  11 ----
>  arch/arm/include/asm/virt.h         |   4 ++
>  arch/arm/kvm/arm.c                  |  20 ++----
>  arch/arm/kvm/init.S                 |  56 ++++++----------
>  arch/arm/kvm/mmu.c                  | 125 ++++++++++++++++--------------------
>  arch/arm64/include/asm/cpufeature.h |   3 +-
>  arch/arm64/include/asm/kvm_host.h   |  17 ++---
>  arch/arm64/include/asm/kvm_hyp.h    |  28 ++++----
>  arch/arm64/include/asm/kvm_mmu.h    | 100 ++++++++++++++++++++++++-----
>  arch/arm64/include/asm/virt.h       |   4 ++
>  arch/arm64/kernel/cpufeature.c      |  19 ++++++
>  arch/arm64/kvm/hyp-init.S           |  61 +++---------------
>  arch/arm64/kvm/hyp/entry.S          |  19 ------
>  arch/arm64/kvm/hyp/hyp-entry.S      |  15 +++++
>  arch/arm64/kvm/reset.c              |  28 --------
>  17 files changed, 240 insertions(+), 297 deletions(-)
> 
> -- 
> 2.1.4
> 
