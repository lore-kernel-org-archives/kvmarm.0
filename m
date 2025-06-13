Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406FB2397A4
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 21:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749849941; cv=none; b=HMj8c0o4WfKy84mp95kmEhT+1qnL+1C880LFYk2GqJQU4S++LG46y7zi/mplvECpUZLqdDzSvhvLf7yBWqNgMVB7XTECyAiOaFYHPWrb6tKaEtJhM8eoyo55CWMTEsxjkqXGb7elPgSJkSH9D80FY1x5i3ZZ9mzrE+tmZfEPYw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749849941; c=relaxed/simple;
	bh=sHV8yx62yol9Bk56YKbLE0IVF5sfS+vZdmV+r8o63x0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILUgKQ6XbmLbF/MAS1ZpPTlO9cfKmugpnLQRZgSCDe+3kQHaQCEF40Osb4VyqCe3f25c02ZF9C/tLV6i6HZ3aKkvT/krkWt1x4377cNdXfqjdGyrhVAdUlXWDJRUjUolx0uG3fDHD3PUZ5Do8vKGpVoi+pmoJLfb7ZMfNCm1aiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lo1Pvri7; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lo1Pvri7"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4a5ac8fae12so114071cf.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 14:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749849939; x=1750454739; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPUzIppHcu65DcXjx+xmQ4p2o7TM+1lbGXLpXn/D90M=;
        b=lo1Pvri7kP7jfi/gvpHy8xDL7eIITXqfKRtzVmil1/bVNuDCFAxTlHwogFEvQdgZc4
         b7vkgdjubPCY1/IhkjFiSJExPQIPBPfW1yAYhjmtwGFG1qVo4UCe/Q6GUomms+00iPeL
         hwXI+Xb6RwH29RtCJrpKKRVsEd6p99N9I5yHT/42P5FP6Ulp+oTZnqAoVasACcKCcvzH
         S/TkyEf0dh1VIG5+6q16HQ1qp2OMNbzn/B4MsVwO542+rZKKBNIedjV6aRwidVUns2zl
         4AX1LblAoXB7OhbG3lM58+miSMLfrHyytexc5PulZ05e8IfgGImh6Cm9Yp4O/vcLSbLS
         L3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749849939; x=1750454739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPUzIppHcu65DcXjx+xmQ4p2o7TM+1lbGXLpXn/D90M=;
        b=DRQcND+yBPAoNXYN+FtMhwrDTKG9BRnop6oFVnBpN8uJn1/HnhQDl2UAnwG1M8zxEk
         2Knqoq3AqOFzdVivORKLyyX2VxNIkZOWskAXo4RjfWGTEtWmz/U0XfmnxWzTlzlO9yCe
         eCYmiYged/Qn0l6KCaIBg4BW7eStRbRaxyH2UYXqCh3SSVIaJKjVlio8sRBeUrBOVIrg
         U9kz/GeZ2DkjLZRJuts4HFO5J5wC4+VJQAsAu3nyy1FBkIyne62oihyrk1Q3vPGQbqoO
         MffWWuig/ShtCmCLoO33TB+bGXrX0aWn476yofmjnqZinVuKqh92Cqef7Ta42vKp+qLr
         Dltw==
X-Forwarded-Encrypted: i=1; AJvYcCUYkmOn0ygzFq33tmSn7GsDABdgL7DRGWpS0M+2sIrI1Rsr9Uy+HXaLX4xwN0SVjE3eFkNwAJY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuHrlb1DwVpur8t+TMQgNo1DsiPvsxuqVDebUGAOe/mI1sX7hW
	I8vTNw12pi/QjU87YnVl/4gZPiboVu2fs5HxM6rczbyvm5hmofj7Yjt875BYZvTuowmoJvFz+J6
	E44+43BkkKBtvHZh2kK78thgObbkp12qs+zdZrIVk
