Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C0B200BB8
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734341911; cv=none; b=u/7ZKyObOuNpL9m7+sS9CLK/wku4QxOHMT3pEBJ0AymFXCtQBjwjeySc/1Pqkn5Q4TasSMSOzxUOkLieoNoxH8BUtXYG66u35n8Xka7Uq0BpROk0KCZjzoyPOHPalvToVl6mbSqRLzNVuweoVcdwe753n3gXy+1KNsRJa3jav+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734341911; c=relaxed/simple;
	bh=LxzxYHaYqvSvrKL6pNOeXJJEEowAKzftB8AI0UlNKDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XtzviD67KUWohTMfJWPuZKKtKUg4lV+g7xXY32bDUZ099dPDLun9gO1y5HF6AkadYp/31uuVMCe5OjLq7wnxu0OQq486UE/0UvKmrGAKBvp72htZG4+RkqeEOYA5FYJKt59ujNVge1gHM9Hwzj/SRz7+dBvir6UhJGZYKVPyxG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EzT9SCV/; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EzT9SCV/"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ee86a1a92dso2608061a91.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 01:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734341906; x=1734946706; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tH3QBbIq+Oz3UUmj0lw02AcvLXxTPOgWHp9+Xspxbik=;
        b=EzT9SCV/XXX7kczx/Ux9jk+dlPSYZoozYmvaBMKcR7yfkBWP/ot/2BlQbw9AfBxtW3
         gZzLX9fEKfj8QOPl+Pf5LaHumZxts5NqtP+SnUajWqALJq4crqBBOSG62bUb94caKXV5
         28OdoHUTauinQm5uZd9XQS3ENiJSDDdRBYLiitawv5sKTCHhSS4WyvnE2chEzVi1kdSY
         QMdgqgWOydGbwlWVsLKA1kFP8EAJNR3GFAZ3TNPTeN6CB3pblQ83Ls7eEer9rPiPBfEL
         KAkB30lcnsMgHF7Hs6TeCnf8UTSvXu4ZE5zDfTlljOdPM4e54YT0oOMIP64YUW8ebAuF
         g/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734341906; x=1734946706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tH3QBbIq+Oz3UUmj0lw02AcvLXxTPOgWHp9+Xspxbik=;
        b=oBwcE+/GgFHDKrfpKioCTCyTI9I6ifMaVbLPtXYf7iUpiazEKwbsLTyeVyLattXy7w
         AEC2eO31NW4wyGVGB3jmU/ezPZsYUytj2WvlxNad/JttIfvWI0ClcpVExj9W7mIhk4xZ
         PPQ1l64Q/OroJEE0ve7KrQNtI0asIPGOi4uf3kG1BInJhL/unQnf5ZYKIn6lM1kldtW/
         VaN8qyZTw6CF2zSWrT4QJ5hw7vcZOLaeyQLZ59rPwq1ZxnIhR01W2xCQVqqr0X2kfB0O
         Xqe/Bx+X19MlJokIBSzNStM731E2mclBddw9BB+dsfA6SJg8jypZj95RlMQLW1bYwUnk
         j+bg==
X-Forwarded-Encrypted: i=1; AJvYcCUFh91bJQtkEwIt3yB/4XJc+utmbpYkHsc/iU6JFVrCHmQh4eJS7HgiT3eS5WQHZBhDGkSHB04=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxbzx18e2MVCtcKAwWTtiY/MJvu1uKu7H11eXXs6TvM6MGDIriI
	o7eWi7W9L9DW+GZRt8hGTuTmakrwDW0DuphSP/jJ6aqnglDu+AeIzRAxugB7+NPZh4GYoazroA0
	RILZ/wsMSa2lN3tBa1jX2g5e+u1rYTUWHwSsD
X-Gm-Gg: ASbGncsTf18XTSoNOxOH3OpC/hfl/avTHKxcTzFt6bAgV3xAZUWd0D6cxQgP2MXf624
	fyX62qFuYFzh23vxngHY/Kb6YddHV3SIcxagJeLeQMM/MRmKeET0S7ABOK0wkWZfnb3uJ
X-Google-Smtp-Source: AGHT+IGTB5sJUwQljcH3S5XL+OOeiabxzJ/8JQxqL7sZAHgT5dvELbfZeFL8O7lW9m6UCh29vDeERfH397eAur7NOuQ=
X-Received: by 2002:a17:90b:3c02:b0:2ee:5958:86d with SMTP id
 98e67ed59e1d1-2f28fb6764amr17469580a91.9.1734341906491; Mon, 16 Dec 2024
 01:38:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <675aa352.050a0220.1ac542.0018.GAE@google.com> <867c80ro2w.wl-maz@kernel.org>
In-Reply-To: <867c80ro2w.wl-maz@kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 16 Dec 2024 11:38:15 +0200
Message-ID: <CANp29Y6Eu47CvtuKfS7qKqXVcVf7mvVoP7XQstryb_ooakCpcA@mail.gmail.com>
Subject: Re: [syzbot] [kvmarm?] BUG: unable to handle kernel paging request in __hwasan_check_x0_ADDR
To: Marc Zyngier <maz@kernel.org>
Cc: syzbot <syzbot+67a9ec5b1706e0184581@syzkaller.appspotmail.com>, 
	catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, 
	syzkaller-bugs@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

Thanks for looking into the report!
Let's tell syzbot about the fixing commit you mentioned:

