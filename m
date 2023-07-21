Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5D14F6A
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 08:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689928709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NwNy9iOU1ioDiJtC0wNNa3aEUmMXumdBTFbQ/HwLllU=;
	b=FAQDH2Q0cpSc5oacdwSCknYjAnlS3HXnjj9Db7SlCM/2F4pcNoycTLCM56EJdRw/Es2UoN
	CrHl2lfUfiV08WZ5fsTORmMbKy3GtuCqm+P06tCXF2RtLPt6ikX4Z6bPY6/1o9WTBxCh6C
	RtWeg+LRx4Cexnavh1DITiK5KY3gDs4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-Blr1Gv_KOaS1Li0WyBAPWQ-1; Fri, 21 Jul 2023 04:38:25 -0400
X-MC-Unique: Blr1Gv_KOaS1Li0WyBAPWQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8C88936D20;
	Fri, 21 Jul 2023 08:38:24 +0000 (UTC)
Received: from localhost (unknown [10.39.193.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E20A492B02;
	Fri, 21 Jul 2023 08:38:24 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, ARMLinux
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, Reiji Watanabe
 <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, Suraj
 Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
In-Reply-To: <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com>
 <87o7k77yn5.fsf@redhat.com>
 <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Fri, 21 Jul 2023 10:38:23 +0200
Message-ID: <87sf9h8xs0.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9

On Thu, Jul 20 2023, Jing Zhang <jingzhangos@google.com> wrote:

> Hi Cornelia,
>
> On Thu, Jul 20, 2023 at 1:52=E2=80=AFAM Cornelia Huck <cohuck@redhat.com>=
 wrote:
>>
>> On Tue, Jul 18 2023, Jing Zhang <jingzhangos@google.com> wrote:
>>
>> > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
>> > from usrespace with this change.
>>
>> Typo: s/usrespace/userspace/
> Thanks.
>>
>> >
>> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index 053d8057ff1e..f33aec83f1b4 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -2008,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[]=
 =3D {
>> >         .set_user =3D set_id_dfr0_el1,
>> >         .visibility =3D aa32_id_visibility,
>> >         .reset =3D read_sanitised_id_dfr0_el1,
>> > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
>> > +       .val =3D GENMASK(63, 0), },
>> >       ID_HIDDEN(ID_AFR0_EL1),
>> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
>> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
>> > @@ -2057,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[]=
 =3D {
>> >         .get_user =3D get_id_reg,
>> >         .set_user =3D set_id_aa64dfr0_el1,
>> >         .reset =3D read_sanitised_id_aa64dfr0_el1,
>> > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
>> > +       .val =3D GENMASK(63, 0), },
>> >       ID_SANITISED(ID_AA64DFR1_EL1),
>> >       ID_UNALLOCATED(5,2),
>> >       ID_UNALLOCATED(5,3),
>>
>> How does userspace find out whether a given id reg is actually writable,
>> other than trying to write to it?
>>
> No mechanism was provided to userspace to discover if a given idreg or
> any fields of a given idreg is writable. The write to a readonly idreg
> can also succeed (write ignored) without any error if what's written
> is exactly the same as what the idreg holds or if it is a write to
> AArch32 idregs on an AArch64-only system.

Hm, I'm not sure that's a good thing for the cases where we want to
support mix-and-match userspace and kernels. Userspace may want to know
upfront whether it can actually tweak the contents of an idreg or not
(for example, in the context of using CPU models for compatibility), so
that it can reject or warn about certain configurations that may not
turn out as the user expects.

> Not sure if it is worth adding an API to return the writable mask for
> idregs, since we want to enable the writable for all allocated
> unhidden idregs eventually.

We'd enable any new idregs for writing from the start in the future, I
guess?

I see two approaches here:
- add an API to get a list of idregs with their writable masks
- add a capability "you can write to all idregs whatever you'd expect to
  be able to write there architecture wise", which would require to add
  support for all idregs prior to exposing that cap

The second option would be the easier one (if we don't manage to break
it in the future :)

