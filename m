Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0124D49B1F2
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 19:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789415866; cv=pass; b=bEGwWRfCK+0gmDt50cR8QKhvai9goh3PB/iDfrjrTvmbFmKiNM3lMJIm9LNfOgr3ZkB0AS2Zvgwn4NPX+0w3xxxqFm/smL5dAzQz7y+C9T5jVHDYWBgR7japlAsWqMFokVckkFK23SIHdzA50K8DqTo2fmdi4/mg2MWVZzZK0y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789415866; c=relaxed/simple;
	bh=rm+zdLu0LlzNfMP/vZrBYvi966p9ISS8d4XEb3JQ094=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qJYxE+CeJ/lrnN9LmoH5JGuzOC6USakewcpubd5Sba+34NAcirxEHkiVWrOwrzH6CRE5A0uwidDQ2pOXZYTxOxZaJ7rwsYlXBGpOEo56n2xsdro2lO/0advitG/wedT8wQKEBV/DG1heAngk9JUJv4+63Ssqkth4lekC7lanDso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=dAOCiPxl; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="dAOCiPxl"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469e25187so1854645b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 12:57:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789415862; cv=none;
        d=google.com; s=arc-20260327;
        b=MMC0lnXdKGT61/2NhsE0WTyY8tR1urmFYPpii5yDsHKP16dSvrcyyUOhog2DemFrJN
         grQCbU/3yybgDjfi2LydzUVvrm+TfaUSsBRdrDK2n3hDSSxTal4fU5IvsXJ/gVzxK1vW
         xYMHBOZnriDnuAlCDk0LkvpWzWCeIP1fa6pzirYJOWRohXA5413YABwNMakXv7BFTcrU
         3ljQntin/4ou4Acaf6PR5dBZ/57zLH3SUpdYUe8bRBz8R7vc1z+IZUYTdOtYvu20ZXNv
         F9bkKdtp/WCGZhnZ68g3Dlr6GCherA9o/r6bkkk3ggyJ7yF/iA05PqSSXcEmZjq7BWk6
         BPDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
        fh=5Zv/tlKjqJ/afkTD0hwsiFGQ3WfTFWSzjJldqLG7iUQ=;
        b=Bf0jayBRY5mHOWvNJzWLSWd7fXu0osQOM2GtkH22lbN9fjoicAoo8FeDHynX1LkeqU
         T7JE0xAM1DM4kQyRZUtoPLWXZmB6LpYNX+o+Ai5qM7p1Ydx0DHpKmkqVmjNOkYwmDYHD
         evzEJI6KjjT2PrfcTmcSSGFP+liFuqltsc9X6HG1M1MS//m77xH12RAW9o6O82GaUxvs
         kxagSnHRVb6P3pzV2sQ04TtRdtz+4fy9s+buFpiRoDtcLiKzk1aFD6VIiGGua/nJ2Ufx
         ROmV+1OCgqHu7KpHI1OBCLphJiirHcvMqHywemzmuGV8sQoNV2qw5eGspZegU3HeAk48
         H8sA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1789415862; x=1790020662; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
        b=dAOCiPxlOXx5TExOke4JVOmNQHVNiM4cNMNDkF5KkX3sss7Y3VaSPJtqBzBS7sijne
         78FWJD8IdbZX1u6v7nty2UPI6gxqLAD5kzMn4wZPyG/4IUVbjX378n5IA6EqzAc0Msr/
         E/hAWxf3vkwya2K/gFjdiH3bWogW/GZYqAK3tqzN2UehaYKaw1N3WXktCumLJ/3uNn4w
         SWDFTz59ZASRuWwuB4cYai4LhlfK1LwcJz4YQVX32WQm2z8mwgDbK4c4Viwt7EgD3CdX
         n4IB9WxDC4vjt0HRRhp/aM6DOlR3hf9ooGhsBsswi2YjjTS34yZUaYCe+iChfSEGXOXm
         42Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789415862; x=1790020662;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
        b=EssttKwUlehNTm/aQYl+UKib1wRMeQnC5EwQf+EjNj5hPfRPpbgMJGyphIXTrdj0u+
         fEdaX6D/SAfNEDTrvHiCZfASCZ0Yh4TgbeVaBpQS7Qp9W2KZHqGFghrbEAkmmGd0J7tz
         nEQ8TJ5QS6OOWdxu1Dlkuq7R88i8gYeu9JM1inpCHvQRdcjMkJWxwq7iI4ziwgkfSnSW
         akvYCfZPMs6YvXhuLUhsVB312hBZdQmlBo90PS3Cc4CQLxCJO1Sn+HV+39UWABEZy9nf
         6wF5UZUuCFVuNNSyOFEOByMNsoavrqG+6NLRGDAiEh0y95HtI/GlV1U45qfcOBdh+Kl/
         ZuGA==
X-Forwarded-Encrypted: i=1; AKwUvBzpQ8bgL88sEPBYPvR8vD6k9iLCXFnNnJzv1Yx1K81KEWnIoaorb5K7IMk+krq86AOzmMO1ngw=@lists.linux.dev
X-Gm-Message-State: AFuF++mua6heEoNmBR8qmJYSbIYt/Q7qctVXC/ZTCCKppxBGOI19AA7l
	xP0y0dztHP3duGP3kjnBK6jqwtmZwPsK7mVOCZbSo0eRvePYrdLwvS96crBPySp3rUmrzfU5G+7
	qNzLuKyynT5W2mvcveS6FOmhS/ofYfri3tcfmTwxx
X-Gm-Gg: AYBFou19MT1ddOK3WyuA4/er02a517VLhr+xVTC2mg2HBmGnLj5yTQr9VZyDneyNURI
	43+KOb/qTAyQQQMnge9IaOX5T7uXCIr1MlYLSal2EYpgfnzYffsaPueBzXzyvSJnA9sZHeA/FGd
	fxk3dOGFSgD5cFpid5bhBt6njxkgc/KqqdQkIQlObraaXYXJZEkcZvqOJBD+GPwZPCXmQLPBPf1
	xs6BYraYhIgIlgBW/yCvzUL8XjgkKplrXu0i3qSgMwM8PsfzSXP/tEvwJ+FsdRfbPgsomtZL1aU
	U8Oow8oQ0ps3iH54fcLPSjkMGSzOkzYKyNjMCv9xlI6q7GKvmNluNdBMj+vpYZV1cwleKvPeJI3
	ZZdHqNMQ6KsA=
X-Received: by 2002:a05:6a00:18a9:b0:858:b809:6ec0 with SMTP id
 d2e1a72fcca58-86f869a920dmr8896742b3a.23.1789415862342; Mon, 14 Sep 2026
 12:57:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-12-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-12-7d9781ed5361@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 14 Sep 2026 15:57:29 -0400
X-Gm-Features: AcwNN1XaLRK0KaZAmfcRvdaBSkZOdh14LF1fb-xWULoFVhBfqyRklsdKoWBmLag
Message-ID: <CAHC9VhQ3TwdGGH6YtVyMqJX4avJwsadcRvRhAoUhCvJEHk=i=g@mail.gmail.com>
Subject: Re: [PATCH v2 12/40] selinux: reject writable opens of policy file,
 drop mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
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

On Mon, Sep 14, 2026 at 11:05=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, a=
s
> kernfs does.
>
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARE=
D
> check in sel_mmap_policy() cannot be reached. Remove it.
>
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  security/selinux/selinuxfs.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
