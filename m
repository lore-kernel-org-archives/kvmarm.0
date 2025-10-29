Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230F33112C1
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 20:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761768269; cv=none; b=JG8/T+4r1gQ3tZ7x9+IYCsCxttojjtf7iszk50DZugNMR5GMa5k45lBbeDBJqIc4mLbCkweZGZkHzYdwcFXQEtGYFYLc72DN3vNk78FV9txi1+hERPE4SQuw62gfof1PI6wu6QcrQopoDU3f2U2C5BkSsa30GkdZ25vczQBF3uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761768269; c=relaxed/simple;
	bh=fioUdpsvkg7o4DURZKigp8NqVzpYOCoFYaEmsLifRNc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=rKJNOuRAqchf/QnaVDQQ7+7F1uGVrh8IiflHe5YrM2IHgYD5pTfVoV4s7fUaJS7nvxOGZHfCtVOO533Fk979wJTDsZAKsj/7ew4N9ftbPiS3U2OiJe7diUAOIjlelgH/z/lvU+Jj/KTZtAH1VSD7iWAaSA0DYI0ONze+fjPVS7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-430da49fcbbso3456365ab.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 13:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761768267; x=1762373067;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s9g2Js5R08cAxeOIEvq9143t2u9EB2ub+jMhK2A6O7M=;
        b=tdTD16dSGrwrH6pRJOIElI6k6Lfvx0ow0bSW3Sa1mLO38wMgs+SY+lKcUWjDWIBV+s
         oFO4KFlzjBvZCFZl781zmcFFMrG6Tm29l8QctjekVSJL6mWiVm3oN6NJ9qKoMLDQt+ud
         XJhzf2tZm5mI46mnOr0RSb1dHNVz9a6QnWbXjOp+9ai43WUkoGWsA+uQR74ALCDlB1gy
         5rkhG1TQLm83SWgCv0VMtU60t3dfsJpvlZ3ioDtZYr44KHvpv0tkAyMpuSdcVTMxNLSL
         dIHb/FCDo6df4xVd5LNuBW3w9hl/TO8JfENB0UzLz10HT63VcmJdf2Mrp5DFWUnntKnf
         Gmaw==
X-Forwarded-Encrypted: i=1; AJvYcCUnBC6ePdaFZezwod9V4KjKgv/Vy1cYHqFpph5FVr4mTgVBFWDWth1sMfvHrKhribrJmnnkN8Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9F6YGYB6tnhLb6Op95NLyrNXX0gZQIwYQVelEu4tMTQYiBMz3
	AL9I87dpt6lBND1934j1dNG613D059c7kbl5qbN5+sCamaO0RWW2NnDfBpAeZY6QYgnaDcM0VCz
	gxSrtglgx4fx8weOOOcDmd8b8lMAd8lubmkTufSkYbcXKxA4MwgvGzABoapE=
X-Google-Smtp-Source: AGHT+IHIYFLsAiBCqojPIt2QDWa9d/yLxjivS9JM+BHMWwChpQQKGmD61OncOVmQEwUwcLFJDz83jDyr5DBAP7ALsrxrwXOp6FZQ
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1f13:b0:42e:7589:6290 with SMTP id
 e9e14a558f8ab-432f8fbe8b4mr61708075ab.12.1761768267270; Wed, 29 Oct 2025
 13:04:27 -0700 (PDT)
Date: Wed, 29 Oct 2025 13:04:27 -0700
In-Reply-To: <68cd66b0.050a0220.139b6.000f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6902734b.050a0220.3344a1.0430.GAE@google.com>
Subject: Re: [syzbot] [kvmarm?] kernel BUG in kvm_s2_put_page
From: syzbot <syzbot+c41f3ddb8299a30a98b5@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, 
	syzkaller-bugs@googlegroups.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    10fd0285305d Merge branch kvm-arm64/selftests-6.18 into kv..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
console output: https://syzkaller.appspot.com/x/log.txt?x=173e4fe2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4522b3a704e0394
dashboard link: https://syzkaller.appspot.com/bug?extid=c41f3ddb8299a30a98b5
compiler:       Debian clang version 20.1.8 (++20250708123704+0de59a293f7a-1~exp1~20250708003721.134), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13559c92580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12963fe2580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-10fd0285.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/65e2ebd050e3/vmlinux-10fd0285.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9d47fc3df12e/Image-10fd0285.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c41f3ddb8299a30a98b5@syzkaller.appspotmail.com

