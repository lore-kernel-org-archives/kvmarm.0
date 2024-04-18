Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A3616F8E5;
	Thu, 18 Apr 2024 16:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713456387; cv=none; b=NAdue/qNVDCzv1leAKzuXn2UrLm2U1nPJPHobQO54rDeini4ZyHclvuFl+QOb1i78fa894JMOUeG6K/5Nk39ccHktEYuZ87xWM84UlQGDLACAoTapZvbet7Gc+YVOf67g1r2NCAwXK8r8jZxqGlTiu/ptjetb8eiDvCUG3phpGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713456387; c=relaxed/simple;
	bh=h09iCW/axBdidz8NSHC6ATGFyq1RaAUUpwPJbfK8h20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E89HFqjPeAb+zjnXwzgdpYlEktWAgt73hPgsUfWdY2BmVDy/R796k7RpMtzc6pZWe3tNmM3xiWfcu87nkuHnJzu2YPEnFTyNjdXRdSzdWHe0+m6BF2Jwo6/UGqWGgD+UsJDR85nwFEqk+SH3vTtK6+PJ9+LuIyM4diwRBbeDDAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 071022F;
	Thu, 18 Apr 2024 09:06:53 -0700 (PDT)
Received: from [10.57.84.16] (unknown [10.57.84.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CEBC3F64C;
	Thu, 18 Apr 2024 09:06:22 -0700 (PDT)
Message-ID: <23173718-1e44-49ce-9666-4443c7295ed8@arm.com>
Date: Thu, 18 Apr 2024 17:06:20 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 33/43] arm64: rme: Enable PMU support with a realm
 guest
Content-Language: en-GB
To: kernel test robot <lkp@intel.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240412084309.1733783-34-steven.price@arm.com>
 <202404140723.GKwnJxeZ-lkp@intel.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <202404140723.GKwnJxeZ-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/04/2024 00:44, kernel test robot wrote:
> Hi Steven,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on kvmarm/next]
> [also build test ERROR on kvm/queue arm64/for-next/core linus/master v6.9-rc3 next-20240412]
> [cannot apply to kvm/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/KVM-Prepare-for-handling-only-shared-mappings-in-mmu_notifier-events/20240412-170311
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> patch link:    https://lore.kernel.org/r/20240412084309.1733783-34-steven.price%40arm.com
> patch subject: [PATCH v2 33/43] arm64: rme: Enable PMU support with a realm guest
> config: arm64-randconfig-r064-20240414 (https://download.01.org/0day-ci/archive/20240414/202404140723.GKwnJxeZ-lkp@intel.com/config)
> compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 8b3b4a92adee40483c27f26c478a384cd69c6f05)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240414/202404140723.GKwnJxeZ-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202404140723.GKwnJxeZ-lkp@intel.com/

I guess the problem is with CONFIG_HW_PERF_EVENT not set, arm_pmu is an
empty struct, triggering all these errors.

Suzuki


