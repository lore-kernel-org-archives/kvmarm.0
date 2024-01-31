Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E8039FC5
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 22:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706738409; cv=none; b=JlCIfvW9cIas2kOX/JiysSLqjDaoZcZH6FsdJLnOgCYZ8gVnwMSiC8qmMORN+8IJ0dxFLvjrXoOStpa7mrHIQOYDkQdX5HUkhJpWB1O7QGE3Um8oul0mEkvOgySRdCTYD8ystvmm/2JCByInSWeN9tMtM0L1ftMJAJ/sOKETW64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706738409; c=relaxed/simple;
	bh=pTPZRdj/clNw8Oelh7URCewuDtXPDjO7UvOoX7E79cU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q+9zZWdIliWiFKwmcCOy5oP7peQDj+4NAksltWXwoW4I3A3gmiFsLkW09wW1+aGvczi45O/C4BH0rK+Ed8hMJn5bE8PkCcc5DOpjwPKTEAdQqxbHBRtn8L0kL89vGIGvAxnsy4v7Yx2ptgJU/0ZYaXaw8eqfmA+8zUq3q4LoD5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oAhIzU/M; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oAhIzU/M"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3bb9b28acb4so190242b6e.2
        for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 14:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706738406; x=1707343206; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3HWn2vkHxIR1F0Lo5tspJmR3xmAUHbpogVpChRP7V7U=;
        b=oAhIzU/MQ6uf4mymH+cIiiPcDD138VJXNy2ogj5aFL4xqtDvNYyNG1Vrd/uFZ1mDyH
         2w2xOzrHpHunhejBgkdKGX+AtCUKEoWrSyYgtNOjTaYBxVEaal/DtnRn7o13JJcQRuLJ
         27rCUI3UUJRntJdaF8Rr54HzMnFqL3ZD9bggkQIO+lkQLh9m+S2e0s7LJop9ROy3BR+7
         cGC7pog0waZZ8kKxZQhyne11ZSzcywMYqQlyu/oAUa71ys0tlqGex7Hmj6rg40z5UNAQ
         ipxEjs2dTG2zza860qeUsQ3QZMp3+85gV/h0DCUybMloSBIIQJmCOPhABFJP7PKHZmNq
         Enbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706738406; x=1707343206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3HWn2vkHxIR1F0Lo5tspJmR3xmAUHbpogVpChRP7V7U=;
        b=J0ZsdewB/MabLAzej0chEpDxN+eMY4MSdgxBsM7GVM6F+vRRHV7exuvaUqXZMXQ4em
         DLG3YETxF1nOauKUtTuvycQl8k/KpyEleazciFcLDFNwWnZpUfsF4wOEjEXYlUHUzh+H
         FGEdU6AXEARUWn7SPU+k0z88IN0F5g+DWsgvtG7glmn31VevIb8DJoE6Mq5CSNKhvfAC
         mUTzIobgEMNAKY0PjsQDnbULvpR3hBCqq1BtUk95s1kngeAnlqO7Pg5F+G2T4aXaxgIA
         Hn8iFExXQ4C6TEA5xKFAK9mVPuVQYpo30A2+QDVno9U6V8aP4MELH/HBVnamz30/Jbqv
         aCkw==
X-Gm-Message-State: AOJu0Yy9BMjjbd3XJTC2gqvH1pQnFws88NPpSbrsjAbKA0D2VDl4ORcf
	90LWMXkcrtyVDSl//vu1xY5f2XPF4TBEQMYx73uXYvSKRmBVwtb+02RUIInRIpON7c1MTgWQ30k
	b7bQmDTj2ax7FDWLitbnuHkHQmiTLTVmergdn
X-Google-Smtp-Source: AGHT+IGKCsKTkygbpPhG3XJ9O5u/HE7aI2abahJw3REKjJnkzRFEpCfEVmamGfDvrnVqdpiddT5NVHn+Cs9fjWdogOQ=
X-Received: by 2002:a05:6871:783:b0:210:af25:a5a0 with SMTP id
 o3-20020a056871078300b00210af25a5a0mr3347929oap.1.1706738406281; Wed, 31 Jan
 2024 14:00:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
In-Reply-To: <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 31 Jan 2024 13:59:30 -0800
Message-ID: <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: James Houghton <jthoughton@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Feel free to add:
>
> Reviewed-by: James Houghton <jthoughton@google.com>

> If we include KVM_MEM_GUEST_MEMFD here, we should point the reader to
> KVM_SET_USER_MEMORY_REGION2 and explain that using
> KVM_SET_USER_MEMORY_REGION with this flag will always fail.

Done and done (I've split the guest memfd doc update off into its own
commit too).

> > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_=
memory_slot *slot, gfn_t gfn,
> >                 writable =3D NULL;
> >         }
> >
> > +       if (!atomic && can_exit_on_missing
> > +           && kvm_is_slot_exit_on_missing(slot)) {
> > +               atomic =3D true;
> > +               if (async) {
> > +                       *async =3D false;
> > +                       async =3D NULL;
> > +               }
> > +       }
> > +
>
> Perhaps we should have a comment for this? Maybe something like: "If
> we want to exit-on-missing, we want to bail out if fast GUP fails, and
> we do not want to go into slow GUP. Setting atomic=3Dtrue does exactly
> this."

I was going to push back on the use of "we" but I see that it's all
over kvm_main.c :).

I agree that a comment would be good, but isn't the "fast GUP only iff
atomic=3Dtrue" statement a tautology? That's an actual question, my
memory's fuzzy. What about

> When the slot is exit-on-missing (and when we should respect that)
> set atomic=3Dtrue to prevent GUP from faulting in the userspace
> mappings.

instead?
