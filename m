From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] target-arm: Store SPSR_EL1 state in banked_spsr[1]
 (SPSR_svc)
Date: Tue, 17 Mar 2015 20:22:20 +0100
Message-ID: <20150317192220.GA23225@cbox>
References: <1426619975-2346-1-git-send-email-peter.maydell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52CA948F98
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 15:15:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ol8UNxrWRewR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2015 15:15:18 -0400 (EDT)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02E4D48F4C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 15:15:17 -0400 (EDT)
Received: by labjg1 with SMTP id jg1so17554474lab.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 12:21:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426619975-2346-1-git-send-email-peter.maydell@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, Greg Bellows <greg.bellows@linaro.org>, qemu-devel@nongnu.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 17, 2015 at 07:19:35PM +0000, Peter Maydell wrote:
> The AArch64 SPSR_EL1 register is architecturally mandated to
> be mapped to the AArch32 SPSR_svc register. This means its
> state should live in QEMU's env->banked_spsr[1] field.
> Correct the buggy regdef that put it in banked_spsr[0] instead.
> 
> Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
> ---
>  target-arm/helper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target-arm/helper.c b/target-arm/helper.c
> index 10886c5..d77c6de 100644
> --- a/target-arm/helper.c
> +++ b/target-arm/helper.c
> @@ -2438,7 +2438,7 @@ static const ARMCPRegInfo v8_cp_reginfo[] = {
>      { .name = "SPSR_EL1", .state = ARM_CP_STATE_AA64,
>        .type = ARM_CP_ALIAS,
>        .opc0 = 3, .opc1 = 0, .crn = 4, .crm = 0, .opc2 = 0,
> -      .access = PL1_RW, .fieldoffset = offsetof(CPUARMState, banked_spsr[0]) },
> +      .access = PL1_RW, .fieldoffset = offsetof(CPUARMState, banked_spsr[1]) },
>      /* We rely on the access checks not allowing the guest to write to the
>       * state field when SPSel indicates that it's being used as the stack
>       * pointer.
> -- 
> 1.9.1
> 

Don't you need to change aarch64_banked_spsr_index() accordingly?

-Christoffer
