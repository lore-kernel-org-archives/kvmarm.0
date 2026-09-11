Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E542B36E494
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139171; cv=pass; b=icmdVQ0zhkQITi0rrrH20UfT5OLWLpUZOY//tfi0/Ugm0gMXrSuXr1CvQGcFZs1gRrK/eusZDTLP5fWFe1M9aQyY04aNTznyIVys/Sb13jk3qhI9z7uSfKGPzfXAxL4YJ6M888pUBhavC4FgbH5xxztZK3qahwY+JRMdu6qtwEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139171; c=relaxed/simple;
	bh=31WGPI9CsS8AEb1QmZigfY8oBbhGb6+EPuGPGJKusUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KfXRe5i9D+a+NM8wy3Qo9yLwraHEXmU5p09oGte36MpD0G1hLtTq9CICsfR9/8AANZVfHNWqW8s1Vza8EYSrKrnq0CbwUC8C5HLhQiNB1DlStVVxp5p9lQiFrrj/VTw6TqNbe8nEosC8kmLUo4MN0bugjrNrhYZ64m5H0fw32Hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QYxdXNkM; arc=pass smtp.client-ip=74.125.231.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYxdXNkM"
Received: by mail-oo2-f43.google.com with SMTP id 006d021491bc7-6b1ae6f5fc7so647604eaf.3
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 08:06:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789139169; cv=none;
        d=google.com; s=arc-20260327;
        b=S818MJazc5OKE9ShSxfG6IfLOPox29A1HwWkkoEghsPwsxEGi1NSbB5dAHUpyGK5SO
         hLoPjhXUEeh8QBZNEaUNRPTrCcRB4jmd2ukUl+DEyYnmzX8ICRHC5ex4OllPqu/Ensis
         VWnPHh/tQtQ8n652VXOAmPCeOr0+i7ZwWVzS70RhBFSOmPHimpMycMn+vgx3ShuZ4WdU
         ZyZChX5MIjawguKnewDUa6oK89hELIVPntRyroOqzkjF2O0vhy3MpcHsW0UpolZvDVUW
         XCBZW4Cr8WPTWiT88HsLUnZB0cuSjG0RvzDL6i+tAO864Hz3u4ltg2XNKM9bzDlVjaci
         xgOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=31WGPI9CsS8AEb1QmZigfY8oBbhGb6+EPuGPGJKusUg=;
        fh=bMg6cc1NUAv8rndVqwLFkhBL4sLEo+mxhip4IxEw/n8=;
        b=UE3X2rGI+a7GDvqK7ba3A5C2TnLOp36gM+qicw26JYVxxuLYi4pjSSJSlg2vgbFOZp
         LXYl6lefsK8/dr65pDvfWG0p6SYv34fApgRiEsLPk2Fjlb/xATa/+diUF6mmeklkh1ZC
         KnaqZTDoNMD5cbaKOSPDIYFRmQLavW48u8AaI1EftUI3zmBbVoRLYt5XOgh2PHhm7XV6
         7SWIxGjMaO2+g1tTMZtoCeHtV+vOwNTEuWmmAQ13PkFgdThUfS41wmnMZd0vU7ps8vQk
         k9W3HB8K2pNsy6Fl9+50B+k7a89LUoR9WcY60NU3s/04L1a7AgCuddBGtQ2ksQ/+QAwV
         hlZw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789139169; x=1789743969; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=31WGPI9CsS8AEb1QmZigfY8oBbhGb6+EPuGPGJKusUg=;
        b=QYxdXNkMIAcDjt4CItin7wMy9XEt8NlVgFOT9uCVQnD7dM2WCRgl4hWO3xcNjoGeXC
         g8RiKQN7MF8y4ZhajB+7H0DORIau+/auuWiIqsUkk2YRq9b2tGasF7jrXFeu1GGh+vtK
         hCCFIkc3zkmOcrHnp3SEZxUYVoAjeBaiVpBJXe6Nlqov37s9XveT4OWyKLoBluDSqiFM
         v5WPzEI/dDi7oPiLXvmwWW1LIE8PFpGPME8iLmNnHZfW5Vdm0eM80ov9K8ej3rwhiS7w
         9h/sMDEHXTLoYITMsyoiQYDR/EQ6xpLpNrBKp2n0Eopa2ueF45dMly6ZhmDd58uBkm9Q
         TTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139169; x=1789743969;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=31WGPI9CsS8AEb1QmZigfY8oBbhGb6+EPuGPGJKusUg=;
        b=akJQbj6h4DFRH6w83eJ4324J2xs5V4ebUXxG33GA/zkDWKKGDUh7TivwgTSsQLRrHa
         dP91z8Zs04ze2y/img7B0yvwjbzkAcE32RYP8+HXgL+vj6zIdGqpBxG/FnteZl+/hzb6
         oasXE/esywx605Hr1IhYdKqDaAmgryJyPbpCP1aA7+b3xOf6W1aX55KKMSXkJ9axM+pW
         LqkqOF1jqOsWk84AymdvmVte+dcfngq4kn7UbuxcTPWRRa2bQazGrmMLleRSTdLZWkUC
         J3RnVtj5pBQzouayB9bHeIri195qIqsFZheZjE/zASSCrfSZb4ut/C/JiA9joN4ly389
         bq2A==
