Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3921119E
	for <kvmarm@lists.linux.dev>; Wed, 13 Mar 2024 04:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710305734; cv=none; b=C94gOme+RNddh+IGiX/8wV40czu70UE5aaKxN4YoyEOIReS32imO927GPZk74cK51pgoJDmwvLKRChJh6lg4thYSVO+Ldja4zr5BmMUsOr43waQedG/rO3cuJHJwKtPPMyVMtPXXy2/F2neg6jHJyVsPqIFofSm/qpY8U0y5zrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710305734; c=relaxed/simple;
	bh=RTWz8EpSDEWKJM3TEtQ8z2nh961615KfzXWZv+DoDH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KqeATIHEls1GsehGbaosdQWhvg/01Loe4Du2iBq2OwrJg3fCSuzvneWb+T3AX37tcyrM1dUGabOdbbr/M+yf8XIxHpU3xVtHPAJEKDayuSqMrgG3pF8/hk5P8616KDnLxlE2nxGn764a38RgO/cZs3DwwnKHG6m4zBX5wFRQtVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=kMPI7108; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kMPI7108"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-513b16bb739so2365371e87.3
        for <kvmarm@lists.linux.dev>; Tue, 12 Mar 2024 21:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1710305731; x=1710910531; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTWz8EpSDEWKJM3TEtQ8z2nh961615KfzXWZv+DoDH8=;
        b=kMPI7108QMi0NasO2PMsSSqzmf+eQXL9unEr87o2KgMUuWx5oMi3QLDYXTB2QMU3Cs
         vIutn0FVtUEeeS9YG9yPXsU6aHeDKTarS8S7j4fCb7ShpAqoO4t721zIu0arY9IkJj2y
         q8yg/dV4RKBPqt+5AN4rUpqZiWVMkoxZxGacg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710305731; x=1710910531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RTWz8EpSDEWKJM3TEtQ8z2nh961615KfzXWZv+DoDH8=;
        b=uLSE3n0LE2caKgL2GWx3a8ezKPn6OL6y+eZ4Zyvo7FTkt8rNnw3X/4lHivUoUB/GWH
         h7irm3GrBOssTregs6kIBQ8f9cYg2+RjpWtDkRWWk+F8Go8OXtiANqKFFSC0zX52p3AG
         TZDg5F3/YLNTqs6CDw0IX/Ry15KItgQUG9xSeqv4AwmlHPLeXpMnjr3K8nqyxnn6Y1Vs
         kbH45PPSg00tJQ4FVCRoVoZgBNBxwAjyGfu2rArWMh6Ng0ykO7qnTCv9ymG6NyVL1Udv
         k8m46eVd0SKg4x/4Iegtz2ZOGCvc9M33AnsE/gMO1fVq9Ig2FzW2SYtKNKndnwq69mZ8
         Dnhw==
X-Forwarded-Encrypted: i=1; AJvYcCVeNtQi0+nXQOtIJnwPuyKYaAE/tCFUnSYIYAvLgnPNuXs1/LaD3ChuEVDja5Ar7qmhvEoUWSKsGi420WcjqBMd/TEmi9aB
X-Gm-Message-State: AOJu0YzzA6cDvlB2CsYXpkn4Lq65xMnO4PZwL5Ecw9NIxLR9PDEBEeFw
	lpwNosIFq5U2aLZHXlucCSHduckm4mS26xYt8XUWaw7RYknvODwuopMgy7+tkRqDH1EIXd8b47k
	OVku41mqo4fWH/ANGg2Aw3duAatMwagAUTBev
X-Google-Smtp-Source: AGHT+IFnrqxk91ihDavcZ15Yamg0oeFHaSxOKuxqRQfg8amMGoR83ZIRGkueW8eCFqCm+gR78/kxhDbJgQE9zn7EngE=
X-Received: by 2002:a05:6512:556:b0:513:c1e6:3c55 with SMTP id
 h22-20020a056512055600b00513c1e63c55mr1925135lfl.69.1710305731589; Tue, 12
 Mar 2024 21:55:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZeCIX5Aw5s1L0YEh@infradead.org>
In-Reply-To: <ZeCIX5Aw5s1L0YEh@infradead.org>
From: David Stevens <stevensd@chromium.org>
Date: Wed, 13 Mar 2024 13:55:20 +0900
Message-ID: <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Koenig <christian.koenig@amd.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 10:36=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Thu, Feb 29, 2024 at 11:57:51AM +0900, David Stevens wrote:
> > Our use case is virtio-gpu blob resources [1], which directly map host
> > graphics buffers into the guest as "vram" for the virtio-gpu device.
> > This feature currently does not work on systems using the amdgpu driver=
,
> > as that driver allocates non-compound higher order pages via
> > ttm_pool_alloc_page().
>
> .. and just as last time around that is still the problem that needs
> to be fixed instead of creating a monster like this to map
> non-refcounted pages.
>

Patches to amdgpu to have been NAKed [1] with the justification that
using non-refcounted pages is working as intended and KVM is in the
wrong for wanting to take references to pages mapped with VM_PFNMAP
[2].

The existence of the VM_PFNMAP implies that the existence of
non-refcounted pages is working as designed. We can argue about
whether or not VM_PFNMAP should exist, but until VM_PFNMAP is removed,
KVM should be able to handle it. Also note that this is not adding a
new source of non-refcounted pages, so it doesn't make removing
non-refcounted pages more difficult, if the kernel does decide to go
in that direction.

-David

[1] https://lore.kernel.org/lkml/8230a356-be38-f228-4a8e-95124e8e8db6@amd.c=
om/
[2] https://lore.kernel.org/lkml/594f1013-b925-3c75-be61-2d649f5ca54e@amd.c=
om/
