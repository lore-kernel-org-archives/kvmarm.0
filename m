From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 0/2] kvm: arm/arm64: Fixes for race conditions
Date: Tue, 16 May 2017 11:53:18 +0200
Message-ID: <20170516095318.GA5259@cbox>
References: <1494927295-29369-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4B7D40948
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 05:50:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lMqB3Ls-51aN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 May 2017 05:50:01 -0400 (EDT)
Received: from mail-qk0-f175.google.com (mail-qk0-f175.google.com
 [209.85.220.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AB19400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 05:50:01 -0400 (EDT)
Received: by mail-qk0-f175.google.com with SMTP id a72so122590261qkj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 02:53:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1494927295-29369-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andreyknvl@google.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 16, 2017 at 10:34:53AM +0100, Suzuki K Poulose wrote:
> The patches fixes race conditions in stage2 pgd accesses.
> 
> Patch 1 is a fix up for the patch which has already been pushed to
> kvmarm/master.
> 
> Patch 2 fixes a case where stage2 PGD could be free'd when we release
> the kvm->mmu_lock to prevent VCPU starvation.
> 
> Applies on kvmarm/master tree

Thanks for the rebase and fix.

Applied to master, and for both patches::

Reviewed-by: Christoffer Dall <cdall@linaro.org>
