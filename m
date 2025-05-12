Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667D324C099
	for <kvmarm@lists.linux.dev>; Mon, 12 May 2025 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747068387; cv=none; b=exIZtbJzC6tN9X51XpAQcOnORBT7qNz6QQpueS/iGyz+GWIQtp3JkaMANP3r1bf5Rs3vP8XrmKWOYHNGovg6cH9BOS1rRv8U+A9EOtP6wgnlk+Xk4Keu31Jg6HW6BftwxON2cG9u9SPC36efjVA1vDHxtXpv68uP3u9iVxmUp0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747068387; c=relaxed/simple;
	bh=qukYTQ9gqsLGpARstbxnyXkpA+4LfgM/mx0IKU7X1MU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KFUhmp3KKrO7zsbuOh0fijR8hxFWrY01TKzy2hVXMLj7GzVtlkhvEUUVD0mM5LGWb1Jhvn2T+EMxnWIur1PzK/KBP9eVNu1SG0k74rYBXWPTl407G0innOBdc88bSLfSo5I8ibLLB0bJHEsgyvpmEMTDCnu75EFuiTqvFaQOOHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d81a0224e7so83022535ab.3
        for <kvmarm@lists.linux.dev>; Mon, 12 May 2025 09:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747068384; x=1747673184;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e79DEBw39ni0myLiGMqi2od8L0GXfqigIyanB8qli9w=;
        b=wgnei+A50Iv9uVpaxUF5anybXZCBBDn0ayqZg3idvwEy6fJkx07jOWeqfbeHmvM3h8
         qF4TcwgqBOlROkHLhV6Gqu8lGap0oBZCWNarrnT66qtiNHjB0e/ibpHk0Rl8KzWH1gkO
         EZt+pIczuM7hL/99bhiEjl7y9QXwNmgjVhM0GuPLaO73insP3/KBisdGR6JtRlTn3NOE
         RZh/bKo+ZJ4TvguURvPGBLLbloTRwK4LqN9yll/ZuY3B3qqBFQJPKi+L2CyG1ydQ/i2k
         yxVwNL2p4SMSBLU+t0hK0KF/ixIwJIvyCe/ljC4E3xp9es/j1+IoE0k/U3HAUiDuC7zZ
         2UHQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2J/9vtksv8PLsbWQ/dBwshb92eZPxF6mwlAbsDMvGI82xC7NMe258IdoBWXB6U3944ClHwHY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuUm5iMnFUJFCGhXFKF85incB8YgJlgBa5uav7c8nsz0c4q5xS
	VgC5c7DhutdBfOKe4OJMjJqQ3v7HzCXaWi+dvn8Owtk9DNv/4tsbVHVkuLvdoXvG7k/oeGg4dfr
	9s9RoDy5yyV44/JwAH8jOAbIQDk4Q5O58I47N10NfMjyFyiR5sYgXoD4=
X-Google-Smtp-Source: AGHT+IFXNBCoJpWUIqc40y4go3YSzmW9SL0u3Q96FgkKvHitoh8WNiTMksarST9yKwP7q5T4iCwsN4hbe1ibq60vt4FXo0QMpcSz
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:154e:b0:3d8:2187:5cea with SMTP id
 e9e14a558f8ab-3da7e1e6257mr169782655ab.1.1747068384389; Mon, 12 May 2025
 09:46:24 -0700 (PDT)
Date: Mon, 12 May 2025 09:46:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <682225e0.050a0220.f2294.0075.GAE@google.com>
Subject: [syzbot] [kvmarm?] KASAN: invalid-access Read in kvm_vgic_set_owner
From: syzbot <syzbot+9993ad918a0b1c0af91c@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, 
	syzkaller-bugs@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c4e91ea0cc7e Merge branch kvm-arm64/misc-6.16 into kvmarm-..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
console output: https://syzkaller.appspot.com/x/log.txt?x=10f27768580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2f705363127f7638
dashboard link: https://syzkaller.appspot.com/bug?extid=9993ad918a0b1c0af91c
compiler:       Debian clang version 20.1.3 (++20250415083350+2131242240f7-1~exp1~20250415203523.103), Debian LLD 20.1.3
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-c4e91ea0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7ecf29c15547/vmlinux-c4e91ea0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/59a7b6f25d98/Image-c4e91ea0.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9993ad918a0b1c0af91c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: invalid-access in __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
BUG: KASAN: invalid-access in _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spinlock.c:162
Read of size 1 at addr 00000000000013c8 by task syz.0.1041/7144

