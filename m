Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8234DEC05;
	Thu, 17 Sep 2026 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663732; cv=none; b=NJJeVoS5B59LwQtkujvpARejgUqKR6ZLdGmRerHFkTZw5tne8tLgpJ2xX+u6ZqOSW7XRTayIGAPwHIdSTothVfLGXueQEsFegaix7RtBL7pymgZTBhlHSGT1QMyRLX6KvG9Sszz3ZuukeYr8HIYcboadqj6Bx2Sm3VKwHukxl/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663732; c=relaxed/simple;
	bh=v2C7EiRZuO4diAaDVWghy6mD5U5YPo2XvV9CYJSeGiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VKl3mwzztV/M9nF7GUmNzeMjhOetfzOaURnZDUjl+zS8dZccoAHyzvfk+F1xcM6Vg4CW7z75+QZnhel9DtfMEOHDr4+ieXr14iBUZNGSi/iQLEQp3Oox1pgcKy7wem87MHUYxaxlbUPad3Ew8ikM74JXQKp+JkQHOzBqi3yfYmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dbf7TZpW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dbf7TZpW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1422143D;
	Thu, 17 Sep 2026 09:48:46 -0700 (PDT)
Received: from [10.57.6.197] (unknown [10.57.6.197])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 886E13F86F;
	Thu, 17 Sep 2026 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789663730; bh=v2C7EiRZuO4diAaDVWghy6mD5U5YPo2XvV9CYJSeGiQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dbf7TZpWogEREN5RtxsT/Ausx25/I4HOlW/ITLaj4+pQXjm4b7U/AGcpjhwZoulPA
	 gVQE4SzxWT43WU1WQtx3stH4r63UHBcaPC3cu+7Z+VBaHDnmHer/mADG0jng9X3W14
	 CT+yQz3WNYuJywEWBzHIlrYl+7VHRdeC1KfxlkUg=
Message-ID: <888527d9-6355-45fc-b4a1-e485ae32d377@arm.com>
Date: Thu, 17 Sep 2026 17:48:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 12/23] KVM: arm64: Widen the scope of "protected" VMs
Content-Language: en-GB
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-13-suzuki.poulose@arm.com>
 <CA+EHjTxfbG6-LPjJVoErQ3iJk4vAvhVO=Qv6hjcxDXL0yByiQA@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTxfbG6-LPjJVoErQ3iJk4vAvhVO=Qv6hjcxDXL0yByiQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/09/2026 12:51, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Tue, 15 Sep 2026 17:01:30 +0100, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
> [...]
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> [...]
>> -#define kvm_vm_is_protected(kvm)        ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
>> +#define kvm_vm_is_protected(kvm)        ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>> +#define kvm_vm_is_protected_pkvm(kvm)        ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
>>   #define kvm_vm_is_unprotected_pkvm(kvm)        ((kvm)->arch.vm_flavor == VM_PKVM)
> 
> Agree with Marc that this belongs in patch 5. When it moves, could you
> add vcpu_is_protected_pkvm() next to vcpu_is_protected()? The pKVM
> host-side series [1] has vcpu_is_protected() checks that are pKVM
> mechanism (the vCPU feature allowlist, CPU_ON against the pKVM
> power-off state, the ONE_REG rejection after the first run), and with
> the wider predicate those have to carry a pKVM-specific name.

Ack.

Suzuki

> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20260914113338.159227-1-fuad.tabba@linux.dev/

