Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A191AF0CE
	for <kvmarm@lists.linux.dev>; Fri,  4 Apr 2025 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743759869; cv=none; b=hQpwPwt0kX84HhQMxwSqRV921dBeoUy2FSbPMJlHuO6QViGYcY0MnI07F7TGL5bXmt3MjgzrKvzTSJniE+IdG+44s8ORZprZ8hwfhz+VMVcgDoIgUPTcvqHj4+gvB/A4TPZaupfNcF2gJBjnh+CAGsR2343sOg6dtXr4qC4h5gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743759869; c=relaxed/simple;
	bh=f9fYezKx9c+EzFcFbWCCgEz61MqKEZoVC313VdsYY9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JeT2ylf5g0Tt2z3RiGrbclRHM2+7CMR42rQL4ekjFXS2xZhIWXmZw8hFF+pxBlrPVyn2+zu+/SL9PAgoyMNvCH65W3kcr6h5uCZViqwa41oVLBChIDntIyfRPkchAfE2zhpf/To7aHE6z8uk+tUlj8zprotCuk1HfOmZXJmuWaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2E8D1515;
	Fri,  4 Apr 2025 02:44:28 -0700 (PDT)
Received: from [10.162.40.17] (a077893.blr.arm.com [10.162.40.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40D8C3F59E;
	Fri,  4 Apr 2025 02:44:23 -0700 (PDT)
Message-ID: <f0e1ce67-8341-4c44-993c-dac31db00c59@arm.com>
Date: Fri, 4 Apr 2025 15:14:21 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: Expose AIDR_EL1 via sysfs
To: Oliver Upton <oliver.upton@linux.dev>,
 linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20250403231626.3181116-1-oliver.upton@linux.dev>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250403231626.3181116-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/4/25 04:46, Oliver Upton wrote:
> The KVM PV ABI recently added a feature that allows the VM to discover
> the set of physical CPU implementations, identified by a tuple of
> {MIDR_EL1, REVIDR_EL1, AIDR_EL1}. Unlike other KVM PV features, the
> expectation is that the VMM implements the hypercall instead of KVM as
> it has the authoritative view of where the VM gets scheduled.
> 
> To do this the VMM needs to know the values of these registers on any
> CPU in the system. While MIDR_EL1 and REVIDR_EL1 are already exposed,
> AIDR_EL1 is not. Provide it in sysfs along with the other identification
> registers.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu |  1 +
>  Documentation/arch/arm64/cpu-feature-registers.rst | 13 +++++++------
>  arch/arm64/include/asm/cpu.h                       |  1 +
>  arch/arm64/kernel/cpuinfo.c                        |  3 +++
>  4 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 206079d3bd5b..9bbf4c27c237 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -485,6 +485,7 @@ What:		/sys/devices/system/cpu/cpuX/regs/
>  		/sys/devices/system/cpu/cpuX/regs/identification/
>  		/sys/devices/system/cpu/cpuX/regs/identification/midr_el1
>  		/sys/devices/system/cpu/cpuX/regs/identification/revidr_el1
> +		/sys/devices/system/cpu/cpuX/regs/identification/aidr_el1
>  		/sys/devices/system/cpu/cpuX/regs/identification/smidr_el1
>  Date:		June 2016
>  Contact:	Linux ARM Kernel Mailing list <linux-arm-kernel@lists.infradead.org>
> diff --git a/Documentation/arch/arm64/cpu-feature-registers.rst b/Documentation/arch/arm64/cpu-feature-registers.rst
> index 253e9743de2f..add66afc7b03 100644
> --- a/Documentation/arch/arm64/cpu-feature-registers.rst
> +++ b/Documentation/arch/arm64/cpu-feature-registers.rst
> @@ -72,14 +72,15 @@ there are some issues with their usage.
>      process could be migrated to another CPU by the time it uses the
>      register value, unless the CPU affinity is set. Hence, there is no
>      guarantee that the value reflects the processor that it is
> -    currently executing on. The REVIDR is not exposed due to this
> -    constraint, as REVIDR makes sense only in conjunction with the
> -    MIDR. Alternately, MIDR_EL1 and REVIDR_EL1 are exposed via sysfs
> -    at::
> +    currently executing on. REVIDR and AIDR are not exposed due to this
> +    constraint, as these registers only make sense in conjunction with
> +    the MIDR. Alternately, MIDR_EL1, REVIDR_EL1, and AIDR_EL1 are exposed
> +    via sysfs at::
>  
>  	/sys/devices/system/cpu/cpu$ID/regs/identification/
> -	                                              \- midr
> -	                                              \- revidr
> +	                                              \- midr_el1
> +	                                              \- revidr_el1
> +	                                              \- aidr_el1

Right, the existing ones are also marked with _el1 suffix as well.

>  
>  3. Implementation
>  --------------------
> diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
> index 81e4157f92b7..71493b760b83 100644
> --- a/arch/arm64/include/asm/cpu.h
> +++ b/arch/arm64/include/asm/cpu.h
> @@ -44,6 +44,7 @@ struct cpuinfo_arm64 {
>  	u64		reg_dczid;
>  	u64		reg_midr;
>  	u64		reg_revidr;
> +	u64		reg_aidr;
>  	u64		reg_gmid;
>  	u64		reg_smidr;
>  	u64		reg_mpamidr;
> diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
> index 285d7d538342..621218d2a991 100644
> --- a/arch/arm64/kernel/cpuinfo.c
> +++ b/arch/arm64/kernel/cpuinfo.c
> @@ -328,11 +328,13 @@ static const struct kobj_type cpuregs_kobj_type = {
>  
>  CPUREGS_ATTR_RO(midr_el1, midr);
>  CPUREGS_ATTR_RO(revidr_el1, revidr);
> +CPUREGS_ATTR_RO(aidr_el1, aidr);
>  CPUREGS_ATTR_RO(smidr_el1, smidr);
>  
>  static struct attribute *cpuregs_id_attrs[] = {
>  	&cpuregs_attr_midr_el1.attr,
>  	&cpuregs_attr_revidr_el1.attr,
> +	&cpuregs_attr_aidr_el1.attr,
>  	NULL
>  };
>  
> @@ -469,6 +471,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
>  	info->reg_dczid = read_cpuid(DCZID_EL0);
>  	info->reg_midr = read_cpuid_id();
>  	info->reg_revidr = read_cpuid(REVIDR_EL1);
> +	info->reg_aidr = read_cpuid(AIDR_EL1);
>  
>  	info->reg_id_aa64dfr0 = read_cpuid(ID_AA64DFR0_EL1);
>  	info->reg_id_aa64dfr1 = read_cpuid(ID_AA64DFR1_EL1);
> 
> base-commit: e8b471285262d1561feb2eb266aab6ebe7094124

LGTM

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
