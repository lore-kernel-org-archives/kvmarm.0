Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1543090F5;
	Thu, 13 Aug 2026 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786634949; cv=none; b=sAJ3sVeedA8Svx5u1TYkShdHCjuPbtoV1x8tCLOGtI83gk1z5NssJrg9uKHzzHsRmJs2eFHxSDpZ0nn2O297swAj0I7b/DitoHPBssbnBQbdIRmP7mACi99EuLFIiLcMEEVZnPyuwKp+AdTHxoCarzfTAWAUiQtB7oOx3vjNmZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786634949; c=relaxed/simple;
	bh=hwSP41DeEmtt7lyKNcI/TpZqJSs8Qf3xJssO3OjtPzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HSIMdAM7NS7aUeAOOSY0a0+cNQnJdD7i94og23Le//l+DMAysBYLFKpM9e9HO3ujLgduQAbtQKdLmk/xHFl6XkYFpgnwpgK0QTNvslUdcMfygohxr3ql6YQ3nfbcNYr6lUesv66YYbPfBDBmCw1JKS9mJzs4Z7TzTUlVyi8j9j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=itBB1IFK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="itBB1IFK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A52D1576;
	Thu, 13 Aug 2026 08:29:03 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AEDE3F632;
	Thu, 13 Aug 2026 08:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786634947; bh=hwSP41DeEmtt7lyKNcI/TpZqJSs8Qf3xJssO3OjtPzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=itBB1IFKjNP9DbOkr/kHIFoks2lYJmw2ANl9SZOyFtDGubOYpdT76oI7qrubQEhvS
	 5CjB+gB8LUXcDTjQRcQSWY6Q6ualkMYYZmfwi0DTp/zbv1DYBQRKXsuxkDEpuSoxfE
	 QqxzU6p1Q2t+mx6kzqQs9ixwC+4AMFZV+Ve9mJkc=
Message-ID: <adba8512-ac9e-4d22-86a8-2ffcff837f11@arm.com>
Date: Thu, 13 Aug 2026 15:38:19 +0100
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
 <20260803134403.80630-22-steven.price@arm.com> <yq5a5x1q461s.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5a5x1q461s.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/08/2026 09:57, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
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
>> +		return ARM_EXCEPTION_TRAP;
>> +	case RMI_EXIT_RIPAS_CHANGE:
>> +		rec_exit_hvc(vcpu);
>> +		return ARM_EXCEPTION_TRAP;
>> +	}
> 
> Should we handle RMI_EXIT_RIPAS_CHANGE differently? Currently, the call path is:
> 
> kvm_rec_exit()
> -> RMI_EXIT_RIPAS_CHANGE
> -> handle_hvc()
> -> kvm_rec_handle_hvc()
> -> kvm_prepare_memory_fault_exit()
> 
> Could we instead treat RMI_EXIT_RIPAS_CHANGE as a special case and avoid
> redirecting it through handle_hvc()? The completion part of the RIPAS
> change could still be handled by kvm_rec_handle_request().

Yes that seems like it's slightly neater.

Thanks,
Steve

> 
> -bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret)
> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>  {
> -	struct realm_rec *rec;
> +	struct realm_rec *rec = &vcpu->arch.rec;
>  	struct realm *realm;
>  	unsigned long base;
>  	unsigned long ripas;
>  	unsigned long top;
>  
> -	if (!vcpu_is_rec(vcpu))
> -		return false;
> -
> -	rec = &vcpu->arch.rec;
> -	if (rec->run->exit.exit_reason != RMI_EXIT_RIPAS_CHANGE)
> -		return false;
> -
>  	realm = &vcpu->kvm->arch.realm;
>  	base = rec->run->exit.ripas_base;
>  	top = rec->run->exit.ripas_top;
> @@ -89,8 +83,7 @@ bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret)
>  			 base, top, ripas);
>  		/* Set RMI_REJECT bit */
>  		rec->run->enter.flags = REC_ENTER_FLAG_RIPAS_RESPONSE;
> -		*ret = -EINVAL;
> -		return true;
> +		return -EINVAL;
>  	}
>  
>  	/* Exit to VMM, the actual RIPAS change is done on next entry */
> @@ -102,8 +95,7 @@ bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret)
>  	 * KVM_EXIT_MEMORY_FAULT requires a return code of -EFAULT, see the
>  	 * API documentation
>  	 */
> -	*ret = -EFAULT;
> -	return true;
> +	return -EFAULT;
>  }
>  
>  int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
> @@ -169,8 +161,7 @@ int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>  		kvm_make_request(KVM_REQ_RMI, vcpu);
>  		return ARM_EXCEPTION_TRAP;
>  	case RMI_EXIT_RIPAS_CHANGE:
> -		rec_exit_hvc(vcpu);
> -		return ARM_EXCEPTION_TRAP;
> +		return rec_exit_ripas_change(vcpu);
>  	}
>  
>  	return rec_exit_fatal(vcpu, "Unsupported Realm exit reason",
> 
> -aneesh

