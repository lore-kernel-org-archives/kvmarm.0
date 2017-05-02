From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Fix decoding of Rt/Rt2 when trapping AArch32
 CP accesses
Date: Tue, 2 May 2017 09:30:26 +0200
Message-ID: <20170502073026.GD16940@cbox>
References: <20170427180648.25159-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDE4F40B5E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 03:27:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GI0Iy5blPoEY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 May 2017 03:27:26 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8647F40B3E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 03:27:26 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id m123so9494663wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 May 2017 00:30:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170427180648.25159-1-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 27, 2017 at 07:06:48PM +0100, Marc Zyngier wrote:
> Our 32bit CP14/15 handling inherited some of the ARMv7 code for handling
> the trapped system registers, completely missing the fact that the
> fields for Rt and Rt2 are now 5 bit wide, and not 4...
> 
> Let's fix it, and provide an accessor for the most common Rt case.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

Aplied to kvmarm/queue.

Thanks,
-Christoffer
