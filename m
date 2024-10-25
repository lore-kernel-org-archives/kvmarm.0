Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DB82064E0
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 12:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729860575; cv=none; b=Cck1XUk8Wp0mXHlXfSl0uw6d4BZeo4BBkhgmWmiLCAO4thqmwQp+Ipikpx2K4vzLJ0/kwkyBdE9d5Cwdihm5/1gT4ndQIU528i7p07jTeHM3NLDp3mC5kSQ0j6yOGpJ673qEkwJBfaBQyNcASqmjH7336enkAv3AU5LJoSuzRo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729860575; c=relaxed/simple;
	bh=oohwAmAednoWW8YztnEuFbtCKhu38m0FFSb5I+du1n4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jcf18fYibhIKxKUeYbdPABs3tmf1as+l3QdsuP9AWVvchlsI51EEUL2NWlM4p4F8laFX/GtWlaeBWuXLjdYm4hQ++/k1V+0/uXhL6NR2rhtkNdGy0oOEP9fL6oP4cToSYoRJ2UAT6SJgYYSAS4PwYKNxJAxtdtGAIjy9f39ic7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9CJvS91; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9CJvS91"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729860571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f1BnruG4Kfu1r9iXja9U/DIlPDPmhd6APbx6NA1XMrE=;
	b=a9CJvS91aXj1wrwA2qqG3kxDPuN8+7OK5nYqcRf7KO9WxYJqwFF66RB4+JxmWhWq31EnhQ
	xf0fClyQPaDBThnzb/rP3bMr8ScXfhPzWJ8gLzAHd8BoyyQ4PJmdxB4g82N0TJSVGOIrPc
	7B+YJS3gPkZfrbxqoHZ/xaANWwzVglw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-RpRkkbBXNLqYo4wMaf5XvA-1; Fri,
 25 Oct 2024 08:49:28 -0400
X-MC-Unique: RpRkkbBXNLqYo4wMaf5XvA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7A4219560B7;
	Fri, 25 Oct 2024 12:49:25 +0000 (UTC)
Received: from localhost (unknown [10.39.193.55])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C0371955F43;
	Fri, 25 Oct 2024 12:49:23 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [RFC 00/21] kvm/arm: Introduce a customizable aarch64 KVM host
 model
In-Reply-To: <20241025101959.601048-1-eric.auger@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241025101959.601048-1-eric.auger@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 25 Oct 2024 14:49:21 +0200
Message-ID: <877c9wpctq.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Oct 25 2024, Eric Auger <eric.auger@redhat.com> wrote:

