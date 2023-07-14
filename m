Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5087013724
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 13:46:57 +0000 (UTC)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-51e55517de3so9371a12.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 06:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689342416; x=1691934416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cG5vg4zkY2IhP/vDKR8jxn8x/o71eYBsN8wA/LPy7IQ=;
        b=efZUYZdr7dO7xvVoBdwscxelunm7h8kanShCI+CQ7eNq4oKTYFfrFtx/m8MfSQ5x+k
         UdNYkVD+qNHaZAV+VZ3x4HQ3gpVFV4URPxSiVVkAQDb3KCfZHjrCAOmbHTNzGZDdd+CK
         VOCutxoXEfK2kdh232R8sk0NpJNkV/+ETRm2yeuv/tFSdm5lS2XkW+T7sXiW3PoRmvb0
         RrfP5weCJzKZVVCrAUTUTHvQ7/Qbach+iZy/rsBjAC3t8UoJmLcEtA6hP5EP74EV2p6e
         H0nW9UxBaFhdD9t7c/K5eL7Qs1CdoPYwdOKuflIjpPZuw6ULpwtWP2CxLv5t6WPJsToI
         aB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689342416; x=1691934416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cG5vg4zkY2IhP/vDKR8jxn8x/o71eYBsN8wA/LPy7IQ=;
        b=FF5/Zrm/ucsWIxTk3WXCLk0BKwPenAxkWACaSeUqIzqKbYz0GroPdyxo4Kp5XE4Fyj
         qKMMvbZ5OpI+Ad7QhGODZzy6ixEo761z6vIPx53ZZmK5hdu3eB6DR2imcQBhLXYMos2P
         bEmyXP2Xw5+M7ATZCcMHJe5EBba25zx4RteD1JJ8SFpY/qqPKG5NtAwSqGQlZkJH3kyv
         LeX2p5mJzZpvaGK9DobHpx3fatZrHtEIC/KSiDw51xz9IG3LeUS7sLu6uLzsQCSd0/B0
         2Z9OC+YqbQtQhR9ZiAZas0xAYr9SqZBFtObc2gkKyHnZkAbOMPULXAEr9pZfruSN3l2X
         YtHA==
X-Gm-Message-State: ABy/qLbigJmNMV2vrUojeVGUoqanuETuKyuP3h/lrMkEqBMaKPWQ0ox6
	d9KgJ7p5c5UQ9HJVi4kjE7+f2rTul2/RqoX410DY5A==
X-Google-Smtp-Source: APBJJlFtNLv3SZMGpqm5paTkIYxfV+FoqlV6OkFVGuC3Ckr41VGSOodx4YBU7k640EUVnLlBvPCX5lxHdkBFKJiUj7g=
X-Received: by 2002:a50:c346:0:b0:51e:5773:891d with SMTP id
 q6-20020a50c346000000b0051e5773891dmr434609edb.4.1689342416099; Fri, 14 Jul
 2023 06:46:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230713221649.3889210-1-oliver.upton@linux.dev>
In-Reply-To: <20230713221649.3889210-1-oliver.upton@linux.dev>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 14 Jul 2023 06:46:39 -0700
Message-ID: <CAAeT=FxwcxagQ4a4s1Ew6dvN+yRGS+7tAkVjtfR8Shd-P_V5Og@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Correctly handle RES0 bits PMEVTYPER<n>_EL0.evtCount
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 13, 2023 at 3:17=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> The PMU event ID varies from 10 to 16 bits, depending on the PMU
> version. If the PMU only supports 10 bits of event ID, bits [15:10] of
> the evtCount field behave as RES0.
>
> While the actual PMU emulation code gets this right (i.e. RES0 bits are
> masked out when programming the perf event), the sysreg emulation writes
> an unmasked value to the in-memory cpu context. The net effect is that
> guest reads and writes of PMEVTYPER<n>_EL0 will see non-RES0 behavior in
> the reserved bits of the field.
>
> As it so happens, kvm_pmu_set_counter_event_type() already writes a
> masked value to the in-memory context that gets overwritten by
> access_pmu_evtyper(). Fix the issue by removing the unnecessary (and
> incorrect) register write in access_pmu_evtyper().
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

FYI. Looking at their reset values, fortunately, the pseudo
"unknown" reset values used by reset_pmevtyper() has the
bits [16:11] cleared.
I would think it's a bit fragile, but not a real problem.

Thank you,
Reiji
