Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4401E5218
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 08:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746435055; cv=none; b=OMWRDj9NWt9J6yY4eQl+hzbSMv6BrGId0lQMol91vEiaOG6u8vBaUd/g9Qj0dkdAqOaHhMNtWel5JakIDDdydLJFU44TMt0N7neitHW8D9yeTJ9KITzuK0kn93w4MHYYRdZuIWS/TW1ELjevfcZkRag3zuOsYvIbjBcOgQ9/CyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746435055; c=relaxed/simple;
	bh=dGj+nqxvZoZhR5SxY74gTpr9hBbS8Khk7mmyoBCBZq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rGVJhh9w5ieC4VajXt3Qnvn/H2u820WIfgXiVGBTzMkSSxAPWalaWoPA0vdqjafqWO9Hoi49/Fw3QNDfcForduveGt63Flo59PSAGjAjjrnQ5IRZhnsQUlL5M3Z8UkpbS3dZA7d6p45h8n7+b7nUNHKEEOp3//0AUx7HinOcA5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD2BD1007;
	Mon,  5 May 2025 01:50:43 -0700 (PDT)
Received: from [10.163.53.144] (unknown [10.163.53.144])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 257CA3F5A1;
	Mon,  5 May 2025 01:50:49 -0700 (PDT)
Message-ID: <16ffa9f2-5ebb-4839-ab87-3c193ab9683a@arm.com>
Date: Mon, 5 May 2025 14:20:46 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] arm64/mm: Implement pte_po_index() for permission
 overlay index
To: Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250415054442.2287891-1-anshuman.khandual@arm.com>
 <20250429151134.GB26272@willie-the-truck>
 <b07c1320-3140-40d3-899b-7c2b6e0d3c18@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <b07c1320-3140-40d3-899b-7c2b6e0d3c18@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/29/25 22:15, Ryan Roberts wrote:
> On 29/04/2025 16:11, Will Deacon wrote:
>> On Tue, Apr 15, 2025 at 11:14:42AM +0530, Anshuman Khandual wrote:
>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>
>>> Previously pte_access_permitted() used FIELD_GET() directly to retrieve
>>> the permission overlay index from the pte. However, FIELD_GET() doesn't
>>> work for 128 bit quanitites. Since we are about to add support for D128
>>> pgtables, let's create a specific helper, pte_po_index() which can do
>>> the required mask and shift regardless of the data type width.
>>
>> You say:
>>
>> "we are about to add support for D128 pgtables"
> 
> Providing some context: Anshuman has a private branch that adds D128 pgtable
> support to the kernel (it does not yet do this for KVM). I originally created
> this patch to fix a bug on that branch, so the "we are about to add ..." comment
> really only makes sense in that context.
> 
> We are not yet ready to post D128 upstream - there are still a lot of questions
> to answer - but Anshuman has been posting some of the reshuffling and cleanups
> that prepare the way for D128 where (we think) it makes sense. The aim is to
> reduce the diff as much as we can.

Agreed. All these patches have been really harmless clean ups and re-orgs etc,
that do not affect existing 64 bit page table management or its functioning in
any manner. OTOH these changes help the kernel prepare for D128 enablement.

> 
>>
>> but all I've seen so far are piecemeal patches like this and it's hard
>> to know what to do with them, to be honest. Somebody could reasonably
>> turn up next week and clean this up to use FIELD_GET() again.
>>
>> Grepping around, I also see that the KVM page-table code uses the FIELD_*
>> macros on page-table entries, so perhaps we're better off adding support
>> for 128-bit types to those instead of trying to avoid them?
> 
> I think FIELD_* are always implicitly 64 bit, right? I could be wrong...
> 
> But I agree with the overall sentiment; where stuff is clearly crossing over
> into KVM, which hasn't been tackled yet, don't post until we have a good view on
> what KVM needs.
Keeping KVM changes separate was the motivation in V1 of this patch for similar
reasons. KVM uses FIELD_GET() for all the page table management purposes, hence
wanted to keep these S1 changes separate.
