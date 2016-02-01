From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 00/21] arm64: Virtualization Host Extension support
Date: Mon, 1 Feb 2016 17:25:23 +0100
Message-ID: <20160201162523.GA6190@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD9B740F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 11:19:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oelae+5-niKT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2016 11:19:39 -0500 (EST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EAC540BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 11:19:39 -0500 (EST)
Received: by mail-wm0-f42.google.com with SMTP id l66so78260427wml.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2016 08:24:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 25, 2016 at 03:53:34PM +0000, Marc Zyngier wrote:
> ARMv8.1 comes with the "Virtualization Host Extension" (VHE for
> short), which enables simpler support of Type-2 hypervisors.
> 
> This extension allows the kernel to directly run at EL2, and
> significantly reduces the number of system registers shared between
> host and guest, reducing the overhead of virtualization.
> 
> In order to have the same kernel binary running on all versions of the
> architecture, this series makes heavy use of runtime code patching.
> 
> The first 20 patches massage the KVM code to deal with VHE and enable
> Linux to run at EL2. The last patch catches an ugly case when VHE
> capable CPUs are paired with some of their less capable siblings. This
> should never happen, but hey...
> 
> I have deliberately left out some of the more "advanced"
> optimizations, as they are likely to distract the reviewer from the
> core infrastructure, which is what I care about at the moment.
> 
> A few things to note:
> 
> - Given that the code has been almost entierely rewritten, I've
>   dropped all Acks from the new patches
> 
> - GDB is currently busted on VHE systems, as it checks for version 6
>   on the debug architecture, while VHE is version 7. The binutils
>   people are on the case.
> 
> This has been tested on the FVP_Base_SLV-V8-A model, and based on
> v4.5-rc1. I've put a branch out on:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/vhe
> 
> * From v1:
>   - Full rewrite now that the World Switch is written in C code.
>   - Dropped the "early IRQ handling" for the moment.
> 
> Marc Zyngier (21):
>   arm/arm64: Add new is_kernel_in_hyp_mode predicate
>   arm64: Allow the arch timer to use the HYP timer
>   arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
>   arm64: KVM: Skip HYP setup when already running in HYP
>   arm64: KVM: VHE: Turn VTCR_EL2 setup into a reusable macro
>   arm64: KVM: VHE: Patch out use of HVC
>   arm64: KVM: VHE: Patch out kern_hyp_va
>   arm64: KVM: VHE: Introduce unified system register accessors
>   arm64: KVM: VHE: Differenciate host/guest sysreg save/restore
>   arm64: KVM: VHE: Split save/restore of sysregs shared between EL1 and
>     EL2
>   arm64: KVM: VHE: Use unified system register accessors
>   arm64: KVM: VHE: Enable minimal sysreg save/restore
>   arm64: KVM: VHE: Make __fpsimd_enabled VHE aware
>   arm64: KVM: VHE: Implement VHE activate/deactivate_traps
>   arm64: KVM: VHE: Use unified sysreg accessors for timer
>   arm64: KVM: VHE: Add fpsimd enabling on guest access
>   arm64: KVM: VHE: Add alternative panic handling
>   arm64: KVM: Introduce hyp_alternate_value helper
>   arm64: KVM: Move most of the fault decoding to C
>   arm64: VHE: Add support for running Linux in EL2 mode
>   arm64: Panic when VHE and non VHE CPUs coexist

These patches generally look awesome!

I found some trailing white space in patch 6 and 7 that you can fix up
if you care to.

Thanks,
-Christoffer
