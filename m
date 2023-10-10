Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9D43550B
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 23:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WnWGPZNJ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4064876e8b8so61403205e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 16:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696978916; x=1697583716; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdRL4y1cTCFXmyMFKustVLIgbPKJzRBqwfNfiJOWZO8=;
        b=WnWGPZNJFYUR/Fbdqv6fCGJseaJ9WvFIII5AvWRnJh9Xct3mDYZHNYRyt9VBw6rf0N
         ctYQuWC+dkf1mtC+0FbV9dwiW3eWv0C8Q8WUlfhgYWR6cGDqrH6qm8jAK+KLH/XfndAp
         H9KHLH2BN5c4Aw2vzDxbU+iGh5E1b3Vwyh+8fwZwB+CSFKojJMLFmjukxVXqrJoiAUwB
         HRfHmCRJHfOjxHNElXFxsbYH+9nNQWcdEWZLu6UUkmci6rN93lBGUH22ZtZEY9xFbnC6
         aEMg6f9SbcZN4M4jSAptQd3buAm2FkeYGcm8MA8FwnCxmqtu5I23d+fvmYOwLf7zYPyD
         wYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696978916; x=1697583716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdRL4y1cTCFXmyMFKustVLIgbPKJzRBqwfNfiJOWZO8=;
        b=D0HnAjOnELf27ImS3grcl2n3aH0z0LXy1bvfeG0Qg7gHq4O/0nKyokInp9PIrgBWx7
         M/KfBslnnGbsYKNN2ScN4Aujz9eQkGw1EqobTCpbAw+9vTBgp/KF8aR47xvP2Al5Kltd
         TcZlFnikPc3FCyzUqJFHPaOzrH/M1+NXPcb9DLZUwc+5FbUWlxa+yBsHs1oEH3FAzh0t
         jv7TFf0KR3Xo6YL5OSCXyfnJMraHAaLXjNe3D7SkIeWpYjH4CGrLv/Uixd54UKWwK2Sy
         uxcsocuBwLMZCrEP9yuwx1uXail4Ow4i0W4UTmlR+Tm6GOXa84bSdZezFh1SLKPE3Fl0
         dv7A==
X-Gm-Message-State: AOJu0YxNbtIEfm5dNu7ABa7MrqC0zYUfVP1iFF9KF4WvYqu3M9lQ3A6l
	QnUlB2Z9GX1OgAE+I03NtZ+x6WT8gkljpMnLNN3byA==
X-Google-Smtp-Source: AGHT+IHzhd3JKjUkEBkPi958g3DnO7+xRps/XVocUHHHRRU2TV7BqApmiCT22okMhkBb70Feyl/KpPt3TmnyND1MuRc=
X-Received: by 2002:a05:6000:1f02:b0:32c:d7e6:4054 with SMTP id
 bv2-20020a0560001f0200b0032cd7e64054mr2728992wrb.53.1696978915793; Tue, 10
 Oct 2023 16:01:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-8-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-8-amoorthy@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 10 Oct 2023 16:01:29 -0700
Message-ID: <CALzav=fZ6cEJO+YO1vHFBxiTmLj3kv0pX=ss1f-NCC=Opp==Ag@mail.gmail.com>
Subject: Re: [PATCH v5 07/17] KVM: arm64: Annotate -EFAULT from user_mem_abort()
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> Implement KVM_CAP_MEMORY_FAULT_INFO for guest access failure in
> user_mem_abort().
>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 587a104f66c3..8ede6c5edc5f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1408,6 +1408,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         long vma_pagesize, fault_granule;
>         enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt;
> +       uint64_t memory_fault_flags;
>
>         fault_granule =3D 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level=
);
>         write_fault =3D kvm_is_write_fault(vcpu);
> @@ -1507,8 +1508,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, p=
hys_addr_t fault_ipa,
>                 kvm_send_hwpoison_signal(hva, vma_shift);
>                 return 0;
>         }
> -       if (is_error_noslot_pfn(pfn))
> +       if (is_error_noslot_pfn(pfn)) {
> +               memory_fault_flags =3D 0;
> +               if (write_fault)
> +                       memory_fault_flags =3D KVM_MEMORY_FAULT_FLAG_EXEC=
;
> +               else if (exec_fault)
> +                       memory_fault_flags =3D KVM_MEMORY_FAULT_FLAG_EXEC=
;
> +               else
> +                       memory_fault_flags =3D KVM_MEMORY_FAULT_FLAG_READ=
;
> +               kvm_handle_guest_uaccess_fault(vcpu, round_down(gfn * PAG=
E_SIZE, vma_pagesize),

I think gfn * PAGE_SIZE is already rounded down to vma_pagesize. See
earlier in this function:

1484         vma_pagesize =3D 1UL << vma_shift;
1485         if (vma_pagesize =3D=3D PMD_SIZE || vma_pagesize =3D=3D PUD_SI=
ZE)
1486                 fault_ipa &=3D ~(vma_pagesize - 1);
1487
1488         gfn =3D fault_ipa >> PAGE_SHIFT;


> +                                              vma_pagesize, memory_fault=
_flags);
>                 return -EFAULT;
> +       }
>
>         if (kvm_is_device_pfn(pfn)) {
>                 /*
> --
> 2.42.0.283.g2d96d420d3-goog
>
