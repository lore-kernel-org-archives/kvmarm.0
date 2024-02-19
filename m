Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41F5A44388
	for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708361771; cv=none; b=qucEtku9rq5BJzAD+AxFyUZkUCfpid8x5cN1xuZCaE9LZbTgtKuoEY15sOwegDQ07AYIKV6L1+P4XsV83dTJowXnxqqdKHWu4ewFtR7nKGwn5DAhyao0N8kcl95DD0a1M9BRBFg7kCn8B9Y0lGflriVm94mzd5+wYL2/VtBR6Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708361771; c=relaxed/simple;
	bh=AkPcE8McHBhy/l2wJWb/CDxJG7R5AjV1tCPwRaX1pcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7cPYrzQVOpTQnmaQsoW9QYjNHWz/JmQvfDfjer5b8uknAYie0gGeUu3U58vkBvxXFK1Q0GYoeKBRaeZMsRkNo0604Oj1fPPl1FK0BV23G/RfbCwA6jnr3fA4FG52mcn/kPB9k4dLbxNZIavOLfXh8v4wiwinax107XsHtbLjN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B307DA7;
	Mon, 19 Feb 2024 08:56:49 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C1CF3F762;
	Mon, 19 Feb 2024 08:56:08 -0800 (PST)
Date: Mon, 19 Feb 2024 16:56:05 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
Message-ID: <ZdOIJfvVm7C23ZdZ@raptor>
References: <20240216140210.70280-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240216140210.70280-1-thuth@redhat.com>

Hi,

Thanks for writing this. I've tested it with kvmtool, which emulates a 8250
UART:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

This fixes a longstanding bug with kvmtool, where migrate_once() would read
the last character that was sent, and then think that migration was
completed even though it was never performed.

While we are on the subject of migration:

SKIP: gicv3: its-migration: Test requires at least 4 vcpus
Now migrate the VM, then press a key to continue...
INFO: gicv3: its-migration: Migration complete
SUMMARY: 1 tests, 1 skipped

That's extremely confusing. Why is migrate_once() executed after the
test_its_pending() function call without checking if the test was skipped?

Nitpicks below.

On Fri, Feb 16, 2024 at 03:02:10PM +0100, Thomas Huth wrote:
> getchar() can currently only be called once on arm since the implementation
> is a little bit too  naïve: After the first character has arrived, the
> data register never gets set to zero again. To properly check whether a
> byte is available, we need to check the "RX fifo empty" on the pl011 UART
> or the "RX data ready" bit on the ns16550a UART instead.
> 
> With this proper check in place, we can finally also get rid of the
> ugly assert(count < 16) statement here.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/arm/io.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index c15e57c4..836fa854 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -28,6 +28,7 @@ static struct spinlock uart_lock;
>   */
>  #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
>  static volatile u8 *uart0_base = UART_EARLY_BASE;
> +bool is_pl011_uart;
>  
>  static void uart0_init_fdt(void)
>  {
> @@ -59,7 +60,10 @@ static void uart0_init_fdt(void)
>  			abort();
>  		}
>  
> +		is_pl011_uart = (i == 0);
>  	} else {
> +		is_pl011_uart = !fdt_node_check_compatible(dt_fdt(), ret,
> +		                                           "arm,pl011");
>  		ret = dt_pbus_translate_node(ret, 0, &base);
>  		assert(ret == 0);
>  	}
> @@ -111,31 +115,21 @@ void puts(const char *s)
>  	spin_unlock(&uart_lock);
>  }
>  
> -static int do_getchar(void)
> +int __getchar(void)
>  {
> -	int c;
> +	int c = -1;
>  
>  	spin_lock(&uart_lock);
> -	c = readb(uart0_base);
> -	spin_unlock(&uart_lock);
> -
> -	return c ?: -1;
> -}
> -
> -/*
> - * Minimalist implementation for migration completion detection.
> - * Without FIFOs enabled on the QEMU UART device we just read
> - * the data register: we cannot read more than 16 characters.
> - */
> -int __getchar(void)
> -{
> -	int c = do_getchar();
> -	static int count;
>  
> -	if (c != -1)
> -		++count;
> +	if (is_pl011_uart) {
> +		if (!(readb(uart0_base + 6 * 4) & 0x10))  /* RX not empty? */

I think it would be useful if the magic numbers were replaced by something
less opaque, something like:

		if (!(readb(uart0_base + PL011_UARTFR) & PL011_UARTFR_RXFE))

> +			c = readb(uart0_base);
> +	} else {
> +		if (readb(uart0_base + 5) & 0x01)         /* RX data ready? */

Same as above, perhaps:

		if (readb(uart0_base + UART16550_LSR) & UART16550_LSR_DR)

Naming of course being subject to taste.

Thanks,
Alex

> +			c = readb(uart0_base);
> +	}
>  
> -	assert(count < 16);
> +	spin_unlock(&uart_lock);
>  
>  	return c;
>  }
> -- 
> 2.43.0
> 
