Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E046B3C2777;
	Fri, 10 Jul 2026 12:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783684934; cv=none; b=dGnBGjcXpLYWSfjldE2FmE98JfiWhcFLTjGZgrGVSkf7T4rzWGLs5H2l8tXY22MNmRgoBXRlGftvkorf5r6FHa3NxcaKcTEYmGIfDFndbmBg/Z+ngKuaGTpg1OdGXy+7uv6mR92FwuyTgh/wbX8RvCBqAw1Y5J6oTKuRz3f1YgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783684934; c=relaxed/simple;
	bh=VbD/U3mZLcFNprQtikPmaVhdVIAHp3rEpPdxQ8KyssQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=el9F4NxIvEEsjw22E2odUU8LtzbZJIC+h5GkZtbe2QuRERkJm/rBInr/TAgCpz+NtOyxHMQLTner5bxZ6nkRpevdyOwK0032S7kw1Rkv8Q7wz30G+4W+dA1IJCGbEeltqR6w716tG5dLWnVNewqpIkJTVDFlJSjaWWd9Bnyy5tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=guCeLf94; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="guCeLf94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E3C1F000E9;
	Fri, 10 Jul 2026 12:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783684930;
	bh=PP3VC/37RzTAGWL7k/+I+tmeLylhrGIoDnWfhyG+Q0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=guCeLf94Bg9R/kH/GNwmitbcZ9pnDfuV2KrvtxKoIIzqP/+DoqIomIHeCNsbYF3ro
	 qKp3wQ5pxTpNyQYt1whiGSQ+yjFoChrqoYDZObx4xLdK4ZH6Zwl7sUjBa8SAOvvB8o
	 GkHN6O/EYamKycKyvIzCvz09r4rK1kRkytWrj9fPaoXO291aq3SAbD9htWsQC9qF8e
	 ilfy9Xj+IlsOiuZVK0DPpJ8QkdGDUAgF/wBdnF4J6fAy8Z4xJ6RNSl3i0X8WCd31XK
	 /Da0mhyQ43cK8N+cdPKBY2//YItjHgz/aN9i+KbDo2RNaPiJvpPn658lyyQFV8rUJq
	 4wb+jt6MWPqQQ==
Date: Fri, 10 Jul 2026 13:01:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Takahiro Itazuri <itazur@amazon.com>, fvdl@google.com, 
	Liam.Howlett@oracle.com, agordeev@linux.ibm.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, alex@ghiti.fr, andrii@kernel.org, aou@eecs.berkeley.edu, 
	ast@kernel.org, baolu.lu@linux.intel.com, bp@alien8.de, chenhuacai@kernel.org, 
	corbet@lwn.net, coxu@redhat.com, daniel@iogearbox.net, 
	dave.hansen@linux.intel.com, david@kernel.org, derekmn@amazon.com, dev.jain@arm.com, 
	eddyz87@gmail.com, gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, 
	haoluo@google.com, hca@linux.ibm.com, hpa@zytor.com, itazur@amazon.co.uk, 
	jackabt@amazon.co.uk, jackmanb@google.com, jannh@google.com, jgg@ziepe.ca, 
	jgross@suse.com, jhubbard@nvidia.com, jiayuan.chen@shopee.com, 
	jmattson@google.com, joey.gouly@arm.com, john.fastabend@gmail.com, jolsa@kernel.org, 
	jthoughton@google.com, kpsingh@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	lenb@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, luto@kernel.org, maobibo@loongson.cn, martin.lau@linux.dev, 
	maz@kernel.org, mhocko@suse.com, mingo@redhat.com, mlevitsk@redhat.com, 
	nikita.kalyazin@linux.dev, oupton@kernel.org, palmer@dabbelt.com, patrick.roy@linux.dev, 
	pavel@kernel.org, pbonzini@redhat.com, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, pjw@kernel.org, prsampat@amd.com, rafael@kernel.org, 
	riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, sdf@fomichev.me, 
	shijie@os.amperecomputing.com, skhan@linuxfoundation.org, song@kernel.org, surenb@google.com, 
	suzuki.poulose@arm.com, svens@linux.ibm.com, tabba@google.com, tglx@kernel.org, 
	thuth@redhat.com, urezki@gmail.com, vannapurve@google.com, vbabka@kernel.org, 
	will@kernel.org, willy@infradead.org, wu.fei9@sanechips.com.cn, x86@kernel.org, 
	yang@os.amperecomputing.com, yangyicong@hisilicon.com, yonghong.song@linux.dev, 
	yosry@kernel.org, yu-cheng.yu@intel.com, yuzenghui@huawei.com, 
	zhengqi.arch@bytedance.com, zulinx86@gmai.com
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
Message-ID: <alDe8fpxdafnfuqb@lucifer>
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
 <20260508081812.12345-1-itazur@amazon.com>
 <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com>
 <DJP40SEE38XA.3BXJN4U0VDIOS@linux.dev>
 <akw1lZDEv8_Ub1zQ@google.com>
 <DJURGJEHZHFY.3SINJIME8E9RB@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJURGJEHZHFY.3SINJIME8E9RB@linux.dev>

