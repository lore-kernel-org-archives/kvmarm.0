Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03036134CD
	for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 20:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wZSi9fRG"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3529f5f5dadso8955ab.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 13:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697228705; x=1697833505; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqAeTW3JeHR2NgxF+OPMVJ48NQjtKJfCWCw4Wwse+lk=;
        b=wZSi9fRG29Qbvb+9vuHZn9ZTRq89jqx4kKLwisWro+BNHmcW+gFPGyq9DrC5DEXnG1
         eXaFflrRCoI1YUDjDfPINOg07bS2bf09jcU7kqiwLitVOVnFCX49EjeXJBhL1A0udyI1
         64EXnNwFgpj9kjfZMAtYxGhXjOR4VvAUK6Fua1U1k8NJo5DgDcC/EyWBbQN/noTJzXe8
         bX7B+SEDjI4F7pkGVfh5E7N1Jcgf899MV4PoKvUIKj4MfDh86BdbjI0jBzILgFqfEjQ/
         be8L1gddo+ckCYJR6kqUOKSsHNJEs3zXaXhGhr5jXGL4Lho1BrctISIBGp/3Dbmg9koB
         i1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697228705; x=1697833505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pqAeTW3JeHR2NgxF+OPMVJ48NQjtKJfCWCw4Wwse+lk=;
        b=NJUQSI8IRKbOuMKndlNhkvVVkFqbfto/KX8M+OyPCkfZXkM6dJIA4v8ijcMM4c0cXg
         VbAZNblRHBP8O8Sz1FmBGIDeoCFVWbhqRzoowEDIJlQffq8cyZYKJw2kF2CT9X84n0NU
         H49ntS1M2iYbUc75q6VivkyucOe4f9ae1Ul5nYZyBQRi13/EQwffZZbMO8LVs5s9764u
         tnjDYgQaAh/C3NSk0xTfgY9uozCrTMHW0tnbTgS04ZqOVPEGbI+BbUjeLydHqpRwPfPF
         iV0KYTjRw5yRwiRStPM28HDRO/lLSwL2KFOyBpik2N+tW2UtDvADq3D/BlJ96zQQX7lZ
         ZJQA==
X-Gm-Message-State: AOJu0Yxq3ct7PAAmUNFgJaK0XqiUWCi+w50GKPxCGMH8+q2O1JaJvlko
	rFhsxK8nsM1J/Y0qygg/kacmqBS7nIfzefzapN4PHQ==
X-Google-Smtp-Source: AGHT+IH3FYJ8icPieu2/ai2TXNcA8zCg7+rWyoOf+Iq4ZbCOKrHHuD6XmPVTgbe/B7M4h1eHHImeEnUWJbuZ8PtUB1c=
X-Received: by 2002:a05:6e02:220e:b0:351:efb:143d with SMTP id
 j14-20020a056e02220e00b003510efb143dmr29195ilf.22.1697228704929; Fri, 13 Oct
 2023 13:25:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-7-rananta@google.com>
 <ZSXQh2P_l5xcj7zS@linux.dev> <ZSjY5XCCoji6MjqC@linux.dev>
In-Reply-To: <ZSjY5XCCoji6MjqC@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 13 Oct 2023 13:24:52 -0700
Message-ID: <CAJHc60yjiuyacbKytTx_ry8=_574CqwzoWdMH7ehBYswCpk5ig@mail.gmail.com>
Subject: Re: [PATCH v7 06/12] KVM: arm64: PMU: Add a helper to read the number
 of counters
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Thu, Oct 12, 2023 at 10:43=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Oct 10, 2023 at 10:30:31PM +0000, Oliver Upton wrote:
> > On Mon, Oct 09, 2023 at 11:08:52PM +0000, Raghavendra Rao Ananta wrote:
> > > Add a helper, kvm_arm_get_num_counters(), to read the number
> > > of counters from the arm_pmu associated to the VM. Make the
> > > function global as upcoming patches will be interested to
> > > know the value while setting the PMCR.N of the guest from
> > > userspace.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  arch/arm64/kvm/pmu-emul.c | 17 +++++++++++++++++
> > >  include/kvm/arm_pmu.h     |  6 ++++++
> > >  2 files changed, 23 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > index a161d6266a5c..84aa8efd9163 100644
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > @@ -873,6 +873,23 @@ static bool pmu_irq_is_valid(struct kvm *kvm, in=
t irq)
> > >     return true;
> > >  }
> > >
> > > +/**
> > > + * kvm_arm_get_num_counters - Get the number of general-purpose PMU =
counters.
> > > + * @kvm: The kvm pointer
> > > + */
> > > +int kvm_arm_get_num_counters(struct kvm *kvm)
> >
> > nit: the naming suggests this returns the configured number of PMCs, no=
t
> > the limit.
> >
> > Maybe kvm_arm_pmu_get_max_counters()?
>
Sure, kvm_arm_pmu_get_max_counters() it is!

> Following up on the matter -- please try to avoid sending patches that
> add helpers without any users. Lifting *existing* logic into a helper
> and updating the callsites is itself worthy of a separate patch. But
> adding a new function called by nobody doesn't do much, and can easily
> be squashed into the patch that consumes the new logic.
>
Sounds good. I'll squash patches of this type into the caller patches.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver
