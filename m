Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EBB33ADB1;
	Thu, 30 Jul 2026 05:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785390288; cv=none; b=ewY/EyOquiJmcUbyRIwZKHZFRvGRZJsJOipI/E1MA6h/iS+rWj0BUr2T9zrFNq+0BIQQzLA8iGcf6SMd9vHxncTzKa+LBHb3shFjR4U2pIgk6mbhgGYrh/nqFS1g3DJARTq42mOkyHfbml6Bs8bUYdktA6wH36LrhX8NxbedzsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785390288; c=relaxed/simple;
	bh=rrQQyBE83GwPGeDrkZvblGGfFFUvzbKS9u6s3bZBzrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q1w/FBJL1xdRcefXRys9p0tx93NSWDV+rpLQnheUBdLOxmQcPOkxseqCt0uZplAQrtpM+p7o0h6x9YFA/9Q3HQP8YSE5o1+CAfFaoSFe2FB9OoojMfept3lb8wbN+AABGI3wxn5PXwjnuMUC3hvYUezJcrRqpCnkouDoTcvtkkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=C4z79NUP; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="C4z79NUP"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66U5iNhO025790
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 30 Jul 2026 14:44:24 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=d/qF0/RsV01j9A8e8wMikayfr+DKzRnr+HTkRP0uC7w=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1785390264; v=1;
        b=C4z79NUPx6C3ByN5VCeKenVyEaTH0QwMPDH+PKHmjlaomh80gYN/kg334cQSO+G9
         yl2o9CeEhWSfHBorEzVNXu/LbWTwlVyov4jJ4DH5pgX3453btM9VbbpIkaVBhAgy
         A5lg0b8fbNGFmw2hdCHzCzTxAfiBPuS94OEd7PRvxC1PrEMPmZAPj01ll3OHkTf1
         /X6xyPNzHL1UNxrb/0wOs0cM6gnLYFtDNiqLVVb87GZDNIzr7MNASgGU9NzvK2cw
         E/LqmAUBKk7jegq0lAmjjppH6ELzXRplL54P1K7SPOIC6BmXLLNtqDwxh3cqbK1n
         hOGX056s06TXrr6z4gqYCQ==
Message-ID: <1e5e1a1f-51ce-4c0c-8690-b5472cc7bd2e@rsg.ci.i.u-tokyo.ac.jp>
Date: Thu, 30 Jul 2026 14:44:22 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COUNTERS
 after first run
To: Fuad Tabba <tabba@google.com>, sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-4-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720060858.5AEB11F00A3E@smtp.kernel.org>
 <CA+EHjTxsm6LorPDR9irVHL0gtmsUG6zUKQLBA2=8Ruy+V4UmBw@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <CA+EHjTxsm6LorPDR9irVHL0gtmsUG6zUKQLBA2=8Ruy+V4UmBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/07/30 0:23, Fuad Tabba wrote:
> On Mon, 20 Jul 2026 at 07:09, <sashiko-bot@kernel.org> wrote:
>>
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [Medium] The test ignores the guest's exit state and `ucall` status after executing `vcpu_run()`.
> 
> vcpu_run() does the check.

vcpu_run() itself doesn't. run_vcpu() calls vcpu_run() and then performs 
the check (their names are so confusing here), but the new test bypasses 
run_vcpu() and therefore does not perform the check. I'm planning to 
rework the test to use run_vcpu() with the next version.

Regards,
Akihiko Odaki

> 
> /fuad
> 
>> --
>>
>> --- Patch [4]: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COUNTERS after first run ---
>> commit 0382d3a32df9349f988ca69c7b11c92e61c3d384
>> Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>>
>> KVM: arm64: selftests: Test SET_NR_COUNTERS after first run
>>
>> This commit adds a regression test that runs one vCPU and then tries to change
>> the VM-scoped PMU counter count through an idle sibling to verify that
>> SET_NR_COUNTERS fails with EBUSY once any vCPU has run.
>>
>>> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
>>> index 22223395969e0..3b5bb421f401b 100644
>>> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
>>> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
>>
>> [ ... ]
>>
>>> @@ -622,6 +627,37 @@ static bool kvm_supports_nr_counters_attr(void)
>>>        return supported;
>>>   }
>>>
>>> +static void test_set_nr_counters_after_vcpu_run(void)
>>> +{
>>> +     struct kvm_vcpu *running_vcpu, *stopped_vcpu;
>>> +     unsigned int nr_counters = 0;
>>> +     struct kvm_vcpu_init init;
>>> +     struct kvm_vm *vm;
>>> +     int ret;
>>> +     u64 irq = 23;
>>> +
>>> +     vm = vm_create(2);
>>> +     vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
>>> +     init.features[0] |= BIT(KVM_ARM_VCPU_PMU_V3);
>>> +     running_vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code_done);
>>> +     stopped_vcpu = aarch64_vcpu_add(vm, 1, &init, guest_code_done);
>>> +     kvm_arch_vm_finalize_vcpus(vm);
>>> +
>>> +     vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
>>> +                          KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
>>> +     vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
>>> +                          KVM_ARM_VCPU_PMU_V3_INIT, NULL);
>>> +     vcpu_run(running_vcpu);
>>
>> [Severity: Medium]
>> Does this code need to check the guest's exit state and ucall payload?
>>
>> If the guest payload crashes or hits an unexpected exception, this will silently
>> ignore the failure and proceed. Since the test only checks for an EBUSY error on
>> the subsequent ioctl (which will still be returned because the vCPU has been
>> run), the test will pass despite the guest crash, potentially masking
>> virtualization bugs.
>>
>>> +
>>> +     ret = __vcpu_device_attr_set(stopped_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
>>> +                                  KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS,
>>> +                                  &nr_counters);
>>> +     TEST_ASSERT(ret == -1 && errno == EBUSY,
>>> +                 KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
>>> +
>>> +     kvm_vm_free(vm);
>>> +}
>>> +
>>
>> --
>> Sashiko AI review · https://sashiko.dev/#/patchset/20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=4
>>

