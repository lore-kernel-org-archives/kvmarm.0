Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742FF3A6411
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 10:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779360256; cv=pass; b=qpytkNEN1nt6pN0rx9V1mb7L1lHnuTrQ3KsvjX9QdtS30Kdd3w/nci3zGzpc042KOxm/f4UODxN+kxi42ObhC/AlEZKDeqsS7Of7U7RQsPx2EUjuocin7T9t009dm9s11S0uAFVVbFZl0C7gfh9C/Ox3yflnFfo03wEDLLRcxTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779360256; c=relaxed/simple;
	bh=NQ3Nusm6YkbFPT1vR/R2GlJCmX9emImzU3s5lu4qsk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CKO50JNXjO8YdWPlfJgpULJx4ZbzNHJgi1d2Kqb2D5EZCx2duAXGSsT4sIVHzytcxDVXevKjV+Gyi19ZDOiYk77PtU9oDl+Kvy9+CJh1qH9spNOBJFasqJ1lRynAI0LVvg7/JdTite+QJVjOSYTM6SRRhbeMT/RsD4mV+KvSdX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cR0ey0yG; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cR0ey0yG"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-515548f390fso2871cf.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 03:44:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779360251; cv=none;
        d=google.com; s=arc-20240605;
        b=Hd2wpJqCoxc675+3Vx2YXyVPEjKp1sBB+vnojQKaenWn4hFu/YaAurTDZGnqwbypnL
         GqeKfurka3zk2sXB7G15zS47I4PWBZoSJnhpZ7SkFbag7YNDli/RKES934US1phetCDh
         k43WavWbBJNBk2UWYq2T4DkXruJTffrQ6ZPyXVv5z9sA93+JIdcAzo+OfvCS3LT+Elk1
         cprl1aNTXySmrv8bfh04suOkJ5nLGgHQvwfW9D6gyPSw/pEa/6szfg40wdQ7EUCVFBgG
         ZwVb2KF2fbWRXkfpfNRAuEne3mg7HRxEcrj+cE6jYtwlokjnvfwz0EoAzyAfiR+2bdmk
         40AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=01uiUNMkWOnOyoQp4EjW7o/7679tfblvQE/eVZhbN1U=;
        fh=Ms3tCFuJ1/Vzb8wuuACY3CxEfkv48lcIHGEN4jKLXSQ=;
        b=g+HGJdcT0rI5fhBSoHWaOhX9brcJ+ro9hHpE69jVabet1OLz+TYcjwyUMWSF8OFtLM
         Jwh+9xIQ4V88F/0lqrT9cFJ6GfaPEO/SJb9PnOkfs9snFRWflcmetm+B5h2tMr1utX1w
         hgB31o8CJSLlFJfQkACSlrdyZBxFV9808l9RowYFIIuLoDuzdnmRW1gJeQHxvJh7B8qa
         iUHI2LmQ6ZqTahZiy1AIh/8OU22cVBLgh8ElQPhsx2Kyz1gbhMRtlN314gBm0wZdf2cK
         yN4lreGAHKz53MiNiqUCj2cWM+B1jOot4DxaXf5gl7jB3K3oPN8PKmEDfkpmDh8LUkVo
         vhxg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779360251; x=1779965051; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=01uiUNMkWOnOyoQp4EjW7o/7679tfblvQE/eVZhbN1U=;
        b=cR0ey0yGM/vN4du0ji3vJzUewFaoJU4EPzRKMqvPfMvY7vIVc9mmouKz3UmtGV3T/O
         oopIWzWsYzRlzgYqa8mFVgEQaU0bZq5UqKk0DoJ480iuFs4uAu73V4bP8WpgtFA+/YWS
         GtYTvpRCGciZGOsxpD4RACgP1R7PbYmsEKTHqM+XBfLzuspIAfOvNrODzu5iXvmWSiwd
         0ChGYRAKJGcEcBRMg0NBzvs9nBYcT+Jj3F2mKJ5mykPvqZU5X86Hywp7j4hhzlZ/YdLu
         VCFPa7S8NYVbzi6OXmRO75Ee27XVOiYWfPESpcRr9BjA4Qs95F15SGw61mgjubGW8rrk
         gVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779360251; x=1779965051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=01uiUNMkWOnOyoQp4EjW7o/7679tfblvQE/eVZhbN1U=;
        b=oWIgJCejI8wAYnUWauy7mhc8CFUNy5gpFqYG2PgXUPhYWGz7FZ5BpNHEAcK+H1U8bw
         l2gYbB69mfzIfqUf8KiLhLbSLHF+fVUvjosjb1Ma8NJYjJT780gCAdlIU00nEJLc7GGz
         EgXkTHejeqF67S1Oo1eoUEo9tHwQqMKd+FiEOzaXBEbSRab/CwCLGc9xgukmueEOkfLU
         jp0OtebNtf6Z4NG90Pgy/aEST7hD46J8tpP6VsFfPrKItFVX6A9qPwOdwU/QeEZ0scfD
         LZidsTW/exPaGhibRolpFgT0FiVLZSM6HVu9Hqn586yWKqp7TqU1da3rg6r07Po9AYjW
         55rQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mbD6BD4GeCw0yUDgd2xFFPogoBIU7ptOeSw8IFKgHbp1You4adZLmqcOCbv+5prnxqaGqlQQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhU65eRMC1O/Fo4J2E8639QsMIdbZFccWifQljB7rz/aWBVDKO
	nvR7ArFwyIpeAiOyt6wfVB6O0QE7YB649XUN8B8iTv5tn0wV/38GVX2qh8A9iPVdMBk3HE2Vqus
	gJc8vToTOYdUhtNg/5uw6c6CIC79TYzfFbYPRF4fw
