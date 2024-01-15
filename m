Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F52101CA
	for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y4S+Xe6h"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2cdb50d8982so21080771fa.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 13:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705355597; x=1705960397; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srI+QJCcaSdOGmilFvhJukBBrNbYl/iiFTS82slCDmA=;
        b=Y4S+Xe6hv/0Rin03Gh4iWNA9DfEEQP9hezpZvM6yzxntkJP3vfxfxi2dcfIF3VsvZX
         zIXIDl0uZ80H4KU32oN4tg9gIRy/qu7PTYJnXkMQymAVFo4FU9kyvu/pKAusLWo37wXg
         5PSypGhkMv2eGnBnO3uJzAIYqptVVJsBAKlayQh2dFH3u/rZ+LF/uWJTmQ7m7zgp0dbG
         uH3B5vcueh4uWce+TZgwkZCapRv1XycrGIcz9ItUbVSxxtDx3GDk35RRdmJUKS4c/s9W
         fIhpKX9T+qoINzUK12dMcHuoee1cBRh+eP/FaoYJJSMUF5ugYKEDXnVoM+ngaqI13Mid
         STmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705355597; x=1705960397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=srI+QJCcaSdOGmilFvhJukBBrNbYl/iiFTS82slCDmA=;
        b=k5Wmk7d2JAtv8fkBvHKjKO6rWslB8llmPT9NtIWt6OoDSVpercp1MY3f5w1svqYANC
         HK3jKb0sdTLQ1uLYUBbdpOCeQfNlCKguOJml9TWmxH0fdjYGy++KgLr75Oz4rnraa4/R
         NAOhT1eNbF6n6/H8RseBuDwQEfemw/WJJ2zbldGNwREREaMn8XWDoT5UqoaW1bcmzB32
         hCq5rJGgx+9Cw7FiPhKY0VlV+eN5CnoCkvdy0RRCb1NV0wrqWcFGzbz/+612HoWiOPYD
         AIr8utvnxAK8kTXk2G5mCuIb6ZfL1eikVP9yXVh0ZGwakljxlDfK0G/+cN5/9gZFdHVF
         hl5Q==
X-Gm-Message-State: AOJu0YwLOlAfkjq7+YVxD0NOKV/8fMbd+WZAxAzSQRXynkN8hJC4mavc
	gJqpK7Ukw7qqd9jK0n4uBboUzLlDuaSQdG2PYTv+0He7kasU
X-Google-Smtp-Source: AGHT+IFzcXqZv7MAO5YZ5RVCYAl39JUV9v/r8FCKcNCkLlUAAv/DZU4c6ysxX0gO0iB9+zMFIXIpa8ACAE1KGOO/fug=
X-Received: by 2002:a2e:5c44:0:b0:2cd:1d6e:74c9 with SMTP id
 q65-20020a2e5c44000000b002cd1d6e74c9mr2574217ljb.48.1705355597248; Mon, 15
 Jan 2024 13:53:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240109165622.4104387-1-jingzhangos@google.com> <4e3c051b-ccdb-47d4-9a29-5c92f5101a06@arm.com>
In-Reply-To: <4e3c051b-ccdb-47d4-9a29-5c92f5101a06@arm.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 15 Jan 2024 13:53:04 -0800
Message-ID: <CAAdAUtjPKv08ymo1ydJpigqmOWCAw7dqyKqmYVg4jcbc3MQE5g@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Handle feature fields with
 nonzero minimum value correctly
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Itaru Kitayama <itaru.kitayama@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Suzuki,

On Mon, Jan 15, 2024 at 1:34=E2=80=AFAM Suzuki K Poulose <suzuki.poulose@ar=
m.com> wrote:
>
> On 09/01/2024 16:56, Jing Zhang wrote:
> > There are some feature fields with nonzero minimum valid value. Make
> > sure get_safe_value() won't return invalid field values for them.
> > Also fix a bug that wrongly uses the feature bits type as the feature
> > bits sign causing all fields as signed in the get_safe_value() and
> > get_invalid_value().
> >
> > Fixes: 54a9ea73527d ("KVM: arm64: selftests: Test for setting ID regist=
er from usersapce")
> > Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> > Reported-by: Itaru Kitayama <itaru.kitayama@linux.dev>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >   .../selftests/kvm/aarch64/set_id_regs.c       | 20 +++++++++++++++---=
-
> >   1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/=
testing/selftests/kvm/aarch64/set_id_regs.c
> > index bac05210b539..f17454dc6d9e 100644
> > --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> > +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> > @@ -224,13 +224,20 @@ uint64_t get_safe_value(const struct reg_ftr_bits=
 *ftr_bits, uint64_t ftr)
> >   {
> >       uint64_t ftr_max =3D GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0)=
;
> >
> > -     if (ftr_bits->type =3D=3D FTR_UNSIGNED) {
> > +     if (ftr_bits->sign =3D=3D FTR_UNSIGNED) {
> >               switch (ftr_bits->type) {
> >               case FTR_EXACT:
> >                       ftr =3D ftr_bits->safe_val;
> >                       break;
> >               case FTR_LOWER_SAFE:
> > -                     if (ftr > 0)
> > +                     uint64_t min_safe =3D 0;
> > +
> > +                     if (!strcmp(ftr_bits->name, "ID_AA64DFR0_EL1_Debu=
gVer"))
> > +                             min_safe =3D ID_AA64DFR0_EL1_DebugVer_IMP=
;
> > +                     else if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_Cop=
Dbg"))
> > +                             min_safe =3D ID_DFR0_EL1_CopDbg_Armv8;
>
> Instead of hardcoding the safe value here in the code, why not "fix" the
> safe value in the ftr_id table and use ftr_bits->safe_val for both the
> above cases ?
>

SGTM. Will do.
> > +
> > +                     if (ftr > min_safe)
> >                               ftr--;
> >                       break;
> >               case FTR_HIGHER_SAFE:
> > @@ -252,7 +259,12 @@ uint64_t get_safe_value(const struct reg_ftr_bits =
*ftr_bits, uint64_t ftr)
> >                       ftr =3D ftr_bits->safe_val;
> >                       break;
> >               case FTR_LOWER_SAFE:
> > -                     if (ftr > 0)
> > +                     uint64_t min_safe =3D 0;
> > +
> > +                     if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_PerfMon"=
))
> > +                             min_safe =3D ID_DFR0_EL1_PerfMon_PMUv3;
> > +
> > +                     if (ftr > min_safe)
> >                               ftr--;
>
> Also, here, don't we need to type case both "ftr" and min_safe to
> int64_t for signed features ?

They are all used as unsigned on purpose. That's why the handling for
signed features are handled in different cases.
>
> Suzuki
>
> >                       break;
> >               case FTR_HIGHER_SAFE:
> > @@ -276,7 +288,7 @@ uint64_t get_invalid_value(const struct reg_ftr_bit=
s *ftr_bits, uint64_t ftr)
> >   {
> >       uint64_t ftr_max =3D GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0)=
;
> >
> > -     if (ftr_bits->type =3D=3D FTR_UNSIGNED) {
> > +     if (ftr_bits->sign =3D=3D FTR_UNSIGNED) {
> >               switch (ftr_bits->type) {
> >               case FTR_EXACT:
> >                       ftr =3D max((uint64_t)ftr_bits->safe_val + 1, ftr=
 + 1);
> >
> > base-commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a
>

Thanks,
Jing
