From: Mihai Claudiu Caraman <mike.caraman@nxp.com>
Subject: RE: [PATCH v2 00/17] KVM/ARM: Guest Entry/Exit optimizations
Date: Mon, 29 Feb 2016 00:57:49 +0000
Message-ID: <AM2PR04MB073947192D0A7015739689EF84BA0@AM2PR04MB0739.eurprd04.prod.outlook.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Reported-by: Mihai Caraman <mihai.caraman@freescale.com>
Tested-by: Mihai Caraman <mihai.caraman@freescale.com>

40% improvements here and there will make the difference. 

Thanks,
Mike

> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Marc Zyngier
> Sent: Wednesday, February 17, 2016 6:41 PM
> To: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: kvm@vger.kernel.org; linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu
> Subject: [PATCH v2 00/17] KVM/ARM: Guest Entry/Exit optimizations
> 
> I've recently been looking at our entry/exit costs, and profiling figures did show some very low hanging fruits.
> 
> The most obvious cost is that accessing the GIC HW is slow. As in "deadly slow", specially when GICv2 is involved. So not hammering the HW when there is nothing to write (and even to read) is immediately beneficial, as this is the most common cases (whatever people seem to think, interrupts are a *rare* event). Similar work has also been done for GICv3, with a reduced impact (it was less "bad" to start with).
> 
> Another easy thing to fix is the way we handle trapped system registers. We do insist on (mostly) sorting them, but we do perform a linear search on trap. We can switch to a binary search for free, and get immediate benefits (the PMU code, being extremely trap-happy, benefits immediately from this).
> 
> With these in place, I see an improvement of 10 to 40% (depending on the platform) on our world-switch cycle count when running a set of hand-crafted guests that are designed to only perform traps.
> 
> Please note that VM exits are actually a rare event on ARM. So don't expect your guest to be 40% faster, this will hardly make a noticable difference.
> 
> Methodology:
> 
> * NULL-hypercall guest: Perform 2^20 PSCI_0_2_FN_PSCI_VERSION calls, and then a power-off:
> 
> __start:
> 	mov	x19, #(1 << 16)
> 1:	mov	x0, #0x84000000
> 	hvc	#0
> 	sub	x19, x19, #1
> 	cbnz	x19, 1b
> 	mov	x0, #0x84000000
> 	add	x0, x0, #9
> 	hvc	#0
> 	b	.
> 
> * Self IPI guest: Inject and handle 2^20 SGI0 using GICv2 or GICv3, and then power-off:
> 
> __start:
> 	mov	x19, #(1 << 20)
> 
> 	mrs	x0, id_aa64pfr0_el1
> 	ubfx	x0, x0, #24, #4
> 	and	x0, x0, #0xf
> 	cbz	x0, do_v2
> 
> 	mrs	x0, s3_0_c12_c12_5	// ICC_SRE_EL1
> 	and	x0, x0, #1		// SRE bit
> 	cbnz	x0, do_v3
> 
> do_v2:
> 	mov	x0, #0x3fff0000		// Dist
> 	mov	x1, #0x3ffd0000		// CPU
> 	mov	w2, #1
> 	str	w2, [x0]		// Enable Group0
> 	ldr	w2, =0xa0a0a0a0
> 	str	w2, [x0, 0x400]		// A0 priority for SGI0-3
> 	mov	w2, #0x0f
> 	str	w2, [x0, #0x100]	// Enable SGI0-3
> 	mov	w2, #0xf0
> 	str	w2, [x1, #4]		// PMR
> 	mov	w2, #1
> 	str	w2, [x1]		// Enable CPU interface
> 	
> 1:
> 	mov	w2, #(2 << 24)		// Interrupt self with SGI0
> 	str	w2, [x0, #0xf00]
> 
> 2:	ldr	w2, [x1, #0x0c]		// GICC_IAR
> 	cmp	w2, #0x3ff
> 	b.ne	3f
> 
> 	wfi
> 	b	2b
> 
> 3:	str	w2, [x1, #0x10]		// EOI
> 
> 	sub	x19, x19, #1
> 	cbnz	x19, 1b
> 
> die:
> 	mov	x0, #0x84000000
> 	add	x0, x0, #9
> 	hvc	#0
> 	b	.
> 
> do_v3:
> 	mov	x0, #0x3fff0000		// Dist
> 	mov	x1, #0x3fbf0000		// Redist 0
> 	mov	x2, #0x10000
> 	add	x1, x1, x2		// SGI page
> 	mov	w2, #2
> 	str	w2, [x0]		// Enable Group1
> 	ldr	w2, =0xa0a0a0a0
> 	str	w2, [x1, 0x400]		// A0 priority for SGI0-3
> 	mov	w2, #0x0f
> 	str	w2, [x1, #0x100]	// Enable SGI0-3
> 	mov	w2, #0xf0
> 	msr	S3_0_c4_c6_0, x2	// PMR
> 	mov	w2, #1
> 	msr	S3_0_C12_C12_7, x2	// Enable Group1
> 
> 1:
> 	mov	x2, #1
> 	msr	S3_0_c12_c11_5, x2	// Self SGI0
> 
> 2:	mrs	x2, S3_0_c12_c12_0	// Read IAR1
> 	cmp	w2, #0x3ff
> 	b.ne	3f
> 
> 	wfi
> 	b	2b
> 
> 3:	msr	S3_0_c12_c12_1, x2	// EOI
> 
> 	sub	x19, x19, #1
> 	cbnz	x19, 1b
> 
> 	b	die
> 
> * sysreg trap guest: Perform 2^20 PMSELR_EL0 accesses, and power-off:
> 
> __start:
> 	mov	x19, #(1 << 20)
> 1:	mrs	x0, PMSELR_EL0
> 	sub	x19, x19, #1
> 	cbnz	x19, 1b
> 	mov	x0, #0x84000000
> 	add	x0, x0, #9
> 	hvc	#0
> 	b	.
> 
> * These guests are profiled using perf and kvmtool:
> 
> taskset -c 1 perf stat -e cycles:kh lkvm run -c1 --kernel do_sysreg.bin 2>&1 >/dev/null| grep cycles
> 
> The result is then divided by the number of iterations (2^20).
> 
> These tests have been run on three different platform (two GICv2 based, and one with GICv3 and legacy mode) and shown significant improvements in all cases. I've only touched the arm64 GIC code, but obviously the 32bit code should use it as well once we've migrated it to C.
> 
> Vanilla v4.5-rc4
> 	     A             B            C-v2         C-v3
> Null HVC:   8462          6566          6572         6505
> Self SGI:  11961          8690          9541         8629
> SysReg:     8952          6979          7212         7180
> 
> Patched v4.5-rc4
> 	     A             B            C-v2         C-v3
> Null HVC:   5219  -38%    3957  -39%    5175  -21%   5158  -20%
> Self SGI:   8946  -25%    6658  -23%    8547  -10%   7299  -15%
> SysReg:     5314  -40%    4190  -40%    5417  -25%   5414  -24%
> 
> I've pushed out a branch (kvm-arm64/suck-less) to the usual location, based on -rc4 + a few fixes I also posted today.
> 
> Thanks,
> 
> 	M.
> 
> * From v1:
>   - Fixed a nasty bug dealing with the active Priority Register
>   - Maintenance interrupt lazy saving
>   - More LR hackery
>   - Adapted most of the series for GICv3 as well
> 
> Marc Zyngier (17):
>   arm64: KVM: Switch the sys_reg search to be a binary search
>   ARM: KVM: Properly sort the invariant table
>   ARM: KVM: Enforce sorting of all CP tables
>   ARM: KVM: Rename struct coproc_reg::is_64 to is_64bit
>   ARM: KVM: Switch the CP reg search to be a binary search
>   KVM: arm/arm64: timer: Add active state caching
>   arm64: KVM: vgic-v2: Avoid accessing GICH registers
>   arm64: KVM: vgic-v2: Save maintenance interrupt state only if required
>   arm64: KVM: vgic-v2: Move GICH_ELRSR saving to its own function
>   arm64: KVM: vgic-v2: Do not save an LR known to be empty
>   arm64: KVM: vgic-v2: Only wipe LRs on vcpu exit
>   arm64: KVM: vgic-v2: Make GICD_SGIR quicker to hit
>   arm64: KVM: vgic-v3: Avoid accessing ICH registers
>   arm64: KVM: vgic-v3: Save maintenance interrupt state only if required
>   arm64: KVM: vgic-v3: Do not save an LR known to be empty
>   arm64: KVM: vgic-v3: Only wipe LRs on vcpu exit
>   arm64: KVM: vgic-v3: Do not save ICH_AP0Rn_EL2 for GICv2 emulation
> 
>  arch/arm/kvm/arm.c              |   1 +
>  arch/arm/kvm/coproc.c           |  74 +++++----
>  arch/arm/kvm/coproc.h           |   8 +-
>  arch/arm64/kvm/hyp/vgic-v2-sr.c | 144 +++++++++++++----  arch/arm64/kvm/hyp/vgic-v3-sr.c | 333 ++++++++++++++++++++++++++--------------
>  arch/arm64/kvm/sys_regs.c       |  40 ++---
>  include/kvm/arm_arch_timer.h    |   5 +
>  include/kvm/arm_vgic.h          |   8 +-
>  virt/kvm/arm/arch_timer.c       |  31 ++++
>  virt/kvm/arm/vgic-v2-emul.c     |  10 +-
>  virt/kvm/arm/vgic-v3.c          |   4 +-
>  11 files changed, 452 insertions(+), 206 deletions(-)
> 
> --
> 2.1.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