X-Gm-Gg: ASbGnctC8+a3rdLLd/Wgopi1WioCppEO5vB+L0LDzc58yzSzAEeSV7YwxJaRcXLQSgW
	X1mDCxIrmn+fQetsTKQeCykbEoZZPoZXUKoMjpRQS9zBpIUGfssRFOGwmRf4iybPzZifI+aggGY
	me3Bg5t7P+qSyMM7rrsTV1vunCLzoarxw7m25s/tnyBVJ/3ic2selFjQ==
X-Google-Smtp-Source: AGHT+IHRTXKzQVq2KTm0RSt5qVgrnPAP0bkIbd607Uu6/KmOUX6+sJKqoHDdBmms0U0ufq7rNkEH/UqGIKX1Oa8Sr14=
X-Received: by 2002:a05:622a:610d:b0:498:e884:7ca9 with SMTP id
 d75a77b69052e-4a73da5803emr310651cf.13.1749849938737; Fri, 13 Jun 2025
 14:25:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250613155239.2029059-1-rananta@google.com> <aEyPswyvfJ2-oC3l@linux.dev>
In-Reply-To: <aEyPswyvfJ2-oC3l@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 13 Jun 2025 14:25:26 -0700
X-Gm-Features: AX0GCFvCkuSdtDxaxbaw03np7924c6ya2dvq2vPeL3lenyiqTkrCE5acxgbNPCk
Message-ID: <CAJHc60yacW7-1K3Uw9RT7a8qH9JyTXouiP=6VP3gifqzHgMaQQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] KVM: arm64: Add attribute to control GICD_TYPER2.nASSGIcap
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2025 at 1:53=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Jun 13, 2025 at 03:52:34PM +0000, Raghavendra Rao Ananta wrote:
> > A shortcoming of the GIC architecture is that there's an absolute limit=
 on
> > the number of vPEs that can be tracked by the ITS. It is possible that
> > an operator is running a mix of VMs on a system, only wanting to provid=
e
> > a specific class of VMs with hardware interrupt injection support.
> >
> > The series introduces KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap vGIC attribute=
 to allow
> > the userspace to control GICD_TYPER2.nASSGIcap (GICv4.1) on a per-VM ba=
sis.
> >
> > v1: https://lore.kernel.org/kvmarm/20250514192159.1751538-1-rananta@goo=
gle.com/
> >
> > v1 -> v2: https://lore.kernel.org/all/20250531012545.709887-1-oliver.up=
ton@linux.dev/
> >  - Drop all use of GICv4 in the UAPI and KVM-internal helpers in favor
> >    of nASSGIcap. This changes things around to model a guest feature,
> >    not a host feature.
> >
> >  - Consolidate UAPI into a single attribute and expect userspace to use
> >    to read the attribute for discovery, much like we do with the ID
> >    registers
> >
> >  - Squash documentation together with implementation
> >
> >  - Clean up maintenance IRQ attribute handling, which I ran into as par=
t
> >    of reviewing this series
> >
> > v2 -> v3:
> >  - Update checks in vgic-v3.c and vgic-v4.c to also include nASSGIcap (=
via
> >    vgic_supports_direct_sgis()) that's configured by the userspace. (Ol=
iver)
> >
> > Oliver Upton (2):
> >   KVM: arm64: Disambiguate support for vSGIs v. vLPIs
> >   KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
>
> Make sure you run checkpatch next time before sending out, it should've
> warned you about sending patches w/o including your SOB.
>
Hmm, I do run checkpatch before sending, but I don't see any warning as suc=
h.

Example:
$ ./scripts/checkpatch.pl
v3-0001-KVM-arm64-Disambiguate-support-for-vSGIs-v.-vLPIs.patch
total: 0 errors, 0 warnings, 107 lines checked

v3-0001-KVM-arm64-Disambiguate-support-for-vSGIs-v.-vLPIs.patch has no
obvious style problems and is ready for submission.

I do see an option to tell the script to ignore the check:
--no-signoff, so I'm guessing it should check by default? Or is there
any other option?

Thank you.
Raghavendra
