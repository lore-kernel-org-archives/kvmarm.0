Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC5A63AE
	for <kvmarm@lists.linux.dev>; Wed, 17 Apr 2024 01:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713318054; cv=none; b=trF6NJYpr2F51xKy3A9zHXSG4gcCDYFvmT0D5Rn6e61aJs4A6uYtf0RidjRRs7UUeoUYCN98D44HPNGjfqReh2yCle80UFzibQo+y5IP2JPsOoJb/62YM7cIqIo35XRh9PorJ6pkI1aPC5FbGnwMdXSpvh1JDYPp7fg8eC9SbSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713318054; c=relaxed/simple;
	bh=qd+oXhdytQdMGQjfxPuaaFQdJ9/xiGThuh+6RN0NtNo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=Unrj9rwVmg/QspSKZqYcEzLGbs8Vo9Kabn2MEBks7JUnEkFJLCr1UTtebkpuvQwaN4/Iu5sjLMR4XDqvdopDr+iMVg0kJY5ZjJTG9ioC9Fm6Ml6J/EI3rhe0xrZG+JoJq1Dd3tZ13g9iFKc9dqcqOoBmgH3aw6Yt9IyhEmQkA6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+ss2pr2; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+ss2pr2"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2a6ff4f91cbso3200902a91.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 18:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713318051; x=1713922851; darn=lists.linux.dev;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6kw6dCQ+cydDghFyBvYaAs0p3Ma1QKkt6qhRC1Ap34=;
        b=a+ss2pr2/f/Xir1bKDsGQo/Mpun7s09MCLNFkRXC9pGDd8WupKMFsE9392HuKO+E0f
         JhnW5f4Fqke/pGWiSpB7Pk/Xe8C/NXQFu6Y4p4eig3cFs+2RyuZMEI3TP9vrKDtN3UgW
         QAPWzQHSWvO8iz8IFO+wgJcqiLG67sXyO15dk/6tGKkS6oeWI7JO1iUvIKQIVklMHe3l
         MQLRTbwVLZjKmrB0WuKf4LCeDuzx4yjgad9nn6iCuANFeq7aIlfhR2RazIINY6rlNExj
         MzxnV96ArrdvarpZ+2CYEDrr9e2TlGmEellKTxs6toBreC4qpCVr6ad5M/kM7hYv4gFp
         gElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713318051; x=1713922851;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m6kw6dCQ+cydDghFyBvYaAs0p3Ma1QKkt6qhRC1Ap34=;
        b=pBp1O0O91CqiiwGzbrUSeFRC3P66tG9dywRF571UDfxSNYpkTVDahkfQ83t6bRN+PZ
         2RZSBaHamCt/v9LLlaUGgvF7njHohoSMJ/cMbHDv/jw3qubKRBgDaOnMd/wA+kleZbvF
         obi5XOkQ6w9WG77Ztf34GJ8kPyMnw1dh7uUKW1+hYnKsWR9LEnNtOtwKIQSG8mu3vgjF
         GkUMzIaZvzpWeNA23JQt/iuhnTP8EMVtTCnLrKeVQpcUXYrxIjva4KX0iub2sIOXqpxs
         bJjECzRtHGSg1hPch5bOeAOQLWVKWUwf+OBnGXUInRllnDKnEB+lLbOKzcOgE/KImfId
         gOXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx1SX4kSfnhX36expvT1m8mTNjF6IogZp4kguj19IDKEkttOIF+Q0CG5eENtcF0V3sum7OptbW58pwy8Gm+r3tj7YTqpDJ
X-Gm-Message-State: AOJu0Ywckcjpk1XcOSne8PZuthMnMcnQkAYXRXpG03ta1r1mmdta2Z4X
	QEBxFXW/Ejw6QduRJQjKlCiLVbc87p4gO0F0RfQYiT4xP58uhewn
X-Google-Smtp-Source: AGHT+IEuN9i6b2kO7+yPYNxq5M/Sp0bpfJQ/y0HJK8y0kGe81d5INGjTCRH6pUQ3OUq2XgGUoTKysA==
X-Received: by 2002:a17:90a:d24d:b0:2a5:c3a7:39d9 with SMTP id o13-20020a17090ad24d00b002a5c3a739d9mr11513430pjw.45.1713318051302;
        Tue, 16 Apr 2024 18:40:51 -0700 (PDT)
