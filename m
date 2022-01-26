Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7D7C2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 04:30:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 796EA412FC;
	Tue, 25 Jan 2022 23:30:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MMN9SB-hYZ5O; Tue, 25 Jan 2022 23:30:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 042BC40E00;
	Tue, 25 Jan 2022 23:30:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1802340BC2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 23:30:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jg9MHgamU6SI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 23:30:37 -0500 (EST)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C193340B80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 23:30:37 -0500 (EST)
Received: by mail-pj1-f44.google.com with SMTP id o11so4963747pjf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 20:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2yeIRYFe9M+8an4DmHoEr9JRURI6IunXHMdZZW5UiRY=;
 b=l25dcaAdVWTM0b44MWQVrrkn54mJd/qIJT3qCO1QKaPoQerc7dIhN+V7PzrMjJQOYW
 RHGEdissPejb6S73sb4jfr0zI9lNL9GeJV9yFsRPVkNqQAoxG+xrOp+14GEZ1F+xirR2
 COi9T1OEjLsZGKQ/19OoTQ+H6ognYN3dszUTO6Y3jYPvg1hayn7gQi2MFGULMFRj8Km3
 tTugNDpPb18NKip0T6J7YxcX8+LAUAqUxcCc0jrtMI8pCeX+TpyukbREKF5aLqOz/VaO
 8r+5pXsDo+jp7r+vChWSd2iAfJxAOJEpeWWxVaBnPcaSgZoY7FRrvLcoWRDqLQxh0wmF
 POSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2yeIRYFe9M+8an4DmHoEr9JRURI6IunXHMdZZW5UiRY=;
 b=mSvNiDzXMy6SmgMkEls8nCv4xNRm3nBLI+VmWup/nylze48ksAwfc2wlm2jwhaAlCq
 /lKZgPEMOZRAK4MqS3M5j/9B05lgB85bwL3wvYKRjttro2yB+NWJvS4/p1RacrZL6Ic4
 mAnyDnrQL944Aq4EbWoZJNqLkgZ83iUgMrTQzDAHeZRH8t9t46bVHAxe+6/Cf1Qeemcu
 IFy1VCbBK+oIKJiYV0N8xsa4pd2dcFAJiXnp2oU/8eLrPuMmDNj7XlOibUtVpE+HIj+s
 FoNv4HjQiPy9SKj5jlTxYxe5GF0eldYAVtzimJDtptf4igiO7ObO+A7YEg4MkTfGFzFu
 W1cg==
X-Gm-Message-State: AOAM533mZeMnNBZARksLNvF7qrGG1LJ5J88rwGBrOPT+roajVmTQjmK+
 hJy6pdIiIMFOiECA6K1YeyGq4Q==
X-Google-Smtp-Source: ABdhPJwqjoaPOsJ872cKwoMrGq+I9rFh3unVdmrez5w9cbohGtpWkAeFDGfK/ABTE489X/UBunQyOg==
X-Received: by 2002:a17:90a:dc86:: with SMTP id
 j6mr6900589pjv.52.1643171436628; 
 Tue, 25 Jan 2022 20:30:36 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id p20sm16085527pgm.88.2022.01.25.20.30.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 Jan 2022 20:30:35 -0800 (PST)
Date: Tue, 25 Jan 2022 20:30:32 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v4 01/26] KVM: arm64: Introduce a validation function
 for an ID register
Message-ID: <YfDOaMrj3/M8g+7z@google.com>
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-2-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220106042708.2869332-2-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hey Reiji,

On Wed, Jan 05, 2022 at 08:26:43PM -0800, Reiji Watanabe wrote:
> Introduce arm64_check_features(), which does a basic validity checking
> of an ID register value against the register's limit value, which is
> generally the host's sanitized value.
> 
> This function will be used by the following patches to check if an ID
> register value that userspace tries to set for a guest can be supported
> on the host.
> 
> The validation is done using arm64_ftr_bits_kvm, which is created from
> arm64_ftr_regs, with some entries overwritten by entries from
> arm64_ftr_bits_kvm_override.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |   1 +
>  arch/arm64/kernel/cpufeature.c      | 228 ++++++++++++++++++++++++++++
>  2 files changed, 229 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index ef6be92b1921..eda7ddbed8cf 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -631,6 +631,7 @@ void check_local_cpu_capabilities(void);
>  
>  u64 read_sanitised_ftr_reg(u32 id);
>  u64 __read_sysreg_by_encoding(u32 sys_id);
> +int arm64_check_features(u32 sys_reg, u64 val, u64 limit);
>  
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 6f3e677d88f1..48dff8b101d9 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -3140,3 +3140,231 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
>  		return sprintf(buf, "Vulnerable\n");
>  	}
>  }
> +
> +#ifdef CONFIG_KVM
> +/*
> + * arm64_ftr_bits_kvm[] is used for KVM to check if features that are
> + * indicated in an ID register value for the guest are available on the host.
> + * arm64_ftr_bits_kvm[] is created based on arm64_ftr_regs[].  But, for
> + * registers for which arm64_ftr_bits_kvm_override[] has a corresponding
> + * entry, replace arm64_ftr_bits entries in arm64_ftr_bits_kvm[] with the
> + * ones in arm64_ftr_bits_kvm_override[].
> + */
> +static struct __ftr_reg_bits_entry *arm64_ftr_bits_kvm;
> +static size_t arm64_ftr_bits_kvm_nentries;

