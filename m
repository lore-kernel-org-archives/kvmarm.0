From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v4 15/21] KVM: arm64: Set an impdef ESR for Virtual-SError
 using VSESR_EL2.
Date: Sat, 21 Oct 2017 00:44:57 +0800
Message-ID: <CAMj-D2AMy1_SPrLGti9U=oz1JvBDHvRAMsBtw51B3JK0omLyXg@mail.gmail.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-16-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 026AD41185
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 12:43:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0oH-WSsW2-QB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 12:43:51 -0400 (EDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com
 [209.85.213.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2100C4078A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 12:43:51 -0400 (EDT)
Received: by mail-vk0-f53.google.com with SMTP id r82so7694308vke.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 09:44:57 -0700 (PDT)
In-Reply-To: <20171019145807.23251-16-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, Xiongfeng Wang <wangxiongfeng2@huawei.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

2017-10-19 22:58 GMT+08:00 James Morse <james.morse@arm.com>:
> Prior to v8.2's RAS Extensions, the HCR_EL2.VSE 'virtual SError' feature
> generated an SError with an implementation defined ESR_EL1.ISS, because we
> had no mechanism to specify the ESR value.
>
> On Juno this generates an all-zero ESR, the most significant bit 'ISV'
> is clear indicating the remainder of the ISS field is invalid.
>
> With the RAS Extensions we have a mechanism to specify this value, and the
> most significant bit has a new meaning: 'IDS - Implementation Defined
> Syndrome'. An all-zero SError ESR now means: 'RAS error: Uncategorized'
> instead of 'no valid ISS'.

consider again.

I still consider that it is not better set  "Implementation Defined
Syndrome" here.
I know your meaning that An all-zero SError means Uncategorized
>From the beginning,  our starting point is KVM is the architecture
related and Qemu/kvmtool is platform related.
Qemu/kvmtool is the role of host firmware.
so we let Qemu to create APEI/GHES table and record CPER,
and also injects SEA/SEI in the Qemu.

About the vsesr_el2 which is used to specify the guest ESR,   also all
set by Qemu/kvmtool are better.
including the three cases  even the ESR are  all-zero(uncategorized).
1. IMPLEMENTATION DEFINED
2  categorized,
3  uncategorized,

For this case, Qemu just set the ESR, nothing else, not passing
RAS-error to userspace.
