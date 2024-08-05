Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F72149C4E
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 23:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901463; cv=none; b=nqGGrB7NGv2t/2G37xO7ZFH3HcTxXWkMJSfbIYBDjjrGKsoKDMZISCgGqAR3knQC58rrAG4gAbQfstuCALyRRDTiw1+QEA2dwhb/ITyfuSKbg0Z/Phcxj+2xP5yLyPAMUUKqhvgkiXxY/MeTf1/kMEHHVp2e7orpi8m7VwZ4YgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901463; c=relaxed/simple;
	bh=N36BgzP/Ze7QI1FmjnSinfkcU4TKCKVAfKUS3FFhhCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WJFBrK0OJTLVbcoEsqTrvAlnqgWiWS1RvhTNt/wRbWVEWIQfz1Hw/F6afbSlHVE6/cYZTdLM3kJ/n+pA/Ke5cgBVhlvfR4S01a8JY7Y8fpj/dcfc+EEfrCjAJstnHEPHVLU3VV+bvXD2HoskYlzf6ldeAbRdw6FcVwG+5LUybhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=nIr9T/c2; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nIr9T/c2"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f035ae0ff1so2531941fa.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 16:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1722901460; x=1723506260; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ldf/5dV/loYFjBwyCn5nK6gnfSKwn5dyvPTT5/+hrg8=;
        b=nIr9T/c2xvActtRMI4DHyX4YxVoBRrFzO8KtQAhmihLV/2zK6rfKfTGRx4OZ127NjN
         7u2wOK+Shk4x1fkSBmYvsuBJhDoMbbQ/kyJfags3loFoATzBLORH/lqUG1sGHaujr9aS
         sV+zA5tI4PzcgMOjIOnCZeWDpj84s4XWilD/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722901460; x=1723506260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ldf/5dV/loYFjBwyCn5nK6gnfSKwn5dyvPTT5/+hrg8=;
        b=TJWueZW3G/epcLSHZ8juIsi17bmsItHPL/rCFDUBaBmbN86g9LHJT5lgD89e0HcmUS
         rQ7E5lKwEM5QQKoAfBXTEao+BwdmxE7c6Ezo+X6UlIjkReyFBRzy9Pccgx59TkJxRhS3
         HZXGdmdXTq1p4JmNFQiLbtcFmpfMS1mrWUtT13MMHmgSINmaOCL2wvM601aH8wrqxjJa
         x1/YuptFlmydt5w4KhsOm31HU1AtqK+8V5lymNFTVtUiRLy/eEfZI+GKWAMFuQZGsAKT
         pSC2OJ6HN1nSh3UoiowvgQwI5U5QY3hxGs8t8c2GwnSNKD60S01qoOhgIysmx/bSZ1ll
         ChqA==
X-Forwarded-Encrypted: i=1; AJvYcCUN9muh2a4Yl1j1AnvjPmHFEXaOYrvT2ZD56ZTzF0kJqlm7ydDT7Z9nsToMU3NLWWWZiKiAomYSpWOyw7+SbrprQ5Lcvh1D
X-Gm-Message-State: AOJu0YxWtfGxFLcgnYFWew8LcGGgU77Gn63j76CSnxAXWAJUwy/4bUCz
	jwn7wezkjbVdgsXQfYPkcAk1Lhe1sr3DKOwafIK83G5wXCAgg1Lu4kM87U6+GcG7/IIHR57OGD2
	htjraQb6wfIyJTg03pgX60om7dzbDdjD85UR1
X-Google-Smtp-Source: AGHT+IHIK0kYEUYapI5tIc8vSMvjbESuyPpwn3iTc/MzDz8eRJWcfhJa0eyJoudkIswN6TS8V0q74Bp34S0uh1BvkQE=
X-Received: by 2002:a2e:9004:0:b0:2ec:347a:b020 with SMTP id
 38308e7fff4ca-2f15b13c649mr36224431fa.12.1722901459336; Mon, 05 Aug 2024
 16:44:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZnXHQid_N1w4kLoC@google.com>
 <87cymtdc0t.fsf@draig.linaro.org>
In-Reply-To: <87cymtdc0t.fsf@draig.linaro.org>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 6 Aug 2024 08:44:08 +0900
Message-ID: <CAD=HUj6gjqthaenpZUr2Lci3WJW86OWe559YrDWiUSVfZBNHiQ@mail.gmail.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 8:41=E2=80=AFPM Alex Benn=C3=A9e <alex.bennee@linar=
o.org> wrote:
>
> Sean Christopherson <seanjc@google.com> writes:
>
> > On Thu, Feb 29, 2024, David Stevens wrote:
> >> From: David Stevens <stevensd@chromium.org>
> >>
> >> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> >> that is backed by struct pages that aren't currently being refcounted
> >> (e.g. tail pages of non-compound higher order allocations) into the
> >> guest.
> >>
> >> Our use case is virtio-gpu blob resources [1], which directly map host
> >> graphics buffers into the guest as "vram" for the virtio-gpu device.
> >> This feature currently does not work on systems using the amdgpu drive=
r,
> >> as that driver allocates non-compound higher order pages via
> >> ttm_pool_alloc_page().
> >>
> >> First, this series replaces the gfn_to_pfn_memslot() API with a more
> >> extensible kvm_follow_pfn() API. The updated API rearranges
> >> gfn_to_pfn_memslot()'s args into a struct and where possible packs the
> >> bool arguments into a FOLL_ flags argument. The refactoring changes do
> >> not change any behavior.
> >>
> >> From there, this series extends the kvm_follow_pfn() API so that
> >> non-refconuted pages can be safely handled. This invloves adding an
> >> input parameter to indicate whether the caller can safely use
> >> non-refcounted pfns and an output parameter to tell the caller whether
> >> or not the returned page is refcounted. This change includes a breakin=
g
> >> change, by disallowing non-refcounted pfn mappings by default, as such
> >> mappings are unsafe. To allow such systems to continue to function, an
> >> opt-in module parameter is added to allow the unsafe behavior.
> >>
> >> This series only adds support for non-refcounted pages to x86. Other
> >> MMUs can likely be updated without too much difficulty, but it is not
> >> needed at this point. Updating other parts of KVM (e.g. pfncache) is n=
ot
> >> straightforward [2].
> >
> > FYI, on the off chance that someone else is eyeballing this, I am worki=
ng on
> > revamping this series.  It's still a ways out, but I'm optimistic that =
we'll be
> > able to address the concerns raised by Christoph and Christian, and may=
be even
> > get KVM out of the weeds straightaway (PPC looks thorny :-/).
>
> I've applied this series to the latest 6.9.x while attempting to
> diagnose some of the virtio-gpu problems it may or may not address.
> However launching KVM guests keeps triggering a bunch of BUGs that
> eventually leave a hung guest:
>

Likely the same issue as [1]. Commit d02c357e5bfa added another call
to kvm_release_pfn_clean() in kvm_faultin_pfn(), which ends up
releasing a reference that is no longer being taken. If you replace
that with kvm_set_page_accessed() instead, then things should work
again. I didn't send out a rebased version of the series, since Sean's
work supersedes my series.

-David

[1] https://lore.kernel.org/lkml/15865985-4688-4b7e-9f2d-89803adb8f5b@colla=
bora.com/
