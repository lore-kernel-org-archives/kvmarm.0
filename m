Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FC311CA4
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 19:26:09 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6b72c4038b6so5687105a34.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 12:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688585168; x=1691177168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KIxxp026/w7UKJlFK3fYGlwG+XSxn3u3/0XumxsaeA=;
        b=054SwNoSENr7q1hk4ph8TPf6/Rl9OBTQDS21mJ2SKL3lagyOMq34Swlbd6UcIJGfxk
         6FfgtaKhK/V/WLW0AfBdjrNpSSsskPUsobYjWw1XAtCUKud1vJ8g435rvAZd8dM3+AIr
         qzQ5hJl9FQpbRU4d1NqR8SrFS2BwF7tCJbNbcFAG/EEY0U2ndRg5plumKc1aRgDD910u
         Xi/SDhlkvO6L5DktKz/M82eAU8mqOfF3GBnyi01If851eD59MG6hCk5io8gIu4HbqxoE
         1riwvUFiezCOF5HRYHr5GoZDGAEKkMwC/RV+udIvu6n2h5nmggpZ/By9liaRjRMUz0UG
         lD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688585168; x=1691177168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9KIxxp026/w7UKJlFK3fYGlwG+XSxn3u3/0XumxsaeA=;
        b=TPDnqiAb6ofeaQp9kpwCBGUEhdAaYvsuyVHawpnBzbBGDFx506kQtc8pi2yjbFIkTB
         Ab9HjmEkoRNlF5pO+24XDAe85g4kJMC3q6JA+be+JfPVuIKU41rPMayYCSJtSvvm1nuX
         Y6vBVkIut4TO9dGNUoPIy1EfIfeChyNWAd28Efa2KoiG0mFNSDoCc0KIxOchmJL6UoS6
         eI7+85ESXuV+tDRZP38xu6BYHHBQvPdAYheTfPdk88eTm2eJz9k0elJRYT1rZd/qsegJ
         +P6fW/LY2FmA8qmlUpyC/fnraQimMBlsq29feCrk7qD2B2/in80/Lb9t9cMPwfhcrKYs
         rYoA==
X-Gm-Message-State: ABy/qLb17tApu/8pagG3F3i5QJfOcnxAVNumup3x/ayaNlc4tRRVgaV2
	B8lVkPh/+9E65Cv7AESV9zuJw5Elr37Ch9ZrgfUmig==
X-Google-Smtp-Source: APBJJlGvXWeSNtOCYEgeQwfIozB9e87JkiwqFzwV4rWdasBMr59GIrb4XnRvhSMyWX4xvVnZXe/BP2yXaEGboH9NXRU=
X-Received: by 2002:a05:6871:4409:b0:1b0:5290:c95e with SMTP id
 nd9-20020a056871440900b001b05290c95emr15909408oab.42.1688585168238; Wed, 05
 Jul 2023 12:26:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com> <ZJn6niA1RgAqu7DC@linux.dev>
In-Reply-To: <ZJn6niA1RgAqu7DC@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 5 Jul 2023 12:25:57 -0700
Message-ID: <CAAdAUtjqR1WrCNF9OFxe0atWj1P_Mc+OPv9tLKU3t7QbeiWaqg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2}
To: Oliver Upton <oliver.upton@linux.dev>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Mon, Jun 26, 2023 at 1:52=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Jing,
>
> On Wed, Jun 07, 2023 at 07:45:50PM +0000, Jing Zhang wrote:
> >
> > This patch series enable userspace writable for below idregs:
> > ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2}_EL1=
.
> >
> > It is based on below series [2] which add infrastructure for writable i=
dregs.
>
> Could you implement some tests for these changes? We really need to see
> that userspace is only allowed to select a subset of features that're
> provided by the host, and that the CPU feature set never exceeds what
> the host can support.
Sure, will add a selftest for these.
>
> Additionally, there are places in the kernel where we use host ID
> register values for the sake of emulation (DBGDIDR, LORegion). These
> both should instead be using the _guest_ ID register values.
Will add a new commit for these change.
>
> --
> Thanks,
> Oliver

Thanks,
Jing
