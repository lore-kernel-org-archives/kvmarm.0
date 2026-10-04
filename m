Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C5E4718F2
	for <kvmarm@lists.linux.dev>; Sun,  4 Oct 2026 17:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791135814; cv=pass; b=QQaC5HBGLwSgyWcjuqD7zL/TtcHlb6CWYIyh3Cf1eFPrf5WTTKnrDX+qctT+GG6AvTGlGB3HSYewouZaa2SJpUy1X7OhcGT/65BlR3A04daaqQMUam4YiGC08N9Gi+gg4hNP5JS/SOsXn4s4J5ZcBNzzMJeidP4DGPYjhfdqQpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791135814; c=relaxed/simple;
	bh=kLTbSagc0N48D5iLz2IHv2jwZa7qPxl4pR47fwwH0D8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WKlgw9QSnCng01agqh76crPE5YeSwag+WO6l/+jWwbZpYPxTNoeqQ1UsvCVksJamOXDGrnfh981XT2aWQNHYkdNL7Gwee+HpCjKx8UVBTNXGbqkc06zFoif/ZnljEkLoxk6uuDZNF6kloi+ErlmiZNYBrS8EEULnNovj/UCK/kM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a6/JxSB1; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a6/JxSB1"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5351f9dbfe0so95891cf.1
        for <kvmarm@lists.linux.dev>; Sun, 04 Oct 2026 10:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791135811; cv=none;
        d=google.com; s=arc-20260327;
        b=dEOSBCklul8Lf2WgJIow6BfKx9kMm8U7UZjnTKG6ItdHUuv8Xq/RzR1E8nywMMWg7G
         bnshbDByZqNZnKDvRmMlOuyrsQ6odapamH4w+NVhaJavPrcHh+/3Jj4mOrzYwhwAvAEG
         gsXwQ2PT9qy4MSuA6CqJLAA3yPWeRw2BOZbMkRZg+bHi3RY0akcRBqOljWoQZVgZ9QCc
         GcoUoIIe0Zs5UDCoZxf4dtuD2aKRua5U450hOeBlfgZQWPJ4EOHYJEAj+JBcZuyA6PIt
         t1NFDn8TSrNCOA7bs88If5960w3+cSyfWo9jYF0/QJoFNNEq5tatrpM3wbqskdmir1gO
         7I7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
        fh=0njX1boTTbWSdzAAmnEuhrFB0l2x3hd33+QiOvulysQ=;
        b=pBAlpbN0492QkLLmnJGUBDYy4k6laWPPZBMA6F+BXrDCC0Hg5fMOp7OWa7SBF/jqyf
         lHuiRBntlkvj72lnFtEABmeygCNN6RYI8uQu2bQVLhKwMOhWQIImHpfLa9bqVm4CV6BX
         LrGHNtJyoaq+OxvG1VMqtRDF0jf+0j+Pvh7jPS/fb6ugTFiZwwRQGNsEooIfUaR84qJP
         Qq5O5JBq8n5Ebmz5/PYnp41qrTvdptCTQr6qVYzMX79iLCAfMaziLkEjGHYY7QXXf7a2
         Ur+wrzsy5LDL5se1teV9WJm7SGqiyN5h02Nbn6YaFYO7xgYPWHGOK9EsyiATZofJndtx
         bSZw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791135811; x=1791740611; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
        b=a6/JxSB1ba0+ZaFtTKmvL3TnJFlrKuTAzvBWiYWnqWrEA67v8qSLEO6NbECZOua1l9
         PdPLiU9Mj+BHCQFuVX+H8QimtHQvKzaF6pae8CKMCtO87ifVwSa5+8Il+cDq1a8WYoOC
         XIUtV3HHMiA9SxSCEQ6D3M7AiRNeLsPTr9S5ol4u+RQVPNm/cm5OUUuf/hddawQ9ZE0U
         HBxVjXDx3ScRlWXXpvhcDdzO+eqQZdPCTyHs42dXoZFPIYtBXZ/vw3OBR+1okQV6zbVM
         C5N6ops25TzMW/bNkNit4qNDt558XKEzqo67XGgKSlB5DuiShzEY/UvJU+S6ygN7mB/N
         FcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791135811; x=1791740611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
        b=IOumB+T3Q8qTTCwiMEWpWF0XKEIPdMdcqG48rU2UTOt9zy/6BDWkvTNGWw99gzAx9k
         WFH2koxZ2GRSXF0HSBNGjs6ppMAse4W5wnwibYNXct1/Y3frTDE4LD5vVeZxYWZBKAFn
         7oEwvRqM0CEg783EHuWYgZ+isnCAae3duiol+NYzr/fvN+DcnslvbL93tntldmPELDNH
         nupgLkpfvMGwLenizpXEs4PNixHL34rCP4m7xWQa/hghQyx0F7AGIdPr9qnWMe2e4fJv
         Pej4xfJ3hZrCAH7KlV2R19Wdo/TbnuhMu4RBmbyzMAaQwyotX62zmMl7ZYw+7aCVsNYh
         G6gA==
