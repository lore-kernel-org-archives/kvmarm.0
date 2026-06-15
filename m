Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F5A3F1ACA
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529211; cv=pass; b=j2046f93t80/H62ljWycSj9rCHvDrFgm7NrEEZPuL+/6oYvUpdzULhulSFl8HeUjBUwCfRfLqjFxuNRzmwZh8l5O2RMWmXJg2cPJ6Ez5iTLIaJG3u7AAcqma9DUhiXn8s6L5MuUwRUFasVb/zOY7b3Iq6I6gi/V9i1ljjYRJe04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529211; c=relaxed/simple;
	bh=JFSXX89TRMF0cmJ1cK7Y0aUHUQ3U5IIYGQ/no+czA+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PuXFMdo+mmf8QVPCBPoKEnUlrr7lzzrrrYJToChV/cUttjGXorcydvbYytLO1FlbszxwGbmTAe95bu8vJc1ksLrGcjhZb8uHnBxUQMQ9hZurl27LBlbrYA5FMdAzb3QNruavMFe2jMnzbVX1wylwC8zTX0BSn3XFjfQ6+OsjXtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LD+vSaph; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LD+vSaph"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51765331535so941781cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 06:13:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781529209; cv=none;
        d=google.com; s=arc-20240605;
        b=O+78+p0Yws4Jvq6z0Oobs2oX4UhpAnh7ndqcq+yf1ZBVMDbRKBejXcm7Xw09gRemnG
         WNiCJ14r45/0W+aP+dZ4zVmSVLWDvJMgQrKh3PRvKziugIbvNDBvi+78SFvG/s4UEWDi
         59/EHi7ypPy89g0dg59X3omXAUTe0vQS+xBUPCUMyrWbNi9Btrj5PTsIfyPPc3cYHwnr
         nSF/HohenG5dNMa6eyzE+XYOcGgJESvlcQR22WFqL44izWv0TyghyoWJ3C0VB0uv6JMs
         Sm3s50cEveqVuRJUPzlR3qnRZDOIrJBkGtLH7USvunYTqIPk1XeXWuGTLiF9XXvnijQX
         4a1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2In6AGzrSURwEbShzRwtRfVTt7zDjTYOHDQU3MzBeLw=;
        fh=GVDQE9m1AjLMAHXQMi9W9JDO5rWkFrSRhH226c3NyCk=;
        b=S5XWUNgpzydVOg9047bMaK/ilc2sjgAcU/Z1ByfwsHyNeyCY2tKsnmXcQJ7nfDxW9h
         tLYUxjxTUXa5xOeg8vcyGQmHlWdzMbTJovJ4xci9djDEUiNpMqoPNIJhtJGVsQTCG6ic
         +a67nCmNKMJcqz/puy6vLvO8khcGZhHr0BvlI6mzUyYT6ddgXnSI8/al9hUp/XEAxLXh
         KPSXpJHvB0V6AigAVqxxi1IAe3EeYcJf4DfcP08U82xoq+i1DWwPme1Z/2J3dAhdyqff
         QwYDEc9skHeW6P5fqOhJ5lLpB9lzELXqUsOoFF8zWxTB62Q2EQmCkuDsQTyybXOkCiYt
         w7Sg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781529209; x=1782134009; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2In6AGzrSURwEbShzRwtRfVTt7zDjTYOHDQU3MzBeLw=;
        b=LD+vSaphrhJfopfM9hRC12Lj2m8vjAu6J0eDmb6MK3enxFlOB2t1gB8ZV+jfUwwOgC
         gznXN3ZiFTOIlScIlRSqnKEKymBVR9FK+axf3RMwe2xwdrErp6eKZlKmMKSOR8O70xk1
         2m3LldtWl3LZFRxtW7j/9+WkkKmARvT4Cy90IV06928CKY0YRqWAwVGUDQgnHLqKwe72
         J02g7vvN5uFj9bkw3yZBwaQa1kxBcRF0dm1S+XFhzbKgQZgwRVV+CVAjrruU1rKefgag
         ohLynfATHcLojaXzQc9bjWbVzabtRPS47gGbU3cbBSFnpUuMIodcPFn6t1uusfNAW7zs
         LLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781529209; x=1782134009;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2In6AGzrSURwEbShzRwtRfVTt7zDjTYOHDQU3MzBeLw=;
        b=MLrxdwdv8abOi4eeK2dVDadpNHjRdHfZMHlTR/EfVi6dY4XSanlL3YTF5uHnL7zac0
         vV3zfb9SPxYrJLeW78gnvpsKDcpPQORlKyd/VCXLRgJ8cSY4Jv7FxowQxeFFyzSzub3C
         RUp7KXu1bYWLOYUwyg7Cz/uQly6Ej7ncd0rL5FZVfaf70qylz+govqlLzEZJaHijMhoF
         GgNWJ44Mj38dcVI+Dw6dBXnLlPoHh3Ju7bpdGpPD2taS/286H12BjFnVI5Hauz+YG4Oc
         3Dd/ccqN7CMjJl5wETVQLYuVy8vYYsPH63FfEMNcPeO8SCZ1ArhjVdmLRRLxpfHzcZr7
         OOHA==
