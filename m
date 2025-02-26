Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4080821D5AE
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596089; cv=none; b=ZtTQuIqsTjo3Pk9+Dx7V0ggsjanlM7+vV825oZNI24/eWd/yx4R0eBfDghHaLm02N1I3/1P5bTClY4vpsI25TtzmshZZX9Q3J7BrhT976N3VuZoE+Oc8/0VmbP9L+7l5GFYEXgZC5e5L/epKXKD48mCAWUZ2ehe6PukpA1HTEIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596089; c=relaxed/simple;
	bh=jm+hQhpbBPZDXtIxFlvAlRst+7gSlpnJiPBA9eiFpWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KKzCwLFXlbTvCrENLuKjXnBu/dhEu6BMuFbl+RBbppm1imQUbJ9/PWvoHJl0rTxcSp9q2wuRCkZh++9YnBFnbvzcRfL/ZNNC2QN7Csf1kQVHjJ2RPeqKAUR/zz0hCisieyRgj+8u4GPPal79hj7sneynmracqAtRkPbRMBXmq3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j+4GLKj+; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j+4GLKj+"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-471fbfe8b89so24381cf.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 10:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740596087; x=1741200887; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jm+hQhpbBPZDXtIxFlvAlRst+7gSlpnJiPBA9eiFpWI=;
        b=j+4GLKj+u0LSphHnjI7c2TJg1FpI6hFGJ8fQ0YAs6SVFDYDqjU3VuXVIG5MP4ETZMy
         pbqJNSKc6ZWjULkn0UJ01X2FvQSM+11WoK3aZzOXc2083MFSbDJp5nJqbVPjFY4Vm8jA
         9VQNPl1UPiDrZbuofsCtCJLt4wn0KeM8ez7F1nDcxYoG8NWeHAKh9NefYCV0M5FSBUJ+
         DZWF/cFvq1dPzxGP87PBTWeXQk5DQFOFE3EHTWpz7V6jxHtJh9uuU5ZH30pXttYiEUrB
         u49A3imqgqaL4jmDRBvAJ2jA7//zTfqF0uutT8esUhQ86M0qf/GVKZWgU7lxbBqo+u6B
         3jpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740596087; x=1741200887;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jm+hQhpbBPZDXtIxFlvAlRst+7gSlpnJiPBA9eiFpWI=;
        b=wBZhDMjIF636TjiWQit7OBpJ05QKjb65Om56HUZaS0dHAQ8COkyHFc9xfpXWt2vX1D
         +CATSbTXUqfrdUR6b4Hc4qVoqmRDf7BJYcFHX3ZCRjXVLJ05qC+0UfK7WVvZPAuU9ZzK
         umkWuebSiZoyO2fy3wqJhqp2wyN6PwV5COuClL+H3IAlYGW07FH2o0TJ5HMYZF7L5hAO
         Sq6Z0w+y9iTjQTXeLc7HD1D+F5CHBYK7UCt4HAfsrcotOxCZXN41ov7zkuLW+ofaamrP
         4S/7Uj8C1BGN+DFshzYFKMKAE+x3YWXjqecYk+iofmUe4EI0PyWPfB04gHwOKSYWaAVI
         QhGw==
X-Forwarded-Encrypted: i=1; AJvYcCVftJ8BmlUVYRTEse57McqNETUQA0Ye8I8JfAR7E5G0wYxtiluLYfU051TvH1iZ3cu2gwxUkZs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3GWF1aULe1wjz0yi2raLBZKmgEWFUVA5tiri3T1aiMUe35TtG
	zsalnwHm9FYwxWmXH765JR9zpZRtxX3ND+vEbUyLHcjP9AXn2J3qUrpa7DkPSwF6l2nlromHg1g
	nF9K8Zz5WaaiouxTl0m26fzKEqnTiBe5cfKyU
X-Gm-Gg: ASbGncucEhlKT2KM3U1Vgmon8JW/VUtaTlpM30ouUuOKyce8UVyZ3qNajEC2EiyJlav
	KU6Ng77tArPBKOeUnFVuqRm+4pTUpAD8v2cTK3g3M5ks7oy1IYnXlaBuyqhoeGVxbQwNcJkb/ZF
	329htTBfSrejdLsXf+ZqFHxmznSVnUhPAhkL2XiA==
X-Google-Smtp-Source: AGHT+IEvbo/qpO8zM6NEwM8415x8NiC4BvYaD8EjSi3ZRxS+phZeusP2fVadV5Yb1VRrKz30bhb6mW1PPbQZPX6zf/U=
X-Received: by 2002:a05:622a:586:b0:467:8416:d99e with SMTP id
 d75a77b69052e-4743eb158femr36311cf.21.1740596086874; Wed, 26 Feb 2025
 10:54:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250214150258.464798-1-tabba@google.com> <20250214150258.464798-2-tabba@google.com>
 <Z77n_Gv0X0bolONW@linux.dev> <86a5a9q90z.wl-maz@kernel.org>
 <CA+EHjTwRNj6z_TTCXR8UNiB0ty=85_VKWDVsFOLke31UGnBE7A@mail.gmail.com>
 <865xkwrai1.wl-maz@kernel.org> <Z79jERSoEvEtZI7k@linux.dev>
In-Reply-To: <Z79jERSoEvEtZI7k@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 26 Feb 2025 10:54:10 -0800
X-Gm-Features: AQ5f1JqSx5kV2acKeViwRiAfykz0YO8iKO1HdNiNosGApuOWJ7mYmxLt9fS-EJg
Message-ID: <CA+EHjTwHZ-2sX38bsUQCSuwPbQC8pjHwJ0wCQROi2b+k_fHvZA@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] KVM: arm64: Initialize HCRX_EL2 traps in pKVM
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, 26 Feb 2025 at 10:53, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hey,
>
> On Wed, Feb 26, 2025 at 03:28:22PM +0000, Marc Zyngier wrote:
> > On Wed, 26 Feb 2025 12:44:49 +0000, Fuad Tabba <tabba@google.com> wrote:
> > > On Wed, 26 Feb 2025 at 02:45, Marc Zyngier <maz@kernel.org> wrote:
> > > > This is a copy/paste of what we have in kvm_calculate_traps(), and the
> > > > result of the removal of the dreaded HCRX_GUEST_FLAGS.
>
> Ah, I missed that.
>
> We probably should've just tossed it at that point, doing configuration
> for features we don't support is a bit confusing.
>
> > > > > Any objection to dropping this bit? I can fix it when applying the
> > > > > series, no need to respin.
> > > >
> > > > Whatever we do, I think we should keep the two side of the trap
> > > > configuration in sync, as this is otherwise a cause of bugs.
> > >
> > > I could take the initialization of hcrx part from
> > > kvm_calculate_traps() and place it in an inline function in
> > > kvm_emulate.h. This then would be called by kvm_calculate_traps() and
> > > pkvm_vcpu_init_traps().
> > >
> > > What do you think?
> >
> > That could be a good option indeed, irrespective of the fate of SMPME.
> >
>
> Agreed. Fuad, would you mind taking another pass at this with the shared
> helper?

I'm on it!

Cheers,
/fuad

> Thanks,
> Oliver
>
