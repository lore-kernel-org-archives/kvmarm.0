From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 0/8] arm/arm64: KVM: limit icache invalidation to
 prefetch aborts
Date: Sat, 21 Oct 2017 17:24:55 +0200
Message-ID: <20171021152455.GF12618@cbox>
References: <20171020154904.31427-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171020154904.31427-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc, Will, Catalain, and Russell,

On Fri, Oct 20, 2017 at 04:48:56PM +0100, Marc Zyngier wrote:
> It was recently reported that on a VM restore, we seem to spend a
> disproportionate amount of time invalidation the icache. This is
> partially due to some HW behaviour, but also because we're being a bit
> dumb and are invalidating the icache for every page we map at S2, even
> if that on a data access.
> 
> The slightly better way of doing this is to mark the pages XN at S2,
> and wait for the the guest to execute something in that page, at which
> point we perform the invalidation. As it is likely that there is a lot
> less instruction than data, we win (or so we hope).
> 
> We also take this opportunity to drop the extra dcache clean to the
> PoU which is pretty useless, as we already clean all the way to the
> PoC...
> 
> Running a bare metal test that touches 1GB of memory (using a 4kB
> stride) leads to the following results on Seattle:
> 
> 4.13:
> do_fault_read.bin:       0.565885992 seconds time elapsed
> do_fault_write.bin:       0.738296337 seconds time elapsed
> do_fault_read_write.bin:       1.241812231 seconds time elapsed
> 
> 4.14-rc3+patches:
> do_fault_read.bin:       0.244961803 seconds time elapsed
> do_fault_write.bin:       0.422740092 seconds time elapsed
> do_fault_read_write.bin:       0.643402470 seconds time elapsed
> 
> We're almost halving the time of something that more or less looks
> like a restore operation. Some larger systems will show much bigger
> benefits as they become less impacted by the icache invalidation
> (which is broadcast in the inner shareable domain). I've tried to
> measure the impact on a VM boot in order to assess the impact of
> taking an extra permission fault, but found that any difference was
> simply noise.
> 
> I've also given it a test run on both Cubietruck and Jetson-TK1.
> 
> Tests are archived here:
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvm-ws-tests.git/
> 
> I'd value some additional test results on HW I don't have access to.

Since these patches are mostly KVM patches I think taking them via the
KVM tree makes the most sense, but they do touch architecture parts of both
arm and arm64.  Are you ok with us merging these via the KVM tree, or do
you prefer some more advanced merge strategy?

The 32-bit arm change is really tiny, but it would be good to have an
ack on patch 1 from the arm64 maintainer.

Thanks,
-Christoffer
