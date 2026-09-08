Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874C73B0ACE
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 20:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788898982; cv=pass; b=EsQgc2W9nRfPUMpEpDjG5QpRX0HrfJmVL8buhZe4rT5yHjtvd1j0Ivjyi7/lI1Xz3uo+EkkzUixLmCWKAYz8hTXXo2tpTNuZhBcSWqZfIEbrI5dwwsRnZjvdPQc0X4YPaeESUsHhQhhcjHckNdWy8jh9fWsJ+Nr+7YvQ6bsW374=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788898982; c=relaxed/simple;
	bh=TsLhOzf+D46xHpyx683mbvtqY0bc9njzNbabbHNEj0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hk4Ac8fpdIZCSreIvL5a0Q99rrD72qqc8goo2wmJ5u79a5l6a9RP4UgvZxfWwtser7TFGNDRDy5/iohmHBAkOXWMWO30uhwJE8LN+w6GSLo1WLAquxhZMWuheq/TD3VEaqitHL9mDNEtbthQJyBD8PeRkwHRWlvAziArvot+9u4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NWF1ucZo; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NWF1ucZo"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d6ff3aca06so4475ad.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 13:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788898979; cv=none;
        d=google.com; s=arc-20260327;
        b=TlYEPFAq4YGSRKPNdFAjKNaIIDjg7qJvvy6H4N1bkQv5H+l/+L1FlPROGmZgSP+9Yy
         2pLrslZbuEa3VL6eExVmrEeoXnSApagtbkHgwp1lHaMLw9MeEBWZKG3AXTj8M8yuRzGg
         fuN0fdfpoLUs2WZU5mZYeDv8YOBg5iK3dgrWriJWj9RmFFRWcSJXG7BmcjRcIGW6ZI/i
         9GJuJfrleT33UA8oys27eFFXwTvRzaA2zbb6vh9spqkKVO/49yC13k7PBzuvCYUaquwk
         eDzFnuuOdW3v99f9TGnaeGMOlhdDIR03c4GTx+v6+7YkgBQ7eIg4TDQxtmv9VavA1JaQ
         BktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TsLhOzf+D46xHpyx683mbvtqY0bc9njzNbabbHNEj0I=;
        fh=tu42axUnM1aNrnI7vY7ylYasxrwET3qfOfA/ZG5+xj8=;
        b=GIVNVpHVZwUP1JwhbGcXRbpCU65z3HWFA98FNjLa2BP0g5t6K+8pLEMUYuB/oYI3vq
         1mxhK+8ib6M8eTysjfyY0HT2yroOJaJjTOhrpBMSmfuSsIAhK8NM8NfPxZQHvYPjmSj6
         bRiCxvSAMUxjde0nfv94P+RLEx2/wgEjnzYNCb3ZgbcvIY0MP1fZPbNVUq01PmNJUz0Z
         s7Glfjvv/1dAFzwcOizT7GTQw1YcyHaFDM7sixLcLiAjD+9bR8+ZLzvCAEuLhgbCm2rQ
         SpCjiEktTwvhf9YqQoN6R6WDIsWiU4Q0+AvCApdfHav+rjlvryoBcxFgb59jU7uiU3cy
         HCbw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788898979; x=1789503779; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TsLhOzf+D46xHpyx683mbvtqY0bc9njzNbabbHNEj0I=;
        b=NWF1ucZocwc8zI8uCg+E/fCv1oarrnPkMgK8F050SjVxgrC+jgM17EoMQHgtgBlY2D
         HV/DzSvpHMgqjnbasy0Db1DQ9iWuro/WJcVAeraNkubT4ZuP8PsHGCRGUBRdsH5nvhuE
         dNIi3V72Jjv4ftPjIOc9rmlewayVnfrh0EYwScjkl8AUc20qnSXam+fhcmmokoQYBpio
         4J+J4eCs4oAEv3T3uREd0jPo5QTX7VkDM/6ixvbTat/u8vc83RyLQYiIL8Lr8Q66I+5e
         H18LL+8AfcnYij5pl5CkZwnuAvj3VbXDHmtWlhqZitJrQfFjQQOQjrk4N8zoEeNklSjA
         bSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788898979; x=1789503779;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TsLhOzf+D46xHpyx683mbvtqY0bc9njzNbabbHNEj0I=;
        b=Mub1OXGQnlqfDlzg9hDhbQxL4fao7QVlYaSdsBAo0O9R8WGyb5xMdmU+5ABMVMw49S
         lo4t/6N5nVWCEn/6hHZtOiTGYQWTpfIglfB0qrWJDRx6mN6SEJLZxpvqP9K1HOVC3X0T
         MyJj1ZumIQ9LkJFqCTD/99UkXIp84UDBeT9z9DbjSCmEijpqK8mEax0nvp9uVJHhDFBO
         NZuKfA08gqt1wkQDeeYVnGG7FyRdW64k/PKOeEMz3wXA6nJryVYQLea3O0YxsBTbVEJi
         auNCq+bMcMq4EGVfeMA3ByIbw9ICO/MDaxPGHVkedMlQZnSNpGeOlX9hTvV4ZGPYMA+3
         bLQA==
