From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 10/15] arm64/sve: Move sve_pffr() to fpsimd.h and make
 inline
Date: Wed, 9 May 2018 09:46:05 +0100
Message-ID: <c98bc032-3120-974e-2511-e909a289584d@arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
 <1525797900-5548-11-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525797900-5548-11-git-send-email-Dave.Martin@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/05/18 17:44, Dave Martin wrote:
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
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
