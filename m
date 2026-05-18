Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C539E3E7171
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 10:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779100057; cv=none; b=Xi4cmHi2Ec3kgJGnNWzj5aPcKa3/fIBCe1LpGcnjHdIf6qqMNx7WloUXyCSguZQQRqJS6h9CleXpEg+tyna2MzmGdJ/CUZ71I+g7L1hmJTDGTmjMD7U046jYtWTI3cPId6fkFaLljADvY5CueeHlblRlecg7QPnBHf/aFxwneaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779100057; c=relaxed/simple;
	bh=q//63wwyubdSelf71C+/xMPdqZEOIoeRBSv5bbWoOg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KwxJcNgZ19iFciw1gQjvKosGZyMOuZO4Fiz8B9lHzZNmdtG/YxPNn5P7sEkzSy3mpgVQMB5/o3VzkQp2BGvue4UKlEOCwZbTZZ5ZddycuJctbPBjDpES9x/52C+ajbM/FgB8mZprDfpqCYfh223xSgeebFL4eSSIZBrr8EP33Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hDrHWCTJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hDrHWCTJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779100046;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVSCeAhOwn5hkTv4cFbfZT6+KgO3cID0Tows3sPcKao=;
	b=hDrHWCTJWuUqjEsMeoMclGa4u7G64cUd1rCsN3oueMczH/tA8C1UaHtZVO34N6wQNhptIi
	pdf9ZxBFY1g2yx1vPLwM79ilGbdAyfIzAdBblXjtgh4R6y1n6xiJ1/gZ6NY5AIQtPb/jWc
	5a08ReLdLDFjT1MYYjy0V4+oqDWjW9k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-ZtZK8MdYNtOCgojW31rBTw-1; Mon, 18 May 2026 06:27:23 -0400
X-MC-Unique: ZtZK8MdYNtOCgojW31rBTw-1
X-Mimecast-MFC-AGG-ID: ZtZK8MdYNtOCgojW31rBTw_1779100042
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48fd233d1e2so19387035e9.1
        for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 03:27:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779100042; x=1779704842;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVSCeAhOwn5hkTv4cFbfZT6+KgO3cID0Tows3sPcKao=;
        b=N79Z86chPtdzgGhmPMyejFLzYm1BmVO9mKPyngIOEGdf5GZFv9/OjO2wcPIpCPsSro
         tnSXByJmKELYJHk4py7ikhvGEyRswI/ErFiguf8x78W75YJPOzLSy+97UohTlYMJuP8T
         FY1GwKQlspZy3vzN6FVDx5GCWhbpiC3no5M/vB8/7n3nUomLOhycRPett43yd7HzW5Hj
         f3qyH+IjmLfU/6eK0eD5Bwk3iVQwBokXNUM1c69A5wABGRDh5xFOMggBcbGi6fQVaIhJ
         ZRYWm30TgQWgVCjLTNw5I5xgFbu/Nts74K9VEmlq94nLFr6aODilELtp1zEdnaXt9OAF
         /lOw==
X-Forwarded-Encrypted: i=1; AFNElJ9mTT/FVGBJgfVjth3n0NgDg49NHqm9RmP02M+g13Bn75wFr4nOPjq8HR294Qi5nN/dO/6tY60=@lists.linux.dev
X-Gm-Message-State: AOJu0YwY3fGmevMnG+Yfhn+v1Flm1iOrHpVq53IOwkEPfnO0vMRnfuZE
	j2ZvFkqT3DTVJU9hWR2Uz6glUBCtrYvl8pxBGPCslTlI/ZzdL9lWaiVe1L3yF3kL3OCQWHnznPH
	tFKsJxU15gr4G8gylysrr1VEImYMtAGH1hSv6GWBpFHiKxRnD//3TsZvygw==
