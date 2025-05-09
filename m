Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9019D28936C
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 12:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746795089; cv=none; b=VV98hGKuXEFGoLhx7bCWDy4AxsUA/LX8DufctRGUnyT4cw/b09jAL3IAzYPzJ49+0IcAGSXkQTEW+czvhZIG86WAmR38i+I3zyotq2J/3BXX1E3It04j/y7461nrWpfr/MCnqbNdJUudsA6VBImXYvQv+g3D6+05tjyhfF5jbFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746795089; c=relaxed/simple;
	bh=KQr0CIxMUynjnn6HMhNK32temHKAByuymxyW2dFzLxE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tWd62275i3ebeD+iZiPD1e2XKfaGEyfyYfmdjvYiB53Xa4nQf5AsN3g2ODp92DoysDc209Ecw2XNMLBRlh0ZKExSbhLJ+b6t62LwAqUqpb9EUmClekQhd4BJHPxLOgKkeHKLKS7HrUbfP7E7yqZg6BK0wsi1c9zIgznNta8QryM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3da7584d3baso23677645ab.1
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 05:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746795086; x=1747399886;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nKYKV/yff+j42RTk2qZcwb9+n6iBZSUwVqOYZn/7YK0=;
        b=sRG7W8UvmkfoEm7Z/Kx4D84WxUpdEK6iswgnhkciQT0nPySR6SHL0yNRGA/OkOl9gY
         /HDHg6f6Ngxyy8qjQ0yYmcfq9EluRQ/TxIVpOyugT4ZGINlp7x4n8X8KRyJw4SZ+EBE3
         VO/dqLkSGdn9Pg/jAgjZ0t4hDIfMlGmiJTYtn87p3Z/aNjZajsfiIkHN4LJtXS37r8bh
         yoasSwl7X89ujq/oNW8ylMYuAme9AEum/B6Ay8YVgDEwAjPkNBA5bK1zqHWAKb2ZOffT
         xj9JKraWPOCgW7Ivz0wzdZnZIWToLwPOCO59kHMNin6qq43jMqR9zbcVDD4hLK0KMlxl
         lZfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVv5+OU4vBU0M+wmOabIIzQ2hyLt5k7IZmXYX9/gwhPP4VKQPqZ3OajrxJ0r3ZQH8eIhhaLN1Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxvT9/QnJgZO4jY4Lnz+PapG+GR/boOYXs1WugZw8kVnvl+WKK
	01C5V/4Lqaw9B4VVGgclXGwdRpQNEUpdavv5Sae2KRUx1UfpsjyJ9G3Ra5ZHJSYQ7FLSdYqZfFh
	O1lhBY6mRRysHt6CdX2hhl5/31Fx3IxxtSXXWuegOp7c4wx0r1WWmzqw=
X-Google-Smtp-Source: AGHT+IFYT54CJFYDlmecRr9rSz4DarOdIA1mhDXTAdmBbLSjqE4WZorAtiD9t1T3wFZDmZRYb+cqJgK6Nkj+sDyZYG5aBS9iVnlj
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2509:b0:3d4:6ff4:261e with SMTP id
 e9e14a558f8ab-3da7e1645b1mr40251325ab.0.1746795086663; Fri, 09 May 2025
 05:51:26 -0700 (PDT)
Date: Fri, 09 May 2025 05:51:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <681dfa4e.050a0220.a19a9.0131.GAE@google.com>
Subject: [syzbot] [kvm?] [kvmarm?] BUG: unable to handle kernel paging request
 in vgic_its_save_tables_v0
From: syzbot <syzbot+4ebd710a879482a93f8f@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c4e91ea0cc7e Merge branch kvm-arm64/misc-6.16 into kvmarm-..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
console output: https://syzkaller.appspot.com/x/log.txt?x=11d634f4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2f705363127f7638
dashboard link: https://syzkaller.appspot.com/bug?extid=4ebd710a879482a93f8f
compiler:       Debian clang version 20.1.3 (++20250415083350+2131242240f7-1~exp1~20250415203523.103), Debian LLD 20.1.3
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1437c4d4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f84768580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-c4e91ea0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7ecf29c15547/vmlinux-c4e91ea0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/59a7b6f25d98/Image-c4e91ea0.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4ebd710a879482a93f8f@syzkaller.appspotmail.com

