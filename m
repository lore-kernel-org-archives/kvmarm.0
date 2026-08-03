Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E5A40B0E5;
	Mon,  3 Aug 2026 14:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785765883; cv=none; b=duEh5bLVxuLFKvEYE+/juF9EXLe3/8c7BXKc5E4fESftntYYLUetes13zM20jgNGiQhI8Nj3c15KskYKY+8oLwN8KFPZG09VifwUxtMzRRgxgK9yVyORGLpC4B8uF65gly5Soho/V89oEHB61Ev3Kfv9nDb4CFaQoAwadhu9cEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785765883; c=relaxed/simple;
	bh=R5zVtJQeJdnpiL1SXoRY5in2VKOjAQvpPgHtildoK4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=losEHzLJnIO8VWQLjN41Fo5Cm6sQz4Xhs+fGnlecjAR42dhUV3BmbeNW/pZzepL2Z9j8GibkBVa1q/UNgcxkTuiLX9UMBkKgeYyCstaVzP8hindvHqYmKRI76nRMP9j2NMMqUIgmpBrINYsAIbdEXzJqyTU64bUS/6ZkFiJSjMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Phdo70qu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Phdo70qu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF613143D;
	Mon,  3 Aug 2026 07:04:36 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28AF23F632;
	Mon,  3 Aug 2026 07:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785765880; bh=R5zVtJQeJdnpiL1SXoRY5in2VKOjAQvpPgHtildoK4Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Phdo70quSxNwfAFYbq70eisXqrPYXMiWgSYK1sX3pctFAEcRrfygnwgOhCWloGpTV
	 S4EOs4gpdcwU+j4KniTPTF/lkfVb/DGq2NurltGXqArUnmv7+vK3bZrFyd4G7uyOmQ
	 M9KiU4CTW8cY7JCGZq4RQbmE2aZ96e9r6zRuVpW4=
Message-ID: <f971d029-84d9-4c66-9875-36fa8f1a2a1b@arm.com>
Date: Mon, 3 Aug 2026 15:04:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 15/37] KVM: arm64: CCA: Handle RMI_EXIT_RIPAS_CHANGE
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-16-steven.price@arm.com> <865x1rcvfw.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <865x1rcvfw.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

I've just posted v16 before looking at these - I didn't want to delay
posting before responding as I'm going to be on holiday for a week after
today. Apologies that I haven't addressed these comments in v16.

On 03/08/2026 12:09, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 15:28:17 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The guest can request that a region of its protected address space is
>> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
>> RSI_IPA_STATE_SET. This causes a guest exit with the
>> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
>> protected region to unprotected (or back), exiting to the VMM to make
>> the necessary changes to the guest_memfd and memslot mappings. On the
>> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
>> calls.
>>
>> The VMM may wish to reject the RIPAS change requested by the guest. For
>> now it can only do this by no longer scheduling the VCPU as we don't
>> currently have a usecase for returning that rejection to the guest, but
>> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
>> open for adding a new ioctl in the future for this purpose.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v14:
>>  * Use addition rather than bitwise OR for adding the shared_bit in
>>    realm_unmap_shared_range(), this handles the case where the region
>>    includes the last address (which means 'end' already has the bit
>>    set).
>> Changes since v13:
>>  * Switch to the new RMI_RTT_UNPROT_UNMAP range-based API.
>>  * Drop ugly hack for RMM bug which errored when the RIPAS was already
>>    set to the desired value.
>> Changes since v12:
>>  * Switch to the new RMM v2.0 RMI_RTT_DATA_UNMAP which can unmap an
>>    address range.
>> Changes since v11:
>>  * Combine the "Allow VMM to set RIPAS" patch into this one to avoid
>>    adding functions before they are used.
>>  * Drop the CAP for setting RIPAS and adapt to changes from previous
>>    patches.
>> Changes since v10:
>>  * Add comment explaining the assignment of rec->run->exit.ripas_base in
>>    kvm_complete_ripas_change().
>> Changes since v8:
>>  * Make use of ripas_change() from a previous patch to implement
>>    realm_set_ipa_state().
>>  * Update exit.ripas_base after a RIPAS change so that, if instead of
>>    entering the guest we exit to user space, we don't attempt to repeat
>>    the RIPAS change (triggering an error from the RMM).
>> Changes since v7:
>>  * Rework the loop in realm_set_ipa_state() to make it clear when the
>>    'next' output value of rmi_rtt_set_ripas() is used.
>> New patch for v7: The code was previously split awkwardly between two
>> other patches.
>> ---
>>  arch/arm64/include/asm/kvm_rmi.h |   6 +
>>  arch/arm64/kvm/mmu.c             |   8 +-
>>  arch/arm64/kvm/rmi.c             | 457 +++++++++++++++++++++++++++++++
>>  3 files changed, 468 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index b1e4cf0f6803..5461c49bea4d 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -104,6 +104,12 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
>>  int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>>  int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>>  
>> +void kvm_realm_unmap_range(struct kvm *kvm,
>> +			   unsigned long ipa,
>> +			   unsigned long size,
>> +			   bool unmap_private,
>> +			   bool may_block);
>> +
>>  static inline bool kvm_realm_is_private_address(struct realm *realm,
>>  						unsigned long addr)
>>  {
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index cd06881c1497..dcc2ab08d0e4 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -319,6 +319,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>>   * @start: The intermediate physical base address of the range to unmap
>>   * @size:  The size of the area to unmap
>>   * @may_block: Whether or not we are permitted to block
>> + * @only_shared: If true then protected mappings should not be unmapped
>>   *
> 
> I don't understand the need for this additional argument. Given that
> CCA imposes that shared and private are in non-overlapping ranges, why
> is it necessary to introduce this at the core of the S2 management
> code?
> 
> I'd expect that the CCA code could simply work out what range it needs
> to run on and keep the API intact.
> 
>>   * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>>   * be called while holding mmu_lock (unless for freeing the stage2 pgd before
>> @@ -326,7 +327,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>>   * with things behind our backs.
>>   */
>>  static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
>> -				 bool may_block)
>> +				 bool may_block, bool only_shared)
>>  {
>>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>>  	phys_addr_t end = start + size;
> 
> So what is the *actual* change?

It looks like I've screwed up what goes in which patch. The real change
is in patch 22 where this 'only_shared' property gets passed down to
kvm_realm_unmap_range(). There it's used to decide whether the private
range should be unmapped or not.

The reason for this is kvm_unmap_gfn_range() which has a 'attr_filter'
member of 'kvm_gfn_range' which can specify KVM_FILTER_PRIVATE. Which is
used in __kvm_gmem_set_attributes() so choose whether to invalidate the
private or shared part of a gmem range.

The issue on CCA is that invalidating the private mapping is destructive
- if the guest doesn't agree to it then the guest will not be able to
continue executing. For the shared part this isn't a problem (we can
refault the address).

Clearly I've screwed up the patch ordering here, but I'm not sure quite
how to structure the APIs better to avoid adding this argument.

Thanks,
Steve

