Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9258A480DF5
	for <kvmarm@lists.linux.dev>; Sun,  4 Oct 2026 18:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791138265; cv=pass; b=gpeXmAfGrsprRjeCQaZnQw3yVaMizvUsQqC0Z8y00ma5qaF247268iw0SfJCDoobLA3xdMGOz17SrWo8yDWY+OKw1sDi8xLjmuoJUZ570ZBUgNH+D2AxBeX1TvpCi4fPTDgLjoV/9rg0JtduzPxa3or85GtwQ1k4T9E37ChqGms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791138265; c=relaxed/simple;
	bh=3aBRZG0J7nrNd8eWZI+tOUTLRCjKVPsGyHM+wAKTgfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hZGJt29VtRu3+IbZjx1g+Hi+h+4eAwv2uGhoiPYYLNNl1q6ZWhMJbYx9LNqpwE4JUTUvGh8Qz9xV5ji13lbR4bQ2FsY/4MM6T4sGqkq5y+xJK5yyY061xxEFEb3CAd0Y61NjlAM+d7WjITAZl5xf+cek4oUxOLXtfsdX9ktpKzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vHESjkf+; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vHESjkf+"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6aae147ef9dso7800a12.0
        for <kvmarm@lists.linux.dev>; Sun, 04 Oct 2026 11:24:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791138260; cv=none;
        d=google.com; s=arc-20260327;
        b=pamSKyPG7JY46o/zvnX08Pnm/O/9MIaaatbO5zLX3io5vVqdnNztRunzTHpl5uX+oB
         eMse8eWaxdyIKT4JsT5z2fU2CJ27AslPgXGVGIJXeFO+4yQORpXzb7eadz9hwE5NanB2
         7eS0eBBDbbGz4U0dSUd/lyPg/2qgeQQEg4xz/fQFFMJKpm9bI5Z4f4LGErEg+18Ehuch
         mF6XZQEGcEnQGqoFDL6I2LfUoQTZaoxIc1+/C3rJAIxzotdLcrdhScqlmwpoHxX9QKEe
         HdgvJGqzm7XzMM+7OGE0e71v4r23RcZDDrKH4B5+3VYivaptZ2FDn1FpI3WhRV/Cl0rH
         s9DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
        fh=WyJaywTL8kjd1TGlBeGfrQUEptG1fHJR6uJvF4w9Fbc=;
        b=GmMg8gLyjxF4xg9STkVr8FDrMpQrdfXHLgxYdRDV+GabJu6nm0XL/ZPvxU9g/piq/e
         oyAwD5XYstvLv93MSYQmq4R0ar1Dr0dK7fu7EX+zVwHCF9B/2R3459zymY3d5Ssvxzgn
         tC9knwiU8Jg1+E6AOefyPjZYeR7eD7E8QiONnAYAfwIZSproouxgXD2NE27DEG/pUaTT
         oUFXVZQwmHkXJVJ5vxiqJ3CFqSz9eyGq9g82Ldfl34XXgs+vWQ61S04SkyEwTCYoaFXi
         6S7pO3ATup5VhvUuJ/fG0bgNB8gkAik7kKCRAQ850anFQpm9V3RU/bRFzdxTquKM76nn
         sxog==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791138260; x=1791743060; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
        b=vHESjkf+Tq+uTR20HFjrwl+CvuZljnQY2KVK0TZe/acJG+868sAoOM0BGPzq9d6QlD
         FdxuwiNJxGIPMUCtFwbwxxBqRE+rwXZG7AFaRqgQcud2HqtrQKXQK1TvdnO81WK8fhI6
         s+0o5npZac6dQaxKScWAoI83kZYr+ytEj3dXvOfONb1toSHKJXHM7zCydnJNoMtqnTRg
         Hdjgv0kCctyUg5LgfZyBBcy/vtIsrMFVb3VY/BsWQiXy1AUrAsvIBRA2DzaOLhx5QK5b
         fIwBQ3VoYglPGtYdVjjDxOSQRXoPIIkosaBstwbnOhC/9E3zdHdIO2DxBvEJ7r3HXoks
         tzpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791138260; x=1791743060;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
        b=fwKxIy5vcoBpHsdMvQBf+r8sDipoUATdqNfWnGDSo2kIuRiBcDzr/3SnByD7GSRrrg
         Y53+D/Z96cte8ri/2wcxgy9AaiKGpA0tJEmR2zrHT10Y2iL2HOthgbGGDD856l8WbG+D
         /R4PzlEYV+ZVo4Qyhuw1uhP6j4X006atibWyKzRe2gur0anSZMx1RoL0nG3ScdXwujXs
         CrA0+pJf9wM1ojjqmSHfyF/r0d7V9gHS2X8ph1eLLtT05ZcPZn/iyE/0gUPXLgEvxLG6
         zCyQ313zWKOcLifAhEwELMmQ5OrYjqfj2V/MlHtSF2JvVqLZlFtc4gwlhfdWRwEkdfr8
         yuDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzYyhCNXyCxMSatiCrORrhikYvpcMJ9zg5oTGrURrZLdYXHEIkGDBow3LRNHoWjdDL5sWcUPyU=@lists.linux.dev
