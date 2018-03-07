From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 05/23] arm64: cpufeatures: Drop the
 ARM64_HYP_OFFSET_LOW feature flag
Date: Wed, 7 Mar 2018 18:11:51 +0000
Message-ID: <20180307181150.zoi3ote4ymjrntnw@armageddon.cambridge.arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86AA4402D3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 13:05:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aN3hp3bYtviI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Mar 2018 13:04:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7A6401CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 13:04:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180301155538.26860-6-marc.zyngier@arm.com>
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

On Thu, Mar 01, 2018 at 03:55:20PM +0000, Marc Zyngier wrote:
> Now that we can dynamically compute the kernek/hyp VA mask, there
> is no need for a feature flag to trigger the alternative patching.
> Let's drop the flag and everything that depends on it.
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
