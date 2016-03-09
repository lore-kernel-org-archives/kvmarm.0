From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PULL] KVM/ARM updates for 4.6
Date: Wed, 9 Mar 2016 11:50:57 +0100
Message-ID: <56E00011.6000900@redhat.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 09/03/2016 08:29, Marc Zyngier wrote:
> - VHE support so that we can run the kernel at EL2 on ARMv8.1 systems
> - PMU support for guests
> - 32bit world switch rewritten in C
> - Various optimizations to the vgic save/restore code

Pulled, thanks!

Paolo