X-Forwarded-Encrypted: i=1; AKwUvBwcaG3xrDLyDMGkrMN5K/sENKyn1sgtZfX/WVwBb1LXu5OMwSzfM17GNsbmzzuoViZ86N1I0Fk=@lists.linux.dev
X-Gm-Message-State: AFuF++nLBO271gMa/77emX7Wer/Z9XarkrAF1F8gxC0EMvm8Fte/gMOE
	dtxAYRXhM93LNGF9YNMnBRI/QB/eV8VZZ1KfQptJz1Cbzh4glUVnIL3wKLDaDqAMRcNw3Kh6ffq
	jQGOT91hGHm5qV9fjZ8ZVChFq1yTs2nIFMQQnrK9B
X-Gm-Gg: AYBFou2civcjTWyqWCyaUHXQ4XI7giN9a06pqb3IPZjSXYlgc/DWgUBYdloZsDjkuQ4
	g8fTRA2zYAEDojgH+y3Lnen6efh7QUzi+kdBfiEXxSe6aW2+iIcCdo9Tns/xAmCmNVGBOPS0oDR
	EcAEIXu3miuHavz50h5YzQONixrjPr5h91Z2Q2uulgle1L3hVteBsmaDOAJtFGirgVkuv7bMXkf
	GPekWITwDb0Wv3bIKicZSHpocspnHI8lDKRIDtnGXok5olw+b8clJt3JQnJ6Zr7QGg8sfn0ImdU
	uBbE/pAEyGNBRUC+SHn7+L3SneIPIveqUL/Dm7H3/6ZFy05BMrPIo62A
X-Received: by 2002:a05:622a:5c09:b0:532:eff8:3491 with SMTP id
 d75a77b69052e-5351497bae9mr16844861cf.14.1791135809929; Sun, 04 Oct 2026
 10:43:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:43:17 -0700
X-Gm-Features: AclHuK-Z2ieyqrFQLh5f1D20FCqfsVRqEWMyJIzhNXdOxd9iUhJDwyyLAY8lrcs
Message-ID: <CAJuCfpFounkD97p9iJ8zUunAMoOv+h8Tnxf2NOkp7qs3cfqs7w@mail.gmail.com>
Subject: Re: [PATCH v4 14/38] mm/vma: add vma[_flags]_is_mm_managed() predicates
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

