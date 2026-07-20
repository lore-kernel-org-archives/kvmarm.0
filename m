Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A679392838
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 20:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784580079; cv=pass; b=jaIro4R0/uwusvOQwctToK0Vzjiz1HMlpyXTNrocoG5Lc5btkuJ4c9/AHQ+X7Gi7BGcQZsNE79x/RoGV5fcdONTsv42J19f6ohUw49preDo5js8tzcUMl5qyFg7wn1mqTUn9Pm8/+7rVU6D3rDl4Fsq51q2EcwKlsJmtD8McyqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784580079; c=relaxed/simple;
	bh=5JjcKgrUFTdMwjnI+56C3PYivcYyZwMQCWWxdK1ZTZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pPvVHwCNoKCjZrrtNcgixJntRYVVXzmyRY5ShB1vkCCfE7hK6Hh4Ss1vSDNumxZ4f1Lp921zWiAJtAKpdyOKLDjAj0REefoG0DP8IKL4+7lTKXxsj3z8hq0n7Buv7qIYacwG/P42AaSFOio03m51k/WRC297O14t6nhpW1k/Pjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aDOWvgyf; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aDOWvgyf"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10e86e52so968051cf.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784580077; cv=none;
        d=google.com; s=arc-20260327;
        b=MOagueMKYcD82LTb8sVJPyPtlewGVaYC6EO56YhEK+mY08Xb6N4GLVKn5wyIcd5AZa
         0FmQ/LBFMmhhFfFD4KVtTrX0eYJRB2fZvVWWqyNt5XPooyyvxZGLdWIH+OW2CnpUwnMH
         nkBma8UAryeYoimisr4nNLlLsNFracrWNfSM8PKWSSAvtIr8I0iAj3MJmXDp2C3GLHem
         ZkKw1u/ojEsKXtYsdsZu4lPcddxr/swpD5SFagKMXs4xkL/s2jRtXauv5VyICtfqjk0P
         DwPYO8fLcG19ZdfDdn3iFIF7XDv61uNKK0pXFri51qnmRcZR6pSJqNAzePo/k36KiW6t
         3JIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6FyDVlIhYJarF3j5mg5Rdrj8kYPlrN1IEeGCY8y4YAw=;
        fh=8p5+Hepzl36pLF1K+Jt/TV82F+1PwNraIIfCY8cBm0Y=;
        b=MEf/rBbXO6dHGnt0FC32d1ua24Dk0/ERvQ/TfO8uNPYenU8evfEXdCKrxG0Ix0CLzx
         VN5mCmF46VlqJNaCU4vaEwTACy3X6ZLwZe82hhu0T2+gdywiUXes/PGHyvErP2pDNYtm
         cJ/7loSSUf3arQNPhi0Y12P0Rh7TMBYNH+duduGlGAaNeeU1tdXg1leqovVBaqGHDV2g
         zelNxx+4Z06yQDP2D++l4A6RSw5DEiUrCYPn5NgUNEXk/x1TJtN4wJxX46bF1qtyzD8W
         Op4sBBDc/p4rSXiKpdiOdS1kF4+yMAu8GyYQP3fAiloHpEU8b7alLx3NEP5s12/WJwrI
         fYDg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784580077; x=1785184877; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6FyDVlIhYJarF3j5mg5Rdrj8kYPlrN1IEeGCY8y4YAw=;
        b=aDOWvgyfEGPm+oXaCMkOJ5q3WcgoH6Gc0w5aD+ZCRLGmB4XOfWN5nx0I2QUGtt7p7v
         +SDB+riPnA2hSUsuGiX712NNpCPRh6U+KgJ7vwZakyejOUrdtWyRLLL+hugBZaS3Qjr9
         5QFlJqMAbccFMPxof2rzn8oUiYN37B3EyCG/sm/dhDM69sKUWysmACc6WR4pE+/WtQ/R
         DnYpt+9P0OwhrpwUiuRBCC3MfDd7bwUcAfyi8I8naeih3Bz539iNJQovJ8xT+YaHmO9w
         Ia6+jiwsZqNdJhPiOYpO0to2qcFpkUwTQwnkZ8uB3kKqxrbi3jGT3xL0BrTQR/jF8jQN
         m1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784580077; x=1785184877;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6FyDVlIhYJarF3j5mg5Rdrj8kYPlrN1IEeGCY8y4YAw=;
        b=lrZoHRhROe16yqpZvQ7Ks5JreINPQCVpChhS80OOQ/VSvYaq2ahA2UvBtNmPqoH/j1
         oVXu7DOVY7lRq/VioaOCBlgY+Jv0SC03QwrzWiM9tqdMAwXvqgA0lv+kiOgE+Br9wn3h
         jlGwdFnmvs76l72K6rvBAIOmgh2Ljt147bAOnZzkV6b4Edx4CrMAf9fwVvglQHwwA9rw
         Vc+sc0SusOz7l1/CFLwrdOWaStV9y1VJc22jzESkt31c+DFYjWRPDcfCbQ/kKOP3Z6dA
         hlD+rzSrOOiqH33HElpLskRodJpqavSnLw/5XRW1gXFUDMGVuhgguTa/U1EFeLruzLTT
         qtog==
