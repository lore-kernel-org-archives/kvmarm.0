From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 09/15] arm64: Add page size to the kernel image header
Date: Sat, 10 Oct 2015 19:22:03 +0200
Message-ID: <20151010172203.GI29128@cbox>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-10-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E32A4413E1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Oct 2015 13:19:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QRyoEqroGfjz for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Oct 2015 13:19:42 -0400 (EDT)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
 [209.85.217.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCD2041338
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Oct 2015 13:19:41 -0400 (EDT)
Received: by lbos8 with SMTP id s8so107892423lbo.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Oct 2015 10:21:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1442331684-28818-10-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Marc.Zyngier@arm.com, Catalin.Marinas@arm.com, Will.Deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 15, 2015 at 04:41:18PM +0100, Suzuki K. Poulose wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> This patch adds the page size to the arm64 kernel image header
> so that one can infer the PAGESIZE used by the kernel. This will
> be helpful to diagnose failures to boot the kernel with page size
> not supported by the CPU.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  Documentation/arm64/booting.txt |    7 ++++++-
>  arch/arm64/kernel/image.h       |    5 ++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
> index 7d9d3c2..aaf6d77 100644
> --- a/Documentation/arm64/booting.txt
> +++ b/Documentation/arm64/booting.txt
> @@ -104,7 +104,12 @@ Header notes:
>  - The flags field (introduced in v3.17) is a little-endian 64-bit field
>    composed as follows:
>    Bit 0:	Kernel endianness.  1 if BE, 0 if LE.
> -  Bits 1-63:	Reserved.
> +  Bit 1-2:	Kernel Page size.
> +			0 - Unspecified.
> +			1 - 4K
> +			2 - 16K
> +			3 - 64K
> +  Bits 3-63:	Reserved.
>  
>  - When image_size is zero, a bootloader should attempt to keep as much
>    memory as possible free for use by the kernel immediately after the
> diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
> index 8fae075..73b736c 100644
> --- a/arch/arm64/kernel/image.h
> +++ b/arch/arm64/kernel/image.h
> @@ -47,7 +47,10 @@
>  #define __HEAD_FLAG_BE	0
>  #endif
>  
> -#define __HEAD_FLAGS	(__HEAD_FLAG_BE << 0)
> +#define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
> +
> +#define __HEAD_FLAGS	(__HEAD_FLAG_BE << 0) |		\
> +			(__HEAD_FLAG_PAGE_SIZE << 1)
>  
>  /*
>   * These will output as part of the Image header, which should be little-endian
> -- 
> 1.7.9.5
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
