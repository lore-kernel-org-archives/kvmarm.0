Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC1B37AA97
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 08:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673454; cv=none; b=iXYmUt3BsygXUfZsb4Hs2ZAdNte7oCK7n3Lmb7xWUMaVAOL8qnSa24RWhxYKQyIISufbgdZkfOV8/+5Rf9aES4ADaU1+UpkHEv3fpcF4qr6n9qVgXd2tVu1fEM4YbNJs1jE8jvY9a9eoG9ns+SeUofKzQyTBzygGGeZEwOY89Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673454; c=relaxed/simple;
	bh=531uqzE4LNSGQaQzGZp72+k4OWpnOWwrASTrhirbtnM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=FJ7yMOND7ZZ32GByATPn2ny5fOlbeIguPYfR/SLXu0QYNkmJjZy1KniaxryL7yDZP+Q+vSAxXt0pMr1Gb4csNrYrtHKTs2e8t9D+KHfg90jEhONukCpGxt8R9sfa1XK4Wf0BRGyu+vfiqUWdAE2fXdNipG6BV8uGELtY0dGx6L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VbknYlqK; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VbknYlqK"
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783673449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=speNZ5kxqcfvumuAgKlguzjeDrPs0cEQRv6glMz1oGY=;
	b=VbknYlqKj+XeIwzbMFqz18KoTCbiahRLIUVGMfOYwRvwWQDGfJDqU13WBtB/ZEsWkuWtpf
	LVp/piuHvqgAGyy/krjeq3Z0CfZpSJGS5hLhzUS23o4QaH1h9OySlwj9sRNCmz9Mjw5s8I
	WN1kk+gEuGno4d9AStWzQ1C6uj+gB+k=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jul 2026 08:50:25 +0000
Message-Id: <DJURGJEHZHFY.3SINJIME8E9RB@linux.dev>
Cc: "Ackerley Tng" <ackerleytng@google.com>, "Takahiro Itazuri"
 <itazur@amazon.com>, <fvdl@google.com>, <ljs@kernel.org>,
 <Liam.Howlett@oracle.com>, <agordeev@linux.ibm.com>,
 <ajones@ventanamicro.com>, <akpm@linux-foundation.org>, <alex@ghiti.fr>,
 <andrii@kernel.org>, <aou@eecs.berkeley.edu>, <ast@kernel.org>,
 <baolu.lu@linux.intel.com>, <bp@alien8.de>, <chenhuacai@kernel.org>,
 <corbet@lwn.net>, <coxu@redhat.com>, <daniel@iogearbox.net>,
 <dave.hansen@linux.intel.com>, <david@kernel.org>, <derekmn@amazon.com>,
 <dev.jain@arm.com>, <eddyz87@gmail.com>, <gerald.schaefer@linux.ibm.com>,
 <gor@linux.ibm.com>, <haoluo@google.com>, <hca@linux.ibm.com>,
 <hpa@zytor.com>, <itazur@amazon.co.uk>, <jackabt@amazon.co.uk>,
 <jackmanb@google.com>, <jannh@google.com>, <jgg@ziepe.ca>,
 <jgross@suse.com>, <jhubbard@nvidia.com>, <jiayuan.chen@shopee.com>,
 <jmattson@google.com>, <joey.gouly@arm.com>, <john.fastabend@gmail.com>,
 <jolsa@kernel.org>, <jthoughton@google.com>, <kpsingh@kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, <lenb@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <lorenzo.stoakes@oracle.com>, <luto@kernel.org>, <maobibo@loongson.cn>,
 <martin.lau@linux.dev>, <maz@kernel.org>, <mhocko@suse.com>,
 <mingo@redhat.com>, <mlevitsk@redhat.com>, <nikita.kalyazin@linux.dev>,
 <oupton@kernel.org>, <palmer@dabbelt.com>, <patrick.roy@linux.dev>,
 <pavel@kernel.org>, <pbonzini@redhat.com>, <peterx@redhat.com>,
 <peterz@infradead.org>, <pfalcato@suse.de>, <pjw@kernel.org>,
 <prsampat@amd.com>, <rafael@kernel.org>, <riel@surriel.com>,
 <rppt@kernel.org>, <ryan.roberts@arm.com>, <sdf@fomichev.me>,
 <shijie@os.amperecomputing.com>, <skhan@linuxfoundation.org>,
 <song@kernel.org>, <surenb@google.com>, <suzuki.poulose@arm.com>,
 <svens@linux.ibm.com>, <tabba@google.com>, <tglx@kernel.org>,
 <thuth@redhat.com>, <urezki@gmail.com>, <vannapurve@google.com>,
 <vbabka@kernel.org>, <will@kernel.org>, <willy@infradead.org>,
 <wu.fei9@sanechips.com.cn>, <x86@kernel.org>,
 <yang@os.amperecomputing.com>, <yangyicong@hisilicon.com>,
 <yonghong.song@linux.dev>, <yosry@kernel.org>, <yu-cheng.yu@intel.com>,
 <yuzenghui@huawei.com>, <zhengqi.arch@bytedance.com>, <zulinx86@gmai.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Sean Christopherson" <seanjc@google.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com> <20260508081812.12345-1-itazur@amazon.com> <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com> <DJP40SEE38XA.3BXJN4U0VDIOS@linux.dev> <akw1lZDEv8_Ub1zQ@google.com>
