From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 09/10] ARM: gic-v3: Introduce 32-to-64-bit mappings
 for GICv3 cpu registers
Date: Tue, 13 Sep 2016 10:52:09 +0200
Message-ID: <20160913085209.GI5680@cbox>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-10-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 889EB49B75
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6N1l1VCP6BC4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 04:40:48 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4D0249B6F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:48 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id c131so99858361wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 01:49:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473691764-29424-10-git-send-email-vladimir.murzin@arm.com>
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

On Mon, Sep 12, 2016 at 03:49:23PM +0100, Vladimir Murzin wrote:
> vgic-v3 save/restore routines are written in such way that they map
> arm64 system register naming nicely, but it does not fit to arm
> world. To keep virt/kvm/arm/hyp/vgic-v3-sr.c untouched we create a
> mapping with a function for each register mapping the 32-bit to the
> 64-bit accessors.
> 
> Please, note that 64-bit wide ICH_LR is split in two 32-bit halves
> (ICH_LR and ICH_LRC) accessed independently.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
