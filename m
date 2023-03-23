Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED2E8F6D
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 12:56:27 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1244F4B3;
	Thu, 23 Mar 2023 05:57:05 -0700 (PDT)
Received: from [10.57.64.178] (unknown [10.57.64.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 13E903F71E;
	Thu, 23 Mar 2023 05:56:19 -0700 (PDT)
Message-ID: <4eca298b-411f-e6db-04d2-e8963a0e5d98@arm.com>
Date: Thu, 23 Mar 2023 12:56:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v2 0/3] KVM: selftests: Fixes for broken tests
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230308110948.1820163-1-ryan.roberts@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20230308110948.1820163-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

Just a polite nudge on this: I was originally hoping to get these into 6.3 since
I thought they were fairly uncontroversial and clearly fixing bugs. What are my
chances?

Thanks,
Ryan


On 08/03/2023 11:09, Ryan Roberts wrote:
> Hi Oliver,
> 
> Here is a respin of the KVM selftests fixes, with your nits addressed; I've
> fixed the footer whitespace issue and I'm now using FIELD_GET() in the place
> where you suggested and a couple of other places too. I've also included the 3rd
> patch in this series (the ttbr0_el1 fix), which I originally sent separately -
> this is now using FIELD_GET() too.
> 
> So this series superceeds [1] and [2].
> 
> Thanks,
> Ryan
> 
> [1] https://lore.kernel.org/kvmarm/e8ed178a-0c67-3e00-a085-1d88fb3cb41f@arm.com/
> [2] https://lore.kernel.org/kvmarm/20230302152033.242073-1-ryan.roberts@arm.com/
> 
> Ryan Roberts (3):
>   KVM: selftests: Fixup config fragment for access_tracking_perf_test
>   KVM: selftests: arm64: Fix pte encode/decode for PA bits > 48
>   KVM: selftests: arm64: Fix ttbr0_el1 encoding for PA bits > 48
> 
>  tools/testing/selftests/kvm/config            |  1 +
>  .../selftests/kvm/lib/aarch64/processor.c     | 39 ++++++++++++++-----
>  2 files changed, 30 insertions(+), 10 deletions(-)
> 
> --
> 2.25.1
> 
> 

