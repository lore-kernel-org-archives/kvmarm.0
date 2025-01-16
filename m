Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B88F1DE4EC
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737035409; cv=none; b=SnaYcfzbY47J2wTZ3oUdfVnT1YoQqCObFUcaLi9aIVGSNwVAW36qAlaFEQFK0FWAYZgUeGc49+EtHDDXfAXisLUUsqMCrSs0gRxpY4q/4zC+NbK1iSsY2ivJy0nhw2VnnqGq4davaVEjFvONwAvjKNt5Baod/Fl0GDDkQO/ohvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737035409; c=relaxed/simple;
	bh=SLQfJPpx9moSlt3HR020SpUS6TcUSYn6JnbSzglVC7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jibMnSZQ05AoVB0iniyNeuVhxVfjWVm9iScESPMoX4PjQtxcV8V5PLDYsJZB+QLRei45zY2dioUsjTF0F9icDpAIF/+a7qsOnCP4JKwX0lQw9G+1Qr7/2jM1ZAZyDgPGNv98tNahRczwHEP4ojlHZAOKwvU4rxhOkwviHwV7b+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 494ED106F;
	Thu, 16 Jan 2025 05:50:35 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5B313F77D;
	Thu, 16 Jan 2025 05:49:59 -0800 (PST)
Message-ID: <e79c78a7-24a3-42e6-a217-ec64f8320e91@arm.com>
Date: Thu, 16 Jan 2025 13:49:54 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Fix the upper limit of the walker range
To: Marc Zyngier <maz@kernel.org>, Sebastian Ene <sebastianene@google.com>,
 Mark Brown <broonie@kernel.org>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, will@kernel.org, Aishwarya.TCV@arm.com
References: <20250114145050.563658-2-sebastianene@google.com>
 <14cce00c-29bd-4feb-b7d0-7aae6e948d1e@sirena.org.uk>
 <8634hjvxi2.wl-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <8634hjvxi2.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/01/2025 10:55, Marc Zyngier wrote:
> On Thu, 16 Jan 2025 01:16:40 +0000,
> Mark Brown <broonie@kernel.org> wrote:
>>
>> On Tue, Jan 14, 2025 at 02:50:51PM +0000, Sebastian Ene wrote:
>>
>>> Prevent the walker from running into weeds when walking an
>>> entire address range.
>>
>> The KVM page_fault_test selftest started failing in next-20250115 on
>> at least n1sdp and TX2 in VHE mode and a bisect seems to point to this
>> change.  The bisect only just finished, I've done no further
>> investigation.
>>
>> When the test fails it generates backtraces like that below:
> 
> [...]
> 
> Thanks for the heads up.
> 
> Given how close we are to the merge window opening, I've dropped this
> patch from -next.
> 
> Seb: it looks this breaks a bunch of existing assumptions. Let's
> revisit this before -rc1, if possible.
In kvm_pgtable_walk() we set the walk_data.end to PAGE_ALIGNED(start + 
size), where size is BIT(ia_size) and start = 0, for 
kvm_pgtable_stage2_destroy().

And subtracting the limit in _kvm_pgtable_walk makes things go bad,
  returning -ERANGE.
Given the kvm_pgtable_walk() passes the "end" as the top address (not 
including it), and is always PAGE_ALIGNED, we should probably leave 
things as it is in the code.


Cheers
Suzuki


> 
> Thanks,
> 
> 	M.
> 

