From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Tue, 21 Mar 2017 22:10:41 +0000
Message-ID: <CAFEAcA_NBvRQpuXJ2iZs_8n3b6920Z6E5ueuiAeF-4JCcqPRxQ@mail.gmail.com>
References: <1489996534-8270-1-git-send-email-gengdongjiu@huawei.com>
 <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com> <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
 <20170321113428.GC15920@cbox>
 <58D17AF0.2010802@arm.com> <20170321193933.GB31111@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8484F40190
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 18:09:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ClnbQ4X6ZJ3A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 18:09:16 -0400 (EDT)
Received: from mail-wr0-f170.google.com (mail-wr0-f170.google.com
 [209.85.128.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23509400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 18:09:15 -0400 (EDT)
Received: by mail-wr0-f170.google.com with SMTP id g10so120274814wrg.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:11:02 -0700 (PDT)
In-Reply-To: <20170321193933.GB31111@cbox>
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, wuquanming@huawei.com, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, gengdongjiu <gengdongjiu@huawei.com>, Andre Przywara <andre.przywara@arm.com>, huangshaoyu@huawei.com, wangxiongfeng2@huawei.com, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 21 March 2017 at 19:39, Christoffer Dall <cdall@linaro.org> wrote:
> My confusion here comes from not thinking about QEMU or KVM as firmware,
> but as the machine, so it would be sort of like the functionality is
> baked into hardware rather than firmware.

There is precedent for that kind of thing -- we implement PSCI
in KVM/QEMU for the guest, though in real hardware it would be
provided by firmware at EL3.

thanks
-- PMM
