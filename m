Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972D1C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 10:08:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 122C14B162;
	Tue, 14 Dec 2021 05:08:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cO6RGvVn9yT4; Tue, 14 Dec 2021 05:08:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5603C4B153;
	Tue, 14 Dec 2021 05:08:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE1F04B153
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 05:08:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2RezlfKn2vyH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 05:08:41 -0500 (EST)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 976804B128
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 05:08:41 -0500 (EST)
Received: by mail-wr1-f44.google.com with SMTP id j3so31511300wrp.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 02:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9DoS0eeq/Z/GFeFWDgflXa3FqL8V5QGgw6tIjQG1I6I=;
 b=qeqTc2MHbC9iY0+Wt6bSK0hRkJuuGRunpStNsXILy5cXKe7tLCkYqsyrFmqcIFYObJ
 Q8o00s8cvy/k7clCM0lSrCDmMTvvlI4VqxNYd+DDF/miYt3wH0CZbPZhfE9xECNLr9NX
 Y85HeuC68bQZ+u5inPU/59ryy33epb0+b3MpAB9ftxBkq0nlalqf7BfyYstnV4p8PjR1
 j5cZpfN4aRF9TNWJ1WdO95c1Xha5I5FF0eDL0CHEd0SVyGlfmx7NSK4VqwC0skmZMAnz
 YM6f74mXSGwCPEbRgH4Ac8vAcHs+EIH2zsFSsk+0KC1Ol0yJJFx+G0AE/ziiYX+de36i
 ZdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9DoS0eeq/Z/GFeFWDgflXa3FqL8V5QGgw6tIjQG1I6I=;
 b=RCe8zIARO88MkO35uZQQhAtGw00uGIKM6sEuyPWKJX1+Xtw1H59QzlbvSAh0lk/EwI
 IEyUMFJ4NL2olNEh2NxKHMh4EaeIVaD2OuMmyH9UCDWJVdeylAtNskODvfhxxW939yLj
 zU28ZUCRO2pVfvJy5X32gFwsKb3t1K7DNrpf5zAqU3XSuXxmn8zi+10Er93lARNMNzyb
 jEznUt+TzO64Tf/iwSgBSVv/1AXSQZ2GAWAwgOiKjHsEnxnY7zBZFuSAYBcyaw7AkQcr
 q7i5JOhJJ8MxqiLrR1R5K1XPnOQ7eXg2/+19iX/XMv4R9KBZgRlJe9Zd7rsffiKB8SLk
 ti3w==
X-Gm-Message-State: AOAM531S6F/PYmApFllwxn2yS9ap1ODbDNfcARNJX5uYBy8rnKjoNOt8
 fMalq7aK3A6vpg4yb7iKV6nz/8KCEPUlWp/Yx2cxLQ==
X-Google-Smtp-Source: ABdhPJxvOfVnLc4SnEuv+Gxxwpf6Y0BTx7GbbTIS+sHetpjki+yO5Um+t6zUil3eNa7Wz/mbIbqKbLpbwcQ8IorPD88=
X-Received: by 2002:a5d:522b:: with SMTP id i11mr1324896wra.2.1639476520656;
 Tue, 14 Dec 2021 02:08:40 -0800 (PST)
MIME-Version: 1.0
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
 <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
 <87lf0ojvq2.wl-maz@kernel.org> <aa407ba2-e9c4-882e-a085-91e7dd724f78@gmx.com>
 <29409a18-5156-6b3a-6a44-eecd83a20a78@redhat.com>
 <2281a255-fef3-c872-963e-2c5274d0d815@gmx.com>
 <87ee6fjyyh.wl-maz@kernel.org>
In-Reply-To: <87ee6fjyyh.wl-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 14 Dec 2021 10:08:29 +0000
Message-ID: <CAFEAcA-vpj3P5-D4U+mfEEgTXC=-1SeXqs4aRbSDX6Enj+abQA@mail.gmail.com>
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
To: Marc Zyngier <maz@kernel.org>
Cc: =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>, qemu-discuss@nongnu.org,
 libvirt-users@redhat.com, qemu-arm@nongnu.org,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Tue, 14 Dec 2021 at 09:52, Marc Zyngier <maz@kernel.org> wrote:
> You are still missing the point of how QEMU works:
>
> - QEMU creates a dummy VM with a single vcpu. This can happen on *any*
>   CPU.
> - It snapshots the sysregs for this vcpu, and keep them for later
> - It then destroy this VM
> - QEMU then creates the full VM, with all the vcpus
> - Each vcpu gets initialised with the state saved earlier. If any vcpu
>   is initialised on a physical CPU of a different type from the one
>   that has been used for the dummy VM, you lose, as we cannot restore
>   some of the registers such as MIDR_EL1 (and other registers that KVM
>   considers as invariant).

Put another way, QEMU's "-cpu host" is exactly one thing
(the "create a dummy VM and snapshot" steps above are where
QEMU defines what "-cpu host" means), and we have an implicit
assumption that the VM must only have one kind of guest CPU,
and not be heterogenous.

> The best workaround is to taskset the QEMU process (and I really mean
> the process, not individual threads) to an homogeneous set of CPUs and
> be done with it.

Agreed. I suspect that often the 'little' CPUs are sufficiently
low-power to probably not be worth giving to the VM anyway.

Side note: if you *do* give a guest both big and little CPUs
using kvmtool or something similar, does the guest kernel get
enough information to schedule tasks properly to both kinds of
CPU, or does it just assume they're all the same and happily
put performance-requiring tasks on the little CPUs ?

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
