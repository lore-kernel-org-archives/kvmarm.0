Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F0F285C83
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 08:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752742236; cv=none; b=qtX+OpP9FhyT9ROUFqMPFZcGQuqAhTmK4nzB0B1YDxOkLVLlXuk+0DXIQDoh3vvXnbTkqr9gs7wk0RjR+9v6q5nL77EGFbwCo3TwqUw6V1jR/VzYPfsTLJ7/+dJ5ZPjm03YM1jl3NZPEUH7PG1qrV6DSdaNPmp20wylpY9W8V90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752742236; c=relaxed/simple;
	bh=fx1JuSGB5ku3XgYVMYRTc/eMvpZ5Y30SL8s3qhNbUrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khiasI0hKYoQcmrkeIYI0qDgqEcuDt5+qPLnUC+QyJj4wEwH5lvPcJo2gI1yGfIdkguEc3cyDYA40GPr1kh366Te/PLpwp1ZGcQr32reMHpOTg09lcLw/q+Ck2Nb/Z9DOJn0S8+IFne2Y/81lPfpR/TWzhl0FHbh47MxsHGGeEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yKnspwQK; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yKnspwQK"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso277541cf.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 01:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752742234; x=1753347034; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fx1JuSGB5ku3XgYVMYRTc/eMvpZ5Y30SL8s3qhNbUrI=;
        b=yKnspwQKZNshXMI8DdaY4P1q0vkVGz0tAzDA6aHXPKI3F4owaY3MtiK5xwytiky28a
         wtu/qskORyjdq+FukUhyeXQ4fwdji7AHvdtY1DBD2o1hAO3j+bfpjgIHUDzXRyxqhOe/
         i5ZIzt9KTBBLJ3QI7D+6fYOVxI41Gf+gc3ZOlTTcR8zh1ZbGyS5LbOoLaJu8fHec5Gdj
         AfVnibCc+pZaowzXGrghacg+AbAUql6eNJfvy61PK6oxova6IHNw1du4bwRcNxovwAYB
         1mKW1v564PHtwL1Tg+loG19wVXSVpCQ/sDCsoFEFSN2ixCyAh9zaeq8+7iZR/ag/mil6
         lqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752742234; x=1753347034;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fx1JuSGB5ku3XgYVMYRTc/eMvpZ5Y30SL8s3qhNbUrI=;
        b=CX5T7CVwUj1tr6LyU7LR2XbOxCGx3bnKl8tJIviWMicNfuDh206GqLM6ICPWk10tnm
         mggWj6vlqfkQQBDNMKm7r1TeNmDroG/Giht3xn59+Lo1oO+6+ROiM5wob8yMyU4iNcet
         +pObPC2PlFFssa2oL6ew9TXIVzE219YP802CFqa+30JSsoepF58LMVB9SokGaT1oltI6
         PUPt2dgjEWva3pRTS7rQXVqcfiMme58w012zh2XyCoSmnPd9fVWVZ0mIxzAFbMNSwzNo
         UUTA2LPAfMgj+V8stbmjkfPMyPldHWxEBJUz4VxqRF5vYUFI4WI4PDDnxGJla5Upi5jE
         d4/A==
X-Forwarded-Encrypted: i=1; AJvYcCVzpVnZx2TKvIp0+yqG0CSnGq2HMZii1sqveH/wy+C2Ra0BPuA2KrD/noSbupk9Cb+k7t67JEY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdACkKD9dqYtRo5tBUfQsSPYaLCuySkZ1pMMsdk/eo8nPUr8OC
	TZ97f0Ylls2whwwnBtL6Aozt/8igouVIk1bbiNYiw9u58vJUcB33cQBDANeDTA/P5qAD4wH0uzh
	NGbWmWg83SOAZK7kvbl65z51N+WCZw6UYcQTHSlHs
X-Gm-Gg: ASbGncvM+Rdez3iDOmLyDImHfHbLpJSpTQfUaCBV8GNAugEjJSYp6MxVx9stiRUS6fI
	9IxfxqDZ5jibvSM6KzFP4rZJv5v2OCPrQqMDKnn8bJucqWahovBUKj3SScRqbAQLE/srlmlGX/N
	Uhd9JzCRZlQDv8Zyk1oPx/ILw/U0dcZCSzlGuachEYRMir1hUp35Lz7vRfcJZ5mfplCW2gI8Iwh
	oaEhfY=
