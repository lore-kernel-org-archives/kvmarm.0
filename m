From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 01/25] arm64: hyp-stub: Implement HVC_RESET_VECTORS
 stub hypercall
Date: Mon, 13 Mar 2017 17:53:39 +0000
Message-ID: <58C6DCA3.9050403@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com> <20170306142458.8875-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170306142458.8875-2-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/17 14:24, Marc Zyngier wrote:
> Let's define a new stub hypercall that resets the HYP configuration
> to its default: hyp-stub vectors, and MMU disabled.
> 
> Of course, for the hyp-stub itself, this is a trivial no-op.
> Hypervisors will have a bit more work to do.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
