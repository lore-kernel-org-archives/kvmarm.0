From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 10/10] ARM: KVM: Support vgic-v3
Date: Tue, 13 Sep 2016 10:52:13 +0200
Message-ID: <20160913085213.GJ5680@cbox>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-11-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3E7B49B6F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MCoeFV9CLPj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 04:40:53 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE14C49B8D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:52 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id c131so99861895wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 01:49:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473691764-29424-11-git-send-email-vladimir.murzin@arm.com>
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

On Mon, Sep 12, 2016 at 03:49:24PM +0100, Vladimir Murzin wrote:
> This patch allows to build and use vgic-v3 in 32-bit mode.
> 
> Unfortunately, it can not be split in several steps without extra
> stubs to keep patches independent and bisectable.  For instance,
> virt/kvm/arm/vgic/vgic-v3.c uses function from vgic-v3-sr.c, handling
> access to GICv3 cpu interface from the guest requires vgic_v3.vgic_sre
> to be already defined.
> 
> It is how support has been done:
> 
> * handle SGI requests from the guest
> 
> * report configured SRE on access to GICv3 cpu interface from the guest
> 
> * required vgic-v3 macros are provided via uapi.h
> 
> * static keys are used to select GIC backend
> 
> * to make vgic-v3 build KVM_ARM_VGIC_V3 guard is removed along with
>   the static inlines
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
