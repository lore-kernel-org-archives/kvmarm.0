From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 2/2] arm64: Implement branch predictor hardening for
 Falkor
Date: Tue, 9 Jan 2018 10:04:27 +0000
Message-ID: <20180109100426.GE4297@arm.com>
References: <1515447068-20977-1-git-send-email-shankerd@codeaurora.org>
 <1515447068-20977-2-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3882A49DC8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 04:59:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bbEPxG2y3Pap for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 04:59:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5080249DD4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 04:59:43 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1515447068-20977-2-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Thomas Speier <tspeier@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 08, 2018 at 03:31:08PM -0600, Shanker Donthineni wrote:
> Falkor is susceptible to branch predictor aliasing and can
> theoretically be attacked by malicious code. This patch
> implements a mitigation for these attacks, preventing any
> malicious entries from affecting other victim contexts.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
> Changes since v1:
>   Corrected typo to fix the compilation errors if HARDEN_BRANCH_PREDICTOR=n
> 
> This patch requires FALKOR MIDR which is available in upstream v4.15-rc7
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm64?h=v4.15-rc7&id=c622cc013cece073722592cff1ac6643a33b1622 ans also
>   attached this v2 patch series.

Please resend this as a fixup on top of for-next/core. It might make the
most sense to queue that at -rc1, after the MIDR change has already landed
in mainline.

Will
