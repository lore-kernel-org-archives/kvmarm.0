Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1BF1DFDA6
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783340416; cv=none; b=GU/TWAsmdpJdXvBxAbTEBnzsGQjjYx/6BGLLn4ALgDoCguOm2B5P7oQN3xj9sO5/Aik4K2MeDWHTh8a4CviQ1/uDyP3Anvy2nDM7MhPL7IuVJ6oQNqD4YXkNOVA6e+py5fhhKXZi3f5Ssf83i+QfY3CGbruZgzeDAJrOWZ5J2go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783340416; c=relaxed/simple;
	bh=3pAPqRyCz47jW6pF5Otooe/+3/9ox81FM1rDig9Ka4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=naVvrYibHBgr4pDKHUY/uO0f133PazqV0RwZnBnVzdfwCLtqJRcTkH1bj9K6Ofza9gmG9Tbbl51fef5r5fCakwsZ9WfkRC5+i2xhMBlux7pMuj+ZaMtrzcUjYcBGYPZjC8JpF4HSJUTSUhA1TWu+PuzzhP8kRwcpwkqGo46je94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ui7mjHoZ; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ui7mjHoZ"
X-Forwarded-Encrypted: i=1; AHgh+RoH16Mctz+UhJLNfRIChAIfFuzSu0hP4xXOm5GF5e/7tfNJ6bvwrksxWTHgE6zOVMhuOK1yHVQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783340413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dVcMhJLIy9haEIo6pLqn9e7Ayq5LkoPAXjXorNnSgUA=;
	b=ui7mjHoZv0kLP6LBEQndKFKOeq0lNRR8jYXXBUdl+iRXNNmtnBM7ELFhG2yulVZx3It81O
	1xrQHZW0ICnB8pBiw5h+SYykMAAuZcVvWxCD7FSNODWxUZwGuZf3Hcqz6ZaNFiy2EPo5ZJ
	rj8hsuDuPVEuKCrS/wjcZYKfn7MX+Ts=
X-Gm-Message-State: AOJu0Yw2fbo2JHRlgVF/OBPIiH5gtBSL4G3UURpnxIDYcoSPOhu/34nV
	HIoIkn+jDG8F9SLE4P+g4OEffC0FW48TCuDNF+7cl6nKYNu3kEJixZLhVytryvI1tWsic8E5rQv
	zC7vThrYreH/ng0WL72AGbstJdfwF1I75xDQ6AqSi
X-Received: by 2002:a05:622a:a588:b0:51b:fd21:c077 with SMTP id
 d75a77b69052e-51c4c1379d4mr17747231cf.21.1783340400558; Mon, 06 Jul 2026
 05:20:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706115522.954913-1-fuad.tabba@linux.dev> <20260706115522.954913-3-fuad.tabba@linux.dev>
 <20260706120824.0853C1F000E9@smtp.kernel.org>
In-Reply-To: <20260706120824.0853C1F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 6 Jul 2026 13:19:23 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz2mT8Qt4N8wKXhcUdn9YKKmyxxfyybcqj0zJfJDWLanA@mail.gmail.com>
X-Gm-Features: AVVi8CeOp1J0wbQRPfB0z2peKlVLRkq5RthR0rNtxpNgEn1-hZPTZqor5XoUC38
Message-ID: <CA+EHjTz2mT8Qt4N8wKXhcUdn9YKKmyxxfyybcqj0zJfJDWLanA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: arm64: selftests: Add MMIO sign-extending
 load test
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 13:08, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] The test executes guest code at EL0 but fails to map the execu=
table text segment with unprivileged access permissions (PTE_USER), causing=
 an immediate Instruction Abort.
> --
>
> commit 8d8bc26c675634520d0cf6c2769677a38145f1a9
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: selftests: Add MMIO sign-extending load test
>
> Add a test for sign-extending MMIO loads (LDRSB, LDRSH, LDRSW) into Xt
> and Wt destinations, with and without the sign bit set. The host supplies
> the MMIO data and checks the guest register holds the sign-extended value=
.
>
> > diff --git a/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c b/tools/=
testing/selftests/kvm/arm64/mmio_sign_ext.c
> > new file mode 100644
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
>
> [ ... ]
>
> > +static void guest_code(void)
> > +{
> > +     guest_loads_le();
> > +
> > +     if (guest_mixed_endian_el0()) {
> > +             write_sysreg(read_sysreg(sctlr_el1) | SCTLR_EL1_E0E, sctl=
r_el1);
> > +             isb();
> > +
> > +             asm volatile(
> > +             "       msr     elr_el1, %[pc]\n"
> > +             "       msr     spsr_el1, %[spsr]\n"
> > +             "       mov     x0, %[mmio]\n"
> > +             "       isb\n"
> > +             "       eret\n"
>
> [ ... ]
>
> > +int main(void)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_vm *vm;
> > +     struct ucall uc;
> > +     unsigned int i;
> > +     bool be;
> > +
> > +     vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
> > +     virt_map(vm, MMIO_ADDR, MMIO_ADDR, 1);
> > +
> > +     vm_init_descriptor_tables(vm);
> > +     vcpu_init_descriptor_tables(vcpu);
> > +     vm_install_sync_handler(vm, VECTOR_SYNC_LOWER_64, ESR_ELx_EC_SVC6=
4,
> > +                             el0_svc_handler);
> > +
> > +     be =3D vcpu_mixed_endian_el0(vcpu);
> > +     if (be)
> > +             make_el0_accessible(vm, MMIO_ADDR, vm->page_size);
>
> [Severity: Medium]
> Will this cause an immediate Instruction Abort on hardware supporting
> mixed endianness at EL0?
>
> The MMIO address is made EL0-accessible here, but the code segment
> containing el0_be_loads is not. KVM selftests map the test payload
> (including the .text segment) as EL1-only by default (AP[1]=3D0).
>
> When vcpu_mixed_endian_el0() is true, guest_code() drops to EL0 using ere=
t
> to execute el0_be_loads. Since the page containing el0_be_loads lacks
> unprivileged access permissions (PTE_USER), the instruction fetch at EL0
> will trigger a Permission Fault.
>
> Should the page containing el0_be_loads also be made EL0-accessible here?

Not an issue. PTE_USER (AP[1]) controls data access at EL0, not
instruction fetch, which is governed by UXN. The .text pages have UXN
clear, so el0_be_loads is fetchable at EL0 without PTE_USER.

This is actually what your earlier review caught in v2: the old code
set PTE_USER on the code page unnecessarily, confusing data access
with instruction fetch.

Cheers,
/fuad


>
> > +
> > +     ksft_print_header();
> > +     ksft_set_plan(ARRAY_SIZE(tests) * (be ? 2 : 1));
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706115522.95=
4913-1-fuad.tabba@linux.dev?part=3D2
