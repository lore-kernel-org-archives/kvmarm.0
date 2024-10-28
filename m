Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DE31D6DDA;
	Mon, 28 Oct 2024 12:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119658; cv=none; b=g+hRRE38qCkz81+hBJkTcpzdjwnF8JsqJHjQX/kcZ9nlujW1CMpOD6FjECWW4novrpFoFFdGLROhnc2jLEz5u2AG2e/Gl030VKY62qP8j66JExA3rWZTf8Pt749no13/rv1ZAS55GmVDJnAn7EtnAKA9lbZTnftTFThqhgW3c1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119658; c=relaxed/simple;
	bh=OlZRFoq/d2AxHvHoLmuiflTglaY8xpIsCiBPVNVcTJI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=B9sfh4WVtQP3VV63H+aRmLjW7PJF7tvAATalM+b7VrKlWU0Hy0MosaSOCrmPT4spzt3+uZQV1IT99Amrxfgk7PJPBM+MsKzuhjmuQxaL037YRlGt0+t8saBgs7GXRMpGvwon0xhJooligTv+TUmnFLt3pKulM1ZhnaDeUmqV0Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgEqUa8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgEqUa8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5529BC4CEC3;
	Mon, 28 Oct 2024 12:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730119658;
	bh=OlZRFoq/d2AxHvHoLmuiflTglaY8xpIsCiBPVNVcTJI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XgEqUa8ho42bb+yGuEH9XkK4eQ9oawObnaYQ3J0+IZvXG3ToTEigom2v9XbI+d6vy
	 xYQ4vHIt4IYi1Ksh39GYV77uXOYz85aZ6jNU+OWk6pHfDB7n2JfgjkouF6ofaaIYsF
	 3DmWhoIwwlhDRSMJnFhJgiSYQOKZ1gyvAoy5THY3hrTM4nCJjTtExvQJP3a7bUT88b
	 KRZA8e6CDinrPSPidQib2chsGbcvivIeelaa5WIkqDPDdtKZPwzWjqtpIXl5n7pwzx
	 Zwr4w9QCEfUecTACLN3WnN+9ont9VpdWNGxQpFtKImVKYe5he04xL0d4ueIv7Doyod
	 j4t6juMe+uiwQ==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/4] arm64: mte: update code comments
In-Reply-To: <87plnktt2q.wl-maz@kernel.org>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
 <20241028094014.2596619-4-aneesh.kumar@kernel.org>
 <87plnktt2q.wl-maz@kernel.org>
Date: Mon, 28 Oct 2024 18:17:30 +0530
Message-ID: <yq5attcwcs2l.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Hi Marc,

Thanks for reviewing the changes.

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 28 Oct 2024 09:40:13 +0000,
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>> 
>> commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
>> initialisation") updated the locking such the kernel now allows
>> VM_SHARED mapping with MTE. Update the code comment to reflect this.
>> 
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  arch/arm64/kvm/mmu.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> This is a KVM patch. Please make sure you write the subject
> accordingly, matching the existing conventions (in this case, this
> should read something like: "KVM: arm64: MTE: Update...").
>

Will update

>
>> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index a509b63bd4dd..b5824e93cee0 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1390,11 +1390,8 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
>>   * able to see the page's tags and therefore they must be initialised first. If
>>   * PG_mte_tagged is set, tags have already been initialised.
>>   *
>> - * The race in the test/set of the PG_mte_tagged flag is handled by:
>> - * - preventing VM_SHARED mappings in a memslot with MTE preventing two VMs
>> - *   racing to santise the same page
>> - * - mmap_lock protects between a VM faulting a page in and the VMM performing
>> - *   an mprotect() to add VM_MTE
>> + * The race in the test/set of the PG_mte_tagged flag is handled by
>> + * using PG_mte_lock and PG_mte_tagged together.
>
> How? This comment is pretty content-free. TO be useful, you should
> elaborate on *how* these two are used together.
>

I will add more details described in commit d77e59a8fccde7fb5dd8c57594ed147b4291c970
Should i quote the commit there in the comment? 

>
>>   */
>>  static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>>  			      unsigned long size)
>> @@ -1646,7 +1643,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	}
>>  
>>  	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
>> -		/* Check the VMM hasn't introduced a new disallowed VMA */
>> +		/*
>> +		 *  not a permission fault implies a translation fault which
>> +		 *  means mapping the page for the first time
>
> How about an Access fault due to page ageing?
>

IIUC access fault is already handled by the caller kvm_handle_guest_abort?
I can add that as part of the updated comments?

-aneesh
