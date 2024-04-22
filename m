Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAE048CF2
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 08:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713773528; cv=none; b=Ik00lJ4dNcnVGn/jNOFQ8fMhUQ4PogwFfszW0yd0ZiLrrFVMiFcJ87wTCuyczJW/cj0ESjNq3T0tsFf94dnkiF7MEHgPjLa1AjnRkyNxLeRSdd68uGWAFdtVk4dzz1cXzKcH4OUUR4lSOwOaprcYsZDFJn8NhEwO6hiJxGPkTa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713773528; c=relaxed/simple;
	bh=mSp6NSho+E0BSlYpSDfx7+w1TvH1fUrtLurZd/um5hc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fz7CPypXOvEQ1Q3v7Zc9/R2L74YFRZYLlA1PL+JoJqjL4YdY8eUEwidQF4XhQFKUgUSXyhFGkKgcuNixnSTe/jLj8Ymbl2J6NF0iDqP2ajpP98QSG5VkmMc9hIo0WP2GPxH3A1rM8TOLFSjfuQuCEcLAHnoE7EIknP7V6MdON9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k+eyXN4B; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k+eyXN4B"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-47a3819c4bcso638979137.0
        for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 01:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713773526; x=1714378326; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSp6NSho+E0BSlYpSDfx7+w1TvH1fUrtLurZd/um5hc=;
        b=k+eyXN4BIB+7+FXwtCgDYJ5VaEXA8xgjl6T89iiDp8YhzXRrQGeBlNl5DEKAJAfASw
         1b5pXphOBz61EztKPKN9nnovZTrnZ0iVxkjGqVQuoKjNyjTDfHt/FZd8flvXMGEjhXh5
         uBr5D7aJCknoQ3eViyVGH+Twz2kspCw5oZAA0kSw6lMI2WwJr9ydpXoM/aWdVYCpysNT
         CpHbagAxkzwnkoDjFKPSaUCeZsHwBBZhuf/mTGGowVL3KSaERyq5Pp5eEuTkiK9QHMEp
         ZLG+OmpP5Z8RGPQccJZPxTJ3VRanggOcNPF5zvuxWOpRO1x3VXOoQBPBguvND98tVoux
         YqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713773526; x=1714378326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mSp6NSho+E0BSlYpSDfx7+w1TvH1fUrtLurZd/um5hc=;
        b=V2U7FsdRyTyzIN5IRjR1e641uIY30wREvZiXHBCDh+sNUn4Cz8uN+AZCM0L091OKvy
         jEbjDgo8zJIZyAm+1t8naXVHWCCs/Qdv6x/uP3CPkSxcM6i0mDiKWLPJX3uI94cesxKV
         xsKhoCP79LLjgPtU2NX8eQgjpiQwvwbQ4IeYdIAAibCZAk2jDW0jW64Mjjwlrku6XdOv
         KpWhodaTlyCWcT4K3XnepLWBQBRgVTwnIEcOVQxhPpHf84IAkY9N4bnSFuJJiQqr5lfT
         ajh6TAOx11BR0+hY/0W5Ixcf4e8Og4vb9PlEYR8Dsd51pgllY/vqvDND4Xn8Z5uoMwjU
         gWRQ==
X-Gm-Message-State: AOJu0YwjAeLelbdx654ll2Q+lhJHTA+oXLRgxmrXJS/1jCbEd2D0cBgM
	TxPGKRbTPwrMpWtQPS1qt6NsRURGDo3X5/YX8EyjgyF09SgPbypwrLX2l3OHOfLcyB89rPasDOT
	e6b3o3gg7ztZIb8RDR6sexDK49XRPH62QrPvK
X-Google-Smtp-Source: AGHT+IGY4K0E672bg8rQfl8RTXeka64n2ph7HBw6d28uth6eRY77mvXIQcaNRIqBJwXt71Z9OyzbE+dSrcOSp9C/sSM=
X-Received: by 2002:a67:ec4b:0:b0:47b:b8a6:32bc with SMTP id
 z11-20020a67ec4b000000b0047bb8a632bcmr7898486vso.33.1713773525914; Mon, 22
 Apr 2024 01:12:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com> <20240419075941.4085061-10-tabba@google.com>
 <ZiLaC8nrfcp9lDTD@linux.dev>
In-Reply-To: <ZiLaC8nrfcp9lDTD@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 22 Apr 2024 09:11:29 +0100
Message-ID: <CA+EHjTw5dDnqZgy_W_LmWFf94bxgVB8_np0hgvWpjY7RnpvYDA@mail.gmail.com>
Subject: Re: [PATCH v3 09/31] KVM: arm64: Support TLB invalidation in guest context
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Fri, Apr 19, 2024 at 9:54=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Apr 19, 2024 at 08:59:19AM +0100, Fuad Tabba wrote:
> > From: Will Deacon <will@kernel.org>
> >
> > Typically, TLB invalidation of guest stage-2 mappings using nVHE is
> > performed by a hypercall originating from the host. For the invalidatio=
n
> > instruction to be effective, therefore, __tlb_switch_to_{guest,host}()
> > swizzle the active stage-2 context around the TLBI instruction.
> >
> > With guest-to-host memory sharing and unsharing hypercalls
> > originating from the guest under pKVM, there is need to support
> > both guest and host VMID invalidations issued from guest context.
> >
> > Replace the __tlb_switch_to_{guest,host}() functions with a more genera=
l
> > {enter,exit}_vmid_context() implementation which supports being invoked
> > from guest context and acts as a no-op if the target context matches th=
e
> > running context.
>
> I'd rather not introduce unnecessary asymmetry between the nVHE and VHE
> TLB invalidations, the code duplication is annoying enough as is. Can
> you rename to {enter,exit}_vmid_context() on the VHE side as well?

Will do.

Thanks for all the reviews!
/fuad

> --
> Thanks,
> Oliver