CPU: 0 UID: 0 PID: 7144 Comm: syz.0.1041 Not tainted 6.15.0-rc4-syzkaller-gc4e91ea0cc7e #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_report+0x5c/0xa0 mm/kasan/report.c:524
 kasan_report+0xb0/0x110 mm/kasan/report.c:634
 __kasan_check_byte+0x3c/0x54 mm/kasan/common.c:557
 kasan_check_byte include/linux/kasan.h:399 [inline]
 lock_acquire+0xb0/0x2e0 kernel/locking/lockdep.c:5840
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spinlock.c:162
 kvm_vgic_set_owner+0x18c/0x294 arch/arm64/kvm/vgic/vgic.c:611
 timer_irqs_are_valid arch/arm64/kvm/arch_timer.c:1573 [inline]
 kvm_timer_enable+0x1c4/0x794 arch/arm64/kvm/arch_timer.c:1631
 kvm_arch_vcpu_run_pid_change+0x1f0/0x458 arch/arm64/kvm/arm.c:857
 kvm_vcpu_ioctl+0xae8/0xc24 virt/kvm/kvm_main.c:4381
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl fs/ioctl.c:892 [inline]
 __arm64_sys_ioctl+0x18c/0x244 fs/ioctl.c:892
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x90/0x2b4 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x180/0x2f4 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x58/0x74 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x134 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
==================================================================
Unable to handle kernel paging request at virtual address ffef80000000013b
KASAN: maybe wild-memory-access in range [0xff000000000013b0-0xff000000000013bf]
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[ffef80000000013b] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 7144 Comm: syz.0.1041 Tainted: G    B               6.15.0-rc4-syzkaller-gc4e91ea0cc7e #0 PREEMPT 
Tainted: [B]=BAD_PAGE
Hardware name: linux,dummy-virt (DT)
pstate: 604020c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : debug_spin_lock_before kernel/locking/spinlock_debug.c:86 [inline]
pc : do_raw_spin_lock+0x4c/0x2b4 kernel/locking/spinlock_debug.c:115
lr : __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:111 [inline]
lr : _raw_spin_lock_irqsave+0x64/0x7c kernel/locking/spinlock.c:162
sp : ffff8000a8ef7930
x29: ffff8000a8ef7940 x28: ddf00000139057c0 x27: ddf0000013906c30
x26: 0000000000000001 x25: ddf0000013906e10 x24: 0000000000000010
x23: a3ff8000a91ee000 x22: ddf00000139057c0 x21: ffff8000801fd8a4
x20: 00000000000013b0 x19: efff800000000000 x18: 00000000000000ff
x17: 000000000000001f x16: 00000000000000fe x15: 0000000000000000
x14: 0000000000000000 x13: 00000000ffffffff x12: 0000000000000002
x11: 0000000000000001 x10: 0ff000000000013b x9 : 0000000000000000
x8 : 00000000000013b4 x7 : ffff8000870a9afd x6 : ffff800086582ed8
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff8000802a42dc
x2 : 0000000000000001 x1 : 0000000000000000 x0 : 00000000000013b0
Call trace:
 debug_spin_lock_before kernel/locking/spinlock_debug.c:86 [inline] (P)
 do_raw_spin_lock+0x4c/0x2b4 kernel/locking/spinlock_debug.c:115 (P)
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:111 [inline]
 _raw_spin_lock_irqsave+0x64/0x7c kernel/locking/spinlock.c:162
 kvm_vgic_set_owner+0x18c/0x294 arch/arm64/kvm/vgic/vgic.c:611
 timer_irqs_are_valid arch/arm64/kvm/arch_timer.c:1573 [inline]
 kvm_timer_enable+0x1c4/0x794 arch/arm64/kvm/arch_timer.c:1631
 kvm_arch_vcpu_run_pid_change+0x1f0/0x458 arch/arm64/kvm/arm.c:857
 kvm_vcpu_ioctl+0xae8/0xc24 virt/kvm/kvm_main.c:4381
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl fs/ioctl.c:892 [inline]
 __arm64_sys_ioctl+0x18c/0x244 fs/ioctl.c:892
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x90/0x2b4 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x180/0x2f4 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x58/0x74 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x134 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
Code: d344fd4a aa0003f4 f90007e9 d378fd09 (386a6a6a) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	d344fd4a 	lsr	x10, x10, #4
   4:	aa0003f4 	mov	x20, x0
   8:	f90007e9 	str	x9, [sp, #8]
   c:	d378fd09 	lsr	x9, x8, #56
* 10:	386a6a6a 	ldrb	w10, [x19, x10] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