On Fri, Jul 10, 2026 at 08:50:25AM +0000, Brendan Jackman wrote:
> On Mon Jul 6, 2026 at 11:09 PM UTC, Sean Christopherson wrote:
> > On Fri, Jul 03, 2026, Brendan Jackman wrote:
> >> There are also the fault paths though; if the pages are nonpresent in
> >> the direct map for the duration of their life in the page cache (and I
> >> think they should be) then by the time we get to
> >> kvm_mmu_faultin_pfn_gmem() or kvm_gmem_fault_user_mapping() we lost the
> >> ability to zero them.
> >>
> >> My original answer for this was "that's fine, we'll use __GFP_ZERO
> >> (which will probably use the mermap under the hood)", but now I've
> >> realised there's a good reason we don't set __GFP_ZERO at the moment,
> >> namely that it's wasted if we end up doing kvm_gmem_populate()
> >
> > Eh, don't worry about the wasted cycles for populate().  The overhead of zeroing
> > a page is dwarfed by the overhead of adding (and in most cases, measuring) the
> > page.
> >
> > We (KVM folks) discussed this in the context of in-place conversions, and long
> > story short, the consensus is that shaving cycles by eliding the zeroing in the
> > host isn't worth the complexity.
>
> OK thanks, this is useful. Nonetheless because it leads to a less
> confusing dishgn, I think it still makes sense to just disallow
> __GFP_ZERO for the unmapped pages.
>
> (At least, at the page allocator level. We might want to allow it in
> address_space.gfp_mask or something and have filemap.c deal with it.
> But, overloading a GFP flag like this is yucky, if we need a flag for
> that I think it's likely neater to make it an AS_ flag or something).
>
> >> (Continued below...)
> >>
> >> > I'm a little bit uncomfortable this statement since it seems to say TDX
> >> > and SNP aren't taken care of. Would just like to discuss (for
> >> > a line of sight to SNP and TDX support):
> >>
> >> Are you saying we need NO_DIRECT_MAP support for TDX/SNP? I think that
> >> would be doable but what's the value?
> >
> > Hardening against consumption of shared memory?  Yes, the guest has explicitly
> > shared the memory so there are (very) reduced expectations around confidentiality
> > and integrity, but defense in depth and all that.
>
> Ah yeah, it did not occur to me that there was memory being set up via
> CoCo paths that is not encrypted. So yeah that makes perfect sense.
> Eventually we'll want to be able to lean on this to protect that shared
> memory against attacks by other VMs etc.
>
> > For me, the main thing is that I don't want to completely punt on the interaction
> > of the two things, and end up with an unworkable mess if there's ever a strong
> > reason for CoCo VMs to support NO_DIRECT_MAP.
>
> Yeah that makes sense.
>
> >> So that we can get a #PF instead of #MCE if we screw up?
> >
> > Note, SNP gets a #PF either way.
> >
> >> NOW, the thing I'm stuck on (again lol) is the patchset-fu. Here's all
> >> the parts we need, with dependencies indented:
> >>
> >> 0. efficient GUEST_MEMFD_FLAG_NO_DIRECT_MAP
> >>   1. AS_NO_DIRECT_MAP
> >>     2. ALLOC_UNMAPPED (formerly known as __GFP_UNMAPPED)
> >>       3. alloc_flags arg to the page allocator (I'm sneakily introducing this
> >>          in [1])
> >>       4. freetype_t
> >>   5. The mermap
> >>     6. The mm-local region
> >>
> >> I originally posted all of those in [0], except part 3. Doing all of
> >> that together in one series would be a bit too much though. Approaches I
> >> can see to avoid that:
> >>
> >> Approach X:
> >> - Do parts 1, 2 and 4 as a standalone series. The only beneficiary of
> >>   AS_NO_DIRECT_MAP would be secretmem.
> >> - Then another series that fills in 0, 5 and 6.
> >>
> >> Approach Y:
> >> - One series that does parts 0, 1, 5, and 6. AS_NO_DIRECT_MAP is
> >>   implemented by having filemap.c itself call folio_zap_direct_map(),
> >>   then guest_memfd.c zeroes it via the mermap. It works but it's really
> >>   slow.
> >> - Then another series that fills in parts 2 and 4, switches filemap.c
> >>   over from manual folio_zap_direct_map() to ALLOC_UNMAPPED, making
> >>   things fast.
> >>
> >> Approach X seems natural from a code progression perspective but leaves
> >> us with an interim phase where we have a bunch of complexity just to
> >> "optimise secretmem" which nobody cares about.
> >>
> >> Approach Y seems natural from a feature progression perspective but
> >> leaves us with an interim phase where we expensively zap a page, only to
> >> then immediately do this complex mermap dance to access it right
> >> afterwards.
> >>
> >> Any thoughts / other ideas? Personally I think I prefer X.
> >
> > I don't have preference between those options, mostly because I don't appreciate
> > the difference.  My overarching preference is to separate the mm/ work from the
> > guest_memfd as much as possible.  Beyond that, I probably don't care all that much?
>
> Cool thanks, shrugs are fine here.
>
> Main thing I'm trying to do here is generate some awareness that the
> decision is being made, so that I don't forge ahead with X and then have
> people going "ugh, why haven't you considered Y?" If nobody cares either
> way then nothing to worry about.

X seems fine to me and that seems to be the consensus here. And it seems moot if
Y relies upon mm stable branches which are not here yet :)

Cheers, Lorenzo
