Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95F1186A
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 18:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753814017; cv=none; b=ATyCaE5/BqKWLa7dmaj0qeYJkuz3P4LVxF3gl/155Cds99cGwUeIwmJiq3jA0bU+jKL02AOI0SQMh6T2ZvB37hxloM7703aWIfQocHUqWo6cH1gUbuWn7wu+bYq/fQUCKuYk/K4l9dAUf2WkGe5vtfWw1qLOJM4iulRG3wzG6AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753814017; c=relaxed/simple;
	bh=zhhsN1AqU60iSsHthAP5HUoMBvOnju18nFxPG9F76EM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s6avxPYvTwzFkhMoGqUxZzMwePckldyBA4s136cnWVE7iBMi3mruYm7XWA9bkrnS2gDkuzWg+eDTD28c8qB7NbVMD8by+XtclOghzbC7sNBCJ5Fc3DkrugfVis7EBSXxlS4wfdbBI0GNuw4sCmvDAnRwGkwWgYvztU2ttg5RxvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RVu9/fDL; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RVu9/fDL"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4561b43de62so14105e9.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 11:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753814014; x=1754418814; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7IB94kLTsbGsiDgptDqLFiCExxMxuJKtjoAOZzmwaM4=;
        b=RVu9/fDLnJA8EaA+OM02ZIJX16M+r9bZsPeEFsYi5ZlfjMqsG5cYCGHwlpTqT/408K
         OC2a1vnRwmgGBa3CbubKX7n1UNACt+aaudvpGfdAD7i3G15wZB+uFkdo5lqyoZDIMhPI
         4Iz5YTc8Ee63mTLMJhirNnGMTPiOIg7Md42nTyka3IGooOau/VrijY5GQjSeynpKVgWg
         UtWgAMmAWnRwvzi81+PkurlkDYu/dG+TiAIDacdFSvdRvfKTGE84SEd+lfQYiHNnOXFU
         RyMTm0S+BaXtc8/0ik8Nsu0ykG+szqa6tqASA2vJEUe2hfikLjs84I11EuVfEzuDto2E
         Vy/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753814014; x=1754418814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7IB94kLTsbGsiDgptDqLFiCExxMxuJKtjoAOZzmwaM4=;
        b=nuhCLHPRUCw62eTBH0tPQMrf16w4KrgZD+vcFAhX/wV+UwLIrds34La/3R388w2Qwd
         zniU9hMhwCMjD3KBJwD7sxFZ99tqm5fZ0isHz3jUE+N52UkqJX6divgcbzS7ltYqlC8h
         PNsW+Oyponv6OqshEOjNp6F+n2iGvJwI3lJfBLKwK2w2mwxeu5qB+q7abruz02m3cUUE
         1DzqOIZg1ntaIck1czbxm4MZKmGiu4xZpdFGT5gjPmJkEWsUr4yv0zu7LvP1DUh2Z85n
         y6unyWft1oU0quFmgJZiD6H/cJySvYOnvYZKKy/l1foL6fLmciOGoaXwKB4r6yuXpmXx
         pq2g==
X-Forwarded-Encrypted: i=1; AJvYcCWNQicnO/X5UAink+/Vc2SyQF7gEzUpPe5EyT4QtUPlIVFS9wnccf/ArKjf0zmZG0KlPsVZJdE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzfn/qePPshse3eNgWQwpKDtngNGqwASAae1mfBKuiXPiPH1oSI
	gD8K2Pzeq7bvGFYI3EQ7Kgrmw8Ev2dNttHHJytpkvYOZ18rrujeZt2tQc6Yll26PGdEgEOXlTbV
	AZEjjUu0d4VKSgV3ICmIb5ApK+UfyRmuiQkZxl940
X-Gm-Gg: ASbGncuSPEVCbFHGIboxUf5tcX6rQGM5bsZDVPcMebmchIwch31GRVwSrNMyZ0RGcKl
	FEl2KFAE+QyanTDS/jcfFounT2M5qc8iBqK7khFkOM/qpJ0bEHfdmYc5bkzNcIL6VpEJdPIJA8z
	f045aPxO+sZF+wAHljcGGCEpJQD3C+cdnRsbLgp2sK3IVqLCl7NxjGoiKQqzJz5gJ46o57T/BSj
	024JiQofuoZPp+4zIjlaTSRDsGpP2Zww59vug==
