Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5990C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jul 2022 09:43:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 826D74BB79;
	Mon, 11 Jul 2022 05:43:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gRHldkyXytjO; Mon, 11 Jul 2022 05:43:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB50B4BB54;
	Mon, 11 Jul 2022 05:42:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6B84B57E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 15:35:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IwfrxHUcSqVO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 15:35:37 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88CA94B569
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 15:35:37 -0400 (EDT)
Date: Fri, 8 Jul 2022 12:35:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1657308932;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=3Ycz7xdndecdoawfzbIyPAd3t3ebJtVTm3UIiAKwNFg=;
 b=olzZ+ookEIfsTd28pXfJRmRAuF2JhpMmJkZGekjmDkJWrRfcTMaB4oKdkxiZnMiKk1m9pp
 0qjzQzyC4BkzeXkoddp7UEhYYP3FV7I+XT8g4sLVkvS8MLL+lToUNsChah6E3OfBHQcqtD
 EWKCDcynDRaXTRZgGSXVaFl8j2Z0eN4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 06/19] KVM: arm64: Get rid of reg_from/to_user()
Message-ID: <YsiG/ylMObDiDE91@google.com>
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-7-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220706164304.1582687-7-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Mon, 11 Jul 2022 05:42:55 -0400
Cc: kvm@vger.kernel.org, kernel-team@android.com, Schspa Shi <schspa@gmail.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Jul 06, 2022 at 05:42:51PM +0100, Marc Zyngier wrote:
> These helpers are only used by the invariant stuff now, and while
> they pretend to support non-64bit registers, this only serves as
> a way to scare the casual reviewer...
> 
> Replace these helpers with our good friends get/put_user(), and
> don't look back.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/sys_regs.c | 33 +++++++++------------------------
>  1 file changed, 9 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1ce439eed3d8..b66be9df7a02 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -44,8 +44,6 @@
>   * 64bit interface.
>   */
>  
> -static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> -static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
>  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
>  
>  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> @@ -2661,21 +2659,7 @@ static struct sys_reg_desc invariant_sys_regs[] = {
>  	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
>  };
>  
> -static int reg_from_user(u64 *val, const void __user *uaddr, u64 id)
> -{
> -	if (copy_from_user(val, uaddr, KVM_REG_SIZE(id)) != 0)
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static int reg_to_user(void __user *uaddr, const u64 *val, u64 id)
> -{
> -	if (copy_to_user(uaddr, val, KVM_REG_SIZE(id)) != 0)
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static int get_invariant_sys_reg(u64 id, void __user *uaddr)
> +static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
>  {
>  	const struct sys_reg_desc *r;
>  
> @@ -2684,23 +2668,24 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
>  	if (!r)
>  		return -ENOENT;
>  
> -	return reg_to_user(uaddr, &r->val, id);
> +	if (put_user(r->val, uaddr))
> +		return -EFAULT;
> +
> +	return 0;
>  }
>  
> -static int set_invariant_sys_reg(u64 id, void __user *uaddr)
> +static int set_invariant_sys_reg(u64 id, u64 __user *uaddr)
>  {
>  	const struct sys_reg_desc *r;
> -	int err;
> -	u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
> +	u64 val;
>  
>  	r = get_reg_by_id(id, invariant_sys_regs,
>  			  ARRAY_SIZE(invariant_sys_regs));
>  	if (!r)
>  		return -ENOENT;
>  
> -	err = reg_from_user(&val, uaddr, id);
> -	if (err)
> -		return err;
> +	if (get_user(val, uaddr))
> +		return -EFAULT;
>  
>  	/* This is what we mean by invariant: you can't change it. */
>  	if (r->val != val)
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
