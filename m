From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 03/25] arm64: KVM: Implement HVC_GET_VECTORS in the
 init code
Date: Mon, 13 Mar 2017 17:54:13 +0000
Message-ID: <58C6DCC5.8040700@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com> <20170306142458.8875-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170306142458.8875-4-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/17 14:24, Marc Zyngier wrote:
> Now that we have an infrastructure to handle hypercalls in the KVM
> init code, let's implement HVC_GET_VECTORS there.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
