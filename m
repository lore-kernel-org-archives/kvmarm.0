Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A2415CA
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 03:35:56 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so277417pjt.2
        for <kvmarm@lists.linux.dev>; Sun, 12 Mar 2023 20:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678678556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XIVDKNgNNnu7iJidCAmkeAHFjqwKfwXTuL13VCoOInQ=;
        b=OHPdAgmcGU4QMibOut+sWb1Mt3yexKZ+FGNJSMuSuf/Z8Jt1h6UtKkMXBxGdTHctL9
         oVIWxgsPVk524AJEpmL1bOqTWCbKlNet6yr5mqfEkSaxAXZoV3Ps4A46yvo0jz7Rdyem
         x6eXadJTQLU8zjhJ53dciyxBu5LaG0xyzxeooK4zRv0pgYgzDCkYGdcv06QBYzD9e0f5
         cw7WocKdrsfrBCslixZvrJBQ4Arbn6zpYsP/FFs6i6QCuQ1TY/0p/MoD0X5LNbYXI8j7
         UK0NO1+vC6kiU7BC3pdxWzjpGfxsEyH6vK35nGbNtG4pr0xFq1cFRPrNoJAo5q8mM683
         YOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XIVDKNgNNnu7iJidCAmkeAHFjqwKfwXTuL13VCoOInQ=;
        b=jnJB7HOiherSbnoTW5UxJuW3bvOB+A2BVl1/SYrr4ese1tsulB9i8o+kerXlFKfaJF
         zseF/nQjjC7buPA8UIPE2ckgMy+3lDDon9pGv0v+yU9cGxmWRavR08J2hnQ7WZmJu36e
         jE1qVwPeF0SbUazG+qoEDdFu3/maOsbB6TR4ICTGnhWISkNnOU7+fDNlbAMtenN+HvAC
         I9jnfAA13DlyV2XUmSVhEO15WgWLVx0rY2zAS1p80TFY387R+s0oaIMR6c5CNdunQytn
         HvhkYq1uI1EBfDndvDn7TbhUwQJrgGjHWD9hCqHRqiK3fxj95pkHJbbkcVov6iNTwh2F
         Spdw==
X-Gm-Message-State: AO0yUKXP2caftyJAucBC0mhDgFvGPhR3CL3dP9wlsWVxWfcaZqhwuPSb
	9GZ+StuljWJDH4Ot4lrQVPN+7KEunRxEhT4QbhXrtA==
X-Google-Smtp-Source: AK7set9ytJ+OvrhbrLetsnIDo/dfpOg8EONiPahVU2UwpRmMYqsdRD/mpKfb4P9rmj1BRrcC6/ounfQ9rh5k4KZbWJo=
X-Received: by 2002:a17:90a:ba03:b0:230:b842:143e with SMTP id
 s3-20020a17090aba0300b00230b842143emr11836800pjr.6.1678678556258; Sun, 12 Mar
 2023 20:35:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302055033.3081456-1-reijiw@google.com> <87wn3m3ta0.wl-maz@kernel.org>
In-Reply-To: <87wn3m3ta0.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 12 Mar 2023 20:35:39 -0700
Message-ID: <CAAeT=FzTSboSVB=VJ_mkmkOmMtftjzOaQQfAOwmnUuomOwfiYw@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: arm64: PMU: Preserve vPMC registers properly on migration
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Sun, Mar 12, 2023 at 8:04=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 02 Mar 2023 05:50:31 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > The series fixes two problems in preserving vPMU counter (vPMC)
> > registers (PMCCNTR_EL0/PMEVCNTR<n>_EL0) during migration.
> >
> > One of the problems is that KVM may not return the current values
> > of the vPMC registers for KVM_GET_ONE_REG.
> >
> > The other one might cause KVM to reset the vPMC registers on the
> > first KVM_RUN on the destination. This is because userspace might
> > save PMCR_EL0 with PMCR_EL0.{C,P} bits set on the source, and
> > restore it on the destination.
>
> This looks good to me. Can you please add the relevant Fixes: tags and
> a Cc: to stable? With that, that'd be a candidate for -rc3, I think.

Thank you for the review!

I posted v2, which addressed the comments above, and the comment
for the patch-2 (remove the line break).

Thank you,
Reiji



>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
