Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792642342;
	b=myQ2qS1zuRjDg4y9oDllMjUeF6H0Is/NcEdpyQvz9IsMlEW3ZrKxQl46gnESxH5LK5SK
	 rSKSGG9vqrO7P1/Ka451sY48fEkhBJj0dbAF+h2easzzJMI6bDAeegNgWY2CtvVWscPS/
	 JM1X0/HdvK0TQhvubVHSpexyU3iyN870INw+9ArtETnPISYsmYjJiY7Nlh4paEviJwSHO
	 7DqnM1+yxSQ7fGVWiPQ794hFo8qUDdzS6Ag/s533uhhq5i9DdauEa+suF2QfNwEcK2NVi
	 c/7ZxCoE9RvPgP94EfhXI9TGVnoQvd5T/FT2r2UA28kJPHKT4bxB6t0idMmm5MIaKfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792642342;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=vprUskQTUd+SPbnT8TFojrEtK+oeOiPvhjewwpNbp/8=;
	b=KvDpBhlJ2VdTqca7+wJCjxig7ib1F/vwARYrP4eMsHFwlwpyVEcOkilBmHipexhtTwZV
	 rUp2CJmod7YMzEzPXFGFmxd8Beo8encXywNyToapzYlfCj/JAk0TCqd3gTdoGT1ZKP5iY
	 ZeQXVUuQ+CsFayBBf3yRSnxSlH6K3zhSNp+MT2mcuX4dCs2F9QiZUjdz/P4XpB7PE/52g
	 HhYEdBCTqk2xOT+GkLbkfDvIvl1++3yH90KBjy+ylUgxG/u5MabmeCvN58DzzdJOb3SHG
	 I0pgT2fTlL8XKNBOBLg2LtjagYdbxBcEd1r08Yc3Bc6qI0oJmfWsKp49gZrR3I7qqAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=URELnTGD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88428606A31D
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 04:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88428606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=URELnTGD
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b1a86c0316so1781213a12.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 21:12:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792642336; cv=none;
        d=google.com; s=arc-20260327;
        b=YxCWYCDjg71cDlW0AjUHklQgkS2rnRmWCCGh1We5fowq2mRTP5SV56WSRT2aQIWz6o
         sfCnmMnQwbiZuc0ODLSMN+41qFrK8tvYaWT4oWU/5F2QerUtNZpbZWMlQ45/nXtarBI4
         uuOqWevPZhZagB1o9HnJEQOtZdkFkOkcGZesDe4DNn56iPqtzx7FATX0THdf70RzAqLh
         J3Vx+Rl8R6bvRiMJeUzgKFGFipGRvbAbFKG9KtTPv8LbaELRblwntXUOw9NsDYXJHcEW
         EnyyXm11KtXoF3JFy+9V9rPohHIImS28dNGkuiJQX1ODejBG2ifZbkpnbqogfvQUeyEK
         saWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vprUskQTUd+SPbnT8TFojrEtK+oeOiPvhjewwpNbp/8=;
        fh=6zkAdzK4o42gqIdL4uwCoNUvMi7B4InuZ+ol5h8V/7E=;
        b=o5zke5tL6hgR04pviZOfqkekJUjdQ3NFjzL4+HKGeH8DuPMUWS1cH1u3RHU0dNhqJk
         MvozXEkP1Gn2OGhgl5pO0CA0mCbGX2ljg7DqKjBwPFwwsVXr9QgeiU1M17B7h4KtD5Hn
         gsH/m/k8+aKduL+I2qi08VQvNQu4jrAqkzbNtNdWBNrI5qia8n389Pwp0sZrzyVv4+5t
         ul4xgKPn0tadlHJJpjucueXbbxA8A0QFPo9MQZ7s1KsP5ec3N9oppb/fx5VXlTO7udOq
         ExeF714eNRK/Px8+1dz5qsG1nRZWktOMJG27gnpSXWEdafBNZrxsjJ584tcyjNU0Ldnh
         CumA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792642336; x=1793247136; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vprUskQTUd+SPbnT8TFojrEtK+oeOiPvhjewwpNbp/8=;
        b=URELnTGDTEFT3a59Exg9C44vVdmWLcMYEeJZW40MPXNL8jgW6rEXI4tjEehy8+wT3p
         Uq3LA2VIDHYpCkXF3kj+5Rvu+fGpxyekTmQTGZip9gs/NBCDR3aSXn97NdO8vMkc5/j2
         5iekOlHajKUZ6ncXC9EZeude7kX0+3jXvExKhlHe/sFwE6i8c6B4YlPGqDvvYxTYFmi6
         KyeNxE+Bb+zk6Rekv7zKceYKfB+TF0aBJebxEQHXpEnm7vqZoMZwn8Yxh1IJXyQDJlSy
         WrybG35BPzdrNEWXdkxcgHcGzCtcF5OpxB6TIguhPBLfEmE24kPfPch4/+DnBhRO/1eB
         RmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792642336; x=1793247136;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vprUskQTUd+SPbnT8TFojrEtK+oeOiPvhjewwpNbp/8=;
        b=M96E4FYld176lRne2WSAbKXj5lJwkGSbCBpgM4gPu1/sKO2UvDJW7LxwG7kjzDjG8b
         2ydDGupSOlvQW0jXbm/rkPPSwYxeuxfGTOWm9CT2i9HyADsX2Dux385kyHYV+PsEDuGQ
         NDXI7XfDN7bCxL4iyUzfZy09yw5en9PpigyAu1uB8xU12lEVvj8rmn0zR1DIdAgL27sJ
         43Po0AiNME3CBSN7s68/F0v+e6gOnjRcN0fKVdCJhprcqchdEewtxIjiI7BgmG9XM89b
         9uTlZmYn67v9fa8a6OImdAKCvvOKUoa3RUewUg/oGF7JvVdeB0JembNz4xXYh6w+XuQW
         G1pA==
