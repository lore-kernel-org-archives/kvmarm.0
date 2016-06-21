From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 0/3] arm64: Kill ESR_LNX_EXEC
Date: Tue, 21 Jun 2016 17:09:09 +0100
Message-ID: <20160621160908.GF14542@e104818-lin.cambridge.arm.com>
References: <1464694383-31700-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 353B849B49
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2016 12:04:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7OYxo0LCiJfG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jun 2016 12:04:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07E3C49B3D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2016 12:04:23 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1464694383-31700-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, will.deacon@arm.com, dave.martin@arm.com, shijie.huang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 31, 2016 at 12:33:00PM +0100, Mark Rutland wrote:
> Currently we (ab)use a reserved bit in ESR_ELx for our own purposes as
> ESR_LNX_EXEC, which isn't ideal, especially as we're inconsistent with our
> mnemonic usage. This series removes ESR_LNX_EXEC entirely, avoiding (ab)use of
> reserved ESR_ELx bits, and makes things a little more consistent.
> 
> I've extracted this from my entry-deasm branch [1], and rebased to v4.7-rc1.
> I've split the KVM changes as the KVM code is undergoing rapid change these
> days, and it should be possible to take those as a subsequent cleanup rather
> than forcing a painful merging process.
> 
> Thanks,
> Mark.
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/mark/linux.git/log/?h=arm64/entry-deasm
> 
> 
> Mark Rutland (3):
>   arm64: add macro to extract ESR_ELx.EC
>   arm64/kvm: use ESR_ELx_EC to extract EC
>   arm64: kill ESR_LNX_EXEC

I queued these 3 patches for 4.8. Thanks.

-- 
Catalin
