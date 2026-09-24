Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 223953C1F57;
	Thu, 24 Sep 2026 10:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246970; cv=none; b=XaUlT/o90AkzEdqFPt9+AGOtERY3pCZTPz3QQWPm9XQEn/aG/jVFLXUMSq/B0pbwANIQRo4SUhHpJKcY8vbhoDSvGIkR7SMvkqjewowRtEe8DojUiVNLHf6Go3gMtBwNzYCCcqdPH1ki4YOkEXukqOZPWsecFvgGS/88NhVhR1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246970; c=relaxed/simple;
	bh=Ag41tBiO61VwQ+kewkVFaahq+25iFQPI5Fv2AnmNV18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p3ow61Cd7bMQzm+alhEFFmcnEZoH/qAA9n2/1PKOGlDavl9d3qk6bVopn44pC+q+rm3jrWqDQvPTZ9+n6PvCA3A1d2shjARDT+DHcNJkCmFOXy1q8ad+kYDqh/GR6ZYw+wd79GTjhFaYu5g5xYIJ2e3GBMmYnpuMqBlBl1j6yE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q9yC7wHd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q9yC7wHd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D97E6143D;
	Thu, 24 Sep 2026 03:49:23 -0700 (PDT)
Received: from [10.0.128.141] (Suzukis-MBP.cambridge.arm.com [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D96DE3F86C;
	Thu, 24 Sep 2026 03:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790246967; bh=Ag41tBiO61VwQ+kewkVFaahq+25iFQPI5Fv2AnmNV18=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q9yC7wHdZXpuo4PysDrfAcK3SJ5rRf3qlhEGCDKFRN/YbqljYcD3v55a9UEEeEKHV
	 r/bRMjCJ8n9qahCY2sAApK5n+VSeCXhOv4APeMR+LM0WMtPMwu/W/yGltTK5+G1Q9j
	 ST88bkpe6fcITNgu0XVklHs8Ydj28yBvcwNn+Ywg=
Message-ID: <1734c61b-88ed-42e0-a342-fdacca49297c@arm.com>
Date: Thu, 24 Sep 2026 11:49:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 00/20] KVM: arm64: CCA: Add basic plumbing for Realms
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <a5dbea3b-d175-42d2-a29d-9280c92236da@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <a5dbea3b-d175-42d2-a29d-9280c92236da@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24/09/2026 11:40, Gavin Shan wrote:
> On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
>> This series is a trimmed down version of the Arm CCA KVM support, 
>> previously
>> posted here [0]. Like in the v17, we have tried to split the entire 
>> series
>> into the following chunks.
>>
>>   1) Base RMM RMI support under drivers/firmware/arm_rmm -> [1]
>>   2) Linux Host support for handling GPFs - [2]
>>   3) NEW: Enlighten KVM arm64 about the different VM types and use call
>>      backs for the VM type, rather than spilling the is_this_type_of_vm()
>>      everywhere. Adds VCPU and Stage2 MMU related callbacks with support
>>      for the existing VM types. There are other places where we may be
>>      able to abstract, but those need careful performance evaluations
>>      to make sure they are fit (e.g., vcpu_run)
>>
>>     With that in place we generalise the predicate 
>> "kvm_vm_is_protected()"
>>     to cover all  "Confidential" VMs (which includes Protected VM and 
>> Realms),
>>     allowing us to handle common themes without having to do things 
>> like :
>>
>>       if (kvm_vm_is_protected() || kvm_vm_is_realm())
>>
>>     Also replaces the code with precise check for a given VM type to
>>     avoiding combination of if (). e.g,, kvm_vm_is_unprotected_pkvm(kvm).
>>     The checks under arch/arm64/kvm/{nvhe,pkvm} still retain the 
>> vm_is_protected()
>>     check as pVMs are the only possible protected VMs there.
>>   4) Bare minimal Realm VM support without the actual functionality to
>>      run a Realm. This would help the maintainers to review the series in
>>      smaller chunks. This doesn't depend on [1] and can be independently
>>      merged, without being "functional".
>>      This series includes vcpu operations and the s2 vm operations, which
>>      do need the RMI driver backend to be meaningful. But the KVM handler
>>      is in the right shape. The remaining changes would be added once the
>>      RMI firmware library lands. Also covers the SET_ONE_REG/GET_ONE_REG
>>
>>   5) Core implementation of the RMI driver for KVM and actual 
>> enablement of the
>>      Realm support. This depends on (1), (2) and the guest-memfd-in-place
>>      conversion series v12 from Ackerley. This is available here at 
>> the integration
>>      branch [3]
>>
>> This series is comprised of (3) and (4) above.
>>
>> The integration branch has been tested with the following components:
>>
>>    tf-RMM:   main branch (commit 5e6e2acd) compliant to RMM-v2.0-beta3 
>> [4]
>>    kvmtool: git@git.gitlab.arm.com:linux-arm/kvmtool-cca.git cca/kvm-v18
>>
>> [0] Arm CCA KVM Support v16 : https://lore.kernel.org/ 
>> all/20260803134403.80630-1-steven.price@arm.com
>> [1] Linux firmware RMI https://lore.kernel.org/ 
>> all/20260912083611.2513845-1-suzuki.poulose@arm.com
>> [2] Linux GPF Host https://lore.kernel.org/ 
>> all/20260913070459.2547407-1-suzuki.poulose@arm.com
>> [3] https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/kvm- 
>> v19/integration
>> [4] https://support.arm.com/documentation/den0137/2-0bet3/
>>
> 
> Apart from the issue found against PATCH[v19 05/20], I didn't see more 
> issues with this
> series in my tests where kselftest/kvm cases and kvm-unit-tests are done 
> on various
> combinations: 4KB host kernel, 64KB host kernel, kernel parameter "kvm- 
> arm.mode=
> {nvhe, protected}" or nil. So with the found issue caused by PATCH[v19 
> 05/20] fixed:
> 
> Tested-by: Gavin Shan <gshan@redhat.com>

Thank you Gavin, much appreciated !

Cheers
Suzuki

