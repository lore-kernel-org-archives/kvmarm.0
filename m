From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm64: timer: Avoid IRQ race in timer test
Date: Wed, 2 Aug 2017 17:53:12 +0200
Message-ID: <20170802155312.yep4rywinl5pmc6i@kamzik.brq.redhat.com>
References: <20170726114249.17774-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 961BF49C31
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Aug 2017 11:52:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I5vUtILTyqr6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Aug 2017 11:51:59 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE0AD49C30
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Aug 2017 11:51:59 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170726114249.17774-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 26, 2017 at 01:42:49PM +0200, Christoffer Dall wrote:
> The current timer test relies on testing the pending state of the timer
> before the interrupt handler has run which could lower the pending
> signal again (because it masks the timer output signal).
> 
> What we really want is to make sure the output signal from the timer as
> perceived by the virtual interrupt controller is low when the timer is
> programmed some time far in the future.  The proper way to do that is to
> disable the timer interrupt on the distributor and then reading its
> pending state.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  arm/timer.c | 41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
>

Hi Christoffer,

With this patch the ptimer "not pending before" test always
fails on KVM for me (tested on mustang and thunderx). Have
you seen that?

Thanks,
drew
