Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2771A285CB3
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780561918; cv=none; b=VnM3pS1OhhhGvU5NKGlafcOCnyN235+5PMuzsizLDIbdwoRk97Th/gA9WixDYD6FrF/SqRC9SWLLzygLQOSughCnnF0IvHCXD97gloyu4DEHk94XbXA/R17dF0rqbkbCFC3L2H9P51aYxkLQNen2v/waEgJuOWweowLESCR0gYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780561918; c=relaxed/simple;
	bh=QZUFFeE/zWYE0ibOF8MIRl7fETt/Cr7YoCjrXqi7Vrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nAgP899m207zHmiM0YeMzRx9c0JM/FFpSxVRcjt8tRRnHo5jlRPKXg1euT5g/zjGxZ9SRwUlkPXoXOOQt/wz/YvG+FIpG9gfYJAbOqH/QyoVnfjwA3E4X4KoAmqGYc+SY5h5wunqYSksYAxLzNxAxsx0Al/abycMhlqGD3+46yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TohJRe+y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TohJRe+y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780561916;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QZUFFeE/zWYE0ibOF8MIRl7fETt/Cr7YoCjrXqi7Vrw=;
	b=TohJRe+yaxM16jHJxvFz88gvlAOgKgWk+JpXz2Ljs6jTQrk9RGqc01tW3shEN8en2JYMP9
	HDKD22Pi/30czRpiYgB+lDdL6ydZ12SfbcuwSSYTuzxd0sycqU25aoL8uLUyty9XsuHrua
	vvH6wwMDLvVjSl1BZe2cgDDSd+1V+1s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-WD9k7HIPNE-YIf5sj6yqOg-1; Thu, 04 Jun 2026 04:31:54 -0400
X-MC-Unique: WD9k7HIPNE-YIf5sj6yqOg-1
X-Mimecast-MFC-AGG-ID: WD9k7HIPNE-YIf5sj6yqOg_1780561914
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45ef6b407b4so192735f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 01:31:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780561913; x=1781166713;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZUFFeE/zWYE0ibOF8MIRl7fETt/Cr7YoCjrXqi7Vrw=;
        b=WfB8U/yk+YJ2Tk/38QqxATvgb7m91R4CDCUtwWxg9d5Hx17hbR8EPBDyrvw1EK17gL
         g+tMYpf800Yb/r4GnOjBr/6c3nQA0m4L9Oz6A+d3IqFBHNMdy9VMjC6saRdt9LpFZe8i
         LMZZZ2n5jkR7rOyW/S4hXcaxZSEyyEIVbkQmiBW7sjFu+LAJnlVYWxz7lHkEPWBzcsq0
         KdhQdTVpYACv8MtDuRfu1RpBafdlAPcWAeB/zrVuJY/imrwz10LjZ6tCEg7UXB1AAc+8
         j5p+3GWZKc4G783RMdfu0Qt/EAWsQrdmbf3QxpI/cnJlpAqAPmkOgvO+f2ysWHrvYrSQ
         T/cQ==
X-Forwarded-Encrypted: i=1; AFNElJ/DhLkvM3EoQqRl7kuWJMT57nwexI8KG8+Ws0vDkM0KH0+ehe1crab/NpUOdIikMyCdnVentnA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMINdU42ikHdURTgY8EwkbuPNdI73Ghal7HV8OVpEJ8z7CooXK
	N0xl6vtREsdI0SV10xSzUhnz6RgWbNdxefexghzSkS1v5lcNoZg/qkkiXioj4hMbQNSTXugrsom
	gwdqAHOmyqakdATNLshf/GhYQAMRFNQCcJ+5P4FgHi9EAhsHxV8mFlrAadQ==
X-Gm-Gg: Acq92OG9q8TI/8bvRdX4ATooiPm1US21r/LX3SShxEIR7JWAbckcS+rIDWfq4GO4JGk
	iXI51DRz2rVoikyu6Nys9mvcRjnl/Qpmz3hZ9bpmpbU3dSXz6VL5k+bhu5o1R3tXM0xDfk6A2+k
	wlm5aRCk5N0puQrBU1sNY4WBS4CpBSTh+6SbMCjGLJ+FLb/grj7mx4OUfDN9iiCnV96NT9Ivomh
	F1TyvC1SpH/zc2qFvTfUSPNp4tsiqwOfzdKRNtrIStuS5feN0rTKnGZX7XH8ihFziG6zU6nuEmh
	76hfd1ClDF6Yxp36Wj26LLIy9SNinbh4CzPk53Xf8rdYERaQn2fBTp+b9VP05Gjgcy7YdAiGEGH
	1ZoAV2ftNbwH+CW1QdafzjSjzSKNo2ZdQIpZjixsyjtorXai7zRZJsUk/71DuMPeTLbazJKgGWF
	i5V87T
