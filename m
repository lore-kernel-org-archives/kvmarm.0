Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0FA523781;
	Wed,  9 Sep 2026 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961968; cv=none; b=LCYVhvTA8GpBa4znkYxKYSlz3U6pz0k0BKvzDfWPTSIQqRgiHvtvvqlgTvLjjnvikDKgkeAA6z0Yv0rtMjdwad0jyEBH0LvVk4/7IWp13LFe9GlBEOPKkygOele6M2I6yVuqzBERpzUX+8ugq3z1L6GUTABR1LTAiWUr3czi7yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961968; c=relaxed/simple;
	bh=0e+vVbTn7gtjt+ndYPN+Yizq0HsnlJMP58UYCyMUZOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cei12+2ayIG5mV+CSiJYlGTs6bLsRvvbEgsRPlNwMCyKsfNF3FuCaGV2WF5hL+ArN39AjMmFj4ZD+ayVGjRBFRxJ+CazGtGT5kpfUnL5d9YcHPzNNKllqly9vW+qC4AyQCLPI0M4CpVfhQYTBiS2WMti+kmgP5RZqt0xeaDW/tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Esc5UWw4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Esc5UWw4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42A4F176B;
	Wed,  9 Sep 2026 06:52:42 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D96BF3F7B4;
	Wed,  9 Sep 2026 06:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788961965; bh=0e+vVbTn7gtjt+ndYPN+Yizq0HsnlJMP58UYCyMUZOA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Esc5UWw4fKnlt/HxqgDDr4fptKWfnfQBakSmMsDI1AQng2kJ1KlAf2z1pXVfuhiEA
	 DwlFBwnYkNFrr2nZ2dxOQpc8wESu8h59eS5xYd9P99CiZ7A+0SniEM8K9KVJoHdCp2
	 9DCtlV43WnuuliMeTCs7hxjSk7+PhoPWPKp8O8Ao=
Message-ID: <ce968e53-58b4-440c-94f4-fdba08dc6dc5@arm.com>
Date: Wed, 9 Sep 2026 14:52:41 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/20] KVM: arm64: CCA: Add basic plumbing for Realms
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <CA+EHjTzr-r1FRuJ-X3E38_SSHsNSz_vdO-8sFOtBdsiB3V_x=g@mail.gmail.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTzr-r1FRuJ-X3E38_SSHsNSz_vdO-8sFOtBdsiB3V_x=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/2026 14:18, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Tue, 8 Sept 2026 at 17:22, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> ...
>>   3) NEW: Enlighten KVM arm64 about the different VM types and use call backs for
>>     the VM type, rather than spilling the is_this_type_of_vm() everywhere. This is
>>     not complete yet, but it is largely functional. Adds VCPU and Stage2 MMU related
>>     callbacks with support for the existing VM types.
> 
> A design thought on the vm_flavor dispatch tables. They're
> hand-maintained arrays indexed by enum, and a gap fails silently at
> runtime, not at build: arm64_vm_s2_ops[] has no VM_REALM row, so a
> realm VM would get NULL ops.
> 
> How about something like declaring it unsized with
> BUILD_BUG_ON(ARRAY_SIZE(arm64_vm_s2_ops) != VM_FLAVOR_MAX), as
> host_hcall does? A non-NULL check of the selected ops' mandatory
> callbacks at VM init would catch the s2_ops naming typo Sashiko
> caught, where the rows point at zeroed forward-declared structs.

Agreed, I will add that. The VM_REALM S2 ops will come in the next part,
as we can't have anything meaningful without the RMI backends.

Thanks for the review !

Cheers
Suzuki

