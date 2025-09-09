Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497682512DE
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 21:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757452292; cv=none; b=sqY9b/Z2Cld3qy1PTa0tRwJ0UDhGGbrFkvAi+sehutezAShiJsOnNxNcnfBLQ3QRstucRebwIXh8CuuqUTbAgHFHIDqJPqo6UXsCT3z19oGT8D25WYgs1y6xlDSip1Kpm25BvqLHKrVahZH2Hd2Ex4grB340aCLT+h40q8kEGhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757452292; c=relaxed/simple;
	bh=7adoKaEiA+Gm69Am8vMBgE9yOGNCvSrE9kTZS+1R9Hk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EgSA89sirJjDGvH7ar/kjCOmowENCzPfhsYl57CF0vZxPz0I5Hx6scUCvpusJO4EOA/s3MuRUhzG1MfVtEXOmQaZF7U/cBPlbxetRBzARpUzSD0Be2fxEQ1qVpE9HK4Dl10PsWKSbm0ETEtc/J2BpfGuzUGiC1B47+47i/q+esA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-40826edb6e1so82188285ab.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 14:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757452290; x=1758057090;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yK8ClsucKWiZ7rP6dTqe53VFnXreX3iMm3poQhOEI+w=;
        b=Jutixop0irFchEyF9WK+5W+O9qP6lr+MJh7No0eiLQjTkcTEe/tkrgqBMmQ8U9thIv
         1I+3+5aUZiw6APFvus13MZ6zMS+IN5Aopilm+RL6pbmwLGKHfXRf+quTQjjRCZoTKX1u
         POkdJ2Nt+Ol6EFMGs7h68Hwl3nZxnN3+NOWK+bAzhYbiKO6zWbSxzWLbnbT3wlJ11lax
         0n9UH79f3d/SWPSgMnUbv6epJvRxY9xF5qtJo1F+nKVWsubvDS1/upcqgaZBsONE9IZo
         ucFoKvxoZL+fv6jDWTdlBdmP1E9J76vCPJQjg/jqm3xyTWE6p8gRJHV12PwO3fQtxiAy
         MG/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUa8VKmhvPwEeDkV72k19Q7H8s8ybX0zMmhGIvovNz1iTJ6b+2c0mQG7f4BssJDderpmO8/yLI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdurGIHUKjY5v31OO1iEsTj5Uoz3uatyjz8cdq9XbdNsDudtYO
	QTb32X3/vybxT7Cm4ZnoCs8Gzk06ESx51t52e6y7gGwTRG7ctqru/o8gkmSQwveQz/rTXzGs6D9
	rwH7uSHfdaenxYwQIAMH+V3UIoSk85k98MVQa7wnbeRH1DWta55v3qF84GUU=
X-Google-Smtp-Source: AGHT+IGssSVcxmkBfpblAy2nP+e5Aj6iGPblHqj/69X/ccVF/yGQCkSd5+z/RwxOxmuNFincMwwqtng89Ctn5p55ABp9QPWIGMgv
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:5e85:b0:3fd:a540:9352 with SMTP id
 e9e14a558f8ab-3fda5409466mr174561575ab.17.1757452290375; Tue, 09 Sep 2025
 14:11:30 -0700 (PDT)
Date: Tue, 09 Sep 2025 14:11:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c09802.050a0220.3c6139.000d.GAE@google.com>
Subject: [syzbot] [kvmarm?] KASAN: invalid-access Read in __kvm_pgtable_walk
From: syzbot <syzbot+31156cb24a340d8e2c05@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, 
	syzkaller-bugs@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f777d1112ee5 Merge tag 'vfs-6.17-rc6.fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15f84b12580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45bc268c8b0b2faf
dashboard link: https://syzkaller.appspot.com/bug?extid=31156cb24a340d8e2c05
compiler:       aarch64-linux-gnu-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117c6d62580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e94934580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-f777d111.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3e36256124c6/vmlinux-f777d111.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea9018353872/Image-f777d111.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+31156cb24a340d8e2c05@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: invalid-access in __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:161 [inline]
BUG: KASAN: invalid-access in __kvm_pgtable_walk+0x110/0x2d0 arch/arm64/kvm/hyp/pgtable.c:237
Read at addr fdf000000f7c1000 by task syz.2.17/3592
Pointer tag: [fd], memory tag: [fe]

CPU: 1 UID: 0 PID: 3592 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
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
 kvm_pgtable_stage2_destroy_range+0x3c/0x70 arch/arm64/kvm/hyp/pgtable.c:1563
 stage2_destroy_range arch/arm64/kvm/mmu.c:924 [inline]
 kvm_stage2_destroy+0x74/0xd0 arch/arm64/kvm/mmu.c:935
 kvm_free_stage2_pgd+0x4c/0x84 arch/arm64/kvm/mmu.c:1112
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
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4f7c1
flags: 0x1ffc80000000000(node=0|zone=0|lastcpupid=0x7ff|kasantag=0x2)
raw: 01ffc80000000000 ffffc1ffc03df088 ffffc1ffc02393c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 fff000000f7c0e00: f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5
 fff000000f7c0f00: f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5 f5
>fff000000f7c1000: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
                   ^
 fff000000f7c1100: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
 fff000000f7c1200: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
