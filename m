Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ADA366048
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 22:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934709; cv=pass; b=A0r3jaCZs6aznsc3nakqJWl3m9ys1LHqUen1KIGaKAJZAbwIvXDZdSjAYX8zt5XE8WPQ83GAayrs5uC+ZXQsMzsnHAXeK/j5hUFIc2NdKNPVF0r63YJxZZVBLLHcHOtWaJ80dLpKnmH/Ghw36f1GKqboAQDx3pGaz/85M9zGCxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934709; c=relaxed/simple;
	bh=noNTHlOK1+XTXgECJLp1WELbdM2KwGW5uoEbbwKOcik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XMHIc+ibb11fP9J2r20idS7sCzQDK5SDI+e2VXkUbsd8EBA4AX7FsaMvGBrinhRoR/XAlS3AymJbDEGaXNdkhkCQP0LKwVJ4NMRP+6AjKne93N+3gB4Ue+w7lyM+BMFpEH/EInQdNGx24eLE45m1LAbzOgHVAEcufEwKQLacvbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nFoqAluv; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nFoqAluv"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b9358bc9c50so707104866b.1
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 15:45:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777934706; cv=none;
        d=google.com; s=arc-20240605;
        b=bzlIm1yAbHcff5zRLtYGdAkY9p4ZNsjV6Wf6Hm5rstdu2XMoH2oK1xBxH18z0bR0Xf
         1XuKpRHgmsrDpFloeg7XhiErwn2ocpDm/VbLjZUeCFtWEjXuYeG+gGRBQbJ5uzFK4/ez
         XCjVHjjRyA7uWJfMXS9g3+jg60ghl9hZfYQbCe7VJsIPOEbu2+oqKKWEUKPGN1fd+znL
         ICBrN/YfW/rcZuRSFCC7P7yhvP3AachhOJgn0ffHnBECj4cw0RwEJ7q/vJj1wGeW8fF9
         5xlxekz5P9wi2QWPxIH09WEeGyIT/mIKC9713Dh1cW8FqinSlhjfJiRm+1gq3KLGIbB5
         jTdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=agnS5syCqKso6alfew7fBrkBd9YsRa9Uue32+MAHthw=;
        fh=FsW/APNwIzTm5CnD8uc3tKl4b1AOoo9f2YNFVsVlO7Q=;
        b=MGbXMWFJxizzJH4SkRjpLO0Of+hi0lWR1lWg73rwik19hvoIMdzCg6HfTtc7rxQHQe
         wumHaSlTis/V79B6kSK88DA2PUIAVx+iFlVJPbvMqhxowo/PO34Q/kn+A844kuf3uXMy
         vJk0pAZy161NMRm2nWtIYR37xQZXS++YO3mW97ZzvT+mo/qdn0sXOnjJbRPx3f71WbJB
         P/fidhpO3bhaTnb88NAL7aYhoLcW9iDZTUwXZtDanGU0kd6AmbseeAqXr0kgGPwNE4Uq
         B/b6CUayna3rhyRZShn7b1EJNw1U8q0ZGJm4QicDtBgfdVEAhBrWX4t0AImjlkjJne5M
         lCeA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777934706; x=1778539506; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agnS5syCqKso6alfew7fBrkBd9YsRa9Uue32+MAHthw=;
        b=nFoqAluv/c49L3im1/G9UgHPFDiMbdJiIAW4WV1hbu6b557363NowzcVc4JpArH1w1
         Lt46La4mTsKaRWG9uysPk4sL7ripieCihBoC5+cMzlCXb8jHQS2ntGT5rG766RCaU3M1
         DolTgWL9La9cZ6ejBlUqAYREehW/y7kWrewke9hnEW3d5UN+4rbJunDkfCKV64KHQ3wa
         EEfQSP19Brj76sbxdmhaMEwaNnza0WoQPLfdpjvu4Q/zjTN53aXKDL/5+jyjXiNYZHrQ
         WlTEeJzWNxyf0A2Gd5mO1lQoh1yDMkYNlacgIWUPlaYsNCN7Xl3IzyrZbnmmOxokEqkI
         wD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777934706; x=1778539506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=agnS5syCqKso6alfew7fBrkBd9YsRa9Uue32+MAHthw=;
        b=qgNoYf0b6Rj01N9g9UWUaFnq0i5OXnMp0iwkE4QcnwY0uxt4Apw1/3FpRj+k78+Sy6
         rnbrxOtBdepsvh4JOLmL8ALSYs+e2dyYCAf/vwRRA9F0DgJKTT5hshAoOw/OQK0d0L+C
         DcY/VW2bU5LbhjGO/HM2iKFwtXEsu7P91xbXvzSkPKOumi7y8OjV3XtxgDBcTpxaM2/d
         t9KmyQkZSSqD0+3LCRebB1f/g3BLxRSvDbORMXMMGLU2F3dm5mzJ20t5a1F6fLVget1s
         L8YXUgpUgipQ+yZjnI0jkQ+ZfrGxsBCQLJG2baeteAaopZ0pVzQGi8I0PQcgcLkqeJoe
         g9gQ==
