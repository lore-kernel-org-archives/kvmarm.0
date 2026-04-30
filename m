Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528201BD9CE
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 00:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777509799; cv=pass; b=mDwkEYqPhX8psLSp0YfkxiBZAj7MsY2lVxU0ChqmpyTrxnWpMwZGsYZU+3zwnwcQt6I9JhgET84H06/ivpr5qBUzjfuDXFccGIxk/2fBhU5yMmVOqIhkfqzvb/+WJq/au7gyAj/WgKGuAVb9rZHfPqTv5L9rQnWohHgsK5u92Ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777509799; c=relaxed/simple;
	bh=ZdaMDMnsE2bNTMd0UOmXsnLLXqtDt1Cqm9/WufJEwTo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ALe2nnomm5xox0uhcuoUoMLiC4kedPE0nFsD+8H7qb1ZMarGnIKrzBjTKTkjpRJ5To/A0q/5YQnZENYz8tPFyEO4+QE0K8KRu7fDwqwntMIqOUIYeBFGoxZ6Xb04x2KNXPEd3OpxIPGLPr+LHQ7zEibDO5vaFdoxjBhcz2Ca1GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=S+qXINIE; arc=pass smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="S+qXINIE"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36146ae9dd4so246832a91.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 17:43:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777509798; cv=none;
        d=google.com; s=arc-20240605;
        b=gTGuYarTAj0nIBjToGIuLvO7q0PsLZC5WVBPeBhTn+pqBxdwuMnyG3YJn+4PMTWaZ5
         9eabRtaBHl8a0HKp6fX/W9BP2Pzk1Fvj47xQyjvMdGn2dhJDecGqZQb34BZnRaAH2m2M
         sj1GBrPn20IQaMBIRFOXBbAiy4zQWmgMAAFEaYXI8GV29jwCPZMCZJvRPbf0bTsFK/Wf
         NJv0mUP0MadESMtbBC4qvXK20P7etPT3dwnGtKNVj8tDNZNOkNG+Wia/eHA7R/dQURXC
         qYU/VxqgaWBPOyMPvNPnFK6o0x8F9ap5yHT1w54Y6ZS+b8ck4I8si0MI8A/ViATuSkZ2
         rtTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+22Vew3O7NYuCAbB+MpAlEjTY5hterfUj3xJsaAyHE8=;
        fh=qAw1veLVyOsWTGzalTu8TPx2O8xRTKMwzS/KirxlySc=;
        b=BWD1c6UE3nLdd4Q7jaAImTAmSpY5vGkzUACP7eQTeKXixR5OmG7TBHQNicKhYi/8m0
         IJFj+Jy9JjM9nf81GTneWTy577r/79E3Vtq+znEQy/8wkl/z8uq4WPranhvcFJ0mfg7E
         SJ+Xolzlffud4nMR0a5DqbhISc7gNAa72uAGFvmFLLTL3F/y3kKlIeoerGUuWrXLUEyl
         dwg4hIrDWACVzt5WK5ioqXKm2+Q/N7IPueQIntuy3mg0fIm71JR5JdLr+k+D/7DKOp7Y
         wuYRwHnobbe1htiQqOIIWhSLf+s/ESpViTPg8oxK0yjjtWmVtueAAy9XjJudn6ZYMin+
         ntKQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1777509798; x=1778114598; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+22Vew3O7NYuCAbB+MpAlEjTY5hterfUj3xJsaAyHE8=;
        b=S+qXINIEqtAZMsSxneyyVvR7ZzCcdvWePe1M125127Gm2Uv2VdW5Snwa17u7yryrlB
         4RQ7eXauZFFbsFgnmMPWB8CqUPXZklI27hftrBouSv5pzb/0VQ6Arz9Jez5YHauQBoPo
         vX+ie0NbfTB8z75umHYYHK4/vHKmRS2SRuYbmqsy4tH8RdJacgJrzxtfPZOj201cyBSO
         bnq7fvuI7JPA+KtAuxCqnCXX4G/dFyr55wKoQb3+UO+jZOcTR/JLokskYuv9y2kpw6Ky
         EiP8ITPRzwtgdakxlWa+Oi4kDiG1Im2XTuKbEp2/AYXeghCehg6YnMjxj6JxVaTH6z/d
         OhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777509798; x=1778114598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+22Vew3O7NYuCAbB+MpAlEjTY5hterfUj3xJsaAyHE8=;
        b=orzcbonKzkq6gFRrERyGQ4G1UiSD0xIvAZNZ108Nj79Bjyj8UNyVRzrbgs+QxzwrEB
         FTX5BiPY5KEsfJdZbbQPhz+GJfK8h0u3ptIM+8qAwjG59DxZ87FwoKih19+InZgq10mx
         SGvVRVyTQvRr3DOAyS0Ln9VPLiWl4U7tDwOPm5ZS3oflcRtTnkg0ivtwjsSpQcXEnwx6
         WnG4kUUZmI+pH49kfdIs2FKVsygF4sJkA94dprdVw+Irq0vYmviuK9g2siCblsnC2B+2
         Kd96at63DYbZwi9uXZvHNe51jNMze2gBznE021ijjFbrdQkiUAzjGRd698RGaw4OX3Sc
         2xJA==
