Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827C2201270
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 14:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746542830; cv=none; b=riF9i06nqdBTcd0Jhh1QV295bk9dJI45Ju/GUmYEhIcEl1XNJACldUGHvJ44PPqlxrc6EFTPmmhIN7HjuzxIFSvOkt+J6ZXeQASAWPCTqsdGf0gD9MRctO1x2gt3XR4VL2D5FQ5mB46bO18vbwiV7B1VtCq/t9oFN/U1M9Tyf/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746542830; c=relaxed/simple;
	bh=NMQ6gHoepk2Hh+GE5YhvmtUey4N6usZn6VaPR71gppg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1v4k7V8zQVtxlQaQoIi1lWBDbhv0fAe37pfIx9HSGZkT5rTl7rscKQLKtQ4ofdJamXrBKYmVmiOmYKNB7JtmJduiYnGPSxEV91KgAjxoH/tqfxoTBX0PamNF/H6yLtBVOaatR6szKLRqYGfUoB/HuXehULilmsSCDDYuqmGkFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZsLnp0cdTz6K5kv;
	Tue,  6 May 2025 22:46:54 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 0994E14011D;
	Tue,  6 May 2025 22:47:05 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 6 May
 2025 16:47:04 +0200
Date: Tue, 6 May 2025 15:47:02 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
CC: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey
 Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-perf-users@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v21 0/4] arm64/perf: Enable branch stack sampling
Message-ID: <20250506154702.00002b57@huawei.com>
In-Reply-To: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
References: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Mon, 07 Apr 2025 12:41:29 -0500
"Rob Herring (Arm)" <robh@kernel.org> wrote:

> This series enables perf branch stack sampling support on arm64 via a 
> v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details 
> on BRBE can be found in the Arm ARM[1] chapter D18.
> 
> I've picked up this series from Anshuman. v19 and v20 versions have been 
> reworked quite a bit by Mark and myself. The bulk of those changes are 
> in patch 4.
> 
> A git branch is here[2].
> 
> [1] https://developer.arm.com/documentation/ddi0487/latest/
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git arm/brbe-v21

Hi Rob,

Expecting any changes on this?  Anything specific we can do to help then shout.

We need to pull in the reworked version into openeuler that is carrying older
code and would rather not do it more than once. 

Jonathan

> 
> v21:
> - Drop clean-up patches 1-7 already applied
> - Rebase on v6.15-rc1
> 
> v20:
>  - https://lore.kernel.org/r/20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org
>  - Added back some of the arm64 specific exception types. The x86 IRQ 
>    branches also include other exceptions like page faults. On arm64, we 
>    can distinguish the exception types, so we do. Also, to better 
>    align with x86, we convert 'call' branches which are user to kernel 
>    to 'syscall'.
>  - Only enable exceptions and exception returns if recording kernel
>    branches (matching x86)
>  - Drop requiring event and branch privileges to match
>  - Add "branches" caps sysfs attribute like x86
>  - Reword comment about FZP and MDCR_EL2.HPMN interaction
>  - Rework BRBE invalidation to avoid invalidating in interrupt handler
>    when no handled events capture the branch stack (i.e. when there are 
>    multiple users).
>  - Also clear BRBCR_ELx bits in brbe_disable(). This is for KVM nVHE 
>    checks if BRBE is enabled.
>  - Document that MDCR_EL3.SBRBE can be 0b01 also
> 
> v19:
>  - https://lore.kernel.org/all/20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org/
>  - Drop saving of branch records when task scheduled out (Mark). Make 
>    sched_task() callback actually get called. Enabling requires a call 
>    to perf_sched_cb_inc(). So the saving of branch records never 
>    happened.
>  - Got rid of added armpmu ops. All BRBE support is contained within 
>    pmuv3 code.
>  - Fix freeze on overflow for VHE
>  - The cycle counter doesn't freeze BRBE on overflow, so avoid assigning
>    it when BRBE is enabled.
>  - Drop all the Arm specific exception branches. Not a clear need for
>    them.
>  - Fix handling of branch 'cycles' reading. CC field is
>    mantissa/exponent, not an integer.
>  - Rework s/w filtering to better match h/w filtering
>  - Reject events with disjoint event filter and branch filter or with 
>    exclude_host set
>  - Dropped perf test patch which has been applied for 6.14
>  - Dropped patch "KVM: arm64: Explicitly handle BRBE traps as UNDEFINED"
>    which has been applied for 6.14
> 
> v18:
>  - https://lore.kernel.org/all/20240613061731.3109448-1-anshuman.khandual@arm.com/
> 
> For v1-v17, see the above link. Not going to duplicate it all here...
> 
> Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
> ---
> Anshuman Khandual (4):
>       arm64/sysreg: Add BRBE registers and fields
>       arm64: Handle BRBE booting requirements
>       KVM: arm64: nvhe: Disable branch generation in nVHE guests
>       perf: arm_pmuv3: Add support for the Branch Record Buffer Extension (BRBE)
> 
>  Documentation/arch/arm64/booting.rst |  21 +
>  arch/arm64/include/asm/el2_setup.h   |  86 +++-
>  arch/arm64/include/asm/kvm_host.h    |   2 +
>  arch/arm64/include/asm/sysreg.h      |  17 +-
>  arch/arm64/kvm/debug.c               |   4 +
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c   |  32 ++
>  arch/arm64/kvm/hyp/nvhe/switch.c     |   2 +-
>  arch/arm64/tools/sysreg              | 132 ++++++
>  drivers/perf/Kconfig                 |  11 +
>  drivers/perf/Makefile                |   1 +
>  drivers/perf/arm_brbe.c              | 802 +++++++++++++++++++++++++++++++++++
>  drivers/perf/arm_brbe.h              |  47 ++
>  drivers/perf/arm_pmu.c               |  15 +-
>  drivers/perf/arm_pmuv3.c             | 129 +++++-
>  include/linux/perf/arm_pmu.h         |   8 +
>  15 files changed, 1287 insertions(+), 22 deletions(-)
> ---
> base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
> change-id: 20250129-arm-brbe-v19-24d5d9e5e623
> 
> Best regards,