Received: from localhost (gla2734477.lnk.telstra.net. [110.145.172.154])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090a428900b002a3a154b974sm250417pjg.55.2024.04.16.18.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 18:40:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Apr 2024 11:40:40 +1000
Message-Id: <D0M0K25RUX0G.1FCOQS1GR21N4@gmail.com>
Subject: Re: [RFC kvm-unit-tests PATCH v2 00/14] add shellcheck support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Eric Auger" <eric.auger@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "David Hildenbrand" <david@redhat.com>, "Shaoqin Huang"
 <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "David
 Woodhouse" <dwmw@amazon.co.uk>, "Ricardo Koller" <ricarkol@google.com>,
 "rminmin" <renmm6@chinaunicom.cn>, "Gavin Shan" <gshan@redhat.com>, "Nina
 Schoetterl-Glausch" <nsg@linux.ibm.com>, "Sean Christopherson"
 <seanjc@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240406123833.406488-1-npiggin@gmail.com>
 <a7cdd98e-93c1-4546-bba4-ac3a465f01f5@redhat.com>
 <D0L86IDPMTI3.2XFZ8C6UCVD1B@gmail.com>
 <3ed01604-3b9e-4131-9ec0-c354c6d65cc8@redhat.com>
In-Reply-To: <3ed01604-3b9e-4131-9ec0-c354c6d65cc8@redhat.com>

On Tue Apr 16, 2024 at 2:46 PM AEST, Thomas Huth wrote:
> On 16/04/2024 05.26, Nicholas Piggin wrote:
> > On Mon Apr 15, 2024 at 9:59 PM AEST, Thomas Huth wrote:
> >> On 06/04/2024 14.38, Nicholas Piggin wrote:
> >>> Tree here
> >>>
> >>> https://gitlab.com/npiggin/kvm-unit-tests/-/tree/shellcheck
> >>>
> >>> Again on top of the "v8 migration, powerpc improvements" series. I
> >>> don't plan to rebase the other way around since it's a lot of work.
> >>> So this is still in RFC until the other big series gets merged.
> >>>
> >>> Thanks to Andrew for a lot of review. A submitted the likely s390x
> >>> bugs separately ahead of this series, and also disabled one of the
> >>> tests and dropped its fix patch as-per review comments. Hence 3 fewer
> >>> patches. Other than that, since last post:
> >>>
> >>> * Tidied commit messages and added some of Andrew's comments.
> >>> * Removed the "SC2034 unused variable" blanket disable, and just
> >>>     suppressed the config.mak and a couple of other warnings.
> >>> * Blanket disabled "SC2235 Use { ..; } instead of (..)" and dropped
> >>>     the fix for it.
> >>> * Change warning suppression comments as per Andrew's review, also
> >>>     mention in the new unittests doc about the "check =3D" option not
> >>>     allowing whitespace etc in the name since we don't cope with that=
.
> >>>
> >>> Thanks,
> >>> Nick
> >>>
> >>> Nicholas Piggin (14):
> >>>     Add initial shellcheck checking
> >>>     shellcheck: Fix SC2223
> >>>     shellcheck: Fix SC2295
> >>>     shellcheck: Fix SC2094
> >>>     shellcheck: Fix SC2006
> >>>     shellcheck: Fix SC2155
> >>>     shellcheck: Fix SC2143
> >>>     shellcheck: Fix SC2013
> >>>     shellcheck: Fix SC2145
> >>>     shellcheck: Fix SC2124
> >>>     shellcheck: Fix SC2294
> >>>     shellcheck: Fix SC2178
> >>>     shellcheck: Fix SC2048
> >>>     shellcheck: Suppress various messages
> >>
> >> I went ahead and pushed a bunch of your patches to the k-u-t master br=
anch
> >> now. However, there were also some patches which did not apply cleanly=
 to
> >> master anymore, so please rebase the remaining patches and then send t=
hem again.
> >=20
> > Hey Thomas,
> >=20
> > Yeah the sc patches were based on top of the big series, so some
> > collisions expected. I'll look at rebasing.
>
> Ah, ok, we can also try to get in the big series first ... I just lack=20

They should have come first, but I'd written the multi migration code
before Andrew suggested adding sc, and it looked like hard work to
rebase the other way. I'll try again.

> enough spare time for reviewing currently, so it might take a while :-/

Understandable. You've done heaps of reviewing already so I really
appreciate it.

Thanks,
Nick
