Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9581146AEFC
	for <kvmarm@lists.linux.dev>; Tue, 20 Jan 2026 15:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768922897; cv=pass; b=YO3Fv9H4Yr4W6HXmtNKD6mYG6LKcZv4MqmUWApWGBXu7nE4BUGW+GF7l8lqndcYZXFevzYmDI9GaJ0Nc27M6yKLQFNMqVlri2xM8BHTM0CAVsizBUVCH1W6ZYRfCMMqA3YNp6HKCY92obkYn5tZ51cf9+y4NoAwMquOuCsQQeTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768922897; c=relaxed/simple;
	bh=CjZdxht1enMOf+3v9JjMW2617y8WRsmePW7pLjxbFhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bFd/19mhli3nOg1g9vfVB38FvhmISNN1LVgBqJc002ZyTxjXzdiKeptOTAq15krLvFiKV2/ua8V1i48bFBCyoYGk4drWjIwaMLf2wUT99h9/mpW2yCoA0kbgOVArhCYf8hjhPpQpAH3dDJ4iBHRwExgSGxXrpA8D1Wq9sI77Wwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p3Dkk6nc; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p3Dkk6nc"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so11238875a12.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Jan 2026 07:28:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768922893; cv=none;
        d=google.com; s=arc-20240605;
        b=YRDdcWUb4/0vxkp4xH8F5HI55BaXYlKXJWNinI7i6JlnrDpDl0AoYbYGGh0ZB9DiZs
         R45+Ey4rOhyJebcxwSum3RLxPtbJFXVUQxMRy/9uY6NnmdAkzqqSLFcNlBuv7VpCEuzC
         LTyE5poklc0RNjgLasmebW8t2VRM6Eg+FUyfYGohNdflWYOjfWnNvQDJty4H5ejy5/KJ
         w3NBwzyXvbPAdCRdJttDYAG23/jJrhkqumhTIPfCpZsSzKWWD2CY4/67/bQ2S9jiKqEt
         J7kx1zvFh54H0pOKPmpZAuj1qNFhMBKMQnx11qPyu0Mcy0WDHLefBFIAGuGAKnD9u3k3
         nwAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I1zCNGgef8h4dx5wfQYzWOmcIl2PEe8tEJazBc1BpM8=;
        fh=v1CPlbnAf9i2iV/Uxqi2D7qUSMSHD7izCot+OcKKofY=;
        b=jWf2S7HK4KbsMTa1u27pReYLkf7ok/kXL6gXEYFgh9OJOBYMnsyB73b9a0JHH5dIbV
         sDclFMt5JNB8sreIfZiXKxlaOvrYAcUmFqMQaXSIIQl3UVPnXz9IMBr8PtjvYfGsucfk
         w5CHFJsJ3R02GHk5iVCCCGpguzHRFHKtSyVxNoY0ADkUfP8qtfBex12wmU+Q1HA8vlkk
         OAu7hp13KIAo3q65CcWlUMZ8SyvNX2b6Ergn6CVcRVDfj09Du9pqlSUaVBZyVP3coKgq
         QLTHXYGCVvRWJ5ui1KTldsuHOz4YXUzOQS4qEzOq+ai9iesng73uhbrmdJKDIE33omfc
         s8AQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768922893; x=1769527693; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I1zCNGgef8h4dx5wfQYzWOmcIl2PEe8tEJazBc1BpM8=;
        b=p3Dkk6ncjPk5coVyERMUsuMM7wYPPKGiYwwHbtSDZrbyP1nbuIKRqOhWdIQtFb+nco
         PuuWs6nmT+7kL43W2QghmjiMtDSML/U2ATM0JhTq16RdauoBdO1GCCjqTQiHxuLoPrfN
         NXG+kyP8qjWRq8L8hUe6B2S1moqlYGgEDeBW/6EW7/KWmCaFUYuJ2QRNIN6PSLnhb4kP
         OJBu4rRQNduWOI+Yoi/1BDByDrzmzAG9e1VxikajtpcS5GViKfjMFiqsb5tS3p8UOXm+
         0OjAPEUj9FuFqX8aC9jQrakCRS/zPeIiAajgwrfP4ekp+kMQa2Q9erSE3B7elqq+Vglv
         SxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768922893; x=1769527693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I1zCNGgef8h4dx5wfQYzWOmcIl2PEe8tEJazBc1BpM8=;
        b=tMi0Kq5iM4YbKXHKShB7T5LC5C0QdrC99eZt9Ex1aCwnyZuxNpy1RnNuQwm4D6EDms
         e955IS29Ovuab8QOBTScpn4VoUqz0mxgTbxuXqJQCMeASHlexoDwnfxgF8sM7We0yFsF
         3KVmVYOfMNje0TpZ8etu+9HwBjWNqb1+RDXVjEsWMRBG9N0JIpaMq4pyCKQ/eZAwIsGS
         9VgHVNDXsSp+JkQKPl+fycJ3+67jmdfh2VkdFRGlOOZWCvnks5z/F9FlVkVqC7m0hsO+
         ulH68kY6sxqGp6igwIf3o4hOALiqDI1Y2iBW+zkJ2SwusuTyxqbWAkeOqEr0uU5pczcr
         7f4A==
