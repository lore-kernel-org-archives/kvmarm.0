From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 21/23] arm64: hw_breakpoint: Allow EL2 breakpoints if
 running in HYP
Date: Mon, 15 Feb 2016 10:22:30 +0000
Message-ID: <20160215102230.GC13683@e104818-lin.cambridge.arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
 <1455216004-19499-22-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455216004-19499-22-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 11, 2016 at 06:40:02PM +0000, Marc Zyngier wrote:
> With VHE, we place kernel {watch,break}-points at EL2 to get things
> like kgdb and "perf -e mem:..." working.
> 
> This requires a bit of repainting in the low-level encore/decode,
> but is otherwise pretty simple.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

To the best of my knowledge, this patch is fine ;)

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
