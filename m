Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6B9107A7
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 23:00:28 +0000 (UTC)
Received: by mail-qk1-f171.google.com with SMTP id f8so184609qkg.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Nov 2022 15:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cmFG+lMjzf/ZVIEgSvSUi/Kw8nPzVjb1fGFMbu/W5vY=;
        b=dudkNi4O683uD+TNndcPtPCeCpa9QA7FbrHjaVOmIRg+UIGVhAfjaXmH9wBmtQDeLP
         uNHcUO7j+uCpDHYxGSZ329F4Pqk6v23Tz3bL13gqm3RiGz3qJQ/5WwLouTw/AcT5Af9A
         rQwCxIpQ+YDTTjArHhx2QEoIvvIdpsL61e+NndZ9oI8EQss2i6rc9Xfaom1mQcgOEuKg
         X725WqyvZrKDxE82nLTfL2duzd2WFlc4dcdajM8jpWTqjR8pxMwjOHMgSw7/94Xya4Fw
         OtHNgVbPfchbdE78tQKPU3oB9S3RIz76UsqxoZzTcwc1Vr43CTJ+spRrWppH+q9QCzYf
         4lBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cmFG+lMjzf/ZVIEgSvSUi/Kw8nPzVjb1fGFMbu/W5vY=;
        b=k4y1ksnIg+kh6Tyja5iWh6NRTRuKfam1+yrRuVpOLOSH0FNx2LiyaKhmIbTJkjxWyZ
         8tWDKmgoKt+r+VspW/ImAbHVD77V3+BdOhZdE6b/a1G9FzPWz+voe++fbQX8DHZAj6X/
         QBSTwj3dPPuVzNeygJtBc0kv/xm/J7lPIFinD5sa8Ll1gOEyS/WVF9c4+yPxJk3DN97j
         TLe00TB+orwEMnPIbhYCftArvQqGLqAEBkkD2m9A4/eNhKVYv8AoL+PaeH0i9py9AYt8
         xBYe0rmcUidNZPe0KRAckRcrUIpZd4TUW+FIc0nd0G618lU16SCCvslU7p739BuJ7Ld0
         9UGQ==
X-Gm-Message-State: ACrzQf0OWqP+xYSELoff8BdsZY/XkxJ9Pps9FjglbMSNzK/VBeh69TjG
	LQDZ80217Y5ZwdwWXpB189xyjQiMVC6jYWLsiJA/+Q==
X-Google-Smtp-Source: AMsMyM4kdVFylTXfA6FM8xY8axVjaBWiaQEF+FUnFYjRSXBpMV5wYMwqbp4Gdq5EBHSBdeNF/gET466fMdMwNRFqj/U=
X-Received: by 2002:ae9:eb48:0:b0:6fa:d61:4510 with SMTP id
 b69-20020ae9eb48000000b006fa0d614510mr43595869qkg.768.1668034827137; Wed, 09
 Nov 2022 15:00:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-10-oliver.upton@linux.dev> <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
 <Y2wswsHgDHIIXram@google.com>
In-Reply-To: <Y2wswsHgDHIIXram@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 15:00:16 -0800
Message-ID: <CANgfPd_=6r1pmuNbrEdiom4JpryUBkVxxxmKTCN+xfiAQYrP0w@mail.gmail.com>
Subject: Re: [PATCH v5 09/14] KVM: arm64: Atomically update stage 2 leaf
 attributes in parallel walks
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>, 
	Ricardo Koller <ricarkol@google.com>, David Matlack <dmatlack@google.com>, 
	Quentin Perret <qperret@google.com>, Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221109230016.xKz7UqEs4kMU8pXqnJ54ye97YdVy-TAZDqb-Y4XtEuY@z>

On Wed, Nov 9, 2022 at 2:42 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 09, 2022, Ben Gardon wrote:
> > On Mon, Nov 7, 2022 at 1:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > @@ -1054,7 +1066,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
> > >  bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
> > >  {
> > >         kvm_pte_t pte = 0;
> > > -       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
> > > +       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, 0);
> >
> > Would be nice to have an enum for KVM_PGTABLE_WALK_EXCLUSIVE so this
> > doesn't just have to pass 0.
>
> That's also dangerous though since the param is a set of flags, not unique,
> arbitrary values.  E.g. this won't do the expected thing
>
>         if (flags & KVM_PGTABLE_WALK_EXCLUSIVE)
>
> I assume compilers would complain, but never say never when it comes to compilers :-)

Yeah, I was thinking about that too. IMO using one enum for multiple
flags is kind of an abuse of the enum. If you're going to put multiple
orthogonal flags in an int or whatever, it would probably be best to
have separate enums for each flag. That way you can define masks to
extract the enum from the int and only compare with == and != as
opposed to using &.
