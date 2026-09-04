Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B183F1AD5
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 08:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788511161; cv=none; b=nR5RQgqlI3shtROc6/yGZlN635AFDq8b9b1v1frZmYOhmXjZx/KgrQN8Pav5E4H4SHLkL7/iakYsn1OIlghMiXbBT4jmbbt0/QaSCtdnhT3pWOPKFPl8httxgbvh390yMyinhc8WIM8DimhJtkoj5uTU72E20x1jYyfIyElhE6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788511161; c=relaxed/simple;
	bh=ez4hNx4DVEe8KBHqNb84IrBjM+F93g8WM7rAblDyLXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HsDjjpbnlB4DlJrxgBgRO6Zmj98aE+I4qcLSznX81SoiTqu1hjLcCmWOt1Pc52NllO9cvi2awTpDpaPcu5F3O5llQkS0G82W8vcRTApVCM9ZoZ/Lu1aVFMLNjThxNbVv7Wh1RBoe5Eku4A3P+uB7TUUssJVI2KN3dwXeqALJx8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nr515e14; arc=none smtp.client-ip=91.218.175.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nr515e14"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ez4hNx4DVEe8KBHqNb84IrBjM+F93g8WM7rAblDyLXo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788511157; v=1; x=1789115957;
 b=Nr515e14o6jo5iYmFOgF9Ul0KQGsN4/MwD7YQM1jBLzTR2DSJi0ZNDm5ljCFnnKSwVBqI6si
 +Be1fYxEijBB4EL+C7CLLSyQzOdDY6InG0+NdFBV2+rKqu9ALRwhpDSxoeiy5kF/ZfdHZS4bQCo
 vMVaSxh/Kxh/Jn8jdR7sDLNQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 476049ad87e21ad1;
	Fri, 04 Sep 2026 08:39:17 +0000
X-Mizu-Trace-ID: 476049ad87e21ad1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so3589e87.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 01:39:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxltxHZ2A9RG3DJLkwN1xDS6y04rhV7dL2PNiZFQ2GzYg94gCq9XuJ0p67dKBvNPQzyQ37TNL0=@lists.linux.dev
X-Gm-Message-State: AFuF++mjKprPYrfPo9LXCba/GTQfpd9IgpVkAuzkOY7wqEDliQUVGt62
	uS/u+X9OG2gQ72fltXg+tNAnVxk2xl2ucepbZWQ9gAiOpt71xmlMVe5A0Nf+9J4nswbOU8P0ZB2
	chhk1O0w+UKMU0Dz+iTVNm0ylYjSJL5vvrUABQ5ux
X-Received: by 2002:a05:6512:2352:b0:5b4:9dba:7401 with SMTP id
 2adb3069b0e04-5b6182512c1mr68725e87.11.1788511156074; Fri, 04 Sep 2026
 01:39:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com> <20260826-arm64-52bit-va-v1-1-14ec98211363@fujitsu.com>
In-Reply-To: <20260826-arm64-52bit-va-v1-1-14ec98211363@fujitsu.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 4 Sep 2026 09:38:39 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy6EH-d=O+dtRdWdTUkS0zkXeW=auxiK6N5Dc-yihrYRw@mail.gmail.com>
X-Gm-Features: AcwNN1Ue3UiJZXsq0JIrKBZUTapvpCHZ2jnrY0FG9kKB_BUUN5ArhPu7u2gQg_E
Message-ID: <CA+EHjTy6EH-d=O+dtRdWdTUkS0zkXeW=auxiK6N5Dc-yihrYRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: selftest: arm64: Support 5-level paging in stage
 1 translation table
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Takayuki Okamoto <tokamoto@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Hi Itaru,

The usual subject prefix in the tree is "KVM: arm64: selftests:", for
this patch and the next one.

On Tue, 25 Aug 2026 at 22:18, Itaru Kitayama <itaru.kitayama@fujitsu.com> wrote:
>
> Add p4d_index() for when 5-level paging required, i.e., V52 guest mode
> IDs. With the index helper function, _virt_pg_map() handles 5-level

Only VM_MODE_P52V52_4K has five levels. The 16K and 64K V52 modes get
four and three, so this is for the 4K granule rather than for V52
modes as a class.

...

