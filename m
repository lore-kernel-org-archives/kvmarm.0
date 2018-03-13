From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v5 05/23] arm64: cpufeatures: Drop the
 ARM64_HYP_OFFSET_LOW feature flag
Date: Tue, 13 Mar 2018 08:44:56 +0000
Message-ID: <666a9b42-0d35-b34f-8496-6d89b97acb15@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180301155538.26860-6-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/03/18 15:55, Marc Zyngier wrote:
> Now that we can dynamically compute the kernek/hyp VA mask, there
> is no need for a feature flag to trigger the alternative patching.
> Let's drop the flag and everything that depends on it.
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   arch/arm64/include/asm/cpucaps.h |  2 +-
>   arch/arm64/kernel/cpufeature.c   | 19 -------------------
>   2 files changed, 1 insertion(+), 20 deletions(-)
> 

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
