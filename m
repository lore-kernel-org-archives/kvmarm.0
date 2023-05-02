Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF1E7491
	for <kvmarm@lists.linux.dev>; Tue,  2 May 2023 21:46:57 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-3f1958d3a53so43407865e9.0
        for <kvmarm@lists.linux.dev>; Tue, 02 May 2023 14:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683064015; x=1685656015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SkakKPnXdIbwhp3qELgh3mzIzgc5pZX2Ojek8iG0RyE=;
        b=fACx6mF2xuwefnFQeDZSjfuFRH9n6cXIZ3o0YwzNNDTbAVajDEGBng/RhJW7g+DUpf
         lgq7FvtbDnKdMDN0DHjNZFOSWDgSA3o3eE0AOOcIuXdmWx2q5To4NDp8rlM3kiQJEpBU
         3V73gGptU8Jof3O9JyXhd6V8e0mDR/SJFlgV3SepmPyJQzAOAh0SbsxPoQgWiygW5LgE
         KfN58BApR1oCOwgJH8QFZI3n9uGGjqC8XRtgzN4e2s8FY2AFOQfikRBdChNZTg0kro6g
         MCyZL+YZNAtdHyCBWDDFlj2QZ/V4w2qeea1Tp8C7xHEcFbNpOAFizsK/4iX7HAuddtGy
         m2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683064015; x=1685656015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkakKPnXdIbwhp3qELgh3mzIzgc5pZX2Ojek8iG0RyE=;
        b=G1nFX56O+UqOitlsGf4YSvKkhPSpoYGo1XbC6iDIDkcXyRs8hYH5TLoaKYreu50o3G
         AhhaiAf1fsW/KMj0unuIqmQiQEwTtwnBq6B6Sb260ToZIl5nckdoNd9JfXb2JPNqb25v
         6XZ8qhtBv/71TTiEh+KNlZOAP4rglxPlAnd3zMU+/kMZwNU/flHdyolq/aTYnY9kkyI6
         a7IQq3lM+WYAtjF9ecllzSQRpwyVcWms3H94Hh/ki7fLBMHrqbb0UudQRaSg0VTqVZPO
         +3nDhtADEQDUcTbcDeTT6rYrqOXalH5cWR2PxS/rQ5eWh9kq7DIOc/6xk6fQ+bWDdn6O
         GbEQ==
X-Gm-Message-State: AC+VfDz0SL7amytMBXD0FTWCddeE7wLsRo1+4xFfT+ZRbBDXE5HK+tH/
	M3exUa1SIPev13e54eKF3iOAnGL+jspe2w14jKYHbw==
X-Google-Smtp-Source: ACHHUZ7LJi1Shbt1CFcWQbc6/FosMafNfZN0vuGJxJL7Kri+kUr9e3Xx9lDcdl6InlfdY5njNxX+bZ74agQJHMmLDgk=
X-Received: by 2002:adf:dec1:0:b0:306:2e62:7716 with SMTP id
 i1-20020adfdec1000000b003062e627716mr4856286wrn.56.1683064015454; Tue, 02 May
 2023 14:46:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
 <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
 <ZFFbwOXZ5uI/gdaf@google.com> <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
 <ZFF1ibyPZHKYzEuY@google.com>
In-Reply-To: <ZFF1ibyPZHKYzEuY@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 2 May 2023 14:46:18 -0700
Message-ID: <CAF7b7moeysHUtiS_5DL9c5OPKnCsiO50zBkjp1m4QjVTvXF58A@mail.gmail.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 2, 2023 at 1:41=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> If KVM triggers a WARN_ON_ONCE(), then that's an issue.  Though looking a=
t the
> code, the cui() aspect is a moot point.  As I stated in the previous disc=
ussion,
> the WARN_ON_ONCE() in question needs to be off-by-default.
>
>  : Hmm, one idea would be to have the initial -EFAULT detection fill kvm_=
run.memory_fault,
>  : but set kvm_run.exit_reason to some magic number, e.g. zero it out.  T=
hen KVM could
>  : WARN if something tries to overwrite kvm_run.exit_reason.  The WARN wo=
uld need to
>  : be buried by a Kconfig or something since kvm_run can be modified by u=
serspace,
>  : but other than that I think it would work.

Ah, ok: I thought using WARN_ON_ONCE instead of WARN might have
obviated the Kconfig. I'll go add one.
