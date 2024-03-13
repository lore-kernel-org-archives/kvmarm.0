Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCC3168A8
	for <kvmarm@lists.linux.dev>; Wed, 13 Mar 2024 04:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710305647; cv=none; b=Rwcq8Sm2EggDmsH837cUq9BTWme5dsM/nNUS10kMkEhOxtJREojNe81ZIXUE5vYkk04UZILBhzVq4bEEhILnYegg42HXotkPJgMi5DhEmRiJDwaoj61S8ptcktgskIhDY02TYD44UTtK4zF8LzoXojVGbpjY5E9LxH2oJEYqoio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710305647; c=relaxed/simple;
	bh=RwE1SZFykbFIEdXhc32E9CCRRyP1RnAu8GR+ZlbsO/s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=S6FoDLPNG3Lne0ygrNKb777jECWPPNgW0Y0vuL8D0Mg8mtH9DhhG+aiBjmfq+ngDZZ6ZgSqMkqfhcdf9cyOWIPLOaSR5kTzyN5MhzyrCG3qypV8uQUoqK3peLVAp59OO1ED3UydbkC5WqJOjnkYsrrnxld5W6r9jeuupxraLpxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KtC5WmL5; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KtC5WmL5"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a4649c6f040so146394666b.0
        for <kvmarm@lists.linux.dev>; Tue, 12 Mar 2024 21:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710305644; x=1710910444; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lmEJWusqrVjTeVeazF5ThOOQa2SgJsJeK5CBTdQJlGQ=;
        b=KtC5WmL5dhblTgx8jRSml4MYnrj+EQrcVKStOFDrnRftoV8nu8hMiBYIRfreaK0F1G
         yvWxgQIxMcUGUhXFRWXJc4vpMXpz2tCE6ela8EWBvoU65WOrtIxCuuYnpEZdXpTTmkOz
         f8MBCu2vxy47c65sidmOfESNd0d3NhQJ6fsBcnFNc8EDONgq1MplVvIe5TitKKwUYpAW
         IEDJars8yswwHdbHxYBsgGWYhLezfmJreSO3wZVm1PB0/V6srLkGaDogQKhizccBtoPt
         vFNVYxdME+wLDJVaQ93o/O1Fml5005Eu64hY0NXrQm9gpUZnF6kbU+O/bv69QwBuZXhA
         W6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710305644; x=1710910444;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lmEJWusqrVjTeVeazF5ThOOQa2SgJsJeK5CBTdQJlGQ=;
        b=mjh8322iKdvpNZQL1GIFUxtJ4Cxf3nZTVYQ57NVI+ZOJ9JMubcAP+Ku2oeDvczLQgK
         sr6MZBAHB2yAR7RnJ4XedV/zUaZCLbFJa582AdjXV+pOy014mL/I8MBaqiHU3HnXBcvX
         Y7ufw5MgEHPswyxV1oNUvYGkTJNHXLMIO102ReidPeasDA8QEhSvGLKMCUm0rOEU7okH
         8wF/VHXGsdTrKQtzye6VffFOY8TowmJuaXzgqAocWOyBqBOeXO8ysmKG3xCxbLKRARPE
         jfZoLODCRpEqAIkDtPnseL2sZpfQkDYlTWip3KeiQqgOqhtjQb4lLT3V94iz6bMBZRn8
         Vq4w==
X-Forwarded-Encrypted: i=1; AJvYcCVPiq7JJ+DqFnbhEbO+BXCNydi2uYdY0dAt8vca9KE0DioXQCk3jx9YHPI1V2Y1FhE6+p43pfyrwSr1N0Hzzhxwm6JmReuz
X-Gm-Message-State: AOJu0Yy6Zjiz9zE1M7PaRl7tP66UiQqITpHEc4jlB2I2jAyR54Z5DQO2
	40MFASfcpx9OLz5wFH8HJH1FJ9OSzyQpSx6Fgm3jj44OWB4N3uEa9LlKT8ZQmyxETIu35ik6CmC
	BTh0pH3vLxF2nIyTS0T2wf7Tycew=
