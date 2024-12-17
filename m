Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48221DE3D7
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 09:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734428906; cv=none; b=I5FxOuixubbngFsrzSmMg1vLQj1pLhhUbFo0jfTruJm0cGRYESR/mUfWAsAGNGacTLzOJivTPULLCGipa5MHcFPHBb3M22+F70VGFo9AvMs9/xwbJ+rDrxWX0n2w9zZRryLdD+X7FZxZX7QkBTywGbM2PzPkB4KQEPeJ/yEw3jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734428906; c=relaxed/simple;
	bh=I0fyUejRXrcZeygj2FiK1acNIwCSe5DLIYY2zBUhphM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=byOMAjegSY+uYRLnQxoBMTWhZoIVVIF9bVjPQvzZLrQrf2J3nwIR0NkWp5lxQl6hsMOtoqKIVTDD9M93u7b89iadOrvamQRKWT2NGpPPjbR4qm8mNlD5xKfGf17uHEHCGCOzQS/dcIp68QZ2MvmRjgByhpTvSd3M2EBhRQMnd/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-845dee0425cso234004539f.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 01:48:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734428904; x=1735033704;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k7Ohw9FdZun9tCxVR+V58AxTTwpDnpaw4I4rebrkACs=;
        b=skYlOUShtF8+YRynCOPKCQBGORPvH7lHwMOI9Fu8hGm82fqexFiAc3kvPyGcLFonhk
         JtggbgpBS1WGrgvnBkaUbUFoL9DkYQONen7wdL4uLAwZWmJzV5zDQ0GUXlUSITedAWmS
         oIDH/ybp3YtC3FLhLgDefiC0/oiXUhvN7mRTJR3bnxef2kjk9HvONyUYp20QmSeXpiqH
         YsoVKXoJEDnh1b6wv5oV77aK+OWK46OvCruP8jpOro4qai2oD1csvk7ZP20gUWX97/aj
         +/AqKL5Z7jND0CR3N9Ds2GMVqGBCw5W6d6O0pdreGpQ1JaHw8yZ7Atje9p+WqDWAYxeX
         4htQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuU6Ci9km01X19EOYX+fJBf2bjK+/OXb6RCn5KCT7EN5DOz4pDrLa4DZQdJEkIxhHmdjQoWSc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3YmlEj+PJXT42UgrJ3EzJ9gPBK/b0+WyNB8YrgRZ/qBThF6LS
	L4PsG7O5/6t8dGDmzRzMSjjj6W9g7Je3Rk/EEKGz1iL0WjMCFpKkypC6jVj/JOQ13ijz4cGuWw1
	M4AyCjLt4tcysifbYMoj7FZFSsQ3jGVLDsakcg1xoUfiqsoknOL5xQnI=
X-Google-Smtp-Source: AGHT+IHI9tYk8oBynelfPrOkch9cOquRNVuGZrHan+16Hk0hGAubvsg8DCIGxrVhoM/XYZRyY38tAlmP5tjN4bfiN2UpHZ89frcW
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1905:b0:3a0:c820:c5f0 with SMTP id
 e9e14a558f8ab-3aff9256d09mr175850255ab.24.1734428904148; Tue, 17 Dec 2024
 01:48:24 -0800 (PST)
Date: Tue, 17 Dec 2024 01:48:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676148e8.050a0220.37aaf.0158.GAE@google.com>
Subject: [syzbot] [kvmarm?] BUG: unable to handle kernel paging request in vgic_its_set_attr
From: syzbot <syzbot+62e8b837d5ec5953c8e2@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, 
	syzkaller-bugs@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5db899a34f75 Merge remote-tracking branch 'kernel/kvmarm/n..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git fuzzme
console output: https://syzkaller.appspot.com/x/log.txt?x=148b6a0f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fde68ab6d6c8c8ab
dashboard link: https://syzkaller.appspot.com/bug?extid=62e8b837d5ec5953c8e2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/384ffdcca292/non_bootable_disk-5db899a3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4938b757ff4a/vmlinux-5db899a3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/936938b47987/Image-5db899a3.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+62e8b837d5ec5953c8e2@syzkaller.appspotmail.com

Unable to handle kernel paging request at virtual address efff800000000001
KASAN: null-ptr-deref in range [0x0000000000000010-0x000000000000001f]
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 4k pages, 52-bit VAs, pgdp=0000000044a53000
[efff800000000001] pgd=1000000049992003, p4d=1000000049993003, pud=0000000000000000
Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 UID: 0 PID: 5975 Comm: syz.1.647 Not tainted 6.12.0-rc7-syzkaller-g5db899a34f75 #0
Hardware name: linux,dummy-virt (DT)
pstate: 60402009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __hwasan_check_x0_67043362+0x4/0x30
lr : vgic_its_save_ite arch/arm64/kvm/vgic/vgic-its.c:2101 [inline]
lr : vgic_its_save_itt arch/arm64/kvm/vgic/vgic-its.c:2204 [inline]
lr : vgic_its_save_device_tables arch/arm64/kvm/vgic/vgic-its.c:2353 [inline]
lr : vgic_its_save_tables_v0+0x258/0x634 arch/arm64/kvm/vgic/vgic-its.c:2573
sp : ffff80008bd17be0
x29: ffff80008bd17c30 x28: 6cf0000019180180 x27: 5bf000001952a880
x26: 0000000000000008 x25: 0000000000000000 x24: 0000000000000000
x23: 07f000001952a8c0 x22: 07f000001952a8d0 x21: 00000000c0030000
x20: 07f000001952a8d0 x19: efff800000000000 x18: 00000000000000e8
x17: 0000000000000000 x16: 0000000000000001 x15: 0000000000000000
x14: 000000000002061b x13: 0000000000000000 x12: 0000000001fbb6cb
x11: 0000000000000000 x10: 0000000000002000 x9 : efff800000000000
x8 : 0000000020000000 x7 : ffff8000800fc528 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 8df00000195be2f0 x3 : 0000000000000008
x2 : ffff8000800fc5a4 x1 : 0000000000000000 x0 : 0000000000000010
Call trace:
 __hwasan_check_x0_67043362+0x4/0x30
 vgic_its_set_attr+0x394/0x508 arch/arm64/kvm/vgic/vgic-its.c:2736
 kvm_device_ioctl_attr+0x150/0x18c virt/kvm/kvm_main.c:4721
 kvm_device_ioctl+0x154/0x1b0
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __arm64_sys_ioctl+0x108/0x184 fs/ioctl.c:893
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x78/0x1b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x1b0 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x40/0x50 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x14c arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: a90efbfd d2800401 143a3edf 9344dc10 (38706930) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	a90efbfd 	stp	x29, x30, [sp, #232]
   4:	d2800401 	mov	x1, #0x20                  	// #32
   8:	143a3edf 	b	0xe8fb84
   c:	9344dc10 	sbfx	x16, x0, #4, #52
* 10:	38706930 	ldrb	w16, [x9, x16] <-- trapping instruction


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
