Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CEB3E5A21;
	Wed, 19 Aug 2026 07:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787125467; cv=none; b=AlE9G7UxH+AwyOB/qX1FWfHKqQvF605OJfQYmwOm6kcduHYeOQIloSUSToehfcJCG8mSChRt9MT86sLnug1cbY4nOyim2lQtTP2eUVq7NIRuk8MOA3KVk2J0b+RWSeOEJpbHjQ4/WVae745zqKToZVi+cO7B3UDw4AJ9sxaN580=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787125467; c=relaxed/simple;
	bh=hV9NBaUwK+oKkfZSdLXfpyMZfhgM/jI1Lfjt+6zk9ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KhhTn4fVPMDx94z5Ns1aZ3y6A1337gyGc7BwRDah4BfHoO0TzjIPl4y9SoVpiiJ9TJXLPY5jvfOTUknl7LsTACQ1/yVPgKccq0yth+7SvUXE2NRAl53U+yATw3e3jXWNCKE/m7pEkQlB4ivQQCt+bMd4Ws+5+3twuplC45igjoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHXnOLDU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHXnOLDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BED41F00A3A;
	Wed, 19 Aug 2026 07:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787125457;
	bh=oubRuLbWFLvlMtuijW3QP2kJ9jOj3msRaRwNjdZfPBI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DHXnOLDURblrCknCEm7wpgbuy950TbTtzP4gAhGpRMC2KQpomqfvvTRtv1WVfAP6H
	 +CXccsHyK6xG1398yn1a0GIWAgdfkj6TBy8H/fvs5O2oiYL7vftl3ik94q4gs3vhSd
	 YRYl2SZ87oiHq214+ZsqKjpRDyfOi2LHJQ1e9xuqa4Rp9fS3Nxyj0Rjy7Mm+uwumU7
	 tduJrbv6+sBuDue5R//X+STX9rZIA+l69GQdy/+9UojX4O7BSVstC1QDJsuSVCA7/U
	 x+hj53ks8ZO9v36xQKU9PrccnqMvCCWLOS1zN6jz4qu/V1tAC9Sh8t0B85Nxy8ocEq
	 AFXT/PSiIyO9Q==
Message-ID: <7c368424-80f9-4491-8578-d26ccc7dc835@kernel.org>
Date: Wed, 19 Aug 2026 09:44:08 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] Stop returning struct page from guest_memfd PFN
 lookup
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
 Yan Zhao <yan.y.zhao@intel.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Vishal Annapurve <vannapurve@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <807b4b9f-b1ca-4b5c-bc9e-22bf0637ba33@kernel.org>
 <aoS4wd6Dy9DlluHl@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoS4wd6Dy9DlluHl@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/26 21:55, Sean Christopherson wrote:
> On Tue, Aug 18, 2026, David Hildenbrand (Arm) wrote:
>> On 8/18/26 11:15, Ackerley Tng wrote:
>>> KVM currently expects kvm_gmem_get_pfn() to return a refcounted struct
>>> page. Callers (such as x86 TDP MMU, arm64 Stage-2 fault handler, and SEV-SNP
>>> VMSA / RMP handlers) hold this refcount across page fault handling.
>>>
>>> Holding a page refcount across fault handling is problematic for guest_memfd.
>>> In-place memory conversions between confidential computing shared and private
>>> states inspect folio refcounts to ensure exclusive ownership by guest_memfd.  A
>>> concurrent guest page fault taking a reference on the folio causes conversions
>>> to fail due to an elevated refcount.
>>
>> Right. Won't we still, at least temporarily, grab a reference while looking up
>> the folio in the page cache, or will we be preventing that concurrent race with
>> locking?
> 
> The latter.  What I want to aim for is that if the relevant guest_memfd range
> has never been mmap()'d and there are no memory failures, then conversion is
> guaranteed to not fail due to elevated refcounts.
> 
> Or to put it a different way, I want KVM's ABI to be that pausing vCPU is *NOT*
> required to perform an in-place conversion.

Having the VM access a page that is currently under conversion (triggered by the
VM) should not be the common case, no? Except, prefaulting, of course.

-- 
Cheers,

David
