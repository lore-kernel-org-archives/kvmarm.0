Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45B8320A
	for <kvmarm@lists.linux.dev>; Tue, 14 Mar 2023 11:04:17 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DBFC4B3;
	Tue, 14 Mar 2023 04:04:55 -0700 (PDT)
Received: from e120937-lin (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84F6E3F67D;
	Tue, 14 Mar 2023 04:04:10 -0700 (PDT)
Date: Tue, 14 Mar 2023 11:04:00 +0000
From: Cristian Marussi <cristian.marussi@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Jeremy Linton <jeremy.linton@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: Circular lockdep in kvm_reset_vcpu() ?
Message-ID: <ZBBUoBsfGokxiBzC@e120937-lin>
References: <f6452cdd-65ff-34b8-bab0-5c06416da5f6@arm.com>
 <Y+bnybGEkMpZzm/y@linux.dev>
 <ZA72c+TT9epTcvX4@e120937-lin>
 <3496a6a10b2d8693825e733b871938f5@misterjones.org>
 <ZA9pUNZPyFtLDfxC@e120937-lin>
 <82978ec75c0b34203dd1df693e7adf83@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82978ec75c0b34203dd1df693e7adf83@kernel.org>

On Tue, Mar 14, 2023 at 09:28:25AM +0000, Marc Zyngier wrote:
> On 2023-03-13 18:20, Cristian Marussi wrote:
> > On Mon, Mar 13, 2023 at 02:09:55PM +0000, Marc Zyngier wrote:
> 
> > > And -rc2 works just fine here.
> > 
> > Thanks, I'll dig deeper what's going on un my setup.
> 
> Actually, you really want this patch[1] which is on its
> way to Linus.
> 
> It could explain the issue you're seeing with SMP.

Hi Marc,

thanks this just solves for me on JUNO with guest SMP.

Indeed with earlycon on JUNO with SMP I was seeing, beside a lot of
workqueue lockup that finally hanged the guest, some puzzling
'time-traveling' stamps that seemed to align more with the host time
than the guest.

    [    0.509305] thermal_sys: Registered thermal governor 'step_wise'
    [    0.509327] thermal_sys: Registered thermal governor 'power_allocator'
    [  282.404523] audit: type=2000 audit(0.372:1): state=initialized audit_enabled=0 res=1
    [    0.526380] cpuidle: using governor menu
    [    0.530378] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
    [    0.536241] ASID allocator initialised with 65536 entries
    [    0.547455] Serial: AMBA PL011 UART driver
    [    0.563267] Callback from call_rcu_tasks() invoked.
    [  282.463816] KASLR disabled due to lack of seed
    [  282.470356] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
    [  282.476182] HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
    ....
    .....
    [  345.799753] io scheduler bfq registered
    [  126.753573] watchdog: BUG: soft lockup - CPU#0 stuck for 118s! [kworker/u4:0:9]
    [  126.759801] Modules linked in:
    [  126.762397] irq event stamp: 713

Thanks a lot for the help.
Cristian
