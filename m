Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AC1450C0
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 02:31:34 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-50307acd445so3838987e87.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 19:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1695090692; x=1695695492; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5MbU8VIeu5EiJtwca5r7fWgQWeL6jFIFNv2pIv6XV0=;
        b=eg+7eJDxIMJr0BIncZhR0Wq5Iik57ZS6R5AumLGgeAZrkOXVJ4cgeOVvMJ28KPTLnh
         5gnVuOgw26AU1zGQSX8C55Oj1VqnrvOmWhDbo4Nz2uBPmNIv7yzGsAaT2L0A6i/3NRtq
         E6V4L/lPayo7TtBclBBcqA+vh8gJxJR+mh5/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695090692; x=1695695492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N5MbU8VIeu5EiJtwca5r7fWgQWeL6jFIFNv2pIv6XV0=;
        b=MoJ6V6XLSHYU90amqVMjISdEVKBXqikoHTi4bXWP2RrKXC5mbQOuuYAserRhX6z1pD
         Vw8z7Eh32DLr5z+AJYt07sc1GwKuVnscG7ASd6Dl0rsBbornMO5QIu0dxMgi+aY9+hbp
         QEe0ud2VAmOgBmkBHs5sDFlE3AdG63EvHvxCuxiyuHad4bBOOd7l2q9YyUVQZPhFzByk
         NEXnhXs47WVTtvBa34HsHWSBBw/xGymXL8EyJR6V2fOOGhKPRROXAoLpQi5/PePbYkFO
         urW+yp9jo8Bl37A/lSLmE3STIQYFyfg2WlnVasSmTPwwFM6a3o+KiorXExnjGJXLP2PB
         8wqg==
X-Gm-Message-State: AOJu0YwpSbtu3B4+RdZ/sQNVYxl/kwWl40DPFxGXuCGL6NStJ50giEif
	0nQdtnxl/aytrU3akmiDvvGaMeICWWyQU/7WhPcy/g==
X-Google-Smtp-Source: AGHT+IGYCxBFEzEjTAyANkyZd9lS1pK+lX+uxDNz+TczYIgHSjG072fjvVdeIR+bF5iEyMR0OJrOGNhi1XswkfAyyYI=
X-Received: by 2002:a05:6512:1319:b0:503:2deb:bbc1 with SMTP id
 x25-20020a056512131900b005032debbbc1mr839997lfu.22.1695090691893; Mon, 18 Sep
 2023 19:31:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-7-stevensd@google.com>
 <14db8c0b-77de-34ec-c847-d7360025a571@collabora.com>
In-Reply-To: <14db8c0b-77de-34ec-c847-d7360025a571@collabora.com>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 19 Sep 2023 11:31:20 +0900
Message-ID: <CAD=HUj62vdy9CmqHWsAQi4S6i1ZH8uUE81p8Wu67pQd5vNRr+w@mail.gmail.com>
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
To: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: Sean Christopherson <seanjc@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 18, 2023 at 6:58=E2=80=AFPM Dmitry Osipenko
<dmitry.osipenko@collabora.com> wrote:
>
> On 9/11/23 05:16, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> >
> > Handle non-refcounted pages in __kvm_faultin_pfn. This allows the host
> > to map memory into the guest that is backed by non-refcounted struct
> > pages - for example, the tail pages of higher order non-compound pages
> > allocated by the amdgpu driver via ttm_pool_alloc_page.
> >
> > The bulk of this change is tracking the is_refcounted_page flag so that
> > non-refcounted pages don't trigger page_count() =3D=3D 0 warnings. This=
 is
> > done by storing the flag in an unused bit in the sptes. There are no
> > bits available in PAE SPTEs, so non-refcounted pages can only be handle=
d
> > on TDP and x86-64.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          | 52 +++++++++++++++++++++++----------
> >  arch/x86/kvm/mmu/mmu_internal.h |  1 +
> >  arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++--
> >  arch/x86/kvm/mmu/spte.c         |  4 ++-
> >  arch/x86/kvm/mmu/spte.h         | 12 +++++++-
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++------
> >  include/linux/kvm_host.h        |  3 ++
> >  virt/kvm/kvm_main.c             |  6 ++--
> >  8 files changed, 76 insertions(+), 32 deletions(-)
>
> Could you please tell which kernel tree you used for the base of this
> series? This patch #6 doesn't apply cleanly to stable/mainline/next/kvm
>
> error: sha1 information is lacking or useless (arch/x86/kvm/mmu/mmu.c).
> error: could not build fake ancestor

This series is based on the kvm next branch (i.e.
https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dnext). The
specific hash is d011151616e73de20c139580b73fa4c7042bd861.

-David