X-Forwarded-Encrypted: i=1; AKwUvBzpdYW627vcRqdyF93LYT2A/J9t4x+nrI3+NnRXyRyHFcVOl8VR/GQhfHCGqJUg99Fn5+oEG2c=@lists.linux.dev
X-Gm-Message-State: AFuF++mFVP/dcty15NoQq3AOK5cfOe5uIc5S79yb+EMFypPVSdLT2zoY
	GPygXmGnEugJUc8tNhEhFW+XehNyxdU/PXIsJe2CHi2FHfuW6qyZPBYf9mAT9gzW3ZM+qCrvXpk
	2wwUxC0nfq5lv0Vwswjb/n4/afN+lv9w=
X-Gm-Gg: AYBFou19r+pRLPZrvHJTlO84ZCIqQDmw4d3GlhY37ePyHiUGDe1lb2tCX8RcmAMPY9N
	5c9QXbLB4duUrnUKC2xm2fxld0q3HjRULn14UMpE9on7KmbAJaosu1c1uw5vauiHZJ4XtPZJagW
	RP0tNfogqjS0wQ5toTwXmHNaGEmsBuZUHTv8XX9sCkK0iX00/JZ4YNs2awiyz9vs4ZeibUwjk8W
	D4vP3TjkijKhQiVAIT0BDn1sntgzFbqHy9HryjLzAQxxiMX6bB8a8ZualsQ9cEENOYvy5h5Zk1S
	cCGUFACHeBWPqTQLeS4Zh0kv+/j46PeCzNkDzH48BBJNRQ9wRqM9wZU=
X-Received: by 2002:a05:6820:8585:20b0:6b1:be9f:ce6c with SMTP id
 006d021491bc7-6c0b9d4e35dmr4967721eaf.4.1789139168581; Fri, 11 Sep 2026
 08:06:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
 <CAEjxPJ7hXSi=oLtQPV+7GEvN+txfYwZ-u-v_EysNHM0gSGNrCw@mail.gmail.com> <aqPUqU3eZeFrykj3@gremlin>
In-Reply-To: <aqPUqU3eZeFrykj3@gremlin>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Fri, 11 Sep 2026 11:05:57 -0400
X-Gm-Features: AcwNN1UL9TCHStClpz4OqpdpVCOHFGRlTtL1ELl-GfcxGBMtPjfBSuHNlaSY27Y
Message-ID: <CAEjxPJ6P19eKF-c+mm2BSr5_WpmhMTZjjUfSamv3SfOPO4SGVw@mail.gmail.com>
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file, drop
 mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Jaroslav Kysela <perex@perex.cz>, 
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
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
	linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 11, 2026 at 6:16=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Thu, Sep 10, 2026 at 02:11:18PM -0400, Stephen Smalley wrote:
> > On Tue, Sep 8, 2026 at 4:07=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kerne=
l.org> wrote:
> > >
> > > The policy file has no write method and is exposed read-only (S_IRUGO=
 in
> > > selinux_files[]), yet sel_open_policy() performs no open mode check, =
so a
> > > CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at ope=
n, as
> > > kernfs does.
> > >
> > > The file can then never be mapped with FMODE_WRITE, so do_mmap() alwa=
ys
> > > clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_S=
HARED
> > > check in sel_mmap_policy() cannot be reached. Remove it.
> > >
> > > This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping t=
hat is
> > > neither a PFN map nor a mixed map, ahead of the core enforcing that o=
nly
> > > such mappings may do so.
> > >
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > We should likely do something similar for the other sel_open_*() and
> > sel_mmap_*() functions too.
> > In particular, truncation of the status file can bring down systemd
> > since it is mapped by libselinux.
>
> Yeah I think there's definitely more that can be done there.
>
> Though I think obviously that kind of stuff is better as a follow up as t=
his
> patch is focused on eliminating a case where VMA_MAYWRITE_BIT is cleared
> incorrectly.

Agreed, posted one for the status handlers at:
https://lore.kernel.org/selinux/20260911145840.19039-2-stephen.smalley.work=
@gmail.com/
