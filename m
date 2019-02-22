From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 08/26] arm64/sve: Enable SVE state tracking for
 non-task contexts
Date: Fri, 22 Feb 2019 15:26:51 +0000
Message-ID: <dc379691-ab3a-79a6-b760-59a02aa40717@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-9-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1550519559-15915-9-git-send-email-Dave.Martin@arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 18/02/2019 19:52, Dave Martin wrote:
> The current FPSIMD/SVE context handling support for non-task (i.e.,
> KVM vcpu) contexts does not take SVE into account.  This means that

NIT: Double-space before "This".

> only task contexts can safely use SVE at present.
> 
> In preparation for enabling KVM guests to use SVE, it is necessary
> to keep track of SVE state for non-task contexts too.
> 
> This patch adds the necessary support, removing assumptions from
> the context switch code about the location of the SVE context
> storage.
> 
> When binding a vcpu context, its vector length is arbitrarily
> specified as SVE_VL_MIN for now.  In any case, because TIF_SVE is

NIT: Double-space before "In".

> presently cleared at vcpu context bind time, the specified vector
> length will not be used for anything yet.  In later patches TIF_SVE

NIT: Double-space before "In".

> will be set here as appropriate, and the appropriate maximum vector
> length for the vcpu will be passed when binding.

Cheers,

-- 
Julien Grall
