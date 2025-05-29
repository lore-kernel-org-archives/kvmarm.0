Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1170522DF97
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 17:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748539654; cv=none; b=dNvgYmEwyyJXKv4bIYwzaab7XczpPLvnhYf5QTQ/DA8L8cOhEQ+SCOWo5KBWb13Avj++SwQLo9jni2AvNswJrIyDqPMro5YAj62bTI+nojyl6gfsUUEyMP0Q8DGVldYKBKguPljgcyUO3zoNibAQi9XZ0+VFDYXqU7wntyHIV8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748539654; c=relaxed/simple;
	bh=qH4v453/dendpSvOjjh1ZKW/R1SsJgK2XoSkPc/H1O4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pEpWIYtxXwD8MstZqiq/3SfCigvJFrm9M8LLHgo+evJ6PEPbZ9N3iSXPSafwTBDhpTlIedJezETJ7eDSKMy4VEYD5g1+zBnujfdu2T50y2nZR/r69Z2m/T6Ghttso3u5ohF3eeLNHpOuBZM9CT+neDAbNNdsNkTJW4iIJVInatc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8+N4dZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8+N4dZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92167C4CEED
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748539653;
	bh=qH4v453/dendpSvOjjh1ZKW/R1SsJgK2XoSkPc/H1O4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=t8+N4dZwEfhe+LFdQdFK8MJrzNy7bvLmeld55BQDnlTZUtyshocGIoHG9Q40WZcPw
	 sQjwhnS0pE4+6v1cuKiyCYdZNSqdystTTX9qPQa/JQQDunaV7D1OTBHrpYfvBH8rWR
	 I4bt4WKKQRFnD7KDw5+1is9ziv9jMmW2lYcwx7DVz4OyepjgwIVGLz3qMzuVnQMnjr
	 lifyHr/Wgb/uXXY+3Jej4XdsCuWpCspYzVUXaxBgQIBkyw3VPsoQZuxuMNcjWZ9TSB
	 lectM9/hGEwmawfAB/TYKRzSY600fKZ22CRpVeBgU8mxb/yFrwZrYK8/55QJg8x0RB
	 JrBjN0tSGQ21Q==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60462e180e2so2246891a12.2
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 10:27:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVeku0EfMSOlcP10jY5RfX5XY9yaBZiLDntrKte4IW1Aa5zWJsaqdAdqCUtgyFp9UyRZN4LEgY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yziy/THf2nM/We0BGahTdCtjIDoDQt82eZVBweEzzbKJBWRE/az
	k5ZlA2/10s2ajsW++vuy5cvMVcQNCPxmLDBsxBwgopKUwNC6Gt7vRVvQdCAv/YSzFQmAr3bN9s/
	H/Mu5xsCLbiFEaUHUJ4x+rMqkaTEd4Q==
X-Google-Smtp-Source: AGHT+IG8vuuuHmnAkDYhc0wSUHyMMZZ4pVnP2sLktIt9BGUIiU4Wla89J8p0IqYHCL/M3OMkUGaMQGKSpkLntPI8/WI=
X-Received: by 2002:a17:907:2d12:b0:ad2:2d75:d7fb with SMTP id
 a640c23a62f3a-adb322fa1c2mr29287066b.55.1748539652145; Thu, 29 May 2025
 10:27:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
 <20250520-arm-brbe-v19-v22-5-c1ddde38e7f8@kernel.org> <925bf014-cea8-4cf0-9517-46291db729f2@linaro.org>
In-Reply-To: <925bf014-cea8-4cf0-9517-46291db729f2@linaro.org>
From: Rob Herring <robh@kernel.org>
Date: Thu, 29 May 2025 12:27:18 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJ3t5UvWMBgLEkm_-sD_S7NEor+vWfVkU-d7va6u9xsmQ@mail.gmail.com>
X-Gm-Features: AX0GCFuZiRqbTownBtX9p_AAnxqssjZP9dZ9VucncBlXoHjZthrkTUHlQWalK88
Message-ID: <CAL_JsqJ3t5UvWMBgLEkm_-sD_S7NEor+vWfVkU-d7va6u9xsmQ@mail.gmail.com>
Subject: Re: [PATCH v22 5/5] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
To: James Clark <james.clark@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2025 at 11:03=E2=80=AFAM James Clark <james.clark@linaro.or=
g> wrote:
> On 20/05/2025 11:27 pm, Rob Herring (Arm) wrote:
> > The ARMv9.2 architecture introduces the optional Branch Record Buffer
> > Extension (BRBE), which records information about branches as they are
> > executed into set of branch record registers. BRBE is similar to x86's
> > Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
> > (BHRB).

[...]

