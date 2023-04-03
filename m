Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B437487
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 19:43:04 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-17ab3a48158so32080208fac.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Apr 2023 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680550984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7iJK+OHZ5ZfCg5QFFBGWdn6OvEmXKpIceou758DXRpE=;
        b=P75M9UuYSreShGG1oskdc2oEHaWakGfm3x1nmTBNbY3MhI1CCHeJEpI9YT0AaX7iuz
         W8ppTg/AZfxOImDg64xMZaBEh/n8g0ScCZSFfr3f8iAb6E3VgcUnHOZXjo35Ww6qU9OK
         HYnGda1Rowo0hROsI1n/ZepSutCdSa0xhS13Mr8Q15KtU4gsKDry1UMRVgLjeUEEFAA6
         bMNFmhhvhX7y205udBzLWZOoJ9iEEypmx7YEi9sgb+hBNSADu8ssYBViDuS2wO+aJxXW
         UAq3zDT7tf+A6voHMuArWr3SDGPKncFcNt0th4J/hxZQikvyMbjwHhQ+43Ip5P3bOZn5
         gc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680550984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7iJK+OHZ5ZfCg5QFFBGWdn6OvEmXKpIceou758DXRpE=;
        b=Vve6+tx0pxAx0waRyCnl3oBywyiu/zZTcb/Jd7Wp9OESOWNIFPoBTAyVgiSgoOuxZr
         0fpbEz9qo0N7IrVB4xp9N5woXpJV2Sb35lobevezCw8Bc9ygKH5h1osJKRRPeeDGlnfJ
         c/VNNjNne+0BfuXtugvwtRgSDm4Ps007b6w7MVUYtQDMXQUntmu+7HfffUwxbNe1RRXN
         ZGStK9y6aEaYm5FfSPbXioStqfCrg8I/jJTDgpMFB5dMF54mKIscvlzVuDnILWpFlPtc
         7cne65knko9t3rNkyh7OwQgUd+qP2d45/ujsFrHBOeNoJY+LWagsRMYXSVKK2/V7OJJg
         qmZg==
X-Gm-Message-State: AAQBX9drJLJb+Edt3PxuLkbSMaHwR8k40Gv2pRTe1fQV0l0wg+a2R8BF
	UV33YnoZL6uUjV/gYWhcXSJIdAN6xDR5PrJVh59kGQ==
X-Google-Smtp-Source: AKy350YcqR0yqar7uvrPwBXHS+FhvAwEQIc1UW8a63ZVjaeuxY8QeREXpb8TCwCi9M1fb6UX5fncefBZmYL0TAOcxvQ=
X-Received: by 2002:a05:6871:784:b0:177:bf3e:5d4f with SMTP id
 o4-20020a056871078400b00177bf3e5d4fmr179968oap.8.1680550983629; Mon, 03 Apr
 2023 12:43:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230402183735.3011540-1-jingzhangos@google.com> <861ql1w948.wl-maz@kernel.org>
In-Reply-To: <861ql1w948.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 3 Apr 2023 12:42:52 -0700
Message-ID: <CAAdAUtj0Yn_s-bOxT9smwWzYO+MhUW=Nv7ZH9zrdkKUJPJLEYA@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Support writable CPU ID registers from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Apr 3, 2023 at 3:30=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sun, 02 Apr 2023 19:37:29 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > This patchset refactors/adds code to support writable per guest CPU ID =
feature
> > registers. Part of the code/ideas are from
> > https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com =
.
> > No functional change is intended in this patchset. With the new CPU ID =
feature
> > registers infrastructure, only writtings of ID_AA64PFR0_EL1.[CSV2|CSV3]=
,
> > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon are allowed as KVM does =
before.
> >
> > Writable (Configurable) per guest CPU ID feature registers are useful f=
or
> > creating/migrating guest on ARM CPUs with different kinds of features.
> >
> > ---
> >
> > * v4 -> v5
> >   - Rebased to 2fad20ae05cb (kvmarm/next)
> >     Merge branch kvm-arm64/selftest/misc-6,4 into kvmarm-master/next
>
> Please don't do that. Always use a stable, tagged commit, not some
> random "commit of the day". If there is a dependency, indicate the
> *exact* dependency. Yes, x86 is managed differently.
>
> I'm never going to apply anything on top of an arbitrary commit, so
> this makes it difficult for both you and I. I understand that you want
> to avoid conflicts, but I really don't mind resolving those.
>
> So please stick to existing tags as a base, and describe the
> dependencies you have (in this case, the locking series).
Sure, will do that.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