X-Forwarded-Encrypted: i=1; AKwUvBzizWvYzBm+L45HYFsgT4YGNovmmDrgpjOUD0/INo5hA5439i4C1tmDuZFkBSxy+wGHjhnhgxo=@lists.linux.dev
X-Gm-Message-State: AFuF++lr7Z98GSXUZmRZb1HkENysIq2a5DYIbI2VDOEBVWdftu/eTVog
	sJEq1esEIq+NuZ4/jJ2X/8o4TDX5mg35+IV0souEprewBA3GHbVIPu6TC9b4mFDfaIs0eMCW1nW
	35QHc0ni5T6n5epQHYJI3MyCalGS2gNM0aFIBy678
X-Gm-Gg: AYBFou36pZZi05dA2p1jh2SDXtOnDAI7wA9SgYWMVKYtvhVr/ykVaIPkT88sq8uqVaW
	vDh8KRMbTDyv87rTfKNjHT/BYYnW/itU/lcZ7B0KymASBH7hlgjIbD6e7g2lBuBXyn1PWBLPhlU
	qKSR0TJNlOf45t3QrEGDe3UNwy5tikF2s1rzxdBpBpYucJm9FwDZqB0ETZlteOM4LwnbyIShZWS
	JJPebRbMPhr8K5AYtK+tPwD3MNvXc4QMK8Za6d2ZBAKD5v2TXNsfeF2zFPQNaSLAulQ9WTKSz3M
	ltvL+boSUx5xLJ8xTM6Q3TgucVJ9glMBO1hfuCcs55vMoRaQA/RzzAX48vgQ5LUwlH4XeoeiZtd
	cV2Mznmn1LZx5Ue99gF2a6h71XNMZgB9x
X-Received: by 2002:a17:903:fa4:b0:2d1:1d3d:97c3 with SMTP id
 d9443c01a7336-2dbfeccdf9bmr1436185ad.13.1788898978067; Tue, 08 Sep 2026
 13:22:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 8 Sep 2026 22:22:20 +0200
X-Gm-Features: AcwNN1W16jAho4HwK_fzY15wUA-qa4DGJ92-DrEx1Ojg_VFhiHj2JxDdZTxOKSI
Message-ID: <CAG48ez3Ucb8HyhjC1-fijFiYJsnWcTLYHvJjzMyU710mgegxnA@mail.gmail.com>
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file, drop
 mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
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

On Tue, Sep 8, 2026 at 10:07=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
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

You should also be able to remove the sel_mmap_policy_ops.page_mkwrite
handler, which is only for shared-writable faults, right?

> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Jann Horn <jannh@google.com>
