From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PULL 0/3] KVM/ARM Fixes for v4.12-rc5
Date: Tue, 6 Jun 2017 22:21:30 +0200
Message-ID: <20170606202130.GS9464@cbox>
References: <20170606135629.31664-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170606135629.31664-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 06, 2017 at 03:56:26PM +0200, Christoffer Dall wrote:
> Hi Radim and Paolo,
> 
> Three additional fixes for KVM/ARM for v4.12.

We didn't expect three additional fixes to pop up so quickly, so I'm
going to send another pull request tomorrow.

Please hold off on applying this one if you haven't done so already.

Sorry about that.

-Christoffer

> 
> They fix an issue with migrating GICv2 VMs on GICv3 systems, squash a
> bug for gicv3 when figuring out preemption levels, and fix a potential
> null pointer derefence in KVM happening under memory pressure.
> 
> The following changes since commit fa472fa91a5a0b241f5ddae927d2e235d07545df:
> 
>   KVM: arm/arm64: Hold slots_lock when unregistering kvm io bus devices (2017-05-18 11:18:16 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-for-v4.12-rc5
> 
> for you to fetch changes up to d6dbdd3c8558cad3b6d74cc357b408622d122331:
> 
>   KVM: arm/arm64: Handle possible NULL stage2 pud when ageing pages (2017-06-06 15:28:40 +0200)
> 
