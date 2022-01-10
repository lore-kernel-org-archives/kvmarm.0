Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067A8C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 15:48:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6194B186;
	Mon, 10 Jan 2022 10:48:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7Q2JxLEfkRRU; Mon, 10 Jan 2022 10:48:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B0F74B187;
	Mon, 10 Jan 2022 10:48:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14BCF4B183
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:48:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M3Q+G0ZEbd-6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 10:47:59 -0500 (EST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D0C04B177
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:47:59 -0500 (EST)
Received: by mail-wr1-f50.google.com with SMTP id k18so27528151wrg.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 07:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=peGK9jkA1ECjFCE1GKLjh+6ydkjA9f/37HFPcNjIPDU=;
 b=Fh/b5I5anwBkTrgBAtBNtIQHIvXWf0V/SmPFlgo1Ve2rCHEb+dOLc48FjRg6MyDu8W
 3JIjkFNcPvMJwb2d5XweNmVLbAzYZwc+R9yieoV/nO5cUlW7gdt/gjRxm7Vfv+yGhC7C
 UAh3QVRrkzr9VOreaFCPBJ8kfnHPm/lixEr/I8CQqyLR4tP6tUPdbihWPy+afpSTt+zC
 V+4MajeqxYj48c6D7WcxyLT/o8EgbFOASSbmqUAL1danKNNFEAzVqfpB6Ixc/xq75eSx
 69Zu8RVKme11rtIYESDsR1qD0pyXNUWrTeT4ncZtgB5S/IBqFbUZF+NHFw67ovlnh/PD
 6nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=peGK9jkA1ECjFCE1GKLjh+6ydkjA9f/37HFPcNjIPDU=;
 b=CTEgzwztC+IS8qV5pT+eV5CKRQJ6nT3eeEDtcO8Gi5BH2QUhLR2b7eq0z1ioIgFDIw
 C2ZKqJfCvp+t62u+Eqmz6p1AdCyDJOwx0HvPqmsuxrR/RlAjBYQvtojGJ4xG3lGL6LhL
 zC5dfmJ2C7yFEd/9Oc6gva0Llx33XU0GF40yupgG6L43klUSkX4YqoXSiAVZ4pVArRHp
 Gr8NT3OnYqAYj092c75mK1qfOCgXcDwdOKhJIfecXhRQmp+I8vq3YutWcI6bZgAmJl/f
 WlTkDtOJZozbMdOs7HhTfeWbpGIFv+NKSok6pXNrAVzMwcPYPk+t9WLOb9jEiSNG6r85
 LuPQ==
X-Gm-Message-State: AOAM5309ydFLx1xggkM/e/uCTcxi7reCqz+ngeeRIRhH5TvrUhGZkxu/
 2ZLQQdn2UK8X3vD+1Id34TY/xr2/Z4sywTru3ImnFA==
X-Google-Smtp-Source: ABdhPJxG4gV0GKraTJ6tgmVj/WLmoPT/UKnsUKRM4S2k9+WOReU1GZyRcyeYg2VWZg8Hu9Q+7DLNpKQQR9PpEA7yc1U=
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr183666wrv.521.1641829678212;
 Mon, 10 Jan 2022 07:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-3-maz@kernel.org>
 <448274ac-2650-7c09-742d-584109fb5c56@redhat.com>
 <87k0f7tx17.wl-maz@kernel.org>
In-Reply-To: <87k0f7tx17.wl-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 10 Jan 2022 15:47:47 +0000
Message-ID: <CAFEAcA-OF29ptHr0X9ojyLEcDw9v7Smc5PC3O+v5Uv3bjiSmRA@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] hw/arm/virt: Add a control for the the highmem
 redistributors
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

On Mon, 10 Jan 2022 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
> $ /home/maz/vminstall/qemu-hack -m 1G -smp 256 -cpu host -machine virt,accel=kvm,gic-version=3,highmem=on -nographic -drive if=pflash,format=raw,readonly=on,file=/usr/share/AAVMF/AAVMF_CODE.fd
> qemu-hack: warning: Number of SMP cpus requested (256) exceeds the recommended cpus supported by KVM (8)
> qemu-hack: warning: Number of hotpluggable cpus requested (256) exceeds the recommended cpus supported by KVM (8)
> qemu-hack: Capacity of the redist regions(123) is less than number of vcpus(256)

Side question: why is KVM_CAP_NR_VCPUS returning 8 for
"recommended cpus supported by KVM" ? Is something still
assuming GICv2 CPU limits?

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
