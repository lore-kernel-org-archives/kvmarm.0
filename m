Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8948944F566;
	Sat,  3 Oct 2026 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791043960; cv=none; b=RYaQ+n7TmKKo8EuV8Ghe98LS0u7/9ptVXnWj2Sxyv4yuu1O6RjgHiE1KNHpx4Vzm0cfZjinpw3hTSp2NPyA9PM6Ew9dvXjldeccLWh4HSIzzLZWelYCepKz0VIjIi08eWZ8yl+F2+Ar7Vaakyllnu1VB4axOJWvPg4IZ0aqUNn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791043960; c=relaxed/simple;
	bh=h6+kAYhTqNCk5jLCyFcVvQkz7TJRrMZczCzt8KPp5zw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Lr0yuGSvGUAwCo4wVQTxF9Q5qac6MID8GiWVjhPi9rKMT+WV/o4eL+cfGKVoUa8Njh3tDvoKC32EBA9cbUvvF4Or5cEzV5qt6L9CPeVNkQpAw/hqH+BhuU66L249G+e9SCX5BBC2pK0eE3NdmRyrYL0Irt8ebN1Ikx0hbcdkQB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WeJ4ekDi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WeJ4ekDi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76E9F143D;
	Sat,  3 Oct 2026 09:12:33 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA0A33F763;
	Sat,  3 Oct 2026 09:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791043956; bh=h6+kAYhTqNCk5jLCyFcVvQkz7TJRrMZczCzt8KPp5zw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=WeJ4ekDixCXQNFuyz6q1fIRyA0ToG+nK0I3VpV4M10UQbtKTYc2w28Vgi9UT+YFXD
	 9PwheUiXaPqI7spjj6FU6ER+i/8EYTnpEPDWoNDHaFgHT4tyYGRkFXFvtPF7KHxSLo
	 14PbVYgk7AwPUHBBcevGV+xFjAzPFmtlLgUioF6o=
Message-ID: <ce2e8885-d848-48d3-b82e-49fcd9a6cfcc@arm.com>
Date: Sat, 3 Oct 2026 17:12:28 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 10/23] KVM: arm64: Add VM specific callback for S2 MMU
 operations
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-11-suzuki.poulose@arm.com>
 <86ik3j2m5v.wl-maz@kernel.org> <9873fb9d-6f32-46f6-bcac-6a52e293d011@arm.com>
In-Reply-To: <9873fb9d-6f32-46f6-bcac-6a52e293d011@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03/10/2026 16:30, Suzuki K Poulose wrote:
> On 03/10/2026 10:01, Marc Zyngier wrote:
>> On Thu, 01 Oct 2026 22:06:50 +0100,
>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>>
>>> Add VM type specific S2 MMU operation backends which can be 
>>> initialized per
>>> VM flavor, to keep the handling cleaner.
>>>
>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
>>> Tested-by: Gavin Shan <gshan@redhat.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> ---
>>> Changes since v19:
>>>   - Add a blank line in kvm_arch_flush_remote_tlbs()
> 
> 
>>>   struct kvm_s2_mmu {
>>>       struct kvm_vmid vmid;
>>> @@ -332,6 +345,8 @@ struct kvm_arch {
>>>        */
>>>       u64 fgu[__NR_FGT_GROUP_IDS__];
>>> +    const struct kvm_vm_s2_ops *vm_s2_ops;
>>> +
>>
>> If you're touching this patch, can you please move this pointer next
>> to the vcpu_ops pointer?
> 
> Sure, I will do that.

Sorry, this is only stored in kvm_arch, while the vcpu_ops are stored
in the vcpu_arch, to avoid pointer chasing vcpu->kvm->arch->.

I could move it closer to the vm_flavor ?

Cheers
Suzuki

