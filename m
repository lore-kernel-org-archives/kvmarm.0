Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEE18465
	for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 14:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29ABC43443;
	Tue, 28 Mar 2023 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680012925;
	bh=49m7YtzLSlQ7IsIak5a6PdN9lSIxklya7T1YSDvOg8U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bBQh0oyXYzfRuT69hkDXpPq9oaxAT+alyCX3MSUJeFS44/ksMq9EJGneDyQALmSRw
	 yCR1KjfbfpVvEtL2+Tucd9GWFheKv8zHpTcxYToyfA1QTtZB6qH2RjhkknXZcd7qSg
	 OKAc0q/Ddm3Ve+wyUB/PZgXu6RAsn3LWhPJ9dfMFYBj1nkXMz3rkMnAgdbGWwEgRUt
	 t5AbkVyseS9zniSPRd6r5kdmhwMCE4PgF7lj/96ZSWTbwb7/KyR0CE4dFti1a9DTrR
	 DlBWiJs4kDG+qekukJ1UbfmZTGYAWZHddBBpw/dQe2OThlSKYPYyV1YW1lvydPLSkY
	 FjqL7a3SEs4vg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1phA6d-003nH5-Gr;
	Tue, 28 Mar 2023 15:15:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 28 Mar 2023 15:15:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Sean
 Christopherson <seanjc@google.com>, Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH 05/11] KVM: arm64: Start handling SMCs from EL1
In-Reply-To: <23758eb0-a5b9-afa6-a85e-faa2690323c7@arm.com>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-6-oliver.upton@linux.dev>
 <23758eb0-a5b9-afa6-a85e-faa2690323c7@arm.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <3712e4370dafe95ab828d642dbf064f8@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, oliver.upton@linux.dev, kvmarm@lists.linux.dev, kvm@vger.kernel.org, pbonzini@redhat.com, james.morse@arm.com, yuzenghui@huawei.com, seanjc@google.com, salil.mehta@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-03-28 09:52, Suzuki K Poulose wrote:
> On 20/03/2023 22:09, Oliver Upton wrote:
>> Whelp, the architecture gods have spoken and confirmed that the 
>> function
>> ID space is common between SMCs and HVCs. Not only that, the 
>> expectation
>> is that hypervisors handle calls to both SMC and HVC conduits. KVM
>> recently picked up support for SMCCCs in commit bd36b1a9eb5a ("KVM:
>> arm64: nv: Handle SMCs taken from virtual EL2") but scoped it only to 
>> a
>> nested hypervisor.
>> 
>> Let's just open the floodgates and let EL1 access our SMCCC
>> implementation with the SMC instruction as well.
>> 
>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> One minor observation below.
> 
>> ---
>>   arch/arm64/kvm/handle_exit.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/handle_exit.c 
>> b/arch/arm64/kvm/handle_exit.c
>> index 5e4f9737cbd5..68f95dcd41a1 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -72,13 +72,15 @@ static int handle_smc(struct kvm_vcpu *vcpu)
>>   	 *
>>   	 * We need to advance the PC after the trap, as it would
>>   	 * otherwise return to the same address...
>> -	 *
>> -	 * Only handle SMCs from the virtual EL2 with an immediate of zero 
>> and
>> -	 * skip it otherwise.
>>   	 */
>> -	if (!vcpu_is_el2(vcpu) || kvm_vcpu_hvc_get_imm(vcpu)) {
>> +	kvm_incr_pc(vcpu);
>> +
>> +	/*
>> +	 * SMCs with a nonzero immediate are reserved according to DEN0028E 
>> 2.9
>> +	 * "SMC and HVC immediate value".
>> +	 */
>> +	if (kvm_vcpu_hvc_get_imm(vcpu)) {
>>   		vcpu_set_reg(vcpu, 0, ~0UL);
>> -		kvm_incr_pc(vcpu);
>>   		return 1;
>>   	}
>>   @@ -93,8 +95,6 @@ static int handle_smc(struct kvm_vcpu *vcpu)
>>   	if (ret < 0)
>>   		vcpu_set_reg(vcpu, 0, ~0UL);
> 
> Nothing to do with this patch. But that check above is different
> from how we handle HVC. i.e., we return back to guest for HVCs.
> But for SMCs, we tend to return "ret" indicating an error (ret < 0).
> 
> Do we need to fix that ?

I guess so. It is just that it is practically impossible to get
a negative value at the moment, but it isn't something we should
rely on.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
