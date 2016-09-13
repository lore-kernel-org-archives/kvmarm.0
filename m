From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 03/10] arm64: KVM: Move vgic-v3 save/restore to
 virt/kvm/arm/hyp
Date: Tue, 13 Sep 2016 10:51:44 +0200
Message-ID: <20160913085144.GD5680@cbox>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-4-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38F4349B71
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IByDwQEzkxfR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 04:40:23 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17ACB49B6F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:22 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id i130so19714226wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 01:49:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473691764-29424-4-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 12, 2016 at 03:49:17PM +0100, Vladimir Murzin wrote:
> So we can reuse the code under arch/arm
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
