Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506E6525E
	for <kvmarm@lists.linux.dev>; Wed, 30 Aug 2023 16:22:14 +0000 (UTC)
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-48d0b70097fso1999234e0c.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Aug 2023 09:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693412534; x=1694017334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dw2WvEWP5AHwQBMLMZzuxkvXEX6YYa50Q22jJHrU9hQ=;
        b=IuS59OWDTkpFKE1ft8hy1ZrHyTS6PNYcrS66h840XWCCP7AFiypxoaf4LnAGlRTSwX
         chmooIKIkaFlROU+O6KCZep14t/8wG0mxirv/ADKq4m5+biOgbVbzshafpUlicFSGQvU
         nNnVokcHacFP7nzjf417oJ/vqueFZmeXYp5rdaU+yNeFRnWvu1lp4Ko+kxtf5fanE7BP
         4ASuRvMhVXhK+QPlvksGGYxH1zpH7Z2D0gnlmyRY1GBipdC6mdk6LOtgnW4eZAYt1K2y
         DrgyKGXAXTG8biK/vHLVsHcu2pqLXK5o3DoQrC4EBBy9Cea2V3VzbcwjuN4aYtz/XUnR
         ntvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693412534; x=1694017334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dw2WvEWP5AHwQBMLMZzuxkvXEX6YYa50Q22jJHrU9hQ=;
        b=lMyuyw+oBbVmnNljcXBxi8FoXjneonOPE23xiJjr3VD/PL75tLXDqTKe9tpa3UGeap
         67KmY5Dfej5NWFcgG28/JSiQbatvTVhXci0V5pVU6xrvHBE/SGG4Nmpi991daLVZikab
         v1Vc/PgvIua+kh/cReWVWNUcgsInc/ViPg+ovH6qh0Kr+5CVOawYF3jsbE8Q9urehHg2
         IKMw+AUzwEb/3UmAJ4EMOKslWANd0oawmyFfSYZjZk8Fnyrh/7zGc17UYa966ytzK9oA
         Fo6YpTVp/2TR4HOsfcis5DS+vxmPTEDLDGmDkzItPakgkjTluLOLJU+kV8+CVRbxqWXI
         LbRw==
X-Gm-Message-State: AOJu0YxRvTnicIMkMfvV/605eJ4aHhGPvZg52aoISIq6L/jw3g1yAWOS
	i7LOoAUv08kOWz6kFIh4R7+hspkcDNr9zGlD28UEZQ==
X-Google-Smtp-Source: AGHT+IFJYolaWrvL9Vm6pW/8woBwDRooYKKzo58w/okNFmpZ5IkaXab/sUrziXE2fCbBT5QIHQa5WDlTvBocGpsAIZw=
X-Received: by 2002:a1f:4842:0:b0:48d:d3b:7dd9 with SMTP id
 v63-20020a1f4842000000b0048d0d3b7dd9mr2165847vka.3.1693412533698; Wed, 30 Aug
 2023 09:22:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
 <CAF7b7mrabLtnq+0Gtsg9FA+Gfr12FqbmfxwJZuQcBNDz1+3yLw@mail.gmail.com>
 <ZK11Sxobf53RsAmH@google.com> <CAF7b7mp1Bspeqc9n==gE5NgPwxfYLtu9G3=+OTwAcipeYRkPKg@mail.gmail.com>
 <ZO50Nvl5QaQMmNqX@google.com>
In-Reply-To: <ZO50Nvl5QaQMmNqX@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 30 Aug 2023 09:21:37 -0700
Message-ID: <CAF7b7mr1EHF3EAU9PAFV16N0y52N2Ek8vPEcr60NQL7jd85PLg@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
To: Sean Christopherson <seanjc@google.com>, "stevensd@chromium.org" <stevensd@chromium.org>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 29, 2023 at 3:42=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Aug 24, 2023, Anish Moorthy wrote:
> > On Tue, Jul 11, 2023 at 8:29=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > Well, that description is wrong for other reasons.  As mentioned in m=
y reply
> > > (got snipped), the behavior is not tied to sleeping or waiting on I/O=
.
> > >
> > > >  Moving the nowait check out of __kvm_faultin_pfn()/user_mem_abort(=
)
> > > > and into __gfn_to_pfn_memslot() means that, obviously, other caller=
s
> > > > will start to see behavior changes. Some of that is probably actual=
ly
> > > > necessary for that documentation to be accurate (since any usages o=
f
> > > > __gfn_to_pfn_memslot() under KVM_RUN should respect the memslot fla=
g),
> > > > but I think there are consumers of __gfn_to_pfn_memslot() from outs=
ide
> > > > KVM_RUN.
> > >
> > > Yeah, replace "in response to page faults" with something along the l=
ines of "if
> > > an access in guest context ..."
> >
> > Alright, how about
> >
> > + KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS
> > + The presence of this capability indicates that userspace may pass the
> > + KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS flag to
> > + KVM_SET_USER_MEMORY_REGION. Said flag will cause KVM_RUN to fail (-EF=
AULT)
> > + in response to guest-context memory accesses which would require KVM
> > + to page fault on the userspace mapping.
> >
> > Although, as Wang mentioned, USERFAULT seems to suggest something
> > related to userfaultfd which is a liiiiitle too specific. Perhaps we
> > should use USERSPACE_FAULT (*cries*) instead?
>
> Heh, it's not strictly on guest accesses though.

Is the inaccuracy just because of the KVM_DEV_ARM_VGIC_GRP_CTRL
disclaimer, or something else? I thought that "guest-context accesses"
would capture the flag affecting memory accesses that KVM emulates for
the guest as well, in addition to the "normal" EPT-violation -> page
fault path. But if that's still not totally accurate then you should
probably just spell this out for me.

> At this point, I'm tempted to come up with some completely arbitrary name=
 for the
> feature and give up on trying to describe its effects in the name itself.

You know, Oliver may have made an inspired suggestion a while back...

On Mon, Mar 20, 2023 at 3:22=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> I couldn't care less about what the user-facing portion of this thing is
> called, TBH. We could just refer to it as KVM_MEM_BIT_2 /s

> > On Wed, Jun 14, 2023 at 2:20=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
>
> We'll need a way to way for KVM to opt-out for kvm_vcpu_map(), at which p=
oint it
> makes sense to opt-out for kvm_vm_ioctl_mte_copy_tags() as well.

Uh oh, I sense another parameter to __gfn_to_pfn_memslot(). Although I
did see that David Stevens has been proposing cleanups to that code
[1]. Is proper practice here to take a dependency on his series, do we
just resolve the conflicts when the series are merged, or something
else?

[1] https://lore.kernel.org/kvm/20230824080408.2933205-1-stevensd@google.co=
m/

> > 3. I don't think I've caught parts of the who-calls tree that are in
> > drivers/. The one part I know about is the gfn_to_pfn() call in
> > is_2MB_gtt_possible() (drivers/gpu/drm/i915/gvt/gtt.c), and I'm not
> > sure what to do about it. Again, doesn't look like a guest-context
> > access.
>
> On x86, that _was_ the only one.  You're welcome ;-)
>
> https://lore.kernel.org/all/20230729013535.1070024-9-seanjc@google.com

Much obliged :D
