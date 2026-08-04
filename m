Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3460B3E44F0;
	Tue,  4 Aug 2026 13:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785849571; cv=none; b=scCyyyobbiSb+VUWgyMNDtE4ab/F5E/qKY/1pUi1sil/FYBhQx7QHecziwSJiDDpLCITAiPO0fYvYuBzZeG6oR12GX4yKSIvmR+J6zbxO/7ZwByr7di0XNO9iQgJ0qHfd4Tx8SbbS/M6RFm0lNsDzbmMHJ5Pc0GPKA5jI7hw4kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785849571; c=relaxed/simple;
	bh=NvRjT9Esb9qj9dSa9tEJ9J5zZySATr33Mf+UnG5bR7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tccUcTaXEtv/v+yiLZew7peaZlXW62I4bC7zFcxQKU62uekVNrVycTl9HdvivECoxe+Pyn7MgX/pOg2wRu0os90GcHpdxbCjhfrWq3JimGwWvzKoOr3uYbgI7utZwRukAoZuWD89siuiKaY4E3DMghyuWZPw+x08sNB9AUHHC2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OMrE8whL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OMrE8whL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AC3E1476;
	Tue,  4 Aug 2026 06:19:24 -0700 (PDT)
Received: from [10.57.44.180] (unknown [10.57.44.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B7143F66F;
	Tue,  4 Aug 2026 06:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785849568; bh=NvRjT9Esb9qj9dSa9tEJ9J5zZySATr33Mf+UnG5bR7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OMrE8whLpJFQBhveqqIbqAKKQcVRCbg591te1k+SA8QgvhFbMxmJHLashxhYfOgAi
	 juCGKJHjJl2XgtyAskltDE52iESHO+ckTd+1nhO8VxHE6lR4xaULOG3bJ9Zw+6LBpw
	 oUHfurqWDSK1GhkwDpTz/6+EFboAsUiSLESB6vGA=
Message-ID: <3b8d49be-f031-4134-bd20-a8c51632f4ad@arm.com>
Date: Tue, 4 Aug 2026 14:19:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 15/37] KVM: arm64: CCA: Handle RMI_EXIT_RIPAS_CHANGE
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Quentin Perret <qperret@google.com>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-16-steven.price@arm.com> <865x1rcvfw.wl-maz@kernel.org>
 <f971d029-84d9-4c66-9875-36fa8f1a2a1b@arm.com> <86zez3b6ps.wl-maz@kernel.org>
 <7beafe29-0c5e-418b-8797-190f1850b18a@arm.com>
 <CA+EHjTx751071VhZPf6ABaZngTqOdPG+_aVLCTct_G_ksfYviA@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTx751071VhZPf6ABaZngTqOdPG+_aVLCTct_G_ksfYviA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad

Thanks for your feedback.

On 04/08/2026 13:20, Fuad Tabba wrote:
> Hi Suzuki,
> 
> + Quentin (who's on leave, but for when he gets back)
> 
> On Mon, 3 Aug 2026 at 16:30, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> ...
>>> I.e don't hack into the API. Use the information you already have to
>>> decide whether you need to use the existing API at all.
>>>
>>> If that cannot be done for whatever reason, then you need to indirect
>>> the call with a set of operations that leave the existing code
>>> untouched.
>>
>> Please let us know if you think we need to explore this ^ ?
> 
> FWIW, pKVM already has this kind of indirection: in protected mode,
> the kvm_pgtable_stage2_* calls in mmu.c dispatch to the
> pkvm_pgtable_stage2_* wrappers through KVM_PGT_FN(), and the callers
> don't branch. It is global today because pKVM owns the whole host, but
> a per-VM version would let the CCA backend handle the filter and the
> IPA aliasing internally, keeping __unmap_stage2_range()'s signature
> intact. That should work for pKVM as well.

Sure, will explore this option. For the record, the patch here only 
passes down the "filter" parameter to __unmap_stage2_range() [ though
in a different name, only_shared ] and we still handle the aliasing 
inside the CCA code. Let me explore on this front.

Suzuki



> 
> Cheers,
> /fuad

