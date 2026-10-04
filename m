Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B994756D7
	for <kvmarm@lists.linux.dev>; Sun,  4 Oct 2026 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791136943; cv=pass; b=pji/CV2jic0eD5szp9OTU7cnyPDjlrWoyGv0MK7RPM0mYBQncqlr29E3DljFL+RZkT3bGJKOlfND6xC1Sa7p/SNaBQC4euAIbNtJkySnSF32+FwaCRm0jaL6RymAlqllf9JeXvh7ZHKRiGAOyqCK7EGf63yrRCizo9yDeCOVk9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791136943; c=relaxed/simple;
	bh=xOBOM0qU79KZiyR638ux2NLueBV95WtehhE5D+Z2EOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pzqqdee2JZ1hSmmfReWRVLwsfgLhmXB6n2PFsvfRd4FPabkRNJPDH9nCjUB1XETbSlaiwl3yuxE+akIhk/N2gqcG4edINd/7sTlv+2e6uHiEyFvxB/Rzm/ctKd9epf6seEqGOgXATWzXh4qJnzZi3Evlb2fF5390vzVVb9cHdWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LyrmVM9j; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LyrmVM9j"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5337fa12431so184071cf.1
        for <kvmarm@lists.linux.dev>; Sun, 04 Oct 2026 11:02:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791136935; cv=none;
        d=google.com; s=arc-20260327;
        b=BPkWPErPVxESuvj7IvS9ak9/FuduvtBkVJHztQ7WOOMReRMeUDhcCvMfNWIhd7578U
         X+1spumt6LRgPYYv7P93NpL1SO5jKA6emGD5/DRTf3HJqg3qAylO4khBR83jVat1LDud
         3z4+gra417xC+ItIdWTtrGcKp8g3ExQYhzVth9bl44pcNSBGPsqe9fSQ0mlkmreoQbbB
         J83uzolW9jMT/ZtGuizT8sskElxJ7Mq/7A/DAvkdb7N+pwFaKYrBiUYwONIChH4PTRY0
         flS4XG6ycYFR48V4PxupDFbzuOkM3wUvuzAhGrzzlxITkph3wIGsolon6OBYSwHuRfRl
         jGYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fxl6gThguTjmryCDwAa1VxSTqh72eFueCyhgsTktke8=;
        fh=9mYn3Pie+gdKLtRUKOje1rHe7ixeCVAHVGhRa39EFwE=;
        b=D7R1+FVu5oWflDoJnNKjuV+My9tlSgd76+FgJwn3iY/UFbIIXXCvc/ni0N5aEGXiJt
         DLPtyNx9Q70SIrOrCIkcRuWSLmN8LvVlt8TILJxcrxmmFd2jBvYe20DO1lJ7mlnCszP8
         dhxZkdZL9cSn+soRg80ISTp20Xksvxfugfle9B/hPvdvUFel7+Nw2up8wKh8+F5ldV6j
         UfxhUY5P8Prwr/mnKDruOMyJn9xZpGBbYX6ClQj06iVcTYMFj/xYVabkCqKOSw4G5/r4
         HJBlK2v/8tUwmnLgDLk4lvur+L/1VQSV0DVUpwKGAXNiwClKOsQclWRMMu56zx1viG7+
         PVVw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791136935; x=1791741735; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fxl6gThguTjmryCDwAa1VxSTqh72eFueCyhgsTktke8=;
        b=LyrmVM9jiwcSgscqPCaPRUDd8xVNBEPJK3GlnaYeMcDUO3NMOBPWhdjlR90SrFQ11u
         ArgtbrrTq7NyWVuXBNwFg+NcOfLPrcBQLhAl1Kvi4aUx6ZM2v0BmakBwMBPyM0Uc2U0F
         HLhHM/AV2a7GjrGLFLCyJf12CiF/2WuAbJeK/HGahm/MKy8inMX6IX+A0s3PXisam+a5
         ITLLc4SQwv2D2VWeAmvuuuwHC2n17Hlxkqcd/EEDsNik4mXHm92PMpU8L3G7ni70ogb2
         SSL8K8Noq9Gn1ycyvuYWwwA2p8QawBvYa7Qxf3nxzLSlMkyQNACRN86UKStRfKZqGU+T
         BR9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791136935; x=1791741735;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fxl6gThguTjmryCDwAa1VxSTqh72eFueCyhgsTktke8=;
        b=vK0sHm73mLiXk1E6hz0NepVsT/pHOMLGeVgcNJ5caKFmGlcyOWRFnwC29hXhibNGqW
         iDXmK8rHN+WZeA5J1C8T5L9wC5xUW4rOzmpjofDTi050e1mTVBwYls7DB5V4Mg61tCAm
         BwAA8o32nXdZA825ckbrPSwYI4J42I/oEm21OWq91869IWxzi1XTXawnzWDmtH9pAWzE
         L5xCC/JPPxHM+WsNT6VAaGjwZeLETlzkQiEI0Fv6CF5U+JP8SWYrdbOp0JtnsQFzPckC
         2GKFUbk/IvM9CDERSfN5j4U7R896ap0XWhLBOz6aS5JK4iE62G8IAexLu3WqzdhoXSXX
         Biyg==
