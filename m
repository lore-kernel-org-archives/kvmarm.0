Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7914418F0
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 07:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790321345; cv=pass; b=L+lL7s+RUlyzKectDroOuBwGzrVGElM0uYTOrt/Dlz6fvAZyS06t6j/p/wjuxieUQ1E55Y+RBj7ugUN1KDigMO3vmNEaz7h8cVQVKrgn53QS7VpYiN4h2bYihyw3/hOkBNqAJxyE75cQeZPhvt60fVdFoLcbJjuNfL1BSjo96Sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790321345; c=relaxed/simple;
	bh=jVgzSGCm8ywlcuZ7qh3DmkhvaTUxolTqjmx7km46hGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=njw8NEhl4LzLTYJpdo9DP2F+/PlbpggkySJQxoTTsG3ySzKrX9J2nOHLG+WvTy+Nbr6Ms8X0h+vMz1gUJsE5Z29uU4QCC3BNDXpCMFfgld7iA3n3SMIxsWjucB/eyw/sQzZQBfa9DVc8jRkJ7SnnQNszBdH/VNpM2yJP38Vwd/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PTgz/VZu; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PTgz/VZu"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-532e9ad9a1eso202541cf.0
        for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 00:29:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790321342; cv=none;
        d=google.com; s=arc-20260327;
        b=Nj2hH51j4ICcKl9jogkkGBVbSQUVYb3noCmNqH4UkVf1LEnUiI6L/K7fULarxMHs4G
         ZQMUXYhxDdGQ6sceSVD2X2UmYjSk2XxqwVNnWgCyHrO4xI3hdr1qljASmBAfhjcE7+x+
         uORi42Gge6vE8getqbPanNMz/9s579/xeYdhJihg+mf7BuKXZPxS6QPB0HJ6DMscWTt+
         4FpKyKk6SprVMPDNtv0ZVtRpSGXUqYiZ5s5e4J8MSoRNbTyK+bUlPJdQQOuol4n5X6AO
         GCCTAcC/vL8Cw2K3aF+xVnUg7oWjVrq10RVXOOBlufyOTOIFXaOYN82W3lIwjNzoV99N
         cTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QKlx39bvD+La1fyAAMePfYRq9L+0k8EzNqVplWKbJoQ=;
        fh=L9EXEsDeST9mOrZnkJVALeMWJi1JoGBXxmTZpIofYSg=;
        b=j0potLgqPi6WAlb/m64tvgXwVJqpbWMf4I2qUMMr7FsZCU1u1RmdsmPawJjipJpM89
         aWDlqTrHVTOZYrErxGqO7ZunUl2chcvK5w8ZEuqoT+jwEWCzcmGYikFPsG0FQtZ0haOf
         5+mQtTXnvgxsoIXq+ml4umvyY33jcAZ+4ArRNJs0tU+licZ0a35Ke6f7O3KUgcVE89A2
         DXzh8ALcGtkSguFdFAS2IVouxvI6VRJGZFWe4Rp3/hZkFR/XCwD5yFkoLXP60Sn4W13/
         Xyf6/beFGw8tDDXperXA9tYz4X27HHtvLPnOEdme/R4A9QhBBmYC0UY8i0C0ggmAlYcB
         6TOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790321342; x=1790926142; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QKlx39bvD+La1fyAAMePfYRq9L+0k8EzNqVplWKbJoQ=;
        b=PTgz/VZuChygQfPZpooUM5GVHNkF02xOEu+zXp3HrbOB2qHTBPvclDfVOq5MC0BMGG
         mZkI6h3UI/PBoS9XQarQ9caLc48yd0qC9/RhUmlp+OIqF/JWJHjeqH1kk6nWrR5DTctV
         OFcq1e/1aV6FjZTxcn01G9o7IrzHsPPWhnWYrxyMKmhrkIa4yBdetdnQ8fg9ubVIg33p
         sYIDtG8G8mJ76kFjVrsE6vYAPJswQoU7355MjXwPErI7FsFU2fNyOGahAFf7zKaJv7Yk
         dbMOFVUSe3nfqXDGXo24SSlzt2cgUpbln389N9R57FxT98r87XDZqdCgdziA3ZinhzhX
         AvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790321342; x=1790926142;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QKlx39bvD+La1fyAAMePfYRq9L+0k8EzNqVplWKbJoQ=;
        b=ePwjac/CCf4u1+/lnXuqu4Paca0rU+/bOqPuqInnP1cwexdhe5pSL4pY228EmuPpyM
         Cj/eFley7WZGhkajM0tHUbieFM5okWHVEA3PMoqu0r3U+CbqRe6kdcG05DGFHFCox9pz
         ib0Pfe9trX3NiO4BHNCv0+TwPhFVUz9qngySaS14pwyJlr+LQzX2R6+NbV2zbu359p6T
         BxcxmbiYJULrMHvnhPiuhRDYLpEDsnJjn8zEt5EL8tUDgebSkM5ubyW64/JwEqi6flQF
         Jqf/m+a4uKk0HNYFOeBG7iCh72aJ5X4QMqL49NtYoWJkVxL1Hr6iWG7+TvQqeSx2IS9Q
         ofYQ==
