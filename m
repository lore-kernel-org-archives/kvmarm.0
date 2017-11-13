From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Mon, 13 Nov 2017 13:05:19 +0000
Message-ID: <CAFEAcA_yRT7829=reU=vnAiHWy-9oP1G84v0w_ST8C3VxpskNA@mail.gmail.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <5A049B20.6000501@arm.com> <20171113112946.GK14144@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A799649D6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 08:03:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FX8BXHhyX08Y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 08:03:30 -0500 (EST)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85AD349D53
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 08:03:30 -0500 (EST)
Received: by mail-wr0-f171.google.com with SMTP id o88so14341989wrb.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 05:05:41 -0800 (PST)
In-Reply-To: <20171113112946.GK14144@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Jonathan.Zhang@cavium.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, wangxiongfeng2@huawei.com, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 November 2017 at 11:29, Christoffer Dall <cdall@linaro.org> wrote:
> I'm thinking this is analogous to migrating a VM that uses an irqchip in
> userspace and has set the IRQ or FIQ lines using KVM_IRQ_LINE.  My
> feeling is that this is also not supported today.

Oops, yes, we completely forgot about migration when we added
that feature... I think you're right that we won't get that right.

thanks
-- PMM
