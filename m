From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 14/28] arm64/sve: Backend logic for setting the vector
 length
Date: Wed, 13 Sep 2017 10:29:11 -0700
Message-ID: <20170913172911.3ca2h6cpju7etifi@localhost>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-15-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1504198860-12951-15-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, gdb@sourceware.org, Alan Hayward <alan.hayward@arm.com>, Yao Qi <Yao.Qi@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 31, 2017 at 06:00:46PM +0100, Dave P Martin wrote:
> This patch implements the core logic for changing a task's vector
> length on request from userspace.  This will be used by the ptrace
> and prctl frontends that are implemented in later patches.
> 
> The SVE architecture permits, but does not require, implementations
> to support vector lengths that are not a power of two.  To handle
> this, logic is added to check a requested vector length against a
> possibly sparse bitmap of available vector lengths at runtime, so
> that the best supported value can be chosen.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Alex Bennée <alex.bennee@linaro.org>

Can this be merged with patch 20? It seems to add the PR_ definitions
which get actually used later when the prctl interface is added.

-- 
Catalin
