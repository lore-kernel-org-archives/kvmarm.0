Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72765146910
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 12:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709124294; cv=none; b=omPVffN7hvjttRiGHfigfRmHAI63gMHmC2LLvrPeG2wYn2lW3XnGqR8XNvDk1xqix5GqnjxtHwEZn7oJ9Ibv4Zb9y+aAQSaIUydqNY0sF7IVCf9tDOt1QpOfFBjOBHDZULNMv15Z/O0QsA+fe4tAnzKsN81/IRM0Xz6TbwGHh98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709124294; c=relaxed/simple;
	bh=pXKCZJwJ4+arWlV96KQRxdkQ6IU4sCiGwJyzykK8u3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUKIip0pi0pbYw/cUni3P1FKVsjg4pmNpGW+wdnYPXlXuGUCrIS7f1pDdE99WbU6cjtrEIhV87hCsXcaGbCd6qeRjtnfXbfDXeE5dG0cbennTmYJ0A9F60WNxGuGTRcjKMP4pLKd9EaUYhj/9yYbBe1eY4bFsAnpHaQicPA3G+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hh8TqLzv; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hh8TqLzv"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-55a5e7fa471so7404860a12.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 04:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709124291; x=1709729091; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XKO94nMA1YtYYpk+BNP1fuJKlQZLG/9h2W7iUjre2sY=;
        b=Hh8TqLzvO9guGO4tiC1PV5w9fwLqsaTRA6M46r/D+ar4bJx0e5tZE8ehhoLIwnL7Po
         G6huUPy4p2UX0luMcUyvJa+nGxIQCu6PF5Doa/zGQZ9zSffWUsTULZLCRUGdJvPVycD2
         22lNi6ptgOJGyUxD8k/1YWHTRGcrHGW65SQSRfpsCL8b5Xi4IGP+gUtla/2jfNUVwaHZ
         2jakhtdmqAT9AYWEG6XECBXz5x0Eje7YoMAkn3F0+yDtMzXOLSbSxeJli4zAOZRCy+SH
         KtnBHKM6XiLeWBLq8+3OTtDmSR1rq67l5rD0jH7Z5aAtckZfrtc5YJ4xlexIZFQqmBOm
         N56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709124291; x=1709729091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XKO94nMA1YtYYpk+BNP1fuJKlQZLG/9h2W7iUjre2sY=;
        b=F8gUEmz6hetnUYPQw8bF+4mYaRT1/3L3LHdhTK4jj+3BfDshx16OQyhZLA/850RcFe
         2kw1P9++cIgS5Wxxen2p4Pyj/VgMiaWBFoqIFu/kDkOl707XB4i6JM/ZyuERFkbYwj/t
         jJEM4DXurkywIT7uI3t2joVYvgtuiFQwHDYYI3zC1GBilP5KHMPMMC/USUEWXD9i2gc6
         HgC2R8nNoEAiTGB1YJ+4ccPkCyelB3q8yL/Uca2ATQ0kr/SUVypIdMvCK/662KHLOAHJ
         hM/AvjN8knZ+hi4CUqVpSvm9F+T06KCwoqJkeBZdPDU8asY/aZzE1BC/EAD0kcY1x2Iw
         dngA==
X-Forwarded-Encrypted: i=1; AJvYcCWsTS1HQmuHQJ0rvrajGcJyv53rMW8mJgNmemy4KuxT54mDx+TezBj3E/Qb0/ODPbvn8VOoQ2stpznRFbQ2C4g7NJ1pz6O9
X-Gm-Message-State: AOJu0YyG3H8uK5dinB7iNE1HOhWYOMGKsIBedw+0n0QAmQvIQQa3X8V2
	SvuWr9MJxns2pMFStbP3BPQkiu8c9IquHW7e2psJ4w8aWF7P/A7YsPidJFRS8g==
X-Google-Smtp-Source: AGHT+IFCLZvk2INpPsiNJeuTsGQcBnfWl23OygqTc+LqjELiOS3oXuIg0YTp/dWBUHQaq/Li8DlVuw==
X-Received: by 2002:a17:907:209a:b0:a3f:7e2:84cc with SMTP id pv26-20020a170907209a00b00a3f07e284ccmr10084717ejb.6.1709124290580;
        Wed, 28 Feb 2024 04:44:50 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id hu21-20020a170907a09500b00a42eb167492sm1826966ejc.116.2024.02.28.04.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 04:44:50 -0800 (PST)
Date: Wed, 28 Feb 2024 12:44:47 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
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
Message-ID: <Zd8qvwQ05xBDXEkp@google.com>
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>