>  u64 *virt_get_pte_hva_at_level(struct kvm_vm *vm, gva_t gva, int level)
>  {
> +       int start_level = 4 - vm->mmu.pgtable_levels;
>         u64 *ptep;
>
> +       TEST_ASSERT(level >= start_level && level <= 3,
> +                   "Invalid translation level %d, valid range is %d-3",
> +                   level, start_level);
> +
>         if (!vm->mmu.pgd_created)
>                 goto unmapped_gva;
>
>         ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pgd_index(vm, gva) * 8;
>         if (!ptep)
>                 goto unmapped_gva;
> -       if (level == 0)
> +       /*
> +        * Stage-1 translation starts at level -1 for a five-level page
> +        * table, and at levels 0, 1, or 2 for four-, three-, or two-level
> +        * page tables, respectively.
> +        */
> +       if (level == start_level)


This changes what level means for the existing three-level modes:
level 0 used to return the top-level entry and now trips the assert,
level 1 used to return the leaf and now returns the top level. No
caller in tree asks for either of those two levels, and the new
numbering matches the architecture.

...

> @@ -321,12 +356,14 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
>         case VM_MODE_PXXVYY_4K:
>                 TEST_FAIL("AArch64 does not support 4K sized pages "
>                           "with ANY-bit physical address ranges");
> +       case VM_MODE_P52V52_64K:

These VM_MODE_ enumerators arrive in patch 2, so this patch does not
build on its own:

  lib/arm64/processor.c:359:7: error: use of undeclared identifier
'VM_MODE_P52V52_64K'; did you mean 'VM_MODE_P52V48_64K'?
  lib/arm64/processor.c:360:7: error: duplicate case value 'VM_MODE_P52V48_64K'

There are other build errors from the same cause. Could you move the
enum values and their vm_guest_mode_string()/vm_guest_mode_params[]
entries into this patch, or a new one altogether?

>         case VM_MODE_P52V48_64K:
>         case VM_MODE_P48V48_64K:
>         case VM_MODE_P40V48_64K:
>         case VM_MODE_P36V48_64K:
>                 tcr_el1 |= TCR_TG0_64K;
>                 break;
> +       case VM_MODE_P52V52_16K:
>         case VM_MODE_P52V48_16K:
>         case VM_MODE_P48V48_16K:
>         case VM_MODE_P40V48_16K:
> @@ -334,6 +371,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
>         case VM_MODE_P36V47_16K:
>                 tcr_el1 |= TCR_TG0_16K;
>                 break;
> +       case VM_MODE_P52V52_4K:
>         case VM_MODE_P52V48_4K:
>         case VM_MODE_P48V48_4K:
>         case VM_MODE_P40V48_4K:
> @@ -348,6 +386,9 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
>
>         /* Configure output size */
>         switch (vm->mode) {
> +       case VM_MODE_P52V52_4K:
> +       case VM_MODE_P52V52_16K:
> +       case VM_MODE_P52V52_64K:
>         case VM_MODE_P52V48_4K:
>         case VM_MODE_P52V48_16K:
>         case VM_MODE_P52V48_64K:
> @@ -578,6 +619,42 @@ static u32 max_ipa_for_page_size(u32 vm_ipa, u32 gran,
>                 return min(vm_ipa, 48U);
>  }
>
> +u32 aarch64_get_supported_va_size(void)

This repeats aarch64_get_supported_page_sizes() below it and builds a
second probe VM one line after the first. Could it take a u32 *va
out-param, so both ID registers come off the one vCPU?

VARange is the 52-bit VA indicator for the 64K granule only, so a bare
52 or 48 reads as granule-independent. The caller in patch 2 only uses
it for 64K, so nothing is wrong today.

Cheers,
/fuad


> +{
> +       struct kvm_vcpu_init preferred_init = {};
> +       int kvm_fd, vm_fd, vcpu_fd, err;
> +       u64 val;
> +       u32 va_range;
> +       struct kvm_one_reg reg = {
> +               .id     = KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR2_EL1),
> +               .addr   = (u64)&val,
> +       };
> +
> +       kvm_fd = open_kvm_dev_path_or_exit();
> +       vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, NULL);
> +       TEST_ASSERT(vm_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm_fd));
> +
> +       vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
> +       TEST_ASSERT(vcpu_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu_fd));
> +
> +       err = ioctl(vm_fd, KVM_ARM_PREFERRED_TARGET, &preferred_init);
> +       TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_ARM_PREFERRED_TARGET, err));
> +
> +       err = ioctl(vcpu_fd, KVM_ARM_VCPU_INIT, &preferred_init);
> +       TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_ARM_VCPU_INIT, err));
> +
> +       err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
> +       TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, err));
> +
> +       va_range = FIELD_GET(ID_AA64MMFR2_EL1_VARange, val);
> +
> +       close(vcpu_fd);
> +       close(vm_fd);
> +       close(kvm_fd);
> +
> +       return va_range >= ID_AA64MMFR2_EL1_VARange_52 ? 52 : 48;
> +}
> +
>  void aarch64_get_supported_page_sizes(u32 ipa, u32 *ipa4k,
>                                       u32 *ipa16k, u32 *ipa64k)
>  {
>
> --
> 2.43.0
>
