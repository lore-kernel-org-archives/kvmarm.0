From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC v2 10/10] KVM: arm/arm64: Emulate the EL1 phys timer
 register access
Date: Mon, 30 Jan 2017 12:38:07 -0500
Message-ID: <CAHyh4ximsWC+9UBc7=zinoqbnt9y1dOWzMqmTBLZ0SkS5HzPFA@mail.gmail.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-11-git-send-email-jintack@cs.columbia.edu>
 <86lgtt98gs.fsf@arm.com>
 <CAHyh4xhgNYjpyaGz=UtFfC+smh6CVZgJ530WWmwwmpg=Bi799A@mail.gmail.com>
 <CAFEAcA8BfUQTrdpNtkkB2kh=dLyOCjuBv2vVWZML8px8D0JJ9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60E69408EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:37:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xIMiOEvgjEbj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 12:37:52 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 537D540838
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:37:52 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0UHZDah012458
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:38:10 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 40CAE81
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:38:10 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id DDF6E9E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:38:09 -0500 (EST)
Received: from mail-vk0-f71.google.com (mail-vk0-f71.google.com
 [209.85.213.71])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0UHc98M005406
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:38:09 -0500
Received: by mail-vk0-f71.google.com with SMTP id t8so193230565vke.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:38:09 -0800 (PST)
Received: from mail-ua0-f175.google.com (mail-ua0-f175.google.com.
 [209.85.217.175])
 by smtp.gmail.com with ESMTPSA id d63sm5214314vkh.4.2017.01.30.09.38.08
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 30 Jan 2017 09:38:08 -0800 (PST)
Received: by mail-ua0-f175.google.com with SMTP id 96so255044795uaq.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:38:08 -0800 (PST)
In-Reply-To: <CAFEAcA8BfUQTrdpNtkkB2kh=dLyOCjuBv2vVWZML8px8D0JJ9Q@mail.gmail.com>
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
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

On Mon, Jan 30, 2017 at 12:26 PM, Peter Maydell
<peter.maydell@linaro.org> wrote:
> On 30 January 2017 at 17:08, Jintack Lim <jintack@cs.columbia.edu> wrote:
>> On Sun, Jan 29, 2017 at 10:44 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> Shouldn't we take the ENABLE bit into account? The ARMv8 ARM version I
>>> have at hand (version h) seems to indicate that we should, but we should
>>> check with the latest and greatest...
>>
>> Thanks! I was not clear about this. I have ARM ARM version k, and it
>> says that 'When the value of the ENABLE bit is 0, the ISTATUS field is
>> UNKNOWN.' So I thought the istatus value doesn't matter if ENABLE is
>> 0, and just set istatus bit regardless of ENABLE bit. If this is not
>> what the manual meant, then I'm happy to fix this.
>
> It looks like the spec has been relaxed between the doc version
> that Marc was looking at and the current one. So it's OK for
> an implementation to either (a) set ISTATUS to 0 if ENABLE
> is 0, or (b) do what you've done and set ISTATUS according
> to the timer comparison whether ENABLE is clear or not
> (or even (c) set ISTATUS to a random value if ENABLE is clear,
> and other less likely choices).
> I think we should add a comment to note that it's architecturally
> UNKNOWN and we've made a choice for our implementation convenience.

Thanks for the clarification. I'll put a comment in v3.

>
> thanks
> -- PMM
>
