Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA05266574
	for <kvmarm@lists.linux.dev>; Wed,  3 Sep 2025 23:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756942577; cv=none; b=IxXbY7PZQkSWSCJvzTm9KmDYKz95qebyeK50EkJnuLCg/hglEtmKej581TULxiESnZmnFVnmrk6HAmLiwT/XInNQBVUnSRiNkbZKI7+C6RTKYXMxsvq/Z9ef65K7rsnY7LuSpqv8gL+MxMiDG/bqucEO0T1+pwR8UUEW1RGREWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756942577; c=relaxed/simple;
	bh=UQkBt8q+mpHkzeoBPwe+VU6jSJ9PJ/G13bT7jdZR32E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CJWkNC/DJEV0YfAde3voq8AGhdAdmxbhM2BGXHYqSmxD9gO7UMNIY9GSJLm80uh0rYtoWVF6yx95MgX3alWB9nS4XRJ8Zgbn+A/9G4BEPFNdua6tN4L1l8/LrRxqrk/RYXfhls1Jlh96DVHbSPDPrZoTFyIHtLu5uGJC6GiDUkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g5dgBiF4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5dgBiF4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756942574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0sXropmRvRzVq8QVYH11V1C2zJovVWTZHbdPqhav95Y=;
	b=g5dgBiF4ajtt6DapSfdrK+Z20ZqwrXleY2hCLbu4DNDPbm6sEMMc3NhhcFuCe/2ug+kjAC
	U0IxfY/kfX2BGctZbw7r3vfLUCwM6xqf9lrHYsIAh+RWL/iqrKIVyg+3oKvzZh+8UxU7+E
	jJEdsyRozCMMwR3DC5S8p8nR2Ggyw2A=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-jf2VHAMQNTafImZlzciyCA-1; Wed, 03 Sep 2025 19:36:13 -0400
X-MC-Unique: jf2VHAMQNTafImZlzciyCA-1
X-Mimecast-MFC-AGG-ID: jf2VHAMQNTafImZlzciyCA_1756942572
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-248eec89618so5514405ad.1
        for <kvmarm@lists.linux.dev>; Wed, 03 Sep 2025 16:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756942572; x=1757547372;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0sXropmRvRzVq8QVYH11V1C2zJovVWTZHbdPqhav95Y=;
        b=BdWIUP+LGfF0utA6vXhAL5Vdx+kTxXGfHgHfVde2EzUOHoDbR4KI77G/Isq5IzYFQ2
         FcSsMgrdXrvWcPxGsiLSZoksOnU63/yoDEVH5wXtmpR6v/qswVeg4JB7mrw9zc7FD4pR
         F5xrdXbqvDBsemPdoTDqeR0TtO2EnSC7X3rnjHwL/dkEx7Z0mLDt3rsRYxYNyJOdqPyK
         oswdGz9nuXiKlzYNJfjBvUEtDGiZYS2xrt9MT6tLsdVtbNtVhSlFI1TctTKAMtj6RNP/
         U5anXsOCnChbaFNsdhuZW6rwDblB8a1WeqvuLEuGH6ppiLYB4xAXCSXS3Xxq04R5RcrZ
         Mx8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgWy4T60JIMHBNCkL/KpZJd/qNydbPNDW1AnvglG8yEC8XlauNN1uvBjF4Fp2VApq54fe90jI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiUdkduew9s5IPePrMzS1h/hRTNy0wwMHL2/j4Qg78MNU0TzBv
	zjA2ZxLA6Q3j49WfEBeES4f6cfdMyqx47pYinS0UjezX9ifFFPVR0PLPfYUa9KpeXL3hUHop1UZ
	jOCQBtW3TrsPwhOMxG7QMejpPLpDojr5qo0MdOYrFZgcsiofGY4dEbftOXw==
X-Gm-Gg: ASbGncsthdc8JELkx7GlvocZHEB9cU03MWD3mlk7Zyo2cSfLqdkL7mQb/aHgXmVUPz4
	FVKtxu2auO2N3BhkQTZuCtg6NJyQDquNuzxOKOn2CJTZ4uY6st8Hi1yhbg4ZAO1Ek8hGZviQOTZ
	lcD6ewOQ/CnywXTpMMJ7xgrLWJAR2pZY2j5/fMxSERKXJ4cV4BmHU1yUeXlmQ2pPdIw4+y7mUN6
	MzcI3+3UC+aYZfgcPtUxu9Cp1ZMuMbg0Phw7uP7IHBzsgTR1HTZmU9ZIB/q8cdy2+nu3KpjMBhI
	kSswQk7vWXSMnD0kxBPIhvB2TGSMbILj91StoljgD+yFUTivn0KA2N10AZLQlCS4aPjRcVY0A6C
	pwmnv
