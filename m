From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 21/21] arm64: Panic when VHE and non VHE CPUs coexist
Date: Wed, 3 Feb 2016 20:12:54 +0100
Message-ID: <20160203191254.GD13974@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-22-git-send-email-marc.zyngier@arm.com>
 <20160201153605.GA1478@cbox> <56B0CBF4.9030507@arm.com>
 <20160203084913.GA13974@cbox> <56B23CCB.4000009@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3423412DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2016 14:07:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aF71UuKBvLrT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2016 14:07:00 -0500 (EST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6155E412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2016 14:07:00 -0500 (EST)
Received: by mail-wm0-f42.google.com with SMTP id l66so178398715wml.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Feb 2016 11:12:26 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <56B23CCB.4000009@arm.com>
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

On Wed, Feb 03, 2016 at 05:45:47PM +0000, Marc Zyngier wrote:
> On 03/02/16 08:49, Christoffer Dall wrote:
> > On Tue, Feb 02, 2016 at 03:32:04PM +0000, Marc Zyngier wrote:
> >> On 01/02/16 15:36, Christoffer Dall wrote:
> >>> On Mon, Jan 25, 2016 at 03:53:55PM +0000, Marc Zyngier wrote:
> >>>> Having both VHE and non-VHE capable CPUs in the same system
> >>>> is likely to be a recipe for disaster.
> >>>>
> >>>> If the boot CPU has VHE, but a secondary is not, we won't be
> >>>> able to downgrade and run the kernel at EL1. Add CPU hotplug
> >>>> to the mix, and this produces a terrifying mess.
> >>>>
> >>>> Let's solve the problem once and for all. If you mix VHE and
> >>>> non-VHE CPUs in the same system, you deserve to loose, and this
> >>>> patch makes sure you don't get a chance.
> >>>>
> >>>> This is implemented by storing the kernel execution level in
> >>>> a global variable. Secondaries will park themselves in a
> >>>> WFI loop if they observe a mismatch. Also, the primary CPU
> >>>> will detect that the secondary CPU has died on a mismatched
> >>>> execution level. Panic will follow.
> >>>>
> >>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >>>> ---
> >>>>  arch/arm64/include/asm/virt.h | 17 +++++++++++++++++
> >>>>  arch/arm64/kernel/head.S      | 19 +++++++++++++++++++
> >>>>  arch/arm64/kernel/smp.c       |  3 +++
> >>>>  3 files changed, 39 insertions(+)
> >>>>
> >>>> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> >>>> index 9f22dd6..f81a345 100644
> >>>> --- a/arch/arm64/include/asm/virt.h
> >>>> +++ b/arch/arm64/include/asm/virt.h
> >>>> @@ -36,6 +36,11 @@
> >>>>   */
> >>>>  extern u32 __boot_cpu_mode[2];
> >>>>  
> >>>> +/*
> >>>> + * __run_cpu_mode records the mode the boot CPU uses for the kernel.
> >>>> + */
> >>>> +extern u32 __run_cpu_mode[2];
> >>>> +
> >>>>  void __hyp_set_vectors(phys_addr_t phys_vector_base);
> >>>>  phys_addr_t __hyp_get_vectors(void);
> >>>>  
> >>>> @@ -60,6 +65,18 @@ static inline bool is_kernel_in_hyp_mode(void)
> >>>>  	return el == CurrentEL_EL2;
> >>>>  }
> >>>>  
> >>>> +static inline bool is_kernel_mode_mismatched(void)
> >>>> +{
> >>>> +	/*
> >>>> +	 * A mismatched CPU will have written its own CurrentEL in
> >>>> +	 * __run_cpu_mode[1] (initially set to zero) after failing to
> >>>> +	 * match the value in __run_cpu_mode[0]. Thus, a non-zero
> >>>> +	 * value in __run_cpu_mode[1] is enough to detect the
> >>>> +	 * pathological case.
> >>>> +	 */
> >>>> +	return !!ACCESS_ONCE(__run_cpu_mode[1]);
> >>>> +}
> >>>> +
> >>>>  /* The section containing the hypervisor text */
> >>>>  extern char __hyp_text_start[];
> >>>>  extern char __hyp_text_end[];
> >>>> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> >>>> index 2a7134c..bc44cf8 100644
> >>>> --- a/arch/arm64/kernel/head.S
> >>>> +++ b/arch/arm64/kernel/head.S
> >>>> @@ -577,7 +577,23 @@ ENTRY(set_cpu_boot_mode_flag)
> >>>>  1:	str	w20, [x1]			// This CPU has booted in EL1
> >>>>  	dmb	sy
> >>>>  	dc	ivac, x1			// Invalidate potentially stale cache line
> >>>> +	adr_l	x1, __run_cpu_mode
> >>>> +	ldr	w0, [x1]
> >>>> +	mrs	x20, CurrentEL
> >>>> +	cbz	x0, skip_el_check
> >>>> +	cmp	x0, x20
> >>>> +	bne	mismatched_el
> >>>
> >>> can't you do a ret here instead of writing the same value and flushing
> >>> caches etc.?
> >>
> >> Yes, good point.
> >>
> >>>
> >>>> +skip_el_check:			// Only the first CPU gets to set the rule
> >>>> +	str	w20, [x1]
> >>>> +	dmb	sy
> >>>> +	dc	ivac, x1	// Invalidate potentially stale cache line
> >>>>  	ret
> >>>> +mismatched_el:
> >>>> +	str	w20, [x1, #4]
> >>>> +	dmb	sy
> >>>> +	dc	ivac, x1	// Invalidate potentially stale cache line
> >>>> +1:	wfi
> >>>
> >>> I'm no expert on SMP bringup, but doesn't this prevent the CPU from
> >>> signaling completion and thus you'll never actually reach the checking
> >>> code in __cpu_up?
> >>
> >> Indeed, and that's the whole point. The primary CPU will notice that the
> >> secondary CPU has failed to boot (timeout), and will find the reason in
> >> __run_cpu_mode.
> >>
> > That wasn't exactly my point.  If I understand correctly and __cpu_up is
> > the primary CPU executing a function to bring up a secondary core, then
> > it will wait for the cpu_running completion which should be signalled by
> > the secondary core, but because the secondary core never makes any
> > progress it will timeout the wait for completion and you will see that
> > error "..failed to come online" instead of the "incompatible execution
> > level".
> 
> It will actually do both. Here's an example on the model configured for
> such a braindead case:
> 
> CPU4: failed to come online
> Kernel panic - not syncing: CPU4: incompatible execution level
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.5.0-rc2+ #5459
> Hardware name: FVP Base (DT)
> Call trace:
> [<ffffffc0000899e0>] dump_backtrace+0x0/0x180
> [<ffffffc000089b74>] show_stack+0x14/0x20
> [<ffffffc000333b08>] dump_stack+0x90/0xc8
> [<ffffffc00014d424>] panic+0x10c/0x250
> [<ffffffc00008ef24>] __cpu_up+0xfc/0x100
> [<ffffffc0000b7a9c>] _cpu_up+0x154/0x188
> [<ffffffc0000b7b54>] cpu_up+0x84/0xa8
> [<ffffffc0009e9d00>] smp_init+0xbc/0xc0
> [<ffffffc0009dca10>] kernel_init_freeable+0x94/0x1ec
> [<ffffffc000712f90>] kernel_init+0x10/0xe0
> [<ffffffc000085cd0>] ret_from_fork+0x10/0x40
> 
> Am I missing something *really* obvious?
> 
No, I was, it says "ret = -EIO;" not "return -EIO"...

sorry.

-Christoffer
