Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BE42638AF
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 21:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757454725; cv=none; b=SMsAy+bCRgP0CjhZ0IZM8GZ8VWXt3KuTSrb0MIg5H2ErG9TU+SVboEWRD1jHdSMNW3j8sxvWprxHHcmwa/iNqxoWiTwfiLVKguRWNwTH2IYJHe+n7Y/SAksCaXhccXHA40/ztQh70F/A3CBQONNYIVbf0VaQGhiH3vHu8ZKFtmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757454725; c=relaxed/simple;
	bh=VRKGqPYdPm2RiNkLDyzrA8n4qc370r0yadDPgwWixCs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iyzPm/tefj1003JPURYZi0TBPnOPnJ6cuV2h0Sn6mDYtwke85mjX6rrz5lBHOHcndgjLC5uLDhctxSW2cXPvI4txs+6tVMhrPl+yyiK9jfpb6LJGvpXUvr3nO7hjaxGbYwN4toIbVuaj9IzFvab7ItoaiXxbOGL9ItKcIdiU5gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3f66898cc14so81232995ab.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 14:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757454723; x=1758059523;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vi8P1TS2Ynjge+umvIGVgtajiUURacZtN0BcVRDn4bw=;
        b=JkZNQ08j7z+sNkFnV+g/QDFOUJv2eh/qCBC9sxsxOf1Wxq2yeciI9Ie+d8sivey2P/
         /DDR4UR4MVYjj6J9WbHwFLEIEx+2D87/G3bS7p0f0yP7S9z7dLoHyshcxzKLjARubd7i
         wufs8bgKC3jL7DwWQfFdJPb0IRniiQUntKxt2hw0GU6AHqTrBRsvskmsByyguQZ3fOV0
         cJm7NmmC37AO0xxbuKPlLgK1JYKjPsJ/o7N4EpMpfE2g8jG/yw+6bfPYFtIcMGbH/DW0
         BOagf+8pyq9HeBoTYDmAIW44A9ZBye1F0wjpYtRKZOtNJb/mt9ae7C9/yk1dTgy2J2Gy
         pI4w==
X-Forwarded-Encrypted: i=1; AJvYcCVM4g6yPjw1s4AqUzom/Wl2xa7KqkGn+MBM5OjCBDMWImGwDEgI/Q7udHV03UVm2KI+zifif5M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyhe94uCsf4pY3IyZ9dXgphFM3AoOhmUn3PoTL8DoCFICtTfasc
	VoSLIAPqF6Rg8XrAavRfYwmVZAtn3wvRqZ4uVEq5s6sNgqCVEZ3J9Em6aTSMiPb0QVK6WN3jSf5
	nxkDq45f5d1ezqubb652e0IoA1M40Ow8LzIZWCmzgP+3OCitpj69y9HNPDsw=
X-Google-Smtp-Source: AGHT+IFXhUfwBgzOgjvRLI1Zl8rHtjLLfyTQ/RQcAwkLXAYWLhRa9IKYEjD/7YhyjehBc09jkchZNISGDCiy4EOVAqzjhhpcxsDC
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2198:b0:405:b792:32f0 with SMTP id
 e9e14a558f8ab-405b79234cemr140795505ab.32.1757454722899; Tue, 09 Sep 2025
 14:52:02 -0700 (PDT)
Date: Tue, 09 Sep 2025 14:52:02 -0700
In-Reply-To: <aMCaeA5qKzPbKwLt@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c0a182.050a0220.2ff435.0005.GAE@google.com>
Subject: Re: [syzbot] [kvmarm?] KASAN: invalid-access Read in __kvm_pgtable_walk
From: syzbot <syzbot+31156cb24a340d8e2c05@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, 
	syzkaller-bugs@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: invalid-access Read in __kvm_pgtable_walk

==================================================================
BUG: KASAN: invalid-access in __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:161 [inline]
BUG: KASAN: invalid-access in __kvm_pgtable_walk+0x110/0x2d0 arch/arm64/kvm/hyp/pgtable.c:237
Read at addr f0f0000007d02000 by task syz.2.17/4041
Pointer tag: [f0], memory tag: [fe]

