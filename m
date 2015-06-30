From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 10/10] arm: use new irqchip parameter to create
 different vGIC types
Date: Tue, 30 Jun 2015 17:50:35 +0100
Message-ID: <5592C8DB.20109@arm.com>
References: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
 <1435324578-21832-11-git-send-email-andre.przywara@arm.com>
 <20150630161347.GS27725@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B26E56B62
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 12:39:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8E5+nFL2BQ4A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jun 2015 12:39:00 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E796156B61
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 12:38:59 -0400 (EDT)
In-Reply-To: <20150630161347.GS27725@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "penberg@kernel.org" <penberg@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/06/15 17:13, Will Deacon wrote:
> On Fri, Jun 26, 2015 at 02:16:18PM +0100, Andre Przywara wrote:
>> Currently we unconditionally create a virtual GICv2 in the guest.
>> Add a --irqchip= parameter to let the user specify a different GIC
>> type for the guest, when omitting this parameter it still defaults to
>> --irqchip=gicv2.
>> For now the only other supported type is --irqchip=gicv3
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arm/aarch64/arm-cpu.c                    |  2 +-
>>  arm/gic.c                                | 17 +++++++++++++++++
>>  arm/include/arm-common/kvm-config-arch.h |  9 ++++++++-
>>  arm/kvm.c                                |  2 +-
>>  4 files changed, 27 insertions(+), 3 deletions(-)
>>
>> diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
>> index f702b9e..3dc8ea3 100644
>> --- a/arm/aarch64/arm-cpu.c
>> +++ b/arm/aarch64/arm-cpu.c
>> @@ -12,7 +12,7 @@
>>  static void generate_fdt_nodes(void *fdt, struct kvm *kvm, u32 gic_phandle)
>>  {
>>  	int timer_interrupts[4] = {13, 14, 11, 10};
>> -	gic__generate_fdt_nodes(fdt, gic_phandle, IRQCHIP_GICV2);
>> +	gic__generate_fdt_nodes(fdt, gic_phandle, kvm->cfg.arch.irqchip);
>>  	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
>>  }
>>  
>> diff --git a/arm/gic.c b/arm/gic.c
>> index efe4b42..ff56de7 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -22,6 +22,23 @@ static int gic_fd = -1;
>>  static u64 gic_redists_base;
>>  static u64 gic_redists_size;
>>  
>> +int irqchip_parser(const struct option *opt, const char *arg, int unset)
>> +{
>> +	enum irqchip_type *type = opt->value;
>> +
>> +	*type = IRQCHIP_GICV2;
> 
> Pointless assignment?

Yeah, that's a leftover from some refactoring.

> 
>> +	if (!strcmp(arg, "gicv2")) {
>> +		*type = IRQCHIP_GICV2;
>> +	} else if (!strcmp(arg, "gicv3")) {
>> +		*type = IRQCHIP_GICV3;
>> +	} else {
>> +		fprintf(stderr, "irqchip: unknown type \"%s\"\n", arg);
>> +		return -1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>>  {
>>  	int err;
>> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
>> index a8ebd94..9529881 100644
>> --- a/arm/include/arm-common/kvm-config-arch.h
>> +++ b/arm/include/arm-common/kvm-config-arch.h
>> @@ -8,8 +8,11 @@ struct kvm_config_arch {
>>  	unsigned int	force_cntfrq;
>>  	bool		virtio_trans_pci;
>>  	bool		aarch32_guest;
>> +	enum irqchip_type irqchip;
>>  };
>>  
>> +int irqchip_parser(const struct option *opt, const char *arg, int unset);
>> +
>>  #define OPT_ARCH_RUN(pfx, cfg)							\
>>  	pfx,									\
>>  	ARM_OPT_ARCH_RUN(cfg)							\
>> @@ -21,6 +24,10 @@ struct kvm_config_arch {
>>  		     "updated to program CNTFRQ correctly*"),			\
>>  	OPT_BOOLEAN('\0', "force-pci", &(cfg)->virtio_trans_pci,		\
>>  		    "Force virtio devices to use PCI as their default "		\
>> -		    "transport"),
>> +		    "transport"),						\
>> +        OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
>> +		     "[gicv2|gicv3]",					\
>> +		     "type of interrupt controller to emulate in the guest",	\
>> +		     irqchip_parser, NULL),
> 
> What happens if I don't pass this option at all?

Then &(cfg)->irqchip will be 0 as all the other configuration parameters
because they are part of struct kvm, which is calloc()ed.
So it will be IRQCHIP_GICV2, as that is the first entry in the enum.
Admittedly a bit convoluted, do you want a comment or an explicit
enum { IRQCHIP_GICV2 = 0, ...}?

Cheers,
Andre.
