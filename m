Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D017CF39
	for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 09:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710841668; cv=none; b=pNKhk385KguyRqx+HtDCtlPlVNiwJ2karwoIjgD2SCN6YuLsYSUacdXuSvN1to5vl8PsZyUe4u92ffsctBK1/LOQyI3pGQ+mTjvq/GHKnFF+XoSsPWqy7GjOWK6wsdMz7MdZT0IbfcdGM+cwJrMVrWt7223zkK3SLZhVJD0mykw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710841668; c=relaxed/simple;
	bh=tB59vQHrrWfNtXgOa+QXun/KGjIcXOV4U0cREwm/b3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVNaqUpHx3eTZWff4GVxs5uObTqvBkmvUAVvkIlk59lRkQPNdQMea41KlkJ+jds2Ar35DjrV9k9kIh8AguCvkVNhJ2rmawfVn3YIWPX52W9Jlj9Up7gj+P/fMnrYJztYbWTjvIZYvbfb/5UZPXBTS/vqU8J65i886htvuVKA/Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TdCD7nNS; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TdCD7nNS"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a46cca2a979so97509866b.3
        for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 02:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710841665; x=1711446465; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/HHhyDwGvRCaPjjju0RIkoEll4g5zmeDctgezA6gAMo=;
        b=TdCD7nNSONUUBXfTC6im0Ttg2QUIdh1WXqnqzvsTc2yGWLmxCFtjm5xWuApMBIp8Xu
         6/YcdCojjfhJvGutLKCCBNUS2rUd+buLSZRuQf2WMAT+hItWKHnRcMDbp8AqifKkqvya
         1c3dJi6x8zDxXktx0W4bgPdrKFY0R3GLiMVfi9AeDBvxF/88p06LYzKj/h9lA41RRfkN
         GeAPIn2uJ3IdAMZiBCBxyAjlnmgsj+DtWWj0ZsFaIxMUYwhlWse5rLGWQ08RDkZgCZsl
         bJ2QmK2vfrRROY6HWTKNXchnPwFcLgxxU0rr/IpT4c8/9ftnRu15/7gGRPLAdavyB2+8
         cLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710841665; x=1711446465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HHhyDwGvRCaPjjju0RIkoEll4g5zmeDctgezA6gAMo=;
        b=gWjk7ZzuTbTK1qSUMYYrB0G/ryvtOGNR6f/vV7tZVW8OT6NqRsFPzLrjUpELcuaZug
         rd+LGB3lnAQtIj6+HKMrc5cY/y0WSqGgy0QvGnjfv8c9P72XhNpWOAv+oViRMpkaB2e3
         KPWweRRe09js4mr2i1I1G0ZWjmnCUr6RIMWGPtxF+4eT9UO31kncEGCKZ/oStQ3NE3E5
         Of3lYpg8Lhdsw5CySk1nUdF1QCHZpfMMcqTnpqVE5hahXRzR68/rTsj2JiXK06Vu8qII
         1HzglhDF35Hs8ZGbgAhUzpQp2SReFiRIcXQzrLAfTxPuXF+ykyHwExPUa1ajTXGXjo51
         B76g==
X-Forwarded-Encrypted: i=1; AJvYcCXGf5N4PC/LCvzfMe+9tsWk7MAYDWj6G9mVylLN1PlXGOdRWPDf4PGM9u1DCpV40G4Fjg/lgyM+lhB54o3B4rb+AL0XuAyo
X-Gm-Message-State: AOJu0Ywp4Nwx5gVfQ94QvHSdHhW1fQgQxy0t1w2Y/0zlAHeFI7qwlyDV
	qj8lUJgCpglkM+hQsEJP9cd01Iw1ypa/sEjIcUlj3St9ed+7my1r0eBLHMT9DQ==
