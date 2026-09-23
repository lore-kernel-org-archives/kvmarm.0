Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F505172F9
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790179798; cv=pass; b=R68XEOYpJa2UrMD08A73LcJXy8hOS1SFpJeOXsRxy6GC9oD6WN7Uudb2c6zXyrtHL3PuPgOzHzmO3028LfkRQd2OYVVNOMef/GNGnDUE6rezc2K8oSokBZQQmesiIcCsrZf8jiB4hYR1us2LG9xz2BHp5twkKESRcRrvra2xvLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790179798; c=relaxed/simple;
	bh=LIPPg22fa+TonvxEf6vmQam+ZQ7bHd3Sz9GxpyKknbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ogihJ+zpZGBurmT8qe0Zeqfb9deA6oNUyUtfKWF4mbR/u/plXtF+sfT1Q6SqbEv6fAfpQat64BmFQ39w7YA1cdQCs24KeMGTu71n2uutXiIYl/ulUdYnSlAwaTUwd1NWsW+LoS5zmRtzwEHyBajBkttCEyJhUxr/4kVbum8Iu5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t2NzvoLb; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t2NzvoLb"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-530e8c6fb80so271331cf.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 09:09:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790179793; cv=none;
        d=google.com; s=arc-20260327;
        b=VXeMO0vaj6gsikfGsWwG01wW2AgiVRiaRrsEHVROOj+TAk9palJkbTKjXpZdSAyzIY
         XNAw7FYG8KI9ZThDzEfKAbPWZNTmupFBIK87PpgH8ZDKUTT10Y+MJPyCqG6XbgJ/S2C8
         dU4uOf4bTa3DnAhhi2HJYr3CHq8TKYYuBUDdgHg4sdasunzjm601VvlMilLTV2QK+M/6
         QAwN6BllDQEAI2pFw0ucmb5aOoZjUkcu3yZQusqo2uwUJ0iUxh760RTAcB2KqMP4lyJ2
         Rl9YPBfCD5HQWQwXj/JOHLcZCj8O2yRZCvNEZ6KvD1HhRvDc9Iu66dWGEQg8NUyNO9Qj
         1v5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HHWyBmRaGzTNumsbsfRRD90WYZuPVsFs3XssqLSLFrU=;
        fh=yx/pG43sR6P0uB3maswhN/n6LDR1gznNO0/XQd0DWwU=;
        b=VwtF2V7v5S9lurpHv15EfBgoKs7jVu2RabNZy+eNfFvSqtAJvC1go909jZqdHwbcyh
         Citd8FD/f/Cd/ODUosfhW9hxEBI1xdOQFMk5uzigRA6WGPCldk2RX40qg4hbdSSxv2VZ
         I/e2D8DVrMv61JiiTcdb/Y4eFXFlS0d/VD2spAH31Q2Mr7+e6GpbGBXFIKymwAQwg9eC
         NLiTszd8EFZcRgrE0GHv45c2gskiJiP36jVM5uI3u96SpWZCdyADyCsONvw4B5XDGWCl
         wOXp/dy+Lu2hOKQd96vX33OnbgGKxXjt1Ew2xeIYJ2TLCeNK0E27vFoGMdPUhCtpbCd4
         Wj/w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790179793; x=1790784593; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HHWyBmRaGzTNumsbsfRRD90WYZuPVsFs3XssqLSLFrU=;
        b=t2NzvoLbq4FYUI9LmITxHmBgMc6oIbR05aEwKIz73G0ZWWQh8PRn8N1U1D5FFdY01R
         ZjY2srDnQEckGF1GaKMEtGIQr3+p0eIo961UFkQEkccZf2OBKzRxSPYPIa4I7afVfZ9i
         1XMt+MAviN5dTMqIOxAX/0Z8Crm4kXQfcZ6KdKs+shesw+bjpxgBAW17Co7Iumv0pjVd
         Wa+CKhlu6/BgiXz1Z1mgHbECxjTACgRudhCRGqsDtVqulBM1B8yifrr4TlMRWECBAqdZ
         4GnY0sQu5woCUYyx7RejpmQsPZWP8CtIm3UPf0sZQx7+K9jDop0i/RUgCINcLVkSOyO7
         u5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790179793; x=1790784593;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HHWyBmRaGzTNumsbsfRRD90WYZuPVsFs3XssqLSLFrU=;
        b=QyBS6jDVZjr3PqnwkeLkl92crqEV8vS/6TyYxWlZYbL4NgQ3Cr1OpxvZePDbZcXksl
         N17DXOLriT8AhiWg+P9HYHJBsZOG7wQ5zHeByIZzS2a/JWT5MEeaNaJUcs8T2dH/EQrH
         qky0u0C/Rjx4t5nZwqmg3qYO1bbfRlVT9bx1jUXbQCqjM9+bzTL1hXMOdJkzHOMCHO2U
         WZGzl5fwSqnI02cv0TlF44IqwxcndVjDr8wemlrgMWGTJGDBn1Hd9KkyXVogkZi8Mw4k
         uT0FJvIvzNmA8lT8qWKyfumpWZXnYT7o01GW6G8gRVKMpvz17O3PN5UHv6IoBYNzW5rP
         fbgw==
