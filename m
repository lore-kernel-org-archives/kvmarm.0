Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D835213C80B
	for <kvmarm@lists.linux.dev>; Thu,  6 Jun 2024 09:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717665945; cv=none; b=pNY+tRJdSRcnLI5jYOni6FtsezxaZrPnG02hncfZN2EtvQVzgbEvjQzScTtC5x/foNbLugcjxhytV/frY5ABBhWzDTo3HODCoQwovh9gePqJPL14v4TB7gDPUDd2WVmxzQ3L9EQLKisxaOrTlnQ+VuLTX950Pj9eBZtqPHV1AlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717665945; c=relaxed/simple;
	bh=yRgdSjVWaoT9hcpY+cN2FwfyvTZOgWl9TX3kjezpyBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q+eCaPEoUhtNn1/BKy7da+Y0ZBWy8QWnVx9FcpMEHfxZ9/EOu4Lt1Lbk48s4wTDvOQBzt/F4fObHFpPyKTd7UyOk+gGbk5qoJ0dnEVS0HbbhZvjo4gsAe5W2SZ5YcqC/Untr84Q9zSHATzucCasW8ATOaCWovrEI4t5BiR8SmPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W0sh7rdx; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W0sh7rdx"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-80ac76f1226so1071114241.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Jun 2024 02:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717665943; x=1718270743; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zm3IpDB6ZLqaoPrWmnW67jAKLpTWfnOETi+K8/H0g3Y=;
        b=W0sh7rdxO/ewo7twBU6OPPPTts8VuyW5qxCSZ6h6cmVu/7nqvCIow8CnYuoC2IE6pM
         Im87yqdyc6p/JtaFka6Jmg4PB7F9zoTFqRhfxe74KyX6u43C4rtcIlChT79KNe8C37s2
         CgdtwzsghZ4CIh6lD4cbH95dXUeKhPvjqeB1AlJjHdekGme7qZuxfJexz3iPKRbvRc6w
         2qem3RjglwHVPdsarGONWR4yN12I2oDTuf7iT1vODoEo8w2IrNB3EIry5IqrsNikK2Q5
         WcquN9aHgo5VdaFI4wqF9MtHp1395mZhuXldaiEyWy5i5oXs6K9yhO6xQd00B8IuP9D3
         VZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717665943; x=1718270743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zm3IpDB6ZLqaoPrWmnW67jAKLpTWfnOETi+K8/H0g3Y=;
        b=q2hWJEorbOZFHDFj4vI269CuMozLDigrYiDG3hqiLenfXU9Y4acTglkIJUUWmkGycr
         VJ7SEoxa4JjbCPi9uLx0mne1Tst15/hCOabWwasd340BUmAGCIdouR+qN1SVQkEbzXt+
         iKFtC7nNixDPeVTYrLeyLfdeZpOFvFP0olEPx4tzrqZRXW9qnMeyEnS+aFBMC4KtNBmU
         1NB2j9r3/JRFgPctzp0SqIRYUOLuReGsj4dASPeYKUh0RCBVmBP+bjw9OfK9hQdINtYo
         IXzkETwN/OZdpH0O3mQJLjd2jEimafFkChkrsFSoEzNaxbe9lvQi2mljPE/z4YItCYyk
         uvkg==
X-Gm-Message-State: AOJu0YxTPgGjuD1+ZLm9RoDSTjlSgfJ+JX4CRl8Fudyagfj+swBHwRbG
	hZgh3mzLD0kwA5FWv2eRE2PM5P42eMuXeO118yz4YNQIWpJVaDQDoZkD8mQGGSXjL1AEaFDbOZT
	SUvuSV1YKBCsHJewjdtY3+Rd315RO4BYS5kz+