X-Gm-Gg: Acq92OHU9GZ/pb0SkhrKmw9PW3sZELhPqI2UsuLH9m80Qb0cs83bQODV3D42o59kAAs
	62OLTYG1myX/sK15+IrC+sbmF8CHO21+m7GBBt1C3OcoIUCNnIgDRBWvC7GOIyE8V1ReoWEbA9Y
	0Pd6LzzAWau7uVrVguzAxsORz81N3FWPIeEPWbDDpIjjQ7kO3Mw/8EG3ZBC/Rq+TCv/O59oJgHp
	SuX3C3bDYfm1c7+HJiE9DN5WHMgUZIoiudrVa3vnR4G+sQNc3bmHbxzoC46crgKOPKLa3BOy55R
	S/QSwO0Y1HuBrw/KeA06kaZdRhQu+4lUj2LuKGaqMGpLhGXHxcO9DVgRngnDJbAuBkc8CJw6ttf
	Mhb4zjJk/hCnPznGaf+7YbYcYpwRNLJ19A8xLBXf+qxKOMoNLDnzs7BKgk3onocHrBv3Liw==
X-Received: by 2002:a05:600c:1f89:b0:48e:526e:101a with SMTP id 5b1f17b1804b1-48fe60e7a13mr207226275e9.12.1779100041525;
        Mon, 18 May 2026 03:27:21 -0700 (PDT)
X-Received: by 2002:a05:600c:1f89:b0:48e:526e:101a with SMTP id 5b1f17b1804b1-48fe60e7a13mr207225815e9.12.1779100040928;
        Mon, 18 May 2026 03:27:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4900c16c744sm60785255e9.3.2026.05.18.03.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 03:27:20 -0700 (PDT)
Message-ID: <dd4744c5-6f89-4377-b28a-24b2ebc23412@redhat.com>
Date: Mon, 18 May 2026 12:27:18 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v1 00/13] named CPU models for ARM64 on KVM
To: Shaju Abraham <shaju.abraham@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
 skolothumtho@nvidia.com, philmd@linaro.org,
 Andrea Bolognani <abologna@redhat.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MBjeafUAkNc_F8wF8Z--vk7WbiN-dE4hWBgDC1hh6Bk_1779100042
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Shaju,

On 5/13/26 6:33 PM, Shaju Abraham wrote:
> Hi All,
>
> This RFC introduces "named" CPU models for ARM64 KVM guests. This
> is foundational for cross-host live migration and management-stack
> control over individual CPU features exposed to the guest.
>
> TL;DR Examples:
>   # Boot with Grace CPU model
>   qemu-system-aarch64 -cpu grace-v1 -machine virt,accel=kvm ...
>
>   # Grace with a feature disabled
>   qemu-system-aarch64 -cpu grace-v1,feat_SHA1=off ...
>
>   # Host passthrough with individual feature control
>   qemu-system-aarch64 -cpu host,feat_AES=aes ...
>
>   # Neoverse v2 on Grace.
>   qemu-system-aarch64 -cpu neoverse-v2-v1
>
>   # Migration from Grace to Graviton3 (TBD)
>   qemu-system-aarch64 -cpu neoverse-v1-v1 ...
>
> Relationship with Auger/Huck's customizable host model [1]:
> We have been working on this series in parallel with [1]. Eric Auger and
> Cornelia Huck's series [1] exposes raw SYSREG_<REG>_<FIELD> uint64
> properties on -cpu host, providing the essential low-level knobs for ID
> register customization. This RFC builds on the same KVM capability

Please find some comments/questions below.
> and can be layered on top of [1]:
>   - Human-readable property names: feat_AES=pmull instead of
>     SYSREG_ID_AA64ISAR0_EL1_AES=2, with arch-defined named values
>     validated at set time.
From what I understand what you call feature here refers to an
ARM64_FTR_BITS definition in kernel arch/arm64/kernel/cpufeatures.c.
Named string values, safe policy and safe value are all extracted from
the kernel implementation and do not stem from the ARM ARM itself.

