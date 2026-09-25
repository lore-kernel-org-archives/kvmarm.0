Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B244FECF8;
	Fri, 25 Sep 2026 22:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790374022; cv=none; b=shFgiUeL5At25hcNDaHbuEh+KzUP94papKda/B5mwkvYVG9KXPWsJ18FNwCF+pc82gx2+mEmUhdiVE8K41vtrMDzhfqfOrvWJAT6dr9gN9496q9QVohKZrh0hLaXS3N5WEgUZG94Ppui9kEYRugS6uZDTX5hdExhhww/t95CgXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790374022; c=relaxed/simple;
	bh=lS1TxV0OL5XbjJoEVVQOxIs/WZv/eAgyubI3NbbQssI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=bNUYC7yTOPsZze2+tLUA5DpUj3ukb9j+0K672GMoN0Pcpu8InDi5F6pv2NVPeZVvOlBhtXywO0l/QAxUIQ7yaRiHbNOPl44cOs++ONzLl+5ZjzFeaFM4LAqLAG3W6pN3Wq5BQVo7eS2ZmSz989bRDx4fasNIQaYpvZEgMTmBsuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Zlmr4DHG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=X/5NAWLy; arc=none smtp.client-ip=202.12.124.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Zlmr4DHG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="X/5NAWLy"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.stl.internal (Postfix) with ESMTP id 66524130051B;
	Fri, 25 Sep 2026 18:06:54 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 25 Sep 2026 18:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790374013;
	 x=1790381213; bh=JrMmm48wWb5nfElfLTql9tnPeB0+8MEVeYNyAgGoaQE=; b=
	Zlmr4DHGQ8VOFDbBpL4C63f0nX7MHZG2nG3ayIMRnmI96rYz/AL0gq1drAqD488p
	nRXyZrQmC6x+9EmXhbOrO4tVieILNRX1OrF85tC3SpyFYFTooOPtwQhsomsyVFnR
	/JL/wUDCwIAvzqukPUYWFpnmPjA9tkQKzm3sN8CtP4Er/blf9iMJ5E1RbL9dQr5Q
	azNWuCqNQFI/RtcVKlzqmiwqBdEB7hxNNBcJHZRuQOUlpbLsER9WMTIqh7fR0cbO
	0rqOTpCQJBH/fMc3/cSkpsYg3m2x/XVeiwXfI/fIE3VkuK0tu6kmIxRtGMjmZ5Tm
	0bGA+qPzrmWnT/PmDeHu3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790374013; x=
	1790381213; bh=JrMmm48wWb5nfElfLTql9tnPeB0+8MEVeYNyAgGoaQE=; b=X
	/5NAWLyg3YZFuUWu8ra4DQtcMMYuSCQ8ppRoARSsvykmth6tIbYB1DV/SBkKaBqy
	ucuqfLFSv1a5QY3O0fGJBFNvVgU8ch42KbnuYXIespMpXGzMotkKHyFDIfMWLRl9
	F7nM74RkfKRQS9hC/5ei1xuCfo5nmfjaqdTQnN8R0e7Hlj1lgy0J+W0FR4BAU+A4
	NQLC+nBh6bH7jAdVJkhAAdtNuTA3rfYfCtwlx0hw1TN0+AzlI/wyWDtTfY49272U
	L3RJ4biROW6jLSXjRZNZVlLfRNuZn/iiVPFefw8RdPr0K7bp3w4jlh5vyZVoO4CE
	5wC6Ljxr7feU/E4rReomA==
X-ME-Sender: <xms:cvC2aleooIz-s5Od9uinMQe3cwAY8eDmch1kynf_fy3H821eqXhoEA>
    <xme:cvC2auCqaLVPfE6ov_bEa6-wP_ue3HT7urx6Pkp8OHuNw8Gx-YmbQwreoPICZC_C8
    wqzDaLNP2F-QCveEeF9wWmMIoLPnYMKvncpwz86IJJPrk1J4H72akC->
X-ME-Proxy-Cause: dmFkZTFzcTdzGevjqjoCPQwS3cDuhZoK8oU2gJZJEJ9nm6Ezy4rCsybvSQH5LWRQQ5BGYD
    rWE8GcLh/SD0OK93rHMHb+nN85ZiQLBNNWUMv4/GBdRWEXKSGbwbYWQ2GwGJmZ2CLvUIP3
    2eF1fY0CpcwTbnziypIg5cFo5xsUnavn7wLuBNDJE6AclU/QJrEq8x08d8JZw195pkMut9
    +XQ7lzPYEQZohK59KW7gHFp7WnISiwDCkylL1SuAn0RKCSSdlhmRMt9w65C8xyi3rDiCVv
    vE+hQgASzBzLzKVc3I9ppRL7f57uPiViyuwADs8Yu19vaS3Qfxg9r9IrzC4Mkgk2ustKRO
    F4m05rRdOeE5QpPp6vbIW6kxmuTWTAckzKlnyd8YSIxkWZv6i9nfm513vFD+0eTgA4SdTt
    qri3VNnnch9OdxrqaSSzsWZHizOYpxImHRcvk6QGv1bq1UhMgkHFzBOBPavWiMeiwky2KB
    3YkeHFQE/+K4iWbdjOEFO4OTzP/2wAcq7DiAjSIWoqjXvFqai5/eBWEZwYXzH24T2Jqilr
    EgQhDSmS5E2SAJVWg3UyPZsK5j9sRZkoeQSL0VVjyCIZZx+DN7PLGivuCQsWF/VP5s+ABk
    01aGDOM3El01HuVwMy0P/rO2I5SQxMqxGjZSe1srADQ0PhIRJpx21/0+EvLA