X-Forwarded-Encrypted: i=1; AFNElJ9JxYkVZM7zJHbJxuyV0YfREf9A1gG1un2aimyT1hVc6J01u8H1ZmtpNUreEH0K9P6oGejvkT4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzc582uc9ZFQSG1q08Kx2mrMs+MmZwqiDBpyfmNqTR2wcRICqEt
	V692Ei31g5nNrZ7rw6qbXQTAPhmbwc5SxSWrr/xL/d5VHsiD22FPtdol/KvUKJVTjhWrEYHaHmH
	rFNYcPJRvWE7kwtbMUNg3HTOPvkham+1CgbMifbrR
X-Gm-Gg: AeBDieuqbQS2ladQ+pJkXMGJcx0oYW473iaynpAAsiktK86QpLreXdStqtgor1jvIJX
	El7Wqia35y3fPYYIisP96kXJxJlcgfRdyONg3aPSC+pa4u+xmSRtdtRa7M5a9ieTLQRIrmKSTGd
	q1wjNGXdJv7OEJ9hAC3ojC4ZCkduBrOEK0mC/gkpKKMzcJOj6NqRAHSbuXEZC/RLHPQN/7+CeR1
	0b07a6nBq6jZ14CaprFKVvCrbH0cRn1lIt4sn55zt2TNTbSZjLnatBxTMlxNoBui8fRdJg7/iI2
	fztLIvIn9+6xElq221FriqBxCSgZtVUro2zSTTmYLt10+gbWBx5jNWi2QXiWpxygxH6KsdxzuaL
	0kJJHvDs9A6zYxdYFNk/kTX92YA==
X-Received: by 2002:a17:907:25c3:b0:bae:d2dc:1114 with SMTP id
 a640c23a62f3a-bbffaf48959mr603805766b.24.1777934705381; Mon, 04 May 2026
 15:45:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260504224213.1049426-1-jthoughton@google.com>
In-Reply-To: <20260504224213.1049426-1-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 4 May 2026 15:44:29 -0700
X-Gm-Features: AVHnY4ISX5UKNFbqEqHmUwKZ4SIZjTFpsV3ot1gYDHAioJIe9jsiBtFZaU7PN8U
Message-ID: <CADrL8HWLMEwwQgD954GOWo4n87Y_G0G700qx8mJisMD0SGr4gQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: Fix race conditions in kvm_arch_flush_shadow_all()
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Gavin Shan <gshan@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, James Hogan <jhogan@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 4, 2026 at 3:42=E2=80=AFPM James Houghton <jthoughton@google.co=
m> wrote:
>
> Hi Paolo,
>
> syzbot running on Google production kernels ran into a double-free on
> KVM/arm64 in kvm_mmu_free_memory_cache().

Here is the full splat:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 BUG: KASAN: double-free in kvfree+0x30/0x40 mm/slub.c:7247
Free of addr ffff000810394000 by task syz.25.15225/156017

