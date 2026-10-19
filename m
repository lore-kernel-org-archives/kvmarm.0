Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14F14D9F8A;
	Mon, 19 Oct 2026 13:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416834; cv=none; b=LcHOCRfOEQAJ+SWfZsoPhRFX2Go6arQA3cfpeWssW3nxOEF/4ba3Ak7bHKS5hgDDab4q4BhoV22Ukf2SyZkg+TLpdUklcwo8rFQuSat11zxLh56U/DtQcvP+tJHRWRczL7+qB4DJEoQo9K4V/EL5IJD2xQzQg2YgrEkZ3L4+07k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416834; c=relaxed/simple;
	bh=ujXmLORlFdUC8dYzrwRUCwif5YWfOXSF11Rs+nig8sY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KMvbXlfpN/9Smpv0FXpCe30Nnj61fsRJpCbVzDCdUy5eaHdzHQYggBej7ySuXcv1p/jXG4uV+uSxw96aLxctvTN+LmRLsw2OwNDxBP8tF2hBboSqVmvzml8s+GpFtZZkir1l1xX7bsZrOOBw7SwYZyw7GFRJ/IKkPEahLB51/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UjV4c1SF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UjV4c1SF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D03741682;
	Mon, 19 Oct 2026 06:33:47 -0700 (PDT)
Received: from [10.0.136.108] (M0PRX50XMG.cambridge.arm.com [10.0.136.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C0213F7D8;
	Mon, 19 Oct 2026 06:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792416831; bh=ujXmLORlFdUC8dYzrwRUCwif5YWfOXSF11Rs+nig8sY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UjV4c1SF9xNCAoOXioBz7tSAyYZ/mAfTbiTR7C8qe7c6KAyzoehoYaX2xl7mswvjb
	 2XW5PNkyPw/kkzhazF6kZHxdR/xiPIvVnH6KCJLkhBEAJSa0uqiVIoGcunx6qm2DgW
	 Emdx8z9A21+BvHbW/JWeXE/6xi+YQ0+t8ODrrST0=
Message-ID: <6e7f76e9-3e62-4733-9d4a-acf944e005cb@arm.com>
Date: Mon, 19 Oct 2026 14:33:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016152225.898761-1-sascha.bischoff@arm.com>
 <20261016152225.898761-3-sascha.bischoff@arm.com>
 <sashiko-outbox-174571@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174571@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 16:36, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] selftests: vgic_v5.c uses ad hoc skip messages and direct exit() instead of TAP
> --
> 
> commit 1b97dfda1bac7a30c8395c0645ac8efb945b4639
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC
> 
> Check that a GICv3 ITS and a GICv5 VGIC cannot be paired, regardless
> of which device is created first. Skip the check when the host does not
> expose a GICv3 ITS.
> 
>> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/selftests/kvm/arm64/vgic_v5.c
>> index d5df742b23001..5bf7d99d29147 100644
>> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
>> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
> [ ... ]
>> @@ -2003,8 +2003,40 @@ int test_kvm_device(u32 gic_dev_type)
>>   	return 0;
>>   }
>>   
>> +static void test_vgic_v3_its_with_vgic_v5(void)
>> +{
>> +	struct kvm_vm *vm = vm_create_barebones();
>> +	int gic_fd, its_fd, ret;
>> +
>> +	if (__kvm_test_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_ITS)) {
>> +		pr_info("No GICv3 ITS support; skipping mixed-model test.\n");
>> +		kvm_vm_free(vm);
>> +		return;
>> +	}
> 
> [Severity: Medium]
> When running test_vgic_v3_its_with_vgic_v5() on a host without GICv3 ITS
> support, this prints an unstructured skip message and returns directly.
> 
> Could this be converted to use a TAP reporting macro like
> ksft_test_result_skip() instead of an ad-hoc pr_info() and return?
> 
> Additionally, running the test suite on a host without GICv5 support calls
> exit(KSFT_SKIP) directly in main() instead of using ksft_exit_skip().
> Are there plans to update the main() exit path as well?
> 

As it stands, this matches the rest of the GICv5 selftests. I think that 
it makes some sense to adjust these going forward, but this change is 
not the time to start doing that IMO.

I'll look into doing this going forward, but won't fix this for now.

Thanks,
Sascha