X-ME-Proxy: <xmx:ePC2ai0cNfYHa_hu2mUjpUBcw5imDXjczzuFVtK8vQhMU-jtziGkzg>
    <xmx:ePC2ajmX_hgY984FYsQ00EH6M5K0sfyeHvF1qv2R1IvPjts0GUTCKw>
    <xmx:ePC2alvAPzoDWLruQB6z3Ygd2kq3A2wm1GlTlHlWYalN8zlbryTlaA>
    <xmx:ePC2aqA0UTfKSyeeZg0dB6TK75dxPCAzmPZFuC_nBWalRYa9mhRkLQ>
    <xmx:ffC2alqlaLQVHV7jBfKQ7aBbho8OdZx_4GIw9IJBalNr09Mw03UhyI4W>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 548BB32A0087; Fri, 25 Sep 2026 18:06:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AJwEWD5WPnhk
Date: Sat, 26 Sep 2026 00:06:22 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet" <corbet@lwn.net>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
 "Paul Moore" <paul@paul-moore.com>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.com>,
 "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Andrii Nakryiko" <andrii@kernel.org>,
 "Eduard Zingerman" <eddyz87@gmail.com>,
 "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Zi Yan" <ziy@nvidia.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Nico Pache" <nico.pache@linux.dev>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>,
 "Kirill A. Shutemov" <kas@kernel.org>,
 "Doug Gilbert" <dgilbert@interlog.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 "Jaya Kumar" <jayalk@intworks.biz>, "Simona Vetter" <simona@ffwll.ch>,
 "Helge Deller" <deller@gmx.de>, "Sebastian Reichel" <sre@kernel.org>,
 "John Hubbard" <jhubbard@nvidia.com>, peterx <peterx@redhat.com>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Oleg Nesterov" <oleg@redhat.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, "Rik van Riel" <riel@surriel.com>,
 "Harry Yoo" <harry@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>,
 "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
 "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Dave Airlie" <airlied@gmail.com>, "Will Deacon" <will@kernel.org>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Anup Patel" <anup@brainfault.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Janosch Frank" <frankja@linux.ibm.com>,
 "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>,
 "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>,
 "David S . Miller" <davem@davemloft.net>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Chris Li" <chrisl@kernel.org>,
 "Kairui Song" <kasong@tencent.com>,
 "Kemeng Shi" <shikemeng@huaweicloud.com>,
 "Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>,
 "Youngjun Park" <youngjun.park@lge.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>,
 "Michal Hocko" <mhocko@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>,
 "Xu Xin" <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, "Takashi Iwai" <tiwai@suse.de>,
 "Emil Tsalapatis" <emil@etsalapatis.com>
Message-Id: <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
In-Reply-To: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
References: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Sep 17, 2026, at 18:22, Lorenzo Stoakes (ARM) wrote:
>
>  mm/vma.c                                   | 246 +++++++++++++++++++-------

Hi Lorenzo,

I see that in linux-next there is a new build failure in some
configurations in code that you are changing here:

mm/vma.c: In function '__mmap_region':
mm/vma.c:3083:1: error: the frame size of 1552 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

I don't immediately see anything that you did that would have introduced
something bad that wasn't already there, so it's likely just gone from
just below the limit I was using for my testing to just above. The 1536
byte limit is what I use on 64-bit builds with KASAN and otherwise
still has a clean build (with a small number of local fixup patches).

What I see is that this function has multiple structures on the
stack that have nontrivial sizes:

        VMA_ITERATOR(vmi, mm, addr); /* 104 bytes */
        MMAP_STATE(map, mm, &vmi, addr, len,...); /* 384 bytes */
        struct vm_area_desc desc; /* 128 bytes */

The config that caused this is https://pastebin.com/raw/5M95qHy5,
which is an x86-64 build with CONFIG_KASAN_STACK enabled, and likely
a few other configuration options that made it a little worse.
KASAN_STACK tends to double the stack size used by structures
in order to catch out-of-bounds accesses.

If I sprinkle some 'noinline_for_stack' annotations on functions
called by __mmap_region(), I can get the size down to 1144 in this
config, but that doesn't sound like a great workaround.

The large stack usage is potentially harmful if this ends up
in call chains that have additional large stack usage (e.g.
kmalloc() leading to reclaim). Any ideas for how to reduce it here?

     Arnd
