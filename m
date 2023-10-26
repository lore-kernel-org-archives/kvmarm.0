Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED89E15B1
	for <kvmarm@lists.linux.dev>; Thu, 26 Oct 2023 01:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59ADD2F4;
	Wed, 25 Oct 2023 18:07:30 -0700 (PDT)
Received: from [10.57.2.160] (unknown [10.57.2.160])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EDFC3F762;
	Wed, 25 Oct 2023 18:06:46 -0700 (PDT)
Message-ID: <34e70291-4657-89ae-4e61-5980bb8ea3ab@arm.com>
Date: Thu, 26 Oct 2023 02:06:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 3/5] KVM: selftests: Generate sysreg-defs.h and add to
 include path
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, Jing Zhang <jingzhangos@google.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Ian Rogers <irogers@google.com>,
 Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-4-oliver.upton@linux.dev>
 <f25acdcb-269e-fae5-fbbc-54e8d6d05b23@arm.com> <ZTlnbQ2U9ZaAkXYE@linux.dev>
From: Aishwarya TCV <aishwarya.tcv@arm.com>
In-Reply-To: <ZTlnbQ2U9ZaAkXYE@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 25/10/2023 20:07, Oliver Upton wrote:
> On Wed, Oct 25, 2023 at 10:02:36AM +0100, Aishwarya TCV wrote:
>> On 11/10/2023 20:57, Oliver Upton wrote:
>>> Start generating sysreg-defs.h for arm64 builds in anticipation of
>>> updating sysreg.h to a version that depends on it.
>>>
>>> Reviewed-by: Mark Brown <broonie@kernel.org>
>>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>>> ---
>>>  tools/testing/selftests/kvm/Makefile | 23 ++++++++++++++++++++---
>>>  1 file changed, 20 insertions(+), 3 deletions(-)
>>>
>>
>> Hi Oliver,
>>
>>
>> Currently when building kselftest against next-master with arm64 arch
>> and defconfig+kselftest-kvm  “make[4]: *** [Makefile:26: prepare] Error
>> 2” is observed.
> 
> Looks like we're descending into tools/arch/arm64/tools/ w/
> $(srctree) == ".", which I believe is coming from the top makefile. The
> following diff fixes it for me, care to give it a go?
> 
> diff --git a/tools/arch/arm64/tools/Makefile b/tools/arch/arm64/tools/Makefile
> index f867e6036c62..7f64b8bb5107 100644
> --- a/tools/arch/arm64/tools/Makefile
> +++ b/tools/arch/arm64/tools/Makefile

Confirming that the patch worked fine in the testing. Attached the log
below:

make[4]: Entering directory '/linux/tools/testing/selftests/kvm'
Makefile:270: warning: overriding recipe for target
'/linux/build-arm64/kselftest/kvm/get-reg-list'
Makefile:265: warning: ignoring old recipe for target
'/linux/build-arm64/kselftest/kvm/get-reg-list'
make -C ../../../../tools/arch/arm64/tools/
make[5]: Entering directory '/linux/tools/arch/arm64/tools'
  GEN     /linux/tools/arch/arm64/include/generated/asm/sysreg-defs.h
make[5]: Leaving directory '/linux/tools/arch/arm64/tools'

Thanks,
Aishwarya