X-Forwarded-Encrypted: i=1; AKwUvByemlWAWQepy8Pnxs09nOjEbKkY7gd1To4x7CTRq1aCtSM024YcEYsy1TjR1wC/UIZ/B98KPWY=@lists.linux.dev
X-Gm-Message-State: AFuF++kyjRMY9flSVIQB3Svt/pVrfsyOmUFKSvcrCdvUOLPFYZZdl3p8
	FPFl6VSbo0KWuxhWG1gNM0RkYdMh10nxPcrjsTJUuYHcfP+SaEoZhpeMWeDreqh94v8O0cMi/cd
	YMDrLM15FBMRo5Ar5vFYDEAhcQKbcdLv6hfbezs4Y
X-Gm-Gg: AYBFou2gz28qYsgNHOrlHg+SmyZaLhewxJkVeUifoZay93YRqu063oDdPw+Rc0hf9ZU
	lxldGqLrYdm39+8ZN/GKX+QSPCzogpNFveSCDBVjPwaTRxkpXvjCqEfHz3wOJwGyBYZmqfr/ybx
	APXEbZNhMJWNqRA3fBA+5i19H7KnRoK2qctg98lNB8LfFXu1iG8uoU0su12PBnmLH681xN0lXZH
	KvX4m+NNiCKVJ0G3+9wyO6/L2mGK32jRIzuRClhD2q6yV05EJbbD1y9h4KZJqWvvsoroXDhs1li
	HMRR7o5YJCt47Z18bu0T3yzx2pudC9WHH1AVE/n4FHWcNXJ4FEPnoQ==
X-Received: by 2002:a05:622a:4c15:b0:531:d8:e437 with SMTP id
 d75a77b69052e-5330e1083a8mr8850471cf.7.1790321341004; Fri, 25 Sep 2026
 00:29:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 25 Sep 2026 00:28:49 -0700
X-Gm-Features: AclHuK8wpU_boMBtoQ2BxSfl48UrjTg974xy2tCF5bv_vM_I_Kq5OyVf7aIl6LM
Message-ID: <CAJuCfpF2U9rgHmhaDoXX1hxsuuS=s-oWK9Nk19TDQ6CLpjhFVA@mail.gmail.com>
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
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

On Thu, Sep 17, 2026 at 9:25=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> When a user requests an mmap_action be performed in mmap_prepare, this
> involves populating the VMA range with data.
>
> However, if the VMA is mergeable, it might then mistakenly be merged with
> another VMA without having populated the range.
>
> Every mmap action currently available sets VMA flags such that the VMA
> cannot be merged.
>
> However, to ensure that no future mmap action falls foul of this, assert
> that this is the case upon mmap_prepare validation.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/vma.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index d6ed10cefc8f..62f2ce1ad5a1 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start,=
 unsigned long prev_end,
>  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
>                           const struct vm_area_desc *desc)
>  {
> +       /*
> +        * It is not valid to execute mmap actions for VMAs which can be =
merged,
> +        * as any such merge would leave portions of the mapping incorrec=
tly
> +        * unmapped.
> +        */
> +       if (vma_flags_can_merge(&desc->vma_flags) &&
> +           WARN_ON_ONCE(desc->action.type !=3D MMAP_NOTHING))

Any reason you chose this "if (A && WARN_ON_ONCE(B))" pattern instead
of a simpler "if (WARN_ON_ONCE(A && B))"? Unless there are races
between A and B updates, I think these would be equivalent, right?

> +               return -EINVAL;
> +
>         return mmap_validate(prev_desc->start, prev_desc->end,
>                              desc->start, desc->end,
>                              &prev_desc->vma_flags, &desc->vma_flags);
>
> --
> 2.55.0
>
