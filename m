Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7780B7B
	for <kvmarm@lists.linux.dev>; Tue, 25 Apr 2023 13:00:45 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D8A34B3;
	Tue, 25 Apr 2023 06:01:28 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDB133F64C;
	Tue, 25 Apr 2023 06:00:42 -0700 (PDT)
Date: Tue, 25 Apr 2023 14:00:32 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
	oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 3/6] arm: pmu: Add extra DSB barriers in
 the mem_access loop
Message-ID: <ZEfO8DwsseerTKfK@monolith.localdoman>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-4-eric.auger@redhat.com>
 <ZEJkozep6M4EqxPW@monolith.localdoman>
 <48ea7b8f-8bc3-def5-3bfa-e4a1ee41971a@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ea7b8f-8bc3-def5-3bfa-e4a1ee41971a@redhat.com>

Hi,

On Mon, Apr 24, 2023 at 10:11:11PM +0200, Eric Auger wrote:
> Hi Alexandru,
> 
> On 4/21/23 12:25, Alexandru Elisei wrote:
> > Hi,
> >
> > On Wed, Mar 15, 2023 at 12:07:22PM +0100, Eric Auger wrote:
> >> The mem access loop currently features ISB barriers only. However
> >> the mem_access loop counts the number of accesses to memory. ISB
> >> do not garantee the PE cannot reorder memory access. Let's
> >> add a DSB ISH before the write to PMCR_EL0 that enables the PMU
> >> and after the last iteration, before disabling the PMU.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>
> >> ---
> >>
> >> This was discussed in https://lore.kernel.org/all/YzxmHpV2rpfaUdWi@monolith.localdoman/
> >> ---
> >>  arm/pmu.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/arm/pmu.c b/arm/pmu.c
> >> index b88366a8..dde399e2 100644
> >> --- a/arm/pmu.c
> >> +++ b/arm/pmu.c
> >> @@ -301,6 +301,7 @@ static void mem_access_loop(void *addr, long loop, uint32_t pmcr)
> >>  {
> >>  	uint64_t pmcr64 = pmcr;
> >>  asm volatile(
> >> +	"       dsb     ish\n"
> > I think it might still be possible to reorder memory accesses which are
> > part of the loop after the DSB above and before the PMU is enabled below.
> > But the DSB above is needed to make sure previous memory accesses, which
> > shouldn't be counted as part of the loop, are completed.
> >
> > I would put another DSB after the ISB which enables the PMU, that way all
> > memory accesses are neatly sandwitches between two DSBs.
> >
> > Having 3 DSBs might look like overdoing it, but I reason it to be correct.
> > What do you think?
> I need more time to investigate this. I will come back to you next week
> as I am OoO this week. Sorry for the inconvenience.

That's fine, I'm swamped too with other things, so don't expect a quick reply
:)

Thanks,
Alex

> Thank you for the review!
> 
> Eric
> >
> > Thanks,
> > Alex
> >
> >>  	"       msr     pmcr_el0, %[pmcr]\n"
> >>  	"       isb\n"
> >>  	"       mov     x10, %[loop]\n"
> >> @@ -308,6 +309,7 @@ asm volatile(
> >>  	"       ldr	x9, [%[addr]]\n"
> >>  	"       cmp     x10, #0x0\n"
> >>  	"       b.gt    1b\n"
> >> +	"       dsb     ish\n"
> >>  	"       msr     pmcr_el0, xzr\n"
> >>  	"       isb\n"
> >>  	:
> >> -- 
> >> 2.38.1
> >>
> >>
> 
