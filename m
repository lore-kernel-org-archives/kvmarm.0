From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 05/23] arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
Date: Mon, 8 Feb 2016 14:42:22 +0000
Message-ID: <20160208144222.GN6076@e104818-lin.cambridge.arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 685BA498E2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 09:36:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HtFTiUvTvnQv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2016 09:36:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50362498D9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 09:36:42 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1454522416-6874-6-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 03, 2016 at 05:59:58PM +0000, Marc Zyngier wrote:
> Add a new ARM64_HAS_VIRT_HOST_EXTN features to indicate that the
> CPU has the ARMv8.1 VHE capability.
> 
> This will be used to trigger kernel patching in KVM.
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
