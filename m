Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42291283FC4
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748445038; cv=none; b=HWe5bAjwuTtCdmSp3EJOZjFv36KXawonQDkFRIhDPD/RMBT2IJqgGydpXT08p7ZM2H0t5yOn10nEuuKVTZJDoY4GhYOAgWpw260oKUl5Ufj/zBU525lpiiZieGDkNB4rcOLwDVyhUo9+4wHV3MId3PF44w+1bsM1wDyeIPpaGxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748445038; c=relaxed/simple;
	bh=oRij2I0TpTX32X/NhxasXgfEJxa8A5RThaAlheT8LBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q6jCrtBJHcK4JDvRW1fV5p++fWEigLqR610UtmsDMOnsGHnPcTWLclloQYYqzcbJEplYAlYOfeYtu0bnY8nts9Vq9Jiye9Gan99hjYvHjXomvscBPDTN31PI7z64Szke7T3YI/W7PrSU3f8y5e2m253lDFmPsL/LBGsINalv3LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NtN7fAT9; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NtN7fAT9"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e7387d4a336so3625958276.2
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 08:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748445034; x=1749049834; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mkOH/F0mBjSGdYPCUEiDsSIcD6SIWcpvbL1Z7KSMawk=;
        b=NtN7fAT94lcI0j9RofjJiztD2fD8ModFeytNu7z7Y3aSHgFsFbFkp6dLQS9piquZRI
         gEwFLDFSc3oYuQzEMwic1y/nkLdBqmGSUgXhfwreEGrabX2PFKTkNcmMFIL/t75CpX33
         26x78DvqYe0x/7U0nsVhY0BYdkxLQIRD9p7pxAycE2JarioIEwMfzOc9MENAwB+W6m5k
         6jtHH4nAQ7nUUOLrDivm/csSK0v/vuRSKzJqjYwAZkDURAYMbz1woRzSMYbwQHU1eXOe
         aTO9BDEwfzojgGS1vRTRz0LMcTjZ0rpNfIB/fJMwRBbAVVqw1OtqcLYCJ76bDrvMZPT/
         dkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748445034; x=1749049834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mkOH/F0mBjSGdYPCUEiDsSIcD6SIWcpvbL1Z7KSMawk=;
        b=JSjZMdfpLyBBhdM6RsfWs2Hd1mguXW0/KUX/nErTo+DkqRwrno/tXPSkw0mEo7GvFf
         9hSXMIVvacG9p2qVbYjg0zAqNYL6B56Gg6rZCoriuX/s6MpZDBYuKcZZNoNiyLySAGGO
         Smia3vh6oK+VM2mAu32RSLoCWXZo1VkzwRC6N8pOi9f4hTd/9kKhAyVJ7Txx5P8j7Kqe
         I1UPhj0HlqDPibdM6tZf5l5wIzQJkKSzIxnmwtGXRW1bJmkeORjubdf4/rZH5LnZdbzX
         wBOhp85uZhSiwjPCS0l/zsnigA6HjN7ZRc5+KdmlNNOkY8g8u23MY5gzi6ozAULq4g0B
         nDYw==
X-Forwarded-Encrypted: i=1; AJvYcCWd8u5Uw/QGfUIzqJBvbiCRsIsmadhj8iPPFxgivMvOc7Yl8v/aKRyjikyv7rlUiD+YrPRdpY0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLweyBLWuqnBiJLNvFX2Lgev7R8oXsLz9YKaXRQ5qczcU2sxWP
	qN4grNHIjaMrSv3WoHeqgXRRjOAR258NTPcF8M6pqLush2sg0w71SvZy0leDPA5fb6yOtMxZtt/
	DG/gC1JJTp1vH5AR019kbG9FU8TFiWza6GdrwUGLH
X-Gm-Gg: ASbGncsp0jvWDlXjWLtmnD02Ib0RgwsDia4oeSX0a7KRBfY/C9HAaIMulmabon8Oh9j
	tI0DoSOkuPdAp2MdZMfk3hC0UIrgLP4+vgy5ThtzLUXrrc+r6RrWe9QOqW6u/8Kp1AdhOZsOUTx
	SQY4IKelM/PXb7qZM11kyqCPcpG9PhSDPvnvOGu70fSJIGpU2UpNi3QLJ08VNz1l1QObMycgGcD
	3AAoQ5ZvuJP8yjN
X-Google-Smtp-Source: AGHT+IGR99lWrX4uBQGr2kH0bGfT4JkEfaCzPmaHW/nbBCSd4QahIO99ZAocGBZAuHyfUiwPf1Ucb1uKFWWP5NDU59M=
X-Received: by 2002:a05:6902:2841:b0:e7d:6fe3:fc81 with SMTP id
 3f1490d57ef6-e7d91b459aamr21754237276.30.1748445033884; Wed, 28 May 2025
 08:10:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-7-jthoughton@google.com> <aBqkINKO9PUAzZeS@google.com>
In-Reply-To: <aBqkINKO9PUAzZeS@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 28 May 2025 11:09:58 -0400
X-Gm-Features: AX0GCFt9PLVfklSGC-mOnCNW0mGP_16cIQYPD6tP1ev5K3PmI8fYxDutOCJrYcQ
Message-ID: <CADrL8HXDDRC6Ey5HYWvtzQzjcM2RNX7c7ngGyjUsD3WiBF3VYA@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 8:06=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jan 09, 2025, James Houghton wrote:
> > @@ -2073,6 +2080,23 @@ void kvm_arch_commit_memory_region(struct kvm *k=
vm,
> >                                  enum kvm_mr_change change)
> >  {
> >       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PA=
GES;
> > +     u32 new_flags =3D new ? new->flags : 0;
> > +     u32 changed_flags =3D (new_flags) ^ (old ? old->flags : 0);
>
> This is a bit hard to read, and there's only one use of log_dirty_pages. =
 With
> zapping handled in common KVM, just do:

Thanks, Sean. Yeah what you have below looks a lot better, thanks for
applying it for me. I'll post a new version soon. One note below.

>
> @@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct kvm *kv=
m,
>                                    const struct kvm_memory_slot *new,
>                                    enum kvm_mr_change change)
>  {
> -       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PA=
GES;
> +       u32 old_flags =3D old ? old->flags : 0;
> +       u32 new_flags =3D new ? new->flags : 0;
> +
> +       /* Nothing to do if not toggling dirty logging. */
> +       if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
> +               return;

This is my bug, not yours, but I think this condition must also check
that `change =3D=3D KVM_MR_FLAGS_ONLY` for it to be correct. This, for
example, will break the case where we are deleting a memslot that
still has KVM_MEM_LOG_DIRTY_PAGES enabled. Will fix in the next
version.

>
>         /*
>          * At this point memslot has been committed and there is an
>          * allocated dirty_bitmap[], dirty pages will be tracked while th=
e
>          * memory slot is write protected.
>          */
> -       if (log_dirty_pages) {
> +       if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
>
>                 if (change =3D=3D KVM_MR_DELETE)
>                         return;
