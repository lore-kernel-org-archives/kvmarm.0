Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6E817727
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 09:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E1C01FB;
	Tue, 10 Oct 2023 02:57:47 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A36973F762;
	Tue, 10 Oct 2023 02:57:04 -0700 (PDT)
Date: Tue, 10 Oct 2023 10:57:02 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	catalin.marinas@arm.com, dave.hansen@linux.intel.com,
	maz@kernel.org, oliver.upton@linux.dev, shuah@kernel.org,
	will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 15/20] arm64: add POE signal support
Message-ID: <20231010095702.GB2098677@e124191.cambridge.arm.com>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-16-joey.gouly@arm.com>
 <a6e6c8a3-15b1-48e3-84fa-810ce575c09a@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6e6c8a3-15b1-48e3-84fa-810ce575c09a@sirena.org.uk>

Hi Mark,

On Thu, Oct 05, 2023 at 03:34:29PM +0100, Mark Brown wrote:
> On Wed, Sep 27, 2023 at 03:01:18PM +0100, Joey Gouly wrote:
> > Add PKEY support to signals, by saving and restoring POR_EL0 from the stackframe.
> 
> It'd be nice to have at least a basic test that validates that we
> generate a POE signal frame when expected, though that should be a very
> minor thing which is unlikely to ever actually spot anything.
> 
> I'd also expect to see matching support added to ptrace.

The selftests/mm/protection_keys.c looks for the POE signal frame, do you think
we need a separate test?

I will look into ptrace.

Thanks,
Joey
