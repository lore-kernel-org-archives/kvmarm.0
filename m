Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6503D3CE4BA
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777647724; cv=pass; b=XQ43FQiqAGDC68tlrqP7Zl1aE0+4FbWQdJtVPwPoHqBTAByzN1lewCYAUChJIcNYxQRYCJLuDKrCLrLOLXe1NgsmwwOSyjR6wNIti5CTtGxmD6xPacaX1/WYBPi6eSRyHZzXO4THsExaqOvpeaXbRx51YkmkujQbqMPFeEDbcWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777647724; c=relaxed/simple;
	bh=yiYhJUMfNo18oK0obMw1l0Xm1WbS0b2LK8MKLVxr1fA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gc2Aj7e4Mf6ILlQJP1UVbJsgChVuq+DPQhxtxoYKJ6acmckDQyqre/Ht5t/AKBQbyC1joQEg0LK0VZfUXIKK8105j+MqfYDO00neRcXrRd7e1ENoIHtnEJUhDVWrmD4pnSHduvIwcA6wCkNWdKYCe2tkyAvGXsbl0rW9NwAhsEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CbHljRGn; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CbHljRGn"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50d836552daso559481cf.0
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 08:02:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777647720; cv=none;
        d=google.com; s=arc-20240605;
        b=VwR1fxYJlcBldmFfsAGHh66hgJI92MwQDVIDgkzvX4H7nLy1SAcdwSQMuMU3MczXLZ
         wWNLCOW81hHmJ6ICpz3693xzE7X9pMxi4ZosJfDAfB46ci2Xoef+eXxzcd8ymnmEytF6
         M6vUNvSwHrzrHaqSlWvEIhz1mmwuubmdKMX/UStHPz0JlnFAA48erBnI8o7N9n7/hMBk
         FKUS0MjEOzXAmdbZuENAtYZ/DC6yfoB8SVWLY4zP5gMCaIIo8c05ZEagbfbrx2MYWamt
         YO94E7ke1LxiY45K6WARMPhtqirthDNr4n/xLr7m+5s4lVaieqA0dPtb9quykro6Me2N
         9clw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zc/yqiuFI8zLs6WNwYRHDaX4KurA8TMA/7iu8L3wyVY=;
        fh=S9jiarpfuJ7wLCrZQihv5Bde0R494eMaZ3R4EIHti6g=;
        b=IcEh2qCMXp0GbmQl0nnBMXF/CYuBQKM9/8e5dKnRHivN6BhLYEZZadbqGfRL9t74WN
         UbAKhPtN+UKftEPTD9v3Y1L8oOQWEHY9Sjiam1JzzTA8r12tGp3uOUBtSTtoaFTRSAf9
         ATfzy+ygzgmYDosh8aEDGsJCBUuOjp3uplASxxgLQy3ZDgy2SFuX3y52eTaEHkaq6BeI
         leb4fqDXULbnqrZS2bW146TVMEtUGCOivmT1QDtwj+GxIo7EUFTpOLasC6BmutOkYxrL
         huZU/KLKS3wWM5Rl/5B7lA23yxU4RhO5dFEb0zXdAgbIUIKLgrtlt+4DvaQStgusHfMt
         JiiA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777647720; x=1778252520; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zc/yqiuFI8zLs6WNwYRHDaX4KurA8TMA/7iu8L3wyVY=;
        b=CbHljRGnOY/1BdAbIeGh7p38mcvg50OagARZw3OIS6E6djHi695Mq2pl1Gpni81rTX
         w+gS+O+CLlwLBYYvEtMerSQ3h9y6LmCYWkam5TNvIcYX9C98HmzK7FrIisaCmPIWeZhI
         nwuCRivj3pTeUOTwLMEwaDXkdt48utVcufihl/vjOeA3UGbZr3aL0sbCvHI1L5F4tJoz
         Noe0NFzLKHsMSzYDX6Td49huCvSOpqkuAQpEJSSUqjNNygA0oSsAx+oTvClZxzzeY1AM
         ZlR3T6SShwVFlEb8lkfu5ubHHO8G9mqGyaNbaRKzACuPM9c19+AoiQRs2ITbNBFI1Yci
         CW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777647720; x=1778252520;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zc/yqiuFI8zLs6WNwYRHDaX4KurA8TMA/7iu8L3wyVY=;
        b=NbuaHOTL58WCz8LddyHl/GC3qY1g2jhrySjLhBYsQ1/isSkb+daid5rgg/rKelAknN
         sIdqwmykwxGexkF64Om07ngUdDoUAc0/6vpeVTY9zZjfV/57kw+GlIQ988cTfGok2yAj
         aJ9ciVvEGcQts7zAgdbm4mw7A3SEWMqIzc5DoNFknWRQeWbqrSd56QwgAlKPNRMHwJyB
         /71z6o/w9iCOvP/QZf/oqpRWv5UBo91Kdh+e5Xr/7Qvd1bm1AO0MF88SoGgS324dMmos
         dX90PnPOkFIe0O6p4gG4UgwOkRbZr2W7XDoqYRBuBhg/DOb3GVSCUhjrRbWwh4B0Idux
         xxlg==
