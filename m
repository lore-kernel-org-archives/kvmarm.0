From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 0/2] arm64: add pabt injection test
Date: Fri, 22 Jul 2016 16:46:29 +0200
Message-ID: <20160722144629.7veapnqpggdcpkuw@kamzik.localdomain>
References: <1469198603-27537-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469198603-27537-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 22, 2016 at 10:43:21AM -0400, Andrew Jones wrote:
> Get arm emulation tests kick started by adding a couple pabt injection
> tests.
> 
> Andrew Jones (2):
>   arm64: add start_usr32
>   arm64: add pabt injection test
> 
>  arm/Makefile.arm64        |  2 +-
>  arm/emul-abort.c          | 95 +++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg         | 25 +++++++++++++
>  lib/arm64/asm/processor.h |  1 +
>  lib/arm64/processor.c     | 21 +++++++++--
>  5 files changed, 139 insertions(+), 5 deletions(-)
>  create mode 100644 arm/emul-abort.c

Eh, I forgot the kvm-unit-tests tags on these patches... Sorry.

> 
> -- 
> 1.8.3.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
