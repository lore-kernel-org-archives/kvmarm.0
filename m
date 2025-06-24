Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20981246BAC
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 10:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760783; cv=none; b=k8nAkx4KAw1/qq+MRrPVaOEav08BsDGrqwA/Pk6UzBRsXdOQMJVYsp8mDrz2Qzs3m/GJzq8G2qXW75LfdwWFMm3PqCsVxLLFyFemYTgWDDPbjGtew72k5lQ4wpkEqkQIIpDA+nfIjehPg+Hj2q0Nwi8bcPEhsCFfHuucsD79uT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760783; c=relaxed/simple;
	bh=nn4SuqpphmFRlZUcHn3smREQdX+2aWW06JOZrPoskiM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I9kJRORZCfHdYrizqlnuJunfh/JfnemSOn4E/5wC/hxgjLnZxsHSBLNit2YAeaJJ5Gdzww0dKwNLlPJ0X+95bZwKnRymzTYtTL0QEmmEdQjLvbmCjoNAHvrqM3PSspds/BXVONfh+fShJoaApuBmUDVGlG1OZCu5OcjvF7jBYZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K3d5ktm5; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K3d5ktm5"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4a5ac8fae12so374101cf.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 03:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750760781; x=1751365581; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uaKxjTr2Dy9UkQ7LbzgGPeXHUMCK6nT4emjWQgyE2Gc=;
        b=K3d5ktm5q73e9sdewsqY9Xp4uiVyC3hYaTLCKfBqap4TkP8gi++Wg0BxB1M4K3wqFh
         tU0EFuKIFiJP+i1J0NaP+B2EtGvbHEY0jNHQSMdhbz3os63y2IxYQYD3YZwKfY+bRkkO
         y/tYnOSdihJXA/gRR59VDSWpp0959vMu3a6hb2An90E3K9gD9kQHyt2+OBk+wQZxA9oZ
         Gkjt8iTXDiZE0ADb07qV4AmLKcFS0RCGPO/YlceZq4TCze0pkKQOEVF8sslgNHuNUXiu
         zzZrhluMb5A7+Hh3tc1/v1rOu5ksT5IBDdChg/AB3inb5R9TMO4w9Bs6PjVGiD7v3z+C
         9gBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750760781; x=1751365581;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uaKxjTr2Dy9UkQ7LbzgGPeXHUMCK6nT4emjWQgyE2Gc=;
        b=jjbMky+eXUMIDEElbBLbRB2aBj+MBh8x90LjHXiE/6iy7swwG6TQ/5U2OeqlDlFvML
         3KsokkHG7qavLE3vYU3Q3rOoARDz3yO9xGGge1gWvp8deNJtAgnxta4BHhf+LjW6v18E
         zoY86GVtQBx+c0VgZr12ef9yT5b15bucV/1KS97M8tRynG76vDmKhgBqx2+15arCGWCQ
         L587zuFGZxYsonS7wMRhkb0Eh6zcWDbE9unJhXHJydoNG4J11sHiIGFGwwHA0Yi6bWrM
         d4GimjM1aeCwI4Rhi4U1oEPGV9VzBvXojuvoVt36ZE0z1V3Y3s1IroS7duAfrwyiUaIK
         B8ew==
X-Forwarded-Encrypted: i=1; AJvYcCVwA6AGQmsV80S2X2fct0OTBTaOt5JLF23LFmrk+oyc8WQpiRJlfUGi1iMLQzQKXC/rjo6Dnco=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7mMbjyIx/zjOcJVpRaVYVtX3/diKBTX8Szsl66XklmNiTRN2X
	DjvLmgYm8peMcY499hCdTZj7ErQiTUvHzZDXze+YAj47MqfY8JhRoYNXIhYPU8EjB9/1ZyhJRgR
	8XA56h+4I6BvKFVwFAQXEBAFwygMUBINBJ/CTvN/S
X-Gm-Gg: ASbGncvRsdB1MCqG8I/RIjCV8uGBAqezCZzmaXGiALLpZ1/AJA3RMy4m+bzGDs4HXqC
	GO/tMzDGl6jmtTg68MOuFM9WZsB40IBLwPXLPJ+W6AOZ6vD1d/HOIMcu7G0dy09cX/j8wMwyN+V
	h6TtaGd2Ya4sXJtLTIeFvb2+Ssh9nA8gTaHcO2Z5phUfkxEv3ERp/7No/ZSorCM3rTs+hYCEvQ
