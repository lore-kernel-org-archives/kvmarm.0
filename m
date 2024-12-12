Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F1925949C
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 07:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733989283; cv=none; b=VsEcyWaTnt9jz1zp1oKqMapuZhpeEdlommEDDM3p70F77nEICnf6Mnr+MUIUMXl4iL03abzjvDpUvJmueIYJz5yP6gjbSb+/bfxpaS37/8QNO66n+hR74JwQfyIXOB0BTB/DgJCav3OOGG2b+uSpmAvV8xs8NsUr/CE7Vssty7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733989283; c=relaxed/simple;
	bh=uAByMjOFYXHeIZ/LGPByc5ccB6fLfIJSawVhUBRNBeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etLELTPQDwJQ2EnVUxfqPr1fsSDKqFoq718XfeQcMX98x96ADQckHY8IU/BG3Wz3KG2B00BASHtZS9M+m1wQ6GwytO4A6HAvznNcs8eeisQP5H6Ev9iCFqQF5wrvkp6GcTItQOCOPvcX7AvlvnGUFlIPpQEAvMlieBa0HxIJwcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f4CxVzJq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f4CxVzJq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733989278;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BBjqkexuxRVsrMPO4GlnyeXmHrcoGbCCP6iUHH48A4=;
	b=f4CxVzJqwLZfQp+LCVjN9xs25eIMpTlmYE7SdVEFK0QyKGZ2q6ELpRJb9y7AbZ2qUwOIfh
	OokcIuASmHZydd4ZKwDzXoMd7TBRIhH+bvUIaeXx/bs4qNCv1n1aoFp4rGm1DtzlXi4mMz
	LlonYXO57PgRlnzYQd46r9zcVxqRiks=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-I--In3N0PTSjMycaQ71WsA-1; Thu, 12 Dec 2024 02:41:17 -0500
X-MC-Unique: I--In3N0PTSjMycaQ71WsA-1
X-Mimecast-MFC-AGG-ID: I--In3N0PTSjMycaQ71WsA
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6d8f4a0df93so10400126d6.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 23:41:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733989275; x=1734594075;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+BBjqkexuxRVsrMPO4GlnyeXmHrcoGbCCP6iUHH48A4=;
        b=IdYThY9jLcOBoBBD5TXa7pW0fiHjSs/R2CGMjHWc4i6MgrNm2KmcaQDVcD5NtwiJsp
         40hMXVNAygfTyUCDSlczbvPysD7zllAOnz24b5HWhT2a+gK+pq1Biw6XJSKbYqx6enq5
         g3yJurUdY4tpcgAPrj6QZFSy6PxpgsCY76S9bPCtSAdPx7GQb9HugS9StfVndE9HnWQ7
         9DCtnpM1srFBmts3pGy3NEzsZemQ5FYxcsT85rxAeLiwa3SBaf0/scCvvdLXS/20tImb
         6SIKMh9d2FYfJTcb3WoCfX77kYTnsS3WjTPZkFZ1v5X7I/MzDQXn6QOFY05wZg+vo0Lo
         /c3A==
X-Forwarded-Encrypted: i=1; AJvYcCUycOc3DBT9IQ5XyFzh1pO9SGnoOrLxNRpMchaEnqwQLXx3pa3pY0CmAv1aDXRz4rIN1EoeAr0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzn+YYeS60T7PkjbAwya1Xv/jtkmOYAzFNf7mFLWXFVzmTaYC6V
	8XDBtRPeEpuL9tN4rZcXZIBYEFLF04Q8DLFi98zvEL23iRzY510QpEAOhmQjK70gHqjl5rWxA6k
	BCGnJrDjGmA4jXHHnJx9WuRhrt0thDO2nB+y74hN3XkivweB0EyjRm7dwT+ZuPw==
X-Gm-Gg: ASbGnct7mSgsCmC90H5dTJq6y6RRMo3BukopE9BfrIGTfxbAUxfibisMxQI58sD5WSW
	Ut/ucYBeKb/uyw6NeYIK7Ll+U306g5ZxB7eemSbteuxmJC/0l0u7qWCLRon2cKrL8ZSrakIyYd+
	Rug7zRjvi2iDwSMAVWTCvJzCE1XVZyBB5EnbU1HezuEKIcb5kVE7O2RfXq07eyC99hrrG2rhvuz
	qOE9fCCMvQYOYePSXpkbiQyQ9Sl6oKDO4jhe4LNunm0I5g1/7ATTJaf7+XW6negTiSPqtUrx1C4
	jq1/4NW8vX5yxNDAvXMCPScLQSpI
X-Received: by 2002:a05:6214:2129:b0:6d4:1662:348c with SMTP id 6a1803df08f44-6dae38f5795mr35838216d6.17.1733989275344;
        Wed, 11 Dec 2024 23:41:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHGREz05z/QXRJ9hkMXdYiNNC8IfSda0B0oYfur9EByF99pBgpCDDgNYCds16XzlHWCFNLnTA==
X-Received: by 2002:a05:6214:2129:b0:6d4:1662:348c with SMTP id 6a1803df08f44-6dae38f5795mr35837876d6.17.1733989274955;
        Wed, 11 Dec 2024 23:41:14 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dae944ce81sm4009876d6.61.2024.12.11.23.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 23:41:13 -0800 (PST)
Message-ID: <74616ed3-24d3-44fd-a8b0-bb2927dbd5d5@redhat.com>
Date: Thu, 12 Dec 2024 08:41:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20241206112213.88394-1-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20241206112213.88394-1-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k2H669GiFrps9hdppIhlxr2-PAreOq3Tq0uk05HRkTU_1733989277
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Peter, Richard,

