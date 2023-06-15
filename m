Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A59379
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 01:57:13 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1b4fe2139a8so58395ad.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 18:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686794233; x=1689386233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMLY1axQ9dhHgS2evzrC32ToK9p7zpIVVjZVrkVP9Q4=;
        b=JgGHVcV8/EOlg76CXREOFygRfcPLh0TvPl2YGB0VlwURFpypN66Kb1alr53MRziI0e
         HBYWPc90/oiaA7G6zUyWrl/uxY/oAhW9DKtoyE8Ho3PoorWVYZdX4w3Fxq1OcnWLaBu6
         0LKDTDBzdo+KJIsG26awIGClEZe4bI/iRsZu0tmLTBVPsEH5a72580lO+Sy8YC0GOW6g
         o08HyBosEsk2I2G38RG0zWToRkkdp29E/XznTlNmnTiVzEmZY/AWdY+4p3O/H67u6ndI
         38FJWCrJAW8asX0QUo3w9AW+tptp2b5A3zCqQDu8DCVyosUvLpbpp5JXKWyLmpsPZkbg
         VkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686794233; x=1689386233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMLY1axQ9dhHgS2evzrC32ToK9p7zpIVVjZVrkVP9Q4=;
        b=Z5MArfth6jxdIA/X37PT2quJ5ow3FgQIV1oWOTEEA0q7nNhTcvuvjA6cxL7p1eF0uE
         6O5EGLESVg5qR7HBYTSWqrGX1TiRN0Lammq/7gUYIzNmfl+jDsTM0SXNGjS0xV8oOnJE
         RLlohP9SH7h9QewN1y0mxJ4yrrsqYgkpg7mXG1HcM4IPRUp8Sll9/tH6cC03h0171XxN
         657aqVs9HJ96V0XrJ9zbzLWsXAHVI9sSHrV3YsaqmKj3m4xQmGMaKnpcDKZxjy7Uz6zU
         zHPwRKYEL4WZhmgPTfmNdVpeQ5FNgHBSadq1nqWMz0onYirfU4mdeXDfj82RV5SxRXwV
         AoYA==
X-Gm-Message-State: AC+VfDx9Zv7ifZX8Jt9wAZ07irYOrOT+RUny31DDY1xkk9BVCSPGSAJN
	LdcBGz7p0QwDTzouUHGAaPAg2bNajgxBgEgA4lttig==
X-Google-Smtp-Source: ACHHUZ7k0wQBEo+NKxdCH3hP8L0i+8TYR5xJPePgVUW4Nh6Q7s/Lv/FmuVPnnao1IQ/tXOiUiu+GK3HzgdtUQbbtnqs=
X-Received: by 2002:a17:902:f684:b0:1b3:a195:12d4 with SMTP id
 l4-20020a170902f68400b001b3a19512d4mr124232plg.12.1686794232483; Wed, 14 Jun
 2023 18:57:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230606192858.3600174-1-rananta@google.com> <ZImwRAuSXcVt3UPV@linux.dev>
In-Reply-To: <ZImwRAuSXcVt3UPV@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 14 Jun 2023 18:57:01 -0700
Message-ID: <CAJHc60wUSNpFLeESWcpEa5OmN4bJg9wBre-2k8803WHpn03LGw@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] KVM: arm64: Add support for FEAT_TLBIRANGE
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 5:19=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghavendra,
>
> On Tue, Jun 06, 2023 at 07:28:51PM +0000, Raghavendra Rao Ananta wrote:
> > The series is based off of upstream v6.4-rc2, and applied David
> > Matlack's common API for TLB invalidations[1] on top.
>
> Sorry I didn't spot the dependency earlier, but this isn't helpful TBH.
>
> David's series was partially applied, and what remains no longer cleanly
> applies to the base you suggest. Independent of that, my *strong*
> preference is that you just send out a series containing your patches as
> well as David's. Coordinating dependent efforts is the only sane thing
> to do. Also, those patches are 5 months old at this point which is
> ancient history.
>
Would you rather prefer I detach this series from David's as I'm not
sure what his plans are for future versions?
On the other hand, the patches seem simple enough to rebase and give
another shot at review, but may end up delaying this series.
WDYT?

Thank you.
Raghavendra

> > [1]:
> > https://lore.kernel.org/linux-arm-kernel/20230126184025.2294823-1-dmatl=
ack@google.com/
>
> --
> Thanks,
> Oliver
