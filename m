Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBB828C5B1
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 10:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787999865; cv=none; b=o9PQKTiILCJA1egPCBiV8lO7cEOdr8QnbW4/GsWbCMX/XVQcPLp1BtvpeDofDpNItp5NiZTKCzAm61WFI/+Q+JONEKGjhr6oShuaa4VvYGOqaMeuVBQ5e2fUJ4CXybfjKsaBRGX/znX3oeKVO6VGW+34+0SzFFggVNZgFzPLbBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787999865; c=relaxed/simple;
	bh=yoybuzSmW4uCrTkEL1zvInXoMlH9rjrEE55GFgfLq4Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YMOJF0MNuPnf73r12jCpbnc59FPULJhdire58EMO+BaO364VsCTqMqxmPoB6jxZEz3RS7ngwAJOh+/rY+9/+AcrZUHdXdEsQbrI+ndGtFw1tryiynsoDFz58Wot6aTlsZsupirxJgL03KPMPrTxGjZ64ngi1C6dQHyhTWuP0ERk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f6JxTffo; arc=none smtp.client-ip=91.218.175.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f6JxTffo"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yoybuzSmW4uCrTkEL1zvInXoMlH9rjrEE55GFgfLq4Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787999860; v=1; x=1788604660;
 b=f6JxTffoYzFc+YzJBjcSd1pGXb6Jil0xC3zYhHZqfojW5vwlLumxRU+vbAz9M1H6v80mHcNP
 ndu+pQ0CiWme4biqPBIJ9Y+/xHKfoArdv33rUukDRuEoeq4ePhq2gSvuvzjeCH7jznWnQUKCVlW
 hKph0k9DgUYePu8NFFgHCmzE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f04ed4e2e858ea7d;
	Sat, 29 Aug 2026 10:37:39 +0000
X-Mizu-Trace-ID: f04ed4e2e858ea7d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so1908e87.1
        for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 03:37:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxNs0Xqj7HyD75uZMQ1ezz+CbCSF2KMBxd68eZGfHvnYCwji6cUWCWQ4oxPLqrAHfMbCAQS/qI=@lists.linux.dev
X-Gm-Message-State: AFuF++kQsui7z1AVFmyGlF+kTSkFvQstHH54s/sr3hqZS5ztRYZR4hDH
	S9EH9MvUwdvqlF4QirQxrAr72VuMOrIMWvDql9k4qiFX2HplqdQ6zoAIlHyAkQ9urGsUixeu5wL
	zj2NotAHsm7bPFqav6/lfZ3PSVvDH9sRLy8Woq83N
X-Received: by 2002:a05:6512:1093:b0:5b4:9dba:4ece with SMTP id
 2adb3069b0e04-5b5ef20af9dmr96390e87.12.1787999858471; Sat, 29 Aug 2026
 03:37:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260829071120.2522788-1-fuad.tabba@linux.dev> <20260829072103.D20271F000E9@smtp.kernel.org>
In-Reply-To: <20260829072103.D20271F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sat, 29 Aug 2026 11:37:02 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzfcYWbJqJrzow8qus82QLQVNxNrHV0bqVnXKD=ejU7uQ@mail.gmail.com>
X-Gm-Features: AcwNN1U7-vtk-fg4Clu6UO7RTMdTZ9hLeREFEETZ48Z3QFWNLfcXBDRl1zwueGA
Message-ID: <CA+EHjTzfcYWbJqJrzow8qus82QLQVNxNrHV0bqVnXKD=ejU7uQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU
 under pKVM
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 29 Aug 2026 at 08:21, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] pKVM unconditionally leaks and overwrites protected guest co=
ntext (including general purpose registers, system registers, and trap conf=
iguration) to and from the untrusted host on every guest entry/exit.

Coming soon Sashiko, I promise. This is in preparation for that.

Cheers,
/fuad

PS. I've been preparing for you...
> --
>
> commit 4f524814ed8b14fca5b29ea5c6eacae85dfdeb56
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU under pKVM
>
> This commit ensures that the HCR_EL2.VSE bit is synchronized from the hyp
> vCPU back to the host vCPU on guest exit under pKVM. It prevents the same
> virtual SError from being pended repeatedly.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 65a7c735aa398..be35ff5958c82 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -276,6 +276,10 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >
> >       host_vcpu->arch.iflags          =3D hyp_vcpu->vcpu.arch.iflags;
> >
> > +     /* Cleared by hardware once the guest takes the vSError. */
> > +     host_vcpu->arch.hcr_el2 &=3D ~HCR_VSE;
> > +     host_vcpu->arch.hcr_el2 |=3D hyp_vcpu->vcpu.arch.hcr_el2 & HCR_VS=
E;
> > +
>
> [Severity: Critical]
> This is a pre-existing issue, but does this code unconditionally leak and
> overwrite protected guest context to and from the untrusted host on every
> guest entry and exit?
>
> In sync_hyp_vcpu(), just above the lines added here, the code copies the
> confidential guest context back into host memory:
>
>     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>         host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
>
> This appears to leak protected guest register state to the host on each e=
xit.
>
> Additionally, on the entry path in flush_hyp_vcpu(), the untrusted host
> context completely overwrites the protected guest's context:
>
>     hyp_vcpu->vcpu.arch.ctxt =3D host_vcpu->arch.ctxt;
>
> It also seems to allow the host to inject its own debug trap configuratio=
n:
>
>     hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;
>
> Could this allow the untrusted host EL1 to read and write all protected
> guest registers and inject debug traps, breaking the pKVM threat model
> guarantee that host EL1 cannot read or modify protected-VM memory or
> register state?
>
> >       sync_hyp_vgic_state(hyp_vcpu);
> >  }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260829071120.25=
22788-1-fuad.tabba@linux.dev?part=3D1
