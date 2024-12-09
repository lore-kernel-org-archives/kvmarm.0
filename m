Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD435FEE6
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 08:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733731950; cv=none; b=AqxONp3UQI3kmhYbWpbqFySLAeiZWy6n8mxKh5eGowwA2Aw8mHEy3zJzLGyjd9H9lVEW+U8uNVtLcIUAr1QA54XWrYOv+TVTQmuhTo+DiIQtyNaGf6gpC5gB0Tem7eYLEzC/VG5J2WVhC7tImTyKnPnYFvZCm/CgBCxeQUkEYvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733731950; c=relaxed/simple;
	bh=jiwzthSSyNa/tSRsTGkULxv/q35SeWC9scNB2Tc1b4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gb84sVZeKbSxbtZOx9WWpQlkPiXNmU834S5pmZNW2G1cbNknKoAJOGb0anbq2TZXgwtoU9dWi123NU2QlQ3vz+OWu+TgswjxwnPYsvKOhHlgOhzP0qCwwtTbjse4wJUdw3jCJR3YRsS7Vmw5FiCgiLd0OokGzYbMak3wl+f01lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ikydAE1Q; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ikydAE1Q"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-434f150e9b5so51205e9.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Dec 2024 00:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733731945; x=1734336745; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4NciFRRoGn6D2XlVHSYt3WE5Tr/WBuHB/hCa+auTFK8=;
        b=ikydAE1Qb7ti7EpFLZ2p5Ou4VaON+i9meh7tE14DAE0dIH75RolnFoNj3JMwsk9jC5
         DjALj/CmeJI+khAU+sigZ5mJuQhLnMM7cGtNwV8Eud7rhS+AZj/dhaCr6z6ai3rP6CYn
         HFVKatbM3q4n74bYLvEkQigDQ5AnEth0luWQRn7HXyiZVEWW930duAmaX7lJk2n5azlT
         s9PAcPARidTO4zQka/4AkDXcsIxn2x+j5PyjTBx5FPo086I7BpiOQx4FaMOySxdNZCH1
         Tf06MPxj2F63/i4WFj4qw/1RW8ePdrqFoUiluQConH3jvXPdbKeearxLAOXECaelysfF
         MzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733731945; x=1734336745;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4NciFRRoGn6D2XlVHSYt3WE5Tr/WBuHB/hCa+auTFK8=;
        b=OK9t6zoLPHSeC0x+C9WSvARUm1FHqWktpuDD6i6bwT1HvjWse1/hmJDjJSXJr2cr4A
         +Y5jN+R1FcJonm8HYjNs5sk1eNnDEeVkmCcrKAOzjpsARJyqPFD9bxDHBrnzxSH2BABr
         BGpOU92CBP6k68AIJy9CthoTv+o3UW+IlCoTwDLfBJgvt0HXysMhMvPjbinPtXcLaeNK
         GSPKnbtwuZk+yO0NqfLHX/U04r3AbWiNcMm2VprVAtUqTAu/Iol826yWMYYLRCvzLl1C
         kYh7RznNCbeLpwd62sJRtO2yauGuyI2YUOGbmTyWWFXfP4Sh9JozSjQyQhpo/V3/v7iw
         O6ww==
X-Forwarded-Encrypted: i=1; AJvYcCXDUDFkU5ypuLpU2+H5qtkof8Ky5+jX4h/bxyZZrCI0Did1YACUSrNHbQzLLpsElERtpYcS40o=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpJqQCt+CHShJjSHFZcFBH1t2m6gnmCvOdgb0I+j9CDPijGNGX
	kB42luWNzuca1PS5+Ct6yuW2/jI4OHY1+uuKr5+6RMLDq9FDXUttGbgzl7V94ri2BVctP2fFxLe
	TszalOKFAc7gCSGv/iPzKYE+AxLVNGuVSWbft/D8psxi8pwDw0w==
X-Gm-Gg: ASbGncudpKAm/PVujaSF9zbYl7YXq+8TZsmVCgnApcr/l9FxWDNXpxBskYZKl0Cd0e7
	tmUF/GBtIj9HPPcbBiwb/wEx9A19mcQ==
X-Google-Smtp-Source: AGHT+IFdVhh7qM5pFXOICqgM0O7MUeIFhVrQjqgHLd5tsYdNifpK22oNMUZtWMNgXZXQSPq85vrS0iUacvhsHRyHJcw=
X-Received: by 2002:a05:600c:2246:b0:431:416b:9ecf with SMTP id
 5b1f17b1804b1-434e83ab555mr2569925e9.6.1733731944790; Mon, 09 Dec 2024
 00:12:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-7-tabba@google.com>
 <Z1M1DYbvuqAEU5c-@google.com> <70992791-af72-43ed-88cc-1bb5a8acaf9a@sirena.org.uk>
 <868qssu0wf.wl-maz@kernel.org>
In-Reply-To: <868qssu0wf.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Dec 2024 08:11:48 +0000
Message-ID: <CA+EHjTwc8VWVtU+2GArE8a8TwoZsqmaBNYuLyjqn8JpszxXqjA@mail.gmail.com>
Subject: Re: [PATCH v4 06/14] KVM: arm64: Set protected VM traps based on its
 view of feature registers
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	james.clark@linaro.org, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi,

On Fri, 6 Dec 2024 at 18:22, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 06 Dec 2024 17:43:42 +0000,
> Mark Brown <broonie@kernel.org> wrote:
> >
> > On Fri, Dec 06, 2024 at 05:31:57PM +0000, Quentin Perret wrote:
> > > On Monday 02 Dec 2024 at 15:47:33 (+0000), Fuad Tabba wrote:
> >
> > > > - if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), id_aa64pfr0) <
> > > > -     ID_AA64PFR0_EL1_RAS_V1P1) {
> > > > + if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
> >
> > > I'm admittedly getting a bit lost in the kvm_has_feat() macro maze, but
> > > should this be:
> >
> > >     if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1))
> >
> > > to replicate the existing check?
> >
> > kvm_has_feat() checks for a value <= the supplied constant while the
>
> Not quite:
>
> #define kvm_has_feat(kvm, id, fld, limit)                               \
>         kvm_cmp_feat(kvm, id, fld, >=, limit)
>
> > existing check is just < and the values for the field are:
> >
> > UnsignedEnum  31:28   RAS
> >       0b0000  NI
> >       0b0001  IMP
> >       0b0010  V1P1
> > EndEnum
> >
> > so they're both checking for the same thing.
>
> Evidently not. The original code is checking for RASv1p1, while the
> change turns that into a check for the original RAS spec.

Marc is right. This change was intentional, since the goal is to trap
if RAS isn't implemented/supported by the guest. I should comment on
this change in the commit message.

Thanks,
/fuad


>         M.
>
> --
> Without deviation from the norm, progress is not possible.
