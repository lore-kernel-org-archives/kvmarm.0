From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 15/15] KVM: arm: enable trapping of all debug registers
Date: Tue, 29 Sep 2015 09:38:14 +0200
Message-ID: <20150929073814.GE9002@cbox>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
 <1439213167-8988-16-git-send-email-zhichao.huang@linaro.org>
 <20150902160814.GS10991@cbox> <560A2499.3030409@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4221E4130A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 03:36:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3qf+EArWzvq1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2015 03:36:41 -0400 (EDT)
Received: from mail-la0-f47.google.com (mail-la0-f47.google.com
 [209.85.215.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DAFF41252
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 03:36:40 -0400 (EDT)
Received: by laclj5 with SMTP id lj5so92570716lac.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 00:38:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <560A2499.3030409@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, huangzhichao@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 29, 2015 at 01:41:45PM +0800, Zhichao Huang wrote:
> 
> 
> On 2015/9/3 0:08, Christoffer Dall wrote:
> > On Mon, Aug 10, 2015 at 09:26:07PM +0800, Zhichao Huang wrote:
> >> Enable trapping of the debug registers unconditionally, allowing guests to
> >> use the debug infrastructure.
> >>
> >> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> >> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> ---
> >>  arch/arm/kvm/interrupts_head.S | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> >> index 7ad0adf..494991d 100644
> >> --- a/arch/arm/kvm/interrupts_head.S
> >> +++ b/arch/arm/kvm/interrupts_head.S
> >> @@ -792,7 +792,7 @@ ARM_BE8(rev	r6, r6  )
> >>   * (hardware reset value is 0) */
> >>  .macro set_hdcr operation
> >>  	mrc	p15, 4, r2, c1, c1, 1
> >> -	ldr	r3, =(HDCR_TPM|HDCR_TPMCR)
> >> +	ldr	r3, =(HDCR_TPM|HDCR_TPMCR|HDCR_TDRA|HDCR_TDOSA|HDCR_TDA)
> > 
> > eh, but I thought we didn't have to trap accesses to the debug registers
> > if we switch them, because the guest is likely to be using them?
> > 
> > Maybe I am getting confused, can you repeat for me exactly when we
> > context-switch the registers and when we trap accesses to them?
> > 
> 
> Since we don't want to world switch the dangerous register(DBGDSCR), we have
> to trap accesses all the time, to prevent the guest to write to the real register.
> 
ok, so this is in line with my comment to your previous patch, but you
did have world-switching code of DBGDSCR in this series, hence my
confusion.  So you would need to get rid of this for the new version of
the series.

Thanks,
-Christoffer