X-Google-Smtp-Source: AGHT+IFJBjuZkaiMWobXRfRh9pmhDTYS+xIxMCNkviUrQydZTRd7jIJNkT2lW8gpa/i0jfk07s7YUC00WwCYYsXC4qM=
X-Received: by 2002:a05:622a:1f85:b0:4a9:d3e7:56bf with SMTP id
 d75a77b69052e-4aba4adbb61mr2533831cf.27.1752742233129; Thu, 17 Jul 2025
 01:50:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-5-tabba@google.com>
 <b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com> <diqzwm87fzfc.fsf@ackerleytng-ctop.c.googlers.com>
 <fef1d856-8c13-4d97-ba8b-f443edb9beac@intel.com>
In-Reply-To: <fef1d856-8c13-4d97-ba8b-f443edb9beac@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 17 Jul 2025 09:49:56 +0100
X-Gm-Features: Ac12FXxkRhY2UmJu3hO9xLioH89YY6t8CrSg4iy4xmUp0dV0rsQQHNL4_tw_xsk
Message-ID: <CA+EHjTzZH2NN31ZfTg0NX_o3dryqbkmR4s8Y47eFJ1TcO1kiDA@mail.gmail.com>
Subject: Re: [PATCH v14 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
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

Hi Xiaoyao,

On Thu, 17 Jul 2025 at 02:48, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/17/2025 8:12 AM, Ackerley Tng wrote:
> > Xiaoyao Li <xiaoyao.li@intel.com> writes:
> >
> >> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> >>> Introduce a new boolean member, supports_gmem, to kvm->arch.
> >>>
> >>> Previously, the has_private_mem boolean within kvm->arch was implicitly
> >>> used to indicate whether guest_memfd was supported for a KVM instance.
> >>> However, with the broader support for guest_memfd, it's not exclusively
> >>> for private or confidential memory. Therefore, it's necessary to
> >>> distinguish between a VM's general guest_memfd capabilities and its
> >>> support for private memory.
> >>>
> >>> This new supports_gmem member will now explicitly indicate guest_memfd
> >>> support for a given VM, allowing has_private_mem to represent only
> >>> support for private memory.
> >>>
> >>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> >>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> >>> Reviewed-by: Shivank Garg <shivankg@amd.com>
> >>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> >>> Co-developed-by: David Hildenbrand <david@redhat.com>
> >>> Signed-off-by: David Hildenbrand <david@redhat.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>
> >> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >>
> >> Btw, it seems that supports_gmem can be enabled for all the types of VM?
> >>
> >
> > For now, not really, because supports_gmem allows mmap support, and mmap
> > support enables KVM_MEMSLOT_GMEM_ONLY, and KVM_MEMSLOT_GMEM_ONLY will
> > mean that shared faults also get faulted from guest_memfd.
>
> No, mmap support is checked by kvm_arch_supports_gmem_mmap() which is
> independent to whether gmem is supported.

It is dependent on gmem support:

kvm_arch_supports_gmem_mmap(kvm) depends on
CONFIG_KVM_GMEM_SUPPORTS_MMAP, which in turn selects KVM_GMEM.


> > A TDX VM that wants to use guest_memfd for private memory and some other
> > backing memory for shared memory (let's call this use case "legacy CoCo
> > VMs") will not work if supports_gmem is just enabled for all types of
> > VMs, because then shared faults will also go to kvm_gmem_get_pfn().
>
> This is not what this patch does. Please go back read this patch.
>
> This patch sets kvm->arch.supports_gmem to true for
> KVM_X86_SNP_VM/tdx/KVM_X86_SW_PROTECTED_VM.
>
> Further in patch 14, it sets kvm->arch.supports_gmem for KVM_X86_DEFAULT_VM.
>
> After this series, supports_gmem remains false only for KVM_X86_SEV_VM
> and KVM_X86_SEV_ES_VM. And I don't see why cannot enable supports_gmem
> for them.

It's not that we can't, it's just that we had no reason to enable it.
When the time comes, it's just a matter of setting a boolean.

Thanks,
/fuad

> > This will be cleaned up when guest_memfd supports conversion
> > (guest_memfd stage 2). There, a TDX VM will have .supports_gmem = true.
> >
> > With guest_memfd stage-2 there will also be a
> > KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING.
> > KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaults to false, so for legacy
> > CoCo VMs, shared faults will go to the other non-guest_memfd memory
> > source that is configured in userspace_addr as before.
> >
> > With guest_memfd stage-2, KVM_MEMSLOT_GMEM_ONLY will direct all EPT
> > faults to kvm_gmem_get_pfn(), but KVM_MEMSLOT_GMEM_ONLY will only be
> > allowed if KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING is true. TDX VMs
> > wishing to use guest_memfd as the only source of memory for the guest
> > should set KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING to true before
> > creating the guest_memfd.
> >
> >> Even without mmap support, allow all the types of VM to create
> >> guest_memfd seems not something wrong. It's just that the guest_memfd
> >> allocated might not be used, e.g., for KVM_X86_DEFAULT_VM.
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> > p
>
