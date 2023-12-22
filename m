Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F1133CEA
	for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 23:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J3jq7hMK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703287523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkEZ1y+Od8QjwKk+xy23eJw9jvF0tR+So/hQMtnbcFI=;
	b=J3jq7hMKSwlREppHhRbAndYN7XF+7riiLR5jIWu1Y3PdcezqC9dL2Y4ZVD1qe1m4KPAINA
	k9V42beewsqHwmDHI7ngB+WagsavGHQkPhj9mcpYFDuMVVaLW4935dMHwnrJnldFf1UEPs
	qjAeKTbPn+mhuu0vkjvtv9VDp/LoZ58=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-cWvB8Wn_OByp4XSdBgnhhA-1; Fri, 22 Dec 2023 18:25:22 -0500
X-MC-Unique: cWvB8Wn_OByp4XSdBgnhhA-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5e6f42b1482so34376527b3.3
        for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 15:25:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703287521; x=1703892321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GkEZ1y+Od8QjwKk+xy23eJw9jvF0tR+So/hQMtnbcFI=;
        b=om0WaZs0rgh3J1aXFOOj61eGCPOq9lhlS3DwBir0aUepQhNFelygNGmTHnO4DM4JRf
         LYToi90mL/MDkexcQYxb3I9Xb0dm53BcgATAOoRrg2RIgzt7Q53zqM0bfH6pIqC5d6Ma
         gtxi39sGwCc++T6PBVsniCzfMiK3OT42jZ/B4a1+3B5Vvq0O4NE15xHbzFfJC4gWbkpu
         xgKVvlH0eMVH1+doAvUCM+YVV/WQQs/lFrW2am9PavtQgoDQ0tqVCkEplOltpQfFkEjx
         BkEs/+uwmw4K88YbcVlOpd8MM6G6DIixRyZl5Lektyu9tCVjyyOLc1J0h25qXHAlu09t
         /nVg==
X-Gm-Message-State: AOJu0Yx9OfHNj2RaAH5lJym1qo8LMU2/xHY8i6/kuPbj40EWBMOtiuKI
	3lsKgSLt2aNpaah5hX8oJ1INVLPPBuJRLc14Xjj55xUALdADLmXTvuPbgicAId+QrNxlnpH9hHM
	h6LwLZCtbfFWbXtFkI+J+cehxD7q/IWCXeszlpQM7
X-Received: by 2002:a0d:e60f:0:b0:5e7:731f:cbfd with SMTP id p15-20020a0de60f000000b005e7731fcbfdmr2122785ywe.42.1703287521616;
        Fri, 22 Dec 2023 15:25:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4peG8QFXogPSz9Z8FJhgPYUNNmD67LzVd8kdHknyb1FXrx+tdQwRh4FX14vGlvBNWcvhcSs3HKYyigzXvvr8=
X-Received: by 2002:a0d:e60f:0:b0:5e7:731f:cbfd with SMTP id
 p15-20020a0de60f000000b005e7731fcbfdmr2122772ywe.42.1703287521372; Fri, 22
 Dec 2023 15:25:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZYCaxOtefkuvBc3Z@thinky-boi> <784ab26d-8919-4f08-8440-f66432458492@sirena.org.uk>
 <69259c81441a57ceebcffb0e16895db1@kernel.org> <ffbca4ce-7386-469b-952c-f33e2ba42a51@sirena.org.uk>
 <441ff2c753fbfd69a60e93031070b09e@kernel.org> <cc920d55-39df-4255-b194-a2db1dec6bb7@sirena.org.uk>
In-Reply-To: <cc920d55-39df-4255-b194-a2db1dec6bb7@sirena.org.uk>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 23 Dec 2023 00:25:09 +0100
Message-ID: <CABgObfatzu=tV5UfXOnxZ12GgM=013+-teEj_-5NCLTr6Y82Mg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, part #2
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 22, 2023 at 3:21=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
> > > I see it's not, I'm asking if it should be - given the latencies
> > > involved it seems like it'd be helpful for keeping -next working.
>
> > This is on purpose. We use -next for, well, the next release,
> > and not as a band-aid for some other purpose. If you think things
>
> Note that -next includes pending-fixes which is specifically for the
> purpose of getting coverage for fixes intended to go to mainline (indeed
> this issue was found and reported before the original problematic patch
> was sent to mainline, it's not clear to me what went wrong there).

Indeed most other KVM architectures have a tree included in
linux-next's pending-fixes and kvm/master is included in there.

Knowing that KVM/ARM does not have a fixes tree included in linux-next
might make me get those in kvm/master a bit faster, but then I'd let
them stay in kvm/master, for a day or two of soaking in linux-next.
It's never happened to me to send broken or conflicting pull requests
after -rc1, as far as I remember, and it's indeed unlikely, but
linux-next does provide a little bit of peace of mind.

> He is on CC here.  I'm not sure that it's specifically things not
> getting merged (well, modulo this one fixing an issue in mainline) -

I'm indeed not exactly a speed demon, but in this case I specifically
wanted to make sure to include everything posted before Christmas, as
this was likely going to be the last PR in the release.

I also wouldn't have minded a review or tested-by for
https://www.spinics.net/lists/kvm/msg335755.html :) but in the end I
included it in the pull request anyway.

Paolo

