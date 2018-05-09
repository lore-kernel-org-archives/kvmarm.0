From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 08/15] arm64/sve: Move read_zcr_features() out of
 cpufeature.h
Date: Wed, 9 May 2018 09:28:50 +0100
Message-ID: <2d335ebd-a17e-cf0f-5d59-398f721ce43e@arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
 <1525797900-5548-9-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525797900-5548-9-git-send-email-Dave.Martin@arm.com>
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
> Having read_zcr_features() inline in cpufeature.h results in that
> header requiring #includes which make it hard to include
> <asm/fpsimd.h> elsewhere without triggering header inclusion
> cycles.
> 
> This is not a hot-path function and arguably should not be in
> cpufeature.h in the first place, so this patch moves it to
> fpsimd.c, compiled conditionally if CONFIG_ARM64_SVE=y.
> 
> This allows some SVE-related #includes to be dropped from
> cpufeature.h, which will ease future maintenance.
> 
> A couple of missing #includes of <asm/fpsimd.h> are exposed by this
> change under arch/arm64/.  This patch adds the missing #includes as
> necessary.
> 
> No functional change.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
