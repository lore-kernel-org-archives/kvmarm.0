Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CA53C1969
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 12:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772456398; cv=pass; b=Wzjc+gH6emCP1dntrz7a60tcl69iezH6h1PrRKkUMNBWEUI89DB2DE5mFXXRyx4p0cXdMMIwk7l7q88HrDYy6/hRhsfSAdpHo4POgqJcKHHRgDLkjtrwczjuXs9e1maAj/hzEYZ/8HpeTwd9rFcigMA6Eg3iP20wEnsSG9kw/f8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772456398; c=relaxed/simple;
	bh=TcBOOOnuCLwk0IZQ9M2DakGIxFK3YxRIoF/guGniKN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iQ7DJsxHYEdLZxa88UctcspGwevFco87P0XptHeHR42Js9ULEvWapZGf3RFUoELp4N3bt1nPkQFH6K9HKdmLC8zwh+oCuso3cU9f08AzRURBahMaaZbqQOXC87rGa9dpZnkX9lzkkf9dCif1uW1INLkb0XNkX7duLJ0PFQj4GVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0v/VjVib; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0v/VjVib"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-389ff6e5885so7192591fa.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Mar 2026 04:59:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772456395; cv=none;
        d=google.com; s=arc-20240605;
        b=YQmENbRgLnCQedNBDVA/3v4yMMjmQlghhHcxToTj6BkQ3K/PUMghECCssK5+NTsCq1
         FxKwqds2dTx5WOPWrTVGCZj3uqM6udN/gkBRANlVCBeG1yihk1+0x2+dOVl0E39sNWIR
         U/85exADCznwRWpAWIiLaAvjpM/eABnH4anog3rKLHGANDZ9BKXy7DlBxGrjPCtIAY5E
         OL3LBPZNBSSORdpUSd6zP3x1TaQ9iifRfe+NA8BpebwfxXSdJiHaUVC5IGynG306LU6T
         meD17qxPSy+3A2UDfeLwXyTSjKE3E2q7iRR92FbdGHMrkFsSuQTPsV9ZtkECPBV2kjEO
         qXMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gaZCmNHBBezygKlMXEhqhmCZ8CD3x/AWabkqujMLwpY=;
        fh=1TUdNgKBIXpKIPIF3yIas1hVJPu4gNPNhd0W8V8WJo4=;
        b=kimIBpGAtt7zB5GeACbjQPiryWdY8eYEqJ4/JCxI2qF5HQbekehi4QFqarFhwATV9v
         lM4ZMPVNbgxqASp4vOOT3g1O2dy2aGKYmibWMqokKCEl25/a3lQ2HloUg+zUG+Onkbwn
         oASoO2JoWD9Y9UmwWeTDX4XKdfrbQTf99TumdFDmeGv5hwV1fjfzxkiHgNGdy5RDOPw7
         wJzu0iqfZKVv+cXjWAuUqpRMqqSCHER+Jhh17i8P1D930HfVvRDaMcrWyBb9tuwfTpIv
         SS2rmA54zkRky1IYicYXrpwsmNtV2bvH/418+HorPxfxh/ALv4ytBnCZAsJGisnp5uPR
         LHig==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772456395; x=1773061195; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gaZCmNHBBezygKlMXEhqhmCZ8CD3x/AWabkqujMLwpY=;
        b=0v/VjVibetT9hr6+roHs55UQmfKHqHl20YXs87O1Yc6yDtuUFC+mz+aESR5e14JxxS
         iXHmmCgNqNwzSeGaZ0KDRBZXfgM4vH4tLeG/gRVEWwbNTgER8wEoClUF3H0I5ucivjZn
         robEmavoJ6isHEeaAR4+yj3sbt7OtMMn1f+jklLGcE0Q/jplsznWVqmM8kVwLdllJBnr
         fRkUHCrAqEZewMahVdr4sVN5stc0D2yyrZQBW7cS5dBJVQ2AJoG6P7VS57mV/e5ff4bS
         uPi+JuF3ofULr45nXngdnj3TpNTrSrd+Zuq6wHa9JOj8bK45ysSEDSDj/8kNqjm253n6
         UVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772456395; x=1773061195;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaZCmNHBBezygKlMXEhqhmCZ8CD3x/AWabkqujMLwpY=;
        b=eq+upHXKy/ut+i/EuaVqLsccCpiWSETc7LyM+BpmyvWWhVg3LBm8HD3OT7cK0g6Vsh
         BPArC+iSVdAXy3zMhCuaB/3QXdD56qfbhZHS9YXjDzVOK0ZteSjDkhc6dhanxS8mTF3l
         7TneACkoX8cJ7KMMLvZcanya6o+KdIYMYvTXieW4i4NJrfY6psUvJhzUGt16pYscPqv9
         mVG/9OKYfNCoHPmgK4XPm1WPAzCcfHdsMuGZQ12XQrkZBlvcbIkReeKmOGz+6pH8BiGq
         sdLBy0Y43eTMPp3+MOvtBHwCQ+1i9F8m77UB8gPfqxXkbM8phvRD8qlN567UIzHg4XZZ
         kwBA==
