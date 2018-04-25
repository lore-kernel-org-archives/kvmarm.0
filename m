From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH 6/8] arm64/sve: Move sve_pffr() to fpsimd.h and make
 inline
Date: Wed, 25 Apr 2018 19:07:09 +0100
Message-ID: <20180425180709.xglcnopcoxqi6dn4@armageddon.cambridge.arm.com>
References: <1524242802-21163-1-git-send-email-Dave.Martin@arm.com>
 <1524242802-21163-7-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1BB84A08C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 13:58:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9FFiDI6yP5Ca for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Apr 2018 13:58:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A63549FD4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 13:57:48 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1524242802-21163-7-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 20, 2018 at 05:46:40PM +0100, Dave P Martin wrote:
> In order to make sve_save_state()/sve_load_state() more easily
> reusable and to get rid of a potential branch on context switch
> critical paths, this patch makes sve_pffr() inline and moves it to
> fpsimd.h.
> 
> <asm/processor.h> must be included in fpsimd.h in order to make
> this work, and this creates an #include cycle that is tricky to
> avoid without modifying core code, due to the way the PR_SVE_*()
> prctl helpers are included in the core prctl implementation.
> 
> Instead of breaking the cycle, this patch defers inclusion of
> <asm/fpsimd.h> in <asm/processor.h> until the point where it is
> actually needed: i.e., immediately before the prctl definitions.
> 
> No functional change.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
