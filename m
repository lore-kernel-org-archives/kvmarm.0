Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E0A183088
	for <kvmarm@lists.linux.dev>; Thu, 14 Nov 2024 17:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731605731; cv=none; b=V9xLIbtIm1K4Enx+hEqWevs1V2wsrsXQNXI1luRxWTiI77+tgtvwp2ask9dLCxpt1E+zKzLOYVosRaOqeh/6bFHE4fma7UHRlESaX+0rMHrbszW7ybBBcUCRnk523cDXNB/x9MvSPJH96znvZgIau2oYbznoTKfMkVWsjWTzHLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731605731; c=relaxed/simple;
	bh=Ab+hbDx1HOm+gPbFqo7xK/IqBtFRAEyTfyNj/UbjaXQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EIokJNONb1ea/JXYSTeZVXSJePa5M+sny4/KpFRiZdc/wL00u2qR3x1BLGEIo+y1y9EW5zU7ZV8ET2/bABvvSFCpjpj7v0gs1RMtiqWAtNnU77ytDMh3eANg+mRSu3g/HjIb5FnKy2T2XrIfUIHQVMd+Agj62b5TEeob8cB7uiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83ab4cadf05so90892039f.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Nov 2024 09:35:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731605729; x=1732210529;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PyBn26mUePqthY9XrpQhwn7miJxqIZLoeEl6nlPcolo=;
        b=Pwi3rct34+DG+WYyfkHU5Jz/d6kQ9U6INST3LVKiI6cHiieNWp2OkwN/XkNnUlvKC0
         DV9WhtiBppVJ6xmVPatTaJN7N5UbG51LNuqPi4i+wgx77qp1JnOVDKuP5HybGrLEg6e/
         lFCKw7uKkjmc9Eezzy+OvadmVOuC0C7gViE95ctq1DNo3ZUf/WDlr3F5zD+ZIidprYdb
         RJYlSfTmRKXN0JMFYk50azhD++/WYPy4EbtuhMBwOWybUn9KLlbG292lmjxRc9HTuzAK
         0FOmI/Kee7ejz4i5i5Ui92Netkbfsh96IX1DV7nM0aLXdPDBb0RXHf8tOwiVCms0w8pT
         UWHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWA/HDLJ2uC7MdI7Ng6pyGnvJCWONxYI0e1QDO8aZgSqiNLhKUien0BbTyuRww4VEwQEl8TNcc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUBZjN3LrgU3++qlRO9rl9IJ9aciKF7brIUKJrJALu/tlPXNPh
	fEkch5CHw06/hzAssTHsOP1z2STmtFbbGQlOLl81lggCwnu9+fEDj53jD28+889NQunG3OGsbxP
	47DfvfjRnNpgjTnFnx1WL7WVtRExkiF5ahduKhqUnBrJ4WBA4bN5uKu0=
X-Google-Smtp-Source: AGHT+IGArfQl0h1dH8qLIGSN+m5H0UpJUvpQ7t2lE3lgEmpmzkn62NzkZK3va21oObzriu4b26lvMeqFvzxzKH2wLjKKv0K7GlhR
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2181:b0:3a6:f349:71e6 with SMTP id
 e9e14a558f8ab-3a71fec44f3mr31321115ab.22.1731605728729; Thu, 14 Nov 2024
 09:35:28 -0800 (PST)
Date: Thu, 14 Nov 2024 09:35:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673634e0.050a0220.1324f8.009d.GAE@google.com>
Subject: [syzbot] [kvmarm?] WARNING in kvm_handle_mmio_return
From: syzbot <syzbot+4727d10d6a805738b0f2@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, 
	syzkaller-bugs@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2d5404caa8c7 Linux 6.12-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1393335f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0d77fb8077b4744
dashboard link: https://syzkaller.appspot.com/bug?extid=4727d10d6a805738b0f2
compiler:       aarch64-linux-gnu-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1793335f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144ff4e8580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/384ffdcca292/non_bootable_disk-2d5404ca.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9fafeb95420d/vmlinux-2d5404ca.xz
kernel image: https://storage.googleapis.com/syzbot-assets/498f7a357ea2/Image-2d5404ca.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4727d10d6a805738b0f2@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3270 at arch/arm64/include/asm/kvm_emulate.h:536 kvm_handle_mmio_return+0x1b4/0x1f4 arch/arm64/kvm/mmio.c:99
Modules linked in:
CPU: 0 UID: 0 PID: 3270 Comm: syz-executor447 Not tainted 6.12.0-rc7-syzkaller #0
Hardware name: linux,dummy-virt (DT)
pstate: 61400009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : kvm_incr_pc arch/arm64/include/asm/kvm_emulate.h:536 [inline]
pc : kvm_handle_mmio_return+0x1b4/0x1f4 arch/arm64/kvm/mmio.c:118
lr : kvm_arch_vcpu_ioctl_run+0x1ac/0x854 arch/arm64/kvm/arm.c:1135
sp : ffff800088e33ab0
x29: ffff800088e33ab0 x28: f6f0000005b35b40 x27: 0000000000000000
x26: 0000000000000000 x25: fbf00000073d8048 x24: fbf00000073d8000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: f3f000000664a000 x19: fbf00000073d8000 x18: ffffffffffffffff
x17: 0000000000000000 x16: 0000000000000000 x15: ffff800088e33aa0
x14: ffff800088e33d88 x13: ffff800088e33d4a x12: 6d766b3a65646f6e
x11: 0000000000000000 x10: 0000000000000078 x9 : 000000000000000c
x8 : ffff800088e33d98 x7 : 0000000000000000 x6 : 0000000000005452
x5 : 0000000000000005 x4 : f0f00000060bd300 x3 : f6f0000005b35b40
x2 : 0000000000000000 x1 : 0000000093c18046 x0 : 0000000000000001
Call trace:
 kvm_handle_mmio_return+0x1b4/0x1f4 arch/arm64/kvm/mmio.c:99
 kvm_arch_vcpu_ioctl_run+0x1ac/0x854 arch/arm64/kvm/arm.c:1135
 kvm_vcpu_ioctl+0x294/0xa04 virt/kvm/kvm_main.c:4475
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __arm64_sys_ioctl+0xac/0xf0 fs/ioctl.c:893
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x48/0x110 arch/arm64/kernel/syscall.c:49
 el0_svc_common.constprop.0+0x40/0xe0 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x1c/0x28 arch/arm64/kernel/syscall.c:151
 el0_svc+0x30/0xdc arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x100/0x12c arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x19c/0x1a0 arch/arm64/kernel/entry.S:598
---[ end trace 0000000000000000 ]---


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
