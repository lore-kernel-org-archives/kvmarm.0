From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 2/2] KVM: Make KVM_CAP_IRQFD dependent on
 KVM_CAP_IRQCHIP
Date: Tue, 1 Dec 2015 17:00:26 +0100
Message-ID: <565DC41A.2000703@redhat.com>
References: <cover.1448874023.git.p.fedin@samsung.com>
 <57888eef1c5c21337ddad384250bc5f55829ac67.1448874023.git.p.fedin@samsung.com>
 <20151130122627.12ceb244.cornelia.huck@de.ibm.com>
 <017101d12b66$2c8cf970$85a6ec50$@samsung.com>
 <20151130131331.78d98df5.cornelia.huck@de.ibm.com>
 <017801d12b6c$6a7c2c00$3f748400$@samsung.com>
 <20151130153807.1a2668e5.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151130153807.1a2668e5.cornelia.huck@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>, Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Gleb Natapov' <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 30/11/2015 15:38, Cornelia Huck wrote:
> It obviously
> requires an irqchip; but if you need some configuration/enablement
> beforehand, you'll get different values depending on when you retrieve
> the cap. So does KVM_CAP_IRQFD mean "irqfds are available in principle"
> or "everything has been setup for usage of irqfds"? I'd assume the
> former.

It should be the former, yes.

Paolo
