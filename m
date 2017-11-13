From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Mon, 13 Nov 2017 17:56:14 +0000
Message-ID: <CAFEAcA-uS0gyKHTvNxdTihoi37D=6jCTwzUTjFQttR=mivheBA@mail.gmail.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <5A049B20.6000501@arm.com> <20171113112946.GK14144@cbox>
 <20171113161445.xfqyuntza76ckdmq@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37B3D49D6E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 12:54:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fu-1zRMhyiNo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 12:54:24 -0500 (EST)
Received: from mail-wr0-f177.google.com (mail-wr0-f177.google.com
 [209.85.128.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 345E449D53
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 12:54:24 -0500 (EST)
Received: by mail-wr0-f177.google.com with SMTP id l22so15164847wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 09:56:35 -0800 (PST)
In-Reply-To: <20171113161445.xfqyuntza76ckdmq@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Jonathan.Zhang@cavium.com, Christoffer Dall <cdall@linaro.org>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, wangxiongfeng2@huawei.com, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 November 2017 at 16:14, Andrew Jones <drjones@redhat.com> wrote:
> On Mon, Nov 13, 2017 at 12:29:46PM +0100, Christoffer Dall wrote:
>> I'm thinking this is analogous to migrating a VM that uses an irqchip in
>> userspace and has set the IRQ or FIQ lines using KVM_IRQ_LINE.  My
>> feeling is that this is also not supported today.
>
> Luckily userspace irqchip is mostly a debug feature, or just to support
> oddball hardware. Or at least that's the way I see its usecases...

True, but I think we should always insist on migration working
for new features, because it's just an easier line to define;
otherwise we end up with an annoying "feature mostly works,
unless you happened to be using [list of random things], in
which case it silently doesn't" effect.

thanks
-- PMM