CPU: 1 UID: 0 PID: 4041 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
Call trace:
 show_stack+0x18/0x24 arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x78/0x90 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x108/0x61c mm/kasan/report.c:482
 kasan_report+0x88/0xac mm/kasan/report.c:595
 report_tag_fault arch/arm64/mm/fault.c:326 [inline]
 do_tag_recovery arch/arm64/mm/fault.c:338 [inline]
 __do_kernel_fault+0x170/0x1c8 arch/arm64/mm/fault.c:380
 do_bad_area+0x68/0x78 arch/arm64/mm/fault.c:480
 do_tag_check_fault+0x34/0x44 arch/arm64/mm/fault.c:853
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:929
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:481
 el1h_64_sync_handler+0x50/0xac arch/arm64/kernel/entry-common.c:597
 el1h_64_sync+0x6c/0x70 arch/arm64/kernel/entry.S:591
 __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:161 [inline] (P)
 __kvm_pgtable_walk+0x110/0x2d0 arch/arm64/kvm/hyp/pgtable.c:237 (P)
 _kvm_pgtable_walk arch/arm64/kvm/hyp/pgtable.c:260 [inline]
 kvm_pgtable_walk+0xd0/0x164 arch/arm64/kvm/hyp/pgtable.c:283
 kvm_pgtable_stage2_destroy_range+0x3c/0x70 arch/arm64/kvm/hyp/pgtable.c:1584
 stage2_destroy_range arch/arm64/kvm/mmu.c:924 [inline]
 kvm_stage2_destroy+0x74/0xd0 arch/arm64/kvm/mmu.c:935
 kvm_free_stage2_pgd+0x5c/0xc0 arch/arm64/kvm/mmu.c:1116
 kvm_uninit_stage2_mmu+0x1c/0x34 arch/arm64/kvm/mmu.c:1023
 kvm_arch_flush_shadow_all+0x6c/0x84 arch/arm64/kvm/nested.c:1113
 kvm_flush_shadow_all virt/kvm/kvm_main.c:343 [inline]
 kvm_mmu_notifier_release+0x30/0x84 virt/kvm/kvm_main.c:884
 mmu_notifier_unregister+0x5c/0x11c mm/mmu_notifier.c:815
 kvm_destroy_vm+0x148/0x2b0 virt/kvm/kvm_main.c:1287
 kvm_put_kvm virt/kvm/kvm_main.c:1344 [inline]
 kvm_vm_release+0x80/0xb0 virt/kvm/kvm_main.c:1367
 __fput+0xcc/0x2dc fs/file_table.c:468
 ____fput+0x14/0x20 fs/file_table.c:496
 task_work_run+0x78/0xd4 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x13c/0x16c arch/arm64/kernel/entry-common.c:155
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:173 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:182 [inline]
 el0_svc+0x108/0x10c arch/arm64/kernel/entry-common.c:880
 el0t_64_sync_handler+0xa0/0xe4 arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x1a4/0x1a8 arch/arm64/kernel/entry.S:596

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xfaf0000007d026c0 pfn:0x47d02
flags: 0x1fffc0000000000(node=0|zone=0|lastcpupid=0x7ff|kasantag=0xf)
raw: 01fffc0000000000 ffffc1ffc0375788 ffffc1ffc0374788 0000000000000000
raw: faf0000007d026c0 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 fff0000007d01e00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 fa fa
 fff0000007d01f00: fa fa fa fa fa fc fc fc fc fc fc fc fe fe fe fe
>fff0000007d02000: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
                   ^
 fff0000007d02100: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
 fff0000007d02200: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
==================================================================
Unable to handle kernel paging request at virtual address fff6011cc11c0000
Mem abort info:
  ESR = 0x000000009600002b
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x2b: level -1 translation fault
Data abort info:
  ISV = 0, ISS = 0x0000002b, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 4k pages, 52-bit VAs, pgdp=0000000042978000