X-Forwarded-Encrypted: i=1; AKwUvBwqXga5b6Y62E3PhZpoLOi1hJiczQMOVL6YygTpOuZSkrXzsLLrt0qmQ8hb9202fq//jcCxoUk=@lists.linux.dev
X-Gm-Message-State: AFq9FYJBzbvp1/zM7aKigkpJCCjd792Wp4ax6VgHzg/g3dGsKFGIhMA6
	IXgk/YdrePEkA1BApv/kJxa0t1osUSPoVC6+Lu4fDevd+1ji96Fmatpnl32aVjF/KMVKn0W75sh
	g+IgCDSQM6u9zDg6SeXshMacjYTy4NxTlgq35xjVUWg==
X-Gm-Gg: AYBFou3Mj6Y1IRt+mwHePuJD72Whx+jsnikWvkYcA8Wd7CDsDNJ3Q5nU1jQF/ueNk06
	D8PRqxGnj/Ttndw+xKTIpmxfuGc2cK/VIa/hLWRkJdZBnVaFI87RPWpz5vOKUkOhueo5BeYJDXB
	0U0f8YexHTbwsYXaGhN8mcH7b2u3PbVhMYaQczEfGo+lwbwbkjs8C1QjBsdhbgFq8CgJnXKQxqd
	bwgeEK2qytjsbdWfQu777amKA9P2bB6F+8QSxHSm+djmX/37sLmnkd9kkRwTK4tcgwx0jvas/3p
	K+pXiBESIx8BJBteHcJPSg47Lh6QV714dHQvnTgiC64IWqqjeuzn0LBb2jRQ4vjeCI57vVmyWka
	l3d8ymi0OqKG4hywBmmTbG0+DKn5UXTi4Vp0dqaSRP6TtMBiWfLKIFD/GcNB5DE86HowasYmGvf
	z8vGu8pgOpuncpqCkCzAnBdIsRKxU=
X-Received: by 2002:a05:6402:5d4:b0:6ab:e30:c9a7 with SMTP id
 4fb4d7f45d1cf-6b408e80bddmr3221542a12.10.1792642335878; Wed, 21 Oct 2026
 21:12:15 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