X-Forwarded-Encrypted: i=1; AKwUvBxJ+3ATe4cJ9muhCUY6zfa8pWPn2PwRbepuqrqVBTL7+6T2wPUYPxAA40n9KmiOeUqXYvJZHZo=@lists.linux.dev
X-Gm-Message-State: AFuF++n7Pv1yrtCG/tTKirxj3pHwSvhiKvqxywhSTIIAzKNOQxiLlRkM
	HcKU1npEVLTGw5vEZK77PpwAZ8hntNyrZfIYIDohyTmW4NoNJEmh5b7J0BNDf1L55Vstuyynsg+
	J3fl4HK+frjj8La0UgBtEvd2zJXqPKR7IqeeKYRoC
X-Gm-Gg: AYBFou0q5T6L/YH47KTHmIA60OfLfzwwBrSJAk9LXjZFRN04M4rDNWPn10Liagh9rcD
	FYl/jzBaPy4HdAqLuBARA/hAMx4pk+wcNRigCXdOdklcTpPsB4rx0qWq/giBE6ofYfafM8DRoS6
	B0PNy03dllywK1qqdmi/B+eJbRDC70XPI75TQlqunCNPHrSlWUSGGVf+xs3dZEbTIcZQzhna+4W
	LAV8b3s6Nu5axAdEXfNyhUXZsLt9/8LYfo5OCUXuYe+Vuzv4kmd7DnGbo7JSFN8WBTRwueCdaHJ
	LnTFmOml+pEGa0AMMxZsZoTX6VxgQIkEu8lTaLIoxN/s9n+MR204NFyb
X-Received: by 2002:a05:622a:1b20:b0:530:e335:4ef with SMTP id
 d75a77b69052e-535113c3cb6mr18023261cf.2.1791136934142; Sun, 04 Oct 2026
 11:02:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-18-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-18-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 11:02:02 -0700
X-Gm-Features: AclHuK_nOqMX3djeZOdNLjNPymjaWdesvnL51eoG4SJjNhtYox1cB5x1yziRAMs
Message-ID: <CAJuCfpHiaV6uDCfOMmHJ4tPosUBPRMUF9zjrB0fkCWZG1umG5w@mail.gmail.com>
Subject: Re: [PATCH v4 18/38] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 3, 2026 at 6:39=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Currently all drivers which use defio allocate system memory. All of them
> also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocat=
es
> system RAM, so simply failed to set this flag when it ought to.
>
> This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_I=
O
> in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
> erroring out with a kernel warning if not.
>
> The logic requires a page from the driver and since commit 1ecbc7dd2902
> ("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
> always required it to be refcounted, so this was implicitly already the
> case.
>
> Finally this patch sets VM_MIXEDMAP, as the logic is mapping
> kernel-allocated memory so this is appropriate.
>
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

With the same disclaimer as in previous patch,

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  drivers/video/fbdev/core/fb_defio.c | 6 +++---
>  drivers/video/fbdev/ssd1307fb.c     | 2 ++
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/co=
re/fb_defio.c
> index fd00b86e1ae6..fb359ecc3966 100644
> --- a/drivers/video/fbdev/core/fb_defio.c
> +++ b/drivers/video/fbdev/core/fb_defio.c
> @@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *info, struc=
t vm_area_struct *vma)
>  {
>         vma->vm_page_prot =3D pgprot_decrypted(vma->vm_page_prot);
>
> +       if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
> +               return -EINVAL;
>         if (!try_module_get(THIS_MODULE))
>                 return -EINVAL;
>
>         vma->vm_ops =3D &fb_deferred_io_vm_ops;
> -       vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> -       if (!(info->flags & FBINFO_VIRTFB))
> -               vm_flags_set(vma, VM_IO);
> +       vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
>         vma->vm_private_data =3D info->fbdefio_state;
>
>         fb_deferred_io_state_get(info->fbdefio_state); /* released in vma=
->vm_ops->close() */
> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd130=
7fb.c
> index c4fdecafd856..958514a35433 100644
> --- a/drivers/video/fbdev/ssd1307fb.c
> +++ b/drivers/video/fbdev/ssd1307fb.c
> @@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
>         info->fix.smem_start =3D __pa(vmem);
>         info->fix.smem_len =3D vmem_size;
>
> +       info->flags =3D FBINFO_VIRTFB;
> +
>         fb_deferred_io_init(info);
>
>         i2c_set_clientdata(client, info);
>
> --
> 2.55.0
>
