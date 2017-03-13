From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 02/25] arm64: KVM: Implement HVC_RESET_VECTORS stub
 hypercall
Date: Mon, 13 Mar 2017 17:53:59 +0000
Message-ID: <58C6DCB7.1010705@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com> <20170306142458.8875-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170306142458.8875-3-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/17 14:24, Marc Zyngier wrote:
> In order to restore HYP mode to its original condition, KVM currently
> implements __kvm_hyp_reset(). As we're moving towards a hyp-stub
> defined API, it becomes necessary to implement HVC_RESET_VECTORS.
> 
> This patch adds the HVC_RESET_VECTORS hypercall to the KVM init
> code, which so far lacked any form of hypercall support.

(Nit: other patches to the init code in this series have 'init' in the subject,
this one doesn't.)

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