X-Google-Smtp-Source: AGHT+IGKAkWetZ1FvQ3c2TR9sQ5wbErOwg/m1YLthxVSeCgARrfvYFD3xx1XvoVEZiCGve6ALl+xhDJWyNwcPNrcTPo=
X-Received: by 2002:a05:600c:859c:b0:453:5ffb:e007 with SMTP id
 5b1f17b1804b1-45893a9b7f3mr63305e9.4.1753814013998; Tue, 29 Jul 2025 11:33:33
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CACw3F53VTDQeUbj3C75pkjz=iehbFCqbrTjYbUC3ViUbQJAhsg@mail.gmail.com>
 <CACw3F50O9Z=hPFNzeatzr2k+1cKX_nnqdzKJOMEdmjmfy3LoUg@mail.gmail.com> <18df01493fee0547d8b5902b986a2334@misterjones.org>
In-Reply-To: <18df01493fee0547d8b5902b986a2334@misterjones.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 29 Jul 2025 11:33:22 -0700
X-Gm-Features: Ac12FXyam7bjtry9Vixp29M5W0s0neJG-QDbW5LkEpRdu8HEgX8jGbg9nB_4Esc
Message-ID: <CACw3F53j60QSz=D0HozuazCSaKoOWmODZuydC8152rdxT-fRAQ@mail.gmail.com>
Subject: Re: [Bug Report] external_aborts failure related to efa1368ba9f4
 ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
To: Marc Zyngier <maz@misterjones.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

That commit fixed my issue, thanks a lot Marc!

On Sat, Jul 26, 2025 at 2:18=E2=80=AFAM Marc Zyngier <maz@misterjones.org> =
wrote:
>
> On 2025-07-25 23:38, Jiaqi Yan wrote:
> > On Mon, Jul 21, 2025 at 7:00=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com>=
 wrote:
> >>
> >> Hi Oliver,
> >>
> >> I was doing some SEA injection dev work and found
> >> tools/testing/selftests/kvm/arm64/external_aborts.c is failing at the
> >> head of my locally-tracked kvmarm/next, commit 811ec70dcf9cc ("Merge
> >> branch 'kvm-arm64/config-masks' into kvmarm/next"):
> >>
> >> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
> >> Random seed: 0x6b8b4567
> >> test_mmio_abort <=3D fail
> >> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> >>   arm64/external_aborts.c:19: regs->pc =3D=3D expected_abort_pc
> >>   pid=3D25675 tid=3D25675 errno=3D4 - Interrupted system call
> >>   (stack trace empty)
> >>   0x0 !=3D 0x21ed20 (regs->pc !=3D expected_abort_pc)
> >> vobeb33:/export/hda3/tmp/yjq#
> >> vobeb33:/export/hda3/tmp/yjq#
> >> vobeb33:/export/hda3/tmp/yjq# ./external_aborts
> >> Random seed: 0x6b8b4567
> >> test_mmio_nisv       <=3D pass
> >> test_mmio_nisv_abort <=3Dfail
> >> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> >>   arm64/external_aborts.c:19: regs->pc =3D=3D expected_abort_pc
> >>   pid=3D26153 tid=3D26153 errno=3D4 - Interrupted system call
> >>   (stack trace empty)
> >>   0x0 !=3D 0x21eb18 (regs->pc !=3D expected_abort_pc)
> >>
> >> It looks like the PC in the guest register is lost / polluted. I only
> >> tested test_mmio_abort (fail), test_mmio_nisv (pass), and
> >> test_mmio_nisv_abort (fail), but from reading the code of
> >> test_mmio_nisv vs test_mmio_nisv_abort, I guess test failure is
> >> probably due to some bug in the code kvm injects SEA into guest.
> >>
> >> If I revert a single commit efa1368ba9f4 ("KVM: arm64: Commit
> >> exceptions from KVM_SET_VCPU_EVENTS immediately"), all tests in
> >> tools/testing/selftests/kvm/arm64/external_aborts.c pass. I have not
> >> yet figured out the bug tho. Want to report since you are the author
> >> maybe you can (or already) spot something.
> >
> > Friendly ping ;)
>
> Please check this:
>
> https://web.git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/com=
mit/?h=3Dnext&id=3Dc6e35dff58d348c1a9489e9b3b62b3721e62631d
>
>          M.
> --
> Who you jivin' with that Cosmik Debris?
