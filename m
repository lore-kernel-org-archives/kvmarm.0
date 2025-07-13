Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08EB367
	for <kvmarm@lists.linux.dev>; Sun, 13 Jul 2025 00:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752365192; cv=none; b=c2NdDh4oH6pVsoGdQooE76bvKK6M/wc/6FwCQpJq7qGdYZSW8WBpe3BCkSNH3RjluTmd+LlvZx4mnERG06R3ZF09/G8IqhpFmBkzK8glFFB/s3ru8Azveb6pKVgRgIpCIMx3GRBO9kinurbLlw74+yzSNkb/0NUHdp4gyMl18io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752365192; c=relaxed/simple;
	bh=RLcc0Wj2INa2UMJvTZx9UGOp5v0TPjwea3ZG+MHYAuY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dXnMGTF57S5ddSpJPsjdr+RrMbcnsLJtE4mPxuX2q1sxbCTeiJdlvbFY1xsCuvvcqSn2mmPWmO/Mhs8LkJXpDKrdkDS8z15ccil1IdJfkgP5ln8gDrog2DyhrxNi42ri81eQ0k+Jj9dLirVrBfaByMM2xkHJ5xDbY6hxQuF1jNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-86cf753423cso290212239f.3
        for <kvmarm@lists.linux.dev>; Sat, 12 Jul 2025 17:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752365190; x=1752969990;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ea3qbdppzHtrp+OgojMx38Fd+crkA6AwPr5+Agag3ZU=;
        b=tJBMXyhFPPxxG1NvgNLOiTMLdWx8KIVCBV8fZzjX677XXnWQQIdm3JfB5BOs9NedPg
         UZNpFK8hmUhWgeQueqyX5CAsfllpD3jOGt+ikC04ZBGnG54m/HOd5pBMYFlBnAT2tk9c
         yrcqgiXaUAiDXNQTByVpKqk4/TVASnyqjJ0QMKIo+G5YnpJdZCQhcQXLhmpv+4q8QiXF
         1V6y1vNUYXnHaXecMdyxuG3wx5dVTkOleCZW/61fwlLP3fWw8uLwqq60EZZRccDN2J3o
         gxBz2zxIn0lBs3juJrkCSNAKb67hzGXD/6B8BgSQoDUSd9CfCZctR6s/Qy2tnD/1Rq9I
         JtdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAY83gESS584Yezn7Bhfv+lJumDtHUQehrxlFn41mLkp96js9BabzR7R/QAUI5mF+38EbsXBI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsldJTEg+6whmiBnw6UcdK+kzaLCEOoe5REynuGr+EcqViBq48
	KeOM5OzDMaq1IlXuLZjS1I+OceSkRz2gGh9oeFKN727abe8va7ED6ojrZ9jsnW8RBcpbcv8cMhT
	YceqlERmdXEWEo6qPNxbpReVQrVykIqwlWxaPMbRwQHnUbAbjMewc7lJf7Cg=
X-Google-Smtp-Source: AGHT+IEn2iy03zAoER7fhAagB2X3tgSkQ4pMNqBWX0o7nANF/t35cPk7BhMK5Uk659GNlsCe1vfG1R/XR9Km2pqB+RIvXdMOiW6X
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4010:b0:86d:71:d9a with SMTP id
 ca18e2360f4ac-879787b862emr869201339f.2.1752365190087; Sat, 12 Jul 2025
 17:06:30 -0700 (PDT)
Date: Sat, 12 Jul 2025 17:06:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6872f886.a70a0220.3b380f.000d.GAE@google.com>
Subject: [syzbot] [kvmarm?] WARNING in pend_serror_exception
From: syzbot <syzbot+1f6f096afda6f4f8f565@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, 
	syzkaller-bugs@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    15724a984643 Merge branch 'kvm-arm64/doublefault2' into kv..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
console output: https://syzkaller.appspot.com/x/log.txt?x=123090f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82bd3cd421993314
dashboard link: https://syzkaller.appspot.com/bug?extid=1f6f096afda6f4f8f565
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1324fe8c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1206ed82580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-15724a98.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ec0f03d375a1/vmlinux-15724a98.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a36232f8c6dd/Image-15724a98.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1f6f096afda6f4f8f565@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3603 at arch/arm64/kvm/inject_fault.c:71 pend_serror_exception+0x19c/0x5ac arch/arm64/kvm/inject_fault.c:71
Modules linked in:
CPU: 0 UID: 0 PID: 3603 Comm: syz.2.16 Not tainted 6.16.0-rc3-syzkaller-g15724a984643 #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
pstate: 81402009 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : pend_serror_exception+0x19c/0x5ac arch/arm64/kvm/inject_fault.c:71
lr : pend_serror_exception+0x19c/0x5ac arch/arm64/kvm/inject_fault.c:71
sp : ffff80008e807930
x29: ffff80008e807930 x28: d7f0000016ae8028 x27: 0000000000000001
x26: 0000000000000000 x25: 0000000000000001 x24: 00000000000000d7
x23: d7f0000016ae82a8 x22: 00000000000000d7 x21: d7f0000016ae8e81
x20: 0000000000000007 x19: efff800000000000 x18: 0000000000000000
x17: 000000000000005a x16: ffff800080011d9c x15: 0000000020000200
x14: ffffffffffffffff x13: 0000000000000028 x12: 0000000000000081
x11: 81f000001f049564 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : 81f000001f048000 x7 : ffff800080b08704 x6 : ffff80008e807a88
x5 : ffff80008e807a88 x4 : 0000000000000001 x3 : ffff8000801a2e80
x2 : 0000000000000000 x1 : 0000000000000002 x0 : 0000000000000000
Call trace:
 pend_serror_exception+0x19c/0x5ac arch/arm64/kvm/inject_fault.c:71 (P)
 kvm_inject_serror_esr+0x274/0xe40 arch/arm64/kvm/inject_fault.c:330
 __kvm_arm_vcpu_set_events+0x1d4/0x238 arch/arm64/kvm/guest.c:-1
 kvm_arm_vcpu_set_events arch/arm64/kvm/arm.c:1698 [inline]
 kvm_arch_vcpu_ioctl+0xed8/0x16b0 arch/arm64/kvm/arm.c:1810
 kvm_vcpu_ioctl+0x5c4/0xc2c virt/kvm/kvm_main.c:4632
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __arm64_sys_ioctl+0x18c/0x244 fs/ioctl.c:893
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x90/0x2b4 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x180/0x2f4 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x58/0x74 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x160 arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp: 2728
hardirqs last  enabled at (2727): [<ffff80008653cb88>] __raw_read_unlock_irqrestore include/linux/rwlock_api_smp.h:241 [inline]
hardirqs last  enabled at (2727): [<ffff80008653cb88>] _raw_read_unlock_irqrestore+0x44/0xbc kernel/locking/spinlock.c:268
hardirqs last disabled at (2728): [<ffff800086517e08>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:511
softirqs last  enabled at (2702): [<ffff8000800c988c>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (2700): [<ffff8000800c9858>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
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
