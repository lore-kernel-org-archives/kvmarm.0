Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4774B30E83D;
	Fri, 12 Sep 2025 16:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757696038; cv=none; b=Wz41EqoWXtDaA+QEZX1bRdNnpqFjCQYWcpyummHeqje+gRD+MVOImHGiHkIPs1ZkW0G01pFHXbQhsU6R4SoLZquqwT+IgxfjPmSNciBDCQxAEbk2tMhgjoK7EWYIYgHPgl/oUUB1A8DL8fW3qcyR/25KsHfcV5j5Gw/D5djK/78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757696038; c=relaxed/simple;
	bh=uUFnrieoLxzSat6u+ShEFsAWL4sxsVEqWU61B/F1RO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QF+rXADt2+73SG/D42HcWdzAvNjEkqOrnU0la60DlZXwgO7J+f9RgPj2adpvItlBWRorFke6VQi5/TfGuvFYFzMVsFE2Wz1lo2W6sd0GBwGxMIF1fwgh0IZQDGvxm1mA/z4UtT/x9GuQbFiY+79AOsxeHYcV/a0Qh9X2Zjtb5AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D870C4CEF1;
	Fri, 12 Sep 2025 16:53:55 +0000 (UTC)
Date: Fri, 12 Sep 2025 17:53:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMRQIeIdyiWVR8a0@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151929.197589-5-yeoreum.yun@arm.com>

On Sat, Aug 16, 2025 at 04:19:27PM +0100, Yeoreum Yun wrote:
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index bc06691d2062..ab7003cb4724 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -7,17 +7,21 @@
> 
>  #include <linux/futex.h>
>  #include <linux/uaccess.h>
> +#include <linux/stringify.h>
> 
>  #include <asm/errno.h>
> 
> -#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> +#define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */

I just noticed - you might as well leave the name as is here, especially
if in patch 6 you align down address and use CAS on a 64-bit value as
per Will's comment (and it's no longer LLSC). I think renaming this is
unnecessary.

-- 
Catalin
