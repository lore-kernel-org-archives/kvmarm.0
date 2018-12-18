From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v10 0/8] kvm: arm64: Support PUD hugepage at stage 2
Date: Tue, 18 Dec 2018 12:37:12 +0100
Message-ID: <20181218113712.GA25383@e113682-lin.lund.arm.com>
References: <1544548241-6417-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1544548241-6417-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, anshuman.khandual@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 11, 2018 at 05:10:33PM +0000, Suzuki K Poulose wrote:
> This series is an update to the PUD hugepage support previously posted
> at [0]. This patchset adds support for PUD hugepages at stage 2 a
> feature that is useful on cores that have support for large sized TLB
> mappings (e.g., 1GB for 4K granule).
> 
> The patches are based on v4.20-rc4
> 
> The patches have been tested on AMD Seattle system with the following
> hugepage sizes - 2M and 1G.
> 
> Right now the PUD hugepage for stage2 is only supported if the stage2
> has 4 levels. i.e, with an IPA size of minimum 44bits with 4K pages.
> This could be relaxed to stage2 with 3 levels, with the stage1 PUD huge
> page mapped in the entry level of the stage2 (i.e, pgd). I have not
> added the change here to keep this version stable w.r.t the previous
> version. I could post a patch later after further discussions in the
> list.
> 

For the series:

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
