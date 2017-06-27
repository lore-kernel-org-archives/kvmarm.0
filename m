From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Replaces 'unsigned' with 'unsigned int' in the
 codebase
Date: Tue, 27 Jun 2017 12:01:25 +0200
Message-ID: <9b50ee4b-d27a-8872-0cd3-cad8f5f0e0f8@redhat.com>
References: <20170627095401.GA19864@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170627095401.GA19864@home>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Roman Storozhenko <romeusmeister@gmail.com>, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 27/06/2017 11:54, Roman Storozhenko wrote:
> Signed-off-by: Roman Storozhenko <romeusmeister@gmail.com>
> ---
>  virt/kvm/arm/arm.c        |  2 +-
>  virt/kvm/coalesced_mmio.c |  2 +-
>  virt/kvm/eventfd.c        | 10 ++++++----
>  virt/kvm/irqchip.c        |  7 ++++---
>  virt/kvm/kvm_main.c       | 16 ++++++++--------
>  5 files changed, 20 insertions(+), 17 deletions(-)

This change is pointless.  Contributors to KVM should know what
"unsigned" means.

Paolo