On Wednesday 28 Feb 2024 at 12:11:30 (+0100), David Hildenbrand wrote:
> On 28.02.24 11:48, Quentin Perret wrote:
> > On Tuesday 27 Feb 2024 at 15:59:37 (+0100), David Hildenbrand wrote:
> > > > 
> > > > Ah, this was something I hadn't thought about. I think both Fuad and I
> > > > need to update our series to check the refcount rather than mapcount
> > > > (kvm_is_gmem_mapped for Fuad, gunyah_folio_lend_safe for me).
> > > 
> > > An alternative might be !folio_mapped() && !folio_maybe_dma_pinned(). But
> > > checking for any unexpected references might be better (there are still some
> > > GUP users that don't use FOLL_PIN).
> > 
> > As a non-mm person I'm not sure to understand to consequences of holding
> > a GUP pin to a page that is not covered by any VMA. The absence of VMAs
> > imply that userspace cannot access the page right? Presumably the kernel
> > can't be coerced into accessing that page either? Is that correct?
> 
> Simple example: register the page using an iouring fixed buffer, then unmap
> the VMA. iouring now has the page pinned and can read/write it using an
> address in the kernel vitual address space (direct map).
> 
> Then, you can happily make the kernel read/write that page using iouring,
> even though no VMA still covers/maps that page.

Makes sense, and yes that would be a major bug if we let that happen,
thanks for the explanation.

> [...]
> 
> > > Instead of
> > > 
> > > 1) Converting a page to private only if there are no unexpected
> > >     references (no mappings, GUP pins, ...) and no VMAs covering it where
> > >     we could fault it in later
> > > 2) Disallowing mmap when the range would contain any private page
> > > 3) Handling races between mmap and page conversion
> > 
> > The one thing that makes the second option cleaner from a userspace
> > perspective (IMO) is that the conversion to private is happening lazily
> > during guest faults. So whether or not an mmapped page can indeed be
> > accessed from userspace will be entirely undeterministic as it depends
> > on the guest faulting pattern which userspace is entirely unaware of.
> > Elliot's suggestion would prevent spurious crashes caused by that
> > somewhat odd behaviour, though arguably sane userspace software
> > shouldn't be doing that to start with.
> 
> The last sentence is the important one. User space should not access that
> memory. If it does, it gets a slap on the hand. Because it should not access
> that memory.
> 
> We might even be able to export to user space which pages are currently
> accessible and which ones not (e.g., pagemap), although it would be racy as
> long as the VM is running and can trigger a conversion.
> 
> > 
> > To add a layer of paint to the shed, the usage of SIGBUS for
> > something that is really a permission access problem doesn't feel
> 
> SIGBUS stands for "BUS error (bad memory access)."
> 
> Which makes sense, if you try accessing something that can no longer be
> accessed. It's now inaccessible. Even if it is temporarily.
> 
> Just like a page with an MCE error. Swapin errors. Etc. You cannot access
> it.
> 
> It might be a permission problem on the pKVM side, but it's not the
> traditional "permission problem" as in mprotect() and friends. You cannot
> resolve that permission problem yourself. It's a higher entity that turned
> that memory inaccessible.

Well that's where I'm not sure to agree. Userspace can, in fact, get
back all of that memory by simply killing the protected VM. With the
approach suggested here, the guestmem pages are entirely accessible to
the host until they are attached to a running protected VM which
triggers the protection. It is very much userspace saying "I promise not
to touch these pages from now on" when it does that, in a way that I
personally find very comparable to the mprotect case. It is not some
other entity that pulls the carpet from under userspace's feet, it is
userspace being inconsistent with itself that causes the issue here, and
that's why SIGBUS feels kinda wrong as it tends to be used to report
external errors of some sort.

> > appropriate. Allocating memory via guestmem and donating that to a
> > protected guest is a way for userspace to voluntarily relinquish access
> > permissions to the memory it allocated. So a userspace process violating
> > that could, IMO, reasonably expect a SEGV instead of SIGBUS. By the
> > point that signal would be sent, the page would have been accounted
> > against that userspace process, so not sure the paging examples that
> > were discussed earlier are exactly comparable. To illustrate that
> > differently, given that pKVM and Gunyah use MMU-based protection, there
> > is nothing architecturally that prevents a guest from sharing a page
> > back with Linux as RO.
> 
> Sure, then allow page faults that allow for reads and give a signal on write
> faults.
> 
> In the scenario, it even makes more sense to not constantly require new
> mmap's from user space just to access a now-shared page.
> 
> > Note that we don't currently support this, so I
> > don't want to conflate this use case, but that hopefully makes it a
> > little more obvious that this is a "there is a page, but you don't
> > currently have the permission to access it" problem rather than "sorry
> > but we ran out of pages" problem.
> 
> We could user other signals, at least as the semantics are clear and it's
> documented. Maybe SIGSEGV would be warranted.
> 
> I consider that a minor detail, though.
>
> Requiring mmap()/munmap() dances just to access a page that is now shared
> from user space sounds a bit suboptimal. But I don't know all the details of
> the user space implementation.

Agreed, if we could save having to mmap() each page that gets shared
back that would be a nice performance optimization.

> "mmap() the whole thing once and only access what you are supposed to
> access" sounds reasonable to me. If you don't play by the rules, you get a
> signal.

"... you get a signal, or maybe you don't". But yes I understand your
point, and as per the above there are real benefits to this approach so
why not.

What do we expect userspace to do when a page goes from shared back to
being guest-private, because e.g. the guest decides to unshare? Use
munmap() on that page? Or perhaps an madvise() call of some sort? Note
that this will be needed when starting a guest as well, as userspace
needs to copy the guest payload in the guestmem file prior to starting
the protected VM.

Thanks,
Quentin
