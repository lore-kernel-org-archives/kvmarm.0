Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3977B44781D
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 07:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790321869; cv=pass; b=t4D97YMLEZ03Nm5YnsiecWnuehn3HWxTWd7mTW9gVDVbrtLbTvJd/02bcWdXoGWbkOKISfvLtWbEkyJl1Ff8PpcU7L9u9COrxbesxSnrSRW9gfXvuEswzIsm4lcRAWhC/kZiINq+bfGEgTsyqhGPICVCT4Bh+D+udrlsWaU+xJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790321869; c=relaxed/simple;
	bh=4HRCApcqOCblV/nRa/gIhH9hhLpyjFWAyS7KPdKAl2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bPPfYYBmKNuk9fTPK5gVIZ8Y1R65MuBLdI3WbXYmk4NXUF2BPQIuVrw2wONUwGPDWwmYtgdQFH0WpQjCIuByzbZmA8tC1QFoyljk3vaS0fL0NK+s4vvyygB9hH19F8Awr2OXfu9lGS3avg3VVO9fTmYIx3lNaB+bOSEOS9DZ4ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bwR7uLeM; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bwR7uLeM"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a5f9b036f9so5564a12.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 00:37:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790321862; cv=none;
        d=google.com; s=arc-20260327;
        b=pjBYLnxC8iGN8oLmyvPcoMRwV78fnBW3PVDeLm+CGdSJ3EW2da7b95WH4soU9QWDX8
         V6h0AW+uhlr38TG6P/AY18bbekZAfbZ9lUcprpIGYGMRGg9ZU6W6lLCBg0H7PcGA8nN7
         a9MKFgjBXmEO0JAjX8qRxsICrX4qhf47Wk9rcn+xcocOJVBF2GvMCLELC+PA0NGrfBfP
         IvkAZr9LafUiTDVDZUCCI0xjz/6moqiE6uqmTNfvZsuHCzwSZ2an1//HBmgNMW7BmzEK
         lWgd5NRcenoIsR5RlWXW/gSm2NvTeAPU0NPdLeoLYj8EPucwSj7a33sOLt6SdG/+9GPB
         eCKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Oc+jzCqS0Wyq/bTJh2/I4jluChyvqK4NXUNsIigcps=;
        fh=ux3mtQ1wF+8x1URSD95P45GE7kGQtvXHo8ztSA00va8=;
        b=bZ9DDXiwkxWAnkbQlQDunYYKXndvr/RKmtHt1FrTXavpp2eGgEHpwZHkeF2PuDoMoV
         6WvMAdl75nBktycBD3hDo6EPS+F0HjhH9qBCEvVxkoTwOI/WGeJP9aLTfhNKvG1ISZWA
         rc8kLRDlHaUoX9X+V6znK/B3p1IAY3QDa7biWXrKWOPj1+2eEwfcymeyfCvsmPRwuWjg
         ReBkWqRnKZ1/MH5Zplu0OceIGRQgVpT3OTaYx0YfvRY4PeV3LaW6/R7cftQvXZc0gSlB
         3dG58JeAQ5Y70xOuCzHYWjadAwtOI0Z+Dj9c7ToR02drTddVaqxTn+YtxyqHvNlsDUAW
         6fHw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790321862; x=1790926662; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1Oc+jzCqS0Wyq/bTJh2/I4jluChyvqK4NXUNsIigcps=;
        b=bwR7uLeMXR0iT1rK4KpOyJrnFNdhhNJsNpApZAR3HvxKbqx8gsYsgb+dPqO97/GZnE
         KIGWCEwdOx6FdfTaA6bIbwDpCeaRYeIJTF8mDnStSXOVMYqeIb/cwiCmdfvC6cccqh/3
         1xGz7o4Fy9h7TJotHki0pWrN4j8SdoUoFmngW8/B14DzCLIk7qvdMQa3cjOeY7AMmS93
         KkOXKiuctVYoMEeRk0z5Trr5FBjyh5TafaSQj8A8NilMZjbR5dwk79oGx/UBDpCsz8r7
         Ouz4rANEGGHN182SX4gVuCj9AX+WXPk9yuHExU1jmjyKi2VdzNVjzqcXanY7pttnzBd2
         ZUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790321862; x=1790926662;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Oc+jzCqS0Wyq/bTJh2/I4jluChyvqK4NXUNsIigcps=;
        b=iQGmEt/rhatbarba8HM+FNy51aMMdIBni+gfEpuCjoI8BH1mvI/NlEvCWpcYZG99Y3
         17Fy4ysvi+3Tz1LzgqI6hA/GbC931b/CqTfa33tih2btRTRYz5E86S1bcqYcR/6rdW59
         aYl47WYpg2SZdHN7S+QJD5AYMcGx4ENCNb9sujYunXJmlDkRf5dZPmd9HcFDl1VLhC83
         nA1tPFxgsTGWctsObF95TtFHS0K5/2koxYAg870K7bsTeYe+6V7p0w6E7mDTHuyaLgtK
         0jSHs5b5NCL+iVWHAGqoJfNZe5Lgkt3au+EJZG7nb3d0kLdzP37g095+EI316Nw1vRk9
         /mbg==
