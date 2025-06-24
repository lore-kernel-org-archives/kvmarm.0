Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35BA291894
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766336; cv=none; b=Ifmuvs354Y3/4y50sRvG5B3odXqzmEell1YJMMUxv55p4fbjgHFWGk1pt/pS2yPa30OZMqxWOtLrMEqUirwK66t8RfAfGlbG5k/QqZIG8919CesdLqIP7COkrMWEt4PSLwxtXpxpO+RNDiG/VEf08xu9FFnMVM6IIC+1PFmTlX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766336; c=relaxed/simple;
	bh=uskxUuB6YcOdbnKLw5g8SxZDF6K9gBPzBY4kiD0YoM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BA/1klVWCj+f4ce8mTiUe58RKkivg8blJISJ6Lq1h7BJViV8ua8u6ZLWAJ7rpi2lCdJDKczFKwJfOYIHt+RttOi0HPXkUWgifdkCMABVjLcuTb4566f/oXQcvRObuo0BRZ5PUJ7ZAYOuOkvp41bMmzNvS8ySw79yYiXIHiEcqJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0fOWSGBW; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0fOWSGBW"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4a58ef58a38so146171cf.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 04:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750766333; x=1751371133; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zAkKzBT9Oi47cUQVFAqBKpPqCgRXO9n1TGoSSjrcRig=;
        b=0fOWSGBWY06h9mOk94afrFP/UOXMlxADJYHt2YwhviKOgwfmY2d7eGlGpsvf3Pmjd3
         +PQlnpVWqTf2lZteQ1arT4zepe3sR//F7jSPWv8BvvungcBRvCh5NJv0GSId8Wx1Ojsr
         NBfXEZ7WolBRKyOdb3ejDjdP0BZigJGxCdQlZAwduo8vlWYAU6NxxE7yXhe0LwKd0WMm
         s3UKJvCXSTnzJ8+3yieb3LlPS1jXOsBouoYIJDD5HqQbfGC+32RqA7ZtiYXgNLhCcxGc
         Vwpme0d3RTbRyQknWNRvZLq3jzp9XFxifLO6GQVRKxV0TatRtitnpmoOaHaRxEGGV5xy
         RPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750766333; x=1751371133;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAkKzBT9Oi47cUQVFAqBKpPqCgRXO9n1TGoSSjrcRig=;
        b=YKr/ANKApUvVZqisj46cec6sjMyidvtoBwmttfv7tAhpRZRx19+O8CnPsyL0fYo9Ag
         Zl8EkXOd/YAyyeJz6GVtMSiZDaZhCSN/d6aEwM24XpRpJXGamXHC0bDsOwwEUb98ZFYY
         cVWlNu7vnXO1fXqZa9JcZWjmKybVy5kZ1SoObeGsE/7C36PUY0fQsK/grZl+YquAKl5Q
         V9J+W+K9BFP+NfgG2ywXaj5coWt6QXGlaMCfkCbMDzbPE83ERHe0yjGyYP30tgvQAQKN
         d0fxPLambni2pxeQ60NYovLVCzi65TcvNH8OgPkIC+bbUe3obnENKVU1sn5Nnn4MXTtv
         m2BQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+cNJid6nUHfIOyRL9csPhdQtEQ9KhRzrnOSywS4++Td4Fu3YJPtFEIf8m43FG8MIDdTLoiII=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/JRaeWMRLetB2KLm7GIqEQ+Yvx+4mlNm1STpk3IyP1+gmDTt7
	9ZA9wDVPpeHZOPvoSBmtKv91mbxrvPUNwPEp38UU+zfz+K8pwQtMbygDPPgl33ehgs5+ANLVH3a
	VrOFceTio6siolMbZpGQDh5exqlNHlHJizo08aS4q
X-Gm-Gg: ASbGnctM9FzTcAX70nH0NZibPhf3uD0ZMMj1/tg59z1StZWC62a1EhA3y0BZaEaK2Wt
	aq1BSzqZY/mECR9CW3R5Z11lQcXzqcJzNKwu1UpPfZ/NXhIAAsfagChS7d0iaeWMdHsCcIFtkZm
	31xjDYq8cWhYsRM3Sc88u/0Qt4pJGyWD9/J7tW8IsfCqgWX+0ceb7rI0Kws3QMGaZoHpUXyw==
