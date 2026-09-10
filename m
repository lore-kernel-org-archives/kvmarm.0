Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C5B4BE434;
	Thu, 10 Sep 2026 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789056916; cv=none; b=SpZ2NbrFOJlG1zi29oRZx/+7rmyIkx79vjVLq1jvY1lnAPUXLTj+7MGV8U6Sgl0fbum8dznSKoedoE4a1KIpZMC4JTlm0e3bCBe90Xb3APMfb2QWCsgEPRlrA05MaSJDRxZNnq1fOpDbIVMkGkcP//539Yjh90WdnwxsRsZoyVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789056916; c=relaxed/simple;
	bh=gTz12jkJbmkcu/dc9jIRm7p1HVrJCG1a7M0nlEBn7xM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbcnMONqEQXySXulYjmVfetnO7db9MF2OXwJAXFgRqfDllEfpOUZzarBmnsiGMl+dlW/BpfgM9mCJ8svcEBTLiZ/kXWee6D8Xm9nnJpbuM7kDWNnP4OeqNxTJudkSgG4rFoLZZDqoI2Xw3juni9ihKJUGauFZ1NoHhcZSzSb7j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KwaVR830; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Y2KOBCiA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SSkNdt0y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=f8NVEtsk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KwaVR830";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Y2KOBCiA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SSkNdt0y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="f8NVEtsk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE64E2198D;
	Thu, 10 Sep 2026 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789056909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BRmfG56H5zmUlLl5HniRsrUYDdv+UxK+dNlQeMPFvk=;
	b=KwaVR83038tEY0UY9Duk1VEc71qo6WCRjE1S3O0gvKvuRCHG42+lMQg4Pv852Z53umQGu9
	VjGqLOb8QDmQNHY+2pNnRCnchni2H/fLzJXN2LYO/8zb7Dml+uH7yZSNc2VlGsdDCBFr9Y
	l0PoG4YOAdgBCejTL9J/aXLrVyXMWP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789056909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BRmfG56H5zmUlLl5HniRsrUYDdv+UxK+dNlQeMPFvk=;
	b=Y2KOBCiAAtdbnR/fQhgCwIyKQWjWRx5/MHZPkKS6JrT5lfmwIstj6yrNTcNtSkn1IjAs+v
	GHOsOOnR5zkk3ABw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SSkNdt0y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=f8NVEtsk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789056904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BRmfG56H5zmUlLl5HniRsrUYDdv+UxK+dNlQeMPFvk=;
	b=SSkNdt0yW3GN3tzraY4wrF2jv2x3+drRXWKiGRungajUk2k0YXNbLn5Jv1YL59Qvvucb2O
	83+J8HAnRYoAZaOT6ItAtFTSuMTjA4HRl87EyCKKX4D/avW5hOH5AItmaXn8F2wEhWT2/G
	QirfirGABUJoW7pZPiRpw9/G8O5kGxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789056904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BRmfG56H5zmUlLl5HniRsrUYDdv+UxK+dNlQeMPFvk=;
	b=f8NVEtskkiiUWUL6F4auh9OnOU8pXQdeF2/pdQRRP5fwIvlOb4C4AeuTUScKje5DYuJ3Be
	SlZ8aiM57gvPBsDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 917381326D;
	Thu, 10 Sep 2026 16:15:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oqY5IoXXompKQQAAD6G6ig
	(envelope-from <tiwai@suse.de>); Thu, 10 Sep 2026 16:15:01 +0000
Date: Thu, 10 Sep 2026 18:15:01 +0200
Message-ID: <87qzj1jd6i.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Jaya Kumar <jayalk@intworks.biz>,
	Simona Vetter <simona@ffwll.ch>,
	Helge Deller <deller@gmx.de>,
	Sebastian Reichel <sre@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-sound@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	fuse-devel@lists.linux.dev
Subject: Re: [PATCH 12/39] ALSA: pcm: use vm_insert_page() to map PCM status page
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-12-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
	<20260908-b4-mmap-prepare-vma-flag-sanify-v1-12-dacf19cce22b@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DE64E2198D
