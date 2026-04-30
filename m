Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6C71C84A2
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 12:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777551568; cv=pass; b=kg+OGBLqqrfyXvHoKFApNHL5v6iJjp/7oic8f/GLbs3y/AF0SMe1sfJK5OWTAfPzPB+tdgvTig/C8wE0KtUwXDjhcKHaMhglMY209Ilb1qUFUyDmGtMl6apOddlIFBaIB6blX8ZzUhacxCS7VvsDmM0+OTWI9vqvZaVsx5WZ2PY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777551568; c=relaxed/simple;
	bh=44cjooSElohMQFoXrm+AMIOG2x7f7KQkgD2E8+cShXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Imfl8oR01rQGGFjZC7ueAXz4/0xlb/lzpy8FPOu7lx+EG75LauaJjREtIUSji8Nu7kwrrmEtBIrUxKocupfpanN+QJWIzci+uIkXMn/EjYrrGnjVzNaE5UjZELklDM0HE279ny2CLj49skjQZDYjjmsOQ5i7Ke/GvfPJSGOcU6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IQ/8andZ; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IQ/8andZ"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50d836552daso534111cf.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 05:19:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777551566; cv=none;
        d=google.com; s=arc-20240605;
        b=GuW5TUz85Aor3e+mHv0SA8lxnJ9YmP2NtvydRR9DIsLHQvfyoiGtnfddcD8qcEHLXQ
         iHvnzojgdG/hEzTwYO3PQGyWHavWaf5xPd6NPOOVYN3/9wP5SLsGME3Epvnk3dRVGIQn
         fbJFFgqiL6/ABqFZbASUFmiUvTq7Ez8XiuRko6uzWS6bgEb52q+KMn4BqiBGfngpLFTs
         AcLYpZg8wvhA60TvobRwZus4hkUTZeezv2bYOTN92/gbY3J/vOCf6AhqBQeXTKws5Slb
         lNjwSkoB3std3Wrvsrsjmq9uz9GHnJ3g4YmLc9gbeEHgvLuQfJCNO9AS5WsmPmyidgBE
         6TNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wHRKEeAne5F8MKTBpMczt1Dq5nvrp7CkygWD8nWgp48=;
        fh=6QHfQ0lUM9KtGWsa4Zo+Ms43bXwW9BWcHoHR3OGJOTU=;
        b=iSdaQ+DJFxoHFgorTYkNrGP4ADW9EE//gveJ6bGCupqJmc8nSle/ZFq80Hj4jiHnZs
         GeWGokFgS+Qy/l+XhtStaZTg5LBjUv/DQK9LpKp2hziM59ZbKLOOaflnq5eB9xzQWd7v
         +D1G+fw37X4WVKCR1WrUkdyYGi/WyWkJbhjipuYj7a1L6+fGRTTXZLkpZdxVia2Widj2
         79vJX4oQqp4iA0B8f+mrMX5Bu5UHA+xq1lMXxdztK8rzToMJgYHBevkoisy0ZYOm7pH6
         yRtev6qwTVZQsD/rrdsSQUwUnkS+w7uQEcRgmY7hREyzYAIVzkvVcX20lXTIKGw4Xt+B
         0V8A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777551566; x=1778156366; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHRKEeAne5F8MKTBpMczt1Dq5nvrp7CkygWD8nWgp48=;
        b=IQ/8andZJlq1bG91sA/E2fOqhQQ+Lc2qn7YZavt8ZcfIE/QXiRtxqRcsl6KfrnKAoH
         TqqCEJYc6S/RVuQgodCMUvWbpqhakYl/FgBJ00jtYGXMb3bDqNVzPMQlwPnlcmNSJkyi
         WCb3UcwgfuOYFaJuSuCYenvZQkJoyI+amjJzGluqxFs0eeaaDekZrS7FfgO/DaUkAIjH
         KQmF/ytiQM4gNvr59ezlZiXv4/Xpw8cA3riap0BpVLQ+ELoFnFGQsAYduxoq1R67wgwi
         enS4VSG/WdKrbaYcb/EAnG4NTDs3U6Zx8mHTG/dfn6YS9EwaZeffXdUpnK4QAXeqJQ8k
         c1Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777551566; x=1778156366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wHRKEeAne5F8MKTBpMczt1Dq5nvrp7CkygWD8nWgp48=;
        b=jfaclwxxGymwDsFUWuoFYXmzG+2EfAa6ku1D+IPSCsOYzAbRbQClKU0ilGARndIQEe
         0YL4Fnr7fw3QeVcmznD9kXbu73uPd9ljPE8TthVD00WKTR0GAHrYOLOZZHNtfmODzGeH
         FJ9MqExLYCh3EJbOi+wROjnuQhekaqqARNjsO0Btctq8EuoHDH3GIeVF9XgVQDQzhMaV
         XpG6WcmrysDt14BwcuqSTIENWqMq8xbgEih7wBby3D3xXo0xYxnhlAYOb9olCraUSRm8
         F+qmnj7wba6c9aO1FC6j42smkD1BB/RJYUvQTmp6/TMdEYgYz4ebLnZfpKQYVCrohstO
         RjTA==
X-Forwarded-Encrypted: i=1; AFNElJ+x+ZTGVELoIezn+N9YEd37Fuv0ZnTaqkVfVwrKLAyazlhWEHsPpLYAYsVdoTa+SATM0eZjD8s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9cHpBrEzs+sthOVU13EdQwx5FjLfjthrwXT4w8oblCxGaw2Hn
	Zc1V+ESL1dXKgMMJqzUP2W3c5XhNbx7TVF5DGYItGZLAMjIbG+bSxNZTF4MfViImP2mFcuc+Pxs
	LqY5iADuQ83cVm5x4t7obQUBqP43RiDr+d48ZvCAy
X-Gm-Gg: AeBDievu21HjmsWWL/Lq/hnhWw1mB/R3+RByS9HHlFl2nZm1/gF224QWmdodICRODk7
	tAfjAF5Bpf9d0AQ97/wa5HAeCuckWkm8u0Vq/39jQkgnAd9e3NI97DsPfM/Smd9YQlM0Serw25P
	vxZGAVjRajshWvv22nWu8emugfH/neP5uQVKcz6KXguvylcq/cnELbi37i8ePSS7WXU+JU1ovCN
	0e1PvXHywq4A1riDfb44uRkagVyDsUixZ+w97NOHr0gLVkvqGLZ/ygeSYaNE87fO7VKHURwXwYD
	y5h/hGcCSpbT+CLoQrqWfrJ8fYsRo9wd/fGhop98QXokE7/f7r10/9KCzfk=
X-Received: by 2002:a05:622a:a6da:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-5102830838amr13557601cf.8.1777551565713; Thu, 30 Apr 2026
 05:19:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com> <20260428103008.696141-2-tabba@google.com>
 <afMb7uuPlUbLeu7k@willie-the-truck>
In-Reply-To: <afMb7uuPlUbLeu7k@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 30 Apr 2026 13:18:48 +0100
X-Gm-Features: AVHnY4KrIAjURaGJR0bOqEe6FW-ppWuYCbxV1LsE0PqXIXBObjOjW2F6E4sgXIQ
Message-ID: <CA+EHjTw6rx5rCVnR7Dfva3xmmgGjqUeUaT=3zDCEsN0J909Wsg@mail.gmail.com>
Subject: Re: [PATCH 1/8] KVM: arm64: Make EL2 exception entry and exit
 context-synchronization events
To: Will Deacon <will@kernel.org>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	vdonnefort@google.com, catalin.marinas@arm.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,


