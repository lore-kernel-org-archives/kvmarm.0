From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: can we define a KVM_REG_ARM encoding bit for NonSecure/Secure ?
Date: Tue, 6 Mar 2018 14:28:08 +0000
Message-ID: <d4ab9fb5-4a19-697c-8851-58ed38fcff1c@arm.com>
References: <CAFEAcA8MEp0Uw3NFUVfy7wm--wpTZ591SsjhRgVjrPST47f5Wg@mail.gmail.com>
 <6ee3ff1c-7324-6fcf-651d-bc3404613330@arm.com>
 <CAFEAcA9gocsZU+rirJrTbhpeK5P9A8Ep4YB9899Yue8UqxgN1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D629402D6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Mar 2018 09:21:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bUQx+TIUezxz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Mar 2018 09:20:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA3A340192
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Mar 2018 09:20:58 -0500 (EST)
In-Reply-To: <CAFEAcA9gocsZU+rirJrTbhpeK5P9A8Ep4YB9899Yue8UqxgN1Q@mail.gmail.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/18 14:09, Peter Maydell wrote:
> On 6 March 2018 at 13:59, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 05/03/18 14:01, Peter Maydell wrote:
>>> #define KVM_REG_ARM_SECURE_MASK 0x0000000010000000
>>>
>>> in arch/arm/include/uapi/asm/kvm.h
>>>
>>> Does this seem like a good idea? (We could alternatively steal a bit
>>> from the top of the rather-over-specified 12 bit field for copro
>>> number, but AFAIK bit 28 isn't used currently so is free.)
>>
>> I guess that'd be fine. If we ever have KVM running in S-EL2 on a v8.4
>> core, we'd be able to make use of this bit. Let's hope it never happens
>> though.
>>
>> Would you be able to write a patch for this please?
> 
> Sure. It's been a long time since I wrote a kernel patch: what
> git tree should I base it on ?
Any recent release tag in Linus' tree would do, such as v4.15.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
