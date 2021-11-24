Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5747C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 18:51:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 425AF49FB7;
	Wed, 24 Nov 2021 13:51:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FwQ16EbQnZSV; Wed, 24 Nov 2021 13:51:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C18004A500;
	Wed, 24 Nov 2021 13:51:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 929174A1B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 13:51:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id shbB4M7hRt6H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 13:51:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9984949FB7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 13:51:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6FB31FB;
 Wed, 24 Nov 2021 10:51:35 -0800 (PST)
Received: from lakrids (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BF913F66F;
 Wed, 24 Nov 2021 10:51:31 -0800 (PST)
Date: Wed, 24 Nov 2021 18:51:23 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Tyler Baicar <baicar@os.amperecomputing.com>
Subject: Re: [PATCH 1/2] ACPI/AEST: Initial AEST driver
Message-ID: <YZ6Jq39Z9dIUqcfO@lakrids>
References: <20211124170708.3874-1-baicar@os.amperecomputing.com>
 <20211124170708.3874-2-baicar@os.amperecomputing.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211124170708.3874-2-baicar@os.amperecomputing.com>
Cc: abdulhamid@os.amperecomputing.com, daniel.lezcano@linaro.org,
 rafael@kernel.org, catalin.marinas@arm.com, ishii.shuuichir@fujitsu.com,
 guohanjun@huawei.com, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, lorenzo.pieralisi@arm.com, maz@kernel.org,
 masahiroy@kernel.org, linux-acpi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, samitolvanen@google.com,
 patches@amperecomputing.com, lenb@kernel.org, keescook@chromium.org,
 gor@linux.ibm.com, anshuman.khandual@arm.com, john.garry@huawei.com,
 zhangshaokun@hisilicon.com, Vineeth.Pillai@microsoft.com, bp@alien8.de,
 darren@os.amperecomputing.com, dchinner@redhat.com, tglx@linutronix.de,
 linux-edac@vger.kernel.org, tony.luck@intel.com, jthierry@redhat.com,
 marcan@marcan.st, linux-kernel@vger.kernel.org, sudeep.holla@arm.com,
 tmricht@linux.ibm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

I haven't looked at this in great detail, but I spotted a few issues
from an initial scan.

On Wed, Nov 24, 2021 at 12:07:07PM -0500, Tyler Baicar wrote:
> Add support for parsing the ARM Error Source Table and basic handling of
> errors reported through both memory mapped and system register interfaces.
> 
> Assume system register interfaces are only registered with private
> peripheral interrupts (PPIs); otherwise there is no guarantee the
> core handling the error is the core which took the error and has the
> syndrome info in its system registers.

Can we actually assume that? What does the specification mandate?

> Add logging for all detected errors and trigger a kernel panic if there is
> any uncorrected error present.

Has this been tested on any hardware or software platform?

[...]

> +#define ERRDEVARCH_REV_SHIFT	0x16

IIUC This should be 16, not 0x16 (i.e. 22).

> +#define ERRDEVARCH_REV_MASK	0xf
> +
> +#define RAS_REV_v1_1		0x1
> +
> +struct ras_ext_regs {
> +	u64 err_fr;
> +	u64 err_ctlr;
> +	u64 err_status;
> +	u64 err_addr;
> +	u64 err_misc0;
> +	u64 err_misc1;
> +	u64 err_misc2;
> +	u64 err_misc3;
> +};

These last four might be better an an array.

[...]

> +static bool ras_extn_v1p1(void)
> +{
> +	unsigned long fld, reg = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +
> +	fld = cpuid_feature_extract_unsigned_field(reg, ID_AA64PFR0_RAS_SHIFT);
> +
> +	return fld >= ID_AA64PFR0_RAS_V1P1;
> +}

I suspect it'd be better to pass this value around directly as
`version`, rather than dropping this into a `misc23_present` temporary
variable, as that would be a little clearer, and future-proof if/when
more registers get added.

[...]

> +void arch_arm_ras_report_error(u64 implemented, bool clear_misc)
> +{
> +	struct ras_ext_regs regs = {0};
> +	unsigned int i, cpu_num;
> +	bool misc23_present;
> +	bool fatal = false;
> +	u64 num_records;
> +
> +	if (!this_cpu_has_cap(ARM64_HAS_RAS_EXTN))
> +		return;
> +
> +	cpu_num = get_cpu();

Why get_cpu() here? Do you just need smp_processor_id()?

The commit message explained that this would be PE-local (e.g. in a PPI
handler), and we've already checked this_cpu_has_cap() which assumes
we're not preemptible.

So I don't see why we should use get_cpu() here -- any time it would
have a difference implies something has already gone wrong.

> +	num_records = read_sysreg_s(SYS_ERRIDR_EL1) & ERRIDR_NUM_MASK;
> +
> +	for (i = 0; i < num_records; i++) {
> +		if (!(implemented & BIT(i)))
> +			continue;
> +
> +		write_sysreg_s(i, SYS_ERRSELR_EL1);
> +		isb();
> +		regs.err_status = read_sysreg_s(SYS_ERXSTATUS_EL1);
> +
> +		if (!(regs.err_status & ERR_STATUS_V))
> +			continue;
> +
> +		pr_err("error from processor 0x%x\n", cpu_num);

Why in hex? We normally print 'cpu%d' or 'CPU%d', since this is a
logical ID anyway.

> +
> +		if (regs.err_status & ERR_STATUS_AV)
> +			regs.err_addr = read_sysreg_s(SYS_ERXADDR_EL1);
> +
> +		misc23_present = ras_extn_v1p1();

As above, I reckon it's better to have this as 'version' or
'ras_version', and have the checks below be:

	if (version >= ID_AA64PFR0_RAS_V1P1) {
		// poke SYS_ERXMISC2_EL1
		// poke SYS_ERXMISC3_EL1
	}

> +
> +		if (regs.err_status & ERR_STATUS_MV) {
> +			regs.err_misc0 = read_sysreg_s(SYS_ERXMISC0_EL1);
> +			regs.err_misc1 = read_sysreg_s(SYS_ERXMISC1_EL1);
> +
> +			if (misc23_present) {
> +				regs.err_misc2 = read_sysreg_s(SYS_ERXMISC2_EL1);
> +				regs.err_misc3 = read_sysreg_s(SYS_ERXMISC3_EL1);
> +			}
> +		}
> +
> +		arch_arm_ras_print_error(&regs, i, misc23_present);
> +
> +		/*
> +		 * In the future, we will treat UER conditions as potentially
> +		 * recoverable.
> +		 */
> +		if (regs.err_status & ERR_STATUS_UE)
> +			fatal = true;
> +
> +		regs.err_status = arch_arm_ras_get_status_clear_value(regs.err_status);
> +		write_sysreg_s(regs.err_status, SYS_ERXSTATUS_EL1);
> +
> +		if (clear_misc) {
> +			write_sysreg_s(0x0, SYS_ERXMISC0_EL1);
> +			write_sysreg_s(0x0, SYS_ERXMISC1_EL1);
> +
> +			if (misc23_present) {
> +				write_sysreg_s(0x0, SYS_ERXMISC2_EL1);
> +				write_sysreg_s(0x0, SYS_ERXMISC3_EL1);
> +			}
> +		}

Any reason not to clear when we read, above? e.g.

#define READ_CLEAR_MISC(nr, clear)					\
({									\
	unsigned long __val = read_sysreg_s(SYS_ERXMISC##nr##_EL1);	\
	if (clear);							\
		write_sysreg_s(0, SYS_ERXMISC##nr##_EL1);		\
	__val;								\
})

if (regs.err_status & ERR_STATUS_MV) {
	regs.err_misc0 = READ_CLEAR_MISC(0, clear_misc);
	regs.err_misc1 = READ_CLEAR_MISC(1, clear_misc);

	if (version >= ID_AA64PFR0_RAS_V1P1) {
		regs.err_misc2 = READ_CLEAR_MISC(2, clear_misc);
		regs.err_misc3 = READ_CLEAR_MISC(3, clear_misc);
	}

}

... why does the clearing need to be conditional?

> +
> +		isb();
> +	}
> +
> +	if (fatal)
> +		panic("ARM RAS: uncorrectable error encountered");
> +
> +	put_cpu();
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e3ec1a44f94d..dc15e9896db4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1573,6 +1573,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_ERXADDR_EL1), trap_raz_wi },
>  	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
>  	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
> +	{ SYS_DESC(SYS_ERXMISC2_EL1), trap_raz_wi },
> +	{ SYS_DESC(SYS_ERXMISC3_EL1), trap_raz_wi },

This should be a preparatory patch; this is preumably a latent bug in
KVM.

[...]

> +static struct aest_node_data __percpu **ppi_data;
> +static int ppi_irqs[AEST_MAX_PPI];
> +static u8 num_ppi;
> +static u8 ppi_idx;

As above, do we have any guarantee these are actually PPIs?

> +static bool aest_mmio_ras_misc23_present(u64 base_addr)
> +{
> +	u32 val;
> +
> +	val = readl((void *) (base_addr + ERRDEVARCH_OFFSET));
> +	val <<= ERRDEVARCH_REV_SHIFT;
> +	val &= ERRDEVARCH_REV_MASK;
> +
> +	return val >= RAS_REV_v1_1;
> +}

Is the shift the wrong way around?

Above we have:

	#define ERRDEVARCH_REV_SHIFT 0x16
	#define ERRDEVARCH_REV_MASK  0xf

	#define RAS_REV_v1_1         0x1

.. so this is:

	val <<= 0x16;
	val &= 0xf;		// val[0x15:0] == 0, so this is 0

	return val >= 0x1;	// false

It'd be nicer to use FIELD_GET() here.

As above, I also think it would be better to retrun the value of the
field, and check that explciitly, for future proofing.

[...]

> +static void aest_proc(struct aest_node_data *data)
> +{
> +	struct ras_ext_regs *regs_p, regs = {0};
> +	bool misc23_present;
> +	bool fatal = false;
> +	u64 errgsr = 0;
> +	int i;
> +
> +	/*
> +	 * Currently SR based handling is done through the architected
> +	 * discovery exposed through SRs. That may change in the future
> +	 * if there is supplemental information in the AEST that is
> +	 * needed.
> +	 */
> +	if (data->interface.type == ACPI_AEST_NODE_SYSTEM_REGISTER) {
> +		arch_arm_ras_report_error(data->interface.implemented,
> +					  data->interface.flags & AEST_INTERFACE_CLEAR_MISC);
> +		return;
> +	}
> +
> +	regs_p = data->interface.regs;
> +	errgsr = readq((void *) (((u64) regs_p) + ERRGSR_OFFSET));
> +
> +	for (i = data->interface.start; i < data->interface.end; i++) {
> +		if (!(data->interface.implemented & BIT(i)))
> +			continue;
> +
> +		if (!(data->interface.status_reporting & BIT(i)) && !(errgsr & BIT(i)))
> +			continue;
> +
> +		regs.err_status = readq(&regs_p[i].err_status);
> +		if (!(regs.err_status & ERR_STATUS_V))
> +			continue;
> +
> +		if (regs.err_status & ERR_STATUS_AV)
> +			regs.err_addr = readq(&regs_p[i].err_addr);
> +
> +		regs.err_fr = readq(&regs_p[i].err_fr);
> +		regs.err_ctlr = readq(&regs_p[i].err_ctlr);
> +
> +		if (regs.err_status & ERR_STATUS_MV) {
> +			misc23_present = aest_mmio_ras_misc23_present((u64) regs_p);
> +			regs.err_misc0 = readq(&regs_p[i].err_misc0);
> +			regs.err_misc1 = readq(&regs_p[i].err_misc1);
> +
> +			if (misc23_present) {
> +				regs.err_misc2 = readq(&regs_p[i].err_misc2);
> +				regs.err_misc3 = readq(&regs_p[i].err_misc3);
> +			}
> +		}
> +
> +		aest_print(data, regs, i, misc23_present);
> +
> +		if (regs.err_status & ERR_STATUS_UE)
> +			fatal = true;
> +
> +		regs.err_status = arch_arm_ras_get_status_clear_value(regs.err_status);
> +		writeq(regs.err_status, &regs_p[i].err_status);
> +
> +		if (data->interface.flags & AEST_INTERFACE_CLEAR_MISC) {
> +			writeq(0x0, &regs_p[i].err_misc0);
> +			writeq(0x0, &regs_p[i].err_misc1);
> +
> +			if (misc23_present) {
> +				writeq(0x0, &regs_p[i].err_misc2);
> +				writeq(0x0, &regs_p[i].err_misc3);
> +			}
> +		}
> +	}
> +
> +	if (fatal)
> +		panic("AEST: uncorrectable error encountered");

Why don't we call panic() as soon as we realise an error is fatal?

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
