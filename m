Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C20511CB8
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 22:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694038227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2sW5n0U9nqfDRjI4qbYKErrgizSRaxysFjpyGkvRHBg=;
	b=Pg99Aw0dhrjssfj+plRZ73iAzmz80+t6FzoooYMo5YOjDFkLKZv62XF4FxljMbibakqOrb
	gWlugmjp43pbB5CdnXYoQls8seJQWvdY++J14P9i7h5PP0X9VcuRGlwMkKJAy4kV+FVodZ
	XQCAdiOokbHqs1rtsWQOjmjv9FyPDWo=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-nM8dsyvTOCCbrhkHI6Qp9Q-1; Wed, 06 Sep 2023 18:10:25 -0400
X-MC-Unique: nM8dsyvTOCCbrhkHI6Qp9Q-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-44d3abd5031so113726137.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Sep 2023 15:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694038225; x=1694643025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2sW5n0U9nqfDRjI4qbYKErrgizSRaxysFjpyGkvRHBg=;
        b=lgiWjeK8wQxSfTHx/x7AeKMtpAUvOxNdMdysOfYxUt7R7FmRW4+VcfeT/KKIu/7601
         z4vL/GFV+DMDRX0AswKr1pyuDkwqWF1EpGpxLcQkx/qZ8T/C8kSmokhzoSidipmtcAUw
         QlwA5n+LZtQg3TSfcRjln59e7WqM9X8wM8+Wvn321HsNTd7RIj1dtBFVddg0udwwnUxg
         VjdXWYr8O9q9Smw9u1IPS9GXRipGWQLAo9VR2vsU47IDzayMMSss4qov+53GlraD0Txz
         C25lpS5EJT9W0TfGUGvIk2uHD0YNciPnhcAlsZAWwcd7+zk8POm32+FThvmNFWAMkVMj
         /o0w==
X-Gm-Message-State: AOJu0YyXBAeVq9QwFVcdvJXYr/g0gArhew7X0USkBL0v4R8Vg6mUS/6t
	dJTO+4pzgeCXX2NxS4Uja1n6A4N20gdRXx6f4sGvyOuHqhKCbm5nHXbB4ROUlS3jr6+32LAmsZ9
	wGNAtlJM3cQuhnqbB5EZ+HEtoM+bx93qt
X-Received: by 2002:a67:ee4d:0:b0:444:17aa:df60 with SMTP id g13-20020a67ee4d000000b0044417aadf60mr4110672vsp.13.1694038225083;
        Wed, 06 Sep 2023 15:10:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHp5n1WB8R1og/NcZaTM8SckALAeHpMUrTVBDu8TXyXcr3qI/pIRPsrfv30I89brgsoG52emGtevyCvY1jn784=
X-Received: by 2002:a67:ee4d:0:b0:444:17aa:df60 with SMTP id
 g13-20020a67ee4d000000b0044417aadf60mr4110646vsp.13.1694038224758; Wed, 06
 Sep 2023 15:10:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-14-seanjc@google.com>
 <84a908ae-04c7-51c7-c9a8-119e1933a189@redhat.com> <ZLq8ylTsFQ1s4BAZ@google.com>
In-Reply-To: <ZLq8ylTsFQ1s4BAZ@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 7 Sep 2023 00:10:13 +0200
Message-ID: <CABgObfYLuRx5oAfOKM1fNuyRw5BNhe127sbRYhmpoT9MsjMYQQ@mail.gmail.com>
Subject: Re: [RFC PATCH v11 13/29] KVM: Add transparent hugepage support for
 dedicated guest memory
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Vlastimil Babka <vbabka@suse.cz>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 21, 2023 at 7:13=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> On Fri, Jul 21, 2023, Paolo Bonzini wrote:
> > On 7/19/23 01:44, Sean Christopherson wrote:
> > > @@ -413,6 +454,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_c=
reate_guest_memfd *args)
> > >     u64 flags =3D args->flags;
> > >     u64 valid_flags =3D 0;
> > > +   if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> > > +           valid_flags |=3D KVM_GUEST_MEMFD_ALLOW_HUGEPAGE;
> > > +
> >
> > I think it should be always allowed.  The outcome would just be "never =
have
> > a hugepage" if thp is not enabled in the kernel.
>
> I don't have a strong preference.  My thinking was that userspace would p=
robably
> rather have an explicit error, as opposed to silently running with a misc=
onfigured
> setup.

Considering that is how madvise(MADV_HUGEPAGE) behaves, your patch is
good. I disagree but consistency is better.

Paolo

