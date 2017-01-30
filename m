From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC v2 10/10] KVM: arm/arm64: Emulate the EL1 phys timer
 register access
Date: Mon, 30 Jan 2017 17:26:04 +0000
Message-ID: <CAFEAcA8BfUQTrdpNtkkB2kh=dLyOCjuBv2vVWZML8px8D0JJ9Q@mail.gmail.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-11-git-send-email-jintack@cs.columbia.edu>
 <86lgtt98gs.fsf@arm.com>
 <CAHyh4xhgNYjpyaGz=UtFfC+smh6CVZgJ530WWmwwmpg=Bi799A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DEB340284
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:26:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3qI6kw7fHUzh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 12:26:08 -0500 (EST)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com
 [209.85.213.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1882D40190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:26:07 -0500 (EST)
Received: by mail-vk0-f44.google.com with SMTP id x75so220139777vke.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:26:25 -0800 (PST)
In-Reply-To: <CAHyh4xhgNYjpyaGz=UtFfC+smh6CVZgJ530WWmwwmpg=Bi799A@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30 January 2017 at 17:08, Jintack Lim <jintack@cs.columbia.edu> wrote:
> On Sun, Jan 29, 2017 at 10:44 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> Shouldn't we take the ENABLE bit into account? The ARMv8 ARM version I
>> have at hand (version h) seems to indicate that we should, but we should
>> check with the latest and greatest...
>
> Thanks! I was not clear about this. I have ARM ARM version k, and it
> says that 'When the value of the ENABLE bit is 0, the ISTATUS field is
> UNKNOWN.' So I thought the istatus value doesn't matter if ENABLE is
> 0, and just set istatus bit regardless of ENABLE bit. If this is not
> what the manual meant, then I'm happy to fix this.

It looks like the spec has been relaxed between the doc version
that Marc was looking at and the current one. So it's OK for
an implementation to either (a) set ISTATUS to 0 if ENABLE
is 0, or (b) do what you've done and set ISTATUS according
to the timer comparison whether ENABLE is clear or not
(or even (c) set ISTATUS to a random value if ENABLE is clear,
and other less likely choices).
I think we should add a comment to note that it's architecturally
UNKNOWN and we've made a choice for our implementation convenience.

thanks
-- PMM
