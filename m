Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2720D38657D;
	Sat, 26 Sep 2026 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442893; cv=none; b=idFkI/CVc3ycxvDfNOBFhaQ2tpDYR3YoD5nn+CHkJvyF0qx/icBdE3Aw49iKrOdD7Wmr07RJI9ur+/gduPgIG/5lcSsg9zvugGl8bJhfasodGbXHjRraUHWBi1xpSnCzCZwA+p3O1CyKpHoLZbh3e+iXCjPupLFqHQIg6pVHwxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442893; c=relaxed/simple;
	bh=gojmdYDsD3StNnB/hDyqo1gXIHc8O8nZybk73It5oqU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=F2q26YzU3oaINIbbzBFePri8N28TFCe0sd248jYo8gOAWhJe92gR5SJmYJ3kmpGtjCqh7Zw8gg8FkRsyNxtFvhvRokesweu11m5qsWa9rsIc8UFa4su6bPWb4FvtE5/Doiy4fjjIj54M6f4ygun31K5Rtv030XnrtgJUusJCyMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=dE1RFAps; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LFqYjy/y; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="dE1RFAps";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LFqYjy/y"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 178B413800C5;
	Sat, 26 Sep 2026 13:14:47 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 26 Sep 2026 13:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790442886;
	 x=1790450086; bh=tGTq2YiYGuZgWk5ZY7JZMyWu45IuuL1ykMMcgPEJafg=; b=
	dE1RFApslPrSXAIEUR7zYCnrfR6vWyYxLHf2mps7m16cLN5ynFqwRrqagDCdLt5m
	YGRbmWqMeuJZtlHPeeOXNw4YOCr4WJ6Mx0NBGForSSyaTMKmirJa1d3T2lnduVHI
	rsG6gUbympIQqV0TgHZcoaLCS4Np+hjwdRsk5xnTjJWQAspIaZDsh56Wd+ZL1Q9P
	guB+47QlTtdPYoLG8jeKzxdNJlNY8FOh1EE+3+tKu9V2DYSkeblqIQPL6x4FiFqi
	37BVGgjvon0RgSlw4AbAROwgO5Lo55li4rPUTLQ9IBrXkmPCZHI9T0Ji1alFsVXg
	+dWgvw0N90MVm2Z635R8Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790442886; x=
	1790450086; bh=tGTq2YiYGuZgWk5ZY7JZMyWu45IuuL1ykMMcgPEJafg=; b=L
	FqYjy/yVFlEv/wmLmbEHRnoCYINCfyu+CrEq8Z1fyh4tz9qIiMya3S3yY3OFrTAj
	kbwJ1H7p0hlPQkLTIbo3q91ouu2AqnlXl5AXAUacs9gWfltmW1YlpP2JQRX6xaDG
	BIlnaq23mgNxIHZvkc5sn32cnf0vgx81JvFvLJXh30/EkXzOIDF2jBGju20aWRpQ
	r+U4sr/EsBDJPkf1NNPApHB0wtpHKJnfgD68NUX259cKVa0+Te+WR7YSLWz3+AYG
	NY5HM9amaFG4UKU2VWfYypsTDrNO67ys7nqOEDOLSOI0kUSbd6LrrDfi5G6ZeLOj
	guHR/v4b83Xt/fUVhxgQg==
X-ME-Sender: <xms:ev23aqEfCNjet-2YbYWWzRXflqtzqi8hwMuw-sOV-SpumEa7LG2shg>
    <xme:ev23amLx2unnBtPfhChzlb1fRZ2Od9LfU9yDqP0ez7conwhJcOBcipgwHXcNic6Vd
    ihyMWwi_TyPeTUyTmoikaAeCIv-aWaHbyLCC6Ub4m_6V1cork6IqRQ>
