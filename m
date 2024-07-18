Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7540E145332
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721322553; cv=none; b=sRNtowu9KDRZrR1lprEJtLihY9hBw94hoTLQZNV0j/ocIOSdaV8ELjNLSLVYwpAVFtKx+thwQv8iqY6opT4q9dXzhUjcSqHEBaHyCNEqffmuiyJyXawv41Ft8Uj09AwmMJLMvfMMvI6UlaAVy6wstWD+aVoi2Bto9uNmfeGKmZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721322553; c=relaxed/simple;
	bh=hfptMg5b01LvLxc2SG4Uz4PY1885pejHBHnSI3jHNo4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AttpQti12X5uXlsm4ZYVTAZqsZwUj3LvRSj06pv5wNxZ+dEmRM6bm/EIn0O+zsWucPdJX+12PhpNlFYIwrct5rR03ijpwNcwAogGC2GhAdDQusXXB3ghy7x2IkNPK0kZl9Oo1qyh/4ju4qazJ2xvhvFspjOZ++Cqxg+jAeL2hYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vxcl3wqW; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vxcl3wqW"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fc312a36f9so9985ad.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721322551; x=1721927351; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfptMg5b01LvLxc2SG4Uz4PY1885pejHBHnSI3jHNo4=;
        b=vxcl3wqWNeRPn4xwaLd2d1CP7c08cxxfaBM0+Gd8rhJ99TbK3GfRGWkqkDoswt4AZx
         FShFMmh2fgcV0ptSU9ztMx5BibmLXif2d5Vsuv7lA5t/8oMgXaKcX8j+D8v6KSAXUMwx
         d2b6Bm8MMuHWPeMQ7a71pxEFAp2QyaoKY7TuKcDk/E9mFSwHlsDaY8CGuguRD2hHfz6B
         snDrp76fQbNpxfBfVrGIMXWrunJrrJx56eC1lL5bJWVVcd7mmefLVeSphac/2bRr2Mgv
         dT60B/xDFJpXedbFqMuGdFZK2hHlxAW1jNNimCUq4I7LwUfzdlNI4lJZsGI5TVXsCooe
         kGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721322551; x=1721927351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hfptMg5b01LvLxc2SG4Uz4PY1885pejHBHnSI3jHNo4=;
        b=g55TnSgT0vV6s701dm0Hk63H/ElMlJCAOrJaeCXLqJqOM23Dam0pvZFHiaYPvZhGnS
         irRUnBNfqI3vmviFeRacjbYft43Gl2lfpg6Bv/+q7luVQ3hn9uicTjeFS/zaNRYvL0nw
         wp6XFio0cbNtShkrj4sDHLOdBhsIK4OtvG4BZIQaj+4hW9tIvV3iwIM1+qB38mDiGc8Y
         6fzM9FTahcMlLiMNMA1dYM2vWL10RtEvBcxhfzuiZt1uwc+9Th/09V6XSHQVkDaK8Zw+
         5/AbC8QiHpgwCfh+3qS0BDDxHYzO+8/vjE4JQonU1Gbzj0sWAk1oCKBcKNg06+XA+7Ce
         a4gA==
X-Forwarded-Encrypted: i=1; AJvYcCXvD5kSybn9aPn4kJoTULVPu5ciK918j8X++oJHUV1+mOWW49GpNkbVbH/CXfB/iAU+dSYgDi2XWfLrP62P6W01pZn0mJzB
X-Gm-Message-State: AOJu0YxV4OeshzLdXm8zwiYtu7F5bFo0s1+C024Hc7GBmcrvt9i+IRMz
	5PBm358dE2OYVy8NcxXTYWkd5Nr7mOgmNL8Cpkv1DM2kdK8fiTXNeejE7auKcmaNnz1GEa/GkRZ
	svkYtRLcF45CJOkl7dONPOxYOlOaT1qYlE/ox
X-Google-Smtp-Source: AGHT+IFyQOwgVWytrps02GnyGzCKWAzKQb9jdGG6O5HjYS2fonQnaQCgjBSaqq+ZRXTyamSyDlrVjFSIa0H9hip10Ho=
X-Received: by 2002:a17:903:183:b0:1f7:1c96:d2e8 with SMTP id
 d9443c01a7336-1fc5f58803emr2989145ad.10.1721322550399; Thu, 18 Jul 2024
 10:09:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
 <20240710234222.2333120-9-jthoughton@google.com> <DS0PR11MB6373C1BE8CF5E1BCC9F2365BDCA32@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB6373C1BE8CF5E1BCC9F2365BDCA32@DS0PR11MB6373.namprd11.prod.outlook.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 18 Jul 2024 10:08:33 -0700
Message-ID: <CADrL8HVDUG7OSN2ERmmiXeg8eT8D6edoSiqYKsnjAnVbhGAX9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 08/18] KVM: x86: Add KVM Userfault support
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 8:34=E2=80=AFAM Wang, Wei W <wei.w.wang@intel.com> =
wrote:
>
> On Thursday, July 11, 2024 7:42 AM, James Houghton wrote:
> > The first prong for enabling KVM Userfault support for x86 is to be abl=
e to
> > inform userspace of userfaults. We know when userfaults occurs when
> > fault->pfn comes back as KVM_PFN_ERR_FAULT, so in
> > kvm_mmu_prepare_memory_fault_exit(), simply check if fault->pfn is inde=
ed
> > KVM_PFN_ERR_FAULT. This means always setting fault->pfn to a known valu=
e (I
> > have chosen KVM_PFN_ERR_FAULT) before calling
> > kvm_mmu_prepare_memory_fault_exit().
> >
> > The next prong is to unmap pages that are newly userfault-enabled. Do t=
his in
> > kvm_arch_pre_set_memory_attributes().
>
> Why is there a need to unmap it?
> I think a userfault is triggered on a page during postcopy when its data =
has not yet
> been fetched from the source, that is, the page is never accessed by gues=
t on the
> destination and the page table leaf entry is empty.
>

You're right that it's not strictly necessary for implementing
post-copy. This just comes down to the UAPI we want: does
ATTRIBUTE_USERFAULT mean "KVM will be unable to access this memory;
any attempt to access it will generate a userfault" or does it mean
"accesses to never-accessed, non-prefaulted memory will generate a
userfault."

I think the former (i.e., the one implemented in this RFC) is slightly
clearer and slightly more useful.

Userfaultfd does the latter:
1. MAP_PRIVATE|MAP_ANONYMOUS + UFFDIO_REGISTER_MODE_MISSING: if
nothing is mapped (i.e., major page fault)
2. non-anonymous VMA + UFFDIO_REGISTER_MODE_MISSING: if the page cache
does not contain a page
3. MAP_SHARED + UFFDIO_REGISTER_MODE_MINOR: if the page cache
*contains* a page, but we got a fault anyway

But in all of these cases, we have a way to start getting userfaults
for already-accessed memory: for (1) and (3), MADV_DONTNEED, and for
(2), fallocate(FALLOC_FL_PUNCH_HOLE).

Even if we didn't have MADV_DONTNEED (as used to be the case with
HugeTLB), we can use PROT_NONE to prevent anyone from mapping anything
in between an mmap() and a UFFDIO_REGISTER. This has been useful for
me.

With KVM, we have neither of these tools (unless we include them here), AFA=
IA.
