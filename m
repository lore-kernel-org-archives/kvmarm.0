Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B602927EFF4
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751388612; cv=none; b=kTN6sSkCWMzYQWhExHAqlpBky2PxdfI0WJQltXumhnIcNyETIbbBl2rF1uxNmGL/IfUdJGqvSSMlw43vF/2RzPGLpaXPkj80iu3ZZL5zxnbutR+CqK5M5D9B9Ht5nDCwZJ4aP1T+7qlKmargawkFkk1OQvKo5nJuL3u9fEN626Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751388612; c=relaxed/simple;
	bh=35ez7Kc170voOUq5A4zUyhLBeVOgMP189lwSGDqJvck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kguc5hxINQcqM+2pR8CIQ4KveMOaUlUCB+8wgByZ7w/iet8jzMrVjtecR+vyPVj7uw7Uk3LHkvXvVb5idFK2prb8nr8NKJ0TEoGLeviJRZokgePmo6HYkyBg/U5dZ9PfjiqfcI40lcf6skepuZDdy7ZQAbV/IWZ8rYYZ3g8zVDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aew3+/r4; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aew3+/r4"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e8276224c65so5090772276.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Jul 2025 09:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751388610; x=1751993410; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=35ez7Kc170voOUq5A4zUyhLBeVOgMP189lwSGDqJvck=;
        b=aew3+/r4LSyKcek/NdgMRCkZAJLH1rF5x2Y7NYgblIBCTFvUlLBLDHeyjCQffv00wL
         G4DGO/kYeF4ERqlW1Z5zn6/Rljsr4I+T+uADbOe+4l7ijHAEfchji0o3YfonFMHLwy9u
         lh2hUGJ9Lw4DazcuX8XnsfUDOP5SumzNmPPimdDn4uw86VG+Pl++2H9REMldkGK5le8o
         MLNBGhf7NH+5wbdd4JgqcO5dsxKQUvQhtrHXiPi+P/uaIJZnk3DvZ8BdqGpaC8EGhVXE
         pSZWJqAa/Af6X4UftO/xyOooBr7A6CSKF6+/ikqEFOjU8UBWMWcLGf7vNx7/f5A8kHSI
         ykGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751388610; x=1751993410;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=35ez7Kc170voOUq5A4zUyhLBeVOgMP189lwSGDqJvck=;
        b=sck13l2YTRN6z4kWGybij5i8TAP6qQ+lrw3Il30CzmNOn8mDUXQyXVkYw4CKVZ6cy6
         z8SpEKouDQpMuun6qQYVt5wIGXgr2eh0veBLHmzgAFM65jeyA6JlQSsqfZqMLpILkbPc
         257hQmJe1wvM8i5pF/p6lKwAfL22sBoSYIdHEyhb7BUIu7pXvbfAFQOW1Qqb2eTTKtfI
         SrwrclWlu99yqJwcDABm6z70xqj2hMcfeSdZdJOCOheQB8UBngnMHEDFhmj68wWB1oDa
         Z4HA442pSVmjLN01vYt0Ed11LOU2hclYnr9e3q5BTnd9T45/BmJx1WysjkNyYvFOGUyy
         meuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgY5N6jM5ODsZ56P1a/0680WAxY1cH9WRluHvkfBj5HSBDL0l8nT+zdZAijH+3jRpsMCr2oG8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsUhEtcdIXoe6zB1tcmadvEnXWXPjGCn6Gx7Tydd2EeryKD6iC
	d0gFvGkmoi3hR53UwLqv/0I89birEktU0o5HSfxO5WPKHQKPkAIg0FUyUgSG/OyhTWwmt2tq0Uz
	C8QlLVAU3cu8I7r/bPS3EF6n9XdyfEFVwyiqMA+6pxw==
X-Gm-Gg: ASbGncvxvvY2fRfCmAXT+eZMJ6O74mLFZqXLfv92wBGU07pyts1Udpl23kmYNsM86md
	Vh1nasDCviyPjgMNrlqfdKZbzasczzL+jRQpuLKakDtaieuu+p/35QyNdNov8rsyelET6nK3ZQE
	asr/JmDpjsrVU2+8MaXW5zpfDHszxRVUkcFUgGycPKDCv8
X-Google-Smtp-Source: AGHT+IFTfzg7zxbm1tLzoaUaVZDl2uQqTZJq8NNLOxX6vxXh0XpyMCVDc9uv5IHO5vj5V+Jkhzbnk6Q9LwooxYwplk0=
X-Received: by 2002:a05:690c:30c:b0:714:3e9:dd3 with SMTP id
 00721157ae682-715171582c0mr277642827b3.6.1751388609643; Tue, 01 Jul 2025
 09:50:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617153931.1330449-1-cohuck@redhat.com> <20250617153931.1330449-14-cohuck@redhat.com>
 <CAFEAcA9OXi4v+hdBMamQv85HYp2EqxOA5=nfsdZ5E3nf8RP_pw@mail.gmail.com> <87bjq3rj3a.fsf@redhat.com>
