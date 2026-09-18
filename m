Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457001A3029;
	Fri, 18 Sep 2026 09:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789724842; cv=none; b=aZSgFhvllpR3YMaC6YVvx2NrHH5knkLND16JPH0P6DwTWo0w9/+ipJGNiueS3w+BRalSFrRTHKcvaZQstVtqwo8MzgrU6Zt53cigiShdhL4xufALKr/xRrmYhudmjvUQ/ENmTbjRxMdqZCFOUgq6sacUNXhLb+8mohdXqBfcP4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789724842; c=relaxed/simple;
	bh=eSlqW067KZEESlksS4pzEEOFJpVLZHMuQ6i8lq4fTU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eOACZQMqjW0V+DVbllckaUK0ogqU0RUTs6mfpgLckdTx7b9upuUFj4q91W/mbQG2zYTYYpFkZBmwsf4GawpRFKSyKSCCnbwc6h3VsS/NeuCt9d9bLnm+kCjh8s0CGD0ci48BxglCjwzfLchGu1HAOzKZ1GKGniI46KZ94ZmkwT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fETqMfGi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fETqMfGi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3186168F;
	Fri, 18 Sep 2026 02:47:15 -0700 (PDT)
Received: from [10.57.6.197] (unknown [10.57.6.197])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 801D93F882;
	Fri, 18 Sep 2026 02:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789724839; bh=eSlqW067KZEESlksS4pzEEOFJpVLZHMuQ6i8lq4fTU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fETqMfGisKk6NTxLoU1SBAaZzF4uzWxwEO9GudmINWmDd6C/oSVjhWMWDT2uStWJ5
	 ycmJ+DkKfZGrxwDKDUK3kQ1Wtz273cxB6y7o27WOQyO49zZ/JZpH46scbKmQExn0DR
	 sZ95l4hiNczrmOzTk5BdWjJEPwCKoXP6SGVSRv7s=
Message-ID: <76fb1cc8-60f4-4725-a839-76fcf928e232@arm.com>
Date: Fri, 18 Sep 2026 10:47:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 05/23] KVM: arm64: Track the type of VM in kvm_arch
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-6-suzuki.poulose@arm.com>
 <CA+EHjTz65G0MM=tOrzmk=jMweBX1us6FqfrmSkQs4KSyAEoxhg@mail.gmail.com>
 <e26cbb4e-84e2-4fcc-9eb0-93bfd4aff4a7@arm.com>
 <CA+EHjTw6TOSEs1GtUcUy9WACpGRJBA9yTn9Ro_+tiD=XkeHr4g@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTw6TOSEs1GtUcUy9WACpGRJBA9yTn9Ro_+tiD=XkeHr4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/09/2026 10:14, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On <date>, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> [...]
>> +       if (WARN_ON_ONCE(!kvm))
>> +               return false;
>> +
>> +       /* Cover both pKVM host and Realm VMs */
>> +       if (!kvm_vm_hyp_is_distrusting(kvm))
>> +               return true;
> 
> I'd drop the WARN_ON_ONCE. 

I would say, we need it. i.e., we are filtering kvm_arch_vm_ioctl(),
where it is called from the kvm instance ioctl. So, kvm must be !NULL.


> And this early return needs the `>=` from
> patch 13, or non-protected pKVM VMs skip the filter.
> 

Of course, This snippet is for Patch 20 and I have fixed the comparison.


>> I resorted to is_protected_kvm_enabled() to make it faster than using
>> the vm_flavor checks. I could rever those anyways.
> 
> Agreed it's the faster test. I'd just call it by name at the three
> sites rather than through a macro.
> 
>> Do you mean something like :
>>
>>          if (kvm_vm_is_protected_pkvm(host_kvm))
>>                  hyp_vm->kvm.arch.vm_flavor = VM_PROTECTED_PKVM;
>>          else
>>                  hyp_vm->kvm.arch.vm_flavor = VM_PKVM;
> 
> Yes, exactly that.
> 
>> Do we additionally need to WARN_ON() if we encounter a VM_REALM ?
> 
> No, the host shouldn't be able to trigger a WARN at EL2.

Alright.

> 
>> Apologies, I thought this one didn't change, but later patches changes
>> them, which is why I kept this.
> 
> No worries. With those two in, please keep the tag.

Thanks
Suzuki

> 
> Cheers,
> /fuad

