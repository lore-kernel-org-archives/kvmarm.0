From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 09/55] KVM: arm/arm64: Fix MMIO emulation data handling
Date: Wed, 18 May 2016 12:02:07 +0100
Message-ID: <573C4BAF.5030008@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-10-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDCD2411BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 06:58:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vE+Yzr2xn9p4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 06:58:19 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A02D7410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 06:58:18 -0400 (EDT)
In-Reply-To: <1462531568-9799-10-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/05/16 11:45, Andre Przywara wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> When the kernel was handling a guest MMIO read access internally, we
> need to copy the emulation result into the run->mmio structure in order
> for the kvm_handle_mmio_return() function to pick it up and inject the
> 	result back into the guest.
> 
> Currently the only user of kvm_io_bus for ARM is the VGIC, which did
> this copying itself, so this was not causing issues so far.
> 
> But with the upcoming new vgic implementation we need this done
> properly.
> 
> Update the kvm_handle_mmio_return description and cleanup the code to
> only perform a single copying when needed.
> 
> Code and commit message inspired by Andre Przywara.
> 
> Reported-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks,
Andre.
