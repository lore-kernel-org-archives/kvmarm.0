Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B99219ED
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 09:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708938260; cv=none; b=gDxMfeRE2k+D/u5durJPN7O5GYlMxKM0r2yD/eJXiZ+ot6pSetbaTAwJ1IPPu+bk87hEEJc5b4DwYrElzfGTRIJg7TZzhmpfk//Z8Lkzp8LktWm6Tf8Jlx41WbQP3z03jZ8664Lluqkwtg4squhhisMqv5kEBhfhtu77LuSYW8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708938260; c=relaxed/simple;
	bh=yEZyECskv2rcwMp+c/P2OzQkmGTKaUReF3Ro5PzNU5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cNwItUUMejPGsVAe+agT00ubRIX22d8Ex0OsfmakphBFo6jnFF8VDbLN3cpxwT/j6eyq6cb1X6lfZ2JjraP+/5qIXYJOEfnQAdP2oqx3oJPOarUk/CuVh/jSm9Sd9OqUTGxM8yurFiwTtgRENERLvRplWYKVdVkb10+q7/cBNks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R6Y+debA; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R6Y+debA"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-470455b5352so336345137.2
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 01:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708938257; x=1709543057; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEZyECskv2rcwMp+c/P2OzQkmGTKaUReF3Ro5PzNU5M=;
        b=R6Y+debALlVPYPKQQ5p9rE9e46uLAvLzP9+O9Lp42n5Mkd9B8u47Hs+4PpXbUj5gux
         rX+34mvpKD3Z6ionk+rRvrkbwCJSDPJW9akF8KYs4afXIEELbM8ilwYDJrl48tNpEfay
         Mp6L96RsmfZePqHIGssLyr/OWabHjQWuxNEdthkGLGEoaqJzrcJ1KJtotzzOwImvv3ce
         oFfUb6QzleiVhXTS8hlWX9INM79bQvF5+/NIQKY0HbVBapqjXHK926AetPtroeF8LMRH
         KSbKnC6G+Ie17pcQcUVLJ1PrUf9FEmoPf1M0f9qAARMd6yyH9mS271SQqKSGeBzKnpVB
         UosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708938257; x=1709543057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEZyECskv2rcwMp+c/P2OzQkmGTKaUReF3Ro5PzNU5M=;
        b=XuBPcl1iJusuWhY8FT1sa2u6lSTXgpG7+6vAnIrdbRT4AI393Pw4H7mfJXz71IBm1g
         zxbdYrjU5EaQMwmsLoBrfyIbtMHjenJJsmlUdFd3vFByJGGQUCRoJ70/1rK8Mmvi0VcR
         dBPHZLu1/1iTcIEVnol18bhAcym9nwljSXYOPRMsIm2slrSCOQsTefa3phRJsQBcAVOb
         x2eoQMFmn5Ixj6ScMdPgQodThb5ms5A43QEpotwezUngXo84IzpLqpjj8DrWnQXbGUhF
         OZb7dPwSAkOb/8IsKC6kqprF1A9QJBys6/mqqmDzyvoxoXzXdJ1mUBIpMZeXX5EEjIZG
         a+vg==
X-Forwarded-Encrypted: i=1; AJvYcCUs9tGB1gKXpvo8iJG+Xgl/AFifgITWapwqxRvci31Ob8eJu6UUP60uZOeZe9R5PMSor+9f9unlNJNdXEtAFJwSNJq05iju
X-Gm-Message-State: AOJu0YzSuLz/GWskF2QRfVpYx7/Xd4yqw9pWe6hWXagJ8YQ3UJlgNbiY
	y/RLuFlpnI3nFOpnvCoCrCWkGjbDi3t8xO4C3aIAV2Rl4P3u7m5dwCYOl5i5r0KST5/GcTzFhAT
	L2iYOCgraTO7W38a5XieZSdLv3sQJXlmDtRqW
X-Google-Smtp-Source: AGHT+IGEsNplZutJPQCE2XWM33H2//sA0tBNvMZ/8xQCoXrQdHcbFYE1YTM2S71oQAfgwcpsit9Bxd7++DH7yVsIWtY=
X-Received: by 2002:a67:ad02:0:b0:470:3adf:3ce2 with SMTP id
 t2-20020a67ad02000000b004703adf3ce2mr4465713vsl.10.1708938257027; Mon, 26 Feb
 2024 01:04:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
In-Reply-To: <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Feb 2024 09:03:40 +0000
Message-ID: <CA+EHjTwOx930n7Ja6yXZKCmVJ1t_tcccgGpA36o4JigYKEcVAQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Elliot,