X-Forwarded-Encrypted: i=1; AHgh+Rr9yzhsCqepK7EMzpgEc/IuB6nOIJNTDHI0JTFLXf2YTT/l08Jtkuk98+PLlIWwrq1ItWct0a8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2mB7jJ4PKVvzWv+YH6QSByFwqC3aKXdB6kuUEumOFjKMAR4Ds
	hyLW8L7nIeVx51uzKrbdme12DoHbQXs3/2hCUtVt3xjbtq2RyGxCFhaMe2zokeV7K0y+VjvlqhZ
	DKGcosX5884qlk9uDEXIlSLYRU2LzWaG0yuHF///h
X-Gm-Gg: AfdE7cmEN/C3X7LcYKZ89ImbLw9vh+q+nsPsM3LOUH8C8UcpColHXnMWsLWq8lPAWiN
	uQRqV+eombIPaSGDeDKi1ENLP4iSJ29Bbb+ukq6gfq+PeTLUOh6uLK//C2WaUyM3zywUPLl3C44
	PB8reEjXZ7sxndxFoODPUuFcWN/6cxqsH8kQ7wayQp5lZfBejyJx+1cOpLyW7GRgy1SK5d/9cCe
	Th291KC6spj40f50zGUHR8PKvfNs70OTi2AKJJi3ZDsz3dUIqXF1i3yZ/S+NGRs/cil0il+XjbH
	v4Jtui6/CoJ/BnwckhY=
X-Received: by 2002:a05:622a:1818:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-52600a8412amr5684341cf.11.1784580076851; Mon, 20 Jul 2026
 13:41:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260717130901.2239134-1-smostafa@google.com> <20260717130901.2239134-3-smostafa@google.com>
 <alqW49CH7eViDpAZ@kernel.org> <alvaEgJFJ5DaQaac@google.com>
In-Reply-To: <alvaEgJFJ5DaQaac@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 20 Jul 2026 21:41:04 +0100
X-Gm-Features: AUfX_mwckn6GNC52bvXL7m2f_aD7LRnSayY1o19sXQxbCMxb4tBgy3W_t4EMWJY
Message-ID: <CAFgf54r0xYwUGgPMY=1aTRzcqX7jKp545Jb+p_yFW=JwAX0E4g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3
To: Oliver Upton <oupton@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 18, 2026 at 8:55=E2=80=AFPM Mostafa Saleh <smostafa@google.com>=
 wrote:
>
> Hi Oliver,
>
> On Fri, Jul 17, 2026 at 01:56:03PM -0700, Oliver Upton wrote:
> > Hi Mostafa,
> >
> > On Fri, Jul 17, 2026 at 01:09:00PM +0000, Mostafa Saleh wrote:
> > > If the system supports hardware Break-Before-Make (BBM) level 3, use =
it
> > > to replace stage-2 PTEs directly instead of falling back to the softw=
are
> > > break-before-make sequence.
> > >
> > > 1) Get a reference count on the containing table for the new PTE.
> > > 2) Atomically update the PTE with the new valid descriptor.
> > > 3) Invalidate the TLB for the old PTE.
> > > 4) Drop the reference count holding the old PTE.
> > >
> > > One interesting case, as BBML3 will update the PTE atomically, it
> > > can only know it raced with another core at the point of the cmpxchg
> > > failing, unlike the SW implementation which locks the PTE first.
> > > And as we must issue CMOs to the new mapped page before the update,
> > > that means with BBML3 racing cores will issue redundant CMOs,
> >
> > I'd rather we just predicate BBML3-style transformations on an
> > implementation having FEAT_S2FWB and DIC. You can definitely come along
> > later and enable it when using a stage-2 in an SMMU makes this
> > mandatory, possibly at the expense of some extra CMOs.
>
> Makes sense, I will do that in v2.
>

Looking into this, I see some existing inefficiencies (or maybe I do
not understand it well)
- pKVM still do some work for dcache with FWB I posted a patch for that:
https://lore.kernel.org/all/20260720203529.1276355-1-smostafa@google.com/

- KVM does not elide the icache maintainence with DIC, it seems we
should have something similar for the FWB check in
__clean_dcache_guest_page() as

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_=
mmu.h
index 6eae7e7e2a68..d0a4ae66b069 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -247,6 +247,9 @@ static inline size_t __invalidate_icache_max_range(void=
)

 static inline void __invalidate_icache_guest_page(void *va, size_t size)
 {
+       if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+               return;
+
        /*
         * Blow the whole I-cache if it is aliasing (i.e. VIPT) or the
         * invalidation range exceeds our arbitrary limit on invadations by

or I am missing something?

Thanks,
Mostafa