X-Google-Smtp-Source: AGHT+IFItWaOUEnQWqkCr0iMJsyetgQtFozSIRuqtaWWAUjmia/GJg3tAAHgb8EkJpgaZINqlaKB1Ek0kcCYr/IuJ+k=
X-Received: by 2002:a05:622a:1983:b0:4a7:26ba:bc2a with SMTP id
 d75a77b69052e-4a7b16ece18mr3011891cf.15.1750766332945; Tue, 24 Jun 2025
 04:58:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
 <CA+EHjTx2MUq98=j=5J+GwSJ1gd7ax-RrpS8WhEJg4Lk9_USUmA@mail.gmail.com>
 <372bbfa5-1869-4bf2-9c16-0b828cdb86f5@redhat.com> <CA+EHjTyxwdu5YhtZRcwb-iR7aaEq1beV+4VWSsv7-X2tDVBkrA@mail.gmail.com>
 <11b23ea3-cadd-442b-88d7-491bba99dabe@redhat.com>
In-Reply-To: <11b23ea3-cadd-442b-88d7-491bba99dabe@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 24 Jun 2025 12:58:16 +0100
X-Gm-Features: Ac12FXxIR7DmWnStmYreR1cKwqZETUwJ47Ed0F1LblD3zm6eL8DVUB8Z-pOLCcg
Message-ID: <CA+EHjTyginj74a+A58aAODZ72q9bye5Gm=pTxMmLHrqrRxaSww@mail.gmail.com>
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

On Tue, 24 Jun 2025 at 12:44, David Hildenbrand <david@redhat.com> wrote:
>
> On 24.06.25 12:25, Fuad Tabba wrote:
> > Hi David,
> >
> > On Tue, 24 Jun 2025 at 11:16, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 24.06.25 12:02, Fuad Tabba wrote:
> >>> Hi,
> >>>
> >>> Before I respin this, I thought I'd outline the planned changes for
> >>> V13, especially since it involves a lot of repainting. I hope that
> >>> by presenting this first, we could reduce the number of times I'll
> >>> need to respin it.
> >>>
> >>> In struct kvm_arch: add bool supports_gmem instead of renaming
> >>> has_private_mem
> >>>
> >>> The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED should be
> >>> called GUEST_MEMFD_FLAG_MMAP
> >>>
> >>> The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED should be
> >>> called KVM_MEMSLOT_SUPPORTS_GMEM_MMAP
> >>>
> >>> kvm_arch_supports_gmem_shared_mem() should be called
> >>> kvm_arch_supports_gmem_mmap()
> >>>
> >>> kvm_gmem_memslot_supports_shared() should be called
> >>> kvm_gmem_memslot_supports_mmap()
> >>>
> >>> kvm_gmem_fault_shared(struct vm_fault *vmf) should be called
> >>> kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> >>>
> >>> The capability KVM_CAP_GMEM_SHARED_MEM should be called
> >>> KVM_CAP_GMEM_MMAP
> >>>
> >>> The Kconfig CONFIG_KVM_GMEM_SHARED_MEM should be called
> >>> CONFIG_KVM_GMEM_SUPPORTS_MMAP
> >>
> >> Works for me.
> >>
> >>>
> >>> Also, what (unless you disagree) will stay the same as V12:
> >>>
> >>> Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM: Since private
> >>> implies gmem, and we will have additional flags for MMAP support
> >>
> >> Agreed.
> >>
> >>>
> >>> Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
> >>> CONFIG_KVM_GENERIC_GMEM_POPULATE
> >>
> >> Agreed.
> >>
> >>>
> >>> Rename  kvm_slot_can_be_private() to kvm_slot_has_gmem(): since
> >>> private does imply that it has gmem
> >>
> >> Right. It's a little more tricky in reality at least with this series:
> >> without in-place conversion, not all gmem can have private memory. But
> >> the places that check kvm_slot_can_be_private() likely only care about
> >> if this memslot is backed by gmem.
> >
> > Exactly. Reading the code, all the places that check
> > kvm_slot_can_be_private() are really checking whether the slot has
> > gmem. After this series, if a caller is interested in finding out
> > whether a slot can be private could achieve the same effect by
> > checking that a gmem slot doesn't support mmap (i.e.,
> > kvm_slot_has_gmem() && kvm_arch_supports_gmem_mmap() ). If that
> > happens, we can reintroduce kvm_slot_can_be_private() as such.
> >
> > Otherwise, I could keep it and already define it as so. What do you think?
> >
> >> Sean also raised a "kvm_is_memslot_gmem_only()", how did you end up
> >> calling that?
> >
> > Good point, I'd missed that. Isn't it true that
> > kvm_is_memslot_gmem_only() is synonymous (at least for now) with
> > kvm_gmem_memslot_supports_mmap()?
>
> Yes. I think having a simple kvm_is_memslot_gmem_only() helper might
> make fault handling code easier to read, though.

Ack. So, with that, at least the two of us are in agreement about what
needs to be done for V13. I'll wait until I hear from Sean and
potentially the others before I respin.

Thanks!
/fuad

> --
> Cheers,
>
> David / dhildenb
>