X-ME-Proxy-Cause: dmFkZTE6NCtyMLNoS8hrfLFpEVvHnZq+KuaY8H+9LmihRjQuIS2tAlukOayEfreBF4n2zt
    VM1Xb2o3pLojfbA1Q3K/syWPA1rTM+rS4TL1sKcoS7DFAfYGpLW2jXD87OlXNKqEST0xN/
    cCB9d0v2iX9PJOBVVmY1Q/2SAi/Mg+fUIg3v4HzozejY4wwxdLDProktJHZEibcEbdkK9A
    DsbLRqLfari181EQsuwTU6q2VoX8ASbKad+pD4D4x5fnBcBEsLw1S0g0DqkX98pTL00H96
    s7WDOTgZX/sRdKZFzHVYGuDUWUJen+c2yA8PP101rXcEkHHLoEMw3Y2mH/kj+PJ6Jg4phW
    ZPtHSWVzfsMi/uo7wINTVSLDSLjRI4Nrcb+iIceGEJgwfznIyowU/XB7wjZK1vQwvmWNfh
    Xsf2CcydvUcV328L0LwSnRsCbh10PhtfXwxt1AdrlAnXwA/tpDhQGwkJwWPe8a1uDDSIgR
    FuRPcva3YSO3dMEwljCPu2EQ9gdo7QVG5vdPgtLNw84R0kUyuYuZE3uKBRMlgr4529/DqD
    DjCSn1ux1tr4q9apeaHlutLLSq0hzxv+TC86iyQ80tvVgpfvwCR7R2k16RICYFops8dGKe
    orvK37Cs5fQgJyBNeJVlwb2UjdrY+qi1eBLaiX0vwatLO6jmf2NBuSQeeCRg
X-ME-Proxy: <xmx:gP23aluqnoTw4Kp_p7Myy76Cg9h3zOKmotAVHEwJf7Xg8wiaBQaRtA>
    <xmx:gP23atVx8P31dhvH6TSVp8JBe56LI4k3auajT3v0qFyKlytMy_bmLA>
    <xmx:gP23apJheLHk8ePOwgYDLSw0f2H4aAcZiX3L2QUNgpYltbdfKVe22A>
    <xmx:gP23ahPAx3Etc-AdLxQIy0Ipz5Y_4EKVj1jjlEnECLU6wC7z8PJW4Q>
    <xmx:hv23aunjCQ20lqB8ZAJCIhTa2AfrZr7JcwsQqJyvJGCpuVigaepn1ADv>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7CCAA32A0087; Sat, 26 Sep 2026 13:14:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AJwEWD5WPnhk
Date: Sat, 26 Sep 2026 19:14:14 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
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
 "Xu Xin" <xu.xin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org,
 selinux@vger.kernel.org, linux-sound@vger.kernel.org,
 bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, "Takashi Iwai" <tiwai@suse.de>,
 "Emil Tsalapatis" <emil@etsalapatis.com>
Message-Id: <4a3a089c-3ade-494d-8f83-f9cb710e9ad1@app.fastmail.com>
In-Reply-To: <arfGmNiEngnO3JKm@gremlin>
References: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
 <areSEI5pWBadkqIe@gremlin>
 <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>
 <arfGmNiEngnO3JKm@gremlin>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 26, 2026, at 15:22, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 26, 2026 at 03:06:33PM +0200, Arnd Bergmann wrote:
>>
>> It's a Kconfig setting upstream, but the way I'm doing it is to have
>> patch that calculates a sensible default based on other options that
>> is a little smaller than the default (currently 2048 bytes) on x86-64
>> to catch more cases where something sticks out.
>
> So this is an early warning more or less :)

Yes, a surprising number of these just point to stupid mistakes
where the developer had no they were adding a large object to
the stack. This instance here is unfortunately not an obvious
case.

>> There are many ways the call chain can go of course, but the actual
>> stack overflows do tend to follow this pattern where you are at a
>> function with high stack usage and call kmalloc() during low memory
>> condition and that ends up waiting for a block I/O down the line.
>> (you normally don't go through swap and nfs, I was just looking
>> for the worst case I could easily see in the code)
>
> You certainly found quite the example haha.

I have previously toyed around with using VMALLOC_STACK on a reduced
stack size and syzcaller, so I knew roughly where the worst offenders
lie, but the list was from looking through the code just today.

>> > If I can do it as a follow-up that'd be ideal!
>>
>> What I was hoping for is that as you are already deep into the
>> exact code that caused the warning and you can already see something
>> in there that may help.
>>
>> I don't think it's urgent, I just don't want it to be forgotten.
>
> It won't be, it's now on my TODO and I see it as a relatively high priority
> thing to follow up with.
>
> Will likely send a patch for it next cycle (this is about the worst cycle I've
> seen workload-size for mm so I don't really want to send anything more this time
> around).

Sounds good, I'll keep the local hack to mark functions as noinline for the
moment then. Thanks,

      Arnd
