From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 36/56] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS
 register handler
Date: Wed, 18 May 2016 16:14:08 +0200
Message-ID: <CAMJs5B8KZv=dGDYtrXo3FQ9sx2=G+rrTFgN10tLLfb4O+wBcGw@mail.gmail.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-37-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFDD5412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 10:10:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wnbkaHVwW5TJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 10:10:51 -0400 (EDT)
Received: from mail-yw0-f181.google.com (mail-yw0-f181.google.com
 [209.85.161.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CD97412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 10:10:51 -0400 (EDT)
Received: by mail-yw0-f181.google.com with SMTP id x189so48917645ywe.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 07:14:08 -0700 (PDT)
In-Reply-To: <1463392481-26583-37-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:24AM +0100, Andre Przywara wrote:
> We implement the only one ID register that is required by the
> architecture, also this is the one that Linux actually checks.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
