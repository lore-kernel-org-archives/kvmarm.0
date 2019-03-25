From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Mon, 25 Mar 2019 16:38:03 +0000
Message-ID: <CAFEAcA8K8Q969=3YyeuQso=0Y-MiPnyCCz1DhjtjV9UTc2p0Og@mail.gmail.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <20190325163249.rkk6vvnzex5d4z7k@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 385D84A2E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 12:38:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eAdBEzfMqV7d for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Mar 2019 12:38:15 -0400 (EDT)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45C1A4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 12:38:15 -0400 (EDT)
Received: by mail-oi1-f193.google.com with SMTP id w139so7473842oie.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 09:38:15 -0700 (PDT)
In-Reply-To: <20190325163249.rkk6vvnzex5d4z7k@kamzik.brq.redhat.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Dave Martin <Dave.Martin@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 25 Mar 2019 at 16:33, Andrew Jones <drjones@redhat.com> wrote:
>
> On Tue, Mar 19, 2019 at 05:51:51PM +0000, Dave Martin wrote:
> > This series implements support for allowing KVM guests to use the Arm
> > Scalable Vector Extension (SVE), superseding the previous v5 series [1].

> Hi Dave and Peter,
>
> Do either of you know if anyone has picked up the QEMU side of this?
> If not, then I'll take it.

Nobody has yet, so feel free.

thanks
-- PMM
