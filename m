From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v11 06/21] KVM: ARM64: Add access handler for PMCEID0 and
 PMCEID1 register
Date: Sat, 20 Feb 2016 13:30:33 +0000
Message-ID: <CAFEAcA8=iRkAMLStMzu0wAPWfXZ9vYu_YzEKrEyVrWHP4=VS2w@mail.gmail.com>
References: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com>
 <1454656456-11640-7-git-send-email-zhaoshenglong@huawei.com>
 <20160208120950.GC620@cbox> <56C866EB.9060105@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3D5449692
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Feb 2016 08:24:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P4iE-fqHxM4K for <kvmarm@lists.cs.columbia.edu>;
 Sat, 20 Feb 2016 08:24:24 -0500 (EST)
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com
 [209.85.213.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0BEB4968B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Feb 2016 08:24:23 -0500 (EST)
Received: by mail-vk0-f54.google.com with SMTP id c3so96962093vkb.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Feb 2016 05:30:53 -0800 (PST)
In-Reply-To: <56C866EB.9060105@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <shannon.zhao@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 20 February 2016 at 13:15, Shannon Zhao <shannon.zhao@linaro.org> wrote:
>
>
> On 2016/2/8 20:09, Christoffer Dall wrote:
>> Isn't it really a BUG_ON(p->is_write) ?
>>
>> Presumably a guest write to these registers will raise an undefined
>> exception in EL0/1 and we don't get here by any other path than the trap
>> handler, do we?
>
> Yeah, for EL1, it shouldn't get here. But for EL0, to support the function
> of PMUSERENR, we firstly trap the access to EL2, then according to the real
> value of PMUSERENR to decide whether inject an UND to EL1.

I thought the PMUSERENR check took priority over trap-to-EL2 checks
in the architecture; so if this is an EL0 access and you get to EL2
at all then you know that PMUSERENR is set to permit EL0 reads.

Similarly, UNDEF because of write-to-always-RO register has
priority over trap-to-EL2, so I think Christoffer is right
and you should never be able to get here for a write.
(This should be easy to write a test program for if you're unsure.)

thanks
-- PMM
