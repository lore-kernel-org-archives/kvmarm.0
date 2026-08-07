Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98E52D249B;
	Fri,  7 Aug 2026 10:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786100341; cv=none; b=QUncMwt+2lvA8DQlh1zSR7OjYsDEA2dO8POr6tIebzzRW6U6k/AhMD1RRaj0TRkuyhKLVxNX9O3E+ADfJs09oZ68qC+K2E1mHhjTBSDI4FZzbNn6NHApPCI/vNrvDMoDBVOmvyEHlLRb76o3cnvO0xGsfjsZVxCAQRCDICTorFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786100341; c=relaxed/simple;
	bh=uuFrFlTnxR2oRESNj+PEN7bA9/kaSqszCUAy8op7WaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XGH7q3jzHwlU0ycMZMfwju4cB4U4pGYleskDzDszlhnXwhVsDrt4XuzSSMhu0X9MZI4v66Wsyqa2f3Cz7HscD3hcZRUK87cDtvsyUb4i/Xw8+FyJpckUUshlVus5wOEruwuRx5WwJcA6nW+qlodGgcn9hgNtuupFxunvqqxAOMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fw4XtpBk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fw4XtpBk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F9161516;
	Fri,  7 Aug 2026 03:58:55 -0700 (PDT)
Received: from [10.57.40.157] (unknown [10.57.40.157])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 696D93F9A2;
	Fri,  7 Aug 2026 03:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786100339; bh=uuFrFlTnxR2oRESNj+PEN7bA9/kaSqszCUAy8op7WaA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fw4XtpBkfkE+rClcmwHAo5bM2jngfqXmIKz5nRrbXwqkxFWonBtCZyjh5ySsiYO5P
	 3K+Db6dyLygBF4SXRrevtbXTze2H9PA/sTzd7JGyW1vMiQgjj6DC9JamLCDvyoXPYO
	 50379CxKlYns2w2zd6EOAKlggDYuL8Y78ejrmMl4=
Message-ID: <7ff49972-a9bf-4d99-9088-3d5e1eaa1608@arm.com>
Date: Fri, 7 Aug 2026 11:58:53 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 27/45] KVM: arm64: CCA: Allow populating initial
 contents
Content-Language: en-GB
To: Ackerley Tng <ackerleytng@google.com>, Steven Price
 <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>, rick.p.edgecombe@intel.com,
 yan.y.zhao@intel.com
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-28-steven.price@arm.com>
 <CAEvNRgHF-30EwJEprM466+Ag7GSuJWrzMGNAw7kCvXyT7YVucg@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CAEvNRgHF-30EwJEprM466+Ag7GSuJWrzMGNAw7kCvXyT7YVucg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/08/2026 23:43, Ackerley Tng wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> The VMM needs to populate the realm with some data before starting (e.g.
>> a kernel and initrd). This is measured by the RMM and used as part of
>> the attestation later on.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>

...

