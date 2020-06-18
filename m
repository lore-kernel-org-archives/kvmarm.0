Return-Path: <SRS0=nOLV=77=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F36C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 17:17:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BBA72186A
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 17:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FjpChfRF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BBA72186A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22DF24B172;
	Thu, 18 Jun 2020 13:17:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gZCgcvosEjup; Thu, 18 Jun 2020 13:17:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A50984B142;
	Thu, 18 Jun 2020 13:17:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B09764B13C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 13:17:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1RBgVqVZbvgk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2020 13:17:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 219F94B0A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 13:17:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 006A9208C7;
 Thu, 18 Jun 2020 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592500637;
 bh=eL4F8Kzo3o9RQxZKCFKk2WmbmW81b+JZJvufTVRGoVc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=FjpChfRFuzNA1hzyuFXgjNiiUoytl+mE4ASzMnCLh4bGjsFK92BzszTP8gY2A9df1
 m4C0Xk3I6EERAgSZV0WkGE+5T31B7laDOsYHxEAa165+yMS5mEnwtwb4DNcBv7PShN
 4n2GcePF+s5K7MBxK8s1Pj3kB1RGqria9DRMl7bk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jlyA7-004Epg-GX; Thu, 18 Jun 2020 18:17:15 +0100
MIME-Version: 1.0
Date: Thu, 18 Jun 2020 18:17:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 05/15] arm64: kvm: Build hyp-entry.S separately for
 VHE/nVHE
In-Reply-To: <20200618122537.9625-6-dbrazdil@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
 <20200618122537.9625-6-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <5029f8fb4a7816e11de7469c09347c79@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, will@kernel.org,
 catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 android-kvm@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi David,

On 2020-06-18 13:25, David Brazdil wrote:
> This patch is part of a series which builds KVM's non-VHE hyp code 
> separately
> from VHE and the rest of the kernel.

The above comment doesn't really belong here, and us only fit for the 
cover letter.

