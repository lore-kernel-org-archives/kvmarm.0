Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7587EF0A
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 23:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706659124; cv=none; b=gzFppVHno7bmr6vP7U8UMtqI8JjVUXpqsLv5i0clv2QbTARr4Otl98zDv90ZOI6yfMt+O8AstjpIV+ocy2ky0gJjUADjRacN6m0x6k27zOg2FgYDhgRORb9KoRyaO4pZQEK1RrMN1rwTr1She9D6AQcITEGe0OS/meg0IJs05zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706659124; c=relaxed/simple;
	bh=mqasyqEC+6fRhw5/p/l75otWoegYgzBu1zpsELr1ZTo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HDdPW4OLKaNvOf60y05iIIQpyRtCXCRi52b/VMc7towlrOhW68lGwSbgio3nzmBWoXpkg+/5/L3FXcHwL+1KzEymV88EtJsVXMVFTYKPqYr/D50cMg0APlK7F2PchoKp5nDjR6EY4xarvmfQ9Iktz5SDx4MThCKGQ1UIHaBhYAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WX3TNOoJ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WX3TNOoJ"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d8d08f9454so37555ad.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 15:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706659122; x=1707263922; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1u062nTR9tMZBKXAMw2gk2T6BiQu6ezEgEfg4ndl1uI=;
        b=WX3TNOoJGbAWc5k1iLpMdwwUnxvopx8uoJ8KM43+A56ck45+7BduSkRq9+D2EodJ05
         9HM9bdhK09tvWV7ZQ1z5S8gvFQgNdHkVR3Dvo5UzC9wTlmZ6psOLqsGv7Cuwj+0dPNLD
         o5aBnv2Sf+DRfKIgTXzJ6sEl1ZWZHiyQCTjCHnhZSJECIGTn1Bvwzmpe4stpJgaRIN2A
         FzeoJYi0r+R62QyflJC1HRrHkERybkchUKjG2BS1LU68q13aB/pfrD+esFckKg9oHUZK
         Y4bp7DKcJmhZfhcLEb7pFimZlkFcnAi+kVkD9gOxBqJWQYhnqMeav2U1STVmysmmPM6g
         qDHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706659122; x=1707263922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1u062nTR9tMZBKXAMw2gk2T6BiQu6ezEgEfg4ndl1uI=;
        b=oTskkcuGCwF5TEVLwUKSbdfFIbUIKx//QRcqkZFf0W2neg0H1oBSaS3IM2Lu6hVUKY
         XtelKSf8sDrqcI/Dx37EHXgInm+lj1NJ+0ERB2jCyKN3Om3/PJcjdlO26g7HYQwx4494
         AnVexVQK2ZEJEtMHFdnnyl4tyzaAIOBcJ0+X5KngsG/Agm+6J/nwA1iztJdAaPgnfGiI
         BfMSmnAfUtZ3BjKW8BxJXS1SqxfNXRoBGKOLc7X4FyQxACJuXd9RhHiPO7Sg4hkDNPsO
         0BdrREY76931MQdFfPFPpP+9kWMLUPcoDvMDvpRNJ21WEh9idB48jgzlwC+jGcTPefO+
         rCuA==
X-Gm-Message-State: AOJu0YwDaLYwx5eLpGYZ5WtWAeUX8wScbukdd45K7muITGPyd84ucrnp
	oqYaWV+mL+F5RQvl42O4+r4BWIhARsafh/9rwCtUBfiMAkqWK7cRt7zuSeboIqO4X2dvhQQWwcx
	nZmOOUPETze54WFbLKKBtP/2Xyad7btKTe+1j
X-Google-Smtp-Source: AGHT+IHcdkeyLXa6XCtLDjnDduk6glUOICOD9kwov8c2Kod0b9O1y98HahUbVVMf9/ahZ+kp6Ql6PausH1jHqmGnf44=
X-Received: by 2002:a17:902:f688:b0:1d8:e7a1:8a87 with SMTP id
 l8-20020a170902f68800b001d8e7a18a87mr405401plg.20.1706659122320; Tue, 30 Jan
 2024 15:58:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-10-amoorthy@google.com>
In-Reply-To: <20231109210325.3806151-10-amoorthy@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 30 Jan 2024 15:58:04 -0800
Message-ID: <CADrL8HXLF+EQZt+oXJAiatoJNzz2E-fiwUSJj=YpHzGQxL00mQ@mail.gmail.com>
Subject: Re: [PATCH v6 09/14] KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate an EFAULT from stage-2 fault-handler
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anish,

Sorry to get back to you so late. :) I was hoping others would provide
more feedback, but I have a little bit to give anyway. Overall the
series looks good to me.

On Thu, Nov 9, 2023 at 1:03=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> Prevent the stage-2 fault handler from faulting in pages when
> KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
> calls to check the memslot flag.
>
> To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
> when the stage-2 handler cannot resolve the pfn for a fault. With
> KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of stage-2
> faults as vCPU exits, which userspace can attempt to resolve without
> terminating the guest.
>
> Delivering stage-2 faults to userspace in this way sidesteps the
> significant scalabiliy issues associated with using userfaultfd for the
> same purpose.
>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  arch/arm64/kvm/Kconfig         | 1 +
>  arch/arm64/kvm/mmu.c           | 7 +++++--
>  3 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index fd87bbfbfdf2..67fcb9dbe855 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8068,7 +8068,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
>  7.35 KVM_CAP_EXIT_ON_MISSING
>  ----------------------------
>
> -:Architectures: x86
> +:Architectures: x86, arm64
>  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
>
>  The presence of this capability indicates that userspace may set the
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 1a777715199f..d6fae31f7e1a 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -43,6 +43,7 @@ menuconfig KVM
>         select GUEST_PERF_EVENTS if PERF_EVENTS
>         select INTERVAL_TREE
>         select XARRAY_MULTI
> +        select HAVE_KVM_EXIT_ON_MISSING
>         help
>           Support hosting virtualized guest machines.
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 13066a6fdfff..3b9fb80672ac 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1486,13 +1486,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
>         mmap_read_unlock(current->mm);
>
>         pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
> -                                  write_fault, &writable, false, NULL);
> +                                  write_fault, &writable, true, NULL);
>         if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
>                 kvm_send_hwpoison_signal(hva, vma_shift);
>                 return 0;
>         }
> -       if (is_error_noslot_pfn(pfn))
> +       if (is_error_noslot_pfn(pfn)) {
> +               kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE=
_SIZE,
> +                                             write_fault, exec_fault, fa=
lse);

I think that either (1) we move this kvm_prepare_memory_fault_exit
logic into the previous patch[1], or (2) we merge this patch with the
previous one. IIUC, we can only advertise KVM_CAP_MEMORY_FAULT_INFO on
arm64 if this logic is present.

As for the changelog in the previous patch[1], if you leave it
unmerged with this one, something like "Enable
KVM_CAP_MEMORY_FAULT_INFO to make KVM_CAP_EXIT_ON_MISSING useful, as
without it, userspace doesn't know which page(s) of memory it needs to
fix" works for me.

Also, I think we need to update the documentation for
KVM_CAP_MEMORY_FAULT_INFO to say that it is available for arm64 now
(just like you have done for KVM_CAP_EXIT_ON_MISSING).

Thanks!

[1]: https://lore.kernel.org/kvm/20231109210325.3806151-9-amoorthy@google.c=
om/

>                 return -EFAULT;
> +       }
>
>         if (kvm_is_device_pfn(pfn)) {
>                 /*
> --
> 2.42.0.869.gea05f2083d-goog
>