X-Forwarded-Encrypted: i=1; AJvYcCUZkaF+xQSpuzEn7WqGKPIRkAcF4nRTcGsuVkmsHWiMctl/ag247McxYXxgQkLwokl0u3D0tnk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxTAlElS27EpBTt6T2yaKVqqfpF2Uh3Ha4MqVX80062IR08YlR
	xXnPiweCJkMy9AjjVOI5y9VfzpVlrTy0rlFCAB3iMxIM5aKQQczfF9DvWNT3Tug0VZIV5cdBgrc
	HK1a/F7OyIYVW0KGEP4dHhlcPVXBWqUPMAk3bIHlv
X-Gm-Gg: ATEYQzzWU11RYznCqKl6zmZeJvAhEMO+j/5Ed481EckoJvXktV8iHVKJRxD47CeT7uN
	C9RnHOMZUFrMk909ayhKcMeHrH+rpEvN/dxGw4+0bb5bcC/r89C3/D+Tuj07VYoS+jDZLIf6xUa
	JyL5ADAnZ+MWVfVJZFyF1zuxLIT0xH+PD3Cc8i6cCHGkoqGPzn2NuXSJRbZw+HCU3wr/XkA41oQ
	5vOpVW9J0EVu0eqNrLYBAd2NiI2iM93zFpGT+5UO20g6qFE4vT3g812ULT7/up3wr/uk33SH7u/
	vN+mRpAjvvscgQVSdWUrOXW4MMVZq41isJ0jPQ==
X-Received: by 2002:a2e:a608:0:b0:387:b72:816a with SMTP id
 38308e7fff4ca-389f1d73836mr80891401fa.3.1772456394493; Mon, 02 Mar 2026
 04:59:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69a2d58c.050a0220.3a55be.003b.GAE@google.com> <874in0ex49.wl-maz@kernel.org>
In-Reply-To: <874in0ex49.wl-maz@kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 2 Mar 2026 13:59:41 +0100
X-Gm-Features: AaiRm50VAo0HdWE3pXUzISRFilQBQfPRuh86gosA2aI8t8AALdoEJnWYNg6PsM4
Message-ID: <CACT4Y+bbQ3qfoy0kuXgTk5H2k=Wrg2t0Ghhc6U6fT-28ter7iA@mail.gmail.com>
Subject: Re: [syzbot] [kvmarm?] [kvm?] BUG: unable to handle kernel paging
 request in kvm_vgic_destroy
To: Marc Zyngier <maz@kernel.org>
Cc: syzbot <syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com>, 
	syzkaller@googlegroups.com, catalin.marinas@arm.com, joey.gouly@arm.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	oupton@kernel.org, suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

