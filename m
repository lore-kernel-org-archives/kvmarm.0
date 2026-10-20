Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792532922;
	b=C8qWszU1bpWE5vhlu9ok/r76zp4Vj5AnnO5F7S+LUFyJ4L8lkNj2c+VvJoDfsNmFPVt/
	 0TuK9Ma99yJZOzpyVWS1t9gcPz4OQ3JpWpqQIxJ6E4LMl3aTCI+j0Im/erO1uDTE9IYB4
	 auvX/i8VfHewMcxZkVjxqJ4ZhXVntBg/9o28YaOacqWzb4APWv3QQIG3o+B6Hb+rQigDh
	 0aoKlU08XLgOm1v9Z3Tmog+tR2McCsSeuDB+xXgKSJ/3yYScOt/e23r4m08F0y4aGxcNw
	 rgq72YqUXHgs8MpZKcTv3YpoM5BbDnaxjm8+Dj75UoHT1PFwBaWMLdbSqlGHJ2lC01g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532922;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=lwH5lbGW7Jp7v2pgahH/8u5d5Q1US/ZAJYtMLpAtA4s=;
	b=E4Vzi1uQiL4Q6waBV19Gnrg/4/ADVuUpIW64bWVAvv9ZH6SaP+FpWnc0EMPk7Z2otwJx
	 l1x+m6YpSkWvdyzcgxzlTBwnl8Cl2bCYIKqfstn0FffAX0eSSiUTRB+WdiEk3OnrqH343
	 RZ63k/wQu6Ht6CuLmH55fnD7tK2abxPTkJXAWKNILHEAT2Pifg9tD/yhdUH2Z7zMrJj6F
	 A8063lUQ1VYtDAMRv/QmieZxeKyjNhMLq0vUlpHsuseIpZOQyUVU952FeJ+t/FAnkOrQe
	 nNoeDbWfDuHgCpiurawWXyynnBSf1ognqk+Q1C7JDruIF72gYSu7Dtc17BaAgkfiv9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=O9oNH9kB;
	arc=none smtp.remote-ip=209.85.219.44
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D250606A320
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 21:48:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D250606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=O9oNH9kB
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-917d595138fso958926d6.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 14:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792532920; x=1793137720; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lwH5lbGW7Jp7v2pgahH/8u5d5Q1US/ZAJYtMLpAtA4s=;
        b=O9oNH9kBZDI+Xrxz++71wvZrX2hnP4G6lGl2z053NWXf4ZZIUhKBIgON+Tzd1rn6ou
         3yiISdt6JPv8kfgB+0zKGdzu6SyvNdjFnticSDhJmDRSKUER7ZU780b0tcyaiWQXEnui
         74nQkvWnu+QCNsxYSdy90jVp+KZIMuPT8R4YCuO4TkCTnSVMhbUAJXwx6GRgSbSZcTbP
         1Q3btliAaQzYPMNgu47UKFFTbDjhXYUPXcd0DamGxYz/5D/gZbYHtWCgMH8KKeb23hDd
         b8QTFC/vJ/9xK9+RVs4AKLcNXCe1w7wPxKyXvdqlCGRx3WaUtzox9WtgfD2R2T8RdnYw
         FVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792532920; x=1793137720;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lwH5lbGW7Jp7v2pgahH/8u5d5Q1US/ZAJYtMLpAtA4s=;
        b=2si76wEJz/g39aE4Wz7A+1rAS5hNokjFLHOMnmJUGHsckUjjCRcL1Pgf+7eNRGN4Bc
         P+QszEUXv/Lx74bULHYJKSYFNT1boX1c8aSG/fB6Ael+osWBJeaOgt76l9w1oXddbmz/
         taxeY3e+rxqalJxI9WSmZGA8g6DJF04G9UNmARNWWRhm/Oa73GmJsCoC9262Xw2Ya8YR
         YYTeR9JW4Qf8/Bs9FUtR3TUNZgFTqoMuQbVDYT6hMwrlepzboj5rPILpjbFEtPXq5ny+
         ioC79/2DmF+uiY0NUImNoObG6V555xPNCpm7TKu4jV0ryi1nLKVFCT2kWzkhswQstJhM
         dfFQ==
X-Forwarded-Encrypted: i=1; AKwUvBz/+HzDUiDdz8WcrfRMNSkvVGQZ8isVjrJAvgKA6AiQanYMaUamsFuxZSEBKmsL4wIWVFX7L4k=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ4jxjCdtP2Y4uXBPeuJl2Os5tRomgXc4WyNiHyxqRY2Vxg84l7
	uypHr4Sb090QRYfdf60tcdtK6EE6DFOPK6suw2i2dj4S+m8tJSK5Kyin7AWenr5okn0=
X-Gm-Gg: AYBFou0D0+qQP7WrD2w/QePp4DEdYF/0nRtGQV2WvF24ozTrIKzGZQwhG2E+Troxl0I
	/ZTF0KDW9qYqrClyrtCGQokxvJ8Nhv0qBt+cbaM4szLr6MGRGxUDe5NkCBwov3uk3vqwCUKYQ3m
	dnq0giq+9PxmC7lnLVtQXyVKUQodDlVmm3qGHjURNXQaTe+EJwDwVfvXPc4zVnX1M06cjiY8UGY
	LfxXWh65PrusQTM2115jYXaZ4I3aFrKF0qLuhlrG9kB/rVS7MdkvbyvPdXzbvx1qcfTGSw8TMIS
	nOPt016TyMMVeF9Tq/q5GoYOR3PJC0A5Rm75WseJ8qKRwjlvpTqyvcYmEqbIoD9+FBoAo/UiL3d
	8rDBJ3xhIQr06UN5gFKA/K10h7688XKctrhn7Ew8bUrml/GPRIKe72+AK721u2MW5dN0HJQllRK
	mPjsHnfE1n7U6J+mLRdVOiyBQV60I8YxDm/n//01Vfe/h0C+D7wLKqM3rEB2w2FqEmPFzXA8Ylx
	gDUvfkslcn6QcLO3tN2XmGY/hk6J7+9z7d9m08121Zwyg==
X-Received: by 2002:a05:6214:3c86:b0:91b:5d3a:5105 with SMTP id 6a1803df08f44-91c12f580cemr1790346d6.51.1792532920531;
        Tue, 20 Oct 2026 14:48:40 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10bc99a7sm8625276d6.22.2026.10.20.14.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 14:48:37 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 07/39] mm: assert mmap lock held, use new flags API
 in vm_insert_page[s]
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
Date: Tue, 20 Oct 2026 17:48:32 -0400
Message-Id: <179253291264.1207257.80392040365771672.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-13 16:04 +0100, Lorenzo Stoakes (ARM) wrote:
> The existing logic asserts that an mmap write lock is held, bizarrely, by
> asserting that an mmap_read_trylock() fails (which is not the same thing).
> 
> Assert the mmap write lock here and switch to using the new VMA flags API
> while here.
> 
> Note that the vma_start_write() is explicitly broken out from
> vm_flags_set() here in order to use vma_set_flags() safely.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>
