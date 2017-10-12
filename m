From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 22/28] arm64/sve: KVM: Prevent guests from using SVE
Date: Thu, 12 Oct 2017 18:13:01 +0100
Message-ID: <20171012171301.whfdkfkzvkvxtgz7@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-23-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-23-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:39PM +0100, Dave P Martin wrote:
> Until KVM has full SVE support, guests must not be allowed to
> execute SVE instructions.
> 
> This patch enables the necessary traps, and also ensures that the
> traps are disabled again on exit from the guest so that the host
> can still use SVE if it wants to.
> 
> This patch introduces another instance of
> __this_cpu_write(fpsimd_last_state, NULL), so this flush operation
> is abstracted out as a separate helper fpsimd_flush_cpu_state().
> Other instances are ported appropriately.
> 
> As a side effect of this refactoring, a this_cpu_write() in
> fpsimd_cpu_pm_notifier() is changed to __this_cpu_write().  This
> should be fine, since cpu_pm_enter() is supposed to be called only
> with interrupts disabled.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
