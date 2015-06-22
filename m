From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [RESEND PATCH v2 2/2] arm: KVM: keep arm vfp/simd exit handling
 consistent with arm64
Date: Sun, 21 Jun 2015 20:17:22 -0700
Message-ID: <55877E42.5070205@samsung.com>
References: <1434739306-23417-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A55956072
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Jun 2015 23:06:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IPhTjUCYT2Bp for <kvmarm@lists.cs.columbia.edu>;
 Sun, 21 Jun 2015 23:06:44 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 994685600B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Jun 2015 23:06:44 -0400 (EDT)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQB004UPT5AR230@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sun, 21 Jun 2015 23:17:34 -0400 (EDT)
In-reply-to: <1434739306-23417-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/19/2015 11:41 AM, Mario Smarduch wrote:
[...]

>
>  
> -host_switch_to_hyp:
> +	/* Guest is calling a hyp function, save minimum context branch to it */ 

Hi Marc,
    please correct Guest to Host (or word this to your preference).
Somehow wondered off on Friday :)

Thanks,
- Mario

>  	pop	{r0, r1, r2}
>  
>  	/* Check for __hyp_get_vectors */
> @@ -411,6 +407,10 @@ guest_trap:
>  
>  	@ Check if we need the fault information
>  	lsr	r1, r1, #HSR_EC_SHIFT
> +#ifdef CONFIG_VFPv3
> +	cmp	r1, #HSR_EC_CP_0_13
> +	beq	switch_to_guest_vfp
> +#endif
>  	cmp	r1, #HSR_EC_IABT
>  	mrceq	p15, 4, r2, c6, c0, 2	@ HIFAR
>  	beq	2f
> 
