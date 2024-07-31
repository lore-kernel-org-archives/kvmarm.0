Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798FC1A8C15;
	Wed, 31 Jul 2024 09:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722416600; cv=none; b=l8VXLiyK3s6rwDcSqTFEpvgZYoa9bTwXUskAnnyLG3syKGevST5cuA/H+95XgOE81D6dclFIPxPGnbjhzE/yY8I2+8ZAvRlbMJ6nZF+UEV6qA60/gUN8XitxKnjTQZzPiUmpXohCo/0z8eMBCMt/XTiQ/fVhsy+Hmb/f5oFa0zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722416600; c=relaxed/simple;
	bh=L4DRVaflXM78NURF1PSq70OfloJDJuv4xDuaFsKoiF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EG40esnSPwee+/gDlTF0wEQo2vLWouuv3ILuJgjrBPe4eDchH0wgSfyASOw4/C8Kq3nVRyI6zOBEgwzplLQ4BgZ2wJE3ze8oh8G0fs986dqoPMi2F7KIeSxnOq69Bmr1gKgXnqjDF7FaeuYeX6Fisp/k4H9iQGdeP0MLzGftBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DDAF1007;
	Wed, 31 Jul 2024 02:03:36 -0700 (PDT)
Received: from [10.57.94.83] (unknown [10.57.94.83])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94C093F5A1;
	Wed, 31 Jul 2024 02:03:08 -0700 (PDT)
Message-ID: <6b7db3ba-5556-4aae-961c-4ecf31efda5d@arm.com>
Date: Wed, 31 Jul 2024 10:03:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/15] arm64: Mark all I/O as non-secure shared
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-6-steven.price@arm.com>
 <b20b7e5b-95aa-4fdb-88a7-72f8aa3da8db@redhat.com>
 <e05d2363-d3e4-4a23-9347-723454d603c9@arm.com>
 <68acf6c9-4ab8-4ed5-bddc-f3fc5313597e@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <68acf6c9-4ab8-4ed5-bddc-f3fc5313597e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 31/07/2024 07:36, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 7/30/24 8:36 PM, Suzuki K Poulose wrote:
