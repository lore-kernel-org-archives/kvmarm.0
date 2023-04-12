Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B03B2F24
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 08:49:04 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49EC41684;
	Wed, 12 Apr 2023 01:49:48 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.21.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 523C53F587;
	Wed, 12 Apr 2023 01:49:02 -0700 (PDT)
Date: Wed, 12 Apr 2023 09:48:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Eric Auger <eauger@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: pmu-chain-promotion kvm-unit-test failures in mainline
Message-ID: <ZDZwex6uCrEwS6ds@FVFF77S0Q05N>
References: <cdf922b3-1ac3-438d-8817-6c4d693b1fc3@sirena.org.uk>
 <861qkpmtw3.wl-maz@kernel.org>
 <84aaa360-3f96-d648-0fe3-cb6667542bc7@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84aaa360-3f96-d648-0fe3-cb6667542bc7@redhat.com>

On Wed, Apr 12, 2023 at 10:00:40AM +0200, Eric Auger wrote:
> Hi,
> On 4/12/23 09:39, Marc Zyngier wrote:
> > On Tue, 11 Apr 2023 22:15:02 +0100,
> > Mark Brown <broonie@kernel.org> wrote:
> >>
> >> [1  <text/plain; us-ascii (7bit)>]
> >> Arm's internal test infrastructure has started seeing failures for the
> >> pmu-chain-promption test in kvm-unit-tests on TX2 when running mainline
> >> and kvm-unit-tests commit 2480430a36102f8ea276b3bfb1d64d5dacc23b8f
> >> ("configure: Show the option in case it is not known").  The log I'm
> >> seeing from the test runner is:
> >>
> >> TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
> >> FAIL pmu-chain-promotion (7 tests, 2 unexpected failures)
> >>
> >> Unfortunately I don't have direct access to a TX2 so can't readily
> >> alter the test run other than replacing the kernel.  I believe the
> >> specific failures were:
> >>
> >> FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: CHAIN counter was incremented and overflow
> >> FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: 32b->64b CHAIN counter was incremented and overflow
> > 
> > Is this related to [1]?
> > 
> > 	M.
> > 
> > [1] https://lore.kernel.org/r/20230315110725.1215523-1-eric.auger@redhat.com
> 
> Yes please let me know if it fixes your issue. I also tried bisection
> but it did not lead to anything.

FWIW, that worked for me; I replied there with a Tested-by (and test results).

Thanks,
Mark.