#syz fix: KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR

Syzbot will close the issue once the commit reaches the fuzzed tree.


--=20
Aleksandr

On Mon, Dec 16, 2024 at 11:09=E2=80=AFAM 'Marc Zyngier' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Thu, 12 Dec 2024 08:48:18 +0000,
> syzbot <syzbot+67a9ec5b1706e0184581@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    5db899a34f75 Merge remote-tracking branch 'kernel/kvmar=
m/n..
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kv=
marm.git fuzzme
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D16db78f8580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dfde68ab6d6c=
8c8ab
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D67a9ec5b1706e=
0184581
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for D=
ebian) 2.40
> > userspace arch: arm64
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/384ffdcca292/non_bootable_disk-5db899a3.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/4938b757ff4a/vmli=
nux-5db899a3.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/936938b47987=
/Image-5db899a3.gz.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+67a9ec5b1706e0184581@syzkaller.appspotmail.com
> >
> > Unable to handle kernel paging request at virtual address efff800000000=
137
> > KASAN: probably user-memory-access in range [0x0000000000001370-0x00000=
0000000137f]
> > Mem abort info:
> >   ESR =3D 0x0000000096000005
> >   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> >   SET =3D 0, FnV =3D 0
> >   EA =3D 0, S1PTW =3D 0
> >   FSC =3D 0x05: level 1 translation fault
> > Data abort info:
> >   ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000
> >   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> >   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> > swapper pgtable: 4k pages, 52-bit VAs, pgdp=3D0000000044a53000
> > [efff800000000137] pgd=3D1000000049992003, p4d=3D1000000049993003, pud=
=3D0000000000000000
> > Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 6560 Comm: syz.2.929 Not tainted 6.12.0-rc7-syzkalle=
r-g5db899a34f75 #0
> > Hardware name: linux,dummy-virt (DT)
> > pstate: 80402009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> > pc : __hwasan_check_x0_67043363+0x4/0x30
> > lr : vgic_get_irq+0x7c/0x3d4 arch/arm64/kvm/vgic/vgic.c:93
> > sp : ffff80008c597650
> > x29: ffff80008c597660 x28: 00000000000000e0 x27: 0000000000000004
> > x26: 0000000000000002 x25: ffff800083a7fe20 x24: 16f0000014accd90
> > x23: 16f0000014acb9a0 x22: 0000000000000000 x21: a9ff80008c583000
> > x20: 0000000000000001 x19: efff800000000000 x18: 0000000000000005
> > x17: 0000000000000000 x16: 0000000000000137 x15: 0000000000000000
> > x14: 0000000000000002 x13: 0000000000000003 x12: 70f000000a33ba80
> > x11: 0000000000080000 x10: 0000000000001378 x9 : efff800000000000
> > x8 : 0000000000000001 x7 : 0000000000000001 x6 : 0000000000000001
> > x5 : ffff80008c597858 x4 : ffff8000800f2b38 x3 : ffff8000800f7a00
> > x2 : 0000000000000001 x1 : 0000000000000001 x0 : 0000000000001378
> > Call trace:
> >  __hwasan_check_x0_67043363+0x4/0x30
> >  vgic_mmio_write_invlpi+0xb0/0x174 arch/arm64/kvm/vgic/vgic-mmio-v3.c:5=
46
> >  dispatch_mmio_write+0x2a4/0x308
> >  kvm_iodevice_write include/kvm/iodev.h:54 [inline]
> >  __kvm_io_bus_write+0x290/0x340 virt/kvm/kvm_main.c:5852
> >  kvm_io_bus_write+0x100/0x1bc virt/kvm/kvm_main.c:5877
> >  io_mem_abort+0x4b8/0x7a0 arch/arm64/kvm/mmio.c:204
> >  kvm_handle_guest_abort+0xb4c/0x1c64 arch/arm64/kvm/mmu.c:1880
> >  handle_trap_exceptions arch/arm64/kvm/handle_exit.c:351 [inline]
> >  handle_exit+0x1a0/0x274 arch/arm64/kvm/handle_exit.c:381
> >  kvm_arch_vcpu_ioctl_run+0xbc0/0x15b0 arch/arm64/kvm/arm.c:1279
> >  kvm_vcpu_ioctl+0x660/0xf78 virt/kvm/kvm_main.c:4475
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:907 [inline]
> >  __se_sys_ioctl fs/ioctl.c:893 [inline]
> >  __arm64_sys_ioctl+0x108/0x184 fs/ioctl.c:893
> >  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
> >  invoke_syscall+0x78/0x1b8 arch/arm64/kernel/syscall.c:49
> >  el0_svc_common+0xe8/0x1b0 arch/arm64/kernel/syscall.c:132
> >  do_el0_svc+0x40/0x50 arch/arm64/kernel/syscall.c:151
> >  el0_svc+0x54/0x14c arch/arm64/kernel/entry-common.c:712
> >  el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
> >  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
> > Code: a90efbfd d2800441 143a3ed3 9344dc10 (38706930)
>
> This seems to be something that is already handled by d561491ba927c
> ("KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR"), which
> made it into 6.13-rc1.
>
> The branch you are using doesn't seem to contain that particular
> commit. I have now updated it to -rc3, which should plug that issue.
>
> Let me know if it keeps appearing.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-bugs/867c80ro2w.wl-maz%40kernel.org.