X-Forwarded-Encrypted: i=1; AFNElJ87KBdWwIkqZEPp6RkpdGcA6lmR4cn7GzrzYT2vO2Zin9dElW9DhIexCl9o4G7EEcKyJioi2e0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDQFdzIY+ztBw4Rs8UVMvygKAozpDJejSQKtu11S1bg7QknAZ4
	7EnJVl00eNYqK6oV6k8ochFc+61Fl1nFxEO+nCjMnjlYt3M2TirKJqbvseNS4GVtRo0847t7Uix
	4UVCVtrrKik1AzHPSLnnXlLtLLtiZCsWKfqrbhe98
X-Gm-Gg: AeBDietJkbEcFF/l2MgGzPLLxcRVXUThW5Ojh8FCyAW5p1irniq5lSP8j6wlqJJij5n
	VY4Z3xVLHFZNgaeceXbRm29t1xpNCslxh8RedX1DChYIInp1lLV4rvzs953HYpcBBpdIzdCZrNZ
	nN3Z26pht3tF9ZUqwjcth1R7tCJIB4CQ6fIrIKKRzrzPcEGyCMDGtR/4d0mlKWSCvdrJ36tebp/
	w9waEbj3RfKT4XJkYizaEl3i7tO16olIRUwYALVUxfZkkk4MDmXAulwKciQd07eVhGwenf+k4hh
	AGye35QzesNsWR/9/Q==
X-Received: by 2002:a17:90b:3b8c:b0:35f:b5df:450 with SMTP id
 98e67ed59e1d1-364c309b046mr561429a91.19.1777509797729; Wed, 29 Apr 2026
 17:43:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aeoAlVEwzRUPrlVe@e129823.arm.com> <aeoRxWPyOHGJd+Jh@e129823.arm.com>
 <aeoWO2Cwo04YYu2l@earth.li> <bd908e28298d968740d03c97bc7e441de188b7b4.camel@linux.ibm.com>
 <aeokwrC86WI7uT+K@e129823.arm.com> <aeomlp3I0eVE5mce@earth.li>
 <aeotq8nPVu4wvEx5@e129823.arm.com> <e4e242ae5533d5762a3647186a178764881bf9ff.camel@linux.ibm.com>
 <aephL3MzYoqFGaT5@e129823.arm.com> <CAHC9VhRQWHEWQ5NzOPiu8jtYv6UsRm8WVS4fd74AbkOcAd4y_g@mail.gmail.com>
 <aesGU8a3mbVzvteH@e129823.arm.com> <CAHC9VhSaT_quKYnpFjAfqvL07JNbWMgM6c4pB9F46NHawX3DCA@mail.gmail.com>
 <014cf39aa8d6a0bcfa1a95c069675977ac67b843.camel@linux.ibm.com>
 <CAHC9VhTW3=RJ8L91RWXYYA9tFjfSXGN-DMEEwdiD6big9H57Ew@mail.gmail.com>
 <1f78fc75b2e95239973612a4b6c4cc782960b7ac.camel@linux.ibm.com>
 <CAHC9VhS4JmPmCJrYTdbjxb3TO-uK6cB3Zij-ef=wswGce2BGzg@mail.gmail.com>
 <1e51c2fd090e5ceb07b1d09e50650c70fd3ccdb1.camel@linux.ibm.com>
 <CAHC9VhS_WgwhW_NDO91LoTeSzdieGqbwqnwPq8KpavH1_Lwi7g@mail.gmail.com> <e325b7a8041b7122e8415de9193f4fe1be04bb02.camel@huaweicloud.com>
