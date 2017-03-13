From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 05/25] arm64: KVM: Convert __cpu_reset_hyp_mode to
 using __hyp_reset_vectors
Date: Mon, 13 Mar 2017 17:59:21 +0000
Message-ID: <58C6DDF9.1020800@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com> <20170306142458.8875-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170306142458.8875-6-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/17 14:24, Marc Zyngier wrote:
> We are now able to use the hyp stub to reset HYP mode. Time to
> kiss __kvm_hyp_reset goodbye, and use __hyp_reset_vectors.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
