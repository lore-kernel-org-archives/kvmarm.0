Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C483955F0;
	Thu, 13 Aug 2026 15:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786634955; cv=none; b=QMzGw4jyPnUzQPt6l7n5crOU183ZA6iOQ04ZemzdcFDShogXx2Hkxk5gGGPuZCZgglpWVQq8s18C4j8FL2oSbb0YNISwuHWtD6y5CpH2UU5+7yi0LDRvcbmvLgyJNtpCH2UnBsaMAXSsnS8VTTjH2d/VjTYQpfqHadpNjSRV1qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786634955; c=relaxed/simple;
	bh=/QD7BRHajvoQsee6evmAg1MF6Mele3ZPoIrU1O/8bqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EEQFx76JxrUOfFuKqaKCZB+wKeW5gy70wxI7FfCSNX/yyzjmbLv6nY5BDjQNy70uf2OeNN3SUQ6shViP7/8nHqgN60hiBzrCK88eO99xExZZjYg+/XLKZ6LKKTxmx4j/B5z3EtBydD30Mf2rX2/BbGGUXy1e4N7mUMi5jSMqSck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WVwsfOlz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WVwsfOlz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 298761576;
	Thu, 13 Aug 2026 08:29:09 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2FA5B3F632;
	Thu, 13 Aug 2026 08:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786634953; bh=/QD7BRHajvoQsee6evmAg1MF6Mele3ZPoIrU1O/8bqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WVwsfOlzjKMLQCPV/Kun+w+rcBJQ56P0bCLXJQcQH51ZRSbmJt9LdaqGEvNLwUh/u
	 zU6TjugDY38iS6UzQ4WvkoUx2Hs1mWylme0xEXkUQe5wRDoeSaKo73ycu+VyyfHY3k
	 1qZXM3/+R1fGvFSiETSCfNb01S8ZovMwfZp/uenA=
Message-ID: <23ef41bc-1028-4cc0-8415-d93d60b0ac47@arm.com>
Date: Thu, 13 Aug 2026 15:38:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 21/45] KVM: arm64: CCA: Handle realm enter/exit
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-22-steven.price@arm.com> <yq5a33wu3t4k.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5a33wu3t4k.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/08/2026 14:36, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
>> +
>> +	switch (rec->run->exit.exit_reason) {
>> +	case RMI_EXIT_SYNC:
>> +		/*
>> +		 * HPFAR_EL2_NS is hijacked to indicate a valid HPFAR value,
>> +		 * see __get_fault_info()
>> +		 */
>> +		vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar | HPFAR_EL2_NS;
>> +		rec_exit_sync(vcpu);
>> +		return ARM_EXCEPTION_TRAP;
>> +	case RMI_EXIT_IRQ:
>> +	case RMI_EXIT_FIQ:
>> +		return ARM_EXCEPTION_IRQ;
>> +	case RMI_EXIT_SERROR:
>> +		return ARM_EXCEPTION_EL1_SERROR;
>> +	case RMI_EXIT_PSCI:
>> +		rec_exit_hvc(vcpu);
>> +		kvm_make_request(KVM_REQ_RMI, vcpu);
>>
> 
> I'm also wondering whether we can move the kvm_make_request() call until
> after the PSCI/HOST_CALL handling is complete. I tried a quick hack, but
> it did not look particularly clean, since we would end up adding
> RMM-specific checks in handle_hvc():
> 
> ret = kvm_smccc_call_handler(vcpu);
> 
> if (vcpu_is_rec(vcpu) &&
>     (vcpu->arch.rec.run->exit.exit_reason == RMI_EXIT_PSCI ||
>      vcpu->arch.rec.run->exit.exit_reason == RMI_EXIT_HOST_CALL))
> 	kvm_make_request(KVM_REQ_RMI, vcpu);
> 
> That said, having rec_exit_hvc(vcpu) and kvm_make_request() back-to-back
> is also somewhat confusing. Perhaps we could at least add a comment
> explaining why the request must always be made here.

Agreed, a comment would make it clearer what's going on. I'll add that.
As you say I'm not convinced trying to delay the kvm_make_request() call
is the answer because it ends up with an ugly RMM-specific check.

Thanks,
Steve

> 
>> +		return ARM_EXCEPTION_TRAP;
>> +	case RMI_EXIT_RIPAS_CHANGE:
>> +		rec_exit_hvc(vcpu);
>> +		return ARM_EXCEPTION_TRAP;
>> +	}
>> +
>> +	return rec_exit_fatal(vcpu, "Unsupported Realm exit reason",
>> +			      rec->run->exit.exit_reason);
>> +}
> 
> -aneesh

