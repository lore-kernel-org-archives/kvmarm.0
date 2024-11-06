Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DDA2076B1
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 18:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730918510; cv=none; b=iPmg9n4gtPgs/F7Nb4Uq9OdnnAQqPuxpgJ0Ma602wOMPit8HwL6Z52KxGr0XDm03OVGMn9ijWc7kqR6XxOF+gQZfDlkI8/ScZY/P8kZJVgVxmPzi/a83UO4YQhi1e/1xr4qY4gkMltiyEbz7Vz0KeZGaJ0frLar4j8o7jpK7LKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730918510; c=relaxed/simple;
	bh=O0rXKOxISdp0VOGK36WmzL5LnmhOQY5UyxWhw+AV0sU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vo0CB9JkBlvmZ4anvV6ga4eMuSF1L2awhh5eIa11l++QZes/apvEapJUDzj946sCElYjygp/uOWECHVPR5/UHY8LGe8PYpDQHWqOfPFos7TEF1SBTKJwfm2hTinvIvkT2J+h0z1iuIVx7p7WO7S4qV7PaX6nHuL3ILQSSJFfMmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PAleYMMK; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PAleYMMK"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539f72c8fc1so50364e87.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Nov 2024 10:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730918507; x=1731523307; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYk4e/Rf0Fwn8rgiKqzmXUTH3/JjwaWMVgfrc3mEkFk=;
        b=PAleYMMKqqQMDXNVTBhAmluj99eLyItsFx7gno4oIWcAJzcB9ygcSy1r+YxH0HMWXO
         Hffyd96S+IDRuVlooTjVrtXeInzzRriwFlWF6LzEumKoc2uZ7T8cYyGsleQ5SIM8gX5D
         LHwTIkGtwega/uTj4ehDZ3yUB6ITstVmf/ZQ3oMf06Fj0KXpVtxk60/k/lB7ZcMCTvUY
         WIkNDrr20F3IB+RuDBxlv+gu+QVafs+poZzkdMY84iE8WqpxxV/iTn3GIWTiYpdo5X8o
         sgYKVozBUoNb/LGrdiJWVJsAue5w4V8MbhHj2R07dDHSw9G/i6hFtbn3AYzUglq1E8lP
         nIvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730918507; x=1731523307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yYk4e/Rf0Fwn8rgiKqzmXUTH3/JjwaWMVgfrc3mEkFk=;
        b=K9gMWk9Su8lGZXEVWX2eIZpn3Kzud601+cSGCYBnxG+QmNbUKfZ7IkaU6tMjO7nSK0
         MjbIwa4nSSFC0Nmcs07rvKakD11kE9wCF9uK4HXjJYOOGUU3JRBVIRLbbM34q/YRwWXR
         0Gcgu1PK4YUDBn4VhFEoqrTSwsWx5T6HaNqwEIQIfx6HCB/dy0DfxVCTPPULCJBCxXTs
         f96JoHK8eATbvRgiyw4kT2ELk85z8kuy8MwL7nPVn++aZIt1e0KRCHAJ0//DXUOuWSSM
         JCGS6LO7SW08zLwteVU+/3WPAUQx/0K+YXoBPL1dF/Yg4kL5/BnfACI8hL33WBSzBNfH
         B6Eg==
X-Forwarded-Encrypted: i=1; AJvYcCX3BfqLp0yPR/hsXAlcnyu9N4ZivGpdv5MzncQyPdR8VrzJUDgEJuyTjurGo7d9RFKkvlbm22Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyB2V+qbfykJMVqGUSIUguGOEAn74gJfaf0XAsL4icy3MA30w5
	2t2ZqYu2Q0KGXPrmWuHnwBghfv1G5Idro32z+ZQBUcRykFgO/y+8csZsSS+rtFIMkIc/Geq59dH
	UjrcOJaXqeCNWKYfYkBpW98bZSLvcMVg69+oK
X-Google-Smtp-Source: AGHT+IHx4X3KPAFGSnjaYKE8NT/XVzFyHeBioH3zapaMHSYPe+KnYq0l63zBuSlt2HLiDpsHUtw8XFGqFcDi10iVlu8=
X-Received: by 2002:a05:6512:6ce:b0:539:f922:bd4e with SMTP id
 2adb3069b0e04-53b7ece11eamr15715877e87.23.1730918507026; Wed, 06 Nov 2024
 10:41:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
 <20241106083035.2813799-5-jingzhangos@google.com> <86a5ec1oim.wl-maz@kernel.org>
In-Reply-To: <86a5ec1oim.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 6 Nov 2024 10:41:35 -0800
Message-ID: <CAAdAUtjYZ5N4UpaK5Kt8MRyN1zqPD5QqjZzNdp-HPUgA-AtNJg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] KVM: selftests: aarch64: Test VGIC ITS tables save/restore
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Kunkun Jiang <jiangkunkun@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,


On Wed, Nov 6, 2024 at 5:27=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> [Adding Eric to the list, since he worked a lot on the save/restore code]
>
> On Wed, 06 Nov 2024 08:30:35 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Add a selftest to verify the correctness of the VGIC ITS mappings after
> > the save/restore operations (KVM_DEV_ARM_ITS_SAVE_TABLES /
> > KVM_DEV_ARM_ITS_RESTORE_TABLES).
>
> What are you checking? The saved data? The restored data?
>
> > Also calculate the time spending on save/restore operations.
>
> Is that really relevant? I don't think performance matters at this
> stage, if we can't even have reliable data.

Right. It doesn't matter. Will remove this line from the message.
>
> > This test uses some corner cases to capture the save/restore bugs. It
>
> Which corner cases?

Will add details.
>
> > will be used to verify the future incoming changes for the VGIC ITS
> > tables save/restore.
> >
> > To capture the "Invalid argument (-22)" error, run the test without any
> > option. To capture the wrong/lost mappings, run the test with '-s'
> > option.
> > Since the VGIC ITS save/restore bug is caused by orphaned DTE/ITE
> > entries, if we run the test with '-c' option whih clears the tables
> > before the save operation, the test will complete successfully.
>
> I'm sorry, but this description is meaningless, as you need to know
> what is the bug that has been fixed.

Will add bug description here too as in the cover letter.
>
> Also, how is someone supposed to run this thing? Without options? With
> options? With any combination of options?
>
> From what I understand, the various options are designed to help
> debugging a broken vgic implementation. So please document what the
> options do rather than an bug that is supposed to be already fixed.

Will do.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
