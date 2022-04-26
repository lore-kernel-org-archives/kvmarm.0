Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305ABC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 09:15:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8B0B4B1E7;
	Tue, 26 Apr 2022 05:15:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rKW4IBpz2TKd; Tue, 26 Apr 2022 05:15:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 211CA49E49;
	Tue, 26 Apr 2022 05:15:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4ED949E33
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:15:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iJsL1JSV3XrQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 05:15:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 067DF49B26
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:15:48 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 854F823A;
 Tue, 26 Apr 2022 02:15:48 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D32D23F73B;
 Tue, 26 Apr 2022 02:15:46 -0700 (PDT)
Date: Tue, 26 Apr 2022 10:15:43 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Limit feature register reads from
 AArch32
Message-ID: <Yme4P2cVoxjOXqz9@monolith.localdoman>
References: <20220425235342.3210912-1-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220425235342.3210912-1-oupton@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

On Mon, Apr 25, 2022 at 11:53:37PM +0000, Oliver Upton wrote:
> KVM/arm64 does not restrict the guest's view of the AArch32 feature
> registers when read from AArch32. HCR_EL2.TID3 is cleared for AArch32
> guests, meaning that register reads come straight from hardware. This is
> problematic as KVM relies on read_sanitised_ftr_reg() to expose a set of
> features consistent for a particular system.
> 
> Appropriate handlers must first be put in place for CP10 and CP15 ID
> register accesses before setting TID3. Rather than exhaustively
> enumerating each of the encodings for CP10 and CP15 registers, take the
> lazy route and aim the register accesses at the AArch64 system register
> table.
> 
> Patches 1-2 are small cleanups to how we handle register emulation
> failure. No functional change for current KVM, but required to do
> register emulation correctly in this series.
> 
> Patch 3 reroutes the CP15 registers into the AArch64 table, taking care
> to immediately RAZ undefined ranges of registers. This is done to avoid
> possibly conflicting with encodings for future AArch64 registers.
> 
> Patch 4 installs an exit handler for the CP10 ID registers and also
> relies on the general AArch64 register handler to implement reads.
> 
> Finally, patch 5 actually sets TID3 for AArch32 guests, providing
> known-safe values for feature register accesses.
> 
> There is an argument that the series is in fact a bug fix for running
> AArch32 VMs on heterogeneous systems. To that end, it could be
> blamed/backported to when we first knew better:
> 
>   93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU features from guests")
> 
> But I left that tag off as in the aforementioned change skipping
> AArch32 was intentional. Up to you, Marc, if you want to call it a
> bugfix ;-)
> 
> Applies cleanly to 5.18-rc4.
> 
> Tested with AArch32 kvm-unit-tests and booting an AArch32 debian guest
> on a Raspberry Pi 4. Additionally, I tested AArch32 kvm-unit-tests w/
> pmu={on,off} and saw no splat, as Alex had discovered [1]. The test
> correctly skips with the PMU feature bit disabled now.

But a guest who ignores the fact that the ID register doesn't advertise a PMU
and tries to access the PMU registers regardless would still trigger the splat,
right? I don't think the series changes the AArch32 PMU registers visibility to
REG_HIDDEN when the VCPU feature is not set.

Thanks,
Alex

> 
> [1]: https://lore.kernel.org/r/20220425145530.723858-1-alexandru.elisei@arm.com
> 
> v1: https://lore.kernel.org/kvmarm/20220329011301.1166265-1-oupton@google.com/
> v2: https://lore.kernel.org/r/20220401010832.3425787-1-oupton@google.com
> 
> v2 -> v3:
>  - Collect R-b from Reiji (thanks!)
>  - Adopt Marc's suggestion for CP15 register handling
>  - Avoid writing to Rt when emulation fails (Marc)
>  - Print some debug info on an unexpected CP10 register access (Reiji)
> 
> v1 -> v2:
>  - Actually set TID3! Oops.
>  - Refactor kvm_emulate_cp15_id_reg() to check preconditions before
>    proceeding to emulation (Reiji)
>  - Tighten up comment on kvm_is_cp15_id_reg() to indicate that the only
>    other trapped ID register (CTR) is already handled in the cp15
> 
> Oliver Upton (5):
>   KVM: arm64: Return a bool from emulate_cp()
>   KVM: arm64: Don't write to Rt unless sys_reg emulation succeeds
>   KVM: arm64: Wire up CP15 feature registers to their AArch64
>     equivalents
>   KVM: arm64: Plumb cp10 ID traps through the AArch64 sysreg handler
>   KVM: arm64: Start trapping ID registers for 32 bit guests
> 
>  arch/arm64/include/asm/kvm_arm.h     |   3 +-
>  arch/arm64/include/asm/kvm_emulate.h |   7 -
>  arch/arm64/include/asm/kvm_host.h    |   1 +
>  arch/arm64/kvm/handle_exit.c         |   1 +
>  arch/arm64/kvm/sys_regs.c            | 197 +++++++++++++++++++++++----
>  arch/arm64/kvm/sys_regs.h            |   7 +
>  6 files changed, 178 insertions(+), 38 deletions(-)
> 
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