On Thu, Feb 22, 2024 at 11:44=E2=80=AFPM Elliot Berman <quic_eberman@quicin=
c.com> wrote:
>
> On Thu, Feb 22, 2024 at 04:10:21PM +0000, Fuad Tabba wrote:
> > This series adds restricted mmap() support to guest_memfd [1], as
> > well as support guest_memfd on pKVM/arm64.
> >
> > We haven't started using this in Android yet, but we aim to move
> > away from anonymous memory to guest_memfd once we have the
> > necessary support merged upstream. Others (e.g., Gunyah [8]) are
> > also looking into guest_memfd for similar reasons as us.
>
> I'm especially interested to see if we can factor out much of the common
> implementation bits between KVM and Gunyah. In principle, we're doing
> same thing: the difference is the exact mechanics to interact with the
> hypervisor which (I think) could be easily extracted into an ops
> structure.

I agree. We should share and reuse as much code as possible. I'll sync
with you before the V2 of this series.

> [...]
>
> > In addition to general feedback, we would like feedback on how we
> > handle mmap() and faulting-in guest pages at the host (KVM: Add
> > restricted support for mapping guest_memfd by the host).
> >
> > We don't enforce the invariant that only memory shared with the
> > host can be mapped by the host userspace in
> > file_operations::mmap(), but in vm_operations_struct:fault(). On
> > vm_operations_struct::fault(), we check whether the page is
> > shared with the host. If not, we deliver a SIGBUS to the current
> > task. The reason for enforcing this at fault() is that mmap()
> > does not elevate the pagecount(); it's the faulting in of the
> > page which does. Even if we were to check at mmap() whether an
> > address can be mapped, we would still need to check again on
> > fault(), since between mmap() and fault() the status of the page
> > can change.
> >
> > This creates the situation where access to successfully mmap()'d
> > memory might SIGBUS at page fault. There is precedence for
> > similar behavior in the kernel I believe, with MADV_HWPOISON and
> > the hugetlbfs cgroups controller, which could SIGBUS at page
> > fault time depending on the accounting limit.
>
> I added a test: folio_mmapped() [1] which checks if there's a vma
> covering the corresponding offset into the guest_memfd. I use this
> test before trying to make page private to guest and I've been able to
> ensure that userspace can't even mmap() private guest memory. If I try
> to make memory private, I can test that it's not mmapped and not allow
> memory to become private. In my testing so far, this is enough to
> prevent SIGBUS from happening.
>
> This test probably should be moved outside Gunyah specific code, and was
> looking for maintainer to suggest the right home for it :)
>
> [1]: https://lore.kernel.org/all/20240222-gunyah-v17-20-1e9da6763d38@quic=
inc.com/

Let's see what the mm-folks think about this [*].

Thanks!
/fuad

[*] https://lore.kernel.org/all/ZdfoR3nCEP3HTtm1@casper.infradead.org/


> >
> > Another pKVM specific aspect we would like feedback on, is how to
> > handle memory mapped by the host being unshared by a guest. The
> > approach we've taken is that on an unshare call from the guest,
> > the host userspace is notified that the memory has been unshared,
> > in order to allow it to unmap it and mark it as PRIVATE as
> > acknowledgment. If the host does not unmap the memory, the
> > unshare call issued by the guest fails, which the guest is
> > informed about on return.
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/20231105163040.14904-1-pbonzini@redhat.=
com/
> >
> > [2] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstrea=
m/pkvm-core
> >
> > [3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guest=
mem-6.8-rfc-v1
> >
> > [4] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/gue=
stmem-6.8
> >
> > [5] Protected KVM on arm64 (slides)
> > https://static.sched.com/hosted_files/kvmforum2022/88/KVM%20forum%20202=
2%20-%20pKVM%20deep%20dive.pdf
> >
> > [6] Protected KVM on arm64 (video)
> > https://www.youtube.com/watch?v=3D9npebeVFbFw
> >
> > [7] Supporting guest private memory in Protected KVM on Android (presen=
tation)
> > https://lpc.events/event/17/contributions/1487/
> >
> > [8] Drivers for Gunyah (patch series)
> > https://lore.kernel.org/all/20240109-gunyah-v16-0-634904bf4ce9@quicinc.=
com/
>
> As of 5 min ago when I send this, there's a v17:
> https://lore.kernel.org/all/20240222-gunyah-v17-0-1e9da6763d38@quicinc.co=
m/
>
> Thanks,
> Elliot
>
