From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/5] lib: arm: Fallback to
 psci_system_off() in exit()
Date: Sun, 3 Feb 2019 18:23:53 +0100
Message-ID: <20190202160628.uzqfn5xopdub4i7g@kamzik.brq.redhat.com>
References: <20190201111641.8299-1-alexandru.elisei@arm.com>
 <20190201111641.8299-6-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F1094A399
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Feb 2019 12:23:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id orBEkfQcuLIM for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Feb 2019 12:23:58 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C1AE4A330
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Feb 2019 12:23:58 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190201111641.8299-6-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 01, 2019 at 11:16:41AM +0000, Alexandru Elisei wrote:
> On arm and arm64, kvm-unit-tests uses the QEMU chr-testdev device to shut
> down the virtual machine at the end of a test. The function
> psci_system_off() provides another mechanism for terminating the virtual
> machine.
> 
> chr-testdev is implemented on top of virtio console. If the virtual machine
> manager doesn't emulate a virtio console, then chr_testdev_exit() will fail.
> If this happens, try to use psci_system_off() to terminate the test.
> 
> This patch makes it possible for a virtual machine manager which doesn't
> have support for chr-testdev, but has been configured not to emulate a
> virtio console, to gracefully terminate a virtual machine after a test has
> been completed.
> 
> There is one limitation to using psci_system_off() to terminate a test:
> chr-testdev allows kvm-unit-tests to specify an exit code;
> psci_system_off() has no such mechanism.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 0d5ab9510ec8..bbb93e63fa3d 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -12,6 +12,7 @@
>  #include <devicetree.h>
>  #include <chr-testdev.h>
>  #include <config.h>
> +#include <asm/psci.h>
>  #include <asm/spinlock.h>
>  #include <asm/io.h>
>  
> @@ -90,6 +91,7 @@ void puts(const char *s)
>  void exit(int code)
>  {
>  	chr_testdev_exit(code);
> +	psci_system_off();
>  	halt(code);
>  	__builtin_unreachable();
>  }
> -- 
> 2.17.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
