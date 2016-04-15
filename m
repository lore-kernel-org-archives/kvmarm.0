From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 01/17] arm64: Reuse TCR field definitions for EL1 and
 EL2
Date: Fri, 15 Apr 2016 16:15:41 +0100
Message-ID: <20160415151541.GO22906@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
 <1460640065-27658-2-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9503949BDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 11:13:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ZPu-Fd6XqJX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 11:13:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81C9949BDA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 11:13:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1460640065-27658-2-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 14, 2016 at 02:20:49PM +0100, Suzuki K Poulose wrote:
> TCR_EL1, TCR_EL2 and VTCR_EL2, all share some field positions
> (TG0, ORGN0, IRGN0 and SH0) and their corresponding value definitions.
> 
> This patch makes the TCR_EL1 definitions reusable and uses them for TCR_EL2
> and VTCR_EL2 fields.
> 
> This also fixes a bug where we assume TG0 in {V}TCR_EL2 is 1bit field.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h       |   48 ++++++++++---------
>  arch/arm64/include/asm/pgtable-hwdef.h |   80 +++++++++++++++++++++++++-------
>  2 files changed, 88 insertions(+), 40 deletions(-)

Acked-by: Will Deacon <will.deacon@arm.com>

Feel free to take this through the kvm-arm tree.

Will
