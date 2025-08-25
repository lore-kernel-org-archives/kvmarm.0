Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA10287257
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 21:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756156123; cv=none; b=lhFLynpyyNKBBdj1vfSjMTceNjCC2j6C3L32BuTmjfB+K4ofvHABhEm3iVwbOvUokFc+WqcpWaJoX0c6sCEIsf7t3xSRq5CXvNy0pjxI6yYnGxDAmi0epXY4podOybgY0thlobnKOKptW0cz4qhKgN0JQPC8ZP/xKUh0Q7tu6IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756156123; c=relaxed/simple;
	bh=YbedgNfWinZDDzvHEt14s6YkMLvqG6IdVtI4JF3YddI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XPeRD/thA+K3q3jirKYSN6nKaLvE/vhxag4TiJHHEyW2H1IRZw/73xp4FnqCb9qeR6YnwA2NJrR2oMbLbC9FHw77lSYkKQVD1wkQpQgLritmruAhaLh/blUSHQQUB2yHJ9bxaPKHH3QIWoir4PW2VJYWBYv/Vd5+pM6KVqXUktk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3eea931c037so668945ab.0
        for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 14:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756156121; x=1756760921;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BqZ4/31f0Gtlx5+7VYAHWFz+uBSEbjWh2SiS3l8pvq8=;
        b=LeuJk/2AO9/tH1ywdVnRH8+9ceZMaYRzXRRWiUE9G55V292enBWdHA3febKTJxdJLK
         enmwuSUEAbIm5HTuPaO+QPfUMbORfj4jJiFsxGdLWskdxd8M2hFRndgXKYxYmyiLWBBe
         Kv6DMc7Rj3k7O2s9w6KUtqgdbo0nejM1vkLVB1aYx2LcRJxcpACcQ2XQlMuMmPKvh8sX
         NZAlbLV4O3g8bYlISq4WFQiJABpD4Nu+m8Ujf+Gl3TBe3JwadqnYy/Ob/MN8C5JuDwvN
         CNIQS+pt2t4+d3z4NLmMx2ZBNdfXNxSIeDU29NAoiq4F+64T6ixn8iPAv8VIGLCZQ2xI
         FijA==
X-Forwarded-Encrypted: i=1; AJvYcCWswxn8CpztP44wh2qdrYAOUaQuPMZualhzyDRepX5hvvTiktrK5OxU9OGLo8Jxik53y0X46tw=@lists.linux.dev
X-Gm-Message-State: AOJu0YywoXmBXi6al/CwgQOp/+w0spHbMlNDQI0Y9Re9KzM4Z+c+lQ4V
	JWhYRAUFhjvUhp8BvFEhIg2XZgLWksJk38w6/tsZT+sFJZP9YBzRPkn731c6t3+JNkXYrOq//aU
	BoeV2JL7XwcKZIl9pWJA4QuJuGae80oinDPMRM7iGV8RSspjGiJJVx8dRz6U=
X-Google-Smtp-Source: AGHT+IGpS1LzWvp0I6RmvMl/qq93Vsp8qCYZ44qc949rEp5qDgNdDz744+IAFZov/EbEy+xcBL5nFoRh5qOVdUWsvpJwmA8GhIZ1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe1:b0:3e5:7e26:2f90 with SMTP id
 e9e14a558f8ab-3e922504b72mr209775655ab.24.1756156121309; Mon, 25 Aug 2025
 14:08:41 -0700 (PDT)
Date: Mon, 25 Aug 2025 14:08:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68acd0d9.a00a0220.33401d.048b.GAE@google.com>
Subject: [syzbot] [kvmarm?] [kvm?] WARNING: locking bug in vgic_put_irq
From: syzbot <syzbot+cef594105ac7e60c6d93@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7b8346bd9fce KVM: arm64: Don't attempt vLPI mappings when ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
console output: https://syzkaller.appspot.com/x/log.txt?x=17b4e862580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7c53d3478750eda0
dashboard link: https://syzkaller.appspot.com/bug?extid=cef594105ac7e60c6d93
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15860634580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1074e862580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-7b8346bd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/74f545807499/vmlinux-7b8346bd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d83062566dc7/Image-7b8346bd.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cef594105ac7e60c6d93@syzkaller.appspotmail.com

=============================
[ BUG: Invalid wait context ]
6.16.0-rc3-syzkaller-g7b8346bd9fce #0 Not tainted
-----------------------------
syz.0.29/3743 is trying to lock:
a3ff80008e2e9e18 (&xa->xa_lock#20){....}-{3:3}, at: vgic_put_irq+0xb4/0x190 arch/arm64/kvm/vgic/vgic.c:137
other info that might help us debug this:
context-{5:5}
3 locks held by syz.0.29/3743:
 #0: a3ff80008e2e90a8 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vgic_destroy+0x50/0x624 arch/arm64/kvm/vgic/vgic-init.c:499
 #1: a3ff80008e2e9fa0 (&kvm->arch.config_lock){+.+.}-{4:4}, at: kvm_vgic_destroy+0x5c/0x624 arch/arm64/kvm/vgic/vgic-init.c:500
 #2: 58f0000021be1428 (&vgic_cpu->ap_list_lock){....}-{2:2}, at: vgic_flush_pending_lpis+0x3c/0x31c arch/arm64/kvm/vgic/vgic.c:150
stack backtrace:
CPU: 0 UID: 0 PID: 3743 Comm: syz.0.29 Not tainted 6.16.0-rc3-syzkaller-g7b8346bd9fce #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4833 [inline]
 check_wait_context kernel/locking/lockdep.c:4905 [inline]
 __lock_acquire+0x978/0x299c kernel/locking/lockdep.c:5190
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5871
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spinlock.c:162
 vgic_put_irq+0xb4/0x190 arch/arm64/kvm/vgic/vgic.c:137
 vgic_flush_pending_lpis+0x24c/0x31c arch/arm64/kvm/vgic/vgic.c:158
 __kvm_vgic_vcpu_destroy+0x44/0x500 arch/arm64/kvm/vgic/vgic-init.c:455
 kvm_vgic_destroy+0x100/0x624 arch/arm64/kvm/vgic/vgic-init.c:505
 kvm_arch_destroy_vm+0x80/0x138 arch/arm64/kvm/arm.c:244
 kvm_destroy_vm virt/kvm/kvm_main.c:1308 [inline]
 kvm_put_kvm+0x800/0xff8 virt/kvm/kvm_main.c:1344
 kvm_vm_release+0x58/0x78 virt/kvm/kvm_main.c:1367
 __fput+0x4ac/0x980 fs/file_table.c:465
 ____fput+0x20/0x58 fs/file_table.c:493
 task_work_run+0x1bc/0x254 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x1b4/0x270 arch/arm64/kernel/entry-common.c:151
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
 el0_svc+0xb4/0x160 arch/arm64/kernel/entry-common.c:768
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600


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
