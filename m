From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 12/23] arm64: insn: Allow ADD/SUB (immediate) with LSL
 #12
Date: Wed, 7 Mar 2018 18:13:59 +0000
Message-ID: <20180307181358.yypi56tmz4g3bcum@armageddon.cambridge.arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6ED401CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 13:07:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fTlq6vy4aVLm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Mar 2018 13:06:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E2E40257
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 13:06:48 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180301155538.26860-13-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 01, 2018 at 03:55:27PM +0000, Marc Zyngier wrote:
> The encoder for ADD/SUB (immediate) can only cope with 12bit
> immediates, while there is an encoding for a 12bit immediate shifted
> by 12 bits to the left.
> 
> Let's fix this small oversight by allowing the LSL_12 bit to be set.
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
