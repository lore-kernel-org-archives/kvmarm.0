Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3550C2CD
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 21:17:37 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7909307ecd1so206703439f.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 14:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692825456; x=1693430256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikCtusfTIERSZQgcg1mFeqjKSQ/EZVCFYlWC+HDCtmw=;
        b=zp1ypRyBx04BkTszpYvgREt7D/4bRPcNvftZHL2LE+kw6IFe4MN471OyCop7YzkXdX
         EuK5A0yvKMCodY4S4DX+6jIN4OjKlZC9CYsASWPMW5L9y5KwLfcQWOcsFynu0ijyEGCB
         erNbALn+3zOiuU2sdD6Bsb8u2HI6LQZH49phH8BOQMOmDu960DTSd0noryj/Rir/mT06
         xBWpF4HoceCDEnUgTj5DSSAsGLUkf0Llbkg+LV/Dgo9Po/Q0SgU4rjFJKWiv1QZBPq1r
         v2wmhEqhhLdAYxsEY/NWe6szFeh5Z7rED1xv4jhvBCRTZc6/Gy0GiGKuGtlMRR8yHGWY
         x94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692825456; x=1693430256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ikCtusfTIERSZQgcg1mFeqjKSQ/EZVCFYlWC+HDCtmw=;
        b=My2/2m3UFyjC4ycxORjwUmZQqEZTaKnQ248oQ+QAg1l1dzXTCasXJtnfb8veqr2pj+
         JL/wVZSpHglm1Lg7BsdUQ1Kth6mhvsNiIlRXNItVRF3Bsyvcth5EOKdrgPJKljWLgmHg
         dMiba+7JKp77FtVTjWXIUW0BrF6F7eT3GtzNXzszmNpD325lvFnLf0DM+yl0WkCdW+/F
         Y+cZKB2eyk+cf8q/MMzEBddHvx9WN7lj0o/ubsTp7m1QohaSarzZBTF3g/xrJc0omYQb
         PT3c58RMyZo2RZIEoHt0A/zeGRtS+jaxBYT/QIKxtpD0hdftuFIdxDAsipZxtNdke4Mr
         Uf3w==
X-Gm-Message-State: AOJu0YwzN66+HUvR+Cv/VuSyuoGRKimIQc6pW92bsJI+Ifeupc13SGMu
	ZC0FiRv1n7si1lYU5/T/BFApnsA47BOFtsSIBFA16w==
X-Google-Smtp-Source: AGHT+IEhxH/m+zLly/AlA1+BkNJxLXP3R4qoW0MHefIxcR/d8irHqdZJWWTVtuvTr3KbcOCax1/lnLR+zGAbFa0Kveo=
X-Received: by 2002:a5e:c902:0:b0:791:2194:10a2 with SMTP id
 z2-20020a5ec902000000b00791219410a2mr4156419iol.15.1692825456667; Wed, 23 Aug
 2023 14:17:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <ZIovz22R5dm05u6/@google.com>
In-Reply-To: <ZIovz22R5dm05u6/@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 23 Aug 2023 14:17:00 -0700
Message-ID: <CAF7b7mpoMjXjQe33EKfYc4QTD2rr0UYGuFNEELpenqBrzuTP=Q@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 2:23=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Gah, got turned around and forgot to account for @atomic.  So this?
>
>         if (!atomic && memslot_is_nowait_on_fault(slot)) {
>                 atomic =3D true;
>                 if (async) {
>                         *async =3D false;
>                         async =3D NULL;
>                 }
>         }
>
> > +
> >         return hva_to_pfn(addr, atomic, interruptible, async, write_fau=
lt,
> >                           writable);
> >  }

Makes sense to me, although I think the documentation for hva_to_pfn(),
where those async/atomic parameters eventually feed into, is slightly
off

> /*
>  * Pin guest page in memory and return its pfn.
> * @addr: host virtual address which maps memory to the guest
> * @atomic: whether this function can sleep
> ...
> */
> kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 >     bool *async, bool write_fault, bool *writable)

I initially read this as "atomic =3D=3D true if function can sleep," but I
think it actually means to say "atomic =3D=3D true if function can *not*
sleep". So I'll add a patch to change the line to

> @atomic: whether this function is disallowed from sleeping

I'm pretty sure I have things straight: if I don't though, then we
can't upgrade the __gfn_to_pfn_memslot() calls to "atomic=3Dtrue" like
you suggested above.