[fff6011cc11c0000] pgd=0000000000000000
Internal error: Oops: 000000009600002b [#1]  SMP
Modules linked in:
CPU: 1 UID: 0 PID: 4041 Comm: syz.2.17 Tainted: G    B               syzkaller #0 PREEMPT 
Tainted: [B]=BAD_PAGE
Hardware name: linux,dummy-virt (DT)
pstate: 21402009 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:163 [inline]
pc : __kvm_pgtable_walk+0x110/0x2d0 arch/arm64/kvm/hyp/pgtable.c:237
lr : __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:207 [inline]
lr : __kvm_pgtable_walk+0xb4/0x2d0 arch/arm64/kvm/hyp/pgtable.c:237
sp : ffff8000897ab910
x29: ffff8000897ab910 x28: f9f0000012c1dc80 x27: 0000000000000000
x26: 0000000000000003 x25: 0000000000000004 x24: fffffffffffff000
x23: 0000000000001000 x22: ffff80008292e9c8 x21: fff6011cc11c1000
x20: ffff8000897abbd8 x19: fff6011cc11c0000 x18: 00000000ffffffff
x17: 0000000000000000 x16: 0000000000000000 x15: ffff800081b63cd0
x14: fbf0000003145d00 x13: 0000000000000001 x12: 0000000000000001
x11: 00000042f216d964 x10: fbf0000003145d00 x9 : 0000000000000005
x8 : 0000000000000070 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000004e80000000 x4 : fff6011cc11c0008 x3 : 0000004ec0000000
x2 : ffff8000897abc10 x1 : 0000004e80800000 x0 : 000000000000000c
Call trace:
 __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:161 [inline] (P)
 __kvm_pgtable_walk+0x110/0x2d0 arch/arm64/kvm/hyp/pgtable.c:237 (P)
 __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:207 [inline]
 __kvm_pgtable_walk+0xb4/0x2d0 arch/arm64/kvm/hyp/pgtable.c:237
 __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:207 [inline]
 __kvm_pgtable_walk+0xb4/0x2d0 arch/arm64/kvm/hyp/pgtable.c:237
 __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:207 [inline]
 __kvm_pgtable_walk+0xb4/0x2d0 arch/arm64/kvm/hyp/pgtable.c:237
 _kvm_pgtable_walk arch/arm64/kvm/hyp/pgtable.c:260 [inline]
 kvm_pgtable_walk+0xd0/0x164 arch/arm64/kvm/hyp/pgtable.c:283
 kvm_pgtable_stage2_destroy_range+0x3c/0x70 arch/arm64/kvm/hyp/pgtable.c:1584
 stage2_destroy_range arch/arm64/kvm/mmu.c:924 [inline]
 kvm_stage2_destroy+0x74/0xd0 arch/arm64/kvm/mmu.c:935
 kvm_free_stage2_pgd+0x5c/0xc0 arch/arm64/kvm/mmu.c:1116
 kvm_uninit_stage2_mmu+0x1c/0x34 arch/arm64/kvm/mmu.c:1023
 kvm_arch_flush_shadow_all+0x6c/0x84 arch/arm64/kvm/nested.c:1113
 kvm_flush_shadow_all virt/kvm/kvm_main.c:343 [inline]
 kvm_mmu_notifier_release+0x30/0x84 virt/kvm/kvm_main.c:884
 mmu_notifier_unregister+0x5c/0x11c mm/mmu_notifier.c:815
 kvm_destroy_vm+0x148/0x2b0 virt/kvm/kvm_main.c:1287
 kvm_put_kvm virt/kvm/kvm_main.c:1344 [inline]
 kvm_vm_release+0x80/0xb0 virt/kvm/kvm_main.c:1367
 __fput+0xcc/0x2dc fs/file_table.c:468
 ____fput+0x14/0x20 fs/file_table.c:496
 task_work_run+0x78/0xd4 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x13c/0x16c arch/arm64/kernel/entry-common.c:155
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:173 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:182 [inline]
 el0_svc+0x108/0x10c arch/arm64/kernel/entry-common.c:880
 el0t_64_sync_handler+0xa0/0xe4 arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x1a4/0x1a8 arch/arm64/kernel/entry.S:596
Code: f9400e83 eb01007f 54000789 a9401682 (f9400260) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	f9400e83 	ldr	x3, [x20, #24]
   4:	eb01007f 	cmp	x3, x1
   8:	54000789 	b.ls	0xf8  // b.plast
   c:	a9401682 	ldp	x2, x5, [x20]
* 10:	f9400260 	ldr	x0, [x19] <-- trapping instruction


Tested on:

commit:         2d047827 KVM: arm64: vgic: fix incorrect spinlock API ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=12a4b562580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58f92aa8be80d71
dashboard link: https://syzkaller.appspot.com/bug?extid=31156cb24a340d8e2c05
compiler:       aarch64-linux-gnu-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Note: no patches were applied.