X-Google-Smtp-Source: AGHT+IG7dvHk9kjVfPdNY3CE09+ALlTOMcwHOWFBP9WRHrrMEvmf41kIS7uFXbaypXOKaIBbz/ZGTrFP7IhVhX4+5X4=
X-Received: by 2002:ac8:5ac2:0:b0:4a6:f9d2:b538 with SMTP id
 d75a77b69052e-4a7af677e68mr3881551cf.28.1750760780317; Tue, 24 Jun 2025
 03:26:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
 <CA+EHjTx2MUq98=j=5J+GwSJ1gd7ax-RrpS8WhEJg4Lk9_USUmA@mail.gmail.com> <372bbfa5-1869-4bf2-9c16-0b828cdb86f5@redhat.com>
In-Reply-To: <372bbfa5-1869-4bf2-9c16-0b828cdb86f5@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 24 Jun 2025 11:25:43 +0100
X-Gm-Features: Ac12FXzp2QR2bGdUaTCduQbIoXQgEK3ZRaRgh2VOnlt_lf7nCklaqTOJp7VscJk
Message-ID: <CA+EHjTyxwdu5YhtZRcwb-iR7aaEq1beV+4VWSsv7-X2tDVBkrA@mail.gmail.com>
Subject: Re: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

Hi David,

On Tue, 24 Jun 2025 at 11:16, David Hildenbrand <david@redhat.com> wrote:
>
> On 24.06.25 12:02, Fuad Tabba wrote:
> > Hi,
> >
> > Before I respin this, I thought I'd outline the planned changes for
> > V13, especially since it involves a lot of repainting. I hope that
> > by presenting this first, we could reduce the number of times I'll
> > need to respin it.
> >
> > In struct kvm_arch: add bool supports_gmem instead of renaming
> > has_private_mem
> >
> > The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED should be
> > called GUEST_MEMFD_FLAG_MMAP
> >
> > The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED should be
> > called KVM_MEMSLOT_SUPPORTS_GMEM_MMAP
> >
> > kvm_arch_supports_gmem_shared_mem() should be called
> > kvm_arch_supports_gmem_mmap()
> >
> > kvm_gmem_memslot_supports_shared() should be called
> > kvm_gmem_memslot_supports_mmap()
> >
> > kvm_gmem_fault_shared(struct vm_fault *vmf) should be called
> > kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> >
> > The capability KVM_CAP_GMEM_SHARED_MEM should be called
> > KVM_CAP_GMEM_MMAP
> >
> > The Kconfig CONFIG_KVM_GMEM_SHARED_MEM should be called
> > CONFIG_KVM_GMEM_SUPPORTS_MMAP
>
> Works for me.
>
> >
> > Also, what (unless you disagree) will stay the same as V12:
> >
> > Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM: Since private
> > implies gmem, and we will have additional flags for MMAP support
>
> Agreed.
>
> >
> > Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
> > CONFIG_KVM_GENERIC_GMEM_POPULATE
>
> Agreed.
>
> >
> > Rename  kvm_slot_can_be_private() to kvm_slot_has_gmem(): since
> > private does imply that it has gmem
>
> Right. It's a little more tricky in reality at least with this series:
> without in-place conversion, not all gmem can have private memory. But
> the places that check kvm_slot_can_be_private() likely only care about
> if this memslot is backed by gmem.

Exactly. Reading the code, all the places that check
kvm_slot_can_be_private() are really checking whether the slot has
gmem. After this series, if a caller is interested in finding out
whether a slot can be private could achieve the same effect by
checking that a gmem slot doesn't support mmap (i.e.,
kvm_slot_has_gmem() && kvm_arch_supports_gmem_mmap() ). If that
happens, we can reintroduce kvm_slot_can_be_private() as such.

Otherwise, I could keep it and already define it as so. What do you think?

> Sean also raised a "kvm_is_memslot_gmem_only()", how did you end up
> calling that?

Good point, I'd missed that. Isn't it true that
kvm_is_memslot_gmem_only() is synonymous (at least for now) with
kvm_gmem_memslot_supports_mmap()?
Thanks,
/fuad

> --
> Cheers,
>
> David / dhildenb
>
