From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/ARM updates for 4.18
Date: Fri, 1 Jun 2018 19:18:43 +0200
Message-ID: <009990f0-0713-067d-8f08-331055f46b97@redhat.com>
References: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180601152747.23613-1-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/06/2018 17:27, Marc Zyngier wrote:
> Paolo, Radim,
> 
> This is the set of updates for KVM/ARM for v4.18. This time, lazy
> context switching of the floating point registers for arm64, and the
> ability to deal with multiple redistributor ranges (which allows for
> larger numbers of vcpu).
> 
> Note that some additional KVM/ARM updates will come via the arm64 tree
> with the SSBD patches. This will generate three conflicts that are
> pretty simple to resolve (-next has a good example of the resolution).
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 75bc37fefc4471e718ba8e651aa74673d4e0a9eb:
> 
>   Linux 4.17-rc4 (2018-05-06 16:57:38 -1000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-v4.18
> 
> for you to fetch changes up to e25028c8ded011d19f9a11164807507c94febc01:
> 
>   KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to 512 (2018-05-25 12:29:27 +0100)
> 
> ----------------------------------------------------------------
> KVM/ARM updates for 4.18
> 
> - Lazy context-switching of FPSIMD registers on arm64
> - Allow virtual redistributors to be part of two or more MMIO ranges

Pulled, thanks.

Paolo
