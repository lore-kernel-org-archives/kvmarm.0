Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377EA28F1
	for <kvmarm@lists.linux.dev>; Tue,  2 May 2023 22:31:25 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-559c416b024so48046717b3.1
        for <kvmarm@lists.linux.dev>; Tue, 02 May 2023 15:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683066684; x=1685658684;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SIVJcGIva647UNmGPK+udMl/NK3kjFoUm0hqJKOqIDI=;
        b=yug6czQuDTCW52dBy0FDo7Ylclb8BkXmgTi1DJAnoQ+xgU2idHTbWnXdTTaBWr6dzJ
         IEdaDHkrbH3ssuq/0xYLXmYabqGtRcwcr+4NpyOB2Sfk09KVuV3cm0jmd8R46YYbKZ9M
         dErvexVAqOHnTn0m2k69T5hQi/ufSgbuubVsS+RcPUU8J5eJBTDEreEaIwzqQS07CFlx
         oXQPNrrmE78oDI6/2VBhOdr308e2+MjVjSDM8vbedos5C9W/OsNwIVTvcP1hz3HcY6+v
         tLWRmTwghSrHm/aghAQOOCRp3mkhP40paoqjzVQ1BhxqUqKiL8BjRoDvhdXJ1y1YD8zp
         PZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683066684; x=1685658684;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SIVJcGIva647UNmGPK+udMl/NK3kjFoUm0hqJKOqIDI=;
        b=M6IEfQLt94Gbzf+kfDb5v3xCNXNvw8uKrIIZ6PoWfr05WhZ/xuUv993x7nvQaIKpjL
         05WCoHfpS+dyRHmzwXv+9Zc4uzs2Q3F1H8zcYomvljBWnAcj6eDMRrQKqC6rYG3VZTIs
         /UzA3Vh2+k+s2fWCQrd+Dd1SVm6lq7ngBkvdEc1M+h3qu5J2uD99FYAatrNv3fDLSLb6
         fZTjr+LEeCs2DED0RbhgkejZj6gDCbuf54aLpC8mfdklKtiouldfNeGIkTSkf4lLZoDy
         WNbfTZiJZMUIWsL7YZKoGeTaEoGXct08LpogyZEiqkBY1pNNGGb/w6Jb4rh3fpsznxjy
         OuIg==
X-Gm-Message-State: AC+VfDw3Ebj/x1FiQi6I5Vi4HMpO3oA0XKlRE+k/saSSh5irYeQww+Mv
	xx581LxIxKDY4cQqOcPpDCyl8gXnBzQ=
X-Google-Smtp-Source: ACHHUZ7EqoPbhh3PehAzC9G/nHvcRMmoqlIIGsHGscULH/yhOYfuJYlRXmZ0yd6tLxOKpU03tK93mgs1Qj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:72c:b0:52e:e095:d840 with SMTP id
 bt12-20020a05690c072c00b0052ee095d840mr11910199ywb.0.1683066684192; Tue, 02
 May 2023 15:31:24 -0700 (PDT)
Date: Tue, 2 May 2023 15:31:22 -0700
In-Reply-To: <CAF7b7moeysHUtiS_5DL9c5OPKnCsiO50zBkjp1m4QjVTvXF58A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
 <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
 <ZFFbwOXZ5uI/gdaf@google.com> <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
 <ZFF1ibyPZHKYzEuY@google.com> <CAF7b7moeysHUtiS_5DL9c5OPKnCsiO50zBkjp1m4QjVTvXF58A@mail.gmail.com>
Message-ID: <ZFGPOiip/Sf8V8DU@google.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 02, 2023, Anish Moorthy wrote:
> On Tue, May 2, 2023 at 1:41=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > If KVM triggers a WARN_ON_ONCE(), then that's an issue.  Though looking=
 at the
> > code, the cui() aspect is a moot point.  As I stated in the previous di=
scussion,
> > the WARN_ON_ONCE() in question needs to be off-by-default.
> >
> >  : Hmm, one idea would be to have the initial -EFAULT detection fill kv=
m_run.memory_fault,
> >  : but set kvm_run.exit_reason to some magic number, e.g. zero it out. =
 Then KVM could
> >  : WARN if something tries to overwrite kvm_run.exit_reason.  The WARN =
would need to
> >  : be buried by a Kconfig or something since kvm_run can be modified by=
 userspace,
> >  : but other than that I think it would work.
>=20
> Ah, ok: I thought using WARN_ON_ONCE instead of WARN might have
> obviated the Kconfig. I'll go add one.

Don't put too much effort into anything at this point.  I'm not entirely co=
nvinced
that it's worth carrying a Kconfig for this one-off case (my "suggestion" w=
as mostly
just me spitballing), and at a quick glance through the rest of the series,=
 I'll
definitely have more comments when I do a full review, i.e. things may chan=
ge too.