X-Gm-Gg: Acq92OEtN8YSpy2shK7GX3SRXmOshfYhXd+ez2TyYtOpbQ6Yj/F7EdHakE4DbvDa4QI
	rfzfl67m38yL2enTdBqWSK0pBiWXI2rQF/DRkxUMaHUIy5zl45R1iL4oONc4NpwM1FCQR0kilE4
	fEmdP68UYFp0XDPcOLn/yo+xucE7ddNJYFRqmmk5FGnZmJcrsN22uqrXhpNRRXDyLAQjljKyVY1
	2CoP2rssEKz3mcNktVOG5qrFGiEJgnwy/9Vh6NoZ4m9seeQydxZTZmv67/Ndy5NMD1T6T/8lMQ4
	itO34jxbgOZ4JH66U6NBRX9Zs5MS53MRBOrAOIRMLlT8c0KD2BzG
X-Received: by 2002:a05:622a:1909:b0:516:4f62:85ee with SMTP id
 d75a77b69052e-516c54daacemr7650001cf.19.1779360249995; Thu, 21 May 2026
 03:44:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520204948.2440882-1-smostafa@google.com> <20260520204948.2440882-5-smostafa@google.com>
 <86ldddw4ht.wl-maz@kernel.org> <ag7eq3bfBOxfaZ59@google.com>
In-Reply-To: <ag7eq3bfBOxfaZ59@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Thu, 21 May 2026 11:43:58 +0100
X-Gm-Features: AVHnY4LZQTvaETc0PFZc4ErDn0OiwyQemmgBHI89H_ICLndAOva3c3G1YM9luGk
Message-ID: <CAFgf54qpNVvzSiV89g12-4jWeacm=06LMjCooeU1Mt+3sqWDLQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
To: Marc Zyngier <maz@kernel.org>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	catalin.marinas@arm.com, jens.wiklander@linaro.org, sumit.garg@kernel.org, 
	sebastianene@google.com, vdonnefort@google.com, sudeep.holla@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 11:30=E2=80=AFAM Mostafa Saleh <smostafa@google.com=
> wrote:
>
> Hi Marc,
>
> On Thu, May 21, 2026 at 09:28:46AM +0100, Marc Zyngier wrote:
> > On Wed, 20 May 2026 21:49:47 +0100,
> > Mostafa Saleh <smostafa@google.com> wrote:
> > >
> > > Sashiko (locally) reports out of bound write possiblity if SPMD
> > > returns an invalid data.
> > >
> > > While SPMD is considered trusted, pKVM does some basic checks,
> > > for offset to be less than or equal len.
> > >
> > > However, that is incorrect as even if the offset is smaller than
> > > len pKVM can still access out of bound memory in the next
> > > ffa_host_unshare_ranges().
> > >
> > > Split this check into 2:
> > > 1- Check that the fixed portion of the descriptor fits.
> > > 2- After getting reg, check the variable array size addr_range_cnt
> > >    fits.
> > >
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/=
ffa.c
> > > index 1af722771178..e6aa2bfa63b1 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -607,7 +607,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1=
_2_regs *res,
> > >      * check that we end up with something that doesn't look _complet=
ely_
> > >      * bogus.
> > >      */
> > > -   if (WARN_ON(offset > len ||
> > > +   if (WARN_ON(offset + CONSTITUENTS_OFFSET(0) > len ||
> > >                 fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
> >
> > Do you really want to keep this a WARN_ON(), given that this results
> > in a panic in most pKVM configurations?
>
> Which kind of configuration will that check fail on?
> Does that mean at the moment pKVM does out-of-bound access for
> the header?
>
I might have misunderstood the point. I thought you meant the new
change would cause a panic on most configurations, or were you
suggesting just removing the WARN_ON?
I can do that, I just updated the current faulty check and left the
WARN_ON as is.

Thanks,
Mostafa

> Thanks,
> Mostafa
>
> >
> > Thanks,
> >
> >       M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