X-Google-Smtp-Source: AGHT+IGA6jXg1KHSmhq3jxMUXwOEZxn4SaAY8LwGrOjltmSJhZU1yi1SAptl3xHhi6p/lunMrGzl1F2xeKA6/jBhX1Y=
X-Received: by 2002:a17:906:fb81:b0:a43:29e1:6db8 with SMTP id
 lr1-20020a170906fb8100b00a4329e16db8mr7240435ejb.9.1710305643877; Tue, 12 Mar
 2024 21:54:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: cheung wall <zzqq0103.hey@gmail.com>
Date: Wed, 13 Mar 2024 12:53:52 +0800
Message-ID: <CAKHoSAtTA7pTi5T7oYZkNdVwt79sXbW+1=V=LZxpKdJGRSk0Eg@mail.gmail.com>
Subject: memory leak in kvm_init_stage2_mmu
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

when using Syzkaller to fuzz the latest Linux Kernel arm64 version,
the following crash

was triggered on:


HEAD commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a  (tag: v6.7)

git tree: upstream

console output: https://pastebin.com/raw/MLVZbN01

kernel config: https://pastebin.com/raw/PFD96ZwE

C reproducer: https://pastebin.com/raw/rHmMzvGt

Syzlang reproducer: https://pastebin.com/raw/dAt714WD


If you fix this issue, please add the following tag to the commit:

Reported-by: Qiang Zhang <zzqq0103.hey@gmail.com>

----------------------------------------------------------

