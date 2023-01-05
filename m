Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82239C3DA7D
	for <kvmarm@archiver.kernel.org>; Thu,  5 Jan 2023 20:46:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D081C40FF0;
	Thu,  5 Jan 2023 15:46:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wK-7J9bqsuaK; Thu,  5 Jan 2023 15:46:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78AE64B282;
	Thu,  5 Jan 2023 15:46:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5202D4B248
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Jan 2023 15:46:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FFMzyU9aJ9rz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Jan 2023 15:46:00 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F067640FF0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Jan 2023 15:45:59 -0500 (EST)
Date: Thu, 5 Jan 2023 20:45:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1672951558;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Y4b9wTbh87t22aFi+3L9dW176/vHidmEESsgPe8VPi4=;
 b=SJmgLwjvfvfaFKHy4HbjBuzhn3gsxl/+g8469WZ4uM6A5tb1hH1B2ynXfDuasamnqU3Y+x
 O4RUrLGR8EiM1REe4FgsKJFauz0F/KtwiMPNx2w5L3Xqb5k3g8RLSftNxrbTCia6b3Sdca
 7Z83rmv7+PrkSnL91Ls7XfbvlHdb8u4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH v5 7/7] KVM: arm64: Normalize cache configuration
Message-ID: <Y7c3AZJhlxKcc7y2@google.com>
References: <20221230095452.181764-1-akihiko.odaki@daynix.com>
 <20221230095452.181764-8-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221230095452.181764-8-akihiko.odaki@daynix.com>
X-Migadu-Flow: FLOW_OUT
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

Hi Akihiko,

On Fri, Dec 30, 2022 at 06:54:52PM +0900, Akihiko Odaki wrote:

[...]

> @@ -417,6 +418,9 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +
> +	/* Per-vcpu CCSIDR override or NULL */
> +	u32 *ccsidr;

I don't believe we need to store this per-vCPU. Of course, it is
possible to userspace to observe heterogeneous cache topologies
depending on what core the KVM_GET_ONE_REG ioctl is handled on.

WDYT about keeping track of this per-VM? The value should be whatever
was last written by userspace. To avoid breaking userspace this would
also need to allow mismatched writes (i.e. vCPU0 has a different
configuration than vCPU1).

[...]

> +static u8 get_min_cache_line_size(u32 csselr)

It would be nice to have a comment indicating that it returns
Log2(line_size), not line size outright.

> +{
> +	u64 ctr_el0;
> +	int field;
> +
> +	ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +	field = csselr & CSSELR_EL1_InD ? CTR_EL0_IminLine_SHIFT : CTR_EL0_DminLine_SHIFT;
> +
> +	return cpuid_feature_extract_unsigned_field(ctr_el0, field) - 2;

This probably deserves a comment describing that CTR_EL0 represents line
size in units of words, not bytes. Furthermore, a subtle reminder on the
log transformation being done here would help also.

> +}
> +
>  /* Which cache CCSIDR represents depends on CSSELR value. */
> -static u32 get_ccsidr(u32 csselr)
> +static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
>  {
> -	u32 ccsidr;
> +	if (vcpu->arch.ccsidr)
> +		return vcpu->arch.ccsidr[csselr];
>  
> -	/* Make sure noone else changes CSSELR during this! */
> -	local_irq_disable();
> -	write_sysreg(csselr, csselr_el1);
> -	isb();
> -	ccsidr = read_sysreg(ccsidr_el1);
> -	local_irq_enable();
> +	/*
> +	 * Fabricate a CCSIDR value as the overriding value does not exist.
> +	 * The real CCSIDR value will not be used as it can vary by the
> +	 * physical CPU which the vcpu currently resides in.
> +	 *
> +	 * The line size is determined with get_min_cache_line_size(), which
> +	 * should be valid for all CPUs even if they have different cache
> +	 * configuration.
> +	 *
> +	 * The associativity bits are cleared, meaning the geometry of all data
> +	 * and unified caches (which are guaranteed to be PIPT and thus
> +	 * non-aliasing) are 1 set and 1 way.
> +	 * Guests should not be doing cache operations by set/way at all, and
> +	 * for this reason, we trap them and attempt to infer the intent, so
> +	 * that we can flush the entire guest's address space at the appropriate
> +	 * time. The exposed geometry minimizes the number of the traps.
> +	 * [If guests should attempt to infer aliasing properties from the
> +	 * geometry (which is not permitted by the architecture), they would
> +	 * only do so for virtually indexed caches.]
> +	 *
> +	 * We don't check if the cache level exists as it is allowed to return
> +	 * an UNKNOWN value if not.
> +	 */
> +	return get_min_cache_line_size(csselr) << CCSIDR_EL1_LineSize_SHIFT;

I don't believe this is correct. The value of CCSIDR_EL1.LineSize is
actually:

   Log2(Number of bytes in cache line) - 4 (from DDI0487I.a D17.2.26)


With that, I'd expect the following instead:

	line_size = get_min_cache_line_size(csselr);
	return FIELD_PREP(CCSIDR_EL1_LineSize_MASK, line_size - 4);

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
