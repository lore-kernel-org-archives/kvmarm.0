Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792532832;
	b=LeH9L35E7mogGc85jUOEBxmab2GNJml4xDqJVgxNnofFmk02KoBYxXVDZPJI1E8vjrkI
	 7Cxdo0QG40G6wz3GYALHfvQfy4JASDja/m0Ar9fPb9zRv87jWmxTRPItW8BEtuJRiarEc
	 F4ucozJTVL7OgIeYg2zFmM2/ELQYMgY8UoADbIyuSpIBElqk+qWoiii84Nw/Z0G3Qnsrp
	 O2MKEHrdvE9YDWafKuDgUrMO4FKPdJEJg2BV0v5H0xn3PfY3B+QVpMLklCj0Xff/LWF2v
	 8eCgTPrMvQE8BXBdN2J61/dfmiEmIyS/Zy8GhbZSDyDBqlbHklRQj7vBdPFI9Ufv06w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532832;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=PvIPEfkdtZUqofHUAuuyqlxSRMhwpGZiFkVH0+y5Y1c=;
	b=eD/t/FwqFnRKNEnM802C6MfDpvNi5OVca5jk8UQ/cI0nkc9cOQ+0n5uPznNOarHoC4so
	 W7AAFSn6nBYyEFWHYa5TNEAuBMks2c08PrcHYGwPKUfAYjzBivbEixpMtnlREmG0uQX66
	 j3s4krLLp8QayUracnlaiYNiOPVLQN2zweldF/2Tx+KZVo8rdhjyBfKIwGDlyxkii6hHG
	 LBj88gay6mHiqXetMnr6G2JwXRMOmg+L0U6VN/U8WGIePgEM0hNczX/N+XIStkP1Pz5TU
	 oFyOGXdU3nRtstvAlLeMbWL6w8yLbudhjEttssa2jR0B19734mkEFYN0dfsxmeGGlyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=aF9LWiod;
	arc=none smtp.remote-ip=209.85.222.169
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A56606A322
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 21:47:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5A56606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=aF9LWiod
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93ece7a73b9so12340585a.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 14:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792532830; x=1793137630; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PvIPEfkdtZUqofHUAuuyqlxSRMhwpGZiFkVH0+y5Y1c=;
        b=aF9LWiodVR3DSZM8lC02gS95g5tVcTAUy33sHg68OljnaMkM/cS1kmc5MVVyfQ/BK3
         MDLTByWGc/InVAaplu6xzrOuWz3CGj9c4Q+OKRRbqwcwQZLdTNMW8TAL+tHdIQZI2JAX
         s7fl0FbqnEmhQBrObNoo/O7Q3Ud0ZJ+AIJ5+B5dVQ0urBxEU2TWQo3RrKhwEqZAjR1KT
         Zy9xAK0q7sVZF2sVcSJ/A3CEBN7Pgfg1+lBokgbY/23UUwuz8vF18v6Z5v84DwaNTRny
         b60uGh9w5eELG1gmlbVQvJ0yniK+OW2Ps2H+5cImcnh8cR0HZdisOUyMCb3BPHx/oBGG
         Y08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792532830; x=1793137630;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PvIPEfkdtZUqofHUAuuyqlxSRMhwpGZiFkVH0+y5Y1c=;
        b=AMD0uaDiHRJfaH+HCJVisBrT5TKMv2migfNj1kEv6dhpI2cIupHuOqKj4+kVg4s74K
         Cp7iIHswlMjNtPZuTYp47hRnaUEIaBYl6Yq1fVl47MS7JSbYoa9g3qcbPjbjTrmfT8mb
         veZ7yTrAX7Afg+PTLbTWCdXQcW9yU2hYCyf6UGM4g0WPDcYHHzV8lqbXihr+PIy0LrRI
         f+t5RaUA0etdPxr2gr42/oqwgIWqOz78EVLamPugioZIbX+JLl7YxbsGaiN8KRpRhGmy
         MQmvWvnhYumBEF/s3T/BFAoXUBPnk9nhzKh1bG0ZeNwmxIksYwjCQZ9H079RKl9PAL7A
         z2nA==
X-Forwarded-Encrypted: i=1; AKwUvBxTj7WjZGZ18I8N08NXvj1qxuIqdKYOrpyn5pCz9db6grmnIvI9UOq17O29+QpodMwARRCyNug=@lists.linux.dev
X-Gm-Message-State: AFq9FYKE5MgzZm3P+h7o8zS79c8rtTqUzgFkq/9IIutJdqAT7eSFg+S7
	VFVmQNUDT/CkVksFYMbhY5ei4/sG8zEXUSrPwZRhQ7UhovG1+H+eYOp/OJyEl5jKxWk=
X-Gm-Gg: AYBFou3lu0HTE5HNCySRpzw6qY/tG/oK9JaQmhCKHdhkWFfcb1RjCB+6PAO3LqqA7Vy
	+Wrmu1moWOUvYARaEMUUTBsp4W40HeKHMH6EK+++p9hORkC/2kpwRKMVfkztoeY45Dsp9x8oglV
	1I2kSx+SK7wvpouviL1a0thn49NZ0oLBv5R5mABtgtFg4H3a1e+UWAxny0l72a/QlbB6/ojTuzf
	c4hrN7aZbH1nRG8basVeKsXyWR0Hv2q1Iq+IHYMAEv8poYi+PSUyWoT9WE0LTS6GpkilbIihpDY
	LiSr+RaYPyu0mybBudnMbJKY0mFzpJaclbkW3EA/4o/3gzB/VEgCR4cOUhyzMZmHoQbZgqcB2o1
	BqsmekmuRmKgqVnj7H/QVQ9fFuKjukSnYUkamzAJCWj+2/hnEW3Isb1/6IMobF8wzyOfe3JQrxt
	cYUxtjVw7Te0J2RY0oLMno/+fjy657ortwmLKLlCe+9uvfO//4NHw5UUeF4y9uQXjHv+CqEutdd
	YIuV89I1wHk1VYNXDwalGpqrPgCRXG+T3pWCjakL+pt+X55pDxj+MlzKWzK7YYJ7vhO4WlMIDUI
	G9aLiOrFP3k8c5MIGlBY1o2Lbi8=
X-Received: by 2002:a05:620a:198a:b0:93f:3391:d5a1 with SMTP id af79cd13be357-93f57f65930mr93498685a.75.1792532830268;
        Tue, 20 Oct 2026 14:47:10 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56d98978sm86912785a.10.2026.10.20.14.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 14:47:09 -0700 (PDT)
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
Subject: Re: [PATCH v6 01/39] mm/vma: fix mmap_prepare file handling,
 remove file_doesnt_need_get
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
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-1-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-1-1aa3c9b139f9@kernel.org>
Date: Tue, 20 Oct 2026 17:47:04 -0400
Message-Id: <179253282492.1207257.6426479952081115792.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-13 16:04 +0100, Lorenzo Stoakes (ARM) wrote:
> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
> 
> Drivers are permitted to change the owning file of a mapping. If they do
> so, they are required to take a reference on that file.
> 
> The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> to drop the refcount for the original file the mapping was made under, but
> this is not true for the replaced file.
> 
...
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Have a nit below, but otherwise

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

> +static bool map_same_file(struct mmap_state *map)
> +{
> +	return map->vm_file == map->file;
> +}
>  

Terrible function name :]

~Gregory

-- 
Gregory Price (Meta) <gourry@gourry.net>