On 12/6/24 12:21, Cornelia Huck wrote:
> A respin/update on the aarch64 KVM cpu models. Also available at
> gitlab.com/cohuck/qemu arm-cpu-model-rfcv2
>
> Find Eric's original cover letter below, so that I do not need to
> repeat myself on the aspects that have not changed since RFCv1 :)
>
> Changes from RFCv1:
>
> Rebased on more recent QEMU (some adaptions in the register conversions
> of the first few patches.)
>
> Based on feedback, I have removed the "custom" cpu model; instead, I
> have added the new SYSREG_<REG>_<FIELD> properties to the "host" model.
> This works well if you want to tweak anything that does not correspond
> to the existing properties for the host model; however, if you e.g.
> wanted to tweak sve, you have two ways to do so -- we'd probably either
> want to check for conflicts, or just declare precedence. The kvm-specific
> props remain unchanged, as they are orthogonal to this configuration.
>
> The cpu model expansion for the "host" model now dumps the new SYSREG_
> properties in addition to the existing host model properties; this is a
> bit ugly, but I don't see a good way on how to split this up.
>
> Some more adaptions due to the removal of the "custom" model.
>
> Things *not* changed from RFCv1:
>
> SYSREG_ property naming (can be tweaked easily, once we are clear on what
> the interface should look like.)
>
> Sysreg generation scripts, and the generated files (I have not updated
> anything there.) I think generating the various definitions makes sense,
> as long as we double-check the generated files on each update (which would
> be something to trigger manually anyway.)
>
> What I would like us to reach some kind of consensus on:
>
> How to continue with the patches moving the ID registers from the isar
> struct into the idregs array. These are a bit of churn to drag along;
> if they make sense, maybe they can be picked independently of this series?
What is your opinion on that? Patches 2 -12 are dedicated to the move of
isar struct's individual idreg fields to an array. To me , this
anonymous storage looks more generic, scalable and adapted to the way we
retrieve information from KVM. Do you think this is an acceptable
reshuffle of the code and can we envision to push those changes in a
separate prerequisite series that would avoid us to rebase everytime
until we get a solution for named vcpu models?

Thanks

Eric
>
> Whether it make sense to continue with the approach of tweaking values in
> the ID registers in general. If we want to be able to migrate between cpus
> that do not differ wildly, we'll encounter differences that cannot be
> expressed via FEAT_xxx -- e.g. when comparing various AmpereAltra Max systems,
> they only differ in parts of CTR_EL0 -- which is not a feature register, but
> a writable register.
>
> Please take a look, and looking forward to your feedback :)
>
> ***********************************************************************
>
> Title: Introduce a customizable aarch64 KVM host model 
>
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
> - The custom model and its exposed properties depend on the host
>   capabilities. More and more IDREG become writable meaning that
>   the custom model gains more properties over the time and it is
>   host linux dependent. At the moment there is no versioning in
>   place. By default the custom model is a host passthrough model
>   (besides the legacy functions). So if the end-user tries to set
>   a field that is not writable from a kernel pov, it will fail.
>   Nevertheless a versionned custom model could constrain the props
>   exposed, independently on the host linux capabilities.
> - the QEMU layer does not take care of IDREG field value consistency.
>   The kernel neither. I imagine this could be the role of the upper
>   layer to implement a vcpu profile that makes sure settings are
>   consistent. Here we come to "named" models. What should they look
>   like on ARM?
> - Implementation details:
>   -  it seems there are a lot of duplications in
>   the code. ID regs are described in different manners, with different
>   data structs, for TCG, now for KVM.
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
> Cornelia Huck (3):
>   kvm: kvm_get_writable_id_regs
>   arm-qmp-cmds: introspection for ID register props
>   arm/cpu-features: document ID reg properties
>
> Eric Auger (17):
>   arm/cpu: Add sysreg definitions in cpu-sysregs.h
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
>   arm/cpu: more customization for the kvm host cpu model
>
>  docs/system/arm/cpu-features.rst      |  47 +-
>  hw/intc/armv7m_nvic.c                 |  27 +-
>  scripts/gen-cpu-sysreg-properties.awk | 325 ++++++++++++
>  scripts/gen-cpu-sysregs-header.awk    |  47 ++
>  scripts/update-aarch64-sysreg-code.sh |  27 +
>  target/arm/arm-qmp-cmds.c             |  19 +
>  target/arm/cpu-custom.h               |  58 +++
>  target/arm/cpu-features.h             | 311 ++++++------
>  target/arm/cpu-sysreg-properties.c    | 682 ++++++++++++++++++++++++++
>  target/arm/cpu-sysregs.h              | 152 ++++++
>  target/arm/cpu.c                      | 123 ++---
>  target/arm/cpu.h                      | 120 +++--
>  target/arm/cpu64.c                    | 260 +++++++---
>  target/arm/helper.c                   |  68 +--
>  target/arm/internals.h                |   6 +-
>  target/arm/kvm.c                      | 253 +++++++---
>  target/arm/kvm_arm.h                  |  16 +-
>  target/arm/meson.build                |   1 +
>  target/arm/ptw.c                      |   6 +-
>  target/arm/tcg/cpu-v7m.c              | 174 +++----
>  target/arm/tcg/cpu32.c                | 320 ++++++------
>  target/arm/tcg/cpu64.c                | 460 ++++++++---------
>  target/arm/trace-events               |   8 +
>  23 files changed, 2594 insertions(+), 916 deletions(-)
>  create mode 100755 scripts/gen-cpu-sysreg-properties.awk
>  create mode 100755 scripts/gen-cpu-sysregs-header.awk
>  create mode 100755 scripts/update-aarch64-sysreg-code.sh
>  create mode 100644 target/arm/cpu-custom.h
>  create mode 100644 target/arm/cpu-sysreg-properties.c
>  create mode 100644 target/arm/cpu-sysregs.h
>

