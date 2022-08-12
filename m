Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092D9C00140
	for <kvmarm@archiver.kernel.org>; Fri, 12 Aug 2022 09:26:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ECAE4F3C6;
	Fri, 12 Aug 2022 05:26:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O1xYVCvH26n4; Fri, 12 Aug 2022 05:26:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C63E4F2EC;
	Fri, 12 Aug 2022 05:26:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 514DD4F2E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Aug 2022 05:26:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wZfaatsQpAqj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Aug 2022 05:26:07 -0400 (EDT)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com
 [209.85.128.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E89D34F2EC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Aug 2022 05:26:06 -0400 (EDT)
Received: by mail-yw1-f173.google.com with SMTP id
 00721157ae682-31e7ca45091so4628147b3.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Aug 2022 02:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc;
 bh=JiQM/TVvq7gIOXd+ik/4Sp+rHwPd1vHDw41KWuB5cBU=;
 b=MYucwdMgwjiDONh6lNH5p2lZ+fiDv274tSHE5xMSV6K1Y+PvJC4Peguik9xdoSC2K4
 RbO4Uxqmk4EkXEizAl8goNz6Fz9aJIm5X5Lihskbfp2MnR2IydOvZamjxza3wCRPNffF
 EQx4bjkFqUwCW/6lVx1cWNfLlKERWNrlI/wEDZASMaJMNU6RrIxzqhkE5rLK8H5ghJuO
 40ka+7dKMGBg5ZlFqeq2tkdJ+V+WOc8qpFR9bl4GgGbVkxoIWLgzY3h2xDd6e9H32FQR
 b1qKG8ClM+S44Vjsra3jmeXhG0YcaodBx2eTogZPlJKNoFZsUxkjhm6np2y3nZT5om+b
 OSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
 bh=JiQM/TVvq7gIOXd+ik/4Sp+rHwPd1vHDw41KWuB5cBU=;
 b=YhJT+M9NoA7c2XZ/9v/Nsw3i05q3ULxedZO/aufcz0IBQ9PmasqzPXo+z31X9DyyyN
 IUUtiTPNuX72PqWTIROwLhVHzkThNUa4K9VlJB+RrqedZB7nQjElWEhfzC0iHJgjySLq
 hWvj65Ydhz0psS17CoiFieesBqQ31cogposefIJn6OZxuCfvD/0uG99mXyiRZJMfSmon
 dXZX5LKCbgh2ov3lqgOMi44a2UxRnSEP004Otu+BvFwoXkzzUVcSYoWSNoYcvdr1zXkQ
 P9LQ9TnRQnF974lf6fZ2rUCTdTEXNm1sHUkr2xkcjjboy9GW5L0H3rkB7sW6L7hut09j
 dzGg==
X-Gm-Message-State: ACgBeo2ysrPE8iGyV7KrSiz3me3+DnDeLK0ZVfWmlbwcxvcg6dUJd9Aq
 Gdtdj2RkfdSe/IHZsVXfyeINnCNJsXN9S0Q7LKZcOg==
X-Google-Smtp-Source: AA6agR7Rq0Dir1xYaUY2zni7bfgPxFxfd4P0Cg7Sq+8A6p6J+U50X4kbNCpKrATD0h0DZebIRPcegK52wROOB86oXhc=
X-Received: by 2002:a0d:fd05:0:b0:329:3836:53ac with SMTP id
 n5-20020a0dfd05000000b00329383653acmr3112172ywf.455.1660296366452; Fri, 12
 Aug 2022 02:26:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220812021427.cwenhciuftgtaj64@altlinux.org>
 <20220812084529.ur5qcyws5qvoyvuc@altlinux.org>
In-Reply-To: <20220812084529.ur5qcyws5qvoyvuc@altlinux.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 12 Aug 2022 10:25:55 +0100
Message-ID: <CAFEAcA9BuSe4SwpoWTALURaxoj-8U2y83k=und7oKrZBggLarQ@mail.gmail.com>
Subject: Re: qemu-system-aarch64: Failed to retrieve host CPU features
To: Vitaly Chikunov <vt@altlinux.org>
Cc: qemu-arm@nongnu.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
 QEMU Developers <qemu-devel@nongnu.org>, "Dmitry V. Levin" <ldv@altlinux.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

I've added some more relevant mailing lists to the cc.

On Fri, 12 Aug 2022 at 09:45, Vitaly Chikunov <vt@altlinux.org> wrote:
> On Fri, Aug 12, 2022 at 05:14:27AM +0300, Vitaly Chikunov wrote:
> > I noticed that we starting to get many errors like this:
> >
> >   qemu-system-aarch64: Failed to retrieve host CPU features
> >
> > Where many is 1-2% per run, depends on host, host is Kunpeng-920, and
> > Linux kernel is v5.15.59, but it started to appear months before that.
> >
> > strace shows in erroneous case:
> >
> >   1152244 ioctl(9, KVM_CREATE_VM, 0x30)   = -1 EINTR (Interrupted system call)
> >
> > And I see in target/arm/kvm.c:kvm_arm_create_scratch_host_vcpu:
> >
> >     vmfd = ioctl(kvmfd, KVM_CREATE_VM, max_vm_pa_size);
> >     if (vmfd < 0) {
> >         goto err;
> >     }
> >
> > Maybe it should restart ioctl on EINTR?
> >
> > I don't see EINTR documented in ioctl(2) nor in Linux'
> > Documentation/virt/kvm/api.rst for KVM_CREATE_VM, but for KVM_RUN it
> > says "an unmasked signal is pending".
>
> I am suggested that almost any blocking syscall could return EINTR, so I
> checked the strace log and it does not show evidence of arriving a signal,
> the log ends like this:
>
>   1152244 openat(AT_FDCWD, "/dev/kvm", O_RDWR|O_CLOEXEC) = 9
>   1152244 ioctl(9, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE) = 48
>   1152244 ioctl(9, KVM_CREATE_VM, 0x30)   = -1 EINTR (Interrupted system call)
>   1152244 close(9)                        = 0
>   1152244 newfstatat(2, "", {st_dev=makedev(0, 0xd), st_ino=57869925, st_mode=S_IFIFO|0600, st_nlink=1, st_uid=517, st_gid=517, st_blksize=4096, st_blocks=0, st_size=0, st_atime=1660268019 /* 2022-08-12T01:33:39.850436293+0000 */, st_atime_nsec=850436293, st_mtime=1660268019 /* 2022-08-12T01:33:39.850436293+0000 */, st_mtime_nsec=850436293, st_ctime=1660268019 /* 2022-08-12T01:33:39.850436293+0000 */, st_ctime_nsec=850436293}, AT_EMPTY_PATH) = 0
>   1152244 write(2, "qemu-system-aarch64: Failed to r"..., 58) = 58
>   1152244 exit_group(1)                   = ?
>   1152245 <... clock_nanosleep resumed> <unfinished ...>) = ?
>   1152245 +++ exited with 1 +++
>   1152244 +++ exited with 1 +++

KVM folks: should we expect that KVM_CREATE_VM might fail EINTR
and need retrying?

(I suspect the answer is "yes", given we do this in the generic
code in kvm-all.c.)

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