I don't think this is really needed, as arm64_ftr_bits_kvm_override has
to have the same size as arm64_ftr_bits_kvm. You could use
ARRAY_SIZE(arm64_ftr_regs) like in get_arm64_ftr_reg_nowarn().

> +static DEFINE_MUTEX(arm64_ftr_bits_kvm_lock);
> +
> +/*
> + * Number of arm64_ftr_bits entries for each register.
> + * (Number of 4 bits fields in 64 bit register + 1 entry for ARM64_FTR_END)
> + */
> +#define	MAX_FTR_BITS_LEN	17
> +
> +/* Use FTR_LOWER_SAFE for AA64DFR0_EL1.PMUVER and AA64DFR0_EL1.DEBUGVER. */
> +static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
> +	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
> +	ARM64_FTR_END,
> +};
> +
> +#define	ARM64_FTR_REG_BITS(id, table)	{	\
> +	.sys_id = id,				\
> +	.ftr_bits = &((table)[0]),		\
> +}
> +
> +struct __ftr_reg_bits_entry {
> +	u32	sys_id;
> +	struct arm64_ftr_bits	*ftr_bits;
> +};
> +
> +/*
> + * All entries in arm64_ftr_bits_kvm_override[] are used to override
> + * the corresponding entries in arm64_ftr_bits_kvm[].
> + */
> +static struct __ftr_reg_bits_entry arm64_ftr_bits_kvm_override[] = {
> +	ARM64_FTR_REG_BITS(SYS_ID_AA64DFR0_EL1, ftr_id_aa64dfr0_kvm),
> +};
> +
> +/*
> + * Override entries in @orig_ftrp with the ones in @new_ftrp when their shift
> + * fields match.  The last entry of @orig_ftrp and @new_ftrp must be
> + * ARM64_FTR_END (.width == 0).
> + */
> +static void arm64_ftr_reg_bits_overrite(struct arm64_ftr_bits *orig_ftrp,
> +					struct arm64_ftr_bits *new_ftrp)
> +{
> +	struct arm64_ftr_bits *o_ftrp, *n_ftrp;
> +
> +	for (n_ftrp = new_ftrp; n_ftrp->width; n_ftrp++) {
> +		for (o_ftrp = orig_ftrp; o_ftrp->width; o_ftrp++) {
> +			if (o_ftrp->shift == n_ftrp->shift) {
> +				*o_ftrp = *n_ftrp;
> +				break;
> +			}
> +		}
> +	}
> +}
> +
> +/*
> + * Copy arm64_ftr_bits entries from @src_ftrp to @dst_ftrp.  The last entries
> + * of @dst_ftrp and @src_ftrp must be ARM64_FTR_END (.width == 0).
> + */
> +static void copy_arm64_ftr_bits(struct arm64_ftr_bits *dst_ftrp,
> +				const struct arm64_ftr_bits *src_ftrp)
> +{
> +	int i = 0;
> +
> +	for (; src_ftrp[i].width; i++) {
> +		if (WARN_ON_ONCE(i >= (MAX_FTR_BITS_LEN - 1)))
> +			break;
> +
> +		dst_ftrp[i] = src_ftrp[i];
> +	}
> +
> +	dst_ftrp[i].width = 0;
> +}
> +
> +/*
> + * Initialize arm64_ftr_bits_kvm.  Copy arm64_ftr_bits for each ID register
> + * from arm64_ftr_regs to arm64_ftr_bits_kvm, and then override entries in
> + * arm64_ftr_bits_kvm with ones in arm64_ftr_bits_kvm_override.
> + */
> +static int init_arm64_ftr_bits_kvm(void)
> +{
> +	struct arm64_ftr_bits ftr_temp[MAX_FTR_BITS_LEN];
> +	static struct __ftr_reg_bits_entry *reg_bits_array, *bits, *o_bits;
> +	int i, j, nent, ret;
> +
> +	mutex_lock(&arm64_ftr_bits_kvm_lock);

This is initialized lazily, whenever KVM calls arm64_check_features(). I
guess that's why it needs the lock (and possibly a barrier as you
mentoin in your reply). Would it be possible to simplify things by
initializing arm64_ftr_bits_kvm somewhere at boot time (in
init_cpu_features maybe?)?

