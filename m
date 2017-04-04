From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 00/34] arm/arm64: KVM: Rework the hyp-stub API
Date: Tue, 4 Apr 2017 14:04:05 +0200
Message-ID: <20170404120405.GH11752@cbox>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20B4540B5B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 08:01:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KkkD4J3d4ZuK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 08:01:51 -0400 (EDT)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AAB340187
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 08:01:51 -0400 (EDT)
Received: by mail-wr0-f171.google.com with SMTP id t20so7184210wra.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 05:04:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
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
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Mon, Apr 03, 2017 at 07:37:33PM +0100, Marc Zyngier wrote:
> As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
> could do with some TLC (it cannot perform a soft-restart at HYP, and
> has holes in the hyp-stub support in a number of places). In general,
> it would be desirable for the 32bit behaviour to align on 64bit, if
> only to ease maintenance.
> 
> This series implements the following:
> - Add HVC_[GS]ET_VECTORS and HVC_SOFT_RESTART to the 32bit code
> - Add HVC_RESET_VECTORS to both arm and arm64, removing the need for
>   __hyp_reset_vectors
> - Implement add the stub entry points in the KVM init code, which
>   didn't implement any so far
> - Convert the HYP code to use the init code stubs directly
> - Some general cleanup as a result of these changes (which includes
>   killing HVC_GET_VECTORS)
> - Add some API documentation that covers the above
> 
> Patches 14 to 16 would be better squashed into 12 and 13, but I've
> kept them separate so that I can take the blame for everything I've
> broken.
> 
> I've tested this on arm (Cubietruck, Jetson TK1) and arm64 (Seattle),
> both as host and guest. Keerthy has been kind enough to test the 32bit
> code on DRA7-EVM, AM57XX-EVM and KEYSTONE-K2E-EVM.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-December/473472.html
> 
> * From v4:
>   - Added a standard return value on stub hypercall failure
>   - Zero r0/x0 on successful hypercall
>   - Make 32bit ARM resistant to kvm_reboot while executing a guest
>   - Update documentation to reflect the calling convention expectations
>   - Added Acks from Catalin
>   - Rebased on 4.11-rc5

Thanks for doing the changes.

I have applied your patches to kvmarm/queue.

-Christoffer
