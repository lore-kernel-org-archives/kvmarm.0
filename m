Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3D648F857
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816075; cv=pass; b=u9FaAsP41NlX9VCh0De/mdBAsK/CY1++svn0Gx/pEiMC8K4NmTQvHMSHi7mKtxJ1ZJvWR4KedF0GYFS182PEwmBeWywh6Qmgm/mKs8WXYUOGngVGW5CWQkMsyNDVCMD4c60sw8TM0ivs/yvTWGV6CAiIbnE+XbjfToI8WB7btYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816075; c=relaxed/simple;
	bh=EYFNAc3NwLAUZ6w5n0VWHZN4pBcB2B8Fyu8v+g7OFJM=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kRhQoRmGuFxTydAAMDtAR7+OitjUqECX6babRDr+n7u24ftOntxfNPTqjTeTCNY07j9hyDMLxUJNYOlKs3TgPRqufBXQtrfqPHKG7F2kT7+2YnOweKfnhTlUL5F3YhwLaOGlouYjOaVNqYrCt16wg+qnqtKfO01mmknyLI36GwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=blKVVB9A; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="blKVVB9A"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-917a4b69a79so26359486d6.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 07:41:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791816072; cv=none;
        d=google.com; s=arc-20260327;
        b=h7I6BdtNx4dyzrtNwD+FTK/+8sWbsA8UVmliSHHONwweBJr6hlHhdBlLBHdLn5ZdAh
         woMzTSxM/d5Oo5mT087aXaO+mxumbesIBBN0METyGObEVz8AeNTIozrBBJq/Rp+Zia6+
         BCO2bquJdV1kA12I9yZmghufNkTe6c1wu3Cb30OyY1zvULzxM+iC/Gtr0AJWqSHc6SrU
         TiYHtY4bWUk4v5m5io4QdeNwXORUIuhlLTvpCWB4uRbj+FL0GO214OMWkHA5gKTSlDxK
         SjChtclIWGBTP0YV1InjCZFNZry1oj2LwnfmhdvB7I2l2OB8AEDhzpb0gjw4J9/gzr/k
         slGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=EYFNAc3NwLAUZ6w5n0VWHZN4pBcB2B8Fyu8v+g7OFJM=;
        fh=eQbO1jkB2kryL1hSMV+vp1/uq5j9DgEWsmqae53Cccc=;
        b=ZBqUWc7iAr+e8XjSRXPIPAvq99oq04EXKpNfYPuOB3a6oB9JHzsbkwEfnJk6/455o5
         d4q9BIK2DSWdzr91lpuAlqNQm+Z3ivtjczM5B28RZOzZO4Tk70Uw04zHS6OZTQVrBfYS
         jmVM1DZ7kX39xKhPbQnf5ciZ7geh77K3Kavf1vdrGAA8xQ2BCyJbVmjvWnbJrPjLHbZq
         JBIdpTawbBFNzalYfhtFbesEfuFfndmdJqChQXNQs7JEHX0WP/kRMNi5DJmrcOB7bCVN
         8kiyUW4m+ldb9cfKv69Xell4uQrJbz3B3X2VwEFClumcdHFYcoyEjaO+fXWlLYGUppfG
         mYMg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791816072; x=1792420872; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EYFNAc3NwLAUZ6w5n0VWHZN4pBcB2B8Fyu8v+g7OFJM=;
        b=blKVVB9AESUn4kaaRv+A16anbDuhWv31NZV32CO1JVJSUIXEmSQkrwK6DbABdvd3/T
         vGE+MIrcCIzHOwPbHNwG9Cbox+WOxmwzkj46MDpHGuv3FtqfhXeoxazRgthlc3rA5fXV
         6gFgLJLf3L6LT/B2OFyC5R7Wk82PYhAkl6r1lmsSYSetlmHaOqdSvi/9sCilY9cGQ1B3
         jETDmUWH+Ir0woZnZ2uOI5me2cs/Ii5MMG4wRx65r7RXbDOld34GMPEeISfxSWEVAhee
         JGIfx/y3tWcaVvO6VjdFJ1cFxsEeIqZEzAlkp9+m/FO+NYiyDryqdwKmoeXPIqBuDK+E
         9TGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791816072; x=1792420872;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EYFNAc3NwLAUZ6w5n0VWHZN4pBcB2B8Fyu8v+g7OFJM=;
        b=xLa7CAkGIg7r5WNqhlnTrntTn7rYCRqMxGfzkRUOpVXXIG5TdJeolWHp0QyKLD4XxE
         4h4plUicOo7BFVukHPvP/Nj2UCbk2nLhgDKb31TwNCfMaFtuCVIiQehcfyxyxYd6H1LF
         ov7anW+HtsGkUkAe83GylJbJCw6Cz3+x7G3riU+QLPQ7IOKKTNPGtyPR6ffuvVth/0Py
         HifgbJlwCxDGL12Lh6D60Bj3eYfKtk0KCCNLzb4oYLv0zxz2NSfGeqwCfs38wqyI7p1m
         Sjf+sy0g2wUY8Dg3A/B1+Pt3JR/HahrnBHAhj6jTT/zITjI/YmmLDmWGvaPNBEbfIrup
         pE5w==
X-Forwarded-Encrypted: i=1; AKwUvBxqGemBmhXLUjOhtsBlPGfTyfDsuo+y966Mm7T7e3r91ihGblWYjdCoPS2RYvfIFixMDs0aEDg=@lists.linux.dev
X-Gm-Message-State: AFq9FYKZr2nF3c4gUfpYjCVIPJXcMEPZ7H7ns9ZSW5YhPXdEl74eDqS5
	rNjGick1SL6YhIf9XefXqM2GJbhA5GzM7qB5Vel8GyGXC+YIUTGHt/N1du68USeBKPqkCwpH3nW
	/8yZQIQJpR1kpYlQcWIzWjVDCeQndwHrGqCWs3ROv