> +	if (arm64_ftr_bits_kvm) {
> +		/* Already initialized */
> +		ret = 0;
> +		goto unlock_exit;
> +	}
> +
> +	nent = ARRAY_SIZE(arm64_ftr_regs);
> +	reg_bits_array = kcalloc(nent, sizeof(struct __ftr_reg_bits_entry),
> +				 GFP_KERNEL);
> +	if (!reg_bits_array) {
> +		ret = ENOMEM;
> +		goto unlock_exit;
> +	}
> +
> +	/* Copy entries from arm64_ftr_regs to reg_bits_array */
> +	for (i = 0; i < nent; i++) {
> +		bits = &reg_bits_array[i];
> +		bits->sys_id = arm64_ftr_regs[i].sys_id;
> +		bits->ftr_bits = (struct arm64_ftr_bits *)arm64_ftr_regs[i].reg->ftr_bits;
> +	};
> +
> +	/*
> +	 * Override the entries in reg_bits_array with the ones in
> +	 * arm64_ftr_bits_kvm_override.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(arm64_ftr_bits_kvm_override); i++) {
> +		o_bits = &arm64_ftr_bits_kvm_override[i];
> +		for (j = 0; j < nent; j++) {
> +			bits = &reg_bits_array[j];
> +			if (bits->sys_id != o_bits->sys_id)
> +				continue;
> +
> +			memset(ftr_temp, 0, sizeof(ftr_temp));
> +
> +			/*
> +			 * Temporary save all entries in o_bits->ftr_bits
> +			 * to ftr_temp.
> +			 */
> +			copy_arm64_ftr_bits(ftr_temp, o_bits->ftr_bits);
> +
> +			/*
> +			 * Copy entries from bits->ftr_bits to o_bits->ftr_bits.
> +			 */
> +			copy_arm64_ftr_bits(o_bits->ftr_bits, bits->ftr_bits);
> +
> +			/*
> +			 * Override entries in o_bits->ftr_bits with the
> +			 * saved ones, and update bits->ftr_bits with
> +			 * o_bits->ftr_bits.
> +			 */
> +			arm64_ftr_reg_bits_overrite(o_bits->ftr_bits, ftr_temp);
> +			bits->ftr_bits = o_bits->ftr_bits;
> +			break;
> +		}
> +	}
> +
> +	arm64_ftr_bits_kvm_nentries = nent;
> +	arm64_ftr_bits_kvm = reg_bits_array;
> +	ret = 0;
> +
> +unlock_exit:
> +	mutex_unlock(&arm64_ftr_bits_kvm_lock);
> +	return ret;
> +}
> +
> +static int search_cmp_ftr_reg_bits(const void *id, const void *regp)
> +{
> +	return ((int)(unsigned long)id -
> +		(int)((const struct __ftr_reg_bits_entry *)regp)->sys_id);
> +}
> +
> +static const struct arm64_ftr_bits *get_arm64_ftr_bits_kvm(u32 sys_id)
> +{
> +	const struct __ftr_reg_bits_entry *ret;
> +	int err;
> +
> +	if (!arm64_ftr_bits_kvm) {
> +		/* arm64_ftr_bits_kvm is not initialized yet. */
> +		err = init_arm64_ftr_bits_kvm();
> +		if (err)
> +			return NULL;
> +	}
> +
> +	ret = bsearch((const void *)(unsigned long)sys_id,
> +		      arm64_ftr_bits_kvm,
> +		      arm64_ftr_bits_kvm_nentries,
> +		      sizeof(arm64_ftr_bits_kvm[0]),
> +		      search_cmp_ftr_reg_bits);
> +	if (ret)
> +		return ret->ftr_bits;
> +
> +	return NULL;
> +}
> +
> +/*
> + * Check if features (or levels of features) that are indicated in the ID
> + * register value @val are also indicated in @limit.
> + * This function is for KVM to check if features that are indicated in @val,
> + * which will be used as the ID register value for its guest, are supported
> + * on the host.
> + * For AA64MMFR0_EL1.TGranX_2 fields, which don't follow the standard ID
> + * scheme, the function checks if values of the fields in @val are the same
> + * as the ones in @limit.
> + */
> +int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
> +{
> +	const struct arm64_ftr_bits *ftrp = get_arm64_ftr_bits_kvm(sys_reg);

Given that this is to be used only by KVM (and it's inside CONFIG_KVM),
it might be better to have "kvm" somewhere in its name.

> +	u64 exposed_mask = 0;
> +
> +	if (!ftrp)
> +		return -ENOENT;
> +
> +	for (; ftrp->width; ftrp++) {
> +		s64 ftr_val = arm64_ftr_value(ftrp, val);
> +		s64 ftr_lim = arm64_ftr_value(ftrp, limit);
> +
> +		exposed_mask |= arm64_ftr_mask(ftrp);
> +
> +		if (ftr_val == ftr_lim)
> +			continue;
> +
> +		if (ftr_val != arm64_ftr_safe_value(ftrp, ftr_val, ftr_lim))
> +			return -E2BIG;
> +	}
> +
> +	/* Make sure that no unrecognized fields are set in @val. */
> +	if (val & ~exposed_mask)
> +		return -E2BIG;
> +
> +	return 0;
> +}
> +#endif /* CONFIG_KVM */
> -- 
> 2.34.1.448.ga2b2bfdf31-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
