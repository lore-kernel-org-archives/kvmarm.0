From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 06/18] KVM: arm/arm64: Add kvm_ras.h to collect kvm
 specific RAS plumbing
Date: Fri, 12 Oct 2018 11:57:02 +0200
Message-ID: <20181012095702.GC12328@zn.tnic>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-7-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B858B4A0C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 05:57:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wHcQA+2AmHt6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Oct 2018 05:57:14 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73A0A40A6E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 05:57:14 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180921221705.6478-7-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 21, 2018 at 11:16:53PM +0100, James Morse wrote:
> To split up APEIs in_nmi() path, we need any nmi-like callers to always
> be in_nmi(). KVM shouldn't have to know about this, pull the RAS plumbing
> out into a header file.
> 
> Currently guest synchronous external aborts are claimed as RAS
> notifications by handle_guest_sea(), which is hidden in the arch codes
> mm/fault.c. 32bit gets a dummy declaration in system_misc.h.
> 
> There is going to be more of this in the future if/when we support
> the SError-based firmware-first notification mechanism and/or
> kernel-first notifications for both synchronous external abort and
> SError. Each of these will come with some Kconfig symbols and a
> handful of header files.
> 
> Create a header file for all this.
> 
> This patch gives handle_guest_sea() a 'kvm_' prefix, and moves the
> declarations to kvm_ras.h as preparation for a future patch that moves
> the ACPI-specific RAS code out of mm/fault.c.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Tested-by: Tyler Baicar <tbaicar@codeaurora.org>
> ---
>  arch/arm/include/asm/kvm_ras.h       | 14 ++++++++++++++
>  arch/arm/include/asm/system_misc.h   |  5 -----
>  arch/arm64/include/asm/kvm_ras.h     | 11 +++++++++++
>  arch/arm64/include/asm/system_misc.h |  2 --
>  arch/arm64/mm/fault.c                |  2 +-
>  virt/kvm/arm/mmu.c                   |  4 ++--
>  6 files changed, 28 insertions(+), 10 deletions(-)
>  create mode 100644 arch/arm/include/asm/kvm_ras.h
>  create mode 100644 arch/arm64/include/asm/kvm_ras.h
> 
> diff --git a/arch/arm/include/asm/kvm_ras.h b/arch/arm/include/asm/kvm_ras.h
> new file mode 100644
> index 000000000000..aaff56bf338f
> --- /dev/null
> +++ b/arch/arm/include/asm/kvm_ras.h
> @@ -0,0 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2018 - Arm Ltd

checkpatch is complaining for some reason:

WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
#66: FILE: arch/arm/include/asm/kvm_ras.h:1:
+// SPDX-License-Identifier: GPL-2.0

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