On Thu, 30 Apr 2026 at 10:08, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Apr 28, 2026 at 11:30:01AM +0100, Fuad Tabba wrote:
> > SCTLR_EL2.EIS and SCTLR_EL2.EOS control whether exception entry and
> > exit at EL2 are Context Synchronisation Events (CSEs). Per ARM DDI
> > 0487 M.b, EIS is governed by D1.4.2 rule RBBSRF (p. D1-7205) and EOS
> > by D1.4.4.1 rule RBWCFK (p. D1-7209). D24.2.175 (p. D24-9754):
> >
> >   - !FEAT_ExS: the bit is RES1, so the entry/exit is unconditionally
> >     a CSE.
> >   - FEAT_ExS: the reset value is architecturally UNKNOWN; software
> >     must set the bit to make the entry/exit a CSE.
> >
> > INIT_SCTLR_EL2_MMU_ON in arch/arm64/include/asm/sysreg.h sets neither
> > bit. KVM/arm64 hot paths rely on ERET from EL2 being a CSE, and on
> > synchronous EL1->EL2 entry being a CSE, to elide explicit ISBs after
> > MSRs to context-switching system registers (HCR_EL2, HFGxTR_EL2,
> > HCRX_EL2, ZCR_EL2, CPACR_EL1, CPTR_EL2, SCTLR_EL1, ptrauth keys,
> > etc.); examples include the activate-traps path,
> > ptrauth_switch_to_guest, and the FPSIMD trap re-enable in
> > kvm_hyp_handle_fpsimd. On FEAT_ExS hardware those reliances are not
> > architecturally backed unless EOS=3D1 (and, for entry, EIS=3D1), and
> > whether they hold today depends on firmware initialisation outside
> > the kernel's control.
> >
> > Make the guarantee explicit: include SCTLR_ELx_EIS | SCTLR_ELx_EOS in
> > INIT_SCTLR_EL2_MMU_ON so that EL2 exception entry and exit are
> > unconditionally CSEs regardless of whether FEAT_ExS is implemented.
> > This matches the pairing in arch/arm64/kvm/config.c which treats EIS
> > and EOS together as RES1 under !FEAT_ExS.
> >
> > INIT_SCTLR_EL2_MMU_OFF is left unchanged: that path is used during
> > very early EL2 init and the EL2 MMU-off transition, neither of which
> > relies on these bits in the same way.
> >
> > Fixes: fe2c8d19189e ("KVM: arm64: Turn SCTLR_ELx_FLAGS into INIT_SCTLR_=
EL2_MMU_ON")
>
> I don't think this Fixes: tag is accurate:
>
> 1. That commit doesn't do anything with EIS/EOS afaict.
> 2. Back in 5.12 (when that thing landed), SCTLR_EL2_RES1 did actually
>    include EIS and EOS
>
> so I think the issue here might be that the auto-generated sysreg file
> quietly changes the RES1 definitions as bits get allocated, but the
> macros using the RES1 definition don't get updated. That's a pretty
> horrible pit that it feels like we might keep falling into :/
>
> Looking at 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg
> infrastructure"), I think we ended up dropping a whole bunch of fields
> from the RES1 mask (which became 0!). Have you checked all of those?

You're right, fe2c8d19189e didn't touch EIS/EOS: the SCTLR_EL2_RES1
mask it pulled into INIT_SCTLR_EL2_MMU_ON already contained
BIT(11)/BIT(22). Looking at it, I _think_ it's this one:

  0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg infrastructure")

After that commit SCTLR_EL2_RES1 is auto-generated. Because the
sysreg tooling can only model unconditional RES1, and EIS/EOS are
RES1 only when !FEAT_ExS, the generated mask is UL(0). I'll fix the
Fixes: tag in v2.

On the wider question of the other bits dropped from the old mask,
I went through them against DDI 0487 M.b =C2=A7D24.2.175. The summary
(SCTLR_EL2 with E2H=3D0):

  bit  field    E2H=3D0 status                  kernel cares?
  -------------------------------------------------------------
   4   SA0      RES1 unconditionally          no
   5   CP15BEN  RES1 unconditionally          no
  11   EOS      RES1 iff !FEAT_ExS, else RW   yes (this fix)
  16   nTWI     RES1 unconditionally          no
  18   nTWE     RES1 unconditionally          no
  22   EIS      RES1 iff !FEAT_ExS, else RW   yes (this fix)
  23   SPAN     RES1 unconditionally          no
  28   nTLSMD   RES1 unconditionally          no
  29   LSMAOE   RES1 unconditionally          no

The seven non-EIS/EOS bits all fall under the "Otherwise: Reserved,
RES1" clause for the E2H=3D0 layout, with no feature guard. Writing 0
to them is a no-op, so dropping them from the mask should be harmless
I think. EIS and EOS are the only positions where the bit
becomes RW (with UNKNOWN reset) on FEAT_ExS hardware and the
kernel actively relies on the value being 1, which is what this
patch addresses.

I agree the auto-generator silently zeroing previously hand-rolled
RES1 masks is a real problem. Happy to look at either teaching the
sysreg infrastructure to express conditional RES1 (so config.c's
AS_RES1/FEAT_X facts can flow back into the header masks), or at
least adding a build-time check that flags any auto-generated
<REG>_RES1 that shrinks. After this series, though. Let me know if
you'd like me to take a stab.

What plan to changechange in v2:

1. Fixes: 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg infrastructure"=
).
2. Add one paragraph in the commit message explaining that the bug
landed when SCTLR_EL2_RES1 was auto-generated to UL(0), with a
one-line justification that the other seven dropped bits are
unconditionally RES1 at E2H=3D0 and so harmless.
3. Code diff unchanged (still just adding SCTLR_ELx_EIS |
SCTLR_ELx_EOS to INIT_SCTLR_EL2_MMU_ON).

What do you think?

Cheers,
/fuad

> Will