> This RFC series introduces a KVM host "custom" model.
>
> Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
> of a subset of ID regs. The list of writable fields continues to grow.
> The feature ID range is defined as the AArch64 System register space
> with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
>
> The custom model uses this capability and allows to tune the host
> passthrough model by overriding some of the host passthrough ID regs.
>
> The end goal is to get more flexibility when migrating guests
> between different machines. We would like the upper software layer
> to be able detect how tunable the vpcu is on both source and destination
> and accordingly define a customized KVM host model that can fit
> both ends. With the legacy host passthrough model, this migration
> use case would fail.
>
> QEMU queries the host kernel to get the list of writable ID reg
> fields and expose all the writable fields as uint64 properties. Those
> are named "SYSREG_<REG>_<FIELD>". REG and FIELD names are those
> described in ARM ARM Reference manual and linux arch/arm64/tools/sysreg.
> Some awk scriptsintroduced in the series help parsing the sysreg file and
> generate some code. those scripts are used in a similar way as
> scripts/update-linux-headers.sh.  In case the ABI gets broken, it is
> still possible to manually edit the generated code. However it is
> globally expected the REG and FIELD names are stable.
>
> The list of SYSREG_ID properties can be retrieved through the qmp
> monitor using query-cpu-model-expansion [2].
>
> The first part of the series mostly consists in migrating id reg
> storage from named fields in ARMISARegisters to anonymous index
> ordered storage in an IdRegMap struct array. The goal is to have
> a generic way to store all id registers, also compatible with the
> way we retrieve their writable capability at kernel level through
> the KVM_ARM_GET_REG_WRITABLE_MASKS ioctl. Having named fields
> prevented us from getting this scalability/genericity. Although the
> change is invasive  it is quite straightforward and should be easy
> to be reviewed.
>
> Then the bulk of the job is to retrieve the writable ID fields and
> match them against a "human readable" description of those fields.
> We use awk scripts, derived from kernel arch/arm64/tools/gen-sysreg.awk
> (so all the credit to Mark Rutland) that populates a data structure
> which describes all the ID regs in sysreg and their fields. We match
> writable ID reg fields with those latter and dynamically create a
> uint64 property.
>
> Then we need to extend the list of id regs read from the host
> so that we get a chance to let their value overriden and write them
> back into KVM .
>
> This expectation is that this custom KVM host model can prepare for
> the advent of named models. Introducing named models with reduced
> and explicitly defined features is the next step.
>
> Obviously this series is not able to cope with non writable ID regs.
> For instance the problematic of MIDR/REVIDR setting is not handled
> at the moment.
>
> Connie & Eric
>
> This series can be found at:
> https://github.com/eauger/qemu/tree/custom-cpu-model-rfc
>
> TESTS:
> - with few IDREG fields that can be easily examined from guest
>   userspace:
>   -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0,SYSREG_ID_AA64ISAR1_EL1_DPB=0x0
> - migration between custom models
> - TCG A57 non regressions. Light testing for TCG though. Deep
>   review may detect some mistakes when migrating between named fields
>   and IDRegMap storage
> - light testing of introspection. Testing a given writable ID field
>   value with query-cpu-model-expansion is not supported yet.
>
> TODO/QUESTIONS:
> - Some idreg named fields are not yet migrated to an array storage.
>   some of them are not in isar struct either. Maybe we could have
>   handled TCG and KVM separately and it may turn out that this
>   conversion is unneeded. So as it is quite cumbersome I prefered
>   to keep it for a later stage.
> - the custom model does not come with legacy host properties
>   such as SVE, MTE, expecially those that induce some KVM
>   settings. This needs to be fixed.

One idea would be to convert these to sugar and configure the relevant
features instead. The accelerator-specific properties would need to
either stay or be deprecated and later removed, I think; I'd hope there
are as few as possible of those. The ones requiring to actively do
something (e.g. enable MTE with KVM) are the fun ones.

> - The custom model and its exposed properties depend on the host
>   capabilities. More and more IDREG become writable meaning that
>   the custom model gains more properties over the time and it is
>   host linux dependent. At the moment there is no versioning in
>   place. By default the custom model is a host passthrough model
>   (besides the legacy functions). So if the end-user tries to set
>   a field that is not writable from a kernel pov, it will fail.
>   Nevertheless a versionned custom model could constrain the props
>   exposed, independently on the host linux capabilities.

Alternatively (or additionally?), provide a way to discover the set of
writable id regs, e.g. via a qmp command that returns what QEMU got from
KVM_ARM_GET_REG_WRITABLE_MASKS.

> - the QEMU layer does not take care of IDREG field value consistency.
>   The kernel neither. I imagine this could be the role of the upper
>   layer to implement a vcpu profile that makes sure settings are
>   consistent. Here we come to "named" models. What should they look
>   like on ARM?

I would go with Armv8.6, Armv9.2, etc. that include the mandatory
features, and additionally the features that can go on top (base model,
can be extended; this is similar to what we already have e.g. for s390
z<whatever> models, but allows for the complication that we have many
vendors doing many different designs.) Not sure if we'd also want models
for specific cpus, but that could go on top, I guess.

> - Implementation details:
>   -  it seems there are a lot of duplications in
>   the code. ID regs are described in different manners, with different
>   data structs, for TCG, now for KVM.

Base data struct for all accelerators and used for accelerator-agnostic
code, accelerator-specific structures on top (so that we can add new
accelerators, if wanted?) Once the cpu is up and running, we're not
manipulating the regs anyway.