X-Forwarded-Encrypted: i=1; AFNElJ+QmVqH2iBei0+g9Piit/uLcFkxZieoEClIGbncwmflkWuTMRlnZmfmKAi16K+4q0PU5UN4FHg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaihrEFgwe2dAf40EGoKlRNs/JC1cC50OMOYL7sdq9G3hSlR89
	+xitc/fBwVrvOHuZG2MtDugtW6gGxSKwnruc8HgZbLflCWI2Y/TgyHif+V4FwjCfaHRFmSUDCn9
	p9Ko31Db4pYIeKQ+5L5HpCbXYJXQNh9heDbiUY2qv
X-Gm-Gg: AeBDiet627ONOVjuGmezAHb5hluNjQOrQ/YJLSJdOvLnnX0AldJf8Sse4bC3Thp68tN
	J3bDEYZgcF3SFR/mEjGTLuv6tFU12CmU3c2Uh/GBpsLRG8mdhMvDMHiH5PDDOFei2XOu4jIV0iy
	NP/FJNhi+NjvzO964Zk2Dn0YO2BpfIP8pwawmFOjY9f3B9uoHsEl36eQlCaBSgf45iywZP+HYVD
	Yxy0kphSl1wX2SVDPwIDWgDqKK5nslDMaWl0KTdVg0Mfu2XYZS/R51F7Ef79ySskdQgfdlcoeSt
	Y1DUV3F1DhlBfD70OUCD1ssbgpF2Nl1mcttNWJPtn8mcrJbVmHE+YuqbXZGW5w==
X-Received: by 2002:a05:622a:5e17:b0:510:fa1:73c5 with SMTP id
 d75a77b69052e-5103da47567mr15438331cf.16.1777647719224; Fri, 01 May 2026
 08:01:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260501112149.2824881-1-tabba@google.com> <20260501112149.2824881-2-tabba@google.com>
 <a7e2ac96-b710-40e5-a159-b49555bcf518@arm.com>
In-Reply-To: <a7e2ac96-b710-40e5-a159-b49555bcf518@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 1 May 2026 16:01:22 +0100
X-Gm-Features: AVHnY4INmeFm8QA4K3bkZ03la2-U8rDh6s5g7fQg4Z1xuyOvTM6dsAqgNAaZVmc
Message-ID: <CA+EHjTwgUF4AEw6WvxPiwMTtrTUEs1NjjuKso+VBChon2cdozQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: Make EL2 exception entry and exit
 context-synchronization events
To: Ben Horgan <ben.horgan@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	vdonnefort@google.com, catalin.marinas@arm.com, will@kernel.org, 
	yaoyuan@linux.alibaba.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ben,