In-Reply-To: <e325b7a8041b7122e8415de9193f4fe1be04bb02.camel@huaweicloud.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 29 Apr 2026 20:43:05 -0400
X-Gm-Features: AVHnY4LHifXVy7YvtGHgR9F7kahKzv5vW_Z8KfHyWJ-dvateuzzdMLdc0MOzfBY
Message-ID: <CAHC9VhTqYgc6fE2v+ZY4QXuCDkvNMKZcM4Wi+7Vkxspff08K0A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] security: ima: call ima_init() again at
 late_initcall_sync for defered TPM
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Yeoreum Yun <yeoreum.yun@arm.com>, roberto.sassu@huawei.com, 
	Jonathan McDowell <noodles@earth.li>, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	jmorris@namei.org, serge@hallyn.com, dmitry.kasatkin@gmail.com, 
	eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca, 
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com, 
	sebastianene@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 9:33=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
> On Mon, 2026-04-27 at 21:31 -0400, Paul Moore wrote:
> > On Fri, Apr 24, 2026 at 6:49=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com=
> wrote:
> > > On Fri, 2026-04-24 at 18:10 -0400, Paul Moore wrote:
> > > > (I'm assuming you meant initcall and not syscall above, but if you'=
re
> > > > talking about something else, please let me know.)
> > > >
> > > > Saying that you aren't comfortable moving IMA initialization to
> > > > late-sync is inconsistent with allowing IMA initialization to be
> > > > deferred to late-sync.  Either it is okay to initialize IMA in
> > > > late-sync or it isn't.  You must pick one.
> > >
> > > Yes, we're discussing late_initcall and late_initcall_sync.
> > >
> > > I prefer to look at it as being pragmatic. I'd rather err on the side=
 of caution
> > > and not move the syscall to late_initcall_sync, than move it.
> >
> > If you were truly erring on the side of caution you wouldn't allow
> > late-sync initialization without knowing if it was safe or not.
> > Determine whether IMA initialization is safe at late-sync.  If it is
> > safe, move the init to late-sync; if not, keep it at late and figure
> > out another mechanism to sync with the TPM availability.  If needed,
> > you could probably use the LSM notifier to enable the TPM driver to
> > signal when it is up and running.
>
> Yes, I agree with you, or transition or not.
>
> However, all of this looks very fragile and easy to be broken. If we
> want to be on the safe side, we can use any notification mechanism that
> is suitable, but at the same time from IMA side we need to deny any
> file access that would require a measurement until the TPM comes up.
>
> If you accept this, I don't have any problem to move to late_sync.

To be perfectly honest, I don't care what the solution to the IMA/TPM
dependency issue looks like as long as it doesn't involve simply
trying to initialize IMA multiple times hoping that at one of those
times all of the dependencies have been satisfied and it isn't too
late.

If the notifier helps you solve this, great.  If the notifier isn't
helpful, that's fine too.

If you need to decompose IMA initialization into a multi-step process
spread across multiple initcall levels, that's okay; we do that with
other LSMs.  However, calling into the same init code across multiple
initcall levels is not okay; you need to figure out what is needed
when, and establish some synchronization mechanisms to provide some
assurance that the system will boot up correctly.

--=20
paul-moore.com