If the named vcpu models anyway use hardcoded values I wonder if it is
so important to have named string values whereas a comment would do the
job in the named vcpu model definition?

From a spec pov I had in mind that a defintion of a FEAT could be much
more complex that just 1 field (for instance could be a combination of
several of them).

It is not clear to be if you allow the end-user to overwrite a property
on top of a named model setting.

>   - Default values and forward compatibility: CPU models start from a
>     known-zero baseline rather than the host view, so new fields/registers
[1]
>     introduced in future kernels do not silently leak into existing models.
>   - Named CPU models with hierarchical inheritance: grace-v1,
>     neoverse-v2-v1, etc.
>
> The two series can coexist; this series can be rebased on top of [1].
>
> [1] https://lore.kernel.org/qemu-devel/20260503073541.790215-1-eric.auger@redhat.com/
>
> Problems with defining "named" CPU models for ARM64 KVM guests:
>   * Features are not single CPUID bits. They are mostly multi-bit fields
>     encoding version/level instead of just presence. A single field encodes
> 	multiple ARM ARM defined features (FEAT_s) at different thresholds.
would be good to provide an example for each challenge. I remember
Connie provided some in the past though her KVM forum presentations.
>   * KVM does not allow all registers and fields to be modified for a guest.
>     Some fields KVM does not virtualise at all (SME) or only support host
> 	values (BRPs, CWG, etc.). This is evolving and differs between kernel
> 	versions.
this seems to be contradictory to [1]. Do you have a mix of host
inherited values and hardcoded value or do you only have hardcoded values?
>   * ARM does not have a single natural granularity for CPU models unlike
>     x86. ARM has architecture, reference core and SoC levels each becoming
> 	more granular.
>   * ARM has dozens of vendors and it will be tricky to maintain models for
>     all of them.
>   * Previous designs started from the host values and then subtracted
>     undesirable features. This is not forward-compatible; the design
>     should work when a new ID register or field is introduced.
>
> With the above problems in mind, the design has 3 layers:
>
> 1. ARM ID Register Field Table:
>    - This layer maintains all architecturally defined ID registers and
>      ID register fields. It includes:
> 		* Field name
> 		* Field shift
> 		* Field length
> 		* Safe-value tag: LOWER, HIGHER, HIGHER_OR_ZERO, SIGNED_LOWER,
> 						  EXACT, ANY
> 			This will be used to validate user-provided values during
> 			CPU realization time against the host's value. I.e., if the
> 			host only supports "aes", a CPU model that sets "pmull"
> 			should be rejected.
why isn't the kernel doing that job already. Setting a value not
compatible with the host shall be rejected by the kernel, no?
> 		* Default value: The value to which the field is reset. This gives
> 			CPU models a clean cpu.isar.idregs[] baseline instead of the
> 			host view provided by the kernel, as in previous designs.
> 			This also complements the forward-compatibility story. Given
> 			the "default" values, higher levels need not worry about new
> 			fields/registers being introduced.
> 		* Architecturally defined named values like "off", "aes", "pmull",
> 			etc.
> 		* These values are derived from the kernel's ftr_bits array and
> 		  tools/sysreg file.
>     E.g:
>
>      IDREG_START(ID_AA64ISAR0)
>      IDREG_FIELD_START(ID_AA64ISAR0, AES, 4, 4, LOWER, 0)
>      IDREG_FIELD_ARCH_VAL(0b0000, "off")
>      IDREG_FIELD_ARCH_VAL(0b0001, "aes")
>      IDREG_FIELD_ARCH_VAL(0b0010, "pmull")
>      IDREG_FIELD_END(ID_AA64ISAR0, AES)
> 	 ....
> 	 IDREG_END(ID_AA64ISAR0)
>
>    - This layer is the single source of truth for ARM64 ID registers.
single source of truth extracted from the kernel and not from the spec.
What if we discover a bug in ARM64_FTR_BITS chang default or safe value
for instance. How does the change propagate to qemu and existing models?
>      The default values and safe-value tags are manually derived from the
default value, if equal to reset value could be extracted from the spec
directly.
> 	 kernel's ftr_bits array. Other boilerplate and arch-defined values are
> 	 script-generated.
>
>    - AArch32 ID registers are added with a single field so they can be
>      zeroed out on hosts that support AArch32.
>
>    - This layer also defines helpers for higher layers to extract and
>      manipulate ID register fields.
>        * arm_idregs_reset_to_defaults(): Reset all ID registers to their
> 	     default values.
> 	   * arm_idreg_field_read/write(): Read the value of an ID register
> 	     field.
> 	   * arm_arch_val_name/from_name(): Look up the arch-defined name for
> 	     a numeric field value.
> 	   * ...
this is a pity we have not exchanged on this earlier because that code
could have been shared instead of rewriting things and resetting all
credits.
>
> 	- This layer creates the following tables using X-macro expansion:
> 	   * arm_idregs[]: Array of ID register descriptors.
> 	   * arm_field_locs[]: Array of field location descriptors.
> 	        (fieldIDx -> registerIndex, fieldIndex)
> 	   * ...
>
>     - The ArmIdReg struct also includes a writable_mask to track which
>       bits are writable by KVM. This is populated at runtime during
>       scratch VM creation, and is further used to validate that only
>       the writable bits are modified by the CPU model.
this is an interesting idea that could have been also used in previous
contributions.
>
> 2. ARM Properties Layer:
>    A small property layer on top of the ID Register Field table is defined.
>    This series defines two types of properties with plans for one more
>    in the future:
>       - Single field properties: These represent ARM FEAT_X features
> 	    that correspond to a single ID register field. Example: feat_AES,
> 	    feat_SHA2, etc.
>
> 		The property name is set as "feat_<FieldName>" and possible values
> 		are the arch-defined named values. This can be further categorized
> 		into:
> 			* STRING: multi-bit fields (>=2 bits) with arch-defined named
> 			          values, example: feat_AES, feat_SHA2, etc.
> 			* BOOLEAN: 1-bit fields only (true/false)
> 			          example: hw_prop_IDC, hw_prop_DIC, etc.
> 			* NUMERIC: IDREG_ANY fields with no named values (raw integer)
> 			          example: hw_prop_BS, hw_prop_DZP, etc.
I just wonder if we need all that complexity if eventually we hardcode
values in named vcpu models
>
> 		String property values are validated against the arch-defined named
> 		values.
>
> 		ID register fields that are not covered by single field properties
> 		are also exposed as a property named hw_prop_FieldName. These are
> 		usually implementation-defined values like cache geometry, debug
> 		counter widths, etc. (CTR_EL0.*, DCZID_EL0.*, etc.)
> 		Example: hw_prop_BS, hw_prop_DZP, etc.
how do you discriminate between those and field_ props? Again do we need
that complexity?
>
> 		Single field properties are defined as:
>
> 		ARM_PROP("prop_name", type, reg, field)
> 		Example:
> 		ARM_PROP("feat_AES", STRING, ID_AA64ISAR0, AES)
>
> 		* Validation based on safe-value tags is yet to be implemented.
>
>      - Fractional properties: These represent ARM FEAT_X features that
> 	    use two fields (base + frac) across registers. Example: feat_CSV2,
> 	    feat_MPAM, etc.
>
> 		The property name is set as "feat_<BaseFieldName>" and possible
> 		values are the arch-defined string values like "0.0", "1.0", "1.1",
> 		etc.
>
> 		Fractional properties are defined as:
> 		ARM_FRACTIONAL_PROP("prop_name", base_reg, base_field, frac_reg, frac_field)
> 		Example:
> 		ARM_FRACTIONAL_PROP("feat_CSV2", ID_AA64PFR0, CSV2, ID_AA64PFR1, CSV2_FRAC)
>
>
> 		When a fractional property is set, both the base field and frac
> 		field values are set to the corresponding values.
> 		E.g: feat_CSV2=1.1 will set ID_AA64PFR0.CSV2=1 and ID_AA64PFR1.CSV2_FRAC=1.
>
> 	- Composite properties (planned for v2):
> 	   These will act as master boolean switches that control a list of
> 	   fields. Example: pauth, sve, etc. Setting sve=on with a named model
> 	   will set all the SVE-related fields (ID_AA64ZFR0_EL1.*) along with
> 	   sveNNN vector-length. Similarly, setting pauth=on will set APA, GPA,
> 	   API, GPA3, GPI, GPA3 fields based on the named model.
>
> 	- cpu_revision, cpu_partnum, etc. properties are introduced to expose
> 	  MIDR, REVIDR, AIDR fields.
>
> 	Exceptions to the property naming are made for ID_AA64PFR0_EL1.ELx
> 	fields, which are named elx_mode.
yet another naming exception. 
>
> 	This series defines over 130 single field properties plus 4
> 	fractional properties. All properties work with -cpu host also.
Similary as with the host "custom" series, one needs to address
collision between legacy cpu properties and low level ones too.
>
> 	All properties change the cpu.isar.idregs[] values which are later
> 	written back to KVM at the end of kvm_arch_init_vcpu().
>
> 	* The arch-defined named values and property names can be iterated
> 	  until they make sense.
>
> 3. ARM CPU Model Hierarchy:
>
> A small named model layer is defined on top of the properties. An ARM named
> CPU model defines a list of property values and a parent model. A child
> model naturally inherits all the properties from its parent and can
> override them when needed.
>
> The initial model hierarchy shipped here is:
>     kvm-base-v1                  KVM-imposed quirks
>       arm-v8_4-a-v1              ARMv8.4-A architectural mandate
>           neoverse-v1-v1         Neoverse V1
> 		    graviton3-v1         AWS Graviton3
> 		arm-v9_0-a-v1            ARMv9.0-A architectural deltas on top of ARM-v8_4-a-v1
>           neoverse-v2-v1         Neoverse V2
>             grace-v1             NVIDIA Grace
Do you have a strategy for named model validation, besides code review.
At least each vcpu named model shall be introduced in separate patch,
overrides clearly explained and links to the reference spec shall be
precisely given for review.
>
> (kvm-base-v1 and arm-vX are not meant to be realizable unless the
>  user provides values for implementation-defined fields)
>
> So for example, grace-v1 defines Crypto fields and CTR_EL0.IDC/DIC on top
> of neoverse-v2-v1, which leaves those fields vendor-configurable.
>
> The hierarchy reflects a deliberate trade-off:
>   - Architecture-level models (arm-v8_4-a-v1) maximize migration
>     compatibility but lack implementation-defined values.
>   - Reference-core models (neoverse-v2-v1) enable migration across
>     SoCs sharing the same core design.
>   - SoC models (grace-v1) expose the full hardware feature set but
>     limit migration to hosts with the same SoC.

