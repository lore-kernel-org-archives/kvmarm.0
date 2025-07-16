Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4E1288C15
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 11:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752663621; cv=none; b=Yjp4aktYNRiXiaygrNYfjSMqkOPIYoxidnF0qQUhpmDQi3k/K6Mg5ZvEK7hfr9aYpiSvnibLhGBWV74O/9ZtD4jlG35Vfu40woq7ruq36Ro9F9vRJbCyHIQlD2wDeTemKT4Ol8aA9YXiXk3TXUaRI35at3hVABTsDqCprZ6Hl1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752663621; c=relaxed/simple;
	bh=WEL3KqF/GpMex8AfuvzJH2hVcfhrkUtP29xcoofDR0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sDFJjAK2Ztd3k4ys1O2MfgOJXqbEh/qs87Y/gjlWtC32HAGWrRdaZdGGsAOi327h4xAS85wh7Oai4eEO5DdlhtyKhelGFt4/U8eGXF2VbhKzP8QCKzlPBq1WvYsMbzM5w7655ovO7wsMlxic10XQIQQS2U8+PxidwwzAfBc1Hu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=we+8r3L/; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="we+8r3L/"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso159971cf.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 04:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752663618; x=1753268418; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WEL3KqF/GpMex8AfuvzJH2hVcfhrkUtP29xcoofDR0M=;
        b=we+8r3L/L9FpxSzHBXNXmN1RNl8/9VkxvG/jsvdRO8U6c/OXibK6rCOnx8tR/vbQNO
         n4VFf/+g2COqKIDqXU7iSs7AEFFB40o/lTnVec+GdQwlC4QV7ogZLqGZJgM0PBymh6h9
         Z+AFSuyK3DdnUyytGiy7wRDUD0kjWeEUsKVWP/+2v1WVp0/PhxGo8vhS6UcTDA4NwYsI
         0PtLRifsrjFxLJV3NdIDFlwtw6noJZfPLXLJM1WWGAXmz6+QDgqUYszXNUtJN6XBPmn6
         amQGa2Jvuhx4Sti7k1eztjr0gB3oqdn+LstLmgulj9X7NCjmKzLRCmS2akxAM8ShJXlS
         +0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752663618; x=1753268418;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WEL3KqF/GpMex8AfuvzJH2hVcfhrkUtP29xcoofDR0M=;
        b=EJ5EOOBFI71/kxdwb6byKzQ6p2GV6CdcHRlyATGHZnm+nWK7U9+1ERfx8ihYkuAG5h
         jkbXimdutVYYWTVsmQA0aRkwyqIoxon7pkFRqT4/6DdvKl1VR/5T1wAUhaSqSmykbLeY
         +iEWiyoQmHQp+Djf4F2RE9ZdV2KGWUbh3GO+0RYvGZv8cXtzntySc8khPd6aAFOWR7at
         Z3oO4jTZ9/fhVedGTEAAAXEHmrwi3gqrS/diWWcTwIsztir/DKpX9EEM4pywtGQgnHlO
         NLO+paugk5BJ0RPKueNrfz3rTJMWAGrva8emL6dBjyK716APqMwU8M8HKpcisY2pJ6Ox
         eLfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcdBk/Gp251jXHm9bLplHa/f28MoKh+9WMOJjpB/8y7H+btvHWglM4eYRp9Bojvyrdliow6pE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxA6WcEqtgUj4u6A32K4ofi53rt0vkmL/IpjLDRn6sqq4z0H7lk
	p1qJ3jmrgUhIZlzcAv1HDhYcjWxwIzy2YO7InuDkZS7VKFwwhHqlxgvRKWNnZka0TcrxF4xW9gj
	wQOyXyC6S72Gr875APmbzYpts3Ouuy6zQqwltsceO
X-Gm-Gg: ASbGnctfBO9U7mAyfzWVeA+HG/LKol+ChwKH/55K0V/RCfdZmDKPHn6YZrSOjE+xL7t
	1RscFLg/+U7h7TOqFfICHJ6zvf2Y4NCTgAlV1YRvCtPobEiZ57y1fKH/MUl9V5fckxRy3eTwenk
	ggfIQmMZr6CZ2vre9J8UH8TAoUwaSbcX18m/+oq5RVmuLIc3xY8zH9Fcj3wAtmTbubPI+U3oAqk
	S+1Hzk4wQMIxI9G1ya64/8IObso+p3nnVgW
X-Google-Smtp-Source: AGHT+IGm95NUdK5ftP1jftdordV3iftsesNlsHHVUEP+SmlFPVMmNXMBat3YpfN3rnpVHPoTr0gIhtAtDGvUQcp/clk=
X-Received: by 2002:a05:622a:8317:b0:4a9:d263:d983 with SMTP id
 d75a77b69052e-4ab954af75emr2016961cf.22.1752663617597; Wed, 16 Jul 2025
 04:00:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-10-tabba@google.com>
 <eb9d39b4-0de8-4abb-b0f7-7180dc1aaee5@intel.com> <CA+EHjTw8Pezyut+pjpRyT9R5ZWvjOZUes27SHJAEeygCOV_HQA@mail.gmail.com>
 <b7feea89-be2d-44a9-b116-fb07d16e3bd3@redhat.com>
In-Reply-To: <b7feea89-be2d-44a9-b116-fb07d16e3bd3@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 11:59:39 +0100
X-Gm-Features: Ac12FXx9zd9JVkXqY3lez4L9ptxfAF4QCJ83KzlvcvcQhQV6SV5GBIjlcQUn8Vo
Message-ID: <CA+EHjTzCRvg130oZFy6xRYr4WTw0afo3sjBSZgLf_4XEe8iBTQ@mail.gmail.com>
Subject: Re: [PATCH v14 09/21] KVM: guest_memfd: Track guest_memfd mmap
 support in memslot
To: David Hildenbrand <david@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 16 Jul 2025 at 11:31, David Hildenbrand <david@redhat.com> wrote:
>
> On 16.07.25 10:21, Fuad Tabba wrote:
> > Hi Xiaoyao,
> >
> > On Wed, 16 Jul 2025 at 07:11, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>
> >> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> >>> Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
> >>> memslot->flags. This flag tracks when a guest_memfd-backed memory slot
> >>> supports host userspace mmap operations. It's strictly for KVM's
> >>> internal use.
> >>
> >> I would expect some clarification of why naming it with
> >> KVM_MEMSLOT_GMEM_ONLY, not something like KVM_MEMSLOT_GMEM_MMAP_ENABLED
> >>
> >> There was a patch to check the userspace_addr of the memslot refers to
> >> the same memory as guest memfd[1], but that patch was dropped. Without
> >> the background that when guest memfd is mmapable, userspace doesn't need
> >> to provide separate memory via userspace_addr, it's hard to understand
> >> and accept the name of GMEM_ONLY.
> >
> > The commit message could have clarified this a bit more. Regarding the
> > rationale for the naming, there have been various threads and live
> > discussions in the biweekly guest_memfd meeting . Instead of rehashing
> > the discussion here, I can refer you to a couple [1, 2].
>
> Maybe clarify here:
>
> "Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
> memslot->flags. This flag tracks when a guest_memfd-backed memory slot
> supports host userspace mmap operations, which implies that all memory,
> not just private memory for CoCo VMs, is consumed through guest_memfd:
> "gmem only"
>
> And add a pointer to the list discussion.

Ack.

Thanks,
/fuad

> --
> Cheers,
>
> David / dhildenb
>
