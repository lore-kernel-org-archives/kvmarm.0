Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E50A511E8A
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 14:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173880; cv=pass; b=c1Zf9YpBcL2n/xwfcF9sbQnpM963xG83awoYyyq88eneJV18v6JJ4EIt3ggyQ3D579V3MCJhTuxd6xHjNILTRW16HPm9bSNjMZGAFGB+kcgEyDOJqmqiB8P9eODjyGB+yC/X5Oesr+okBDSeDdPzVO94yeUYg+7G4hOA7gT2ce8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173880; c=relaxed/simple;
	bh=3IRQTfCkVu29EAhzhIq8HL8xV9bhN+vmwTvfaTzW1hg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cyvsirm6Jati/jRBgkeVRi1IfPbmyUbefUto8JrJoQLyx1wXicDkuOSjPtRKQddMbBlBvVzuUk5UPJL0ZEs86NuWglWqiSk5aAHLemBvEG4whatry4G6Ku7eGunmtRCIz+oy/eAXCqZTP2X/MZFU9V6dNDUbE2k0bWMUPxhl7S4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oS0nl4pW; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oS0nl4pW"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53113d72966so260611cf.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 07:31:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790173876; cv=none;
        d=google.com; s=arc-20260327;
        b=M0VK3Uo2MPOXKQWcfIZ+cGx0wJ2Xek9GwKh366WVQp+vX8AtzCw8489MTk7nh8S2SJ
         WNnlb5dqipaJa/HMMgwAT6G22sTV+deuqD69Etxzx27O4nRW0O9D0BYf53Fsp24ZCBqm
         p+LuCBUj+KFuQruO8H6ZKBD4cy4ZYjrX1CBejVXT+bzXgeZVErAz1C81OQqXPkAIUQOS
         zTVLiUY5KqodEzUWqyrQuVq7yLnb5KKyDg+H/FB1JafLX9dTqQmdbIiZd/+Z8yKQYy/a
         uR2ABlZ8RvFSk5aTwierGj0z6hdIUGwvF6CLOtLwg9eDo9+gcvA7t38NvBWxDq2zuflm
         rGKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3IRQTfCkVu29EAhzhIq8HL8xV9bhN+vmwTvfaTzW1hg=;
        fh=veVAqyYbElJV842SzjTcnY8Ig60BlMqjylACGAFrB7w=;
        b=Si7RuJuH3Hd/uh3UekiK++e2axaeajkSqSBlpEJAUECbLD5Z6HfJfQglEBu4ZfKznK
         UMdiGGJR41F/harlihMn+uSW3huGXkcV8BEeZu6aAB9c9fZL+MM5CFZkYsc2S/jm71n9
         jM8WD2ZF88SDe343TJlNTp0ZA7p57Pw3cAYTwcMqfFayNWGFWR6a0mkw2yeMKd/2kbOl
         ZtiyOvrq7cXbVqLF/QiaQTdVmxSNb0rETq7PrOD8fDyH+5Ayfr4kzjrol5d+viK27F40
         8P727KIPJMbndOCUgwSg72hWNBS1xitZmlldrUcNdCtH11YJCGPaAROx2VG44JHU1Rsc
         rExQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790173876; x=1790778676; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3IRQTfCkVu29EAhzhIq8HL8xV9bhN+vmwTvfaTzW1hg=;
        b=oS0nl4pWRlrNyEOwpNkKXpsMS5i0z5ylwRTW7qYTeLf84ktkIDzcEoYkjW2Y5J1KdB
         /ti9FFHd1UlNTfvIpiLR6xasCKByaHQNX29XY6D/cpr1Uw+mhuUBqgyrIHxxIhGv1n/5
         LNUpVVeqfEsKMPcFY4KjL5W8rcmn9uphAddJDPZuc/myD/5+tvPct7F8NoTIpoHPweY/
         ang+6A53f1D1FytSDboOp+wCVFWykrLv0i5YWOeYbDo50Bp4I2OFNeQdOnKmfROFg64m
         5lJW11VC4f+Z615Ta4JOAsKXFk6PWtx2R94JvXTTpuuTppAUYSlSdYFNvTNjA1Dp6Uhg
         HM0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790173876; x=1790778676;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3IRQTfCkVu29EAhzhIq8HL8xV9bhN+vmwTvfaTzW1hg=;
        b=vvNezj4BJZmRdNsTUXE4f9jtWNUQbRrtKzUEk1GOFW5nrxK7xLjlaqPVwjV7J5+DiU
         VwnelueZr6ZTuz09nlRNtHaUOSRHTTGj7ObBlOo9AtjG6ktwRYmb+XGWdwoFF/8UVHeW
         7TM1P7WXqNFGPJjgneKSa1HySVJ1NgeC/JZQRbOUNH35bbDz5+DGpO0TbB9343+SnnhA
         gtzBUj+14xkscg47hJ/fxb5jB5C3zrU1+1K+CTMfsMHsKnBcUmYcIl5KAKGSxo4SkWHl
         WgMQ/jbRSRZd5nDcxsSwgy/va71HzqadlaLysnNU/pNuZuMGezhmshlrmit+A3hpQRbf
         mCSg==
