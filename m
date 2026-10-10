Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12E843E4BB;
	Sat, 10 Oct 2026 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791625470; cv=none; b=D3MJePniNmyxnSI2ZjJ2LiZw0W1/t02Fm1Pi78r7EosiZa0gp9BT73O7sEWRzK2eGBNJMgUqvZgE/MY7Sh6cXa89o5klIcTO4sZxNBaLOCME9Eg+w5h7Inu6Og41Jq474YoC2YT3+HyGAv+3nndDv/Liwbhkgy7OtWqA/n3yTN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791625470; c=relaxed/simple;
	bh=xSrGiPagtnpCy4QbngWDcah0WpHU1UjhcJFdf8wVURY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DmyS6tv0700ykSvQz9JGOE7cB82FNZowT5cm8Gi6SkpdL/UATSx25rGcB+JyDDRuHL6pzHJa0e4NZBDHoowhNonqB57o4WTpM+kDp2gJLwKbpChJE8WOPXD98kNxofgaIgADMxA2E//s6gmIANmKn6yV9cqMxtGyW+eWbDAWuyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nMSWOd9Z; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nMSWOd9Z"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92F691FC7;
	Sat, 10 Oct 2026 02:44:23 -0700 (PDT)
Received: from [10.57.13.91] (unknown [10.57.13.91])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C318F3F882;
	Sat, 10 Oct 2026 02:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791625466; bh=xSrGiPagtnpCy4QbngWDcah0WpHU1UjhcJFdf8wVURY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nMSWOd9ZAvrx7KVY2EuJHRjAwqDOMCaH5ffSd5GgWZfentbnhQhih3r/UmBO/kkvx
	 w1MbhygHPrXdoV6rvl7tZ0zphsO5KlyBvRv5yH+ibtR5InA9haGeBs614DUhRJPyRu
	 CEtNgeRb8wmw5ws78bwLAlArcsC0aLo/aAHUeKwk=
Message-ID: <80155c78-1cf2-4060-a874-c487ff9fee38@arm.com>
Date: Sat, 10 Oct 2026 10:44:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 00/14] KVM: arm64: CCA: Add basic plumbing for Realms
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 jonathan.cameron@oss.qualcomm.com, Fuad Tabba <fuad.tabba@linux.dev>,
 Sudeep Holla <sudeep.holla@kernel.org>
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
 <179155224299.829527.1733164520192309991.b4-ty@b4>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <179155224299.829527.1733164520192309991.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/10/2026 14:28, Marc Zyngier wrote:
> On Wed, 07 Oct 2026 08:35:23 +0100, Suzuki K Poulose wrote:
>> This is a trimmed down and updated version of the v22 of Arm CCA basic
>> plumbing series [0]. I have dropped the CCA specific bits for the sake keeping
>> them separate. This series now only contains the framework for handling
>> different VM types and lay down the path for adding Realm as one of the
>> protected VMs. The full support for running Realms under KVM is available as
>> an integration branch at [1].
>>
>> [...]
> 
> Applied to next, thanks!
> 
> [01/14] KVM: arm64: protected VM: Handle user writes to CNTVCT_EL0/CNTPCT_EL0
>          commit: 3d736a339e9cbeec3841da1a821f56fb3230fd68
> [03/14] KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
>          commit: 22adb9c3543cc702516c18f0a28e3a8dfcdbeecc
> [04/14] KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
>          commit: 0c4063f89bfdf204112651f45620ef0c5a691e6b
> [05/14] KVM: arm64: Track the type of VM in kvm_arch
>          commit: 762ad274c03a13686192d75ef9a354b96114b503
> [06/14] KVM: arm64: Don't call vcpu_set_pauth_traps for pKVM host
>          commit: 42a4026b435e49af4d5eaae58afe7103ca740c30
> [07/14] KVM: arm64: Refactor the vcpu_load to allow for VM specific callbacks
>          commit: 8252f74f9188b9148ec93438e53b8e1b865ffb7b
> [08/14] KVM: arm64: Add vcpu load/put call backs for flavors
>          commit: 0cb16544ccaceba4c5e8beb2e8ae896278dcf018
> [09/14] KVM: arm64: Consolidate stage2 unmap range into kvm_stage2_unmap_range
>          commit: fb3926af9d0d5e2e2f58a1f4b2252f529fbe23bf
> [10/14] KVM: arm64: Add VM specific callback for S2 MMU operations
>          commit: 68933203edddc092b30dd1039167b3262a40a326
> [11/14] KVM: arm64: Use a local kvm pointer in kvm_handle_guest_abort()
>          commit: 4ee1b583589781bfd47b28da3ce216b2fb51dac5
> [12/14] KVM: arm64: Abstract out memory abort handling
>          commit: b44a8c32f0116aba0a934c3068628bacda3cd3a3
> [13/14] KVM: arm64: Mandate VGIC v3 for pKVM VMs and Realms
>          commit: 37d7ea3f81bbe61f1e895b6c87decadbfe8799eb
> [14/14] KVM: arm64: Prevent unsupported vcpu features for VM types
>          commit: a467f39afc2a149f9f5efbb7238fb531ade8a86e
> 
> FWIW: I've dropped patch #2, which was a duplicate of an equivalent pKVM
> change, kept patch #13 (we can simplify things down the line), and hacked
> the patch #14 merge so that we don't have to describe things twice.
> 
> Of course, mmu.c is where the crap happens, so anyone with any interest
> in this stuff being halfway sane, please review the conflict resolution.

Thanks Marc ! Apart from what Fuad reported, the plumbing bits look good
to me.

Cheers
Suzuki