What kind of migration did you exercise up to now?
>
> At model realization time,
>     1. a clean slate of cpu.isar.idregs[] is created using
> 	   arm_idregs_reset_to_defaults().
> 	2. Then, a model's full parent-chain is walked and all properties are
> 	   applied in order from parent to child.
> 	3. Finally, kvm_arm_writeback_idregs() compares the model's desired
> 	   ID-register values against the host-provided cpreg snapshot and
> 	   writes back the writable bits, warning on any non-writable difference.
>
> Models will follow a monotonic versioning convention (grace-v1, grace-v2,
> ...) mirroring x86's scheme.
>
> * Please take the CPU model property values with a grain of salt.
>   They are added based on what the guest-visible values are with "host"
>   model on available hardware.
I don't catch the above statement.
>
> Benefits of this design:
> 	- General benefits that come with properties and named CPU models,
> 	  like cross-host live migration, management-stack control over
> 	  feature exposure, etc.
> 	- Forward compatibility: when a new ID register or field is
> 	  introduced, CPU models need not change; during realization they
> 	  will be populated with the default values. Only ID register/field
> 	  information needs to be added to the field table.
> 	- As CPU models are hierarchical, defining a new model is much easier.
I like the hierarchical approach but to be honest, at the moment, I miss
knowledge on whether it safely applies. I agree that named vcpu models
are the end target goal while [1] is rather an intermediate step that
was paving the way for it. I rather saw [1] as a tool box for enhaving
the host model and understanding issues when migrating. I wish we could
share the foundations instead of having totally separate contributions. 
> 	- The property names and values are self-documenting.
not really sorry (because it does not match the spec). I don't think we
can ask the end-user to read the kernel code.
>
> NOTE: ~2200 of the ~3300 added lines are declarative (field table,
> model definitions, properties, etc.)
>
> Tested with KVM on an NVIDIA Grace host.
>
> Relationship with existing code base:
>  - It does not change any TCG-based code paths.
>  - For KVM host passthrough it just adds property support.
with hardcoded reset values, correct? Instead of host retrived values?
>  - Does not change any existing properties or other code paths.
yes but if it words along with legacy options, you share our concern to
coexist with them
>  - Can layer on top of the SYSREG_ property series [1].
but in that case why don't you simply reuse it to build the named vcpu
model. I don't say the previous properties are the ideal solution but I
am not sure the mix or heterogenously named ones introduced here + value
strings retrieved from the kernel are better. At least the SYSREG ones
matched the spec with raw values, which bring simplicity in the code.
And since the end user shall be so much involved in provided extra
SYSREG values himself on top of named vcpu models, ...
>
> Planned Follow-ups:
>     - Composite properties with handling of sve, pauth for named models.
yes this is needed and I am currently working on this on [1]
>     - CLIDR_EL1 and CCSIDR_EL1 handling.
> 	- Safe-value based validation logic.
> 	- QMP commands like query-cpu-model-expansion are not hooked yet.
> 	  Blockers and supported values (calculated using safe-value tags
> 	  and runtime KVM writable masks) will be reported through them.
> 	  E.g. libvirt could report:
> 	    <property name='feat_AES' type='string' value='pmull'
> 	              supports='off,aes,pmull'/>
> 	  and:
> 	    <cpu type='kvm' name='nvidia-grace-v1'
> 			typename='arm-nvidia-grace-v1-arm-cpu' usable='no'>
> 	      <blocker name='feat_AES'/>
> 	    </cpu>
adding Andrea for libvirt inputs