On Sat, Oct 3, 2026 at 6:38=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what absence of the VMA_PFNMAP_BIT an=
d
> VMA_MIXEDMAP_BIT flags means, and then refer to that function for
> determining VMA mergeability.
>
> If neither of these flags are set, that means the contents of the mapping
> are managed by core mm.
>
> Otherwise they are instead owned by some other kernel component, usually =
a
> driver: the memory may be MMIO, kernel-allocated pages or even ordinary
> pages the driver maps itself, but core mm must not populate, reclaim,
> migrate, copy-on-write or merge the range itself.
>
> We initially also treat VMA_IO_BIT as implying a mapping is not mm-manage=
d,
> as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
> on ordinary VMAs while locking them, which is addressed later in this
> series.)
>
> However the intent is to in future remove this, as no mapping should be
> marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
>
> This forms the basis of further work intended to improve how we express V=
MA
> properties such as this.
>
> Also update the VMA userland tests to reflect the change.
>
> No functional change intended.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  include/linux/mm.h              | 53 +++++++++++++++++++++++++++++++++++=
+++++-
>  tools/testing/vma/include/dup.h | 29 +++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 97e1eb4fe3a4..83953757735a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1612,6 +1612,41 @@ static inline bool vma_is_shared_maywrite(const st=
ruct vm_area_struct *vma)
>         return is_shared_maywrite(&vma->flags);
>  }
>
> +/**
> + * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that =
the
> + * contents of the VMA are managed by core mm?
> + * @flags: The VMA flags to test.
> + *
> + * Such a mapping is one established by a simple mmap() or brk() with no=
 driver
> + * or other kernel component involved.
> + *
> + * They are rmappable, and core mm services rmap operations including re=
claim,
> + * as well as population, CoW and merge/split (if eligible).
> + *
> + * Mappings which fail this test are those where this is not the case -
> + * e.g. MMIO, user-mapped kernel pages, udmabuf (pfnmap shmem), etc.
> + *
> + * Returns: true if the flags indicate an mm-managed mapping.
> + */
> +static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
> +{
> +       return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BI=
T,
> +                                  VMA_IO_BIT);
> +}
> +
> +/**
> + * vma_is_mm_managed() - Are the contents of @vma managed by core mm?
> + * @vma: The VMA to test.
> + *
> + * See vma_flags_is_mm_managed() for a description of this property.
> + *
> + * Returns: true if the VMA is mm-managed.
> + */
> +static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
> +{
> +       return vma_flags_is_mm_managed(&vma->flags);
> +}
> +
>  /**
>   * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to =
be
>   * merged with another?
> @@ -1620,7 +1655,23 @@ static inline bool vma_is_shared_maywrite(const st=
ruct vm_area_struct *vma)
>   */
>  static inline bool vma_flags_can_merge(const vma_flags_t *flags)
>  {
> -       return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
> +       /*
> +        * VMA merging assumes that a VMA's flags and fields completely d=
escribe
> +        * its state.
> +        *
> +        * However, mappings which are not mm-managed may have establishe=
d state
> +        * upon mapping not embodied in any attribute of the VMA.
> +        *
> +        * Additionally, private (CoW) PFN maps encode the source PFN of =
the
> +        * range in vma->vm_pgoff, which may otherwise cause spurious mer=
ges.
> +        */
> +       if (!vma_flags_is_mm_managed(flags))
> +               return false;
> +       /* VMA explicitly marked as being unmergeable. */
> +       if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
> +               return false;
> +
> +       return true;
>  }
>
>  /**
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index a6a8e53c4b38..89c645a6ad60 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1665,7 +1665,34 @@ static inline bool file_is_dev_zero(const struct f=
ile *file)
>         return file && file->f_op =3D=3D &zero_fops;
>  }
>
> +static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
> +{
> +       return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BI=
T,
> +                                  VMA_IO_BIT);
> +}
> +
> +static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
> +{
> +       return vma_flags_is_mm_managed(&vma->flags);
> +}
> +
>  static inline bool vma_flags_can_merge(const vma_flags_t *flags)
>  {
> -       return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
> +       /*
> +        * VMA merging assumes that a VMA's flags and fields completely d=
escribe
> +        * its state.
> +        *
> +        * However, mappings which are not mm-managed may have establishe=
d state
> +        * upon mapping not embodied in any attribute of the VMA.
> +        *
> +        * Additionally, private (CoW) PFN maps encode the source PFN of =
the
> +        * range in vma->vm_pgoff, which may otherwise cause spurious mer=
ges.
> +        */
> +       if (!vma_flags_is_mm_managed(flags))
> +               return false;
> +       /* VMA explicitly marked as being unmergeable. */
> +       if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
> +               return false;
> +
> +       return true;
>  }
>
> --
> 2.55.0
>