X-Forwarded-Encrypted: i=1; AJvYcCVJI/L4UzHrkRggx+Ygo5qiC0BybWTGuojTPB4Uhyc6sOcflTGBAkml7CPIjevWaSCTLkbynaA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhRqVi9vEe+OoGeckasqjkjani7NzB54UNQfUDVi2N3nZS8jhx
	bFcs1XetsEtOPCkqr3bFWLm6X+tsqrEyG4nVj+yDxBKDaHSzMEvggKiH0+9wGkVh8kNF3+cUoyv
	ciWEOwGvsgxtog2zEIElDmeuhp0YrxIJvHkOlM5+8
X-Gm-Gg: AZuq6aIG/rc1tjOfUi0uLARkbbRkL0ISL/o67r9LIFORWpDVVVe93UT+ZC6D0XQWol/
	/zOWNah4076wLmtlzxK2C25iCmj3MhlBokE4J9UpiO9W+OtKd6w/BOH7tNyUqZUyZ+kPOqtxZ3U
	2S0ov350LKGtGNoJEFZjcku8CWe1aNgD2GDbv9oK8c+cenS8CDc1/ehABI/uTrFI1gbjjMveb7I
	c0sIPobiw9jOYQmLn4AcjDD0AXeTKdY2il99PJiBzoipyKcs8SowMZyIKtiIJ6kWb41y4I/Gu3l
	iVBkzO49Jby++iOM7qdfDgm7OQGIm47TP8m8
X-Received: by 2002:a17:907:948d:b0:b3a:8070:e269 with SMTP id
 a640c23a62f3a-b879389056fmr1590488066b.14.1768922892289; Tue, 20 Jan 2026
 07:28:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260112165914.4086692-1-ben.horgan@arm.com> <20260112165914.4086692-29-ben.horgan@arm.com>
 <e65d2b54-e14c-4b1d-a9ea-04b6e0eb051f@intel.com> <90561371-96f0-4bdb-8316-1b657f26da54@arm.com>
 <f2e9d7e2-1f99-45e4-9cf9-49e1ce2f08e9@intel.com> <0eb7fc76-179e-4e55-b13e-78cea775c2ba@arm.com>
