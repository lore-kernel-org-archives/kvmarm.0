Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2097E4B2CC1
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 20:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789763502; cv=pass; b=rP7WJOQ43hfsLbtdER5kaEh9ig/SYdhpSsV19vVGfC+RpdFLp8f5QGUaEm+EeKJjaKyikH2703m/mGQB838kzXcxOjGpWlj5pfi47INAJQQ+hlzYlVUmMszwXteKdIUy/El6NHfj6VQx6/Mv66SscBg9zLeO9/9Up+Pu4IdAB5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789763502; c=relaxed/simple;
	bh=B8p7ihCHzGvnzup/C6y6XYLlWrQRIq7YUbOlQS6xj3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bRJP6ASIyaGwJt7u9mOUfiW81lYtsCE6GVaJEH1Ez2rvm2R1B/n67XfcHNLKdWSybiWJf0riyzcWUk406/xEwUAUKNfVjhXFhrt7Iufexc80JoawY20Z74mj1Do5Qlofb/DJZzx9vab+PUsv1y/4JDZBHC2wLejlOvpzAS5RYKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bz1mitK+; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bz1mitK+"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-530f6bcc301so54861cf.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 13:31:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789763498; cv=none;
        d=google.com; s=arc-20260327;
        b=pnAiAMBDu24uguSPCIlsaaMmkWtBATMxUaWic+I4lYefE09YlSjuQ7EDFc1IqjitUI
         a0KLLIdDg8ofnvsJqzUUKd0YID18PyX8h3WHace8uvddKefu67HRC7r/Le5uwDq09Klw
         tXH7cv0UUPaNumzHPLrGPUp5KVsLqylF/M8cgNZGAtELjzAnie6YcztfaYyxw/YPnAN3
         n3EbDUbt7oPY725pUbUSzxc0/OjQx35OyIuzJbd/jYSThhDaKROyz5Ee2oo+aOGaH0c0
         xwq5uDLwQxmw/1H0ZdtsCB3+i+JJ0xAIB1IaIbCoajDI82Fkq0YhJaioS/aOj7YZs/DB
         lOlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
        fh=Ff4p9x8YBn2Jj0j7kePbOB6glByrtydBx+dIJnLchz0=;
        b=BLFMeX5k+8RQYXpk7zCdbHhdfAef6c9dK6iHxqS4CfmvoA3T5xatZ40Y1oqREBu/un
         37c1Dizrx58Czz0rhsSEj3SzjrbnSoq/WBAbr3CElPrA3yyWs+e6skcVqUO6Aw9b4aPP
         ZWW6H2hduA9koT+NuzX29/7o0hh8wKk1r/9tOuWV+aNEKtHdCNw/Qc2G1MaUxpFXewAg
         Th696PztEgm9kMifYyBH1ArNp/wIcIIy6M8739LWt+TK6MJfa0rNkd/2fRKE3MXSRrHU
         8vrx7BDqxle1l+KYuno5+1J/X/zaTf0QZSmjsF5+yMj64EdCsVj14wWy3HVnZ4G3ggbx
         Stfw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789763498; x=1790368298; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
        b=bz1mitK+///u37Q8SpzXauvMRdcQuhLD6KHJmS7xqUUPEyTVhmUYC/ERAc+UnBfQxQ
         6S9RL3H8c602USCoEJtKDFwL4PmRTRmlLsAPB7eFZAj1zZGHyVcl7tswtMDH8TOkMDCA
         DWNOUTTUT8wmBxPi3lrDcrA/QsSlPzwvJiirmEVaDHCHM2sZOrowKq2AlT2WvDWuynFq
         EBPcafK0y6ayilQq0vQ75+JjGmboVWWVKlXCALBm8d7S9JL8K58BiYNv4QAa4fxC6OWN
         qCKgAcCX7GF3+emqGYSvJD8qyJFOzMWwUZNOH48BB2NHPpI85ts4vmsj2fjoElUL3wkW
         G9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789763498; x=1790368298;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
        b=m4g8R4JKwSUMDVu/wTCDwr2y4WqmDzzDSmVYsSmkYNsXcJVCb5Pry3PyS5TUBrkaAJ
         RtCppV9Ehn/XVPGatvbl3LJZd8dp8nP/29QRFGkk818atA4acqyrAqZnmNAOY2YTRXPu
         p+7vLBEVw9BpMPLyAN5AlKk1dOLZgwetgWPrHncL/PqkY4ReqQ8ePZ+43cjuGsn6GKRx
         4MnqBMhf2wmMFyROEDn+IhEMJoVAgpXJEKrHylejMDgaSajrX2A5WvS6JrLDRn94LjLk
         HCwSfmfSjnhMB94W2MT1Op9mJgBNvn44mQ3qw899rxLSmpYin8kB7bbYVdKOOY3lqL0p
         gb3w==
X-Forwarded-Encrypted: i=1; AKwUvBz36uCpQ06UqGe5qZXAITPQBzhdbSHh7bJITnxrlILVsQcBiZz8VHfyNt0mqokSCFnV7uMtINQ=@lists.linux.dev
X-Gm-Message-State: AFuF++m9MVlifg7Q5qXXfev8060Hal5As3Y+N3KzfXmToIO8epHFqWQn
	MqBrPDhoEJLsmFYRYxyyGaO8jOxWpP5N3bwSHvz+4cQgldM4m4a3tKr6IpVzZapF8VVRNEYk0pd
	bxJMqa//QSVqW6Uo9O2W1Y1dA2RspQ6qHeT9fthx5
X-Gm-Gg: AYBFou2yUqECDf8cTokQZ2XjdUX/uz8dz8UZQ6TmvHVxCtmBPTYp5F+H2u+269n2GB9
	f0q+UvLiiSxKp8aaTAVm++5nMeEZA0QodzGw43wvVUOqIjdlu4jynDA11xa3SLUfT0tpdVmIDnY
	VdWRuqC1/l7/ifYN6NvdmOiCpEQSm71O47v0qcIcXyslGy3f2BUBVqc/+nmY5OOaRLvvXmGHi63
	hnsxVB40NhCkmBWs0tkUO877kAuiwQiBTSR/hbuNrvfj+k8/b8X7sbhMsM+13FzTxA+HMAkKv0P
	c8ojiWhbQtT2lII8S4Nz/1cx9Ksi2u6Bbrzz8Cg1WenRntulSsb/uw==
X-Received: by 2002:ac8:5d08:0:b0:530:2f98:cebb with SMTP id
 d75a77b69052e-532b099561dmr605641cf.11.1789763497212; Fri, 18 Sep 2026
 13:31:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org> <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
In-Reply-To: <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 18 Sep 2026 13:31:24 -0700
X-Gm-Features: AcwNN1VqLTR47MatnNlBWbpWA8EMmoQNGykspJvqoxdaovPnF0EYfRCWZF-8zh0
Message-ID: <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate VM_SPECIAL
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
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
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2026 at 1:21=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/15/26 03:08, Andrew Morton wrote:
> > On Mon, 14 Sep 2026 15:57:20 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.=
org> wrote:
> >
> >> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> >> properties:
> >>
> >> ...
> >>
> >> It's all rather a mess.
> >>
> >> This series brings some order to things by both limiting what drivers =
can
> >> do with VMA flags and switching to using predicates that describe
> >> behaviour, not arbitrary flags.
> >
> > That's a lot of patches.
> >
> > Review is thin and I expect this won't improve a lot.  Lots of "no
> > functional changes" changes.
>
> I'll expect to go through all of them. Might just take a bit ;)

ditto

>
> --
> Cheers,
>
> David
