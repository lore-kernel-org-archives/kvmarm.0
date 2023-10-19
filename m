Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67CC3D382
	for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 20:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m2C/vaJe"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c9b70b9671so9805ad.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 13:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697746690; x=1698351490; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=re69crmlRFvuit7vgWY0A8Ey7T/2hSy2QGFgqasYm7Y=;
        b=m2C/vaJeUZqvddeFluzu8Rl2HhaTZSWxCrxUG7O2HAvSsRdJ5IrCoEdgHFIRMWKUJM
         bOT3IvbzeSGhgYQMprRIscTOcfeRO6ZEwXfDyCGdWtGAyECjlWrAAUt5UqpwiWD2bwaq
         DOd0qsnDMV7QCvgU7axes6/3xMWPjrsl60DWd+mZ8s3OnQv/R5j/tOTQX5ICnyFA6Oa0
         oM+zyxd7+lmu6mxXbFw3+A89XQHT1OipOlf4vnYGCkFzjlhz0iU/vZPb7439XPH2uA8k
         AuLPQhf6HM4eyjLEw1T1C1Pud3PC8grKWyMb4ihvCVj6OanIX2PIJUaKsukoekbWTivF
         yRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697746690; x=1698351490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=re69crmlRFvuit7vgWY0A8Ey7T/2hSy2QGFgqasYm7Y=;
        b=jCSMdNRubYdH/eJeuepsbVNbj5pd17XisA9w90S6aASXguuWkPOIHUd466CzvSJG+e
         Ho4JapXRQfGmHOBipSnKrRKHBkVjkk6/jPcc9oRlwCx7xv7H1yALFqmNxTQFB8QEXzln
         /R0Mkgz9egLBMXM4Q2VXjJdWAS82+EV+I+uUxZ8gzPr/sgX0m/GR734LqTpDh5NNrEBC
         U9Mw2xJJxFLwb7maXhdx2rMCDa48kf2/hK9ibzJurcb75CullRdXwuWnVGfcM0ddoU7j
         WsmQcHyhiDV6pWH1m537bu4PBqmBkbG8v+NTDXoVCzLZxubLSdc8oWjZQmHb2rUidElY
         aFNw==
X-Gm-Message-State: AOJu0YzrTXSOKOKEvRDOvyPYrfoI+XQUR0A3YkDEN60yqJke+KuY30yI
	GqbR5/JpTyv0LBCZiLiNmnVXbxOQI5sEaPY0vneAng==
X-Google-Smtp-Source: AGHT+IHBuZ18aPFC5tbiN39OPHUSbaheZLj3eZFoc72z1OMOJqTRu9TrdQCDkRczySNC2f1yEKxOHu95/xwWlWnDbA8=
X-Received: by 2002:a17:903:40cb:b0:1b9:d96c:bca7 with SMTP id
 t11-20020a17090340cb00b001b9d96cbca7mr42965pld.25.1697746689771; Thu, 19 Oct
 2023 13:18:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com> <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
 <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com> <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
 <CAJHc60yr5U+sxSAaZipei_4TNaU0_EAWKLG8cr+5v_Z1WYRMuw@mail.gmail.com>
 <CAJHc60yQSzsuTJLcyzs5vffgRzR5i0vKQwLnhavAon6hoSkb+A@mail.gmail.com> <ZTF-FlDtvha-6Pw1@linux.dev>
In-Reply-To: <ZTF-FlDtvha-6Pw1@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 19 Oct 2023 13:17:58 -0700
Message-ID: <CAJHc60yNfGo8A+RLozgEsDO=75SQAB5dswAWgFzc3OS7_3FfKQ@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Eric Auger <eauger@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 19, 2023 at 12:06=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Raghu,
>
> Can you please make sure you include leading and trailing whitespace for
> your inline replies? The message gets extremely dense and is difficult
> to read.
>
> Also -- delete any unrelated context from your replies. If there's a
> localized conversation about a particular detail there's no reason to
> keep the entire thread in the body.
>
Sorry about that. I'll try to keep it clean.

> On Thu, Oct 19, 2023 at 11:46:22AM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Oct 18, 2023 at 2:16=E2=80=AFPM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > > I had a brief discussion about this with Oliver, and it looks like we
> > > might need a couple of additional changes for these register accesses=
:
> > > - For the userspace accesses, we have to implement explicit get_user
> > > and set_user callbacks that to filter out the unimplemented counters
> > > using kvm_pmu_valid_counter_mask().
> > Re-thinking the first case: Since these registers go through a reset
> > (reset_pmu_reg()) during initialization, where the valid counter mask
> > is applied, and since we are sanitizing the registers with the mask
> > before running the guest (below case), will implementing the
> > {get,set}_user() add any value, apart from just keeping userspace in
> > sync with every update of PMCR.N?
>
> KVM's sysreg emulation (as seen from userspace) fails to uphold the RES0
> bits of these registers. That's a bug.
>
Got it. Thanks for the confirmation. I'll implement these as originally pla=
nned.

Thank you.
Raghavendra

> --
> Thanks,
> Oliver
