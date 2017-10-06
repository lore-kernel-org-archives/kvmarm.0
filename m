From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v1 1/2] KVM: arm64: handle single-stepping trapped
 instructions
Date: Fri, 6 Oct 2017 14:15:21 +0100
Message-ID: <ec903fcc-6e73-40c6-69b0-b37d7d53d431@arm.com>
References: <20171006113921.24880-1-alex.bennee@linaro.org>
 <20171006113921.24880-2-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171006113921.24880-2-alex.bennee@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 06/10/17 12:39, Alex Bennée wrote:
> If we are using guest debug to single-step the guest we need to ensure
> we exit after emulating the instruction. This only affects
> instructions completely emulated by the kernel. For userspace emulated
> instructions we need to exit and return to complete the emulation.
> 
> We fake debug.arch.hsr to contain ESR_ELx_EC_SOFTSTP_LOW so QEMU knows
> it was a single-step event (and without altering the userspace ABI).
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Thanks,

-- 
Julien Thierry