> 
> hyp-entry.S contains implementation of KVM hyp vectors. This code is 
> mostly
> shared between VHE/nVHE, therefore compile it under both VHE and nVHE 
> build
> rules. nVHE-specific host HVC handler is hidden behind 
> __KVM_NVHE_HYPERVISOR__.
> 
> Adjust code which selects which KVM hyp vecs to install to choose the 
> correct
> VHE/nVHE symbol.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h |  7 ++++++-
>  arch/arm64/include/asm/kvm_mmu.h | 16 ++++++++++------
>  arch/arm64/include/asm/mmu.h     |  7 -------
>  arch/arm64/kernel/cpu_errata.c   |  4 +++-
>  arch/arm64/kernel/image-vars.h   | 12 ++++++++++++
>  arch/arm64/kvm/hyp/hyp-entry.S   |  2 ++
>  arch/arm64/kvm/hyp/nvhe/Makefile |  2 +-
>  arch/arm64/kvm/va_layout.c       |  2 +-
>  8 files changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h 
> b/arch/arm64/include/asm/kvm_asm.h
> index 6a682d66a640..2baa69324cc9 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -76,7 +76,12 @@ struct kvm_vcpu;
>  extern char __kvm_hyp_init[];
>  extern char __kvm_hyp_init_end[];
> 
> -extern char __kvm_hyp_vector[];
> +DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
> +
> +#ifdef CONFIG_KVM_INDIRECT_VECTORS
> +DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
> +extern atomic_t arm64_el2_vector_last_slot;
> +#endif
> 
>  extern void __kvm_flush_vm_context(void);
>  extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t 
> ipa);
> diff --git a/arch/arm64/include/asm/kvm_mmu.h 
> b/arch/arm64/include/asm/kvm_mmu.h
> index b12bfc1f051a..5bfc7ee61997 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -461,11 +461,15 @@ extern int __kvm_harden_el2_vector_slot;
>  static inline void *kvm_get_hyp_vector(void)
>  {
>  	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
> -	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
>  	int slot = -1;
> +	void *vect = kern_hyp_va(has_vhe()
> +		? kvm_ksym_ref(__kvm_hyp_vector)
> +		: kvm_ksym_ref_nvhe(__kvm_hyp_vector));

If you are introducing has_vhe() at this stage, then you might as well 
not apply kernel_hyp_va() to the address. This also make the declaration 
block look a bit ugly (yes, I'm a bit of a maniac). I'd rather see 
something like:

diff --git a/arch/arm64/include/asm/kvm_mmu.h 
b/arch/arm64/include/asm/kvm_mmu.h
index 5bfc7ee61997..e915c47744bc 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -457,19 +457,25 @@ static inline int kvm_write_guest_lock(struct kvm 
*kvm, gpa_t gpa,
  extern void *__kvm_bp_vect_base;
  extern int __kvm_harden_el2_vector_slot;

+#define get_hyp_vector_address(v)				\
+({								\
+	void *__v;						\
+	if (has_vhe())						\
+		__v = kvm_ksym_ref(v);				\
+	else							\
+		__v = kern_hyp_va(kvm_ksym_ref_nvhe(v));	\
+	__v;							\
+})
+
  /*  This is called on both VHE and !VHE systems */
  static inline void *kvm_get_hyp_vector(void)
  {
  	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
+	void *vect = get_hyp_vector_address(__kvm_hyp_vector);
  	int slot = -1;
-	void *vect = kern_hyp_va(has_vhe()
-		? kvm_ksym_ref(__kvm_hyp_vector)
-		: kvm_ksym_ref_nvhe(__kvm_hyp_vector));

  	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn) {
-		vect = kern_hyp_va(has_vhe()
-			? kvm_ksym_ref(__bp_harden_hyp_vecs)
-			: kvm_ksym_ref_nvhe(__bp_harden_hyp_vecs));
+		vect = get_hyp_vector_address(__bp_harden_hyp_vecs);
  		slot = data->hyp_vectors_slot;
  	}

> 
>  	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn) {
> -		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
> +		vect = kern_hyp_va(has_vhe()
> +			? kvm_ksym_ref(__bp_harden_hyp_vecs)
> +			: kvm_ksym_ref_nvhe(__bp_harden_hyp_vecs));
>  		slot = data->hyp_vectors_slot;
>  	}
> 
> @@ -494,12 +498,11 @@ static inline int kvm_map_vectors(void)
>  	 *  HBP +  HEL2 -> use hardened vertors and use exec mapping
>  	 */
>  	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
> -		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs);
> -		__kvm_bp_vect_base = kern_hyp_va(__kvm_bp_vect_base);
> +		__kvm_bp_vect_base = 
> kern_hyp_va(kvm_ksym_ref_nvhe(__bp_harden_hyp_vecs));
>  	}
> 
>  	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
> -		phys_addr_t vect_pa = __pa_symbol(__bp_harden_hyp_vecs);
> +		phys_addr_t vect_pa = 
> __pa_symbol(kvm_nvhe_sym(__bp_harden_hyp_vecs));
>  		unsigned long size = __BP_HARDEN_HYP_VECS_SZ;
> 
>  		/*
> @@ -518,7 +521,8 @@ static inline int kvm_map_vectors(void)
>  #else
>  static inline void *kvm_get_hyp_vector(void)
>  {
> -	return kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
> +	return kern_hyp_va(has_vhe() ? kvm_ksym_ref(__kvm_hyp_vector)
> +				     : kvm_ksym_ref_nvhe(__kvm_hyp_vector));
>  }
> 
>  static inline int kvm_map_vectors(void)
> diff --git a/arch/arm64/include/asm/mmu.h 
> b/arch/arm64/include/asm/mmu.h
> index 68140fdd89d6..4d913f6dd366 100644
> --- a/arch/arm64/include/asm/mmu.h
> +++ b/arch/arm64/include/asm/mmu.h
> @@ -42,13 +42,6 @@ struct bp_hardening_data {
>  	bp_hardening_cb_t	fn;
>  };
> 
> -#if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
> -     defined(CONFIG_HARDEN_EL2_VECTORS))
> -
> -extern char __bp_harden_hyp_vecs[];
> -extern atomic_t arm64_el2_vector_last_slot;
> -#endif  /* CONFIG_HARDEN_BRANCH_PREDICTOR || CONFIG_HARDEN_EL2_VECTORS 
> */
> -
>  #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>  DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, 
> bp_hardening_data);
> 
> diff --git a/arch/arm64/kernel/cpu_errata.c 
> b/arch/arm64/kernel/cpu_errata.c
> index ad06d6802d2e..318b76a62c56 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -117,7 +117,9 @@ DEFINE_PER_CPU_READ_MOSTLY(struct
> bp_hardening_data, bp_hardening_data);
>  static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
>  				const char *hyp_vecs_end)
>  {
> -	void *dst = lm_alias(__bp_harden_hyp_vecs + slot * SZ_2K);
> +	char *vec = has_vhe() ? __bp_harden_hyp_vecs
> +			      : kvm_nvhe_sym(__bp_harden_hyp_vecs);

If we get this construct often, then something that abstracts
the uggliness of the symbol duality would be nice...

> +	void *dst = lm_alias(vec + slot * SZ_2K);
>  	int i;
> 
>  	for (i = 0; i < SZ_2K; i += 0x80)
> diff --git a/arch/arm64/kernel/image-vars.h 
> b/arch/arm64/kernel/image-vars.h
> index 89affa38b143..dc7ee85531f5 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -61,9 +61,11 @@ __efistub__ctype		= _ctype;
>   * memory mappings.
>   */
> 
> +__kvm_nvhe___guest_exit = __guest_exit;
>  __kvm_nvhe___kvm_enable_ssbs = __kvm_enable_ssbs;
>  __kvm_nvhe___kvm_flush_vm_context = __kvm_flush_vm_context;
>  __kvm_nvhe___kvm_get_mdcr_el2 = __kvm_get_mdcr_el2;
> +__kvm_nvhe___kvm_handle_stub_hvc = __kvm_handle_stub_hvc;
>  __kvm_nvhe___kvm_timer_set_cntvoff = __kvm_timer_set_cntvoff;
>  __kvm_nvhe___kvm_tlb_flush_local_vmid = __kvm_tlb_flush_local_vmid;
>  __kvm_nvhe___kvm_tlb_flush_vmid = __kvm_tlb_flush_vmid;
> @@ -75,6 +77,16 @@ __kvm_nvhe___vgic_v3_read_vmcr = 
> __vgic_v3_read_vmcr;
>  __kvm_nvhe___vgic_v3_restore_aprs = __vgic_v3_restore_aprs;
>  __kvm_nvhe___vgic_v3_save_aprs = __vgic_v3_save_aprs;
>  __kvm_nvhe___vgic_v3_write_vmcr = __vgic_v3_write_vmcr;
> +__kvm_nvhe_abort_guest_exit_end = abort_guest_exit_end;
> +__kvm_nvhe_abort_guest_exit_start = abort_guest_exit_start;
> +__kvm_nvhe_arm64_enable_wa2_handling = arm64_enable_wa2_handling;
> +__kvm_nvhe_arm64_ssbd_callback_required = 
> arm64_ssbd_callback_required;
> +__kvm_nvhe_hyp_panic = hyp_panic;
> +__kvm_nvhe_kimage_voffset = kimage_voffset;
> +__kvm_nvhe_kvm_host_data = kvm_host_data;
> +__kvm_nvhe_kvm_patch_vector_branch = kvm_patch_vector_branch;
> +__kvm_nvhe_kvm_update_va_mask = kvm_update_va_mask;
> +__kvm_nvhe_panic = panic;
> 
>  #endif /* CONFIG_KVM */
> 
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S 
> b/arch/arm64/kvm/hyp/hyp-entry.S
> index d362fad97cc8..7e3c72fa634f 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -40,6 +40,7 @@ el1_sync:				// Guest trapped into EL2
>  	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
>  	b.ne	el1_trap
> 
> +#ifdef __KVM_NVHE_HYPERVISOR__
>  	mrs	x1, vttbr_el2		// If vttbr is valid, the guest
>  	cbnz	x1, el1_hvc_guest	// called HVC
> 
> @@ -74,6 +75,7 @@ el1_sync:				// Guest trapped into EL2
> 
>  	eret
>  	sb
> +#endif /* __KVM_NVHE_HYPERVISOR__ */
> 
>  el1_hvc_guest:
>  	/*
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile 
> b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 7d64235dba62..c68801e24950 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -7,7 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -fno-stack-protector \
>  	     -DDISABLE_BRANCH_PROFILING $(DISABLE_STACKLEAK_PLUGIN)
> 
> -obj-y :=
> +obj-y := ../hyp-entry.o
> 
>  obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
>  extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> index a4f48c1ac28c..157d106235f7 100644
> --- a/arch/arm64/kvm/va_layout.c
> +++ b/arch/arm64/kvm/va_layout.c
> @@ -150,7 +150,7 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
>  	/*
>  	 * Compute HYP VA by using the same computation as kern_hyp_va()
>  	 */
> -	addr = (uintptr_t)kvm_ksym_ref(__kvm_hyp_vector);
> +	addr = (uintptr_t)kvm_ksym_ref_nvhe(__kvm_hyp_vector);
>  	addr &= va_mask;
>  	addr |= tag_val << tag_lsb;

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
