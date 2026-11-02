Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630062;
	b=XIeYVPQ9tVavAGZSy3ma319bruaEoeYss8pgi+kOgrpa0f4UCwGx2GoUo2T7e6TUlHur
	 UT5dTsLJd34AOOKXfkfhAMqyMDTSubrQNNFcWSh5+OUPZ545c2d02rzpNpPdKHWd6GJ5O
	 VrQ7yDxz8EmYOlMjT5+frTAuL717QJz3GVnkK306F3gZUYM78f5mmWMyl0KAU6ycsTu5e
	 3J2yHRPO6udtTiGP8j+Bvke7xMhjITijcb7NILfhXvnl9mWTWfs1kjBDrb0gMm9GVAqv/
	 q5vZzXB5p3csLC+UyXSuKy2WqsblRBhVzbxS5SmXzjKvN7jvGF0rVD/dXMQcMaruUog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630062;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=mnbEcy9yAD6phXCBWi7ToEYZPml/PD9q0TObYO3iXg0=;
	b=0wdLHFksv53k9bL96Tn6IQM0Lz9v4lKbe2UYajUviW84Dvcn6hTad5Mow8Cyv1dYDEwK
	 cv7EbZOJsKTZPV27V8WVvsSjjjMVYOZ2J7KSe9GZB0I0ctAqajBr0OChpyRopuoXpmfP/
	 Zhsgukt6RYfJ8BRvht84s6YalXHOuVv4Yat69agqCgl20L5swpSSTSdhd8BtcKUKl+8mP
	 UDQvQ4iI9oJzVWHRb6fd1747lbhGISmB6NWq4EmqPr5Y0yWfA0HFORiE7+5J2zYwOY4Fv
	 knJMiQ75IlE+E+dwd4zghwqd15QP9xV4h1c0Jm2AEUbMzmrUW8LIzUMqHfK5bqZrLxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OrR46o0z;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53988606B0FE
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 14:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53988606B0FE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OrR46o0z
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C1CD1576;
	Mon,  2 Nov 2026 06:34:16 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F42D3F59E;
	Mon,  2 Nov 2026 06:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793630059; bh=sSMXuhaToN1bbAGIonxsHXOHufl/pcpSiAvNaSVjj+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrR46o0zexxiwk2zJWR5KHZn9xMWBWhTC1MviO+EetdzupvPVTzTZsZ4QeJxUM3+L
	 XJ3Rvwgg9U7dRNVQm62aibAmTq/cDOGknoI2kI+vuyt/LJ4BLAFCf3NvpYpeOAekuo
	 u7A3xYfqid7T5oZMMXLVocyyLHQU439ZM9ugRbeM=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 09/15] KVM: arm64: Handle HDBSS faults
Date: Mon,  2 Nov 2026 14:34:03 +0000
Message-ID: <auifWrY1u72afXfJ@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260929103655.85107-10-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-10-zhengtian10@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 29, 2026 at 06:36:49PM +0800, Tian Zheng wrote:
> From: Eillon <yezhenyu2@huawei.com>
> 
> Once the buffer is full, hardware stops promoting writable-clean
> descriptors and raises a stage-2 Permission fault with
> ESR_EL2.ISS2.HDBSSF instead. Failed HDBSS accesses, such as external
> aborts and granule protection faults, are reported the same way.
> 
> Dispatch from kvm_handle_guest_abort() via the new esr_iss2_is_hdbssf()
> helper. FSC == OK means the exit path already flushed, so resume the
> guest; any other FSC is an error - clear it and report -EFAULT.
> 
> Signed-off-by: Eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/esr.h           |  5 +++++
>  arch/arm64/include/asm/kvm_dirty_bit.h |  1 +
>  arch/arm64/kvm/dirty_bit.c             | 29 ++++++++++++++++++++++++++
>  arch/arm64/kvm/mmu.c                   |  4 ++++
>  4 files changed, 39 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index f816f5d77f1a..4b3ccd407faa 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -437,6 +437,11 @@
>  #ifndef __ASSEMBLER__
>  #include <asm/types.h>
> 
> +static inline bool esr_iss2_is_hdbssf(unsigned long esr)
> +{
> +	return !!(ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF);
> +}
> +
>  static inline unsigned long esr_brk_comment(unsigned long esr)
>  {
>  	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> index d828e6b43fe9..eb2039820777 100644
> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> @@ -39,5 +39,6 @@ static inline bool vcpu_hdbss_enabled(struct kvm_vcpu *vcpu)
>  int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu);
>  void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>  void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu);
> 
>  #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index be0d12555c84..893a8c4248bc 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -98,3 +98,32 @@ void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
>  	vcpu->arch.hdbss.hdbssprod_el2 = prod;
>  	isb();
>  }
> +
> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
> +{
> +	u64 prod;
> +	u64 fsc;
> +
> +	if (WARN_ON_ONCE(!system_supports_hdbss()))
> +		return -EFAULT;
> +
> +	if (WARN_ON_ONCE(!vcpu_hdbss_enabled(vcpu)))
> +		return -EFAULT;
> +
> +	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
> +	fsc = FIELD_GET(HDBSSPROD_EL2_FSC_MASK, prod);
> +
> +	if (fsc == HDBSSPROD_EL2_FSC_OK)
> +		/* Buffer full: the exit path drained it before handle_exit. */
> +		return 1;
> +
> +	if (fsc != HDBSSPROD_EL2_FSC_ExternalAbort &&
> +	    fsc != HDBSSPROD_EL2_FSC_GPF)
> +		WARN_ONCE(1,
> +			  "Unexpected HDBSS fault type, FSC: 0x%llx (prod=0x%llx, vcpu=%d)\n",
> +			  fsc, prod, vcpu->vcpu_id);

Any reason for using if() before warn_once, given the first parameter is a 
condition? I mean, why not use, instead:

+	WARN_ONCE(fsc != HDBSSPROD_EL2_FSC_ExternalAbort &&
+		  fsc != HDBSSPROD_EL2_FSC_GPF,
+		  "Unexpected HDBSS fault type, FSC: 0x%llx (prod=0x%llx, vcpu=%d)\n",
+		  fsc, prod, vcpu->vcpu_id);

> +
> +	/* Clear FSC so hardware dirty state updates can resume. */
> +	write_sysreg_s(prod & ~HDBSSPROD_EL2_FSC_MASK, SYS_HDBSSPROD_EL2);
> +	return -EFAULT;
> +}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 85a98d2c23a9..7bf82d65041c 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -15,6 +15,7 @@
>  #include <asm/pgalloc.h>
>  #include <asm/cacheflush.h>
>  #include <asm/kvm_arm.h>
> +#include <asm/kvm_dirty_bit.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
>  #include <asm/kvm_pkvm.h>
> @@ -2315,6 +2316,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> 
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> 
> +	if (esr_iss2_is_hdbssf(esr))
> +		return kvm_handle_hdbss_fault(vcpu);
> +
>  	if (esr_fsc_is_translation_fault(esr)) {
>  		/* Beyond sanitised PARange (which is the IPA limit) */
>  		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {

I did not get the criteria used to positioning it here:
Why placed before is_abt, if not using the result before returning?
What is the rationale to putting it here?

Thanks!
Leo 
