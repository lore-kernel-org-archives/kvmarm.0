From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] ARM/arm64: KVM: test properly for a PTE's uncachedness
Date: Mon, 9 Nov 2015 08:17:09 +0000
Message-ID: <20151109081709.2512e683@why.wild-wind.fr.eu.org>
References: <1446810188-13727-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CA88412E6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2015 03:11:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Wshv10yoHZU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2015 03:11:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 551EC41145
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2015 03:11:48 -0500 (EST)
In-Reply-To: <1446810188-13727-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 6 Nov 2015 12:43:08 +0100
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> The open coded tests for checking whether a PTE maps a page as
> uncached use a flawed 'pte_val(xxx) & CONST != CONST' pattern,
> which is not guaranteed to work since the type of a mapping is an
> index into the MAIR table, not a set of mutually exclusive bits.
> 
> Considering that, on arm64, the S2 type definitions use the following
> MAIR indexes
> 
>     #define MT_S2_NORMAL            0xf
>     #define MT_S2_DEVICE_nGnRE      0x1
> 
> we have been getting lucky merely because the S2 device mappings also
> have the PTE_UXN bit set, which means that a device PTE still does not
> equal a normal PTE after masking with the former type.
> 
> Instead, implement proper checking against the MAIR indexes that are
> known to define uncached memory attributes.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Very well spotted, thanks Ard!

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Without deviation from the norm, progress is not possible.