>> +static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
>> +			       kvm_pfn_t dst_pfn, kvm_pfn_t src_pfn,
>> +			       unsigned long flags)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	phys_addr_t rd = virt_to_phys(realm->rd);
>> +	phys_addr_t dst_phys, src_phys;
>> +	long ret;
>> +
>> +	lockdep_assert_held(&kvm->slots_lock);
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	dst_phys = __pfn_to_phys(dst_pfn);
>> +	src_phys = __pfn_to_phys(src_pfn);
>> +
>> +	if (rmi_delegate_page(dst_phys))
>> +		return -ENXIO;
>> +
>> +retry:
>> +	ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
>> +	if (ret >= 0 && RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +		/* Create missing RTTs and retry */
>> +		int level = RMI_RETURN_INDEX(ret);
>> +
>> +		KVM_BUG_ON(level >= KVM_PGTABLE_LAST_LEVEL, kvm);
>> +
>> +		ret = realm_create_rtt_levels(realm, ipa, level,
>> +					      level + 1, NULL);
>> +		if (!ret)
>> +			goto retry;
>> +	}
>> +
>> +	if (ret && WARN_ON(rmi_undelegate_page(dst_phys))) {
>> +		/* Leak the page if the undelegate fails */
>> +		get_page(pfn_to_page(dst_pfn));
> 
> Is there some way to avoid taking a reference on the page? This would
> interfere with conversions. There was a similar discussion for TDX as
> well [1].

Unfortunately, no. The page was transferred to the Realm world (with
rmi_delegate_page() above the retry: ). If we fail to bring it back,
that page is still in the Realm PAS and any access to it by the normal
world would result in a GPF and eventually bring down the system
if it happens from the kernel.

We don't expect that undelegate to fail. The granule_delegate()
should fail if the page was already in use by the RMM for some
purpose (e.g., already mapped at the IPA, because VMM issued
DATA_MAP_INIT twice. Even with the relaxation coming in the
RMM, we will mandate that the "populate" cases will request
strict conditions for granule delegate).

Please note that this is NOT the "unmap" failure, but it is
"Bring the page back to the NS world" failure that causes
the WARN_ON and the leaking.

> 
> TDX originally incremented folio refounts for these:
> 
> + when mapping folios into the Secure EPTs. This one was easier to agree
>    to remove, since TDX can trust guest_memfd to keep pages around on
>    behalf of the guest.
> + To indicate unmapping failure (IIUC this is the same situation as
>    above). This interferes with conversions.
>      + An alternative discussed was to mark these pages as HWPOISON, but
>        that was eventually rejected as adding unnecessary complexity to
>        make TDX special for code paths that only occur on kernel
>        bugs. (In TDX's case the unmap failures would probably only be for
>        kernel bugs.)
>      + I later worked a bit more on memory failure for guest_memfd
>        HugeTLB and found that because we will need to restructure huge
>        pages for conversions, using the HWPOISON flag would be hard to
>        handle. For TDX since the conclusion was not to use a HWPOISON
>        flag to indicate unmap failures anyway, this turned out to be a
>        non-issue. Nobody wanted to use the HWPOISON flag. (I hope you
>        won't need to either)
> 
> So for TDX, on an unmap failure we do a KVM_BUG_ON() and mark the VM as
> dead, and do nothing about the page, it still gets returned to the
> system as if nothing happened.
> 
> Here's my understanding of why this is okay for TDX (Rick and Yan, could
> you please help me here):
> 
> + For unmap failures, the page remains in TDX's Physical Address
>    Metadata Table (PAMT), and the page is still assigned to some TD.
> + If the page was assigned to some other TD, it would be blocked, since
>    the PAMT shows it as already assigned.
> + If the page was used by something completely unrelated to TDX, then in
>    the TDX model the host is free to write and read pages. Nothing goes
>    bad until the TD tries to use that same page, but that TD would never
>    use the page again, that TD is already dead and the HKID for the TD
>    was leaked.

This is not true for CCA. Like I said above, touching the page in Realm
PAS is going to be disastrous for the Host.


> 
> [1] https://lore.kernel.org/all/diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com/
> 
>> +	}
>> +
>> +	return ret <= 0 ? ret : -ENXIO;
>> +}
>> +
>> +static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>> +			      struct page *src_page, void *opaque)
>> +{
>> +	unsigned long data_flags = *(unsigned long *)opaque;
>> +	phys_addr_t ipa = gfn_to_gpa(gfn);
>> +
>> +	return realm_data_map_init(kvm, ipa, pfn, page_to_pfn(src_page),
>> +				   data_flags);
>> +}
>> +
>> +static long populate_region(struct kvm *kvm,
>> +			    gfn_t base_gfn,
>> +			    unsigned long pages,
>> +			    u64 uaddr,
>> +			    unsigned long data_flags)
>> +{
>> +	long ret = 0;
>> +
>> +	lockdep_assert_held(&kvm->slots_lock);
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	if (!uaddr)
>> +		return -EINVAL;
>> +
> 
> Why not check for !uaddr together with the other checks in
> kvm_arm_rmi_populate?

Yep, we could move it there.

> 
> Also would it be okay to inline populate_region into
> kvm_arm_rmi_populate below?

Ack.

Suzuki
