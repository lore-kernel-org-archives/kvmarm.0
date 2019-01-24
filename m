From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/7] lib: arm: Discover ns16550a UART
Date: Thu, 24 Jan 2019 14:11:51 +0100
Message-ID: <20190124131151.zv7bncpuqyogvgf6@kamzik.brq.redhat.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-2-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52F2E4A3B7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 08:11:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZC2kOjVOD--i for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 08:11:56 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D62A4A3B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 08:11:56 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190124111634.4727-2-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 24, 2019 at 11:16:28AM +0000, Alexandru Elisei wrote:
> Add support for discovering the ns16550a UART from the device tree. This
> particular UART model is emulated by kvmtool.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/io.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index d2c1a07c19ee..35fc05aeb4db 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -32,22 +32,26 @@ static volatile u8 *uart0_base = (u8 *)UART_EARLY_BASE;
>  
>  static void uart0_init(void)
>  {
> -	const char *compatible = "arm,pl011";
> +	const char *compatible[] = {"arm,pl011", "ns16550a"};
>  	struct dt_pbus_reg base;
> -	int ret;
> +	int i, ret;
>  
>  	ret = dt_get_default_console_node();
>  	assert(ret >= 0 || ret == -FDT_ERR_NOTFOUND);
>  
>  	if (ret == -FDT_ERR_NOTFOUND) {
>  
> -		ret = dt_pbus_get_base_compatible(compatible, &base);
> -		assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
> +		for (i = 0; i < ARRAY_SIZE(compatible); i++) {
> +			ret = dt_pbus_get_base_compatible(compatible[i], &base);
> +			assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
> +
> +			if (ret == 0)
> +				break;
> +		}
>  
>  		if (ret) {
> -			printf("%s: %s not found in the device tree, "
> -				"aborting...\n",
> -				__func__, compatible);
> +			printf("%s: Compatible UART not found in the device tree, "
> +				"aborting...\n", __func__);
>  			abort();
>  		}
>  
> -- 
> 2.17.0
>

I agree with Andre that we should document this UART "driver" only ever
writes to the TX register. And that it assumes that TX register is at
the 0th offset.

Thanks,
drew
