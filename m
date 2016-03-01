From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: KVM: Move kvm_call_hyp back to its original
 localtion
Date: Tue, 1 Mar 2016 13:54:10 +0000
Message-ID: <20160301135410.GA30614@e104818-lin.cambridge.arm.com>
References: <1456837964-10325-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEDE441145
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 08:47:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KTGZ61dnGqwk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 08:47:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41EB9410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 08:47:08 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1456837964-10325-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 01, 2016 at 01:12:44PM +0000, Marc Zyngier wrote:
> In order to reduce the risk of a bad merge, let's move the new
> kvm_call_hyp back to its original location in the file. This has
> zero impact from a code point of view.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> Catalin,
> 
> Would you mind merging this on top of arm64/for-next/core? I just
> verified that this prevents yet another mismerge between the arm64 and
> KVM trees.

Applied. Thanks.

-- 
Catalin
