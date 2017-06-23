From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Fri, 23 Jun 2017 11:18:45 +0100
Message-ID: <CAFEAcA_g23xaTn6JdFh2ReoGaKBEqFnF-h04+f-ui64KvGwtgQ@mail.gmail.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <3dbafd74-57f2-e724-ace2-0f84abb57e59@huawei.com>
 <594A4205.70201@arm.com> <3a02e425-5782-dad4-efda-fdc5df73dcf7@huawei.com>
 <594A6A45.60909@arm.com> <ae7a4ac0-d38a-d6fe-2138-c21da23607c6@huawei.com>
 <594CE185.60902@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0DB24095A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jun 2017 06:14:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GrlIwM1mKlig for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Jun 2017 06:14:30 -0400 (EDT)
Received: from mail-wr0-f177.google.com (mail-wr0-f177.google.com
 [209.85.128.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 689CE40430
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jun 2017 06:14:30 -0400 (EDT)
Received: by mail-wr0-f177.google.com with SMTP id r103so59273328wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jun 2017 03:19:07 -0700 (PDT)
In-Reply-To: <594CE185.60902@arm.com>
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
Cc: wuquanming <wuquanming@huawei.com>, Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Achin Gupta <Achin.Gupta@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, gengdongjiu <gengdongjiu@huawei.com>, Huangshaoyu <huangshaoyu@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 23 June 2017 at 10:38, James Morse <james.morse@arm.com> wrote:
> So the v8 ARM-ARM has two ways of indicating an external abort, KVM tests bit 9
> The v7 ARM-ARm has a '{D,I}FSR.ExT' bit, which I think is equivalent. Its
> described as:
>> An implementation can use the DFSR.ExT and IFSR.ExT bits to provide more
>> information about external aborts.

For instance, the Cortex-A15 TRM documents that it uses the ExT bit
to distinguish AXI DECERR (decode error, ExT==0) and SLVERR (slave
error, ExT==1) abort responses.

>> This is what the v8 version must mean with its
>> External abort type. This bit can provide an IMPLEMENTATION DEFINED
>> classification of External aborts.
>
> Which I read as IMP-DEF classification 'as external', as opposed to your reading
> as an extra IMP-DEF classification for external aborts.

I think gengdongjiu's reading is correct here: if this
is an external abort then you can find out more info about
exactly what kind of EA it is by looking at this bit, but
you have to look at the FSC bits to be sure it is an EA first.

The Cortex-A53 TRM documents that it uses the same SLVERR-vs-DECERR
semantics for DFSR.ExT as the A15. It doesn't say so but it wouldn't
be very surprising if its usage of ESR_ELx.EA was the same.

thanks
-- PMM
