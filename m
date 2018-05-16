From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 00/12] APEI in_nmi() rework and arm64 SDEI wire-up
Date: Wed, 16 May 2018 17:46:04 +0100
Message-ID: <15bfc50c-c789-bd79-7495-d040a354d306@arm.com>
References: <20180516162829.14348-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F55E40196
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 12:39:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L0xUKtoqODn2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 12:38:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14FB0400D4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 12:38:51 -0400 (EDT)
In-Reply-To: <20180516162829.14348-1-james.morse@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-acpi@vger.kernel.org
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/05/18 17:28, James Morse wrote:
> The aim of this series is to wire arm64's SDEI into APEI.

... and I missed the 'l' from the beginning of the well know inux-mm@kvack.org
mailing list. I won't increase the spam by resending, please fix it when
pointing out my other mistakes!

Thanks,

James


> Since v3 the NMI fixmap entries and locks have moved into their own
> structure. This moves the indirection up from the 'lock', which should
> be more acceptable to polite society.
> Changes are noted in each patch.
> 
> This touches a few trees, so I'm not sure how best it should be merged.
> Patches 11 and 12 are reducing a race that is made worse by patch 4, I'd
> like them to arrive together, even though patch 11 doesn't depend on anything
> else in the series. A partial merge of this would  be 1-3 and 11.

[...]

> Patch 11 makes the reschedule to memory_failure() run as soon as possible.

[...]

> James Morse (12):
>   ACPI / APEI: Move the estatus queue code up, and under its own ifdef
>   ACPI / APEI: Generalise the estatus queue's add/remove and notify code
>   ACPI / APEI: don't wait to serialise with oops messages when
>     panic()ing
>   ACPI / APEI: Switch NOTIFY_SEA to use the estatus queue
>   KVM: arm/arm64: Add kvm_ras.h to collect kvm specific RAS plumbing
>   arm64: KVM/mm: Move SEA handling behind a single 'claim' interface
>   ACPI / APEI: Make the nmi_fixmap_idx per-ghes to allow multiple
>     in_nmi() users
>   ACPI / APEI: Split fixmap pages for arm64 NMI-like notifications
>   firmware: arm_sdei: Add ACPI GHES registration helper
>   ACPI / APEI: Add support for the SDEI GHES Notification type
>   mm/memory-failure: increase queued recovery work's priority
>   arm64: acpi: Make apei_claim_sea() synchronise with APEI's irq work
> 
>  arch/arm/include/asm/kvm_ras.h       |  14 +
>  arch/arm/include/asm/system_misc.h   |   5 -
>  arch/arm64/include/asm/acpi.h        |   4 +
>  arch/arm64/include/asm/daifflags.h   |   1 +
>  arch/arm64/include/asm/fixmap.h      |   8 +-
>  arch/arm64/include/asm/kvm_ras.h     |  24 ++
>  arch/arm64/include/asm/system_misc.h |   2 -
>  arch/arm64/kernel/acpi.c             |  49 ++++
>  arch/arm64/mm/fault.c                |  30 +-
>  drivers/acpi/apei/ghes.c             | 518 ++++++++++++++++++++---------------
>  drivers/firmware/arm_sdei.c          |  67 +++++
>  include/acpi/ghes.h                  |  17 ++
>  include/linux/arm_sdei.h             |   8 +
>  mm/memory-failure.c                  |  11 +-
>  virt/kvm/arm/mmu.c                   |   4 +-
>  15 files changed, 503 insertions(+), 259 deletions(-)
>  create mode 100644 arch/arm/include/asm/kvm_ras.h
>  create mode 100644 arch/arm64/include/asm/kvm_ras.h
> 