X-Forwarded-Encrypted: i=1; AFNElJ9GZ5M3DybfhAKE+MtsdTri6edsVz9lnxA8v91DReef3qZ5+WmCBI2ZBgKxB7YYgMpHIwt+xJ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXuXVit1Y2aboh4kH0q5GcMsBvqRdFV5aiFsGQH1sCV7rVoZB8
	PT/pAp9DL+y4yeJCQDjya7J2/q4yomZZhI6EILVqI/qvRftVZ/vlDIC5+XACDKfw/zoCrfcL6r/
	AslGmaPGsV6o2Qd7MvXhsV3FwlP0HnoTGBkwtd3MK
X-Gm-Gg: Acq92OHWaBfymNIbopNIvltx11gxKjx4wdisyG2Gp1+PxrABS/Pp9ug5l0qBfQXFqsB
	60mhwhky+xhQ8e9ytRpoMTQAHGftRLHHzojqtgAdpvMx24uMA8oGgSnYI5xsquGbmIIhPjZGuhh
	fFWFyF5CjJ9mXzTFTHNRhIu/lNorCjpJZmrwpJYxUpfaGQEV+0e5hU232K0V+XZuVyuqQGeaZZs
	O9kK+Vqcw/bFKwAppLA5hfLQXQTL8FAzs+p/bw4X1iY6/tHtkiT2jr6LdCs3UOo0cyML9wiTL6l
	GxB/ntlf
X-Received: by 2002:a05:622a:4cc8:b0:516:9871:9a37 with SMTP id
 d75a77b69052e-519872e7661mr1495431cf.3.1781529208275; Mon, 15 Jun 2026
 06:13:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260614163336.3490925-7-tabba@google.com> <20260614164416.D37E61F000E9@smtp.kernel.org>
 <ai-DsLydd7ry0RpS@kernel.org>