X-Forwarded-Encrypted: i=1; AKwUvBzpJKFHJFwnM19oo3Uko60SOXiVFq/Tw7lvJESpHFTGXrIc93hsumx78Y7Stm3bm9GmM88lx3s=@lists.linux.dev
X-Gm-Message-State: AFuF++lBC7ZriwDu3aEXt+3Kv2Z8lD6lFR1Qd3LgU7NuiqOwiamK2e8W
	6pSCKQsXswC69QZz7TdonULCSkma/AT3NaYuPbv2exQxAuY+HyMUOEzXVJUylp7hKRJ5VL7DLvo
	iXFrTAqj3T+nRESqow2jaWBBUajAnuuI04P7rJHNK
X-Gm-Gg: AYBFou39oT5xW0iHxIJh5RFUExEyg8aGR3zm9Z0aqHP+YZoYbOZ1kpZDFh7AZx/gmTT
	IGB+2w3WKEzAEkGtM95tZ08T3EQDlEwKbi66K2sFlHYqMzQTM0r5s1VpMng77y6FUGXrRxUhL7p
	+lKcT7AtfH4D843RgrPzb6NA0s5az+S1ONtHpCmfD/j99n09T/wuazJ8PjmnI+Imov1wvx3jNV3
	ARH5I/AcrAuATfBbWQRYH1Njy/DFz90WLYQK5hfNi7tljhc7cUw/wac91ElpdEBWIVYaNPAMDX9
	xjiXtbJXGDCUSC7ZqIwGkrj7EOQ6ogK4ASbnMMhxHtjG7+Qy+fUCMz/Ugm8EcvqLiJDsgWfCkhx
	NpZ5qLPKxs54=
X-Received: by 2002:a05:622a:591b:b0:52f:8389:29e0 with SMTP id
 d75a77b69052e-532f8b3b7d0mr1642301cf.0.1790179791981; Wed, 23 Sep 2026
 09:09:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
 <CAJuCfpEa8tUmYJBjx-cRdAE8y-jcKY0C81kAOa1QZS7F6tKdfQ@mail.gmail.com> <arP0oJgrgZlgtrb6@gremlin>
In-Reply-To: <arP0oJgrgZlgtrb6@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 09:09:38 -0700
X-Gm-Features: AclHuK-pjLwt7GcAJrmXZc-kWYiEiXZ02rewi0rtPA2ju4vBD2OPEsiN1JlMpG0
Message-ID: <CAJuCfpFPPGaK-grNx9qiQOhzAXbxU+SO+95Fht1571TGREx2oQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
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
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
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

On Wed, Sep 23, 2026 at 8:54=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Wed, Sep 23, 2026 at 08:32:43AM -0700, Suren Baghdasaryan wrote:
> > On Thu, Sep 17, 2026 at 9:24=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> > >
> > > It only makes sense to manipulate VMA fields if we allocated a new VM=
A,
> > > rather than merged it.
> > >
> > > VMA merging does not compare vm_ops or vm_private_data, so a merged V=
MA
> > > keeps its own, which is also what the legacy f_op->mmap path does sin=
ce it
> > > never touches an existing VMA. Previously set_vma_user_defined_fields=
()
> > > overwrote the merged VMA's fields with those set for the new mapping.=
 In
> > > practice these are the same values, with rare exceptions such as shme=
m
> > > selecting vm_ops based on whether the file has been unlinked, so no
> > > user-visible change is expected.
> > >
> > > Make this dependency explicit, and additionally constify have_mmap_pr=
epare
> > > while we're here.
> >
> > The fact that we might be overriding attributes of an existing VMA
> > that we merged with is technically a bug even if we never hit it,
> > right? If so, should we have:
> >
> > Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
>
> It's not a bug, it is an in-built assumption that the state used to asses=
s
> mergeability implies the same properties.

Hmm. What prevents two VMAs with different vm_private_data members to
be merged? IIUC is_mergeable_vma() does not check vm_private_data. In
such a case set_vma_user_defined_fields() would override
vm_private_data of an existing VMA, no?

>
> And if it was, it'd need fixing a different way (check the field for inst=
ance)
> and would apply to the legacy mmap hook also.
>
> This change is needed for the series though.
>
> >
> > >
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks!
>
> >
> > > ---
> > >  mm/vma.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index fa784f069da4..4b74b48c29b7 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -2894,7 +2894,7 @@ static unsigned long __mmap_region(struct file =
*file, unsigned long addr,
> > >  {
> > >         struct mm_struct *mm =3D current->mm;
> > >         struct vm_area_struct *vma =3D NULL;
> > > -       bool have_mmap_prepare =3D file && file->f_op->mmap_prepare;
> > > +       const bool have_mmap_prepare =3D file && file->f_op->mmap_pre=
pare;
> > >         VMA_ITERATOR(vmi, mm, addr);
> > >         const pgoff_t anon_pgoff =3D addr >> PAGE_SHIFT;
> > >         MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_f=
lags, file);
> > > @@ -2937,7 +2937,7 @@ static unsigned long __mmap_region(struct file =
*file, unsigned long addr,
> > >                 allocated_new =3D true;
> > >         }
> > >
> > > -       if (have_mmap_prepare && !map_is_anon(&map))
> > > +       if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
> > >                 set_vma_user_defined_fields(vma, &map);
> > >
> > >         __mmap_complete(&map, vma);
> > >
> > > --
> > > 2.55.0
> > >
>
> --
> Cheers, Lorenzo
