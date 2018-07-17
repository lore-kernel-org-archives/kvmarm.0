From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] arm64: timer: Add TVAL timeout IRQ
 trigger test
Date: Tue, 17 Jul 2018 12:53:01 +0200
Message-ID: <20180717105301.eutivgp2uyuz7ck5@kamzik.brq.redhat.com>
References: <20180716151438.9877-1-andre.przywara@arm.com>
 <20180716151438.9877-3-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B823E4A169
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jul 2018 06:40:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N9hxb+97wdLy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jul 2018 06:40:03 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 253344A159
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jul 2018 06:40:03 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180716151438.9877-3-andre.przywara@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 16, 2018 at 04:14:38PM +0100, Andre Przywara wrote:
> So far we were only testing the CVAL register. Add a test which programs
> a (relative) TVAL value to check this functionality as well.
> Also we go into WFI and wait for the interrupt to release us from it.
> The timer tests are run with a 2 second timeout on the host side, so
> that any failure in coming back would be covered.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/timer.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