X-Received: by 2002:a17:902:d4cb:b0:249:3049:9748 with SMTP id d9443c01a7336-24944a98207mr213064125ad.35.1756942571802;
        Wed, 03 Sep 2025 16:36:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWxDvzz4guDF0h66h4LLb4oxiM+mn4RFSoqx9tFAX6Irf9VMfNEHKTbxRTX3+Sn09XeYBQ/A==
X-Received: by 2002:a17:902:d4cb:b0:249:3049:9748 with SMTP id d9443c01a7336-24944a98207mr213063695ad.35.1756942571216;
        Wed, 03 Sep 2025 16:36:11 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2490375b6d0sm172156625ad.62.2025.09.03.16.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 16:36:10 -0700 (PDT)
Message-ID: <cb387dcf-7ee0-4cf6-bf10-d043d20190f0@redhat.com>
Date: Thu, 4 Sep 2025 09:36:00 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 15/43] arm64: RME: Allow VMM to set RIPAS
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-16-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250820145606.180644-16-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E1K-ibcKgDgqDzu2u7YGicIFqv1z_veTNIM2ejC7LAU_1756942572
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/25 12:55 AM, Steven Price wrote:
> Each page within the protected region of the realm guest can be marked
> as either RAM or EMPTY. Allow the VMM to control this before the guest
> has started and provide the equivalent functions to change this (with
> the guest's approval) at runtime.
> 
> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
> unmapped from the guest and undelegated allowing the memory to be reused
> by the host. When transitioning to RIPAS RAM the actual population of
> the leaf RTTs is done later on stage 2 fault, however it may be
> necessary to allocate additional RTTs to allow the RMM track the RIPAS
> for the requested range.
> 
> When freeing a block mapping it is necessary to temporarily unfold the
> RTT which requires delegating an extra page to the RMM, this page can
> then be recovered once the contents of the block mapping have been
> freed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v9:
>   * Minor coding style fixes.
> Changes from v8:
>   * Propagate the 'may_block' flag to allow conditional calls to
>     cond_resched_rwlock_write().
>   * Introduce alloc_rtt() to wrap alloc_delegated_granule() and
>     kvm_account_pgtable_pages() and use when allocating RTTs.
>   * Code reorganisation to allow init_ipa_state and set_ipa_state to
>     share a common ripas_change() function,
>   * Other minor changes following review.
> Changes from v7:
>   * Replace use of "only_shared" with the upstream "attr_filter" field
>     of struct kvm_gfn_range.
>   * Clean up the logic in alloc_delegated_granule() for when to call
>     kvm_account_pgtable_pages().
>   * Rename realm_destroy_protected_granule() to
>     realm_destroy_private_granule() to match the naming elsewhere. Also
>     fix the return codes in the function to be descriptive.
>   * Several other minor changes to names/return codes.
> Changes from v6:
>   * Split the code dealing with the guest triggering a RIPAS change into
>     a separate patch, so this patch is purely for the VMM setting up the
>     RIPAS before the guest first runs.
>   * Drop the useless flags argument from alloc_delegated_granule().
>   * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>   * Deal with the RMM granule size potentially being smaller than the
>     host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>     still allocates an entire host page for every RMM granule (so wasting
>     memory when PAGE_SIZE>4k).
> Changes from v5:
>   * Adapt to rebasing.
>   * Introduce find_map_level()
>   * Rename some functions to be clearer.
>   * Drop the "spare page" functionality.
> Changes from v2:
>   * {alloc,free}_delegated_page() moved from previous patch to this one.
>   * alloc_delegated_page() now takes a gfp_t flags parameter.
>   * Fix the reference counting of guestmem pages to avoid leaking memory.
>   * Several misc code improvements and extra comments.
> ---
>   arch/arm64/include/asm/kvm_rme.h |   6 +
>   arch/arm64/kvm/mmu.c             |   8 +-
>   arch/arm64/kvm/rme.c             | 446 +++++++++++++++++++++++++++++++
>   3 files changed, 457 insertions(+), 3 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