>   - The IdRegMap->regs is sparsely populated. Maybe a better data
>   struct could be used, although this is the one chosen for the kernel
>   uapi.
>
> References:
>
> [1] [PATCH v12 00/11] Support writable CPU ID registers from userspace
> https://lore.kernel.org/all/20230609190054.1542113-1-oliver.upton@linux.dev/
>
> [2]
> qemu-system-aarch64 -qmp unix:/home/augere/TEST/QEMU/qmp-sock,server,nowait -M virt --enable-kvm -cpu custom
> scripts/qmp/qmp-shell /home/augere/TEST/QEMU/qmp-sock
> Welcome to the QMP low-level shell!
> Connected to QEMU 9.0.50
> (QEMU) query-cpu-model-expansion type=full model={"name":"custom"}
>
> [3]
> KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES
> KVM_ARM_GET_REG_WRITABLE_MASKS
> Documentation/virt/kvm/api.rst
>
> [4] linux "sysreg" file
> linux/arch/arm64/tools/sysreg and gen-sysreg.awk
> ./tools/include/generated/asm/sysreg-defs.h
>
>
> Cornelia Huck (4):
>   kvm: kvm_get_writable_id_regs
>   virt: Allow custom vcpu model in arm virt
>   arm-qmp-cmds: introspection for custom model
>   arm/cpu-features: Document custom vcpu model
>
> Eric Auger (17):
>   arm/cpu: Add sysreg definitions in cpu-sysegs.h
>   arm/cpu: Store aa64isar0 into the idregs arrays
>   arm/cpu: Store aa64isar1/2 into the idregs array
>   arm/cpu: Store aa64drf0/1 into the idregs array
>   arm/cpu: Store aa64mmfr0-3 into the idregs array
>   arm/cpu: Store aa64drf0/1 into the idregs array
>   arm/cpu: Store aa64smfr0 into the idregs array
>   arm/cpu: Store id_isar0-7 into the idregs array
>   arm/cpu: Store id_mfr0/1 into the idregs array
>   arm/cpu: Store id_dfr0/1 into the idregs array
>   arm/cpu: Store id_mmfr0-5 into the idregs array
>   arm/cpu: Add infra to handle generated ID register definitions
>   arm/cpu: Add sysreg generation scripts
>   arm/cpu: Add generated files
>   arm/kvm: Allow reading all the writable ID registers
>   arm/kvm: write back modified ID regs to KVM
>   arm/cpu: Introduce a customizable kvm host cpu model
>
>  docs/system/arm/cpu-features.rst      |  55 ++-
>  target/arm/cpu-custom.h               |  58 +++
>  target/arm/cpu-features.h             | 307 ++++++------
>  target/arm/cpu-sysregs.h              | 152 ++++++
>  target/arm/cpu.h                      | 120 +++--
>  target/arm/internals.h                |   6 +-
>  target/arm/kvm_arm.h                  |  16 +-
>  hw/arm/virt.c                         |   3 +
>  hw/intc/armv7m_nvic.c                 |  27 +-
>  target/arm/arm-qmp-cmds.c             |  56 ++-
>  target/arm/cpu-sysreg-properties.c    | 682 ++++++++++++++++++++++++++
>  target/arm/cpu.c                      | 124 +++--
>  target/arm/cpu64.c                    | 265 +++++++---
>  target/arm/helper.c                   |  68 +--
>  target/arm/kvm.c                      | 253 +++++++---
>  target/arm/ptw.c                      |   6 +-
>  target/arm/tcg/cpu-v7m.c              | 174 +++----
>  target/arm/tcg/cpu32.c                | 320 ++++++------
>  target/arm/tcg/cpu64.c                | 460 ++++++++---------
>  scripts/gen-cpu-sysreg-properties.awk | 325 ++++++++++++
>  scripts/gen-cpu-sysregs-header.awk    |  47 ++
>  scripts/update-aarch64-sysreg-code.sh |  27 +
>  target/arm/meson.build                |   1 +
>  target/arm/trace-events               |   8 +
>  24 files changed, 2646 insertions(+), 914 deletions(-)
>  create mode 100644 target/arm/cpu-custom.h
>  create mode 100644 target/arm/cpu-sysregs.h
>  create mode 100644 target/arm/cpu-sysreg-properties.c
>  create mode 100755 scripts/gen-cpu-sysreg-properties.awk
>  create mode 100755 scripts/gen-cpu-sysregs-header.awk
>  create mode 100755 scripts/update-aarch64-sysreg-code.sh
>
> -- 
> 2.41.0

