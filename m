From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 3/5] arm64: KVM: vgic-v2: Add the GICV emulation
 infrastructure
Date: Thu, 1 Sep 2016 15:39:47 +0100
Message-ID: <CAFEAcA-wRsex26zxK88d68Ec7u71focN3vrydZ+tHSa3AEEM4Q@mail.gmail.com>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
 <1471610295-1456-4-git-send-email-marc.zyngier@arm.com>
 <20160901124629.GF10162@cbox> <57C83B14.6020501@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE21340F9B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 10:32:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9AAtj75i-yzE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 10:32:03 -0400 (EDT)
Received: from mail-ua0-f177.google.com (mail-ua0-f177.google.com
 [209.85.217.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F9B9407A5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 10:32:02 -0400 (EDT)
Received: by mail-ua0-f177.google.com with SMTP id i32so148943805uai.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Sep 2016 07:40:13 -0700 (PDT)
In-Reply-To: <57C83B14.6020501@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 September 2016 at 15:28, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 01/09/16 13:46, Christoffer Dall wrote:
>> On Fri, Aug 19, 2016 at 01:38:13PM +0100, Marc Zyngier wrote:
>>> +                    __skip_instr(vcpu);
>>
>> does this interact in any amusing way with single-step guest debugging?
>
> Ouch. Good point. Actually, nothing that uses kvm_skip_instr() works for
> singlestep/watchpoint either (trapped sysreg, WFx, spurious traps,
> MMIO). I guess that's something we need to fix overall.

I vaguely remember having conversations about this way way back.
All the "advance one insn" stuff (including how the singlestep
state machine gets advanced) is probably on the wrong side of
"return to userspace".

thanks
-- PMM