In-Reply-To: <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Oct 2026 00:11:39 -0400
X-Gm-Features: AclHuK_pCDHndbxcQ4IiuuWok4wCO_ZxudIta9yn_V-W6vImOs3uvaPF1BC9RHM
Message-ID: <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 11:53=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On Wed, Oct 21, 2026 at 8:32=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > On Wed, Oct 21, 2026 at 10:57=E2=80=AFPM David Matlack <dmatlack@google=
.com> wrote:
> > >
> > > On 2026-10-21 09:26 PM, Pasha Tatashin wrote:
> > > > On Wed, Oct 21, 2026 at 7:28=E2=80=AFPM David Matlack <dmatlack@goo=
gle.com> wrote:
> > > > >
> > > > > On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > > > > > On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack=
@google.com> wrote:
> > > > > > >
> > > > > > > On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.co=
m> wrote:
> > > > > > > >
> > > > > > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > > > > > >
> > > > > > > > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <taru=
nsahu@google.com> wrote:
> > > > > > > > >>
> > > > > > > > >> LUO and its file handlers validate handed-over state wit=
h monolithic
> > > > > > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change=
 to a serialized
> > > > > > > > >> structure, even an optional additive one, must bump the =
string, which
> > > > > > > > >> breaks live update between adjacent kernels. Replace the=
 string in
> > > > > > > > >> struct luo_ser with a feature header, so that the target=
 kernel can
> > > > > > > > >> accept or reject the source kernel state per feature.
> > > > > > > > >>
> > > > > > > > >> struct luo_feature_hdr is a fixed 128-byte header: the s=
erialized
> > > > > > > > >
> > > > > > > > > This patch is all wrong; 128 bytes is far too large. For =
every _ser
> > > > > > > > > struct, we only need 8 bytes instead.
> > > > > > > >
> > > > > > > > NOO, It is not. It is intended to avoid complex mess with u=
nnecessary
> > > > > > > > over-engineering.
> > > > > >
> > > > > > 128-byte per serialized struct is not starter.
> > > > > >
> > > > > > > >
> > > > > > > > >
> > > > > > > > > The first 4 bytes are the size, and the next 4 bytes are =
flags (i.e.,
> > > > > > > > > 30 feature flags + 2 reserved bits for flags extension). =
The last two
> > > > > > > > > bits of the flags indicate whether an extended flags fiel=
d is present.
> > > > > > > > > Each extended flags field is 8 bytes, and its last two bi=
ts indicate
> > > > > > > > > that yet another extended flags field follows.
> > > > > > > >
> > > > > > > > If we will have dynamic extension of flags, Think about thi=
s.
> > > > > > >
> > > > > > > To support dynamic extensions in a backward compatible way yo=
u want
> > > > > > > something like this:
> > > > > > >
> > > > > > > struct luo_feature_hdr {
> > > > > > >    size
> > > > > > >    flags
> > > > > >
> > > > > > __u32 size
> > > > > > __u32 flags
> > > > > >
> > > > > > >    extensions  // offset of first luo_feature_extensions (or =
0)
> > > > > >
> > > > > > __u64 extensions[0]  --> but the size should be specificed in
> > > > > > declaration macro that I showed in the next patch.
> > > > >
> > > > > I think you may have misunderstood what I meant. In my proposal,
> > > > > extensions is an offset to the first extension, not an array of
> > > > > extensions that immediately follow the header.
> > > > >
> > > > > If the extensions immediately follow the header, then the number =
of
> > > > > extensions is baked into the struct layout. Every field after the=
m sits
> > > > > at an offset that depends on how many extensions there are. If we=
 ever
