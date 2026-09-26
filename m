Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABFD442FA4;
	Sat, 26 Sep 2026 13:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790428043; cv=none; b=VYoW4VvXO7j67NztL6D3UOwyltAK4agptYRhCY+mHyXFvAFR2E2M7gzt3i4fQGGTeDyc6ctCJhRwR4GtdIp+u8H0LCLMuD5aCvCLgG1O9A86BxkqD7iLcymM6Cgd97tVsEPVy/L4/8rvY0N5EbYIxS2yuOGiQD4LXj9GwHh3yK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790428043; c=relaxed/simple;
	bh=wko7kmHoPQKSvHJFu02PIBG+REawZo/0kXd/Igypq3o=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DRc+lXMdU7s9lC4rO4ejsTCWHb4OZ8kvngUAqATK6bLMysAKLhWEUZVeOyt9F0NdTLdo5okamWPreEk4aKGohQKFtZUN2Xi4K25J9bknOfW74aYXZpt12ghJB26L02ZC+c2oZo4sUVwd+UAO+sA38QVxOPESE8Bny9IwtCn8pVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=JY6ej2Ga; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=w0Cytzi8; arc=none smtp.client-ip=103.168.172.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="JY6ej2Ga";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="w0Cytzi8"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id C06B913804B0;
	Sat, 26 Sep 2026 09:07:16 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 26 Sep 2026 09:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790428036;
	 x=1790435236; bh=E/0Aixz4MoGQbluxHxh98fr8xrgoH3pVa08CacPtFqs=; b=
	JY6ej2GaMU5tFQx4P4L7xpK0hMl18csetiXOfr6O0dqdVPmShWq0JPpifDXCAXS1
	WAsyKi8pjs7t6RWq759bpX8FHUqqgB3ix677GOzcftzN7F9N8PLmthIECeaNfa/A
	P+2uJuuFBTTgZAQ7EbICe01O/JdcPwKinMgJvLho7IluNFj8RTtGxVmNjqIKiYpj
	UR3vOmenvvoHhh4I2ZiYEvackkexMn3lXYx3KuwIgkOFVskKsEp+lc6xtXygxdEK
	AjntRnwlwzXroiH47DzyeX4QFd/GKDl/9E642yS7DF2Kw0s0p/0L0Ubu+WuXNN9t
	Dwqap0O2x84uyGP2aDdDPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790428036; x=
	1790435236; bh=E/0Aixz4MoGQbluxHxh98fr8xrgoH3pVa08CacPtFqs=; b=w
	0Cytzi8wSmj+mFhvAnjabMb+QZf7M3dVCKLEj9/Dbx70AK0JLhjm4IvD59f8aPoW
	M3lSl46dKAne7di/wMTJ76iJeR/YN2CWmJ273SA+/BycJRtz2TadIIcXjRQRA6Fw
	d1PjbiAXLrHehMn9sWL+H1plV3O0I6zA4hqQ8L1CMVdgSuWipTkep6zve4YfEqP0
	Zs6j6tUUMO1riGOt8v1vffbaH/NF18IOy7CG4zw9bmOLTzHJKqkXp4V6OtaaRa5H
	2eR47nryPx9zkA9F1ahtgW9c9sl4Pip3yYqEADEeqnrzG3MzERSbC2635R8ZhKrg
	pwU3ej5l8FK+5aoJABjXA==
X-ME-Sender: <xms:d8O3ag1HENOK2aqX5Hwlw6Q8RFPRNjCrvC5EQg62Q5MwZ2X8bbKZZw>
    <xme:d8O3al7CTh-qdNdQdYHKlYAc2HK5Pct0chw4_Wh6lTausRDuhvnXgNqkprm7sdGdM
    5U4_BMYkuFoj-4mearySbRTQ_cmndooZhYXir5Lfas9_vbxa-3XFA>
X-ME-Proxy-Cause: dmFkZTGluhR8DaufX6B/O8p7kobwL+s/+e2WxIV1ftwgdk4MOyOBMt7LN1vTfG/eVZk0Du
    poDENDPAZWU/+DFm2TqDnNDFfgVA6hHaGe30H4n6HeZKXNfngYWBIprCqpApIrE+Fbsucg
    3T43On08Mo6RNjVXL9te8gsrxz2WjOyw/W95nmJYPc0JMOu2PQIIsRRzHlvn+vNrT8LUbX
    mmoYyzTpLxtlzDHIP0u3kK4ktm0M9xoXlmDPLfcWfL49p+EPf/LNIMvJJMcvl0MfSqseyk
    Rsr0fjsMhmDFEIX9RQVpOsEW/sifidIp5PFecnwP38g63Y0mVjJCAlVER9svaUec6rZbmC
    qbtQKRzPvL8vBpUlrACJ+50qfVABYjsNU7+coMpX7EK9rz3tWqDsshpIrekmR1EYoFIwzi
    MFzRtA6nyv0gSEWy8V3Jxg6yoM9xEoGlhkpmswvoPC+1yCzJfj9aqpNmAvG77toghXLpW3
    oSZGIcXZugioQhzHy9zw5o5cRzaVDoEyD+WlhlAIT7/5QdIXyAicupFVuieBjIjNc7MSLE
    ZTeTptEMpLzGLB31HwOxannZP+AQz43E3ZUxZlcqdrZ09Q6mzAI3aJNRZ88M2AiEhJSkoF
    SRPUmVb1bqKMeD4YM6wIkw8UjM82p5rtkv7hDfqSo1lynYzWf8HPL9EYqClQ