On Fri, 1 May 2026 at 14:47, Ben Horgan <ben.horgan@arm.com> wrote:
>
> Hi Fuad,
>
> On 5/1/26 12:21, Fuad Tabba wrote:
> > SCTLR_EL2.EIS and SCTLR_EL2.EOS control whether exception entry and
> > exit at EL2 are Context Synchronisation Events (CSEs). Per ARM DDI
> > 0487 M.b D24.2.175 (p. D24-9754):
> >
> >   - !FEAT_ExS: the bit is RES1, so the entry/exit is unconditionally
> >     a CSE.
> >   - FEAT_ExS: the reset value is architecturally UNKNOWN; software
> >     must set the bit to make the entry/exit a CSE.
> >
> > INIT_SCTLR_EL2_MMU_ON in arch/arm64/include/asm/sysreg.h sets neither
> > bit. KVM/arm64 hot paths rely on ERET from EL2 being a CSE, and on
> > synchronous EL1->EL2 entry being a CSE, to elide explicit ISBs after
> > MSRs to context-switching system registers (HCR_EL2, ZCR_EL2,
> > ptrauth keys, etc.). On FEAT_ExS hardware those reliances are not
> > architecturally backed unless EOS=1 (and, for entry, EIS=1).
> >
> > Until commit 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg
> > infrastructure"), SCTLR_EL2_RES1 was a hand-rolled mask that
> > included BIT(11) (EOS) and BIT(22) (EIS), so INIT_SCTLR_EL2_MMU_ON
> > was setting both unconditionally. The conversion made
> > SCTLR_EL2_RES1 auto-generated; because the sysreg tooling only
> > models unconditionally-RES1 fields and EIS/EOS are RES1 only when
> > FEAT_ExS is absent, the auto-generated mask is UL(0). The seven
> > other bits dropped from the old mask (positions 4, 5, 16, 18, 23,
> > 28, 29) are unconditionally RES1 in the E2H=0 SCTLR_EL2 layout per
> > DDI 0487 M.b D24.2.175, so dropping them is harmless. EIS and EOS
> > are the only bits whose semantics changed for FEAT_ExS hardware
> > and where the kernel relies on the value being 1.
> >
> > Make the guarantee explicit: include SCTLR_ELx_EIS | SCTLR_ELx_EOS in
> > INIT_SCTLR_EL2_MMU_ON so that EL2 exception entry and exit are
> > unconditionally CSEs regardless of whether FEAT_ExS is implemented.
> > This matches the pairing in arch/arm64/kvm/config.c which treats EIS
> > and EOS together as RES1 under !FEAT_ExS.
>
> In v1 you also had this sentence:
>
> "INIT_SCTLR_EL2_MMU_OFF is left unchanged: that path is used during
> very early EL2 init and the EL2 MMU-off transition, neither of which
> relies on these bits in the same way."
>
> To me, it seems useful to keep that sentence as it makes it clear that INIT_SCTLR_EL2_MMU_OFF is purposely not changed.
> Or is there a reason why you dropped it? Perhaps it's just obvious to people more familiar with this code.

To be honest, I thought the commit message was quite long, and I
wanted to make it a bit more concise. I could re-introduce it if you
think it's helpful.

Cheers,
/fuad

> Thanks,
>
> Ben
>
> >
> > Fixes: 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg infrastructure")
> > Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> > Assisted-by: Gemini:gemini-3.1-pro review-prompts
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 736561480f36..7aa08d59d494 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -844,7 +844,7 @@
> >  #define INIT_SCTLR_EL2_MMU_ON                                                \
> >       (SCTLR_ELx_M  | SCTLR_ELx_C | SCTLR_ELx_SA | SCTLR_ELx_I |      \
> >        SCTLR_ELx_IESB | SCTLR_ELx_WXN | ENDIAN_SET_EL2 |              \
> > -      SCTLR_ELx_ITFSB | SCTLR_EL2_RES1)
> > +      SCTLR_ELx_ITFSB | SCTLR_ELx_EIS | SCTLR_ELx_EOS | SCTLR_EL2_RES1)
> >
> >  #define INIT_SCTLR_EL2_MMU_OFF \
> >       (SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
>