Thanks

Eric
>
> 	- DCZID_EL0 handling.
>
> Out of Scope:
> 	- Inter-feature dependencies like FP <--> AdvSIMD, SM3 <--> SM4, etc.
>
> Appendix: KVM Non-writable fields (kernel 6.18):
>
> These fields pass the host value through to the guest unmodified on
> 6.18; trying to override them get a warning from kvm_arm_writeback_idregs()
> and the slot retains the host value:
>
>    #   Field                       #   Field
>   ---  -----------------------    ---  -----------------------
>    1   ID_AA64PFR0.FP              10  ID_AA64MMFR2.NV
>    2   ID_AA64PFR0.AdvSIMD         11  ID_AA64MMFR2.CCIDX
>    3   ID_AA64MMFR0.ASIDBITS       12  ID_AA64MMFR4.E2H0
>    4   ID_AA64MMFR1.XNX            13  ID_AA64DFR0.CTX_CMPs
>    5   ID_AA64MMFR1.VH             14  ID_AA64DFR0.BRPs
>    6   ID_AA64MMFR1.VMIDBits       15  CTR_EL0.CWG
>    7   ID_AA64MMFR2.EVT            16  CTR_EL0.ERG
>    8   ID_AA64MMFR2.FWB            17  DCZID_EL0.*
>    9   ID_AA64MMFR2.IDS
>
> This list shifts with the kernel version. The runtime probe via
> KVM_ARM_GET_REG_WRITABLE_MASKS is authoritative.
>
> Warm Regards,
>  Shaju, Khushit
>
> Khushit Shah (1):
>   target/arm/kvm: enable writable implementation ID registers
>
> Shaju Abraham (12):
>   target/arm: named_cpu_model: define containers for ID registers and
>     fields
>   target/arm: named_cpu_model: Add ID Register Fields
>   target/arm: named_cpu_model: initialise additional sysregs
>   target/arm: named_cpu_model: generate tables for Arm64 ID registers
>     and fields
>   target/arm: named_cpu_model: replace FIELD macro with IDREG_FIELD
>   target/arm: named_cpu_model: data-structures required for the ARM
>     property layer.
>   target/arm: named_cpu_model: define ARM properties
>   target/arm: named_cpu_model: generate arm_cpu_props[] table
>   target/arm: named_cpu_model: Add ID register field helper functions
>   target/arm: named_cpu_model: Register Arm64 properties for host model
>   target/arm: named_cpu_model: introduce named CPU models for selected
>     CPUs
>   target/arm: named_cpu_model: writeback modified ID registers to KVM
>
>  hw/arm/virt.c                   |    8 +
>  target/arm/arm-cpu-frac.inc.h   |   34 +
>  target/arm/arm-cpu-models.c     |  214 ++++
>  target/arm/arm-cpu-models.h     |   43 +
>  target/arm/arm-cpu-props.c      |  259 +++++
>  target/arm/arm-cpu-props.h      |   36 +
>  target/arm/arm-cpu-props.inc.h  |  180 ++++
>  target/arm/arm-v8_4-a-v1.inc.h  |   22 +
>  target/arm/arm-v9_0-a-v1.inc.h  |   28 +
>  target/arm/cpu-features.h       |  232 +----
>  target/arm/cpu-idregs.c         |  232 +++++
>  target/arm/cpu-idregs.h         |  132 +++
>  target/arm/cpu-idregs.h.inc     | 1724 +++++++++++++++++++++++++++++++
>  target/arm/cpu-sysregs.h.inc    |    5 +
>  target/arm/cpu64.c              |    3 +-
>  target/arm/grace-v1.inc.h       |   17 +
>  target/arm/graviton3-v1.inc.h   |   16 +
>  target/arm/kvm-base-v1.inc.h    |   13 +
>  target/arm/kvm.c                |  167 ++-
>  target/arm/meson.build          |    7 +-
>  target/arm/neoverse-v1-v1.inc.h |   64 ++
>  target/arm/neoverse-v2-v1.inc.h |   64 ++
>  target/arm/trace-events         |    1 +
>  23 files changed, 3284 insertions(+), 217 deletions(-)
>  create mode 100644 target/arm/arm-cpu-frac.inc.h
>  create mode 100644 target/arm/arm-cpu-models.c
>  create mode 100644 target/arm/arm-cpu-models.h
>  create mode 100644 target/arm/arm-cpu-props.c
>  create mode 100644 target/arm/arm-cpu-props.h
>  create mode 100644 target/arm/arm-cpu-props.inc.h
>  create mode 100644 target/arm/arm-v8_4-a-v1.inc.h
>  create mode 100644 target/arm/arm-v9_0-a-v1.inc.h
>  create mode 100644 target/arm/cpu-idregs.c
>  create mode 100644 target/arm/cpu-idregs.h
>  create mode 100644 target/arm/cpu-idregs.h.inc
>  create mode 100644 target/arm/grace-v1.inc.h
>  create mode 100644 target/arm/graviton3-v1.inc.h
>  create mode 100644 target/arm/kvm-base-v1.inc.h
>  create mode 100644 target/arm/neoverse-v1-v1.inc.h
>  create mode 100644 target/arm/neoverse-v2-v1.inc.h
>
> --
> 2.52.0
>