CPU: 2 UID: 0 PID: 156017 Comm: syz.25.15225 Kdump: loaded Not tainted
6.18.16-smp-DEV #1 NONE
Hardware name: Google
Call trace:
  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
  __dump_stack+0x30/0x40 lib/dump_stack.c:94
  dump_stack_lvl+0x198/0x264 lib/dump_stack.c:120
  print_address_description mm/kasan/report.c:402 [inline]
  print_report+0xbc/0x254 mm/kasan/report.c:506
  kasan_report_invalid_free+0x80/0xd0 mm/kasan/report.c:581
 check_slab_allocation+0x134/0x1a0 mm/kasan/common.c:-1
  __kasan_slab_pre_free+0x30/0x40 mm/kasan/common.c:261
  kasan_slab_pre_free include/linux/kasan.h:199 [inline]
  slab_free_hook mm/slub.c:2535 [inline]
  slab_free mm/slub.c:6730 [inline]
  kfree+0x140/0x548 mm/slub.c:6941
  kvfree+0x30/0x40 mm/slub.c:7247
  kvm_mmu_free_memory_cache+0x22c/0x2a0 virt/kvm/kvm_main.c:679
  kvm_uninit_stage2_mmu+0x30/0x40 arch/arm64/kvm/mmu.c:1048
  kvm_arch_flush_shadow_all+0x178/0x198 arch/arm64/kvm/nested.c:1113
  kvm_flush_shadow_all virt/kvm/kvm_main.c:579 [inline]
  kvm_mmu_notifier_release+0x48/0xac virt/kvm/kvm_main.c:1287
  mn_hlist_release mm/mmu_notifier.c:321 [inline]
  __mmu_notifier_release+0x29c/0x46c mm/mmu_notifier.c:359
  mmu_notifier_release include/linux/mmu_notifier.h:406 [inline]
  exit_mmap+0x100/0xb08 mm/mmap.c:1265
  __mmput+0xb4/0x360 kernel/fork.c:1183
  mmput+0x70/0xa8 kernel/fork.c:1206
  exit_mm kernel/exit.c:616 [inline]
  do_exit+0xc1c/0x26f4 kernel/exit.c:1025
  do_group_exit+0x194/0x22c kernel/exit.c:1180
  get_signal+0x1614/0x197c kernel/signal.c:3056
  arch_do_signal_or_restart+0x25c/0x4a5c arch/arm64/kernel/signal.c:1637
  exit_to_user_mode_loop+0x84/0x230 kernel/entry/common.c:44
  exit_to_user_mode_prepare include/linux/irq-entry-common.h:228 [inline]
  arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:103 [inline]
  el0_svc+0x168/0x1dc arch/arm64/kernel/entry-common.c:750
  el0t_64_sync_handler+0x68/0xdc arch/arm64/kernel/entry-common.c:768
  el0t_64_sync+0x1b0/0x1b4 arch/arm64/kernel/entry.S:596

Allocated by task 156010:
  kasan_save_stack mm/kasan/common.c:57 [inline]
  kasan_save_track+0x30/0x68 mm/kasan/common.c:78
  kasan_save_alloc_info+0x40/0x50 mm/kasan/generic.c:573
  poison_kmalloc_redzone mm/kasan/common.c:401 [inline]
  __kasan_kmalloc+0x9c/0xb4 mm/kasan/common.c:418
  kasan_kmalloc include/linux/kasan.h:263 [inline]
  __do_kmalloc_node mm/slub.c:5712 [inline]
  __kvmalloc_node_noprof+0x4e0/0x7d0 mm/slub.c:7204
  kvmalloc_array_node_noprof include/linux/slab.h:1140 [inline]
  __kvm_mmu_topup_memory_cache+0x460/0x5b8 virt/kvm/kvm_main.c:638
  kvm_mmu_split_huge_pages+0x1d8/0x338 arch/arm64/kvm/mmu.c:143
  kvm_mmu_split_memory_region arch/arm64/kvm/mmu.c:1306 [inline]
  kvm_arch_commit_memory_region+0x648/0x814 arch/arm64/kvm/mmu.c:2432
  kvm_commit_memory_region virt/kvm/kvm_main.c:2244 [inline]
  kvm_set_memslot+0xbec/0x120c virt/kvm/kvm_main.c:2506
  kvm_set_memory_region+0x7f4/0x9ec virt/kvm/kvm_main.c:2643
  kvm_vm_ioctl_set_memory_region+0x74/0xdc virt/kvm/kvm_main.c:2677
  kvm_vm_ioctl+0xc28/0xe50 virt/kvm/kvm_main.c:6368
  vfs_ioctl fs/ioctl.c:52 [inline]
  __do_sys_ioctl fs/ioctl.c:598 [inline]
  __se_sys_ioctl fs/ioctl.c:584 [inline]
  __arm64_sys_ioctl+0x14c/0x1c4 fs/ioctl.c:584
  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
  invoke_syscall+0xa4/0x25c arch/arm64/kernel/syscall.c:49
  el0_svc_common+0x13c/0x250 arch/arm64/kernel/syscall.c:132
  do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:151
  el0_svc+0x5c/0x1dc arch/arm64/kernel/entry-common.c:749
  el0t_64_sync_handler+0x68/0xdc arch/arm64/kernel/entry-common.c:768
  el0t_64_sync+0x1b0/0x1b4 arch/arm64/kernel/entry.S:596