>> On 30/07/2024 02:36, Gavin Shan wrote:
>>> On 7/1/24 7:54 PM, Steven Price wrote:
>>> I'm unable to understand this. Steven, could you please explain a bit 
>>> how
>>> PROT_NS_SHARED is turned to a shared (non-secure) mapping to hardware?
>>> According to tf-rmm's implementation in 
>>> tf-rmm/lib/s2tt/src/s2tt_pvt_defs.h,
>>> a shared (non-secure) mapping is is identified by NS bit (bit#55). I 
>>> find
>>> difficulties how the NS bit is correlate with PROT_NS_SHARED. For 
>>> example,
>>> how the NS bit is set based on PROT_NS_SHARED.
>>
>>
>> There are two things at play here :
>>
>> 1. Stage1 mapping controlled by the Realm (Linux in this case, as above).
>> 2. Stage2 mapping controlled by the RMM (with RMI commands from NS Host).
>>
>> Also :
>> The Realm's IPA space is divided into two halves (decided by the IPA 
>> Width of the Realm, not the NSbit #55), protected (Lower half) and
>> Unprotected (Upper half). All stage2 mappings of the "Unprotected IPA"
>> will have the NS bit (#55) set by the RMM. By design, any MMIO access
>> to an unprotected half is sent to the NS Host by RMM and any page
>> the Realm wants to share with the Host must be in the Upper half
>> of the IPA.
>>
>> What we do above is controlling the "Stage1" used by the Linux. i.e,
>> for a given VA, we flip the Guest "PA" (in reality IPA) to the
>> "Unprotected" alias.
>>
>> e.g., DTB describes a UART at address 0x10_0000 to Realm (with an IPA 
>> width of 40, like in the normal VM case), emulated by the host. Realm is
>> trying to map this I/O address into Stage1 at VA. So we apply the
>> BIT(39) as PROT_NS_SHARED while creating the Stage1 mapping.
>>
>> ie., VA == stage1 ==> BIT(39) | 0x10_0000 =(IPA)== > 0x80_10_0000
>>
>                                                       0x8000_10_0000

Yep, my bad.

> 
>> Now, the Stage2 mapping won't be present for this IPA if it is emulated
>> and thus an access to "VA" causes a Stage2 Abort to the Host, which the
>> RMM allows the host to emulate. Otherwise a shared page would have been
>> mapped by the Host (and NS bit set at Stage2 by RMM), allowing the
>> data to be shared with the host.
>>
> 
> Thank you for the explanation and details. It really helps to understand
> how the access fault to the unprotected space (upper half) is routed to NS
> host, and then VMM (QEMU) for emulation. If the commit log can be improved
> with those information, it will make reader easier to understand the code.
> 
> I had the following call trace and it seems the address 0x8000_10_1000 is
> converted to 0x10_0000 in [1], based on current code base (branch: 
> cca-full/v3).
> At [1], the GPA is masked with kvm_gpa_stolen_bits() so that BIT#39 is 
> removed
> in this particular case.
> 
>    kvm_vcpu_ioctl(KVM_RUN)                         // non-secured host
>    kvm_arch_vcpu_ioctl_run
>    kvm_rec_enter
>    rmi_rec_enter                                   // -> SMC_RMI_REC_ENTER
>      :
>    rmm_handler                                     // tf-rmm
>    handle_ns_smc
>    smc_rec_enter
>    rec_run_loop
>    run_realm
>      :
>    el2_vectors
>    el2_sync_lel
>    realm_exit
>      :
>    handle_realm_exit
>    handle_exception_sync
>    handle_data_abort
>      :
>    handle_rme_exit                                 // non-secured host
>    rec_exit_sync_dabt
>    kvm_handle_guest_abort                          // -> [1]

Correct. KVM deals with "GFN" and as such masks the "protection" bit,
as the IPA is split.

>    gfn_to_memslot
>    io_mem_abort
>    kvm_io_bus_write                                // -> 
> run->exit_reason = KVM_EXIT_MMIO
> 
> Another question is how the Granule Protection Check (GPC) table is 
> updated so
> that the corresponding granule (0x8000_10_1000) to is accessible by NS 
> host? I
> mean how the BIT#39 is synchronized to GPC table and translated to the 
> property
> "granule is accessible by NS host".

Good question. GPC is only applicable for memory accesses that are 
actually "made" (think of this as Stage3).
In this case, the Stage2 walk causes an abort and as such the address is
never "accessed" (like in the normal VM) and host handles it.
In case of a "shared" memory page, the "stage2" mapping created *could*
(RMM doesn't guarantee what gets mapped on the Unprotected alias) be
mapped to a Granule in the NS PAS (normal world page), via 
RMI_RTT_MAP_UNPROTECTED. RMM only guarantees that the output of the
Stage2 translation is "NS" PAS (the actual PAS of the Granule may not
be NS, e.g. if we have a malicious host).

Now, converting a "protected IPA" to "shared" (even though we don't
share the same Physical page for the aliases with guest_mem, but
CCA doesn't prevent this) would take the following route :

Realm: IPA_STATE_SET(ipa, RIPAS_EMPTY)-> REC Exit ->
        Host Reclaims the "PA" backing "IPA" via RMI_DATA_DESTROY ->
        Change PAS to Realm (RMI_GRANULE_UNDELEGATE)

Realm: Access the BIT(39)|ipa => Stage2 Fault ->
        Host maps "BIT(39)|ipa" vai RMI_RTT_MAP_UNPROTECTED.

The important things to remember:

1) "NS_PROT" is just a way to access the "Aliased IPA" in the 
UNPROTECTED half and is only a "Stage1" change.
2) It doesn't *change the PAS* of the backing PA implicitly
3) It doesn't change the PAS of the resulting "Translation" at Stage2, 
instead it targets a "different IPA"->PA translation and the resulting
*access* is guaranteed to be NS PAS.

Suzuki

> Thanks,
> Gavin
> 
> 
> 
> 
> 