X-Google-Smtp-Source: AGHT+IFj5cWMQltvncDHFkg2MtWAORDlyntkaLK6vNbVX2kZoFFFWEkGrKtr5Jy7MNqMoNXkhdRDNQJgrQtLvvq0bbc=
X-Received: by 2002:a67:f512:0:b0:48b:d977:d72d with SMTP id
 ada2fe7eead31-48c174fed98mr2261483137.12.1717665942603; Thu, 06 Jun 2024
 02:25:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605150312.3684150-1-tabba@google.com> <cff5b8a1-d837-474e-9b92-b538d7e6caae@sirena.org.uk>
 <CA+EHjTx1Z5FyKO-YMPS83whX39eDAE5G6BzPJtpa6Z1kVpXgMg@mail.gmail.com> <93b31a5d-28e1-489a-b51d-89fc16ddd0db@sirena.org.uk>
In-Reply-To: <93b31a5d-28e1-489a-b51d-89fc16ddd0db@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 6 Jun 2024 10:25:05 +0100
Message-ID: <CA+EHjTxn49GxBN0BNL+V7mheuxAUS+LtMxNpb0+TWt9q2T8d8g@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: Allocate for maximum vector length for
 pKVM host sve state
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, Jun 5, 2024 at 5:52=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Wed, Jun 05, 2024 at 05:14:23PM +0100, Fuad Tabba wrote:
> > On Wed, Jun 5, 2024 at 4:46=E2=80=AFPM Mark Brown <broonie@kernel.org> =
wrote:
> > > On Wed, Jun 05, 2024 at 04:03:12PM +0100, Fuad Tabba wrote:
>
> > > > +     /* The maximum vl encountered for any cpu in the system. */
> > > > +     int max_system_vl;
> > > > +
>
> > > As previously mentioned I'd really prefer not to call this _system_ d=
ue
> > > to the potential confusion with the maximum VL we're using.  Naming i=
s
> > > hard.
>
> > I agree :) I have no strong preference really. It's just that for me
> > max_cpu_vl sounds like it's per cpu. But now I'm just bikeshedding...
>
> seen?
>
> > > > @@ -1031,7 +1031,12 @@ static void vec_probe_vqs(struct vl_info *in=
fo,
> > > >
> > > >               vq =3D sve_vq_from_vl(vl); /* skip intervening length=
s */
> > > >               set_bit(__vq_to_bit(vq), map);
> > > > +
> > > > +             if (!max_vl)
> > > > +                     max_vl =3D vl;
> > > >       }
> > > > +
> > > > +     info->max_system_vl =3D max((int) max_vl, info->max_system_vl=
);
>
> > > It's not clear to me why we stage this in a local variable prior to
> > > updating the global value, and like I say it does feel cleaner and sa=
fer
> > > to keep the current split between enumeration of the PE and integrati=
on
> > > of the results.  This should *work* but it doesn't feel consistent wi=
th
> > > the rest of the code.
>
> > To me it felt more clear like this, but I'm fine with not doing the
> > staging first.
>
> That was the start of the thought path that lead me to implement based
> on splitting it out of vec_probe_vqs() like the rest of the code does,
> the logic doesn't really fit in here for multiple reasons.

The alternative entails duplicating code in vec_init_vq_map() and
vec_update_vq_map().

To me at least, it's straightforward to understand how max_vl is
computed if we set it as soon as we find it. This as opposed to first
having the vq bits set in a map, then in two different functions find
the first set bit in the map, which really corresponds to the vq, to
then convert it back to a vl.

Thanks,
/fuad



> >
> > >
> > > > -               kvm_host_sve_max_vl =3D sve_max_vl();
> > > > +               kvm_host_sve_max_vl =3D sve_max_system_vl();
> > >
> > > I appreciate that we're adding a host_ on the front of it but it woul=
d
> > > feel safer to keep the name of the hypervisor copy of the value
> > > consistent with where we copied it from, sve_max_vl is a different th=
ing
> > > in the host kernel.
> >
> > I agree, this should be renamed.
> >
> > Thanks!
> > /fuad
