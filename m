Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E38BA26
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 07:16:39 +0000 (UTC)
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2b703cbfaf5so98972681fa.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 00:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689750997; x=1692342997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqjGnkydjRYo2dESqfO3eXpJEsuUSuu3liWybMYNxjM=;
        b=gX7b5UN9DkeHJXYwujSe1mjmePWQplvCvP44U3BFMNFhyjzTNc5cPL0b0FlYXl4Hcq
         jxN76VnlMs/9ozWflSmx+8DKY2OPbWWT7ADykcn5N3+7vzltbgVCMSrmganHSQMB0To9
         M8iQKIij7Ois9wkxeKl3uimcVDRE1EU2yCMg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689750997; x=1692342997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqjGnkydjRYo2dESqfO3eXpJEsuUSuu3liWybMYNxjM=;
        b=OFlz9B6qUYZOcIkZngkQgG9cFJSw5dGoujpYkVrj96O2ur/PxBt2sIy2YRlB+ZuvVs
         VYxwWdqhbE+L4b7dglIdqggajFQ/zOtw/xCQmLKt5hJgLC9sBus0wjlpqFHpab0gV4cR
         WuGo2sLeOshXU9in4qu6BotHmLAr0c8OYPZn4Bh4LJNT5tLA802Xnb77FlPQ0sBP79JO
         UOPhqhe6ZROFtBrlxsVgmQap7l0db6dHnrH9WevQ0Htu8BEQGsB0h6XYriIsTyPUKJKs
         hBY30grl7LgwnqpI+ekXd+p46SlBYm8U94r+V/VjaOdOREs3fsg+qClGOh+xGawZEmbx
         gQfQ==
X-Gm-Message-State: ABy/qLbuNCbgzbWAvtKFhbuuDl8PHId8RyPrOCSTFhXf9kFjPxHA9Xwu
	NmpYeD46l1WYVME6BX0Vg8/xhHM4/cWWOytoTE2g0A==
X-Google-Smtp-Source: APBJJlFqhwQMdurqFqZbJF6PVLk2bfOiT9p8qJTEaQQQ3Jq/BQQ5+E1DH8yM8SRT8kMqvgYsDBHQZ/8q8j2PVmM/Edg=
X-Received: by 2002:a2e:b164:0:b0:2b7:1c0f:f221 with SMTP id
 a4-20020a2eb164000000b002b71c0ff221mr1255715ljm.39.1689750997071; Wed, 19 Jul
 2023 00:16:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <ZLd9/V6EAxSwEAzY@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZLd9/V6EAxSwEAzY@yzhao56-desk.sh.intel.com>
From: David Stevens <stevensd@chromium.org>
Date: Wed, 19 Jul 2023 16:16:26 +0900
Message-ID: <CAD=HUj58w8O_XnpOSr_+VH8-evcn+y7ReWPZ-96QesXF4mUybw@mail.gmail.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 19, 2023 at 3:35=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > @@ -4451,7 +4461,8 @@ static int direct_page_fault(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fault
> >
> >  out_unlock:
> >       write_unlock(&vcpu->kvm->mmu_lock);
> > -     kvm_release_pfn_clean(fault->pfn);
> > +     if (fault->is_refcounted_page)
> > +             kvm_set_page_accessed(pfn_to_page(fault->pfn));
> For a refcounted page, as now KVM puts its ref early in kvm_faultin_pfn()=
,
> should this kvm_set_page_accessed() be placed before unlocking mmu_lock?
>
> Otherwise, if the user unmaps a region (which triggers kvm_unmap_gfn_rang=
e()
> with mmu_lock holding for write), and release the page, and if the two
> steps happen after checking page_count() in kvm_set_page_accessed() and
> before mark_page_accessed(), the latter function may mark accessed to a p=
age
> that is released or does not belong to current process.
>
> Is it true?

Yes, good catch. During some testing last week, I actually found this
bug thanks to the WARN_ON the first patch in this series added to
kvm_is_ad_tracked_page. I'll fix it in the next revision, after Sean
gets a chance to comment on the series.

Thanks,
David
