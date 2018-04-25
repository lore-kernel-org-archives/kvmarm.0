From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH 4/8] arm64/sve: Move read_zcr_features() out of
 cpufeature.h
Date: Wed, 25 Apr 2018 19:06:38 +0100
Message-ID: <20180425180637.qw5llrrjdnh7gnei@armageddon.cambridge.arm.com>
References: <1524242802-21163-1-git-send-email-Dave.Martin@arm.com>
 <1524242802-21163-5-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1524242802-21163-5-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 20, 2018 at 05:46:38PM +0100, Dave P Martin wrote:
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

I guess when you eventually drop the RFC, these patches would be merged
through the KVM tree. For the core arm64 parts:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

The KVM changes also look fine to me but I'm not a KVM expert.

-- 
Catalin
