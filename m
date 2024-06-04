Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A3D142651
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 08:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717489498; cv=none; b=PE67GKOJ7CehKn94nqmt6ld0hFeWVDeTbqghhBkDMuNc8FgB3JTOj5docDMwi0Y9uFpGDdBoD/mugl5XToqiUBJ0qaPfuvsF/wAcfn89CWy4Cy1FdhgdJagBAAr9Wv8FijZY5vxcXgncz5yWNLktKJaLjSBecP+FPeWlscjpRkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717489498; c=relaxed/simple;
	bh=YgG8+8m86PBurAy/qhUvsHtO0+WuMFqkxGT+SNnIwFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lphArXmDCw2ytEbTE+A+faR3h9+JhZdzRATWuxav+cu6dh+RAwPFURu0INOMUE8G/L1HwylTNO9HkRYZIDiHnbfN9I3BQDI9GKATihz5jf2KA6/3bPPKbb/fs4N/b9ZfwE+xWlnhFiwDLNXWtdEaXXkh6moDKGGAUi1n3yZND7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zEcptAKb; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zEcptAKb"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-48bdd56b454so205909137.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Jun 2024 01:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717489496; x=1718094296; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwTDeaVvPjkK5Pu4FTYw+/GDejQugGhSaVoW4CU0vdA=;
        b=zEcptAKbGt4EVwvQ+QufL4Tta8uOZu2TvigGNTAlyPxpPdXB+SQiP7BI6KSzGRx7EN
         BfuSvJFNBGRHX2e10qJt1gmUjp8RL/CkpD6JMc9rESrDvoK8u411okNJ6nR+cJQt4URM
         QSWgnYrnWVluLUoaFLTb672Smq+U6PX5vFEYPAZc/hyuhhsmnzeVVg/wcatvxq/P5huo
         o49z0/Em20f8evOXcRq+FNK7Ec6wDIEiR2qKp+wpDgn3O4OhfXdtjJvpzwc0p6qJ+Mzs
         97HOKiZAYxtWBZVFExtqQi0rwEsez4pZlD4Y5uUPYogApGjQIC8mrdOjl7KPDp/r6pqi
         tKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717489496; x=1718094296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FwTDeaVvPjkK5Pu4FTYw+/GDejQugGhSaVoW4CU0vdA=;
        b=PvOXigPlwBQ/PS1ZY2i2b3zlsLdEFPrCONxSCnDUVwrMzPjay0N1VdwHnTO1u06C3E
         KCGnMdKW7EGKYN4eLFWOwgi/V9jppEsdGNsD22GJE0Dj0nOZc3kdXBi9BEmajQmPVd4p
         OVslo2YLtWM25zPg1YiztAIu4UK/RD5DFRZgH/Y0+nUFERLyE4TvhEfx2rr1kF8O+KQn
         46mBKwp/UizDf/DWenHMYFQ0aLlMQerVQ5Y7oRLqVvibFVG7vw5Dgtz6BnxPkyMe9rz0
         LSgyd2+OLbsi8muiEqV3UA4WArriRUXjB9jJBQFZ4MOrenX9Iu49OAO3XhmP0VqIAmEZ
         y6hw==
X-Gm-Message-State: AOJu0YzAzt21Mf9f13uoPneDy3Jf+5wMVnccStPjlxpCDhtLl6lK88xQ
	np0i9x7FvWzJ8pCzL4B7SubWPPMXZaf2rBAqp2drRxR4RwwBNpxwdubZOmZ4tiedPRZIP+Q8mUm
	1w6jC16SxsBNYgdjzyNAswlhuXuAZIwz6RVyHv4A08gMmlMdbog==
X-Google-Smtp-Source: AGHT+IHuY0v9KlwvHnt4oVW8Fkesn9sMKG6dVnOGbgLd61MgXU1s1Qj5vg8JOW/xa+Gp0ouYQzsg6wYhlr0FXSwfW+Y=
X-Received: by 2002:a05:6102:5125:b0:48b:b2ee:1576 with SMTP id
 ada2fe7eead31-48bc20f349amr12486424137.2.1717489495216; Tue, 04 Jun 2024
 01:24:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com> <20240603122852.3923848-6-tabba@google.com>
 <54ceca2b-ca7b-4046-8155-46623f829bf9@sirena.org.uk>
In-Reply-To: <54ceca2b-ca7b-4046-8155-46623f829bf9@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Jun 2024 09:24:18 +0100
Message-ID: <CA+EHjTxdNdquxD=g4OMazCNf_+ZUg8b31PNov1RmVbF=u4YdtA@mail.gmail.com>
Subject: Re: [PATCH v4 5/9] KVM: arm64: Allocate memory mapped at hyp for host
 sve state in pKVM
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

On Mon, Jun 3, 2024 at 3:50=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Mon, Jun 03, 2024 at 01:28:47PM +0100, Fuad Tabba wrote:
>
> >  {
> >       if (system_supports_sve()) {
> >               kvm_sve_max_vl =3D sve_max_virtualisable_vl();
> > +             kvm_host_sve_max_vl =3D sve_max_vl();
> > +             kvm_nvhe_sym(kvm_host_sve_max_vl) =3D kvm_host_sve_max_vl=
;
>
> As discussed on the prior version this either needs to be the maximum
> available physical VL on any individual PE or the hypervisor needs to
> use this VL explicitly when saving/restoring host state.

Sorry it took me a while, but I understand what the issue is now. I'll
send a patch to fix this.

Thanks for being patient with me,
/fuad
