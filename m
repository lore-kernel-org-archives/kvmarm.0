Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786BC44AB79;
	Tue,  4 Aug 2026 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785855566; cv=none; b=mcGGPuX3buKyvIOpwPZZt/yV+8WbiZkEpWvcZZXzGBRGm9eLmouq0QDi0ZFQ9YLTIRFDNjhtvftgc/ySy6KAeYwcXOVY4KVZmaTNjyVKduowaL+0MUdM+o0f3xNLFqG8RcRdCGBMKye3WfSaa5eDiiPSEafejXBi8hd+wWSONy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785855566; c=relaxed/simple;
	bh=jM2dy1jPgBL1qNkC+4PhadiOipaYVgTdH7ArBTEfwHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m/lx9/MWTa0KXN+cJjGU7CagY8HQqcKJsTNk9MLRNQCI8wX2J/HJC9I9PT64wrUIT5yZD+rzPUQFRBZETiJTj6nyiuE2xDspSHsX01ZRkZWOMvlt2yUzUBV3J+8D0fWrPuAbFIifq3845wQI179BRlkEjI9yHRKvsdkz8u0AUT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nNVIav5D; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nNVIav5D"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B3051476;
	Tue,  4 Aug 2026 07:59:14 -0700 (PDT)
Received: from [10.57.44.180] (unknown [10.57.44.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06CB13F86F;
	Tue,  4 Aug 2026 07:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785855558; bh=jM2dy1jPgBL1qNkC+4PhadiOipaYVgTdH7ArBTEfwHI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nNVIav5DEDiR2UTAwZM5v9LaRsiCTiyK80xUupzMVosPgD9BCL2T19cYcc2SLIQkD
	 F6G5qSTE3K+VwIaJKkkSRpA3BmRaw0+ntT60xn2CrJQKCdID7Jf37/T+d6cyelnsmX
	 4Nn1Gl7QvaAe8Bt/JHbT+GCpb9GQOmJqQYeUPljA=
Message-ID: <039f66ef-85bc-49e0-9843-4b102c94ba76@arm.com>
Date: Tue, 4 Aug 2026 15:59:11 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 11/45] KVM: arm64: CCA: Check for RMI support at KVM
 init
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-12-steven.price@arm.com>
 <CA+EHjTwoKj+c-ZS7W4fCAMYWSgrc+15QWBxu_sE-PMECr+8zpA@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTwoKj+c-ZS7W4fCAMYWSgrc+15QWBxu_sE-PMECr+8zpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/08/2026 15:55, Fuad Tabba wrote:
> Hi Steven,
> 
> On Mon, 3 Aug 2026 at 14:45, Steven Price <steven.price@arm.com> wrote:
> ...
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index bae2c4f92ef5..1a5e15040111 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -27,6 +27,7 @@
>>   #include <asm/fpsimd.h>
>>   #include <asm/kvm.h>
>>   #include <asm/kvm_asm.h>
>> +#include <asm/kvm_rmi.h>
>>   #include <asm/vncr_mapping.h>
>>
>>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>> @@ -424,6 +425,9 @@ struct kvm_arch {
>>          /* Nested virtualization info */
>>          struct dentry *debugfs_nv_dentry;
>>   #endif
>> +
>> +       bool is_realm;
>> +       struct realm realm;
>>   };
> 
> Marc suggested at v10 making the pKVM and CCA state here a union,
> given the two are exclusive, and I believe you acked it [1]. Was there
> an issue with it, or did it just get lost across the respins?

Most likely lost in the respins. Will pick this up.

Thanks for spotting.

Cheers
Suzuki