X-Gm-Message-State: AFq9FYJYwaedavHd+ppFphBPio8eyjd/ew1F7T0si8o6PFZsm1Z8wRYF
	tBGtZhN6Mz8W7CuYSp6gAjK45Pd8Jx4JwJY3BiZ0rUqVWaony3kHeeUk1Vlw+wvQq0z1HY8VuF2
	04XZ7MrmDRM+Kiv2ff3Qt0wHN+LytpmXRi2QWfi2S
X-Gm-Gg: AYBFou2z7uLMYKT8HEKVxBLc4yhlYazPc2rSfZGy3dCN55Oj8WWOnW5RwVJcnXQZHdy
	DkNjz64CmDMHoZIa4fWcoqS/WumUCAt4wDJYZVc7LmykDtATE6+v2NpEgb9ozwDotVxVpxeAUoZ
	GLaWevVUFcB/+ZY3FECE9bo/LMGTAOf9mNHr2rPXfGCNl28/i6MlOSu009Mj0yYJQvbppv8nKFO
	PrbTrJV2bN2nhGx/YvJ0hJshqiYG3vgynn1h5CEasAzVg88hndW3hhrNqIZCia7cpMA33/OUjly
	Lw0aEhP8LfSitz/f++GFXpaG1zxcxWkn1ixHHS2vE/zcaT6kJ5e4hlxJadPO+eYBxM0=
X-Received: by 2002:a05:6402:a2cb:10b0:6af:7a5a:97e4 with SMTP id
 4fb4d7f45d1cf-6afaf6bf03amr34523a12.12.1791138257648; Sun, 04 Oct 2026
 11:24:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 11:24:03 -0700
X-Gm-Features: AclHuK9H1gPgFkK4n-5s4Gd8NQjwfuvbGlNRYoPrM6gC5ICSAC1H3Sf5qTdT1bA
Message-ID: <CAJuCfpHOo8UhAZMvO5A3dKbqxQGAWtKGMHXJ+Fc=qwH=Nm0b6w@mail.gmail.com>
Subject: Re: [PATCH v4 20/38] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
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

On Sat, Oct 3, 2026 at 6:40=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> When populating a VMA range via the aptly named populate_vma_page_range()
> an unreadable VMA will always eventually fail with -EFAULT.
>
> That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is no=
t.
>
> All user mappings always have VMA_MAYREAD_BIT set, so this check only
> impacts kernel mappings.
>
> It is implemented specifically to disallow population of uprobes XOL
> mappings which are exec-only.
>
> A nasty interaction with these mappings may occur if they are mlocked, so
> actively disallow this early.
>
> This allows a subsequent commit to remove the VM_IO check in
> __mm_populate() which otherwise requires non-MMIO mappings to be wrongly
> flagged simply as a workaround.
>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/gup.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index c2dfcb4744bc..e6310a7cc05b 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_area_struct=
 *vma,
>         if (!vma_is_accessible(vma))
>                 return -EFAULT;
>
> +       /* Unreadable VMAs also cannot be faulted in. */
> +       if (!vma_test(vma, VMA_MAYREAD_BIT))
> +               return -EFAULT;
> +
>         gup_flags =3D FOLL_TOUCH;
>         /*
>          * We want to touch writable mappings with a write fault in order
>
> --
> 2.55.0
>
