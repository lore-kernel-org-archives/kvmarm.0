Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF83100AE
	for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 14:08:48 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-c83284edf0eso3266467276.3
        for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 07:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689170927; x=1691762927;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=61Bb86vxt9PpkUcz935uJ7O0G2xXf3VyMbaMcGvnRT4=;
        b=Yti+bExW+ZX8aBNYkyF+7gOY1gDsT3YtIr0sz8jtb963EUPi0YHptmlxRpIgAq8krX
         rPvaFqHisX5lV6SnBLuIkaldD0tpF0thm7rcn1IUMpgg5bAJFxMDVEOv+3BBSFX5DE0R
         RAdIvHkn2Znuw+IpLcTp3ImsK9G+ose7oBNwwmHO61RmWaCe+LIjW8Nd4Kp55AWwC8BT
         IifqYHvOs0oQokFE+9PRt78v1CemvelioyZaWix/B9QEZtg5Xo0otlPF2nm5o/uUTSVT
         NS4JxshMd/kSwIeu0oiAJPt7U5ivim6aiipUfyHBdWP4anir08CAFDVnbc8me5EBJZn0
         8Aqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689170927; x=1691762927;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=61Bb86vxt9PpkUcz935uJ7O0G2xXf3VyMbaMcGvnRT4=;
        b=e6VFJBwN6Onm2KMI9NPG79AH2m8qFYMOjfIzi4Jz3cnpCUWL8SgGuJPSdIyFfN8wZD
         f+CGi/m57D/qQykzAaDZdWT5F4msIRVC+/icZXXWHG0cKoZqa0DCbciNzjpEf/AP5pom
         CQUNGKyMaWaFs/sC0QWCGj0o605vRraLfZ6Y3opVjy6VivMgE5MVysuZrc1QSJNlQWGJ
         igJ0zx9w7sM9MdCJXHeSpym1mF4hy7206LqGLc+zK8s98ApyiY56jvABSZV3fx3or6k0
         6jsK/S6LctPbLNss8RaHroaczn4YBuLe326pvehIg9vUxBI97N8K1k+4sDxq2O57pN1c
         KiDA==
X-Gm-Message-State: ABy/qLaIMxvYHWe08aJuOvKg2+MV5OaFLsMsC6qdn0GD7XI0eyxnMMWC
	4J+4wFxCwTAIIQwb/CQjHSN1rT4XDmQ=
X-Google-Smtp-Source: APBJJlHCEzVLrClhpPb8qPoDTeJqu/2HP+RHYiydI+UaZZBLeQbY5BG0fq3uGfdwzCnf84xvbcW4T8rCazs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:90e:0:b0:bc0:bfa7:7647 with SMTP id
 a14-20020a5b090e000000b00bc0bfa77647mr129497ybq.0.1689170927305; Wed, 12 Jul
 2023 07:08:47 -0700 (PDT)
Date: Wed, 12 Jul 2023 07:08:45 -0700
In-Reply-To: <CAF7b7mrxNdMJZT=BQC5VP2EK7SdihW_BfaSywbtJpFz0bgiUbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-6-amoorthy@google.com>
 <ZIoQoIe+UF6qix5v@google.com> <CAF7b7mrxNdMJZT=BQC5VP2EK7SdihW_BfaSywbtJpFz0bgiUbw@mail.gmail.com>
Message-ID: <ZK6z7dkTmdeiwVrL@google.com>
Subject: Re: [PATCH v4 05/16] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 06, 2023, Anish Moorthy wrote:
> On Wed, Jun 14, 2023 at 12:10=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > static int __kvm_write_guest_page(struct kvm *kvm,
> >     struct kvm_memory_slot *memslot, gfn_t gfn,
> >     const void *data, int offset, int len)
> > {
> >     int r;
> >     unsigned long addr;
> >
> >     addr =3D gfn_to_hva_memslot(memslot, gfn);
> >     if (kvm_is_error_hva(addr))
> >         return -EFAULT;
> > ...
>=20
> Is it ok to catch these with an annotated efault? Strictly speaking
> they don't seem to arise from a failed user access (perhaps my
> definition is wrong: I'm looking at uaccess.h) so I'm not sure that
> annotating them is valid.

IMO it's ok, and even desirable, to annotate them.  This is a judgment call=
 we
need to make as gfn=3D>hva translations are a KVM concept, i.e. aren't cove=
red by
uaccess or anything else in the kernel.  Userspace would need to be aware t=
hat
an annotated -EFAULT may have failed due to the memslot lookup, but I don't=
 see
that as being problematic, e.g. userspace will likely need to do its own me=
mslot
lookup anyways.

In an ideal world, KVM would flag such "faults" as failing the hva lookup, =
and
provide the hva when it's a uaccess (or gup()) that fails, i.e. provide use=
rspace
with precise details on the unresolved fault.  But I don't think I want to =
take
that on in KVM unless it proves to be absolutely necessary.  Userspace *sho=
uld*
be able to derive the same information, and I'm concerned that providing pr=
ecise
*and accurate* reporting in KVM would be a maintenance burden.