In-Reply-To: <akw1lZDEv8_Ub1zQ@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon Jul 6, 2026 at 11:09 PM UTC, Sean Christopherson wrote:
> On Fri, Jul 03, 2026, Brendan Jackman wrote:
>> There are also the fault paths though; if the pages are nonpresent in
>> the direct map for the duration of their life in the page cache (and I
>> think they should be) then by the time we get to
>> kvm_mmu_faultin_pfn_gmem() or kvm_gmem_fault_user_mapping() we lost the
>> ability to zero them.
>>=20
>> My original answer for this was "that's fine, we'll use __GFP_ZERO
>> (which will probably use the mermap under the hood)", but now I've
>> realised there's a good reason we don't set __GFP_ZERO at the moment,
>> namely that it's wasted if we end up doing kvm_gmem_populate()
>
> Eh, don't worry about the wasted cycles for populate().  The overhead of =
zeroing
> a page is dwarfed by the overhead of adding (and in most cases, measuring=
) the
> page.
>
> We (KVM folks) discussed this in the context of in-place conversions, and=
 long
> story short, the consensus is that shaving cycles by eliding the zeroing =
in the
> host isn't worth the complexity.

OK thanks, this is useful. Nonetheless because it leads to a less
confusing dishgn, I think it still makes sense to just disallow
__GFP_ZERO for the unmapped pages.=20

(At least, at the page allocator level. We might want to allow it in
address_space.gfp_mask or something and have filemap.c deal with it.
But, overloading a GFP flag like this is yucky, if we need a flag for
that I think it's likely neater to make it an AS_ flag or something).

>> (Continued below...)
>>=20
>> > I'm a little bit uncomfortable this statement since it seems to say TD=
X
>> > and SNP aren't taken care of. Would just like to discuss (for
>> > a line of sight to SNP and TDX support):
>>=20
>> Are you saying we need NO_DIRECT_MAP support for TDX/SNP? I think that
>> would be doable but what's the value?
>
> Hardening against consumption of shared memory?  Yes, the guest has expli=
citly
> shared the memory so there are (very) reduced expectations around confide=
ntiality
> and integrity, but defense in depth and all that.

Ah yeah, it did not occur to me that there was memory being set up via
CoCo paths that is not encrypted. So yeah that makes perfect sense.
Eventually we'll want to be able to lean on this to protect that shared
memory against attacks by other VMs etc.

> For me, the main thing is that I don't want to completely punt on the int=
eraction
> of the two things, and end up with an unworkable mess if there's ever a s=
trong
> reason for CoCo VMs to support NO_DIRECT_MAP.

Yeah that makes sense.

>> So that we can get a #PF instead of #MCE if we screw up?
>
> Note, SNP gets a #PF either way.
>
>> NOW, the thing I'm stuck on (again lol) is the patchset-fu. Here's all
>> the parts we need, with dependencies indented:
>>=20
>> 0. efficient GUEST_MEMFD_FLAG_NO_DIRECT_MAP
>>   1. AS_NO_DIRECT_MAP
>>     2. ALLOC_UNMAPPED (formerly known as __GFP_UNMAPPED)
>>       3. alloc_flags arg to the page allocator (I'm sneakily introducing=
 this
>>          in [1])
>>       4. freetype_t=20
>>   5. The mermap
>>     6. The mm-local region
>>=20
>> I originally posted all of those in [0], except part 3. Doing all of
>> that together in one series would be a bit too much though. Approaches I
>> can see to avoid that:
>>=20
>> Approach X:
>> - Do parts 1, 2 and 4 as a standalone series. The only beneficiary of
>>   AS_NO_DIRECT_MAP would be secretmem.=20
>> - Then another series that fills in 0, 5 and 6.
>>=20
>> Approach Y:
>> - One series that does parts 0, 1, 5, and 6. AS_NO_DIRECT_MAP is
>>   implemented by having filemap.c itself call folio_zap_direct_map(),
>>   then guest_memfd.c zeroes it via the mermap. It works but it's really
>>   slow.
>> - Then another series that fills in parts 2 and 4, switches filemap.c
>>   over from manual folio_zap_direct_map() to ALLOC_UNMAPPED, making
>>   things fast.
>>=20
>> Approach X seems natural from a code progression perspective but leaves
>> us with an interim phase where we have a bunch of complexity just to
>> "optimise secretmem" which nobody cares about.
>>=20
>> Approach Y seems natural from a feature progression perspective but
>> leaves us with an interim phase where we expensively zap a page, only to
>> then immediately do this complex mermap dance to access it right
>> afterwards.
>>=20
>> Any thoughts / other ideas? Personally I think I prefer X.
>
> I don't have preference between those options, mostly because I don't app=
reciate
> the difference.  My overarching preference is to separate the mm/ work fr=
om the
> guest_memfd as much as possible.  Beyond that, I probably don't care all =
that much?

Cool thanks, shrugs are fine here.=20

Main thing I'm trying to do here is generate some awareness that the
decision is being made, so that I don't forge ahead with X and then have
people going "ugh, why haven't you considered Y?" If nobody cares either
way then nothing to worry about.
