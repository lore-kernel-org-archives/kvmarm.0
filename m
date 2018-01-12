From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PULL 0/2] KVM/ARM Fixes for v4.15 - Round 3
Date: Fri, 12 Jan 2018 13:59:41 +0100
Message-ID: <065527d6-960c-3f13-ffab-e907112a248e@redhat.com>
References: <20180112123334.28687-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112123334.28687-1-christoffer.dall@linaro.org>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/01/2018 13:33, Christoffer Dall wrote:
> Hi Paolo and Radim,
> 
> This is the third round of fixes for KVM/ARM for v4.15, including two more
> fixes for v4.15 fixing incorrect huge page mappings on systems using the
> contiguous hint for hugetlbfs and supporting an alternative GICv4 init
> sequence.
> 
> The following changes since commit 0eb7c33cadf6b2f1a94e58ded8b0eb89b4eba382:
> 
>   KVM: arm/arm64: Fix timer enable flow (2017-12-18 10:53:24 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-fixes-for-v4.15-3
> 
> for you to fetch changes up to f8f85dc00b7427de6222ea3955c52512315d13cd:
> 
>   KVM: arm64: Fix GICv4 init when called from vgic_its_create (2018-01-12 11:40:21 +0100)
> 
> Thanks,
> -Christoffer
> 
> Christoffer Dall (1):
>       KVM: arm64: Fix GICv4 init when called from vgic_its_create
> 
> Punit Agrawal (1):
>       KVM: arm/arm64: Check pagesize when allocating a hugepage at Stage 2
> 
>  virt/kvm/arm/mmu.c            | 2 +-
>  virt/kvm/arm/vgic/vgic-init.c | 8 +++++---
>  virt/kvm/arm/vgic/vgic-v4.c   | 2 +-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 

Oops, missed this by a few minutes. :(

We'll send it next week.

Paolo