> > +/*
> > + * BRBE is configured with an OR of permissions from all events, so th=
ere may
> > + * be events which have to be dropped or events where just the source =
or target
> > + * address has to be zeroed.
> > + */
> > +static bool filter_branch_privilege(struct perf_branch_entry *entry, u=
64 branch_sample_type)
> > +{
> > +     /* We can only have a half record if permissions have not been ex=
panded */
> > +     if (!entry->from || !entry->to)
> > +             return true;
> > +
> > +     bool from_user =3D access_ok((void __user *)(unsigned long)entry-=
>from, 4);
> > +     bool to_user =3D access_ok((void __user *)(unsigned long)entry->t=
o, 4);
> > +     bool exclude_kernel =3D !((branch_sample_type & PERF_SAMPLE_BRANC=
H_KERNEL) ||
> > +             (is_kernel_in_hyp_mode() && (branch_sample_type & PERF_SA=
MPLE_BRANCH_HV)));
> > +
> > +     /*
> > +      * If record is within a single exception level, just need to eit=
her
> > +      * drop or keep the entire record.
> > +      */
> > +     if (from_user =3D=3D to_user)
> > +             return ((entry->priv =3D=3D PERF_BR_PRIV_KERNEL) && !excl=
ude_kernel) ||
> > +                     ((entry->priv =3D=3D PERF_BR_PRIV_USER) &&
> > +                      (branch_sample_type & PERF_SAMPLE_BRANCH_USER));
> > +
> > +     // Fixup calls which are syscalls
> > +     if (entry->type =3D=3D PERF_BR_CALL && from_user && !to_user)
> > +             entry->type =3D PERF_BR_SYSCALL;
> > +
> > +     /*
> > +      * Record is across exception levels, mask addresses for the exce=
ption
> > +      * level we're not capturing.
> > +      */
> > +     if (!(branch_sample_type & PERF_SAMPLE_BRANCH_USER)) {
> > +             if (from_user)
> > +                     entry->from =3D 0;
> > +             if (to_user)
> > +                     entry->to =3D 0;
> > +     }
> > +
> > +     if (exclude_kernel) {
> > +             if (!from_user)
> > +                     entry->from =3D 0;
> > +             if (!to_user)
> > +                     entry->to =3D 0;
> > +     }
> > +     return true;
> > +}
> > +
> > +static bool filter_branch_type(struct perf_branch_entry *entry,
> > +                            const unsigned long *event_type_mask)
> > +{
> > +     if (entry->type =3D=3D PERF_BR_EXTEND_ABI)
> > +             return test_bit(PERF_BR_MAX + entry->new_type, event_type=
_mask);
> > +     else
> > +             return test_bit(entry->type, event_type_mask);
> > +}
> > +
> > +static bool filter_branch_record(struct perf_branch_entry *entry,
> > +                              u64 branch_sample,
> > +                              const unsigned long *event_type_mask)
> > +{
> > +     return filter_branch_type(entry, event_type_mask) &&
> > +             filter_branch_privilege(entry, branch_sample);
>
> filter_branch_privilege() sometimes changes the branch type for
> PERF_BR_SYSCALL so I think it should come before filter_branch_type(). I
> didn't see any actual issue caused by this, but it's a bit hard to
> review to see if it's working correctly.

Looking at this again, I think we can drop that with this change:

diff --git a/drivers/perf/arm_brbe.c b/drivers/perf/arm_brbe.c
index 2f254bd40af3..acdde61a8559 100644
--- a/drivers/perf/arm_brbe.c
+++ b/drivers/perf/arm_brbe.c
@@ -546,7 +546,7 @@ static const int
brbe_type_to_perf_type_map[BRBINFx_EL1_TYPE_DEBUG_EXIT + 1][2]
        [BRBINFx_EL1_TYPE_INDIRECT_LINK] =3D { PERF_BR_IND_CALL, 0 },
        [BRBINFx_EL1_TYPE_RET] =3D { PERF_BR_RET, 0 },
        [BRBINFx_EL1_TYPE_DIRECT_COND] =3D { PERF_BR_COND, 0 },
-       [BRBINFx_EL1_TYPE_CALL] =3D { PERF_BR_CALL, 0 },
+       [BRBINFx_EL1_TYPE_CALL] =3D { PERF_BR_SYSCALL, 0 },
        [BRBINFx_EL1_TYPE_ERET] =3D { PERF_BR_ERET, 0 },
        [BRBINFx_EL1_TYPE_IRQ] =3D { PERF_BR_IRQ, 0 },
        [BRBINFx_EL1_TYPE_TRAP] =3D { PERF_BR_IRQ, 0 },

AFAICT, the only cases for BRBINFx_EL1_TYPE_CALL are SVC, SMC, and HVC.

Rob
