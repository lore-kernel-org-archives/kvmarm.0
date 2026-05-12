Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C072D7DEA
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778601196; cv=none; b=dznq8PXJn2PDBse0ln+XjFuqGXqPaPFU03OvQqVCVGdYkSuNGwQ3vY9oMvUi31YWtaJkFjBZagI96S1Adedrm9aD14QIbld5JSh8rUd9aePVWvvMVpXHBZoH1uosI1JH5Q3zAMWhYg4RtuH4xhzkNWiis2rOzwlKTmvxjJTKH8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778601196; c=relaxed/simple;
	bh=WgBwFfkUAGnYzD2OlUsYs9T3doLgjxOO4xn97PfaOo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d5ImQy5fpguQgPliLAft7gHIJt0qNTm53/hEPOJ/tUghNJk9J5jNjKKNh7yZQ0ww2nb3cGetukldf3Hu6Kx84gykPb20aHXDw9MT8hWdT1uL1sfQ/BqpGhfpBc8HLRO9oAYWx6KViCGwaN6dUcdPfT6doX64kZEburNb17AppUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wb41/bmf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wb41/bmf"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ba6fe41283so65942945ad.1
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 08:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778601194; x=1779205994; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dzzb2jJ1jA7GZ4TPN3DcMZIn6KxUjt0dYZxw4XPowVU=;
        b=wb41/bmfRneGlvOww7N25voWDplhSqZVDVfBf7iPr/sxG4T1jd2gm4912igyWzb55X
         KxdygUud4CaqUnD1IAJ89XEMPGmEW5w0q+9GQVteJJOY5b/Rg5a/2CuTd2GoO9htAeX/
         ZAWK+Dd++TjrOXV5d7XNP8Fn56Jq5oNmhwmagqk28rGch+OT/MSBrzNFQ+iY0p7znwHk
         cgHLehYM9LrDvmGby2KLzdY3gq10tzq7/xURx6PgiQLo77OSkeLtT2hARuX0oTQuf2ZB
         b7xiNklsQZqEipHGVNWWGDVMEIIjFw2WOxaFtE7zt0GqJdr2LyIUQR4V0WswxUtfQs25
         0xtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778601194; x=1779205994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dzzb2jJ1jA7GZ4TPN3DcMZIn6KxUjt0dYZxw4XPowVU=;
        b=LHzJMVk5fRjFuikKNFr7xCGy1FOsc2wmjMAyOol4U3nPSofwJtkaAXGxb7PNy25wkd
         r3s3znmxIzIMbaiAQR6MlI2/jqNm90GFUCcnuC/YBh2x07fCVWdYIHOpkbMGG31GYmCn
         94uO9a1+nI5vtRoT9PKRqJwuO4eGTGdC7p2BFrCYB52z8E3VLSNMIuV13ruK6OHqGmDb
         t66UkolD64VwD3bTmNgly894/kA3duvr/bYIBGHIDaRrwIVQbR6g9ioq7fYJ1vvmVhqj
         MZC1F4xs+0USzSJBnAcq0mKiufULmvbpa9orUW3tQqC8UajjUDYjTFANJ2DBmDvBGKJr
         f8Hg==
X-Forwarded-Encrypted: i=1; AFNElJ8zFvS7r689QAYZtRryfbA6FtSabZnB7H2+gVoT4UnJVpME82V78gMGYkaJ81/TKzau4nvrUCA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbsxjE8EbSODfcWzmKFF8Lpqn4Vidmmz0hDkAmgDFSef/EBSqx
	FiAI2Prqe6BH173hjYrVfIpRcULh7Min1vklh7V34LYyGe69INw5SVDu50wHcyATC2c09IDjftN
	UKU4c2Q==
X-Received: from plhq5.prod.google.com ([2002:a17:903:11c5:b0:2bc:a589:91c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b03:b0:2b0:b290:f2f4
 with SMTP id d9443c01a7336-2ba79be43f8mr289028985ad.32.1778601193243; Tue, 12
 May 2026 08:53:13 -0700 (PDT)
Date: Tue, 12 May 2026 08:53:12 -0700
In-Reply-To: <c17d864a-42fc-afbe-345e-c728e2735d0c@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-25-seanjc@google.com>
 <0064952b-048c-455d-ad89-e27e5cb82591@linux.dev> <aeJkCGwsrRmuBikT@google.com>
 <c17d864a-42fc-afbe-345e-c728e2735d0c@huawei.com>
Message-ID: <agNM6KSlsFjOaSUv@google.com>
Subject: Re: [PATCH v17 24/24] KVM: selftests: Add guest_memfd testcase to
 fault-in on !mmap()'d memory
From: Sean Christopherson <seanjc@google.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 12, 2026, Zenghui Yu wrote:
> Hi Sean,
> 
> On 2026/4/18 0:47, Sean Christopherson wrote:
> > 
> > Does this fix things for you?  If so, I'll send a proper patch.
> > 
> > diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> > index ec7644aae999..c682bda722f9 100644
> > --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> > +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> > @@ -510,9 +510,15 @@ static void test_guest_memfd_guest(void)
> >                     "Default VM type should support INIT_SHARED, supported flags = 0x%x",
> >                     vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
> >  
> > +       /*
> > +        * Use the guest's page size for all accesses, e.g. to avoid having to
> > +        * map multiple pages, but create the guest_memfd instance with the max
> > +        * of the host or guest page size, as KVM requires gmem files to be
> > +        * aligned to the host page size.
> > +        */
> >         size = vm->page_size;
> > -       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |
> > -                                            GUEST_MEMFD_FLAG_INIT_SHARED);
> > +       fd = vm_create_guest_memfd(vm, max(size, page_size), GUEST_MEMFD_FLAG_MMAP |
> > +                                                            GUEST_MEMFD_FLAG_INIT_SHARED);
> >         vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
> >  
> >         mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> 
> This results in another failure at
> 
> |	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size,
> NULL, fd, 0);

Gah, the memslot size also needs to be a multiple of the host page size.  I
actually tested on a CONFIG_ARM64_64K_PAGES=y kernel this time, patch incoming...

Thanks!
