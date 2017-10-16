From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] arm64: KVM: set right LR register value for 32 bit
 guest when inject abort
Date: Mon, 16 Oct 2017 16:10:01 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F201699F61@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6817340651
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 12:10:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XFCFXslKO0Yr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 12:10:07 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7725940638
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 12:10:05 -0400 (EDT)
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
To: Marc Zyngier <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

> 
> Please also update the 32bit code accordingly, as it looks broken too.

I have updated the 32 bit code according, in my hand, there is no arm32 host environment,
So there is no method to verify it in the arm32 host, only verify the patch in the arm64 host.

Anyway I firstly send the patch out for review. Thanks.

> 
> Thanks,
> 
> 	M.
> --
> Jazz is not dead. It just smells funny...
