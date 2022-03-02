Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2CDC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 19:55:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A84CB49E2A;
	Wed,  2 Mar 2022 14:55:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P2HTj6jEpNMY; Wed,  2 Mar 2022 14:55:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84C2B49E10;
	Wed,  2 Mar 2022 14:55:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF14A43C96
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 14:55:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Pq5kGa4XWRJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 14:55:31 -0500 (EST)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C784A40B64
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 14:55:31 -0500 (EST)
Received: by mail-io1-f41.google.com with SMTP id t11so3216056ioi.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 11:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=t48F+updsV7T2pr/t57RE2xz11TJHa9Jd7tNCDUAq/8=;
 b=TYAxFlG/fB4zbMIlTaqNBs1Z0P4LQ18nao+fVPmsTJPImo3mo3fWLx+eQ2JVc3lRWp
 Tb4h+Ndoj+4HFpacdhGJtTp0wLbxe8NipiZ7IZmOr2FRL4hAw6vxRnDeNWYmmuKaiC4B
 fsGU7gso+iwqoPr0ZAis8DW/PL60NyvTEksLGDB21VE3Mdy9WvPioubovzUAvoKRlNf/
 WJQGgyJHWxgYWhrLyfT4xOZ5TnwkwgSzWj5oW1G0BCX0Mf6L57Qmsx+tqC0ylp6APHgH
 a5QAzRIDAfqQfZbeRJonXbI9pJHAQqO4i4kSM3HAlZBnylq5JD0bk5vZMwcaf82o0EPi
 E2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=t48F+updsV7T2pr/t57RE2xz11TJHa9Jd7tNCDUAq/8=;
 b=ev2FcvIV6bHBrembaKThQkM5v2oYqbQ4XeYt3sZrxOaDt2FWBrbkJrSRybcUWnt+fH
 0tr7h2774o4aqyo1TbAQyyW5We/kIumFXaz7Vm+utc1kd5Pi9yYEdTtSIvD8idfl1rnk
 vlzp0MFbvYMVC6h0SkiUq2R0i3TJY8tQck9EurZV+sTCsxnqHCJQ8FDIjf6+26tSYpZn
 z5YQw/tfdwUfkJAlC0GSB0wkLfscckFs5Z5wppj7m6SaqCxpwhXLAtxwX8F1c6uCyaI9
 11UTBaGBWWHJrUYt81rY+QIanIeLCJbzwUVlDhvckMabtZiYiMdKkLwRafB8hp48Xo2q
 pS8Q==
X-Gm-Message-State: AOAM531IDliYajZIjAJJ7lk+zrHjlUEZvwav6X97fm0vAoZ44/kcRB4o
 yb1zrJnQl+Yz5Y7uM18XpHX2yQ==
X-Google-Smtp-Source: ABdhPJx7CPtEkHkG+44IZ4Lz4AGVrSAfzwK12Oo2APntBBtYATw0leJMlE93nhI9PHg/1e3LWJhz8w==
X-Received: by 2002:a02:69cc:0:b0:314:3518:780b with SMTP id
 e195-20020a0269cc000000b003143518780bmr26021611jac.133.1646250930988; 
 Wed, 02 Mar 2022 11:55:30 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 r3-20020a92ac03000000b002c3dfcb9a6csm3664750ilh.77.2022.03.02.11.55.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Mar 2022 11:55:30 -0800 (PST)
Date: Wed, 2 Mar 2022 19:55:26 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: selftests: add timer_get_tval() lib
 function
Message-ID: <Yh/LrphX9no9FRzR@google.com>
References: <20220302172144.2734258-1-ricarkol@google.com>
 <20220302172144.2734258-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220302172144.2734258-2-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Mar 02, 2022 at 09:21:42AM -0800, Ricardo Koller wrote:
> Add timer_get_tval() into the arch timer library functions in
> selftests/kvm. Bonus: change the set_tval function to get an int32_t
> (tval is signed).
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  .../selftests/kvm/include/aarch64/arch_timer.h | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> index cb7c03de3a21..93f35a4fc1aa 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> @@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
>  	return 0;
>  }
>  
> -static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
> +static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
>  {
>  	switch (timer) {
>  	case VIRTUAL:
> @@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
>  	isb();
>  }
>  
> +static inline int32_t timer_get_tval(enum arch_timer timer)
> +{
> +	isb();
> +	switch (timer) {
> +	case VIRTUAL:
> +		return (int32_t)read_sysreg(cntv_tval_el0);
> +	case PHYSICAL:
> +		return (int32_t)read_sysreg(cntp_tval_el0);
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	/* We should not reach here */
> +	return 0;
> +}
> +
>  static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
>  {
>  	switch (timer) {
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
