Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510B433C9
	for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 20:33:06 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d23-20020aa78697000000b005a9b2e7702dso654436pfo.8
        for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 12:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3cWU4YaTlf2UhXKjrN1L30IZIkoSCB1BD9HAZEO2O34=;
        b=VcXUa7EhmYLBs+ePYWZMQV8OZnL82Z8DyQSl1EWdMegEl00omMjSrq3F3DMgREAO59
         L/TwjBy0nLdJOS+9odlymeLdBRPVTfbGN81vaPsaec9pcZ4Mkc7mccaYquBfebY944fx
         fBL2+s7yBre/tS0+9j7Q57aSC8jsf5LCh6lYvyQi/pgUE79gvMQzMRkQPLM5riLYHHVz
         O+zzo1oeaV5JJ6qVsChJtCoG3HuHScxCauqSUL0njHozd0Q3Pj5RM7X5QYNr+gl3mswh
         VCiOtQMVtDmKUQ4c7wPtOiAabIyIBNQplPYJdYkLEyFVRJ1F/mCJHhaoybW/lhvyeZWb
         jjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3cWU4YaTlf2UhXKjrN1L30IZIkoSCB1BD9HAZEO2O34=;
        b=MKL/CM33PFg9fMIFB6XXpDW7VtYnmvlVVcbPRy0R6gnWPb9n//jezWVvfYXrhA41NR
         dXo81T9phs48bXjGNHkUzmPScv+CW320bhrbbUjE6nAuEfBgzc4/T/6cT8a1YHLA7SRI
         FVv+czqPc8irXOfvyqKilUKU8O3Fgf7H9WSUTNpbeDD48YqxN9qKVKdmPvpNTxl2TQak
         UdobEVwU1adF3KS8lmg5MKJ1i4OsY1DoZJhIIaKTX6r27aW+jk3PpQlENYKOe4G6iOda
         TqHlSC1xbomdSVE5sWfiPAXFU+y6P/P0pXI+DcXOpLsoLLPczkMLlwl7o5XXvN51gBqZ
         h24w==
X-Gm-Message-State: AO0yUKVaigobxJJdI/Yix2kg3XGbyKtvVUWrLAHyL1uuJq77pc7MW1+Z
	WHH7lr+Q0skBRP+7ahlAtjZpoCAygbA=
X-Google-Smtp-Source: AK7set+B4C+zq8huZ3NcArYooa+U3Mp9foscElC4vL4yxwAcZdjr86jqIYUaycd8VpRKPDtnwMJC0jD/5hg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:878e:0:b0:596:78f:1532 with SMTP id
 i136-20020a62878e000000b00596078f1532mr352202pfe.2.1676665985704; Fri, 17 Feb
 2023 12:33:05 -0800 (PST)
Date: Fri, 17 Feb 2023 12:33:04 -0800
In-Reply-To: <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
 <Y+6iX6a22+GEuH1b@google.com> <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
Message-ID: <Y+/kgMxQPOswAz/2@google.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Houghton <jthoughton@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	peterx@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17, 2023, Anish Moorthy wrote:
> On Thu, Feb 16, 2023 at 10:53=E2=80=AFAM Anish Moorthy <amoorthy@google.c=
om> wrote:
> >
> > On Wed, Feb 15, 2023 at 12:59 AM Oliver Upton <oliver.upton@linux.dev> =
wrote:
> > >
> > > How is userspace expected to differentiate the gup_fast() failed exit
> > > from the guest-private memory exit?

Sorry, missed this comment first time around.  I don't see any reason why u=
serspace
needs to uniquely identify the gup_fast() case.  Similar to page faults fro=
m
hardware, KVM should describe the access in sufficient detail so that users=
pace
can resolve the issue, whatever that may be, but KVM should make any assump=
tions
about _why_ the failure occurred. =20

gup_fast() failing in itself isn't interesting.  The _intended_ behavior is=
 that
KVM will exit if and only if the guest accesses a valid page that hasn't ye=
t been
transfered from the source, but the _actual_ behavior is that KVM will exit=
 if
the page isn't faulted in for _any_ reason.  Even tagging the access NOWAIT=
 is
speculative to some degree, as that suggests the access may have succeeded =
if
KVM "waited", which may or may not be true.

E.g. see the virtiofs trunctionation use case that planted the original see=
d for
this approach: https://lore.kernel.org/kvm/20201005161620.GC11938@linux.int=
el.com.

> > > I don't think flags are a good idea for this, as it comes with the
> > > illusion that both events can happen on a single exit. In reality, th=
ese
> > > are mutually exclusive.

They aren't mutually exclusive.  Obviously KVM will only detect one other t=
he
other, but it's entirely possible that a guest could be accessing the "wron=
g"
flavor of a page _and_ for that flavor to not be faulted in.  A smart users=
pace
should see that (a) it needs to change the memory attributes and (b) that i=
t
needs to demand the to-be-installed page from the source.

> > > A fault type/code would be better here, with the option to add flags =
at
> > > a later date that could be used to further describe the exit (if
> > > needed).
> >
> > Agreed.

Not agreed :-)

> > +    struct {
> > +        __u32 fault_code;
> > +        __u64 reserved;
> > +        __u64 gpa;
> > +        __u64 size;
> > +    } memory_fault;
> >
> > The "reserved" field is meant to be the placeholder for a future "flags=
" field.
> > Let me know if there's a better/more conventional way to achieve this.
>=20
> On Thu, Feb 16, 2023 at 10:53=E2=80=AFAM Anish Moorthy <amoorthy@google.c=
om> wrote:
> >
> > 1. As Oliver touches on earlier, we'll probably want to use this same f=
ield for
> >    different classes of memory fault in the future (such as the ones wh=
ich Chao
> >    is introducing in [1]): so it does make sense to add "code" and "fla=
gs"
> >    fields which can be used to communicate more information to the user=
 (and
> >    which can just be set to MEM_FAULT_NOWAIT/0 in this series).
>=20
> Let me walk back my responses here: I took a closer look at Chao's series=
, and
> it doesn't seem that I should be trying to share KVM_EXIT_MEMORY_FAULT wi=
th it
> in the first place. As far as I can understand (not that much, to be clea=
r :)
> we're signaling unrelated things, so it makes more sense to use different=
 exits
> (ie, rename mine to KVM_EXIT_MEMORY_FAULT_NOWAIT). That would prevent any
> potential confusion about mutual exclusivity.

Hard "no" on a separate exit reason unless someone comes up with a very com=
pelling
argument.

Chao's UPM series is not yet merged, i.e. is not set in stone.  If the prop=
osed
functionality in Chao's series is lacking and/or will conflict with this UF=
FD,
then we can and should address those issues _before_ it gets merged.
