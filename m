From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH v5 07/11] arm/arm64: gicv2:
 add an IPI test
Date: Fri, 11 Nov 2016 11:13:46 +0000
Message-ID: <53d2bd86-61c6-5717-7bfd-1c6594e3dd43@arm.com>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
	<1478798481-25030-8-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1478798481-25030-8-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

more a comment loosely related to this patch ...

> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 3f6fa45c587e..68bf5cd6008f 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -54,3 +54,10 @@ file = selftest.flat
>  smp = $MAX_SMP
>  extra_params = -append 'smp'
>  groups = selftest
> +
> +# Test GIC emulation
> +[gicv2-ipi]
> +file = gic.flat
> +smp = $((($MAX_SMP < 8)?$MAX_SMP:8))

So here we always go with the maximum number of VCPUs in the guest.
However (as you also noted in your cover-letter) running with a
different number of CPUs might be interesting, for instance with less
than 8 CPUs on a GICv2 (the ITARGETSR register must be masked) or in
general with an odd number (both literally and in the broader sense). I
have a test case with passes with 8 VCPUs but fails with less.

Is there any good way to run some tests multiple times with different
numbers of VCPUS?
Shall we add some "set" functionality to the smp parameter, so that we
can specify a list of desired test points?

Cheers,
Andre.