X-Google-Smtp-Source: AGHT+IF/puef8zhuN1727aKfDCay8r7kOdm59liIzFTyv3w/POjfIRKnd9fb5D53y8VNfxHFZefOTw==
X-Received: by 2002:a05:6402:448c:b0:568:1599:b854 with SMTP id er12-20020a056402448c00b005681599b854mr6246355edb.42.1710841665168;
        Tue, 19 Mar 2024 02:47:45 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id p11-20020a056402044b00b00568d325acf8sm2526799edw.20.2024.03.19.02.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 02:47:44 -0700 (PDT)
Date: Tue, 19 Mar 2024 09:47:40 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	keirf@google.com, linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <ZflfPDhZFufZdmp0@google.com>
References: <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com>
 <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <20240304132732963-0800.eberman@hu-eberman-lv.qualcomm.com>
 <4b0fd46a-cc4f-4cb7-9f6f-ce19a2d3064e@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b0fd46a-cc4f-4cb7-9f6f-ce19a2d3064e@redhat.com>

On Monday 04 Mar 2024 at 22:58:49 (+0100), David Hildenbrand wrote:
> On 04.03.24 22:43, Elliot Berman wrote:
> > On Mon, Mar 04, 2024 at 09:17:05PM +0100, David Hildenbrand wrote:
> > > On 04.03.24 20:04, Sean Christopherson wrote:
> > > > On Mon, Mar 04, 2024, Quentin Perret wrote:
> > > > > > As discussed in the sub-thread, that might still be required.
> > > > > > 
> > > > > > One could think about completely forbidding GUP on these mmap'ed
> > > > > > guest-memfds. But likely, there might be use cases in the future where you
> > > > > > want to use GUP on shared memory inside a guest_memfd.
> > > > > > 
> > > > > > (the iouring example I gave might currently not work because
> > > > > > FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
> > > > > > guest_memfd will likely not be detected as shmem; 8ac268436e6d contains some
> > > > > > details)
> > > > > 
> > > > > Perhaps it would be wise to start with GUP being forbidden if the
> > > > > current users do not need it (not sure if that is the case in Android,
> > > > > I'll check) ? We can always relax this constraint later when/if the
> > > > > use-cases arise, which is obviously much harder to do the other way
> > > > > around.
> > > > 
> > > > +1000.  At least on the KVM side, I would like to be as conservative as possible
> > > > when it comes to letting anything other than the guest access guest_memfd.
> > > 
> > > So we'll have to do it similar to any occurrences of "secretmem" in gup.c.
> > > We'll have to see how to marry KVM guest_memfd with core-mm code similar to
> > > e.g., folio_is_secretmem().
> > > 
> > > IIRC, we might not be able to de-reference the actual mapping because it
> > > could get free concurrently ...
> > > 
> > > That will then prohibit any kind of GUP access to these pages, including
> > > reading/writing for ptrace/debugging purposes, for core dumping purposes
> > > etc. But at least, you know that nobody was able to optain page references
> > > using GUP that might be used for reading/writing later.
> > 
> > Do you have any concerns to add to enum mapping_flags, AS_NOGUP, and
> > replacing folio_is_secretmem() with a test of this bit instead of
> > comparing the a_ops? I think it scales better.
> 
> The only concern I have are races, but let's look into the details:
> 
> In GUP-fast, we can essentially race with unmap of folios, munmap() of VMAs
> etc.
> 
> We had a similar discussion recently about possible races. It's documented
> in folio_fast_pin_allowed() regarding disabled IRQs and RCU grace periods.
> 
> "inodes and thus their mappings are freed under RCU, which means the mapping
> cannot be freed beneath us and thus we can safely dereference it."
> 
> So if we follow the same rules as folio_fast_pin_allowed(), we can
> de-reference folio->mapping, for example comparing mapping->a_ops.
> 
> [folio_is_secretmem should better follow the same approach]

Resurecting this discussion, I had discussions internally and as it
turns out Android makes extensive use of vhost/vsock when communicating
with guest VMs, which requires GUP. So, my bad, not supporting GUP for
the pKVM variant of guest_memfd is a bit of a non-starter, we'll need to
support it from the start. But again this should be a matter of 'simply'
having a dedicated KVM exit reason so hopefully it's not too bad.

Thanks,
Quentin