> > > > > need one more extension, all the fields shift and old and new ker=
nels
> > > > > can no longer read each other's struct. That is the problem Tarun
> > > >
> > > > We can structure it cleanly by nesting the payload: something like
> > > > struct { struct header {...}h; struct serialize_data { ... }p; };
> > > > That way, the header can expand dynamically at the front, while all
> > > > fields inside `serialize_data` stay at fixed offsets relative to th=
e
> > > > start
> > > > of the payload.
> > > >
> > > > Since the header size is self-describing via continuation bits (e.g=
.,
> > > > the last two bits indicating whether another flag word follows), LU=
O
> > > > can
> > > > easily compute where the payload begins in the incoming blob. This
> > > > keeps the implementation simple, avoids linked lists of offsets.
> > >
> > > Oh interesting. I agree a dynamically sized header at the front can w=
ork
> > > and is simpler than a linked list.
> > >
> > > So the header and the payload need to be separate, and the payload is
> > > located with pointer arithmetic on the header. For example:
> > >
> > > struct luo_ser_hdr {
> > >     u32 size;    /* Size of the payload in bytes */
> > >     u32 flags;    /* Bits [31:30] indicate an extension word follows =
*/
> > >     /* u64 extension words follow while the continuation bits are set=
 */
> > > };
> > >
> > > /* Size of the header, including any extension words. */
> > > size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr);
> > >
> > > static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> > > {
> > >     return (void *)hdr + luo_ser_hdr_size(hdr);
> > > }
> > >
> > > On preserve:
> > >
> > >     hdr =3D kho_alloc_preserve(luo_ser_hdr_size_for(nr_ext) + sizeof(=
*ser));
> > >     luo_ser_hdr_init(hdr, sizeof(*ser), ...);
> > >     ser =3D luo_ser_payload(hdr);
> > >     ...
> > >     args->serialized_data =3D virt_to_phys(hdr);
> > >
> > > On retrieve:
> > >
> > >     hdr =3D phys_to_virt(args->serialized_data);
> > >     err =3D luo_ser_hdr_validate(hdr, ...);
> > >     if (err)
> > >         return err;
> > >
> > >     ser =3D luo_ser_payload(hdr);
> > >
> > > What would size mean in luo_ser_hdr? The size of the payload or the s=
ize
> > > of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing=
 so
> > > maybe it's just the size of the payload?
> >
> > > What would size mean in luo_ser_hdr? The size of the payload or the s=
ize
> > > of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing=
 so
> > > maybe it's just the size of the payload?
> >
> > Either works, but having size cover the combined hdr + payload
> > provides a few extra guarantees:
> >
> > 1. A single static_assert validates the entire serialized struct at
> > compile time, including the header and the number of ext_flags
> > elements.
> > 2. Bounds checking while traversing the header continuation bits on
> > retrieve: we can sanity-check that luo_ser_hdr_size(hdr) <=3D hdr->size
> > so we never walk past the end of the serialized blob if there is
> > memory corruption.
> >
> > If we declare the payload struct separately and pass it into the
> > macro, handlers also get a clean type for luo_ser_payload(hdr):
> >
> > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count, payload_t=
ype) \
> >     struct name {                                                      =
     \
> >         __u32 size;                                                    =
     \
> >         __u32 flags;                                                   =
     \
> >         __u64 ext_flags[ext_flags_count];                              =
     \
> >         payload_type payload;                                          =
     \
> >     };                                                                 =
     \
> >     static_assert(sizeof(struct name) =3D=3D (expected_size),          =
         \
> >                   "LUO struct " #name " size mismatch!")
> >
> > For example:
> >
> > struct luo_memfd_payload {
> >     __u64 pos;
> >     __u64 size;
> > };
> >
> > DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);
>
> This looks pretty reasonable but I would name the payload
> luo_memfd_ser. The combined struct that DECLARE_LUO_SER() creates
> should never be used directly since the offset of the payload in that
> struct is only valid in the current kernel. So I would give that
> struct a special name that makes it obvious you shouldn't be using it.

Lets drop the fourth macro argument and generate the combined struct name:

#define DECLARE_LUO_SER(name, expected_size, ext_flags_count)              =
\
    struct name##_hdr {                                                    =
\
        __u32 size;                                                        =
\
        __u32 flags;                                                       =
\
        __u64 ext_flags[ext_flags_count];                                  =
\
        struct name payload;                                               =
\
    };                                                                     =
\
    static_assert(sizeof(struct name##_hdr) =3D=3D (expected_size),        =
    \
                  "LUO struct " #name " size mismatch!")

For example:

struct luo_memfd_ser {
    __u64 pos;
    __u64 size;
};

DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);
