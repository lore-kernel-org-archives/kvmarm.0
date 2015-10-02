From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 09/15] arm64: Add page size to the kernel image header
Date: Fri, 2 Oct 2015 16:49:01 +0100
Message-ID: <20151002154900.GN6963@e104818-lin.cambridge.arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-10-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A04541289
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 11:47:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bDsp3j35wV0X for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 11:47:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC9524117E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 11:47:22 -0400 (EDT)
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
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Marc.Zyngier@arm.com, Will.Deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

This patch needs you signed-off-by as well since you are posting it. And
IIRC I acked it as well, I'll check.

If you are fine with adding your signed-of-by, I can add it to the patch
when applying (unless I see other issues with the series).

-- 
Catalin
