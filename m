From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: can we define a KVM_REG_ARM encoding bit for NonSecure/Secure ?
Date: Tue, 6 Mar 2018 14:09:05 +0000
Message-ID: <CAFEAcA9gocsZU+rirJrTbhpeK5P9A8Ep4YB9899Yue8UqxgN1Q@mail.gmail.com>
References: <CAFEAcA8MEp0Uw3NFUVfy7wm--wpTZ591SsjhRgVjrPST47f5Wg@mail.gmail.com>
 <6ee3ff1c-7324-6fcf-651d-bc3404613330@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A209C4029E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Mar 2018 09:02:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4zO4rI1sUIJ4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Mar 2018 09:02:13 -0500 (EST)
Received: from mail-oi0-f43.google.com (mail-oi0-f43.google.com
 [209.85.218.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2F6A40192
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Mar 2018 09:02:13 -0500 (EST)
Received: by mail-oi0-f43.google.com with SMTP id u73so14906970oie.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Mar 2018 06:09:26 -0800 (PST)
In-Reply-To: <6ee3ff1c-7324-6fcf-651d-bc3404613330@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 6 March 2018 at 13:59, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 05/03/18 14:01, Peter Maydell wrote:
>> #define KVM_REG_ARM_SECURE_MASK 0x0000000010000000
>>
>> in arch/arm/include/uapi/asm/kvm.h
>>
>> Does this seem like a good idea? (We could alternatively steal a bit
>> from the top of the rather-over-specified 12 bit field for copro
>> number, but AFAIK bit 28 isn't used currently so is free.)
>
> I guess that'd be fine. If we ever have KVM running in S-EL2 on a v8.4
> core, we'd be able to make use of this bit. Let's hope it never happens
> though.
>
> Would you be able to write a patch for this please?

Sure. It's been a long time since I wrote a kernel patch: what
git tree should I base it on ?

thanks
-- PMM
