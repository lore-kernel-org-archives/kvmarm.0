Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3023905E6
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 23:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789427842; cv=pass; b=m3P7pIRFmW3KkvJQgK2AvzZ6oowoW+tSQAgiPF2TAcZiVV/SlcOyddMRQVgofMqo9RhpAaJyWlBtP8yGUM3EpGycnLs13kZGRhKhOYfF5fb2vKKu3zvz0IskVK0AiUFJUYU8EMnV30PB0ltL1rafk91d75ZB8SoAjq/C/ZealpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789427842; c=relaxed/simple;
	bh=RZ7AYDpwif8OjK59BGFRZwWIVN2HIHDHT/0jIXTGwRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j0uWeYRvr4Kwlvqwj2WrmJhB0jojhSGBZWk8pAPSxckwHRZdT2pWbQN8u0fa0uiPqLxhI0HmNaHg+kAZFOlQdY5ZXE9cj8jIxtDH1vWSOSXaoB5ETymK8B/lg3ZJkRK0jrwr3Cn5bZZIk6KX0gucMvuB94D4pjAHcFyKujhViCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com; spf=pass smtp.mailfrom=etsalapatis.com; dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b=iMn+nkmx; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b="iMn+nkmx"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-67124ad72e4so3938825d50.3
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 16:17:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789427839; cv=none;
        d=google.com; s=arc-20260327;
        b=ru1/s46BIcdgUEumVhhtOHlSKsqRaW93btb6fvxv7BpeCx+kBLVHKG680y7rg47LIo
         nPPv6jK80RP+7kvizZn+LQwEfG811zRzml0MjwJe/zaOGFJBLjd/DFCOTu+3zGZt1uOP
         x6VAQjeGVvJO9NF9Hd3toqUEradyuepqsH4AJmzove0aGw5uoyzMymodK4D8iyo6P7Gt
         gMe5gMgR0awEhkpFJkEFVjJ+oN31sYRpnNLCH2WcJ56T2oWjKB19X22Xs6DKBMxzhH0N
         kpxyQY0JwKlceEh0fAKqAkd3MtGiyM6sBsrjB1YsG1DhakcLFfctHlGzk9yC2JSX/g9F
         pJdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rPKM73fBOFsSjy59aqqxc7UWTKxXfj0ZC9NrA+w1XGc=;
        fh=D3fytWJCu0oY/8kpf/mI5EjLcCefZKALr0GumgZamFU=;
        b=pwk4bGdRW2HclKcytQZFSoPTFebenat/Hwfbr8mJwKJy10E0//4EBoQDxnVnzZ0+lD
         p7d0E5FVetxycD19pAWY9bPJBFsleaDgAV4saHB8QCmmSj8mioc7MsjStJ0ixjrQZE8i
         MMBQUEhBaAQLp/QNnAF3hz5LPjYoY4G1LCobucQtGtjY5CwGJ3Vm6gzNJOjFS74fn9+M
         rcvODOQBcDH6UczNILUATAtf5ojvVNj98gwz9oR/Zdqx7cOFF2FrA38Ph7z3GOr36+IO
         Xr8ZXsk3Ll3fD1sFSEaYdp7XhgEDGvAl7AoCmG1Ht0hs0OmDsL8mDEWONqZvoZpW2YSX
         l1sA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1789427839; x=1790032639; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rPKM73fBOFsSjy59aqqxc7UWTKxXfj0ZC9NrA+w1XGc=;
        b=iMn+nkmxP24mcAxti8fPMQT4x2+RXfTdr+n6NCGkiWFsHMtZZu8YlNIabTzncy4vxV
         FTYUJpkS5+N69FnnLJ7tGEiJPlvsaBYGvTZ2UGGWN5CiC0+6aXZyR+8UnOfAJikl+ew/
         MR0mvI+IbmS8iC6bmGrfrCHhVLPwdsZRRXY02d6WnPRknD4X7Ulf/IdbwonZnqI6CZ2I
         pOMaSikvnNNMlHnGG2h6Ctxd/EcwUIigNUPahDSY547fAjdaIZXbOMobhZGwZJU197RI
         VF8MZyaEHHLvfXHP4mkj02p/u2HYvTVdRMuY5djeI6CiL7qCDMDludVnL+ynW9H6IfS6
         GSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789427839; x=1790032639;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rPKM73fBOFsSjy59aqqxc7UWTKxXfj0ZC9NrA+w1XGc=;
        b=PRyumUNYqjCuIRd8/1ETEadpUg+x+GLzYZ+uYbZhXZq+1ujO8ceMMLKTZBNlsHitYs
         DL1Ku0qNCGO0TVD9n0357+UaG3XhZIWwDrh4vZb7uw59z/TqON7IvaYPBG2CWI+6GibI
         dchg4mk17iUI/gk+hHNjAMQjFdO1JJaTNLYuoxhQJzxMzPmjwQ5F5SYgFECuhZCjl28x
         EA9aDBLWb7uafbxizCkUjp9CinWINSeJburZIMilpf4nGWHwNcG+bXdElJd2OmUHN4YX
         qevgrCxkc8A2lM0H+By32mTce5HAkSLX1TZiNEDT74fB/+vDyqrEjBcaFqz6utWJAdCx
         X4xQ==
