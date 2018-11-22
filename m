From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH v2 11/23] KVM: arm64: Support runtime sysreg filtering
 for KVM_GET_REG_LIST
Date: Thu, 22 Nov 2018 12:59:10 +0000
Message-ID: <CAFEAcA_G1ceUGnDX5u6bK_pX_7-tAHtP8+NkAkK-vKOhzC1hyA@mail.gmail.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-12-git-send-email-Dave.Martin@arm.com>
 <20181102081625.GS12057@e113682-lin.lund.arm.com>
 <20181115172711.GQ3505@e103592.cambridge.arm.com>
 <20181122105344.GF17441@e113682-lin.lund.arm.com>
 <CAFEAcA8UEqxM7KJGm81ETgPpsO6ByK7Vc9SuCKr4FZGVU8vxxg@mail.gmail.com>
 <20181122123424.GG17441@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A7EC4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 07:59:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c4TiNwU8soMt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Nov 2018 07:59:31 -0500 (EST)
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
 [209.85.210.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9521A4A1DC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 07:59:31 -0500 (EST)
Received: by mail-ot1-f66.google.com with SMTP id u16so7974587otk.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 04:59:31 -0800 (PST)
In-Reply-To: <20181122123424.GG17441@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 22 November 2018 at 12:34, Christoffer Dall <christoffer.dall@arm.com> wrote:
> So on migration, will you have the required information for
> KVM_ARM_VCPU_INIT before setting the registers from the migration
> stream?
>
> (I assume so, because presumably this comes from a command-line switch
> or from the machine definition, which must match the source.)

Yes. QEMU always sets up the VCPU completely before doing any
inbound migration.

> Therefore, I don't think there's an issue with this patch, but from
> bitter experience I think we should enforce ordering if possible.

Yes, if there are semantic ordering constraints on the various
calls it would be nice to have the kernel enforce them.

thanks
-- PMM