2024/03/05 18:24:34 executed programs: 0
2024/03/05 18:26:41 executed programs: 8
BUG: memory leak
unreferenced object 0xffff023ad74b8100 (size 128):
  comm "syz-executor.3", pid 3911, jiffies 4295149819 (age 22.132s)
  hex dump (first 32 bytes):
    28 00 00 00 01 00 00 00 00 40 4e d7 3a 02 ff ff  (........@N.:...
    80 d9 5f a4 48 d3 ff ff c8 69 46 d7 3a 02 ff ff  .._.H....iF.:...
  backtrace:
    [<000000008d295845>] kmemleak_alloc_recursive
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/./include/linux/kmemleak.h:42
[inline]
    [<000000008d295845>] slab_post_alloc_hook
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/mm/slab.h:740
[inline]
    [<000000008d295845>] slab_alloc_node
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/mm/slub.c:3398
[inline]
    [<000000008d295845>] __kmem_cache_alloc_node+0x1f4/0x320
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/mm/slub.c:3437
    [<000000003fbdfe35>] kmalloc_trace+0x44/0x6c
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/mm/slab_common.c:1045
    [<00000000a94cbf84>] kmalloc
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/./include/linux/slab.h:553
[inline]
    [<00000000a94cbf84>] kzalloc
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/./include/linux/slab.h:689
[inline]
    [<00000000a94cbf84>] kvm_init_stage2_mmu+0x88/0x450
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/mmu.c:712
    [<00000000d7d73550>] kvm_arch_init_vm+0x6c/0x2d0
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/arm.c:145
    [<000000001e472e33>] kvm_create_vm
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1219
[inline]
    [<000000001e472e33>] kvm_dev_ioctl_create_vm
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/../../../virt/kvm/kvm_main.c:5009
[inline]
    [<000000001e472e33>] kvm_dev_ioctl+0x790/0x158c
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/../../../virt/kvm/kvm_main.c:5051
    [<000000005f1541e3>] vfs_ioctl
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/fs/ioctl.c:51
[inline]
    [<000000005f1541e3>] __do_sys_ioctl
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/fs/ioctl.c:870
[inline]
    [<000000005f1541e3>] __se_sys_ioctl
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/fs/ioctl.c:856
[inline]
    [<000000005f1541e3>] __arm64_sys_ioctl+0x17c/0x204
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/fs/ioctl.c:856
    [<00000000721fb6b6>] __invoke_syscall
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/syscall.c:38
[inline]
    [<00000000721fb6b6>] invoke_syscall+0x84/0x2d0
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/syscall.c:52
    [<00000000718e28b1>] el0_svc_common.constprop.0+0xe8/0x2e4
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/syscall.c:142
    [<000000001553392f>] do_el0_svc+0x64/0x1fc
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/syscall.c:206
    [<00000000585b9848>] el0_svc+0x2c/0x6c
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/entry-common.c:637
    [<0000000051149d12>] el0t_64_sync_handler+0xf4/0x120
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/entry-common.c:655
    [<00000000decfe0e2>] el0t_64_sync+0x18c/0x190
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/entry.S:585

BUG: memory leak
unreferenced object 0xffff023ad0484d00 (size 128):
  comm "syz-executor.2", pid 3935, jiffies 4295150036 (age 21.268s)
  hex dump (first 32 bytes):
    28 00 00 00 01 00 00 00 00 00 13 c7 3a 02 ff ff  (...........:...
    80 d9 5f a4 48 d3 ff ff c8 a9 c3 cd 3a 02 ff ff  .._.H.......:...
  backtrace:
    [<000000008d295845>] kmemleak_alloc_recursive
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/./include/linux/kmemleak.h:42
[inline]
    [<000000008d295845>] slab_post_alloc_hook
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/mm/slab.h:740
[inline]
    [<000000008d295845>] slab_alloc_node
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/mm/slub.c:3398
[inline]
    [<000000008d295845>] __kmem_cache_alloc_node+0x1f4/0x320
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/mm/slub.c:3437
    [<000000003fbdfe35>] kmalloc_trace+0x44/0x6c
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/mm/slab_common.c:1045
    [<00000000a94cbf84>] kmalloc
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/./include/linux/slab.h:553
[inline]
    [<00000000a94cbf84>] kzalloc
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/./include/linux/slab.h:689
[inline]
    [<00000000a94cbf84>] kvm_init_stage2_mmu+0x88/0x450
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/mmu.c:712
    [<00000000d7d73550>] kvm_arch_init_vm+0x6c/0x2d0
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/arm.c:145
    [<000000001e472e33>] kvm_create_vm
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1219
[inline]
    [<000000001e472e33>] kvm_dev_ioctl_create_vm
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/../../../virt/kvm/kvm_main.c:5009
[inline]
    [<000000001e472e33>] kvm_dev_ioctl+0x790/0x158c
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kvm/../../../virt/kvm/kvm_main.c:5051
    [<000000005f1541e3>] vfs_ioctl
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/fs/ioctl.c:51
[inline]
    [<000000005f1541e3>] __do_sys_ioctl
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/fs/ioctl.c:870
[inline]
    [<000000005f1541e3>] __se_sys_ioctl
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/fs/ioctl.c:856
[inline]
    [<000000005f1541e3>] __arm64_sys_ioctl+0x17c/0x204
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/fs/ioctl.c:856
    [<00000000721fb6b6>] __invoke_syscall
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/syscall.c:38
[inline]
    [<00000000721fb6b6>] invoke_syscall+0x84/0x2d0
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/syscall.c:52
    [<00000000718e28b1>] el0_svc_common.constprop.0+0xe8/0x2e4
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/syscall.c:142
    [<000000001553392f>] do_el0_svc+0x64/0x1fc
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/syscall.c:206
    [<00000000585b9848>] el0_svc+0x2c/0x6c
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/entry-common.c:637
    [<0000000051149d12>] el0t_64_sync_handler+0xf4/0x120
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/entry-common.c:655
    [<00000000decfe0e2>] el0t_64_sync+0x18c/0x190
data/embfuzz/emblinux/linux-4a61839152cc3e9e00ac059d73a28d148d622b30/arch/arm64/kernel/entry.S:585