On Sat, 28 Feb 2026 at 15:55, 'Marc Zyngier' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Sat, 28 Feb 2026 11:46:20 +0000,
> syzbot <syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    6316366129d2 Merge branch kvm-arm64/misc-6.20 into kvmarm-..
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15e59c4a580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=148fc9aa8e041d0a
> > dashboard link: https://syzkaller.appspot.com/bug?extid=f6a46b038fc243ac0175
> > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> > userspace arch: arm64
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13182006580000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173900ba580000
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-63163661.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/1018400deda3/vmlinux-63163661.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/fb8a8bb5d8a4/Image-63163661.gz.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com
> >
> >  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
> >  invoke_syscall+0x90/0x230 arch/arm64/kernel/syscall.c:49
> >  el0_svc_common+0x120/0x2f4 arch/arm64/kernel/syscall.c:132
> >  do_el0_svc+0x58/0x74 arch/arm64/kernel/syscall.c:151
> >  el0_svc+0x5c/0x238 arch/arm64/kernel/entry-common.c:724
> >  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
> >  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
> > Unable to handle kernel paging request at virtual address ffef800000000000
> > KASAN: maybe wild-memory-access in range [0xff00000000000000-0xff0000000000000f]
> > Mem abort info:
> >   ESR = 0x0000000096000004
> >   EC = 0x25: DABT (current EL), IL = 32 bits
> >   SET = 0, FnV = 0
> >   EA = 0, S1PTW = 0
> >   FSC = 0x04: level 0 translation fault
> > Data abort info:
> >   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> >   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> >   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> > [ffef800000000000] address between user and kernel address ranges
> > Internal error: Oops: 0000000096000004 [#1]  SMP
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 3651 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT
> > Hardware name: linux,dummy-virt (DT)
> > pstate: 01402009 (nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> > pc : kvm_vgic_dist_destroy arch/arm64/kvm/vgic/vgic-init.c:445 [inline]
> > pc : kvm_vgic_destroy+0x2d4/0x624 arch/arm64/kvm/vgic/vgic-init.c:518
> > lr : kvm_vgic_dist_destroy arch/arm64/kvm/vgic/vgic-init.c:444 [inline]
> > lr : kvm_vgic_destroy+0x290/0x624 arch/arm64/kvm/vgic/vgic-init.c:518
> > sp : ffff80008e647b90
> > x29: ffff80008e647ba0 x28: 0000000000000005 x27: cdf00000200a52d8
> > x26: cdf00000200a4db0 x25: 00000000000000cd x24: cdf00000200a4d8c
> > x23: 00000000000000cd x22: 00000000000000cd x21: cdf00000200a4ad0
> > x20: efff800000000000 x19: cdf00000200a4000 x18: 00000000030f4b63
> > x17: 0000000000000031 x16: 0000000000000000 x15: ffff800088209a68
> > x14: ffffffffffffffff x13: 0000000000000028 x12: 5df000001795c1f0
> > x11: ffff800088209a68 x10: 0000000000ff0100 x9 : 0ff0000000000000
> > x8 : 0000000000000000 x7 : ffff80008672f958 x6 : 0000000000000000
> > x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000002
> > x2 : 0000000000000008 x1 : 0000000000000000 x0 : 0000000000000007
> > Call trace:
> >  kvm_vgic_dist_destroy arch/arm64/kvm/vgic/vgic-init.c:445 [inline] (P)
> >  kvm_vgic_destroy+0x2d4/0x624 arch/arm64/kvm/vgic/vgic-init.c:518 (P)
> >  kvm_arch_destroy_vm+0x88/0x138 arch/arm64/kvm/arm.c:299
> >  kvm_destroy_vm virt/kvm/kvm_main.c:1317 [inline]
> >  kvm_put_kvm+0x778/0xbe0 virt/kvm/kvm_main.c:1354
> >  kvm_vm_release+0x58/0x78 virt/kvm/kvm_main.c:1377
> >  __fput+0x4ac/0x978 fs/file_table.c:468
> >  ____fput+0x20/0x58 fs/file_table.c:496
> >  task_work_run+0x1b8/0x250 kernel/task_work.c:233
> >  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
> >  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
> >  exit_to_user_mode_loop+0x110/0x188 kernel/entry/common.c:75
> >  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
> >  exit_to_user_mode_prepare_legacy include/linux/irq-entry-common.h:242 [inline]
> >  arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:81 [inline]
> >  el0_svc+0x17c/0x238 arch/arm64/kernel/entry-common.c:725
> >  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
> >  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
> > Code: 54000420 b2481c28 d344fd09 d378fc28 (38696a89)
> > ---[ end trace 0000000000000000 ]---
> > ----------------
> > Code disassembly (best guess):
> >    0: 54000420        b.eq    0x84  // b.none
> >    4: b2481c28        orr     x8, x1, #0xff00000000000000
> >    8: d344fd09        lsr     x9, x8, #4
> >    c: d378fc28        lsr     x8, x1, #56
> > * 10: 38696a89        ldrb    w9, [x20, x9] <-- trapping instruction
>
> Oh gawd, fault injection. Because we didn't have enough bona fide,
> directly triggerable bugs, we're tricking the kernel into generating
> more. Oh well.
>
> Thankfully, that's an easy one: vgic_allocate_private_irqs_locked()
> fails, we exit kvm_vgic_create() early, leaving dist->rd_regions
> uninitialised. kvm_vgic_dist_destroy() comes along and walks into the
> weeds.
>
> Note to the syzcaller folks: being a lazy bastard, I run the test case
> (both kernel and C reproducer) as a nested guest using kvmtool.
> kvmtool has a very simple init that doesn't mount debugfs by default.
> It'd be great if the reproducer could check that the debugfs files are
> accessible and stop if it can't configure them. I initially couldn't
> reproduce the issue because of this.

Hi Marc,

The reproducer should print at the start specifically to address this concern:

the reproducer may not work as expected: fault injection setup failed:
failed to write fault injection file

Isn't it enough?




> Anyway, that being said:
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/vgic-fixes-7.0