Unable to handle kernel paging request at virtual address ffef800000000001
KASAN: maybe wild-memory-access in range [0xff00000000000010-0xff0000000000001f]
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
[ffef800000000001] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 3370 Comm: syz-executor338 Not tainted 6.15.0-rc4-syzkaller-gc4e91ea0cc7e #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : vgic_its_save_ite arch/arm64/kvm/vgic/vgic-its.c:2145 [inline]
pc : vgic_its_save_itt arch/arm64/kvm/vgic/vgic-its.c:2248 [inline]
pc : vgic_its_save_device_tables arch/arm64/kvm/vgic/vgic-its.c:2394 [inline]
pc : vgic_its_save_tables_v0+0x3e0/0xe38 arch/arm64/kvm/vgic/vgic-its.c:2614
lr : compute_next_eventid_offset arch/arm64/kvm/vgic/vgic-its.c:2061 [inline]
lr : vgic_its_save_ite arch/arm64/kvm/vgic/vgic-its.c:2142 [inline]
lr : vgic_its_save_itt arch/arm64/kvm/vgic/vgic-its.c:2248 [inline]
lr : vgic_its_save_device_tables arch/arm64/kvm/vgic/vgic-its.c:2394 [inline]
lr : vgic_its_save_tables_v0+0x37c/0xe38 arch/arm64/kvm/vgic/vgic-its.c:2614
sp : ffff80008ecd7bf0
x29: ffff80008ecd7c70 x28: 66f00000123bb4f0 x27: 0000000000000000
x26: 000000000000002e x25: 00000000fffffdfd x24: ccf0000013a2ac40
x23: 66f00000123bb438 x22: edf0000013a2a4d0 x21: edf0000013a2a4d0
x20: cdf0000012236600 x19: efff800000000000 x18: 0000000000000000
x17: 0000000000000032 x16: ffff800080011d9c x15: 0000000020000300
x14: 0000000000000000 x13: fff0000015703b08 x12: 0ff0000000000001
x11: 0000000000000010 x10: 0000000000002000 x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff80008021fbf4 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080158ffc
x2 : ffff80008021fc70 x1 : edf0000013a2a4d0 x0 : 0000000000000000
Call trace:
 vgic_its_save_ite arch/arm64/kvm/vgic/vgic-its.c:2145 [inline] (P)
 vgic_its_save_itt arch/arm64/kvm/vgic/vgic-its.c:2248 [inline] (P)
 vgic_its_save_device_tables arch/arm64/kvm/vgic/vgic-its.c:2394 [inline] (P)
 vgic_its_save_tables_v0+0x3e0/0xe38 arch/arm64/kvm/vgic/vgic-its.c:2614 (P)
 vgic_its_ctrl arch/arm64/kvm/vgic/vgic-its.c:-1 [inline]
 vgic_its_set_attr+0x544/0x828 arch/arm64/kvm/vgic/vgic-its.c:2777
 kvm_device_ioctl_attr virt/kvm/kvm_main.c:4639 [inline]
 kvm_device_ioctl+0x354/0x418 virt/kvm/kvm_main.c:-1
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
Code: 9100412b b2481d69 d344fd2c d378fd69 (386c6a6c) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	9100412b 	add	x11, x9, #0x10
   4:	b2481d69 	orr	x9, x11, #0xff00000000000000
   8:	d344fd2c 	lsr	x12, x9, #4
   c:	d378fd69 	lsr	x9, x11, #56
* 10:	386c6a6c 	ldrb	w12, [x19, x12] <-- trapping instruction


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