In-Reply-To: <ai-DsLydd7ry0RpS@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 14:12:51 +0100
X-Gm-Features: AVVi8CcO8m7JqCdVLIloH1KAihfPBodYuoCe0_y-y0JfcVg7oXzuQgANsW62kFI
Message-ID: <CA+EHjTxn56a-NsNhYns6RSNkqTO+oujM9qnK4JaV0wJmchT43Q@mail.gmail.com>
Subject: Re: [PATCH 6/7] KVM: arm64: Set IL for nested SError injection
To: Oliver Upton <oupton@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jun 2026 at 05:46, Oliver Upton <oupton@kernel.org> wrote:
>
> On Sun, Jun 14, 2026 at 04:44:16PM +0000, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> >
> > Pre-existing issues:
> > - [High] The constructed SError syndrome (ESR) is silently dropped during nested EL2 exception injection because `ESR_EL2` is never updated.
> > - [High] When SCTLR2_EL1_EASE routes a Synchronous External abort to an SError, the ESR injected has the wrong EC (IABT/DABT instead of SERROR) and an incorrect ISS format.
> > --
> >
> > commit 09fd06d56ab3236a0e7af03e0d026ed6725ad6d6
> > Author: Fuad Tabba <tabba@google.com>
> >
> > KVM: arm64: Set IL for nested SError injection
> >
> > This patch modifies the emulated SError injection to unconditionally
> > set the IL (Instruction Length) bit in the generated ESR, as mandated
> > by the architecture.
> >
> > > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> > > index 4b39363cf8911..4262d4c17a877 100644
> > > --- a/arch/arm64/kvm/emulate-nested.c
> > > +++ b/arch/arm64/kvm/emulate-nested.c
> > > @@ -2938,6 +2938,6 @@ int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr)
> > >      * vSError injection. Manually populate EC for an emulated SError
> > >      * exception.
> > >      */
> > > -   esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
> > > +   esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
> > >     return kvm_inject_nested(vcpu, esr, except_type_serror);
> >
> > [Severity: High]
> > This isn't a bug introduced by this patch, but does the carefully constructed
> > esr value actually get written to the guest's ESR_EL2?
> >
> > Looking at kvm_inject_nested(), it passes the esr_el2 argument down:
> >
> > kvm_inject_nested(vcpu, esr_el2, type) {
> >     ...
> >     kvm_inject_el2_exception(vcpu, esr_el2, type);
> >     ...
> > }
> >
> > However, in kvm_inject_el2_exception():
> >
> > static void kvm_inject_el2_exception(...) {
> >     ...
> >     switch (type) {
> >     ...
> >     case except_type_serror:
> >         kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
> >         break;
> >     ...
> > }
> >
> > Since except_type_serror only pends the exception and doesn't explicitly
> > write the esr_el2 argument into ESR_EL2 (unlike except_type_sync), does the
> > nested hypervisor observe a stale or uninitialized syndrome when it takes
> > the SError?
>
> Oops, this definitely needs fixing :) OTOH...

https://lore.kernel.org/all/20260615131116.390977-1-tabba@google.com/

Done :)

/fuad


>
> > [Severity: High]
> > This is a pre-existing issue, but since this code deals with fixing SError
> > syndromes, what happens when SCTLR2_ELx.EASE is enabled and a Synchronous
> > External abort is routed to an SError?
> >
> > Looking at kvm_inject_nested_sea() in the same file:
> >
> > int kvm_inject_nested_sea(struct kvm_vcpu *vcpu) {
> >     ...
> >     u64 esr = FIELD_PREP(ESR_ELx_EC_MASK,
> >                          iabt ? ESR_ELx_EC_IABT_LOW : ESR_ELx_EC_DABT_LOW);
> >     ...
> >     if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
> >         return kvm_inject_nested(vcpu, esr, except_type_serror);
> >     ...
> > }
> >
> > Does this result in an SError being injected with a Data/Instruction Abort
> > EC? According to the ARM Architecture Reference Manual (D8.2.5), shouldn't
> > an SError always have its ESR_ELx.EC field set to 0b101111 (SError)?
> >
> > A similar pattern appears in inject_abt64() for EL1, where a DABT/IABT
> > syndrome is constructed and actively written to exception_esr_elx(vcpu)
> > even though an SError exception was pended. Would this incorrect EC format
> > confuse the guest's exception handlers?
>
> This is confidently wrong, down to citations of the Arm ARM.
>
> While I couldn't find an explicit rule to cite in my cursory search of
> the manual, the definition of the bit describes this as "External Abort
> to SError Vector". On top of that, AArch64.DataAbort() just changes the
> vector offset (but not the EC) based on EASE.
>
> My understanding is that the exception syndrome of an external abort is
> preserved despite taking the SError vector.
>
> Thanks,
> Oliver
