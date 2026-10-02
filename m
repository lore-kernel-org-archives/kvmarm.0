Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D272447F3B1;
	Fri,  2 Oct 2026 10:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790936958; cv=none; b=riARuYO4XWdpDrSvh0amTPYpw9ttrcLCUZ+9ZIyRSnzY0NyFQPTT00Jo/flPx22zRJRhbpxNA437uuJQZslXmgQt8YG3143YgzgylHkONIjkL7rTkLWaxr5urNT54/xiMSfu+i7Dw2Yah9TMS1jhi2C/zguI4WMTQI9XzhqsTIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790936958; c=relaxed/simple;
	bh=8zdG4+TMm/xDMmpwn/2kI2vIq6OxntZw4PKsvfXk3l0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZivxdnV1piHOS1dxaRUBp6ULnTXqK/8Gg/n+ySxnQGl0qd38VjAUvbCvGbtQcca3vXV7SkVxVRD+sKR77g50mSdEl0jF44kwy0VjSU1yOTAb1te1yW+l6GAUTs7Sy5BqMBwgdym7QGSf6jxcopELiTqJVrCLGJVL/ysH8SCmStc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=A0jDrAq+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="A0jDrAq+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 724932F;
	Fri,  2 Oct 2026 03:29:10 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 52A453F86F;
	Fri,  2 Oct 2026 03:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790936953; bh=8zdG4+TMm/xDMmpwn/2kI2vIq6OxntZw4PKsvfXk3l0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A0jDrAq+Uipp3H5I0BVYbZMwW+Mm5UzB/Yew7n6iialYSBFkrm6pTg1i9sUSM2t2r
	 EUc9FcHr/MSwRtmo2+Q2hQC9Q0F9e5Bzi3IodbUU7xML5zPPD+nFXgky/TyzXW1rnz
	 i9x9fQNFEdLdKuRV/KUDWU1nXuFrGwN6RaaM916M=
Message-ID: <a8dcdcfb-3c4c-4e39-b206-004f60c128b6@arm.com>
Date: Fri, 2 Oct 2026 11:29:07 +0100
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
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-11-suzuki.poulose@arm.com>
 <CA+EHjTxCfmOqiJzYDZHunSuEyoZCbgHuzeSYC8y71Re+9PA6Kw@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTxCfmOqiJzYDZHunSuEyoZCbgHuzeSYC8y71Re+9PA6Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad

On 02/10/2026 11:19, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Thu, 01 Oct 2026 22:06:50 +0100, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
>> Add VM type specific S2 MMU operation backends which can be initialized per
>> VM flavor, to keep the handling cleaner.
> 
> The rows only differ where the base already branches (the pKVM TLB
> flushes, the protected VM age and unmap, and from patch 12 its abort),
> so the case for the table rests on the Realm row, which isn't
> functional until the RMI backend lands. Beyond the flushes in patch
> 16, which operations do you expect it to override?

Thats it for now. But I also want to explore the flush_memslots() case,
where Realm doesn't need to do anything. May be it is easier to stub
that case out early.

> 
> [...]
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> [...]
>>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> [...]
>> +       if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs)
>> +               return 1;
> 
> Every row sets it today, but returning 1 falls back to
> KVM_REQ_TLB_FLUSH, which arm64 doesn't handle, so nothing would be
> flushed. Could vm_flush_remote_tlbs be mandatory, checked in
> kvm_vm_init_vm_s2_ops()?

Agree, we could make that mandatory.

Suzuki
