Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5EE1D69F
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 16:58:43 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-34fa117f92bso2405ab.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 09:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695056323; x=1695661123; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=knRagvKuCPzhCIYhCOjRCh44VjecKJtrl8eHwZBErg4=;
        b=yid/VzrO2W80H/UBKVGnqQXYvgIrEbOgOWRZPpkn/rWwT/aaZGszAZN3rNTMJVJeQU
         vv8SCAw8TDUSgICAKpPoaz+MitVPu5/IgT1XMEG0yKKewAf5iQX7k0Q9WmjnmsZfMMKa
         oU7C5kjzQlMoJFMUrYICvDGX2/BqDOHMoVBehUNxARurAiyFuPcFTqNhZBX6xXjXQhnv
         niAcLtjuuY9QrbdBORBjV1sgcqg0ZTmQV9LMvmwkYUDJozhxgKZXRgb/LhBWTJIiBfrV
         40FXiyt+mR6vM7x8/LDO1/hKXnR164ucTEq0Wts+RK7SEwvKwhpEWrkBIUQL7tQg+WTi
         eIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056323; x=1695661123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=knRagvKuCPzhCIYhCOjRCh44VjecKJtrl8eHwZBErg4=;
        b=tHRgH1vRxDq1zAt2kT5Jt1zEU9RPNqfTjyruhOzgKutZaxv6pZ1aRfQUstRWEAb2CJ
         a+Q4pHxsSDDYNZMvJUp4sFlbGPpE1p9Bu1eDbblW8011z1aZzC67/WrRKxv5bMxSb75f
         qoN5epQJND7OaQcOL8ItAJNAYxdoSdDHmX1DinAl9r1GpWAdWEA4/FxqVj9wlU4IwOq8
         M3sxb25LH3wE/xue4msKnrnkKaYzJHFu78Vixucd/EKfnvG2akQSP6RyDo5NFG+KwCQg
         QtQ9aEjNBDNWSKH04DjAbMN5AeIQhqFKCzIXe55PK6klryzW/HboDUhIajoVtLgitCDl
         n/Yw==
X-Gm-Message-State: AOJu0YwIvilav0ChZIoYhj+4W46fZxPtDGJhi+pklgC0F5Q2mJDFJY2/
	mji2yQwX4HlgTFASgAe8WsAk3uHdKFzj7y3rl0F7sA==
X-Google-Smtp-Source: AGHT+IFv1Ps0KGN+3uXX0L5vlmsQqy+WtzDDn/VsgDwBehY5y6fNEdqefWeJzC7fg+gcv+GeSBBp0dzvFA3WkKepQm0=
X-Received: by 2002:a05:6e02:19c5:b0:34f:71b0:e72b with SMTP id
 r5-20020a056e0219c500b0034f71b0e72bmr553193ill.27.1695056322944; Mon, 18 Sep
 2023 09:58:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-3-rananta@google.com>
 <ZQSxgWWZ3YdNgeiC@linux.dev> <CAJHc60ytL7T73wwabD8C2+RkVgN3OQsNuBwdQKz+Qen9b_hq9A@mail.gmail.com>
 <ZQh/H5aMoqpYgVZg@linux.dev>
In-Reply-To: <ZQh/H5aMoqpYgVZg@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 18 Sep 2023 09:58:31 -0700
Message-ID: <CAJHc60wnYYxkav7+Lu3b0iPmyujz-cW-py5Ksg2+098fh5BtVQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 18, 2023 at 9:47=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Sep 18, 2023 at 09:41:02AM -0700, Raghavendra Rao Ananta wrote:
> > On Fri, Sep 15, 2023 at 12:33=E2=80=AFPM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
>
> [...]
>
> > > This would eliminate the possibility of returning ENODEV to userspace
> > > where we shouldn't.
> > >
> > I understand that we'll be breaking the API contract and userspace may
> > have to adapt to this change, but is it not acceptable to document and
> > return ENODEV, since ENODEV may offer more clarity to userspace as to
> > why the ioctl failed? In general, do we never extend the APIs?
>
> Yes, we extend the existing interfaces all the time, but we almost
> always require user opt in for user-visible changes in behavior. Look at
> the way arm64_check_features() is handled -- we hide the 'detailed'
> error and return EINVAL due to UAPI.
>
Got it. Let's return EINVAL then. Thanks!

- Raghavendra
> --
> Thanks,
> Oliver
