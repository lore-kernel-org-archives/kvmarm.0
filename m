Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60942C1A2
	for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 07:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713166146; cv=none; b=Nmwn7OFpNXWujiHpvMWfPd8qbkrIFsLfIFnI4G/U7AweUKBabxbuzF78E2PuMruh815kZ+GtGwrvWangeyCYxV9FO/a3f0/5nEeuwYMBZ/CgTEG+xEJGrMv/kHkj9Bg26wHSxgFhlqLnRiimNsv+4N/W7hMxwLrIZ1apDKjofX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713166146; c=relaxed/simple;
	bh=du0W4qpqs7iigYAyvC1Db2y4iMsMSpAINvx2wlgvTEM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aVHjgdvXDBSFmIfClSXVV1YEoi6amTwR9c3YxZeZSXEpkCe+JrueoW0jTOk7beJ6zjjBXZIYlTCbvVrka05OQcrR/oHH+p7Zx6UyP5iviBnLWPkDsLUULKiwp/dQKPJDjwCfqP4XQ0IGoYVkSNb4qg3lMYsQa/fESWqwxbBpIU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=kUa/rUt1; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kUa/rUt1"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-518d98b9620so937763e87.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 00:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1713166142; x=1713770942; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=du0W4qpqs7iigYAyvC1Db2y4iMsMSpAINvx2wlgvTEM=;
        b=kUa/rUt1O5qsI8Dn5xZWT08xfcNU+soamjvzTNFGhJi+7nXByyKt1zyqKKuFSA1jZt
         rLOivk+qOKbz4tPWY/RJ03vA4dHh5mEA0V+S427U+80vuBEp3r8dFFBoRNAeekt1APYB
         pfwUiqeY3gnsOPsFAsFp5e4JM2kwSxenyQvkk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713166142; x=1713770942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=du0W4qpqs7iigYAyvC1Db2y4iMsMSpAINvx2wlgvTEM=;
        b=AkSyGRrhvSQcJ/WZgKKiUIpAY8Pi/fFL+rO6Q6q+NtDzLl9Vxx56geuOt6XiBKUrRK
         QeiQyaSWGsPOUKqaQBWE8zJV28LX2VM29VSSsGtPNGj+7LIvobO6m9adg3Mibx2ApVxK
         ri4Bskxz7gKLr4pWzmZXLy95NvjSIdsk1sK0hKjYse6ZIMBxIZxgWWVX8j0gafzGtDoa
         mIxqAvVKw1UF7XcgM9fdA1Q3sbsr6fYfhM2Sq/c2rWYQEWJKfSxiZGqbgCm9rEJMtazd
         LhpDnT2VcuL73R6co2xvDa60lyKvz79mP90c/8HA2IEuFl1+YcXFu+OU5F4JA44TBCsf
         2+Fg==
X-Forwarded-Encrypted: i=1; AJvYcCUSKwwbMVXNTMDnO7TjUjcwZ7bl/wR7mcDDI2xi7PtAZpoxIVRiOysmbCzdszVI9SscYZ4MJ+pAtvE48maiWoPV343osFC2
X-Gm-Message-State: AOJu0YyYESx4VrPOHrkDWrbs7fe0Uv+gaT1MDBp6IKariLv0bi2czAvb
	oKrI8kXbnkPcdi824T2cwaSMFQzjjaDPBC1xjeexzJevm9BGvHvogohRRKvTiBIFsKlHrLVPG7S
	LT9ssPvl9RweRixlrZsFLfvuKj9SbbZQEv81Y
X-Google-Smtp-Source: AGHT+IERO5rG8jweS1bNqQ1EXQ2ssIePQAJ4H8RW/7zN4PAfCchdCg5YM+BZHb/VI06OVCMrIz/XiyTQ8yMwuhxGerw=
X-Received: by 2002:a19:7008:0:b0:513:5a38:f545 with SMTP id
 h8-20020a197008000000b005135a38f545mr5926585lfc.62.1713166141844; Mon, 15 Apr
 2024 00:29:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <20240229025759.1187910-9-stevensd@google.com>
 <15865985-4688-4b7e-9f2d-89803adb8f5b@collabora.com>
In-Reply-To: <15865985-4688-4b7e-9f2d-89803adb8f5b@collabora.com>
From: David Stevens <stevensd@chromium.org>
Date: Mon, 15 Apr 2024 16:28:50 +0900
Message-ID: <CAD=HUj72-0hkmsyGXj4+qiGkT5QZqskkPLbmuQPqjHaZofCbJQ@mail.gmail.com>
Subject: Re: [PATCH v11 8/8] KVM: x86/mmu: Handle non-refcounted pages
To: Dmitry Osipenko <dmitry.osipenko@collabora.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 5, 2024 at 1:03=E2=80=AFAM Dmitry Osipenko
<dmitry.osipenko@collabora.com> wrote:
>
> Hi David,
>
> On 2/29/24 05:57, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> >
> > Handle non-refcounted pages in __kvm_faultin_pfn. This allows the
> > host to map memory into the guest that is backed by non-refcounted
> > struct pages - for example, the tail pages of higher order non-compound
> > pages allocated by the amdgpu driver via ttm_pool_alloc_page.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
>
> This patch has a problem on v6.8 kernel. Pierre-Eric of AMD found that
> Qemu crashes with "kvm bad address" error when booting Ubuntu 23.10 ISO
> with a disabled virtio-gpu and I was able to reproduce it. Pierre-Eric
> said this problem didn't exist with v6.7 kernel and using v10 kvm
> patches. Could you please take a look at this issue?

This failure is due to a minor conflict with:

Fixes: d02c357e5bfa ("KVM: x86/mmu: Retry fault before acquiring
mmu_lock if mapping is changing")

My patch series makes __kvm_faultin_pfn no longer take a reference to
the page associated with the returned pfn. That conflicts with the
call to kvm_release_pfn_clean added to kvm_faultin_pfn, since there is
no longer a reference to release. Replacing that call with
kvm_set_page_accessed fixes the failure.

Sean, is there any path towards getting this series merged, or is it
blocked on cleaning up the issues in KVM code raised by Christoph? I'm
no longer working on the same projects I was when I first started
trying to upstream this code 3-ish years ago, so if there is a
significant amount of work left to upstream this, I need to pass
things on to someone else.

-David
