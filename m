From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v7 1/4] arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
Date: Wed, 11 Jul 2018 11:48:56 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F201D54EB7@dggema523-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16B65408AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jul 2018 07:36:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WJhieEKzQLHx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jul 2018 07:36:22 -0400 (EDT)
Received: from huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F06154070F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jul 2018 07:36:21 -0400 (EDT)
Content-Language: zh-CN
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, James Morse <james.morse@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: Linuxarm <linuxarm@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

> >> diff --git a/Documentation/virtual/kvm/api.txt
> >> b/Documentation/virtual/kvm/api.txt
> >> index d10944e619d3..e3940f8715a5 100644
> >> --- a/Documentation/virtual/kvm/api.txt
> >> +++ b/Documentation/virtual/kvm/api.txt
> >> @@ -835,11 +835,13 @@ struct kvm_clock_data e
> >>
> >>  Capability: KVM_CAP_VCPU_EVENTS
> >>  Extended by: KVM_CAP_INTR_SHADOW
> >> -Architectures: x86
> >> -Type: vm ioctl
> >> +Architectures: x86, arm64
> >
> >    In my previous patch, I only add the arm64 support, now you add patches to support arm32 platform,
> >    so you can add "ARM" to the Architectures, for example: "Architectures: x86, ARM, arm64"
> 
> That should be the job of the last patch, shouldn't it? At this point in the series, there is no 32bit support whatsoever.

>From this point in the series, it is ok to add that in the last patch because there is no 32bit support whatsoever.
Thanks for the corrections.

> 
> Thanks,
> 
> 	M.
> --
> Jazz is not dead. It just smells funny...
