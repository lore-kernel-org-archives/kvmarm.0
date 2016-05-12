From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v3 27/55] KVM: arm/arm64: vgic-new: Add PRIORITY registers
 handlers
Date: Thu, 12 May 2016 10:56:57 +0100
Message-ID: <CAFEAcA95nt_4wueOTzergNfupg4zGMTj_EQgCLrRunpg6GUbPA@mail.gmail.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-28-git-send-email-andre.przywara@arm.com>
 <57344889.1050802@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A70B149B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 05:54:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jZvChNei3DNC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 05:54:16 -0400 (EDT)
Received: from mail-vk0-f49.google.com (mail-vk0-f49.google.com
 [209.85.213.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D051149B2C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 05:54:16 -0400 (EDT)
Received: by mail-vk0-f49.google.com with SMTP id f66so90951937vkh.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 02:57:17 -0700 (PDT)
In-Reply-To: <57344889.1050802@arm.com>
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
Cc: Andre Przywara <andre.przywara@arm.com>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 12 May 2016 at 10:10, Marc Zyngier <marc.zyngier@arm.com> wrote:
> This is wrong. We should only write the number of bits of priority we
> actually emulate. And given that we use a common framework for v2 and
> v3, this should probably be 5 bits (32 priorities should be enough for
> everybody).

FWIW QEMU's GICv2 and GICv3 emulations both implement the full
8 bits of priority.

thanks
-- PMM
