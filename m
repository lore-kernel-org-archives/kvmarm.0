Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEAD61E47B9
	for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729509613; cv=none; b=MqIhoeK1dNUa6LWWlRf/hyKFJ9AULh9UnkXQlKgxgdXHZkMyrXaGsccD8+3Dr/mBbYd/kWo4wJjN4xaKKCKhwmT85pguWdoMWp2X2R67P6/zLBDRe4eRoFy+96lbt/P1WxQpjPxFCuwlCerD6OXRKJ8Y4SqEPJHjPBIHBankg/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729509613; c=relaxed/simple;
	bh=04+++EXzlIsU3O1OYtV8+JrmYNxTV69w0cFqFS1hxl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DzwkoZ7LF0wbQwvlrn7mzxIaNQX6noN4lwBbEg4gvBs5mC9Eo2erJTZhwoFMM/M4SIGLr7dDfcQIxjnx+9K+SkJI0pgBlYd55B1zJe5G4rurGFmCIYVGK/9MNl8isU3bAKvJSrlYxvoMA54K+38o/ewmfXUNkvcE5nf7GKiOjdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCA96DA7;
	Mon, 21 Oct 2024 04:20:39 -0700 (PDT)
Received: from [10.57.87.148] (unknown [10.57.87.148])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B769F3F528;
	Mon, 21 Oct 2024 04:20:06 -0700 (PDT)
Message-ID: <cffd8486-63af-4e45-9c4b-57ffda2fc63a@arm.com>
Date: Mon, 21 Oct 2024 12:20:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 44/57] arm64: Align sections to PAGE_SIZE_MAX
Content-Language: en-GB
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>, Greg Marsden
 <greg.marsden@oracle.com>, Ivan Ivanov <ivan.ivanov@suse.com>,
 Kalesh Singh <kaleshsingh@google.com>, Marc Zyngier <maz@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Matthias Brugger <mbrugger@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, Oliver Upton <oliver.upton@linux.dev>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20241014105514.3206191-1-ryan.roberts@arm.com>
 <20241014105912.3207374-1-ryan.roberts@arm.com>
 <20241014105912.3207374-44-ryan.roberts@arm.com>
 <69533deb-dc77-49c3-a256-49efee308905@t-8ch.de>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <69533deb-dc77-49c3-a256-49efee308905@t-8ch.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19/10/2024 15:16, Thomas Weißschuh wrote:
