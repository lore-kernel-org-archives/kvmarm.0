From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm/arm64: trivial header path sanitization
Date: Fri, 8 Feb 2019 15:42:47 +0000
Message-ID: <01ede89d-9cb4-8e3c-420b-d862755c630c@arm.com>
References: <1548403050-6585-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1548403050-6585-1-git-send-email-yamada.masahiro@socionext.com>
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
To: Masahiro Yamada <yamada.masahiro@socionext.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 25/01/2019 07:57, Masahiro Yamada wrote:
> My main motivation is to get rid of crappy header search path manipulation
> from Kbuild core.
> 
> Before that, I want to finish as many cleanup works as possible.
> 
> If you are interested in the big picture of this work,
> the full patch set is available at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git build-test
> 
> 
> 
> Masahiro Yamada (3):
>   KVM: arm/arm64: fix TRACE_INCLUDE_PATH
>   KVM: arm/arm64: remove -I. header search paths
>   KVM: arm/arm64: prefix header search paths with $(srctree)/
> 
>  arch/arm/kvm/Makefile   | 5 ++---
>  arch/arm64/kvm/Makefile | 4 +---
>  virt/kvm/arm/trace.h    | 2 +-
>  3 files changed, 4 insertions(+), 7 deletions(-)
> 

I've applied these 3 patches to kvmarm/queue.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