raw: 01fff1c000000000 ffffc1ffc08742c8 ffffc1ffc07b2488 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
------------[ cut here ]------------
kernel BUG at ./include/linux/mm.h:1036!
Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 3630 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : put_page_testzero include/linux/mm.h:1036 [inline]
pc : folio_put_testzero include/linux/mm.h:1042 [inline]
pc : folio_put include/linux/mm.h:1359 [inline]
pc : put_page include/linux/mm.h:1429 [inline]
pc : kvm_s2_put_page+0x374/0x3a0 arch/arm64/kvm/mmu.c:264
lr : put_page_testzero include/linux/mm.h:1036 [inline]
lr : folio_put_testzero include/linux/mm.h:1042 [inline]
lr : folio_put include/linux/mm.h:1359 [inline]
lr : put_page include/linux/mm.h:1429 [inline]
lr : kvm_s2_put_page+0x374/0x3a0 arch/arm64/kvm/mmu.c:264
sp : ffff80008e717450
x29: ffff80008e717450 x28: bff000001ec92000 x27: bff000001ec92000
x26: 00000000000000ff x25: ffff800087396000 x24: ffffc1ffc0000000
x23: ffffc1ffc0874288 x22: 0000000000000000 x21: ffffc1ffc08742b4
x20: 0000000000000000 x19: ffffc1ffc0874280 x18: 00000000fb20c077
x17: 00000000057d7f34 x16: 00000000fb1a5197 x15: 00000000866b9677
x14: ffffffffffffffff x13: fff0000015a39d88 x12: 0000000000000001
x11: 0000000000000000 x10: 0000000000ff0100 x9 : a6a806ed1668b300
x8 : a6a806ed1668b300 x7 : ffff80008039fbc8 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff80008074aff8
x2 : 0000000000000001 x1 : 0000000100000000 x0 : 000000000000003e
Call trace:
 put_page_testzero include/linux/mm.h:1036 [inline] (P)
 folio_put_testzero include/linux/mm.h:1042 [inline] (P)
 folio_put include/linux/mm.h:1359 [inline] (P)
 put_page include/linux/mm.h:1429 [inline] (P)
 kvm_s2_put_page+0x374/0x3a0 arch/arm64/kvm/mmu.c:264 (P)
 stage2_free_walker+0x1b0/0x264 arch/arm64/kvm/hyp/pgtable.c:1549
 kvm_pgtable_visitor_cb arch/arm64/kvm/hyp/pgtable.c:130 [inline]
 __kvm_pgtable_visit arch/arm64/kvm/hyp/pgtable.c:212 [inline]
 __kvm_pgtable_walk+0x7d8/0xa68 arch/arm64/kvm/hyp/pgtable.c:237
 _kvm_pgtable_walk arch/arm64/kvm/hyp/pgtable.c:260 [inline]
 kvm_pgtable_walk+0x294/0x468 arch/arm64/kvm/hyp/pgtable.c:283
 kvm_pgtable_stage2_destroy_range+0x60/0xb4 arch/arm64/kvm/hyp/pgtable.c:1563
 stage2_destroy_range arch/arm64/kvm/mmu.c:924 [inline]
 kvm_stage2_destroy arch/arm64/kvm/mmu.c:935 [inline]
 kvm_free_stage2_pgd+0x198/0x28c arch/arm64/kvm/mmu.c:1112
 kvm_uninit_stage2_mmu+0x20/0x38 arch/arm64/kvm/mmu.c:1023
 kvm_arch_flush_shadow_all+0x1a8/0x1e0 arch/arm64/kvm/nested.c:1113
 kvm_flush_shadow_all virt/kvm/kvm_main.c:343 [inline]
 kvm_mmu_notifier_release+0x48/0xa8 virt/kvm/kvm_main.c:884
 mn_hlist_release mm/mmu_notifier.c:321 [inline]
 __mmu_notifier_release+0x310/0x614 mm/mmu_notifier.c:359
 mmu_notifier_release include/linux/mmu_notifier.h:402 [inline]
 exit_mmap+0xb8/0xbb8 mm/mmap.c:1263
 __mmput+0x10c/0x528 kernel/fork.c:1130
 mmput+0x70/0xac kernel/fork.c:1152
 exit_mm+0x158/0x258 kernel/exit.c:582
 do_exit+0x788/0x2378 kernel/exit.c:949
 do_group_exit+0x1d4/0x2ac kernel/exit.c:1102
 get_signal+0x1440/0x1554 kernel/signal.c:3034
 do_signal+0x23c/0x4dd0 arch/arm64/kernel/signal.c:1618
 do_notify_resume+0xb0/0x270 arch/arm64/kernel/entry-common.c:152
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:173 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:182 [inline]
 el0_svc+0xb8/0x164 arch/arm64/kernel/entry-common.c:880
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: 900377c1 910e9421 aa1303e0 97f9c9f2 (d4210000) 
---[ end trace 0000000000000000 ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
