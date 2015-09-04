From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 12/14] arm64: Check for selected granule support
Date: Fri, 4 Sep 2015 14:58:17 +0100
Message-ID: <20150904135817.GE17253@e104818-lin.cambridge.arm.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
 <1439465645-22584-13-git-send-email-suzuki.poulose@arm.com>
 <CAPvkgC3=S1BxdzZM4uUOmyXLjii48SMpCof6i6HdNeTG_fydfg@mail.gmail.com>
 <55CCAD73.7080702@arm.com>
 <20150813172946.GD4602@e104818-lin.cambridge.arm.com>
 <CAKv+Gu8vfsL+SFqgsXESfYC5a90-rnHbLqVFuOkvDXTt2b1E3Q@mail.gmail.com>
 <CAKv+Gu-eWRcFQkn_99WF_3H=u8qAAVis60SuegdxyeYK3v5QdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-eWRcFQkn_99WF_3H=u8qAAVis60SuegdxyeYK3v5QdQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Steve Capper <steve.capper@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 02, 2015 at 12:19:07PM +0200, Ard Biesheuvel wrote:
> On 2 September 2015 at 11:48, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > Couldn't we allocate some flag bits in the Image header to communicate
> > the page size to the bootloader?
> 
> Something like this perhaps?
> 
> ------------8<---------------
> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
> index 7d9d3c2286b2..13a8aaa9a6e9 100644
> --- a/Documentation/arm64/booting.txt
> +++ b/Documentation/arm64/booting.txt
> @@ -104,7 +104,8 @@ Header notes:
>  - The flags field (introduced in v3.17) is a little-endian 64-bit field
>    composed as follows:
>    Bit 0:       Kernel endianness.  1 if BE, 0 if LE.
> -  Bits 1-63:   Reserved.
> +  Bits 1-2:    Kernel page size.   0=unspecified, 1=4K, 2=16K, 3=64K
> +  Bits 3-63:   Reserved.
> 
>  - When image_size is zero, a bootloader should attempt to keep as much
>    memory as possible free for use by the kernel immediately after the
> diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
> index 8fae0756e175..5def289bda84 100644
> --- a/arch/arm64/kernel/image.h
> +++ b/arch/arm64/kernel/image.h
> @@ -47,7 +47,9 @@
>  #define __HEAD_FLAG_BE 0
>  #endif
> 
> -#define __HEAD_FLAGS   (__HEAD_FLAG_BE << 0)
> +#define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
> +
> +#define __HEAD_FLAGS   (__HEAD_FLAG_BE << 0) | (__HEAD_FLAG_PAGE_SIZE << 1)

I'm fine with this.

-- 
Catalin
