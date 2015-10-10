From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm/arm64: KVM : Enable vhost device selection under KVM
 config menu
Date: Sat, 10 Oct 2015 17:25:04 +0200
Message-ID: <20151010152504.GF29128@cbox>
References: <1444403323-8333-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444403323-8333-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: linux-kernel@vger.kernel.orgn, marc.zyngier@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.comn, will.deacon@arm.com, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 09, 2015 at 10:08:43AM -0500, Wei Huang wrote:
> vhost drivers provide guest VMs with better I/O performance and lower
> CPU utilization. This patch allows users to select vhost devices under
> KVM configuration menu on ARM. This makes vhost support on arm/arm64
> on a par with other architectures (e.g. x86, ppc).
> 
> Signed-off-by: Wei Huang <wei@redhat.com>

Thanks, applied to queue.

-Christoffer
