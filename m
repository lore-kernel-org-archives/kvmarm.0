Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE2F80050
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 18:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707332281; cv=none; b=B3tBpquzlcohI5qPaQhsPt3v4l2eh7v0ZJ222qarTgPFuytPPzvfeZC5Y33L0IfWiszeH1+flYUUUNLxkWLBDhNtLx7Kx9KjEsn1idhS9XLPGf/vGJSzHEvzJ0SPCzm6VjRi8r35wvw8y70GVOECrUV3k4MvyDk7byOPEFwodJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707332281; c=relaxed/simple;
	bh=8s1FE+YRVuHP4SdIzI41sDhkZil2SiMwsOgXkAW8/qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CsKZbtcxDzzr0ca28XO90snzBtL6Tjq4gZdIfCZlLaQNLHjMZYQAl6aIWJWTl5Gb0mcFNrP74E214zINdpwOp8iIxVlADxmXgPYHR7OF+SDBMRhNsxonulefKoRY2LiLyKpq2TRxjZlUDGCn2FWMLJXg7AY22JScPoZkflKznSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S2digXZA; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S2digXZA"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5961a2726aaso536453eaf.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 10:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707332278; x=1707937078; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8s1FE+YRVuHP4SdIzI41sDhkZil2SiMwsOgXkAW8/qA=;
        b=S2digXZAzv4L5DEiVvg5yNvokHQNrcrsxQWzVdgonbFrkubftwYbARCGmHfkSSIqbc
         2rzFOII0vZ8lOdBRLphfzg7nCfy5cty2xwBL+UNfRrvbiqqsSgAlKxk7gEuYdIWwC1gt
         O4nusMngLsPu3leaRqKjBjROG0cTr8riD1a3exFWdLp+wUmgEB3Ydwg5joq9AwDKKGzG
         789ipIGQTVKaGfGdGxxnYNAdvM3y4rwACsniIFDHncHjRlzoY0yPku6s9wZoB9rELfxC
         P6AE+tFpVl58ESunBR6yQMm6pY2bIDMKhnhhBbDbDXOCUSpL6AP9lDQ6QPM9KqLkMutN
         sdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707332278; x=1707937078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8s1FE+YRVuHP4SdIzI41sDhkZil2SiMwsOgXkAW8/qA=;
        b=EHX8WrPTAvTITagaVRVZazqv57WJJIkmCxSr6mOllXb8Ym/wd4VzJ5RphaDhgDt/j1
         TccLcoMgJI/skgAqPQDE48o4gHON4NfrjwQLvr9cNDQYU1Uw0eFWT6CmpJjI7fzceRVX
         AASjcJhFhpi5piLN5eEn1+Fg7FP5Qzi4YQ7BKhrNDeS/pRkY3fIdlkjLNCbB/RdKnAwP
         QS3qyRaOaguxAVInVhDmgn2PEVNZF3Vm8AibZoQPWQokXbVBaXpC6cFg6O9DBIx2n+Bk
         hmT8jB9fXV+5fjYLq9auMpbPrlxWlFUw5pZ77KXS4TY1XWD9bSFfN2DeQOTCm5A9hgjJ
         AsuA==
X-Gm-Message-State: AOJu0Ywiy3jeQBAw+e//BtGzuRLtotkEvsT4Xh09AZf0RWoeu9VWHkdW
	2zXuwi5LjyTfeezNU7iFXC8KwFWRtFM2kZF5sxno7vOihgbJjZJF1iWdY6f8x5iDYoESAgruXN8
	5FxP+zF5M5GWTjCyc3uVy48VoJsWvCxBoJNg3
X-Google-Smtp-Source: AGHT+IGD8YicdIIBCsyotLNK1A8/ICVi2B7RYMeG0O1LhRdYK2atxybYtkqqFxC0AJniSwuMzi9wVspy9PjeOVVqiug=
X-Received: by 2002:a4a:2d09:0:b0:59a:2817:1533 with SMTP id
 y9-20020a4a2d09000000b0059a28171533mr6012945ooy.5.1707332278646; Wed, 07 Feb
 2024 10:57:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-5-amoorthy@google.com>
 <ZcOiM4O-oPcZpeac@google.com>
In-Reply-To: <ZcOiM4O-oPcZpeac@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 7 Feb 2024 10:57:21 -0800
Message-ID: <CAF7b7mopsU7zGy2RbRMVNvmF+fwsa2BL0kXvwHjC1niHbDb4CA@mail.gmail.com>
Subject: Re: [PATCH v6 04/14] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT
 RWX flags to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 7:31=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Needs a changelog.

Urgh, that's embarrassing: I'll use the following absent any objections

> kvm_prepare_memory_fault_exit() already takes parameters describing the R=
/W/X
> nature of the relevant access but doesn't actually do anything with them.=
 Define
> and utilize the flags necessary to pass this information on to userspace.