> On 2024-10-14 11:58:51+0100, Ryan Roberts wrote:
>> Increase alignment of sections in nvhe hyp, vdso and final vmlinux image
>> from PAGE_SIZE to PAGE_SIZE_MAX. For compile-time PAGE_SIZE,
>> PAGE_SIZE_MAX == PAGE_SIZE so there is no change. For boot-time
>> PAGE_SIZE, PAGE_SIZE_MAX is the largest selectable page size.
>>
>> For a boot-time page size build, image size is comparable to a 64K page
>> size compile-time build. In future, it may be desirable to optimize
>> run-time memory consumption by freeing unused padding pages when the
>> boot-time selected page size is less than PAGE_SIZE_MAX.
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>
>> ***NOTE***
>> Any confused maintainers may want to read the cover note here for context:
>> https://lore.kernel.org/all/20241014105514.3206191-1-ryan.roberts@arm.com/
>>
>>  arch/arm64/include/asm/memory.h     |  4 +--
>>  arch/arm64/kernel/vdso-wrap.S       |  4 +--
>>  arch/arm64/kernel/vdso.c            |  7 +++---
>>  arch/arm64/kernel/vdso/vdso.lds.S   |  4 +--
>>  arch/arm64/kernel/vdso32-wrap.S     |  4 +--
>>  arch/arm64/kernel/vdso32/vdso.lds.S |  4 +--
>>  arch/arm64/kernel/vmlinux.lds.S     | 38 ++++++++++++++---------------
>>  arch/arm64/kvm/hyp/nvhe/hyp.lds.S   |  2 +-
>>  8 files changed, 34 insertions(+), 33 deletions(-)
> 
>> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
>> index 89b6e78400023..1efe98909a2e0 100644
>> --- a/arch/arm64/kernel/vdso.c
>> +++ b/arch/arm64/kernel/vdso.c
>> @@ -195,7 +195,7 @@ static int __setup_additional_pages(enum vdso_abi abi,
>>  
>>  	vdso_text_len = vdso_info[abi].vdso_pages << PAGE_SHIFT;
>>  	/* Be sure to map the data page */
>> -	vdso_mapping_len = vdso_text_len + VVAR_NR_PAGES * PAGE_SIZE;
>> +	vdso_mapping_len = vdso_text_len + VVAR_NR_PAGES * PAGE_SIZE_MAX;
>>  
>>  	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
>>  	if (IS_ERR_VALUE(vdso_base)) {
>> @@ -203,7 +203,8 @@ static int __setup_additional_pages(enum vdso_abi abi,
>>  		goto up_fail;
>>  	}
>>  
>> -	ret = _install_special_mapping(mm, vdso_base, VVAR_NR_PAGES * PAGE_SIZE,
>> +	ret = _install_special_mapping(mm, vdso_base,
>> +				       VVAR_NR_PAGES * PAGE_SIZE_MAX,
>>  				       VM_READ|VM_MAYREAD|VM_PFNMAP,
>>  				       vdso_info[abi].dm);
>>  	if (IS_ERR(ret))
>> @@ -212,7 +213,7 @@ static int __setup_additional_pages(enum vdso_abi abi,
>>  	if (system_supports_bti_kernel())
>>  		gp_flags = VM_ARM64_BTI;
>>  
>> -	vdso_base += VVAR_NR_PAGES * PAGE_SIZE;
>> +	vdso_base += VVAR_NR_PAGES * PAGE_SIZE_MAX;
>>  	mm->context.vdso = (void *)vdso_base;
>>  	ret = _install_special_mapping(mm, vdso_base, vdso_text_len,
>>  				       VM_READ|VM_EXEC|gp_flags|
> 
>> diff --git a/arch/arm64/kernel/vdso/vdso.lds.S b/arch/arm64/kernel/vdso/vdso.lds.S
>> index 45354f2ddf706..f7d1537a689e8 100644
>> --- a/arch/arm64/kernel/vdso/vdso.lds.S
>> +++ b/arch/arm64/kernel/vdso/vdso.lds.S
>> @@ -18,9 +18,9 @@ OUTPUT_ARCH(aarch64)
>>  
>>  SECTIONS
>>  {
>> -	PROVIDE(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE);
>> +	PROVIDE(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE_MAX);
>>  #ifdef CONFIG_TIME_NS
>> -	PROVIDE(_timens_data = _vdso_data + PAGE_SIZE);
>> +	PROVIDE(_timens_data = _vdso_data + PAGE_SIZE_MAX);
> 
> This looks like it also needs a change to vvar_fault() in vdso.c.
> The symbols are now always PAGE_SIZE_MAX apart, while vvar_fault() works
> in page offsets (vmf->pgoff) that are based on the runtime PAGE_SIZE and
> it expects hardcoded offsets.
> 
> As test you can use tools/testing/selftests/timens/timens.
> 
> (I can't test this right now, so it's only a suspicion)

Ahh good spot - that test does infact fail.

This fixes the problem:

---8<---
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 1efe98909a2e0..d2049ba6b19f5 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -151,10 +151,11 @@ int vdso_join_timens(struct task_struct *task, struct
time_namespace *ns)
 static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
                             struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+       pgoff_t pgmaxoff = vmf->pgoff >> (PAGE_SHIFT_MAX - PAGE_SHIFT);
        struct page *timens_page = find_timens_vvar_page(vma);
        unsigned long pfn;

-       switch (vmf->pgoff) {
+       switch (pgmaxoff) {
        case VVAR_DATA_PAGE_OFFSET:
                if (timens_page)
                        pfn = page_to_pfn(timens_page);
---8<---

I'll include it in the next version.

Thanks,
Ryan

> 
>>  #endif
>>  	. = VDSO_LBASE + SIZEOF_HEADERS;
> 
>> diff --git a/arch/arm64/kernel/vdso32/vdso.lds.S b/arch/arm64/kernel/vdso32/vdso.lds.S
>> index 8d95d7d35057d..c46d18a69d1ce 100644
>> --- a/arch/arm64/kernel/vdso32/vdso.lds.S
>> +++ b/arch/arm64/kernel/vdso32/vdso.lds.S
>> @@ -18,9 +18,9 @@ OUTPUT_ARCH(arm)
>>  
>>  SECTIONS
>>  {
>> -	PROVIDE_HIDDEN(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE);
>> +	PROVIDE_HIDDEN(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE_MAX);
>>  #ifdef CONFIG_TIME_NS
>> -	PROVIDE_HIDDEN(_timens_data = _vdso_data + PAGE_SIZE);
>> +	PROVIDE_HIDDEN(_timens_data = _vdso_data + PAGE_SIZE_MAX);
>>  #endif
>>  	. = VDSO_LBASE + SIZEOF_HEADERS;