Freed by task 156010:
  kasan_save_stack mm/kasan/common.c:57 [inline]
  kasan_save_track+0x30/0x68 mm/kasan/common.c:78
  __kasan_save_free_info+0x54/0x6c mm/kasan/generic.c:587
  kasan_save_free_info mm/kasan/kasan.h:406 [inline]
  poison_slab_object mm/kasan/common.c:253 [inline]
  __kasan_slab_free+0x74/0xa4 mm/kasan/common.c:285
  kasan_slab_free include/linux/kasan.h:235 [inline]
  slab_free_hook mm/slub.c:2590 [inline]
  slab_free mm/slub.c:6730 [inline]
  kfree+0x17c/0x548 mm/slub.c:6941
  kvfree+0x30/0x40 mm/slub.c:7247
  kvm_mmu_free_memory_cache+0x22c/0x2a0 virt/kvm/kvm_main.c:679
  kvm_uninit_stage2_mmu+0x30/0x40 arch/arm64/kvm/mmu.c:1048
  kvm_arch_flush_shadow_all+0x178/0x198 arch/arm64/kvm/nested.c:1113
  kvm_flush_shadow_all virt/kvm/kvm_main.c:579 [inline]
  kvm_mmu_notifier_release+0x48/0xac virt/kvm/kvm_main.c:1287
  mmu_notifier_unregister+0xf0/0x330 mm/mmu_notifier.c:815
  kvm_destroy_vm virt/kvm/kvm_main.c:1767 [inline]
  kvm_put_kvm+0x664/0xaf0 virt/kvm/kvm_main.c:1825
  kvm_vm_release+0x4c/0x60 virt/kvm/kvm_main.c:1848
  __fput+0x340/0x754 fs/file_table.c:495
  ____fput+0x20/0x58 fs/file_table.c:523
  task_work_run+0x1d8/0x268 kernel/task_work.c:233
  exit_task_work include/linux/task_work.h:40 [inline]
  do_exit+0xcc0/0x26f4 kernel/exit.c:1037
  do_group_exit+0x194/0x22c kernel/exit.c:1180
  get_signal+0x1614/0x197c kernel/signal.c:3056
  arch_do_signal_or_restart+0x25c/0x4a5c arch/arm64/kernel/signal.c:1637
  exit_to_user_mode_loop+0x84/0x230 kernel/entry/common.c:44
  exit_to_user_mode_prepare include/linux/irq-entry-common.h:228 [inline]
  arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:103 [inline]
  el0_svc+0x168/0x1dc arch/arm64/kernel/entry-common.c:750
  el0t_64_sync_handler+0x68/0xdc arch/arm64/kernel/entry-common.c:768
  el0t_64_sync+0x1b0/0x1b4 arch/arm64/kernel/entry.S:596

The buggy address belongs to the object at ffff000810394000
 which belongs to the cache kmalloc-cg-8k of size 8192
