Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0021417A2E6
	for <kvmarm@lists.linux.dev>; Sat, 15 Nov 2025 18:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763233162; cv=none; b=akwL2Jpg9eEfHL5FBy+X+rHykxtMzxXKqZgwWFgUlS4y+SvcgNvBja7Uu7ihxONije+V6AghqJx/IPeyNwVAsVCCkLYydPDVbfQNDpMVwNb8Zt8YpefGzKMGhYXc60TpYXtUxblq7YnByuXv5LISjhTBZ4P32ka2S9mkkuOVbhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763233162; c=relaxed/simple;
	bh=+2kYoRGpLw7If+rQuosRU2cnJ4zLJfAp8kL+kRt2EKw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=biOh0ucDN0GfzHiqDmbcNQgV2EsEs6M9Wo8mq9Ovdadid0NzDOnpdmgibDFIqHFGpzEDMQGgtMXxh3xFZTgAwMiGSbfh5VWH5mT39JWOINJ5DAF3AQGmC6NaUNWZMALnUaWlVF3weoDjkDDp7jyRY7lkRnr3JpHbbJG9s+eFDZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-4337e902d2bso28822195ab.3
        for <kvmarm@lists.linux.dev>; Sat, 15 Nov 2025 10:59:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763233160; x=1763837960;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hh84L/w/M4L5E9rl0NqJcCUd9TshzOxlJPaXwCeAvmw=;
        b=C9Ty3G70NV6NQV/Czo7k6/m5BedM3eUTB8iqjSu7KVWz6+e/FhpkZwhjM9W4YLBemg
         ZA8bUpYgzPLxjtOW1mrpVq+EiVA0/TWrNRvJVmirE5/nBWwFqJsOxHkQsuZdy5wJGMv+
         DWdzBLU2rtfp9kk0VwOmfczAe+oYFAsn52g5ptBcX6A1ELGgZOVG55X7ytx2vp1fZK6P
         4OFZS2f+yLBsRDuhmT3Fxn6/1CfesNxNH0gJVoJsEqtiTTx6z+T5iJiK/JV40vdzE+Dy
         nTB10NPqGXJORzLkdaRQcPucS6YDYvQ9cXCO1IkLLRAZbYERhMlmOnx7j8JUtm37ypbI
         YpcQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/VzSgRKvGekQqp1kMNiRJrzMp2cnUfAWTMmgpKC9DxgN85Va1AMjSWeBjk9umiHSMHkpcwJE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSjGj4wXwk+8HF4wmckMwL7sM2JSYLGmO1kDorR7epOxEiZ67q
	GbSLTxsz+yPse37oHsJNpL9l3xAGDx8894XBL+ffTIbPCYGyGWa2D5X9dQB8oeZI9l6nUBAElCX
	zqCaEn/UhFnnQpxWExTbR3co7WodDmjjYIHRAPZEmp4GD08lqoq9Cjuy9+fc=
X-Google-Smtp-Source: AGHT+IGAjUvEoAFE5aGheWc9M4XVW88LXL6etrr+P8QM9EJ8eCbbKXLDOA9ojzUpcKBx8dfM+EIEwdm7N+3dwWg4mQ1Ob7M0Ai2M
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:188f:b0:432:f3b:a809 with SMTP id
 e9e14a558f8ab-4348c94e420mr103669645ab.26.1763233160174; Sat, 15 Nov 2025
 10:59:20 -0800 (PST)
Date: Sat, 15 Nov 2025 10:59:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6918cd88.050a0220.1c914e.0044.GAE@google.com>
Subject: [syzbot] [kvmarm?] WARNING in kvm_set_vm_id_reg
From: syzbot <syzbot+c4aef6558d0cd90fe378@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, oupton@kernel.org, 
	suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7a0892d2836e Merge tag 'pci-v6.18-fixes-5' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12c56884580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bbf220ce32df0361
dashboard link: https://syzkaller.appspot.com/bug?extid=c4aef6558d0cd90fe378
compiler:       aarch64-linux-gnu-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=139c77cd980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d6a914580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-7a0892d2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e83411b74df6/vmlinux-7a0892d2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/135caed64c95/Image-7a0892d2.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c4aef6558d0cd90fe378@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3583 at arch/arm64/kvm/sys_regs.c:2353 kvm_set_vm_id_reg+0x60/0xf4 arch/arm64/kvm/sys_regs.c:2348
Modules linked in:
CPU: 1 UID: 0 PID: 3583 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
pstate: a1402009 (NzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : kvm_set_vm_id_reg+0x60/0xf4 arch/arm64/kvm/sys_regs.c:2353
lr : kvm_finalize_sys_regs+0x88/0x244 arch/arm64/kvm/sys_regs.c:5616
sp : ffff800089543ab0
x29: ffff800089543ab0 x28: f6f00000121c12c0 x27: 0000000000000000
x26: 0000000000000000 x25: f1f00000085d8000 x24: 0000000000000000
x23: f1f00000085d8048 x22: 0000000000000000 x21: f9ff800083e0dbd0
x20: f9ff800083e0d000 x19: f1f00000085d8000 x18: 00000000ffffffff
x17: 0000000000000000 x16: 0000000000000000 x15: ffff800089543a90
x14: ffff800089543d98 x13: ffff800089543d5a x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000078
x8 : ffff800089543da8 x7 : f0f0000004469ffc x6 : 0000000000000077
x5 : f6f00000121c12c0 x4 : 0000000000000001 x3 : f9ff800083e0dd18
x2 : 1101001020110222 x1 : 0000000000000000 x0 : f9ff800083e0d000
Call trace:
 kvm_set_vm_id_reg+0x60/0xf4 arch/arm64/kvm/sys_regs.c:2348 (P)
 kvm_finalize_sys_regs+0x88/0x244 arch/arm64/kvm/sys_regs.c:5616
 kvm_arch_vcpu_run_pid_change+0x8c/0x36c arch/arm64/kvm/arm.c:857
 kvm_vcpu_ioctl+0x7f8/0x878 virt/kvm/kvm_main.c:4464
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0xac/0x104 fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x48/0x110 arch/arm64/kernel/syscall.c:49
 el0_svc_common.constprop.0+0x40/0xe0 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x1c/0x28 arch/arm64/kernel/syscall.c:151
 el0_svc+0x34/0x10c arch/arm64/kernel/entry-common.c:746
 el0t_64_sync_handler+0xa0/0xe4 arch/arm64/kernel/entry-common.c:765
 el0t_64_sync+0x1a4/0x1a8 arch/arm64/kernel/entry.S:596
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