X-Received: by 2002:a05:600c:8b23:b0:490:b115:e03f with SMTP id 5b1f17b1804b1-490b5e893admr109843305e9.8.1780561913466;
        Thu, 04 Jun 2026 01:31:53 -0700 (PDT)
X-Received: by 2002:a05:600c:8b23:b0:490:b115:e03f with SMTP id 5b1f17b1804b1-490b5e893admr109842725e9.8.1780561913015;
        Thu, 04 Jun 2026 01:31:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc4082c3sm50760335e9.13.2026.06.04.01.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 01:31:51 -0700 (PDT)
Message-ID: <68090ea2-fe45-4935-80f2-1a4201b5c148@redhat.com>
Date: Thu, 4 Jun 2026 10:31:50 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 00/18] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Jinqian Yang <yangjinqian1@huawei.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, shaju.abraham@nutanix.com,
 khushit.shah@nutanix.com, cohuck@redhat.com, richard.henderson@linaro.org,
 sebott@redhat.com, skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <5a533932-06fe-4401-abfe-66546c15c4ec@huawei.com>
 <1bdf5296-874b-488e-8a34-d6f8d23ddcae@huawei.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <1bdf5296-874b-488e-8a34-d6f8d23ddcae@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sQm6d8-qYJGMdapXyi9z_lZYLqMa9CGZWiCoNXKdWCc_1780561914
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Jinqian,

