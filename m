From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PULL] KVM/ARM changes for 4.2
Date: Fri, 19 Jun 2015 17:16:14 +0200
Message-ID: <5584323E.9020004@redhat.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Firo Yang <firogm@gmail.com>, Tiejun Chen <tiejun.chen@intel.com>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 19/06/2015 14:53, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.2
> 
> for you to fetch changes up to c62e631d4a8e41493c6341d8259e996ed5fc11e3:
> 
>   KVM: arm/arm64: vgic: Remove useless arm-gic.h #include (2015-06-18 15:50:31 +0100)
> 
> ----------------------------------------------------------------
> KVM/ARM changes for v4.2:
> 
> - Proper guest time accounting
> - FP access fix for 32bit
> - The usual pile of GIC fixes
> - PSCI fixes
> - Random cleanups

Pulled, thanks.

Paolo
--
To unsubscribe from this list: send the line "unsubscribe kvm" in
