From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 04/10] KVM: arm64: vgic-its: Introduce config option
 to guard ITS specific code
Date: Tue, 13 Sep 2016 10:51:48 +0200
Message-ID: <20160913085148.GE5680@cbox>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-5-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD63B49B7B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y5e2WirQo9wc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 04:40:27 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09B1749B7A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:26 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id b187so174736274wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 01:49:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473691764-29424-5-git-send-email-vladimir.murzin@arm.com>
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

On Mon, Sep 12, 2016 at 03:49:18PM +0100, Vladimir Murzin wrote:
> By now ITS code guarded with KVM_ARM_VGIC_V3 config option which was
> introduced to hide everything specific to vgic-v3 from 32-bit world.
> We are going to support vgic-v3 in 32-bit world and KVM_ARM_VGIC_V3
> will gone, but we don't have support for ITS there yet and we need to
> continue keeping ITS away.
> Introduce the new config option to prevent ITS code being build in
> 32-bit mode when support for vgic-v3 is done.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