X-Rspamd-Action: no action
X-Spamd-Bar: /
X-Spamd-Result: default: False [-0.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	FORGED_RECIPIENTS(2.00)[m:liam@infradead.org,m:jannh@google.com,m:pfalcato@suse.de,m:surenb@google.com,m:mhocko@suse.com,m:dennis.dalessandro@cornelisnetworks.com,m:jgg@ziepe.ca,m:stephen.smalley.work@gmail.com,m:perex@perex.cz,m:tiwai@suse.com,m:daniel@iogearbox.net,m:eddyz87@gmail.com,m:memxor@gmail.com,m:ryan.roberts@arm.com,m:dev.jain@arm.com,m:dgilbert@interlog.com,m:James.Bottomley@HansenPartnership.com,m:jayalk@intworks.biz,m:simona@ffwll.ch,m:deller@gmx.de,m:peterx@redhat.com,m:oleg@redhat.com,m:peterz@infradead.org,m:mingo@redhat.com,m:bp@alien8.de,m:mark.rutland@arm.com,m:riel@surriel.com,m:juri.lelli@redhat.com,m:tzimmermann@suse.de,m:airlied@gmail.com,m:npiggin@gmail.com,m:arnd@arndb.de,m:osalvador@suse.de,m:willy@infradead.org,m:jack@suse.cz,m:catalin.marinas@arm.com,m:anup@brainfault.org,m:palmer@dabbelt.com,m:aou@eecs.berkeley.edu,m:davem@davemloft.net,m:andreas@gaisler.com,m:viro@zeniv.linux.org.uk,m:matthew.brost@intel.com,m:joshua.hahnjy@gmail.com,m:rakie.kim@sk.co
 m,m:byungchul@sk.com,m:gourry@gourry.net,m:kasong@tencent.com,m:shikemeng@huaweicloud.com,m:nphamcs@gmail.com,s:linux-mm@kvack.org,s:youngjun.park@lge.com,s:baoquan.he@linux.dev,s:chengming.zhou@linux.dev,s:qi.zheng@linux.dev,s:shakeel.butt@linux.dev,s:dri-devel@lists.freedesktop.org,s:kvm-riscv@lists.infradead.org,s:linux-arm-kernel@lists.infradead.org,s:linux-riscv@lists.infradead.org,s:fuse-devel@lists.linux.dev,s:kvmarm@lists.linux.dev,s:linuxppc-dev@lists.ozlabs.org];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,infradead.org,kernel.org,google.com,suse.de,suse.com,lwn.net,linuxfoundation.org,cornelisnetworks.com,ziepe.ca,paul-moore.com,gmail.com,perex.cz,iogearbox.net,nvidia.com,linux.alibaba.com,linux.dev,arm.com,interlog.com,HansenPartnership.com,intworks.biz,ffwll.ch,gmx.de,redhat.com,alien8.de,linux.intel.com,surriel.com,linaro.org,arndb.de,suse.cz,linux.ibm.com,brainfault.org,dabbelt.com,eecs.berkeley.edu,davemloft.net,gaisler.com,zeniv.linux.org.uk,intel.com,sk.com,gourry.net,tencent.com,huaweicloud.com,lge.com,cmpxchg.org,zte.com.cn,szeredi.hu,kvack.org,vger.kernel.org,lists.freedesktop.org,lists.infradead.org,lists.linux.dev,lists.ozlabs.org];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_GT_50(0.00)[135];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	R_RATELIMIT(0.00)[to_ip_from(RLcf4qxihs3rkxkk14mdaty954)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -0.01

On Tue, 08 Sep 2026 22:01:16 +0200,
Lorenzo Stoakes (ARM) wrote:
> 
> There's no need to keep a fault handler around for this, instead map on
> mmap.
> 
> While we're here, rename area to vma to be consistent.
> 
> This correctly makes the mapping a mixed map mapping.
> 
> This works towards establishing the invariant that only PFN mapped or mixed
> map mappings may clear the VM_MAYWRITE flag. The status page mapping clears
> VM_MAYWRITE, so it must be kernel-owned; the control page mapping remains
> writable and is left fault-based.
> 
> The assumption is made that the struct pcm_mmap_status structure is at most
> a page in size, which is asserted as a build bug.
> 
> This is safe to assume, as the size of the structure is 56 bytes at most.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi
