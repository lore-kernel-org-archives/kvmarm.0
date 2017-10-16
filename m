From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v3 15/20] KVM: arm64: Set an impdef ESR for Virtual-SError
 using VSESR_EL2.
Date: Mon, 16 Oct 2017 11:17:32 +0800
Message-ID: <CAMj-D2BbOJBOUnY5r6mGUBB34Lq_z6xGAhvHyuNFjp29KLif7Q@mail.gmail.com>
References: <0184EA26B2509940AA629AE1405DD7F2016959EE@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1D840A74
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Oct 2017 23:16:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i5-isy+LqH38 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Oct 2017 23:16:39 -0400 (EDT)
Received: from mail-ua0-f194.google.com (mail-ua0-f194.google.com
 [209.85.217.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 976E740418
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Oct 2017 23:16:39 -0400 (EDT)
Received: by mail-ua0-f194.google.com with SMTP id i35so8762172uah.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Oct 2017 20:17:33 -0700 (PDT)
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2016959EE@DGGEMA503-MBX.china.huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "Jonathan.Zhang@cavium.com" <Jonathan.Zhang@cavium.com>, Wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Huangshaoyu <huangshaoyu@huawei.com>, "wangxiongfeng (C)" <wangxiongfeng2@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

> In fact I have below method for that, what do you think about that?
>
> 1.  If there is no RAS, old method, directly inject virtual SError, not need to specify ESR, as shown in the [1]
> 2.  If there is RAS, KVM set "the kvm_run" guest exit type value to let user space handle the SError abort
>    A. If ESR_EL2 is IMPLEMENTATION or uncategorized, return " ESR_ELx_ISV " to let user space specify an implementation-defined value, as shown [2]
>    B. If ESR_EL2 is categorized and error not propagated,  the error come from guest user space, return " (ESR_ELx_AET_UCU | ESR_ELx_FSC_SERROR " to let user space specify a recoverable ESR.
>      Here one side calling memory failure, another side let user pace inject SError. Because usually SEI notification does not deliver SIGBUS signal to user space, so here inject virtual SEI to ensure that. As shown [3]
>    C. If ESR_EL2 is categorized and error not propagated,  the error come from guest kernel, return "-1" to terminate guest. As shown [4]
>    D. Otherwise, Panic host OS. As shown [5]
>

For the IMPLEMENTATION ESR, for the safety purposes, I have below suggestion

1. When there is no guest,  host OS receives IMPLEMENTATION ESR, I
hope host can be panic, because we do not know its implementation
meaning.
2. when guest received MPLEMENTATION  ESR, and the Error is isolated
to guest by "ESB" instruction, not propagate to host. I hope guest
will exit, but host not panic.
3. when guest received MPLEMENTATION  ESR, and the Error is propagate
to host, I hope host can be panic.