In-Reply-To: <0eb7fc76-179e-4e55-b13e-78cea775c2ba@arm.com>
From: Peter Newman <peternewman@google.com>
Date: Tue, 20 Jan 2026 16:28:01 +0100
X-Gm-Features: AZwV_Qjn2fnxvYPOYMmk0_TL0MsbH8v-arEYq7xOCEX18DkcfIXaElQDJPpxd5Q
Message-ID: <CALPaoCjK=VoYriKCGUrtTs=xKxkU34nnwxHKjjy6QVbmD99yhw@mail.gmail.com>
Subject: Re: [PATCH v3 28/47] arm_mpam: resctrl: Add support for csu counters
To: Ben Horgan <ben.horgan@arm.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>, amitsinght@marvell.com, 
	baisheng.gao@unisoc.com, baolin.wang@linux.alibaba.com, 
	carl@os.amperecomputing.com, dave.martin@arm.com, david@kernel.org, 
	dfustini@baylibre.com, fenghuay@nvidia.com, gshan@redhat.com, 
	james.morse@arm.com, jonathan.cameron@huawei.com, kobak@nvidia.com, 
	lcherian@marvell.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, punit.agrawal@oss.qualcomm.com, 
	quic_jiles@quicinc.com, rohit.mathew@arm.com, scott@os.amperecomputing.com, 
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, 
	catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net, maz@kernel.org, 
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Fri, Jan 16, 2026 at 11:29=E2=80=AFAM Ben Horgan <ben.horgan@arm.com> wr=
ote:
>
> Hi Reinette, Peter,
>
> On 1/15/26 18:54, Reinette Chatre wrote:
> > Hi Ben,
> >
> > On 1/15/26 7:43 AM, Ben Horgan wrote:
> >> On 1/13/26 23:14, Reinette Chatre wrote:
> >>> On 1/12/26 8:58 AM, Ben Horgan wrote:
> > ...
> >>>> +
> >>>> +          /*
> >>>> +           * Unfortunately, num_rmid doesn't mean anything for
> >>>> +           * mpam, and its exposed to user-space!
> >>>> +           *
> >>>
> >>> The idea of adding a per MON group "num_mon_groups" file has been flo=
ated a couple of
> >>> times now. I have not heard any objections against doing something li=
ke this.
> >>> https://lore.kernel.org/all/cbe665c2-fe83-e446-1696-7115c0f9fd76@arm.=
com/
> >>> https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@int=
el.com/
> >>
> >> Hmm, I see now that 'num_rmid' is documented as an upper bound and so
> >> neither 1 or mpam_pmg_max + 1 agree with the documentation.
> >>
> >> "
> >> "num_rmids":
> >>              The number of RMIDs available. This is the
> >>              upper bound for how many "CTRL_MON" + "MON"
> >>              groups can be created.
> >> "
> >
> > Please note that this documentation has been refactored (without changi=
ng its
> > meaning). The above quoted text is specific to L3 monitoring and with t=
he
> > addition of telemetry monitoring the relevant text now reads:
> >       The upper bound for how many "CTRL_MON" + "MON" can be created
> >       is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.
> >
> >>
> >> So, if I understand correctly you're proposing setting
> >> num_rmids =3D num_pmg * num_partids on arm platforms and that in the
> >> interim this can then be used to calculate the num_pmg by calculating
> >> num_closid/num_rmid but that a per CTRL_MON num_mon_groups should be
> >> added to make this consistent across architectures?
> >
> > Yes for num_rmids =3D num_pmg * num_partids.
>
> Ok, I don't really see another option.
>
> The motivation for this is that to me
> > this looks like the value that best matches the num_rmids documentation=
. I understand
> > the RMID vs PMG is difficult so my proposal is certainly not set in sto=
ne and I would like to
> > hear motivation for different interpretations. "calculating num_pmg" is=
 not obvious
> > though. I interpret "num_pmg" here as number of monitor groups per cont=
rol group and on
> > an Arm system this is indeed num_closid/num_rmids (if num_rmids =3D num=
_pmg * num_partids)
> > but on x86 it is just num_rmids. Having user space depend on such compu=
tation to determine how
> > many monitor groups per control group would thus require that user spac=
e knows whether the
> > underlying system is Arm or x86 and would go against goal of having res=
ctrl as a generic interface.
> >
> > The way forward may be to deprecate (somehow) num_rmids and transition =
to something
> > like "num_mon_groups" but it is currently vague how "num_mon_groups" ma=
y look like. That thread
> > (https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@inte=
l.com/) fizzled
> > out after raising a few options how it may look.
> >
> > Another proposal was to add a "mon_id_includes_control_id" to use as an=
other "guide" to
> > determine how many monitoring groups can be created but at the time it =
seemed an intermediary
> > step for user to determine the number of monitor groups that resctrl ca=
n also provide.
> > https://lore.kernel.org/lkml/CALPaoChad6=3Dxqz+BQQd=3DdB915xhj1gusmcrS9=
ya+T2GyhTQc5Q@mail.gmail.com/
>
> Just thinking about it now but the "mon_id_includes_control_id" option
> seems the best to me as it is a single bit option that along with
> "num_rmids" let's you know which monitor groups you can create and if
> it's sensible to move monitor groups between CTRL MON groups.
>
> The "num_mon_groups" per CTRL MON group would also need to be
> interpreted together with "num_rmid" to know if it is a global or per
> CTRL MON upper bound. This option also uses multiple files to give the
> same bit of information.
>
> >
> > Making this consistent across architectures is the goal since resctrl a=
ims to be
> > a generic interface. Users should not need to do things like infer whic=
h system they
> > are running on by looking at output of resctrl files as mentioned.
> >
> > fwiw ...  there seems to be a usage by Google to compare num_rmids to n=
um_closids to determine
> > how to interact with resctrl:
> > https://lore.kernel.org/lkml/CALPaoCgSO7HzK9BjyM8yL50oPyq9kBj64Nkgyo1WE=
JrWy5uHUg@mail.gmail.com/
>
> Unfortunately, it looks like we're about to break this heuristic :( At
> least, until a way to get this information generically in resctrl is
> decided upon.

We actually ended up going with the "mon_id_includes_control_id" approach.

The property it represents is rather fundamental to what a monitoring
group actually is and is a low-level implementation detail that is
difficult to hide. Google generally needs support for as many
monitoring IDs as jobs it expects to be able to run on a machine, so
the number of monitoring groups will be routinely maxed out (and there
will be some jobs that are forever stuck in the default group because
no RMIDs were free at the time it started[1])

Thanks,
-Peter

[1] https://lore.kernel.org/lkml/CALPaoCjTwySGX9i7uAtCWLKQpmELKP55xDLJhHmUv=
e8ptsfFTw@mail.gmail.com/
