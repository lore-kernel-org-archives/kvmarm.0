Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8C81DF980
	for <kvmarm@lists.linux.dev>; Sat, 28 Feb 2026 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772279183; cv=none; b=JmtSuYUNQ3+cHL261EEfuqB1Cc5ynETYlda6PQ/xvPGBhvL61Tsc510oqHhYGFdYcIzZrteV7bGANXdpQGvTkKfITmN2QZvUFjacdtGR9AHqvKxgq2eFEE0TDvPMvvUsastceC3/kc57Ca5MrRQNkG5xDRavkPifmOk77ZpuQv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772279183; c=relaxed/simple;
	bh=V5nMKAigv3HCQsTyt/zrxEJeoGfpqosEiJVgKBWl6vc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PbT0pS3XtCbu+sd9O/KGT9zRAA/hmMN6R7yAr525NMhNRQ0ELuwFHtfM5vxGaAbj2MfiqJzoIDd4LXS0dfzlsTPO9I1pPlzr5VsnEaKrHuQd3fav5xb9ueJ8HHx/pesvH12mKqLxMktJBeRNFZD/uU6Ce/x69uJhlHkt4RG76VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679deba5e9fso28472165eaf.0
        for <kvmarm@lists.linux.dev>; Sat, 28 Feb 2026 03:46:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772279181; x=1772883981;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q8LuITVldGOlUNrpSliupPOmyqk5VihC4Ea6iAcEmgE=;
        b=vjKT9UUH3gyOw5V21jhar0B/IyyQo2hEi2+uM8unOxj5ORdYj4MVmpMafH22yMTNx8
         mt5gDasKgkDWJoSapjSIJWwknIJSPABS7aACCBDDzoPatElkSBzRsry+uyzP+e4RGFyI
         GzSy3NI9IgRRHh/e6skEEOKrfZDNRN6xTLYLxJH1tzUxAXk5zSNxxA3bKQa2dsehGgKh
         0eeH2teF0iq5ghVr2jROjMIC1keaEa9N2RPLlqttJ3hu1TihmVIqawXqjdbPYvBb090+
         tK+sEOYcxBxRWR5w0MHXTSzeeYnjkfIoj8gfczzQKkRrOzWlaLhQ1mEKAElTExXC0wam
         oTow==
X-Forwarded-Encrypted: i=1; AJvYcCUOQ+KsgbIDIy1JnX0AtW5KjtWU3qIlG0KFDVZRR8k90wXxVepxNtb9mRFCo/ZNndKkoqTaNEI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyC5+7rs6Qnfhcl+PGeeVU3EkB06G7YX9w48AtsBgQkbas+9eO8
	tXr38HZB6mEsx5lWyqnvztR1Eo8DdCZqUOXE+5mlWmpMYaQaJEZzN4ZKbUw/l/QP7EZHwS2S/lG
	8RH9PP7Xe3fzS8LCdIxpI7fUr9rWTTUprlf/fWNOHE+cuFNVZB6g3Q7hOQSA=
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2913:b0:679:e7b2:9fb8 with SMTP id
 006d021491bc7-679fadb8af6mr4205368eaf.14.1772279180960; Sat, 28 Feb 2026
 03:46:20 -0800 (PST)
Date: Sat, 28 Feb 2026 03:46:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a2d58c.050a0220.3a55be.003b.GAE@google.com>
Subject: [syzbot] [kvmarm?] [kvm?] BUG: unable to handle kernel paging request
 in kvm_vgic_destroy
From: syzbot <syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6316366129d2 Merge branch kvm-arm64/misc-6.20 into kvmarm-..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
console output: https://syzkaller.appspot.com/x/log.txt?x=15e59c4a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=148fc9aa8e041d0a
dashboard link: https://syzkaller.appspot.com/bug?extid=f6a46b038fc243ac0175
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13182006580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173900ba580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-63163661.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1018400deda3/vmlinux-63163661.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fb8a8bb5d8a4/Image-63163661.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com

 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x90/0x230 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x120/0x2f4 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x58/0x74 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x238 arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Unable to handle kernel paging request at virtual address ffef800000000000
KASAN: maybe wild-memory-access in range [0xff00000000000000-0xff0000000000000f]
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
[ffef800000000000] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 3651 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
pstate: 01402009 (nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : kvm_vgic_dist_destroy arch/arm64/kvm/vgic/vgic-init.c:445 [inline]
pc : kvm_vgic_destroy+0x2d4/0x624 arch/arm64/kvm/vgic/vgic-init.c:518
lr : kvm_vgic_dist_destroy arch/arm64/kvm/vgic/vgic-init.c:444 [inline]
lr : kvm_vgic_destroy+0x290/0x624 arch/arm64/kvm/vgic/vgic-init.c:518
sp : ffff80008e647b90
x29: ffff80008e647ba0 x28: 0000000000000005 x27: cdf00000200a52d8
x26: cdf00000200a4db0 x25: 00000000000000cd x24: cdf00000200a4d8c
x23: 00000000000000cd x22: 00000000000000cd x21: cdf00000200a4ad0
x20: efff800000000000 x19: cdf00000200a4000 x18: 00000000030f4b63
x17: 0000000000000031 x16: 0000000000000000 x15: ffff800088209a68
x14: ffffffffffffffff x13: 0000000000000028 x12: 5df000001795c1f0
x11: ffff800088209a68 x10: 0000000000ff0100 x9 : 0ff0000000000000
x8 : 0000000000000000 x7 : ffff80008672f958 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000002
x2 : 0000000000000008 x1 : 0000000000000000 x0 : 0000000000000007
Call trace:
 kvm_vgic_dist_destroy arch/arm64/kvm/vgic/vgic-init.c:445 [inline] (P)
 kvm_vgic_destroy+0x2d4/0x624 arch/arm64/kvm/vgic/vgic-init.c:518 (P)
 kvm_arch_destroy_vm+0x88/0x138 arch/arm64/kvm/arm.c:299
 kvm_destroy_vm virt/kvm/kvm_main.c:1317 [inline]
 kvm_put_kvm+0x778/0xbe0 virt/kvm/kvm_main.c:1354
 kvm_vm_release+0x58/0x78 virt/kvm/kvm_main.c:1377
 __fput+0x4ac/0x978 fs/file_table.c:468
 ____fput+0x20/0x58 fs/file_table.c:496
 task_work_run+0x1b8/0x250 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0x110/0x188 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 exit_to_user_mode_prepare_legacy include/linux/irq-entry-common.h:242 [inline]
 arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:81 [inline]
 el0_svc+0x17c/0x238 arch/arm64/kernel/entry-common.c:725
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: 54000420 b2481c28 d344fd09 d378fc28 (38696a89) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	54000420 	b.eq	0x84  // b.none
   4:	b2481c28 	orr	x8, x1, #0xff00000000000000
   8:	d344fd09 	lsr	x9, x8, #4
   c:	d378fc28 	lsr	x8, x1, #56
* 10:	38696a89 	ldrb	w9, [x20, x9] <-- trapping instruction


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
