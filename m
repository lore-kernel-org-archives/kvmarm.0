Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1725A44E678
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 07:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790321753; cv=pass; b=B2ekPh5r+3BILS+1Gk4WVzGlTB96O8Te7p/nB5U2q0eb458XbOlJBXutdxbEq2VjmTQpSAe1EYe9/28I8YvYQ4ZljR8LoWlwX/94aFh8BCWfZ3qalCpcfpDZQNF+UeLwmZiMUmhni2dfg13/1ut0X2fm27cFeXr5F2OH/L3pZfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790321753; c=relaxed/simple;
	bh=QleRDPze6Fay9Y/d+9oXHJ/g/hcfyRz6rdp7ap/qQ+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iOrFhfLKK8x406YoPQmPKjbuU2AdoyjrIiMtwqgFm2/lweadAKYxEzxBClUCdxactywo4Sq526y1f/AWlGjwb9a3T5h5YNWNB6ooR7z7zjt0Fpl1XLPl+2+fmBYJg8y7OZUEhynXC3+IuWGS4i7s2E/z2aKQzxQGhPMYCDkilzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aBYtBpfC; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aBYtBpfC"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6aa13d8d9d0so7218a12.0
        for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 00:35:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790321747; cv=none;
        d=google.com; s=arc-20260327;
        b=nF2DiFqVu2q3UpqfGyQWy6B0EP8w+EZLH2By3C8707HFMO5ajXzIjdq16S83TbiHA+
         e82pOOtgmApYE7Hr4p1agCK4vkOdLvHUJpvrj77wD5/FfLZmd5dm/RAOkVeXXzZq/gzr
         eb/+uOe2E8Ze1wwETA6rfeFXXKvfNc2GDKzyIClOx6FwSP2bLvxx2TvdHYlPVadB2zUp
         H42mV0EIUWuhyLoEaAnKoaYZZJJz46p2m0+bfmnnTCTtZis99w2IYDhWESzW2mBva5nh
         Zhzsexp96kAcU/pQAfZSjs+L6B2uo9C0R8gshi0PI2q0GCFX737zwInQGBzxvfgiJlaM
         fqtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TiarA2FI5/GYv9nr9lV3Ck7oSnVRWS2NuO02/gM+R5Q=;
        fh=irZ813SstaDrIsFny3N+cMafFbLXxo0OUXxZo3DZIuQ=;
        b=REAGzRhSczeWZP8XUsW8HosMFBXfd8nBEe3zFc4XAzs6QxaNp2ImXTEf9tAGRG2zKJ
         kigVhY9kgTfX1oZ1DFEkdocUj02xl3bSg7U05CStMQWv5qDHB6mzjBIU8OS2Gtr4BT79
         +l7K8zYZo0IFqDOL+ROHJxp+Jp6RijSIuZQix0QsjhosdIChXxcRkIXPzw8E2j4QSju/
         3vcCbJhiV0mNEaWukKUUnfgz7tFmKRcY7Q9rurFAX4ajZWHXUwAqr5ElX59HIgz5wx0q
         QqRvyQdRKmPcjYKOZZE87phy9851wilaxXBXYJP5sO/Ur8iA0P+7JqixhVYlBLtI4n+F
         LLrw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790321747; x=1790926547; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TiarA2FI5/GYv9nr9lV3Ck7oSnVRWS2NuO02/gM+R5Q=;
        b=aBYtBpfCu8SQvZHGvaUp07oukWjmNiuMyTzcgCmGrCBGtVTPfMVvpr+xk3qdsSbU7y
         5sl/d+NugHldHhJ+AnRkqE+EzqRqvWDGHPZeR2hw5rzkTRiVJsvryR/zcvfBPSRN1hRS
         /K6+mOygBqvZoRh8KtuJYZfMqx4abIRYfJTaUiYueZ5wNyx6KVK5lmgjgIvDm/bNW3u+
         l0Ce9J31oypA+3FO6NFWZNCyKil/5X5u2zH/4FNYdsT2YPokE72XMpyDuB2+wPZNfGl0
         tgaN/wX2S1HcFhrom6ONJo5jPKIRwsNR/dhMo/M6FqZUOTboCdMnseT2kyMxcUYZY7sA
         aHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790321747; x=1790926547;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TiarA2FI5/GYv9nr9lV3Ck7oSnVRWS2NuO02/gM+R5Q=;
        b=UOSfXfWJ8ZeHZZbLblRocVNs4B6F/TNnSovurWqlyD4/U369KEmcbZExHd2wJjGEoW
         KPJX4NQ+j1a9K7FFXPbQN6kL11oN3dsWr4W366e1gQMf5YUvgb7fDMfnH5zQXAFM3IL/
         zq2bQ32LFqwloX1CBi/i4LdfsEQvv0IbjuwlZZYe3Tzw1fJYq7KDHpF+D/GuUW95VXvG
         qowjnYQGTrfodwxnBb04kUsnHi32mNtvAU3GOU9/X583476+506ydHBX+jLlIS9Nig+Z
         TSFK2JqMaSn7cqEcbjoDKC/S3+PJPMegmxD+fSbTbOBj0axKE+yAJXNfuWmEMqj5Kd/x
         nuGQ==