In-Reply-To: <87bjq3rj3a.fsf@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 1 Jul 2025 17:49:57 +0100
X-Gm-Features: Ac12FXxH6G6SW_BVrh5mED54ufWIrOs3TRJVPA_Y5UCQOxGxPr3hVy6_FRNJx3A
Message-ID: <CAFEAcA8+OjptoJgPDeQkw5TQtVduhq-KvP-Br6JNDmW57jgXbw@mail.gmail.com>
Subject: Re: [PATCH v8 13/14] arm/cpu: switch to a generated cpu-sysregs.h.inc
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Jul 2025 at 17:07, Cornelia Huck <cohuck@redhat.com> wrote:
>
> On Mon, Jun 30 2025, Peter Maydell <peter.maydell@linaro.org> wrote:
>
> > On Tue, 17 Jun 2025 at 16:41, Cornelia Huck <cohuck@redhat.com> wrote:
> >>
> >> Generated against Linux 6.15.
> >>
> >> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> >> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >
> > Stripping out all the lines that just moved around,
> > here are the additions:
> >
> >> +DEF(ID_AFR0_EL1, 3, 0, 0, 1, 3)
> >
> > This is ARMCPU::id_afr0. If we want to store this in
> > the idregs[] array that's fine but we ought to move it.
> >
>
> I guess the *afr* regs fell into the cracks because they were not in the
> isar struct -- makes sense to move them.
>
> (This reg "must be interpreted with" MIDR_EL1; I'm wondering if that has
> any implications once we enlighten guests with possible midr/revidr/aidr
> values.)

It just means that the contents are entirely implementation
defined, so you can't tell what they mean unless you first
look at MIDR_EL1 to find out what your implementation is.

(Linux doesn't appear to ever look at the AFR0 registers.)

> >> +DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)
> >
> >> +DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
> >
> >> +DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
> >
> > These are all ID registers we don't implement yet
> > because we don't implement any features that are
> > described in them (i.e. our implementation is RAZ/WI).
> > I guess it's OK to list them here, though we won't
> > do anything with the array entry.
>
> I don't think it hurts to include them, it makes things easier when we
> want to deal with non-zero values in there via kvm.
>
> >
> >> +DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
> >
> > ARMCPU::id_aa64afr0
> >
> >> +DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
> >
> > ARMCPU::id_aa64afr1
> >
> >> +DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
> >
> >> +DEF(ID_AA64MMFR4_EL1, 3, 0, 0, 7, 4)
> >
> > More ID regs for features we don't implement yet.
> >
> >> +DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
> >
> > CCSIDR_EL1 isn't a single ID register, it's an array
> > of them (indexed by CCSELR_EL1). We keep them in
> > ARMCPU::ccsidr[]. I don't think it makes sense to
> > have an entry in isar.idregs[] for this.
>
> Hm, IIUC, kvm gets the correct CCSIDR_EL1 under the covers already
> (i.e. no array).

There's support in the KVM GET_ONE_REG API for reading
and writing the full array (see KVM_REG_ARM_DEMUX_ID_CCSIDR).
We just don't bother in QEMU at the moment because we never
need the values in userspace.

> >> +DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
> >
> > ARMCPU::clidr
> >
> >> +DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
> >
> > This is an array too.
>
> Currently, kvm handles this as undef.

That seems like a missing feature in KVM -- it ought to be
implemented on anything where ID_AA64MMFR2.CCIDX says
we have FEAT_CCIDX (which means that the whole cache ID
format changes and the info is split between CCSIDR
and CCSIDR2).

> >> +DEF(GMID_EL1, 3, 1, 0, 0, 4)
> >
> > Another ID register for a feature we don't yet implement
> > (and a slightly oddball one in that it should UNDEF
> > until we do implement FEAT_MTE2).
> >
> >> +DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
> >
> > We implement this as a fixed zero in helper.c.
>
> Undef in kvm.

Probably because KVM doesn't have support for SME in
guests yet ?

> >
> >> +DEF(DCZID_EL0, 3, 3, 0, 0, 7)
> >
> > We construct the value of this one in aa64_dczid_read()
> > based on ARMCPU::dcz_blocksize plus some runtime info.
>
> That one's another bit of a headache (I didn't manage to spot kvm code
> dealing with it.)

The hardware handles it for you -- inside the guest, the
value of the DZP bit depends on HCR_EL2.TDZ (and maybe also
SCTLR_EL1.DZE). The value of DCZID_EL0.BS has to match the
real host CPU anyway because you can't change the block
size that the DC ZVA insn is going to use. (You could
trap DCZID_EL0 accesses via HFGRTR_EL2.DCZID_EL0 if you really
wanted to, but you'd also need to trap-and-emulate the
DC ZVA insns, which is a lot of effort for something
no guest is really going to notice the difference on.)

-- PMM
