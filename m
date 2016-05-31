From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 0/3] arm64: Kill ESR_LNX_EXEC
Date: Tue, 31 May 2016 17:53:11 +0100
Message-ID: <20160531165311.GD11321@e104818-lin.cambridge.arm.com>
References: <1464694383-31700-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEFA441145
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2016 12:49:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V0sCR2E+Lws4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 May 2016 12:49:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DAAA40F90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2016 12:49:23 -0400 (EDT)
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
> Mark Rutland (3):
>   arm64: add macro to extract ESR_ELx.EC
>   arm64/kvm: use ESR_ELx_EC to extract EC
>   arm64: kill ESR_LNX_EXEC

For the series:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