X-Forwarded-Encrypted: i=1; AKwUvByQOwGPdTuEdh3VLKQD+litjrxmtO4l1C0GhMRB2GVh0aBGUnBwmY2yyKz0L2XCqM3ZHZX1YJY=@lists.linux.dev
X-Gm-Message-State: AFuF++n2OVv8vYe/yfd66rR+5MGD1hkaduNvBI4cHQl67mDfoiILBnex
	Z7yZzFYu15oR6AGWU/d2MlYH8xAPnDTXNgyXQy3Zt6/e7Wof8vzIgs0VdozDzsPu+kFiHD8Bc7i
	eACMBGaxKE95IVFVVirUy5FmMIGmSg+RAdM4eXoIK
X-Gm-Gg: AYBFou1w2Us4894wnaOMSpZW5jr77hW63X3OP3xMDaWKuh+zww0zN6MO3lWaVJ4rRnS
	9o1ccDYpjBzRiEMsPW6uEpVvMHe05M3QWzo4EO8MzJTBBQQHHe4bZS71xTptZBxAEqdUPfW3F5N
	nsKis1t/pBpz/Z1B5wPpECiee0tE3wQQIPfNHAd2DKgEpJNF7nAzFKPz0i5Nmnk96sBldt5xo9D
	I6maQrBEoLzWtDH9j6dnnLSDtjecnb9vmtb4Hif7U+fRq2DOUHxYwIgAGrdSMMtSLOKk9+lf/S6
	LUsqP01NFWYGel1LBaoEewlVLvMsNl/aJxXpYrj5DsniGlFj9J5GYg==
X-Received: by 2002:a05:6402:2714:b0:6a6:f2a5:1b4f with SMTP id
 4fb4d7f45d1cf-6aae4729638mr36915a12.4.1790321859803; Fri, 25 Sep 2026
 00:37:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org> <DLNSOBMBHIVC.22QI9YBL1U72E@nvidia.com>
In-Reply-To: <DLNSOBMBHIVC.22QI9YBL1U72E@nvidia.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 25 Sep 2026 00:37:26 -0700
X-Gm-Features: AclHuK_RUT9CXNFLpx8ZY_roLEZNzp5S3oNdpNL4cW25fJBFg9wRGnSWohuMdYA
Message-ID: <CAJuCfpH6AF-hOo4jU6OeNVpd+fgpqLpmcfAGs11J=nPCgAqG_w@mail.gmail.com>
Subject: Re: [PATCH v3 07/40] mm/vma: tidy up map kernel pages enum values
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

On Thu, Sep 24, 2026 at 12:31=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied=
 by
> > MMAP.
> >
> > Also while we're here delete useless comments for mmap actions whose na=
mes
> > clearly indicate what they are for.
> >
> > Also update the userland VMA tests to reflect this change.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h              | 2 +-
> >  include/linux/mm_types.h        | 8 ++++----
> >  mm/util.c                       | 8 ++++----
> >  tools/testing/vma/include/dup.h | 8 ++++----
> >  4 files changed, 13 insertions(+), 13 deletions(-)
> >
> LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Best Regards,
> Yan, Zi
>
