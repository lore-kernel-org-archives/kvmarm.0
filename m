From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v4 03/11] arm/arm64: smp:
 support more than 8 cpus
Date: Wed, 9 Nov 2016 13:13:00 +0100
Message-ID: <20161109121300.u3pnyblrcni57pzy@kamzik.brq.redhat.com>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
 <1478636499-14339-4-git-send-email-drjones@redhat.com>
 <f5509dd7-594b-04c8-20b0-2986fe1bcc41@arm.com>
 <20161109115732.hpiaiigtgfgnrybt@kamzik.brq.redhat.com>
 <33e2c904-cea1-6d21-4be9-b3fbd037c563@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <33e2c904-cea1-6d21-4be9-b3fbd037c563@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: peter.maydell@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, eric.auger@redhat.com, qemu-arm@nongnu.org, pbonzini@redhat.com, alex.bennee@linaro.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 09, 2016 at 12:01:42PM +0000, Andre Przywara wrote:
> Hi,
> 
> On 09/11/16 11:57, Andrew Jones wrote:
> > On Wed, Nov 09, 2016 at 11:12:03AM +0000, Andre Przywara wrote:
> > [...]
> >>> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> >>> index 7e7b39f11dde..b6e2d5815e72 100644
> >>> --- a/lib/arm/setup.c
> >>> +++ b/lib/arm/setup.c
> >>> @@ -24,12 +24,22 @@ extern unsigned long stacktop;
> >>>  extern void io_init(void);
> >>>  extern void setup_args_progname(const char *args);
> >>>  
> >>> -u32 cpus[NR_CPUS] = { [0 ... NR_CPUS-1] = (~0U) };
> >>> +u64 cpus[NR_CPUS] = { [0 ... NR_CPUS-1] = (~0U) };
> >>
> >> This should be ~0UL.
> > 
> > Indeed. Thanks.
> > 
> >> Also I think the type should be unsigned long to match the types used
> >> everywhere else.
> > 
> > I'll change mpidr_to_cpu to return u64 instead of unsigned long.
> 
> I am not sure this is the right direction. unsigned long is really the
> natural type for MPIDR, since this is a system register with exactly the
> native register size.
> I think we use it this way in the kernel.

OK, actually, considering arm32 and arm64 should both implement
mpidr_to_cpu, and the interface should be consistent, then unsigned
long is the only way.

Thanks,
drew