X-Gm-Gg: AYBFou3l1PvxMYOheLA4vaeup9xpNR4rh4vnCknIIdYbLKwapOd92db96UpmAxKXLFO
	HtGcKZKcU7UBKlPvRn5g3wcXVzABimEZha6HEsg5e9TINixgk5qsfIDCDVNwF5Je9VyUVAbDP1H
	u2RB7i8093qI0jvXk2ChA7wNHZ7cWSiElWicIvW0j4ZYRZwYdf3z8KVe7i6+4CVjPJdferMsIbz
	9ZKWDqd96XjQyOvpXXulFW7EwZmJUCF+Y4/ZIyhE2VcVtSpJkjuqKQcIQofOF0gI1KA7JFYsLXN
	eThcfBxtVfdBjhn2jilZpc6tcZ7Tk9o0jMzBnoD3AGyV0Q7qffErmbuOkzwagBG/SskIRbkCgez
	vLh29EjecJgxnNQlLvpsh
X-Received: by 2002:a05:620a:2993:b0:93e:9508:8360 with SMTP id
 af79cd13be357-93ebd1dd868mr1604359685a.27.1791816071132; Mon, 12 Oct 2026
 07:41:11 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Oct 2026 07:41:10 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Oct 2026 07:41:10 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261012095800.50250-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com>
 <yq5ald8680t2.fsf@kernel.org> <20261012095800.50250-1-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 07:41:10 -0700
X-Gm-Features: AclHuK-nc_uqkVW8eVTYkrPq_RPqOo6SBs5ABhlJBuD_rVj9OrJECoL16jCBpAc
Message-ID: <CAEvNRgF1hMz+4ivH6WhsEOLTJGOegYO9AYK6OByYysPp_nVJ=g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
To: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, tarunsahu@google.com
Cc: David Woodhouse <dwmw2@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fred Griffoul <griffoul@gmail.com> writes:

> On Sat, Oct 10, 2026, Aneesh Kumar K.V wrote:
>> I have been working on something similar for confidential computing use
>> cases. There is likely some overlap between this series and what I posted
>> at [1].
>>
>> I have not reviewed this series in detail yet, but I will compare the two
>> approaches and identify what can be shared between the use cases. Please
>> let me know how you would like to proceed.
>>
>> [1] https://lore.kernel.org/all/20261010072504.536230-1-aneesh.kumar@kernel.org/
>
> Thanks for the pointer. I read your series, and Ackerley's resource fd
> RFC that it builds on. The use cases differ, but the interfaces overlap,
> and it would be good to agree on the common parts.
>
> All three series add a flag and an fd to KVM_CREATE_GUEST_MEMFD. I
> think one resource_fd is enough, with guest_memfd picking the backend
> from the kind of file it gets. I am happy to drop provider_fd for
> Ackerley's flag and field. We also find the provider from the file in
> three different ways; I would like us to pick one, preferably without
> a registry.
>

David brought up many good points at the LPC discussion, I need to wrap
my head around your model. I'll look closely at Fred and David's
versions this week.

These thoughts are just from reading this email, hope to get more
clarification :)

> The main constraint on our side is that the provider stays the authority
> on which frame backs which page:

Wait, is there some magic done to make struct pages represent different
frames, as in PFNs? In your model, the struct page <=> PFN mapping
doesn't stay constant?

> it moves pages between VMs

Do multiple VMs map the same physical memory at the same time, or is it
a move like below?

I'm thinking that if guest_memfd wraps your provider, then your provider
can issue a revocation to guest_memfd (ctrl-f for
kvm_gmem_provider_revoke in [1]) on the move source guest_memfd inode,
then wait for an allocation request from the move target guest_memfd
inode.

[1] https://lpc.events/event/20/contributions/2551/attachments/2047/4693/lpc-2026-gmem-other-backends.pdf

> and has to
> survive a live update.

guest_memfd is going to support preservation [2]. Tarun's series just
preserves memory from guest_memfd's default provider (buddy allocator)
now. For your provider, I imagine the preservation flow would preserve
whatever metadata in guest_memfd (like the attributes in the maple tree)
and then go on to notify the provider to preserve some range of PFNs (or
folios). Your provider would then basically do nothing, since those PFNs
already survive a live update.

[2] https://lore.kernel.org/all/20260728121138.1103610-1-tarunsahu@google.com/

> What would not work for us is guest_memfd
> becoming the primary manager of PFN memory, as Ackerley suggests. Your
> get_pfn() leaves VFIO as the authority for the BAR, so I think we agree
> there.
>
> You refuse dma-buf exports while guest_memfd is attached. That is
> roughly what the memory provider interface is for: one owner, several
> users, and one revoke that reaches all of them. A BAR exposed as a
> provider file could be mapped by both guest_memfd and iommufd.
>

Will read the rest of this series and reply again :)

> I plan to change the revoke anyway, because iommufd must not leave the
> device with a hole: it should replace mappings in place instead of
> unmapping and remapping. Would that fit your case? I suspect it depends
> on locking, for example whether you have to revoke while holding
> memory_lock.
>
> Shared/private state and the conversion hooks would stay in
> guest_memfd and the arch code, as in your series.
>
> Does that sound reasonable? Ackerley, David, any thoughts?
>
> Thanks,
> Fred
