Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C4126299;
	Tue, 19 May 2026 12:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779195363; cv=none; b=fN0Egw4qUIEZeHbhnms37N/2azIGsE9ONlzyQyKv42N93FR01WrfNOVtZ6iN2ag3iAS06sK9IBb4Zl7iEi+49OykOOJOartchIwmtN6HwwBk7kWwWpCbMSy3U7rTPiu8nidaMuPiDpEsfYwQ0qukb3Zq6Wcf53Yx2GfmETdeIwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779195363; c=relaxed/simple;
	bh=Xfxs9VwhdJKne3gTf8HJ94QxvyAL3Oe1auKr7Ait+AI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hauSdXWNgeIixL9NpH1Hr7aQKd2r0iRZdJfwsvlS7nOMdrhXBPZGtfL0wTw08ZtoEDZdoYX+nfzBfuyP89GQGlX5ccUsEqhelhy/LQiYvDIH4PC329F7O2ugKYWkude/XB1rDqtx6SaBEGkXfnmgLgNrORcUQqSXeGQUXFLHm3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFYn2EQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFYn2EQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9A4C2BCB3;
	Tue, 19 May 2026 12:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779195362;
	bh=Xfxs9VwhdJKne3gTf8HJ94QxvyAL3Oe1auKr7Ait+AI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=PFYn2EQI6o67e3QXj1DmucFzY5eMUMVymfs8SWHXncySGE4NzDUggvInLFr6ixsxt
	 qYg0twpu4rJ6zwcv2EkrCHFLnYMtZXbPyPGyQp7J8y6uStLkA66YZkf9TMjMAtB0R7
	 gwC3eSMHnmV+sx9T9KrsuVPkn2Peyno2mWDGmAhKcSD1ZXmBVlfxMa6QQVn42RIznn
	 3OIPR8CO0/7k0gkobMUa7ZtA/zloHi04HmIUPdroRaX/R0/MQws3I14tk74bCHstbG
	 fo2NHacy3VzbZSO2K5OYkAyPm4uD8SVAWH28rdJeyJFPUhYvBk77tTXkmsWtJMuJ1E
	 51FQMMQt4xrcw==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com
Subject: Re: [PATCH v14 27/44] arm64: RMI: Set RIPAS of initial memslots
In-Reply-To: <6681f10b-0966-42e2-ae04-4e1aef47ec4d@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-28-steven.price@arm.com>
 <yq5av7cjsonr.fsf@kernel.org>
 <6681f10b-0966-42e2-ae04-4e1aef47ec4d@arm.com>
Date: Tue, 19 May 2026 18:25:52 +0530
Message-ID: <yq5ajyszsgmf.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 19/05/2026 11:02, Aneesh Kumar K.V wrote:
>> Steven Price <steven.price@arm.com> writes:
>> 
>>> The memory which the realm guest accesses must be set to RIPAS_RAM.
>>> Iterate over the memslots and set all gmem memslots to RIPAS_RAM.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>   
>>   ...
>>   
>>> +static int set_ripas_of_protected_regions(struct kvm *kvm)
>>> +{
>>> +	struct kvm_memslots *slots;
>>> +	struct kvm_memory_slot *memslot;
>>> +	int idx, bkt;
>>> +	int ret = 0;
>>> +
>>> +	idx = srcu_read_lock(&kvm->srcu);
>>> +
>>> +	slots = kvm_memslots(kvm);
>>> +	kvm_for_each_memslot(memslot, bkt, slots) {
>>> +		if (!kvm_slot_has_gmem(memslot))
>>> +			continue;
>>> +
>>> +		ret = realm_init_ipa_state(kvm, memslot->base_gfn,
>>> +					   memslot->npages);
>>> +		if (ret)
>>> +			break;
>>> +	}
>>> +	srcu_read_unlock(&kvm->srcu, idx);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>>   int kvm_arm_rmi_populate(struct kvm *kvm,
>>>   			 struct kvm_arm_rmi_populate *args)
>>>   {
>>> @@ -890,6 +922,10 @@ int kvm_activate_realm(struct kvm *kvm)
>>>   			return ret;
>>>   	}
>>>   
>>> +	ret = set_ripas_of_protected_regions(kvm);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>>   	ret = rmi_realm_activate(virt_to_phys(realm->rd));
>>>   	if (ret)
>>>   		return -ENXIO;
>> 
>> relam guest already does.
>> 	for_each_mem_range(i, &start, &end) {
>> 		if (rsi_set_memory_range_protected_safe(start, end)) {
>> 			panic("Failed to set memory range to protected: %pa-%pa",
>> 			      &start, &end);
>> 		}
>> 	}
>> 
>> if so why is host required to do this ?
>
> Ideally this should be a call from the VMM (i.e., user). Irrespective of
> what the guest does (which the host has no knowledge about), the VMM/
> user is better aware of what to do for a given guest. We have done this
> implicitly in the KVM as a start, to keep the initial implementation
> simple. This could be moved out to the VMM as UABI, if there is
> sufficient demand for it.
>
> TL,DR: This should be a host/deployer decision, not the Guest. There
> may other guest OS, which do not do RIPAS_RAM early enough.
>

Are we suggesting that when the guest is running out of DRAM initialized
via rmi_rtt_data_map_init(), it may need to access memory outside that
range before it gets a chance to set the RIPAS as RAM?

Does that mean the guest now has to trust the host for that?
rmi_rtt_init_ripas() is not added to the measurement details, right?

-aneesh