The buggy address is located 0 bytes inside of
 8192-byte region [ffff000810394000, ffff000810396000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x810390
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff0008ceb3d481
anon flags: 0x100000000000040(head|node=3D0|zone=3D1)
page_type: f5(slab)
raw: 0100000000000040 ffff00001000b200 0000000000000000 0000000000000001
raw: 0000000000000000 0000000080020002 00000000f5000000 ffff0008ceb3d481
head: 0100000000000040 ffff00001000b200 0000000000000000 0000000000000001
head: 0000000000000000 0000000080020002 00000000f5000000 ffff0008ceb3d481
head: 0100000000000003 fffffdffe040e401 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask
0x1528c0(GFP_NOWAIT|__GFP_SENSITIVE|__GFP_IO|__GFP_FS|__GFP_NORETRY|__GFP_C=
OMP|__GFP_HARDWALL),
pid 18319, tgid 17452 (ContainerMgr), ts 882149108930, free_ts
882148954562
  set_page_owner include/linux/page_owner.h:32 [inline]
  __post_alloc_hook+0x268/0x288 mm/page_alloc.c:1962
  prep_new_page mm/page_alloc.c:1976 [inline]
  get_page_from_freelist+0x2dc0/0x2f1c mm/page_alloc.c:4089
  __alloc_frozen_pages_noprof+0x254/0x120c mm/page_alloc.c:6001
  alloc_pages_mpol+0x1e4/0x444 mm/mempolicy.c:2428
  alloc_frozen_pages_noprof+0xe0/0x210 mm/mempolicy.c:2499
  alloc_slab_page mm/slub.c:3106 [inline]
  allocate_slab+0xc0/0x48c mm/slub.c:3280
  new_slab mm/slub.c:3334 [inline]
  ___slab_alloc+0xc4c/0x13d4 mm/slub.c:4717
  __slab_alloc+0x3c/0x6c mm/slub.c:4840
  __slab_alloc_node mm/slub.c:4916 [inline]
  slab_alloc_node mm/slub.c:5338 [inline]
  __do_kmalloc_node mm/slub.c:5711 [inline]
  __kvmalloc_node_noprof+0x5dc/0x7d0 mm/slub.c:7204
  seq_buf_alloc fs/seq_file.c:38 [inline]
  seq_read_iter+0x510/0xd08 fs/seq_file.c:254
  proc_reg_read_iter+0x174/0x2a0 fs/proc/inode.c:299
  new_sync_read fs/read_write.c:491 [inline]
  vfs_read+0x580/0xac8 fs/read_write.c:572
  ksys_read+0x128/0x220 fs/read_write.c:715
  __do_sys_read fs/read_write.c:724 [inline]
  __se_sys_read fs/read_write.c:722 [inline]
  __arm64_sys_read+0x7c/0x90 fs/read_write.c:722
  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
  invoke_syscall+0xa4/0x25c arch/arm64/kernel/syscall.c:49
  el0_svc_common+0x13c/0x250 arch/arm64/kernel/syscall.c:132
page last free pid 18319 tgid 17452 stack trace:
  reset_page_owner include/linux/page_owner.h:25 [inline]
  __free_pages_prepare mm/page_alloc.c:1483 [inline]
  __free_frozen_pages+0x1274/0x1798 mm/page_alloc.c:3064
  free_frozen_pages+0x14/0x20 mm/page_alloc.c:3114
  free_large_kmalloc+0xc0/0x154 mm/slub.c:6867
  kfree+0x338/0x548 mm/slub.c:6935
  kvfree+0x30/0x40 mm/slub.c:7247
  seq_release+0x58/0x7c fs/seq_file.c:368
  proc_seq_release+0x9c/0xbc fs/proc/generic.c:623
  close_pdeo+0x1b0/0x340 fs/proc/inode.c:242
  proc_reg_release+0x144/0x174 fs/proc/inode.c:547
  __fput+0x340/0x754 fs/file_table.c:495
  fput_close_sync+0x110/0x2c0 fs/file_table.c:600
  __do_sys_close fs/open.c:1591 [inline]
  __se_sys_close fs/open.c:1576 [inline]
  __arm64_sys_close+0x7c/0x118 fs/open.c:1576
  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
  invoke_syscall+0xa4/0x25c arch/arm64/kernel/syscall.c:49
  el0_svc_common+0x13c/0x250 arch/arm64/kernel/syscall.c:132
  do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:151
  el0_svc+0x5c/0x1dc arch/arm64/kernel/entry-common.c:749

Memory state around the buggy address:
 ffff000810393f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff000810393f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff000810394000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff000810394080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff000810394100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
