Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D622A3A961E;
	Wed, 15 Jul 2026 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132141; cv=none; b=UZWrxGhRp1YdjeyAna0LC8C35dOxcBnB9paeJkebmQ1BR3Vh1rwqB+A6wmbLyDTzSvqBGRqLnoadTbYkuPQVWwS+79cyV193K8TBjQcBcyCzlLAtWId7VJsax4h5J3rm7XWNLFk48+mk/TRWViQGNv9uIPLV7QbtqOAAKI9GApc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132141; c=relaxed/simple;
	bh=PKg6jBC/MYOa0C63d4sWEQyRzx/nigEWXdfsBnDnOqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CiB117atJ3Ozb/ifFM97Il7e1xZW7yi46ZQmV5c60v6OhvJTj3/W1ruQDryBdV2RAlVoFYAilPv7krv++7YmBYUz10UXKvtbszm7kvYB4HgCmYbHdthCqnxkV++05JE7/w+Hc1c+mWdBSQcVZwRhQlJMPl6qJw1IvZUMKUJQLco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pCu86zEJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pCu86zEJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CD4F1477;
	Wed, 15 Jul 2026 09:15:34 -0700 (PDT)
Received: from [10.1.25.27] (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFBE93F7B4;
	Wed, 15 Jul 2026 09:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784132138; bh=PKg6jBC/MYOa0C63d4sWEQyRzx/nigEWXdfsBnDnOqM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pCu86zEJfeCDXQkrept5gXczJP3GrT+IwQ8hxr8Kqn7Xcv4jZ1lbcV1eA5eSt2B35
	 V2q4PZFuvcGPE5yaqnhq1aRfrG/VElkjm/pykufi7OS5yb9ELmGlV4aO5xgBbEWvgC
	 1nAeKtvsIRkxzANupJeB0PyiH7sTfbSR4a7ot74U=
Message-ID: <ec0f52d4-666d-4b6f-b010-eb0391fa53a7@arm.com>
Date: Wed, 15 Jul 2026 17:15:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 26/37] KVM: arm64: WARN on injected undef exceptions
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-27-steven.price@arm.com> <8733xk5k7v.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8733xk5k7v.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2026 16:46, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 15:28:28 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The RMM doesn't allow injection of a undefined exception into a realm
>> guest. Add a WARN to catch if this ever happens.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v6:
>>  * if (x) WARN(1, ...) makes no sense, just WARN(x, ...)!
>> ---
>>  arch/arm64/kvm/inject_fault.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
>> index 6492397b73d7..613f223bc7a3 100644
>> --- a/arch/arm64/kvm/inject_fault.c
>> +++ b/arch/arm64/kvm/inject_fault.c
>> @@ -327,6 +327,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
>>   */
>>  void kvm_inject_undefined(struct kvm_vcpu *vcpu)
>>  {
>> +	WARN(vcpu_is_rec(vcpu), "Unexpected undefined exception injection to REC");
>>  	if (vcpu_el1_is_32bit(vcpu))
>>  		inject_undef32(vcpu);
>>  	else
> 
> No. WARN_ONCE at a push, but even then, this looks dodgy.

Yep WARN_ONCE() would be better. This function should never be called
for a realm guest.

> Exceptions must be injectable. Otherwise, how do you respond to, for
> example, a sysreg access for a feature that is hidden from the guest?

The RMM doesn't allow the host to inject exceptions - with the exception
of SEA after a host-emulated MMIO.

> Will the RMM perform this in KVM's stead?

Yes the RMM would have to handle this for the likes of sysreg accesses.
The host doesn't control the trapping of sysreg accesses. There are a
few GIC-related registers which are forwarded to the host ("REC exit due
to system register access") but generally the handling of sysregs is
entirely internal to the RMM.

Thanks,
Steve

