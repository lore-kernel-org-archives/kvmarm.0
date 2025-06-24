Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420F53D3B8
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 10:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750759415; cv=none; b=LpF9o92rTA8F20FXyUXAHIxkoSujMgZQYmhgRGOzM/8lR2+dnVGnHq9DaSVAbSK8+KJji3bZAb9S2lOIJn3g/s/YrfvY7olwT5FfKft2oFBKxfLKN952/zyA+Dzi4OKQts75bDLkOd1B0J3Vgox6EBJWSrn1fsdjwj0tZnFweXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750759415; c=relaxed/simple;
	bh=KsoThbVuC03tvHvNTihda3ndo5AaudSgCC/2MFyVqhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TdQMpLILkuO1y5cMfPbb/4uV1ZBxdhN2aA6jIZqQW/vf/a3rKy+E4jpWotXOUcC0K7nDS2e29goo+xJiAnEZ5E4S5wquHq1AmLhfCPq1EPKE6LxsJ6iQQYoQRKGOE6tatcWDdId0/uhs1FXQKsxtmtWUoI8reF3mu/+rBQ+Rcts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nl1PQKCW; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nl1PQKCW"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-47e9fea29easo285571cf.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 03:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750759413; x=1751364213; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gMW0MMECznJialVQa7oe4n9ne+tvTZu0qfqDN/JkXfs=;
        b=nl1PQKCWnMPj8aUOpOJGGQGe6lXIA8JY/bItoNjzYtOBX3PQAGZnNs6QLeGCqIE+3P
         ItZbmZrRw5lwdtoy/pG2RGcwrX62Mcqjnee9IMsLdJTnKk9LaN2YXerX77rov2aMZ+Ez
         DrXgAC2FAsYLc5mF1BsCL1jx0Ous9vl8ECL1IwXSNOcxmBgG/I81lTtqR0cCyEbi1W8i
         4giRQwMawFumLFaTCA9TPnDSD5i15nTUeRnOwOfPfyOvU81WmpWl1kpYITnNAG9vBaSM
         K48CJJ+LJEjcagVHX5rg8Wo9hccDdIZQ6eKeUcWwpOLFOJ6f6HwQz1Kt8SuD2lZvh2U0
         3vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750759413; x=1751364213;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMW0MMECznJialVQa7oe4n9ne+tvTZu0qfqDN/JkXfs=;
        b=LgKcQ+S6uwGYpOk5CUJMukrBopANOZ3VcIaykRqQu57F4O9SYG5GnNmJeTt8v/gMJW
         wNd7SBAuXdJ3Iy+B4XuF4UEyygfl+YXLQ6JwxfkcqE9j6yqhxUiYLUETdwld285MrrF0
         54q2IYunvFDTY2Z7S8oS4G/F2C10lWs/205Ysh/GbRaKGcxQFFeYqJaKsv13tsuiZN9A
         SJCA9MctgfzYDt+wJoHPJSRP3AE2PemDGutl+TinZDD4GN157mo15abEZIybYxIhlLTl
         xKoc+3PV0dDodEVrtP0/y8HOPkI/N10CX4t8kBRPh9+bVQiAN3w+mEaDxnBWnBIizo0w
         vJ5w==
X-Forwarded-Encrypted: i=1; AJvYcCW5ynO3DCvlIp7E1Qy+OtJFAOE4MNVRDcfmH5kcgxxfJOB6nU3cUoJpdmEBZkKoxMzhxnU2cro=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeXuFgPXy6PwAdNAGB/jxAv6/HABI+tHbTwWWZ1YmpQV1I6VzR
	rW7TCEfDIc6ywPYZDha/gscWj8LzcNv1vWfKoxPalHZvqX9962UqBlVOfMoku78HuaHrpGgsJqu
	mh6CMaKVkUoQ81U/lNgOPK94NsflbYimtUykzEUAz
X-Gm-Gg: ASbGnctpFMIR5gVNYSEXdSjYKPb0lm2/3qbgrQUB/B4LYG//nGw+AHpzPq8Wdh3qCoo
	utHthkMOx+6bD5OHTNnp61C6bm8kq09fme0CiY3VGeruuann1iFNdzD0ZOAG5kVBFYPhavHEP2q
	4RBW41SrlRs0qL9DLzI4X70y0gFoKut/2R6qDjwKW6IY+Gj5vxQenfiz4eGp66lWyQCqy5gGlf
X-Google-Smtp-Source: AGHT+IHT3LkZ35Y5UJEPwLhq2j0BxxOtoLWYptCtFgQuare8SnS0uBLCBrYuYOhTXMb3sDYFZdMfbm/xeJe2fFK+8kI=
X-Received: by 2002:a05:622a:c3:b0:494:763e:d971 with SMTP id
 d75a77b69052e-4a7b171e2aemr2408971cf.23.1750759412503; Tue, 24 Jun 2025
 03:03:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
In-Reply-To: <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 24 Jun 2025 11:02:56 +0100
X-Gm-Features: Ac12FXyaJ6fQiRli6N-G9Ic58vssGb1-G3P5sN6L-3mpP1G-97NTKumDYqIFAvc
Message-ID: <CA+EHjTx2MUq98=j=5J+GwSJ1gd7ax-RrpS8WhEJg4Lk9_USUmA@mail.gmail.com>
Subject: Re: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
To: David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi,

Before I respin this, I thought I'd outline the planned changes for
V13, especially since it involves a lot of repainting. I hope that by
presenting this first, we could reduce the number of times I'll need
to respin it.

    In struct kvm_arch: add bool supports_gmem instead of renaming
has_private_mem

    The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED should be
called GUEST_MEMFD_FLAG_MMAP

    The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED should
be called KVM_MEMSLOT_SUPPORTS_GMEM_MMAP

    kvm_arch_supports_gmem_shared_mem() should be called
kvm_arch_supports_gmem_mmap()

    kvm_gmem_memslot_supports_shared() should be called
kvm_gmem_memslot_supports_mmap()

    kvm_gmem_fault_shared(struct vm_fault *vmf) should be called
kvm_gmem_fault_user_mapping(struct vm_fault *vmf)

    The capability KVM_CAP_GMEM_SHARED_MEM should be called KVM_CAP_GMEM_MMAP

    The Kconfig CONFIG_KVM_GMEM_SHARED_MEM should be called
CONFIG_KVM_GMEM_SUPPORTS_MMAP

Also, what (unless you disagree) will stay the same as V12:

    Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM: Since private
implies gmem, and we will have additional flags for MMAP support

    Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE

    Rename  kvm_slot_can_be_private() to kvm_slot_has_gmem(): since
private does imply that it has gmem

Thanks,
/fuad



On Thu, 12 Jun 2025 at 18:39, David Hildenbrand <david@redhat.com> wrote:
>
> On 11.06.25 15:33, Fuad Tabba wrote:
> > Main changes since v11 [1]:
> > - Addressed various points of feedback from the last revision.
> > - Rebased on Linux 6.16-rc1.
>
> Nit: In case you have to resend, it might be worth changing the subject
> s/software protected/non-CoCo/ like you did in patch #12.
>
> --
> Cheers,
>
> David / dhildenb
>
