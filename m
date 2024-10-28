Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BD318E778;
	Mon, 28 Oct 2024 14:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127129; cv=none; b=LyCaOw8ywGf1Z553BaeBbQCTvaWTivVvtGrAUp6bVPgHCiXWImArgXdxViqOwADtsBUHVA58Sl2GqAA7WGm3KqWcWCBfvpdGZMV0x1ah4oI21XgDkYrrK8cq2lpPa/WW9+fmtRrQR+mUsjC7ljTL1V7/nIYqrkcZ4tlAwAsCUJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127129; c=relaxed/simple;
	bh=JxzWDVYM+b2LhEZUyWIHfG18ytG3bPimVRQv+jNrqHI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XjnGRmEbpQpFZUO2bEfveru7TTVh8P40zLdY5miITUK7DKA9xdp0+W2IVKLGTIfgBAxnWUinayQnTomlDPJ4fIAgmFQEVVEXbxjulgmPkvNaAD5Fcq888tau05nmXSdb81alF0bUEU/n6VfTZkVw6wInBROqIpvEVy8dH8l5mjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PxxrqyDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PxxrqyDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48140C4CEC3;
	Mon, 28 Oct 2024 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730127129;
	bh=JxzWDVYM+b2LhEZUyWIHfG18ytG3bPimVRQv+jNrqHI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=PxxrqyDpaqsMe+Dtc4+nDeIvAerpiO96NLXQ07zW1jdyUIGIRSJ0Jl6IBSLI2FGvj
	 wt9gD7xkR+4nXUhHtCTuFQzrAvKWy3it5zikjLCCAIZgtcg4E5L6IgxWjI5rhh0P2V
	 j+/98LH65OzRuH9SBQCbYgHOylAE/Mzw4uIjzq4Nww6bpFY/sLf1Ub84DJvNpHxflw
	 EqDwxau4Og5rq+dCwsuNPVG4QMjgx6rlnxdrDnxIAJMMCoql6r9nxzm2ZwUaPE7nNi
	 8PfmkoIY0UDbM+Vinds3PT178Cv9sPMU6ykhBocjdTXNTtww81fEe3Eactlruvl6eI
	 ZjDk/YOIUuc3w==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 4/4] arm64: mte: Use stage-2 NoTagAccess memory
 attribute if supported
In-Reply-To: <Zx-jWyF7xvFS-Vs6@linux.dev>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
 <20241028094014.2596619-5-aneesh.kumar@kernel.org>
 <Zx-jWyF7xvFS-Vs6@linux.dev>
Date: Mon, 28 Oct 2024 20:22:02 +0530
Message-ID: <yq5amsiocmb1.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hi Oliver,


Thanks for reviewing the changes.

Oliver Upton <oliver.upton@linux.dev> writes:

> On Mon, Oct 28, 2024 at 03:10:14PM +0530, Aneesh Kumar K.V (Arm) wrote:
>

> NOTE: We could also use KVM_EXIT_MEMORY_FAULT for this. I chose to
> add a new EXIT type because this is arm64 specific exit type.
>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---

I have used KVM_EXIT_MEMORY_FAULT as part of the initial prototype.

>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 637efc055145..a8268a164c4d 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -178,6 +178,7 @@ struct kvm_xen_exit {
>>  #define KVM_EXIT_NOTIFY           37
>>  #define KVM_EXIT_LOONGARCH_IOCSR  38
>>  #define KVM_EXIT_MEMORY_FAULT     39
>> +#define KVM_EXIT_ARM_NOTAG_ACCESS 40
>>  
>>  /* For KVM_EXIT_INTERNAL_ERROR */
>>  /* Emulate instruction failed. */
>> @@ -446,6 +447,12 @@ struct kvm_run {
>>  			__u64 gpa;
>>  			__u64 size;
>>  		} memory_fault;
>> +		/* KVM_EXIT_ARM_NOTAG_ACCESS */
>> +		struct {
>> +			__u64 flags;
>> +			__u64 gpa;
>> +			__u64 size;
>> +		} notag_access;
>
> Can you please look into reusing the memory fault exit infrastructure?
>
> The entire point of that is for KVM to tell the VMM it cannot make
> forward progress because of ${SOMETHING} unexpected at the specified
> GPA. You can add a new flag that describes tag access.
>

The only reason I dropped the change was because the flag will be very much
arm64 specific. Based on your feedback, I will switch to
KVM_EXIT_MEMORY_FAULT in the next update.

-aneesh