X-Forwarded-Encrypted: i=1; AKwUvBzXL8Vrhz/dVp+Cng6OpiQ6Z4u4PuBe8JR6OX5v9laDD84ExTkHCYKp3iNZBFBvGxwMmMNF5RI=@lists.linux.dev
X-Gm-Message-State: AFuF++nyA4ArBYXQKxKj1Hb0TzXSXORBHPvjUxXCAPkB8Og4GKIDYlSB
	QCzj4eBTbREoeIdtEAA/6zP3VgYDMIK/ErirTlynuLNhLBuJY+D5m2rSzQbhHaS7ZiIEJn+DUZ3
	wBFXIRKykqbHmbNseVp0Qd+fhCisQ1TeZKkLXxcO/
X-Gm-Gg: AYBFou2vBZXl0ZN5obHaOKnLF8dBtGqYBCWftCoz1uzUSSWiXkGvX+a3N/IlK/NceRU
	+QrI/xdvI7aIBl8YTfbHBKtCnRgrizmZ4pTehrSTsKIu+IR1lAHh2qJ0KJ+7jY1A9dAe7wjNXuw
	C3KotCJ/2Y2jG4xYKw6Le8fC5Kv/N0/xsjOfn82WFg48GdBDvJuFbG4tZsK+oHLQ1zn6uMBPMKk
	lh29XPMKhR71Vr2OfApfzu4lHZ7Syc5Q01IhccFS7w+uP6o4J4DPyzj2ZZZmeko8u/A4bKfqAPn
	oo5p4qx9PWpgp89+zOz2i8wAUDjNjYgJAMfWsX1kHon0x2LTizei0L4gKVInOlvWzMXrOt8j4XF
	VYpebq0beVQ==
X-Received: by 2002:a05:622a:260e:b0:532:9d15:2e5a with SMTP id
 d75a77b69052e-532ede89b29mr14598791cf.1.1790173874906; Wed, 23 Sep 2026
 07:31:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
 <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org> <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
 <aq6kzpK7wPl3iFGe@gremlin> <aq6lW9FvL69QeA9H@gremlin> <arOCPN02xB7mykju@gremlin>
 <b007cd0f-29ef-457a-8e44-63ab26f3bcd0@kernel.org>
In-Reply-To: <b007cd0f-29ef-457a-8e44-63ab26f3bcd0@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 07:31:02 -0700
X-Gm-Features: AclHuK_ZGTwaB8ygIyiOyIIeQNRzbEtns-G_Cds8CuZ4q61CHw7YMjTifucik0o
Message-ID: <CAJuCfpHL=dHjT=O4S88ZBvT1DyodAtCL9QTryepzs3EMwoECDQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate VM_SPECIAL
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
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

On Wed, Sep 23, 2026 at 1:40=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/23/26 10:13, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Sep 19, 2026 at 04:09:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> >> On Sat, Sep 19, 2026 at 04:05:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> >>>
> >>> Thanks guys!
> >>
> >> Note v3 has been posted to fix a stupid bug in 1/40 + attack some very=
 trivial
> >> sashiko stuff
> >>
> >> https://lore.kernel.org/linux-mm/20260917-b4-mmap-prepare-vma-flag-san=
ify-v3-0-4583d8a23bca@kernel.org/
> >
> > Just a gentle nudge on this :)
> >
> > If you guys or anybody else has some time it'd be appreciated! (obv. th=
e v3 as
> > linked above not this v2!)
> >
> > I know the series seems intimidating but most of the commits are very s=
mall and
> > it's been in -next for a while.
>
> Busy with too many other things sorry. Its time will come.

Had to take care of the pile of bugs but I'm on it now.

>
> --
> Cheers,
>
> David