X-Forwarded-Encrypted: i=1; AKwUvBzwDk8rhjwGHkn64wVVtUnPiBbou++GCvXXW6l995QGrqEoRiMosV8m85TshJ6eLD6bjZ/4/Mo=@lists.linux.dev
X-Gm-Message-State: AFuF++msWWNHtaEWPNA6wBLUQCyplm3kyQvbCpyfwxsWLkcpxbZgdbrE
	+W9YS2G7FLfedZ2CRaOXTjH7H6oxp1sK9fAdnymuANGop2+fmj4f1VbNW1EZNvnglluCAeXXsDO
	YdjGxmwKof1eKuh7tI6CZkekHHCXAG+1FnAx85fm+jQ==
X-Gm-Gg: AYBFou3y1nAQkPLPfHbGyXxJDB/Wg3TSBPUw93LSX/yFEH6XykAiKdpj0Q4rB5i18/1
	lBiBDv36KIluj26lZ/bz6C2lTdTqAr3NTai+Wh3IhCil3ldunRuwIvIBbuSwxA9csDh2zXtPR7F
	Pv0Gf4JBYkDyWW4DMHUmTMyOvCAdR1vJSU8BMAs2E1OW1meTMZ7dt1u+qy0k/SPPpQh3MrFxdmB
	yAyJI1F+84sQhBpqMqVynPvKImZtTuCXCIXdLuyK6i9HneDOWbX0tcrwvCobW8ZdTx9PSc6WCvA
	ieaXx47GEszRROGElPRU5J48RvUNLWhZfPeNXg9Q+aQ5HmAXgtxwieE=
X-Received: by 2002:a05:690e:d0a:b0:671:2382:d57b with SMTP id
 956f58d0204a3-6714e00a7efmr1347187d50.44.1789427834988; Mon, 14 Sep 2026
 16:17:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-14-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-14-7d9781ed5361@kernel.org>
From: Emil Tsalapatis <linux-lists@etsalapatis.com>
Date: Mon, 14 Sep 2026 23:17:04 +0000
X-Gm-Features: AcwNN1UnQs5y9ap_T4Dsaa6llmYZN4_govFYy7UyV78s5E1rt3VhMagl8qfkC_o
Message-ID: <CABFh=a7Sa0zMKssts1TVZ+u_x3roWcYVSmJF34K-W++oHEsbEA@mail.gmail.com>
Subject: Re: [PATCH v2 14/40] bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Paul Moore <paul@paul-moore.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-arch@vger.kernel.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 3:21=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set =
to
> one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
> or arena_map_mmap().
>
> It is convention in mm to mark mappings whose pages the kernel manages
> itself with VM_MIXEDMAP, so the core mm knows not to treat them as ordina=
ry
> page cache or anonymous memory.
>
> The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user(=
)
> use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and =
so
> marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
> explicitly.
>
> However, the exception to this is arena_map_mmap(), which doesn't set the
> flag.
>
> This patch corrects this and updates the comment to reflect it.
>
> The pages are refcounted and vm_normal_page() finds them regardless of th=
e
> flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
> thus unmergeable). The one effect is that NUMA balancing now skips these
> VMAs, as it already does for the other bpf map mappings, which is the
> reason array_map_mmap() gives for setting the flag.
>
> The intent of this patch is to be able to establish the invariant that on=
ly
> PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
> in bpf_map_mmap().
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

Dropped some CC's as Gmail is refusing to retain them in the response.

>  kernel/bpf/arena.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 7b6847200b43..b69fe5e34339 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct=
 vm_area_struct *vma)
>          * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
>          * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
>          * being copied into the child process on fork.
> +        * This is a kernel page so set VM_MIXEDMAP.
>          */
> -       vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
> +       vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
>         vma->vm_ops =3D &arena_vm_ops;
>         return 0;
>  }
>
> --
> 2.55.0
>
>