X-ME-Proxy: <xmx:fcO3asP_JZb7_pe9MebtKK8m1oQZ2mFysi4LzvtqxqjkK-xmQJG7oA>
    <xmx:fcO3ahdCUIGe_-N0_11cq50k2hB7qoMtAn8OQ0p4v_cKD3b-BZ1GSQ>
    <xmx:fcO3auH0MA2jXNBVepFNbfn0NcMhLJ0i9yrj76_mSiuk373fUnS0zA>
    <xmx:fcO3aq71vFxuFeuj5WpfAshyYTTqDxV9SfXlvv_NrYetkbnGCsY2Uw>
    <xmx:hMO3aqB8ADUszpbuD6K9q4F8d_--PVT7Q9k3xSG4B02mLBEY0FvpthMT>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 577F132A0087; Sat, 26 Sep 2026 09:07:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AJwEWD5WPnhk
Date: Sat, 26 Sep 2026 15:06:33 +0200
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
Message-Id: <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>
In-Reply-To: <areSEI5pWBadkqIe@gremlin>
References: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
 <areSEI5pWBadkqIe@gremlin>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 26, 2026, at 11:40, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 26, 2026 at 12:06:22AM +0200, Arnd Bergmann wrote:
>>
>> mm/vma.c: In function '__mmap_region':
>> mm/vma.c:3083:1: error: the frame size of 1552 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
>>
>> I don't immediately see anything that you did that would have introduced
>> something bad that wasn't already there, so it's likely just gone from
>> just below the limit I was using for my testing to just above. The 1536
>> byte limit is what I use on 64-bit builds with KASAN and otherwise
>> still has a clean build (with a small number of local fixup patches).
>
> Hmm are you specifying this limit manually somehow?

It's a Kconfig setting upstream, but the way I'm doing it is to have
patch that calculates a sensible default based on other options that
is a little smaller than the default (currently 2048 bytes) on x86-64
to catch more cases where something sticks out.

>> If I sprinkle some 'noinline_for_stack' annotations on functions
>> called by __mmap_region(), I can get the size down to 1144 in this
>> config, but that doesn't sound like a great workaround.
>>
>> The large stack usage is potentially harmful if this ends up
>> in call chains that have additional large stack usage (e.g.
>> kmalloc() leading to reclaim). Any ideas for how to reduce it here?
>
> That can never happen :) this call chain is _only_ for an mmap() call.

I mean more functions called /from/ here, something like

  __mmap_region()
  __mmap_new_vma()
  vm_area_alloc()
  kmem_cache_alloc(..., GFP_KERNEL)
  slab_alloc_node()
  allocate_slab()
  alloc_slab_page()
  __alloc_pages_slowpath()
  __alloc_pages_direct_reclaim()
  __perform_reclaim()
  try_to_free_pages()
  shrink_zones()
  shrink_node()
  lru_gen_shrink_node()
  shrink_many()
  shrink_one()
  try_to_shrink_lruvec()
  evict_folios()
  shrink_folio_list()
  pageout()
  shmem_writeout()
  swap_writeout()
  swap_add_folio()
  swap_write_submit()
  nfs_swap_submit_write()
  nfs_file_direct_write()
  nfs_direct_extract_pages()
  nfs_do_recoalesce()
  __nfs_pageio_add_request()
  nfs_pageio_doio()
  pnfs_generic_pg_writepages()
  pnfs_do_write()
  pnfs_try_to_write_data()
  filelayout_write_pagelist()
  nfs_initiate_pgio()
  nfs_local_doio()
  nfs_local_do_write()
  nfs_local_call_write()
  ->write_iter()
  generic_file_write_iter()
  generic_write_sync()
  vfs_fsync_range()
  ->fsync()
  xfs_file_fsync()
  file_write_and_wait_range()
  filemap_fdatawrite_range()
  filemap_writeback()
  do_writepages()
  ->writepages()
  xfs_vm_writepages()
  iomap_writepages()
  iomap_writeback_folio()
  iomap_writeback_range()
  ->writeback_range()
  xfs_zoned_writeback_range()
  iomap_add_to_ioend()
  ->writeback_submit()
  xfs_zoned_writeback_submit()
  xfs_zone_alloc_and_submit()
  xfs_submit_zoned_bio()
  submit_bio()
  submit_bio_noacct()
  submit_bio_noacct_nocheck()
  __submit_bio_noacct()
  __submit_bio()
  blk_mq_submit_bio()
  blk_mq_run_dispatch_ops()
  blk_mq_try_issue_directly()
  blk_mq_run_hw_queue()
  blk_mq_sched_dispatch_requests()
  blk_mq_do_dispatch_sched()
  __blk_mq_do_dispatch_sched()
  blk_mq_dispatch_rq_list()
  ->queue_rq()
  scsi_queue_rq()
  scsi_dispatch_cmd()
  ->queuecommand()
  ata_scsi_queuecmd()
  __ata_scsi_queuecmd()
  ata_scsi_translate()
  ata_scsi_qc_issue()
  ata_qc_issue()
  qc_issue()
  ata_sff_qc_issue()
  ata_sff_queue_pio_task()

There are many ways the call chain can go of course, but the actual
stack overflows do tend to follow this pattern where you are at a
function with high stack usage and call kmalloc() during low memory
condition and that ends up waiting for a block I/O down the line.
(you normally don't go through swap and nfs, I was just looking
for the worst case I could easily see in the code)

> In general I am absolutely taking this seriously and will find a way to
> reduce this, but my only question is whether this is actually something
> that needs to be done in this series?
>
> Because it's already huge and I would rather avoid adding yet another patch
> to it if possible.
>
> If I can do it as a follow-up that'd be ideal!

What I was hoping for is that as you are already deep into the
exact code that caused the warning and you can already see something
in there that may help.

I don't think it's urgent, I just don't want it to be forgotten.

     Arnd