X-Forwarded-Encrypted: i=1; AKwUvBxl+fl+CndaFYXEIKdnsyBRLUr3wkPnI90mywI5E50WjTIPlC9BomWiMbEbLd76qH/cgTRrXWw=@lists.linux.dev
X-Gm-Message-State: AFuF++k//0bCKGaoRp2vOmvHvmJdnWyYYBaSpetvF9dcSQ5g3oKN0Hx8
	hZsoWZP5iWNgw98HV6zZWNEw+Cq5NHyYpRCretB6dLfnp5SM6NhSt9xdw7vW1zWLln0gy08RBQP
	S1UKHZ5xfE0UlkP4YTCml33QuqBjCz4AVWtErbxjy
X-Gm-Gg: AYBFou3JA/pAQsrfUO1xk6Y08NFYzoJAkFNiax6qbRaXMNTHdHb/9vuCUl7x+cyEqY5
	XpvpH9wBSAfD1e+eAinv513stRcTPJ84SfGs1jwllRgdcWO7gHwF+YscWufsziiUN7VaIVr4rTi
	SfhqoRbF/WpSIYAqhuG+Xy7V5YjbhVDf08kQegCTvFcgbvc6gDiJT2KC8I8iPpQzC38P6/PGdas
	tr6Z/xlKjCg4BinwhfV3/Ex6X0HPku2LNu+epyfG4oVZqapJU8busURUYG+GwTSTNeK2n0OmNEH
	5qzyhj7NneSoJP+imnrQ6DO46Y71IV3MRHyelNwzIWPVeSJc9Abe3x6N1CO2fBe9
X-Received: by 2002:aa7:c64c:0:b0:6aa:e332:b762 with SMTP id
 4fb4d7f45d1cf-6aae49c58f0mr23500a12.8.1790321746110; Fri, 25 Sep 2026
 00:35:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org> <DLNSNQP7L4FM.1JZQ0GS9300H9@nvidia.com>
In-Reply-To: <DLNSNQP7L4FM.1JZQ0GS9300H9@nvidia.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 25 Sep 2026 00:35:33 -0700
X-Gm-Features: AclHuK_NuiQlFRW78Nf23QbG4E3oej6nx-ZjiAb0IRRSHloLT2xGmv-6NXWsN8E
Message-ID: <CAJuCfpHpo58c6eOPY_CvP+ts2zwXQEDNX2bohXd0CBANYWrBWQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, 
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

On Thu, Sep 24, 2026 at 12:30=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > There's no reason to export the symbols for these functions which are o=
nly
> > called from internal mm logic, additionally there's no reason for them =
to
> > be declared in mm.h.
> >
> > This patch therefore removes the exports and moves the declarations to
> > mm/internal.h.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h | 3 ---
> >  mm/internal.h      | 3 +++
> >  mm/memory.c        | 2 --
> >  3 files changed, 3 insertions(+), 5 deletions(-)
> >
>
> Makse sense.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Best Regards,
> Yan, Zi
>