On 6/4/26 8:32 AM, Jinqian Yang wrote:
>
>
> On 2026/6/4 14:08, Jinqian Yang wrote:
>>
>>
>> On 2026/5/19 21:27, Eric Auger wrote:
>>> This series enhances the current host KVM model with capability to
>>> set writable ID reg fields.
>>>
>>> Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
>>> of a subset of ID regs. The list of writable fields continues to grow.
>>> The feature ID range is defined as the AArch64 System register space
>>> with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
>>>
>>> The end goal is to get more flexibility when migrating guests
>>> between different host hardware.
>>>
>>> QEMU retrieves the writable ID fields from KVM UAPI [1] and
>>> match them against a generated description of ID regs and their
>>> named fields that stem from AARCHMRS Registers.json file.
>>> Current description is based on latest 2026-03 edition.
>>> The content of the generated files was compared against kernel
>>> linux/arch/arm64/tools/sysreg file. It is not straightforward
>>> to have unit tests for python scripts as there are many cases for
>>> field extraction.
>>>
>>> For each writable named field a uint64 property is created
>>> following the "SYSREG_<REG>_<FIELD>" naming convention. REG and
>>> FIELD names are those described in ARM ARM Reference manual.
>>>
>>> The list of SYSREG_ID properties can be retrieved through the qmp
>>> monitor using query-cpu-model-expansion [2].
>>>
>>> Connie & Eric
>>>
>>> This series can be found at:
>>> https://github.com/eauger/qemu/tree/arm-cpu-model-v5
>>>
>>> History:
>>> --------
>>>
>>> v4 -> v5:
>>> - generate target/arm/cpu-idregs.h.inc that look similar to
>>>    the format used in [RFC PATCH v1 02/13] target/arm:
>>>    named_cpu_model: Add ID Register Fields without the
>>>    description of the value values nor safe policy/value.
>>>    I guess valid values could be generated from the Registers.json
>>>    file too. Safe policy/values cannot.
>>>    I reused one patch from the above series.
>>>    Let's see how both series can progress/coexist without any
>>>    anticipated bias.
>>> - Addressed all comments from Shameer on v4
>>> - Addressed 2 comments from v4 that were missed including the
>>>    issue of IDreg visibility affected by some other settings.
>>>    Unfortunately I was not able to test it.
>>> - Further look at overrides between low level id reg field
>>>    properties versus legacy CPU options. I have the feeling they
>>>    can coexist as long as we document the hierarchy between them:
>>>    host kvm default -> ID reg field props -> legacy CPU options
>>> - Noticed more writable fields that are RES0/RAZ
>>> - Improved commit messages in general
>>>
>>> References:
>>> -----------
>>>
>>> [1]
>>> KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES
>>> KVM_ARM_GET_REG_WRITABLE_MASKS
>>> Documentation/virt/kvm/api.rst
>>>
>>> [2]
>>> qemu-system-aarch64 -qmp unix:/home/augere/TEST/QEMU/qmp-
>>> sock,server,nowait -M virt --enable-kvm -cpu custom
>>> sudo build/run qmp-shell /home/augere/TEST/QEMU/qmp-sock
>>> Welcome to the QMP low-level shell!
>>> Connected to QEMU 11.0.50
>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>>>
>>>
>>> Cornelia Huck (3):
>>>    target/arm/kvm: Introduce kvm_get_writable_id_regs
>>>    arm-qmp-cmds: introspection for ID register props
>>>    arm/cpu-features: document ID reg properties
>>>
>>> Eric Auger (14):
>>>    scripts: introduce scripts/update-aarch64-cpu-sysregs-header.py
>>>    target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
>>>    target/arm/cpu-sysregs.h.inc: Update with automatic generation
>>>    arm/cpu: Add infra to handle generated ID register definitions
>>>    scripts: Introduce scripts/aarch64_sysreg_helpers module
>>>    scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
>>>    target/arm/cpu-idregs.h.inc: generate with script
>>>    target/arm/cpu64: Retrieve writable ID reg map in
>>>      aarch64_host_initfn()
>>>    arm/kvm: Initialize all writable ID registers from host
>>>    arm/kvm: write back modified ID regs to KVM
>>>    target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
>>>    target/arm/kvm: Special case REVIDR_EL1 and AIDR_EL1
>>>    target/arm/kvm: Ignore some writable bits that shouldn't be
>>>    target/arm/cpu: Expose writable ID reg field properties on the kvm
>>>      host vcpu model
>>>
>>> Shaju Abraham (1):
>>>    target/arm/cpu_idregs: generate tables for Arm64 ID registers and
>>>      fields
>>>
>>>   docs/system/arm/cpu-features.rst              | 106 ++-
>>>   scripts/aarch64_sysreg_helpers.py             | 109 ++++
>>>   .../update-aarch64-cpu-sysreg-properties.py   | 168 +++++
>>>   scripts/update-aarch64-cpu-sysregs-header.py  |  51 ++
>>>   target/arm/arm-qmp-cmds.c                     |  19 +
>>>   target/arm/cpu-idregs.c                       |  50 ++
>>>   target/arm/cpu-idregs.h                       |  33 +
>>>   target/arm/cpu-idregs.h.inc                   | 617
>>> ++++++++++++++++++
>>>   target/arm/cpu-sysregs.h.inc                  |  57 +-
>>>   target/arm/cpu.h                              |   3 +
>>>   target/arm/cpu64.c                            |  14 +
>>>   target/arm/kvm-stub.c                         |   5 +
>>>   target/arm/kvm.c                              | 320 ++++++++-
>>>   target/arm/kvm_arm.h                          |  12 +
>>>   target/arm/meson.build                        |   1 +
>>>   target/arm/trace-events                       |   6 +
>>>   16 files changed, 1539 insertions(+), 32 deletions(-)
>>>   create mode 100644 scripts/aarch64_sysreg_helpers.py
>>>   create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
>>>   create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py
>>>   create mode 100644 target/arm/cpu-idregs.c
>>>   create mode 100644 target/arm/cpu-idregs.h
>>>   create mode 100644 target/arm/cpu-idregs.h.inc
>>>
>>
>> Thanks for the patch series. I tested it, and it works as expected.
>> After configuring the QEMU command, it was able to successfully migrate
>> on Hisilicon KunPeng HIP09 and HIP12 chips.
>>
>> Tested-by: Jinqian Yang <yangjinqian1@huawei.com> 
Thank you very much Jinqian for the testing. If it does not contain
anything confidential, could you paster the cmd line (restricted to the
SUSREG_* props) you used to tune your host vcpu model. This would
provide another example of usage for reviewers/maintainers?

Thank you in advance

Best Regards

Eric
>>
>> Thanks,
>> Shameer
>>
>
> Sorry, I forgot to update the salutation name at the end.
>
> Thanks,
> Jinqian
>

