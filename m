Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF48387361
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781275866; cv=none; b=hzzk///dfuUPFE28IFJh/drWDvjGvxYPvADpnpOfibTxsRZKta70uCOl04ZLU3rekyrN0+IWWIhPtZDXeTipqLY1pK171IFkPOrgnsUqEXEIFjDyI/ODy9m0R8AWRJqUWXM8jzoN2VraoIuApUxR37ppe23jYydybys8g7jWpsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781275866; c=relaxed/simple;
	bh=6MkgMspqS/w9/Pd3JqCGymCYJ0WdeHEemrM/BqvvB04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JXxJbA1hMKr8+Uc7/yJyHiFj3ANuoIg0nyfZGyLrf//rE02/B/0ehndfXEFpvoTZvmM0c1hMwkDo3sD119cIf8NJdmrCX8Vd8/hb91M632A8CWgu9rIwMjhgKq4EOuwtHhVrS1Owxf/tgnghOM5XADmKH9baegLnpjKMZR1TnaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YXlNw3ep; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXlNw3ep"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781275861;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1jqjLk29+ylgKafy2vZZGpLUZYRXAPBweaq2/Vw0ZvI=;
	b=YXlNw3epOVPfo7Kv4nCiKWsUTJUdHNuDPcf9G1M0XS1DelgYyKvCbknPr7WCmuL3NUULnz
	UwZYLcev0O46xJ987USQh9Gi9hyWZBVKhO2rQC160RAjCwkwOgxNWhmacZjkVQZSe8PISe
	algtF3Lnn/PAkPS1dWLBD21rzPuFNpc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-4K-EHhyiPZW2716C3GsEAA-1; Fri, 12 Jun 2026 10:51:00 -0400
X-MC-Unique: 4K-EHhyiPZW2716C3GsEAA-1
X-Mimecast-MFC-AGG-ID: 4K-EHhyiPZW2716C3GsEAA_1781275859
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-46016bedbaaso761114f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781275859; x=1781880659;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jqjLk29+ylgKafy2vZZGpLUZYRXAPBweaq2/Vw0ZvI=;
        b=qPvimt7s205DJKoZbSiyskyFqoCM6TwC/1eewK8wY5ojx88pORvJVu1mCMxzIw0xQK
         hzqV0Bv3IxwCVh2pkvzeRw0s0RuMDdJvGGFzbce2Iy+oCmVZ9qwUnJTbzRtpP/rMWR+3
         KCpB+E9p4caSe2mAAA6qUWFnyliiQI+HIozkR7fEV6ck9bbxhQRfoi8HIZUHCrAcfUR9
         WYZrEJxVLTgsdeJnGac7aR12YwOpXs/CtKWqU2MfCk1fBbQLrWiKKXT5+6ifvowm56/I
         ZRrVaUw96+dO2ka+Ykk1r5d7/JWYrp/rR8m/LP/ThwqHDsGcXvNzdqDQOW4qzsUqpqtw
         bzxA==
X-Forwarded-Encrypted: i=1; AFNElJ/pi5Hr89Aet5VXtb9RCLatXE0/gTOeCLpV1Zj+CQU5z24qblzl9SHV5gA9hkJGPv4GQLvFCwQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxm1Wblcw7MqBrGu0DJTZl8O5C891LQSuGXomlJNrAbvmmTmkv/
	7W3DN+zR2gYCz9WcAdrcmDv55EOH7cv69R6VV5ODUgrkhOKwbbp18YeHKnePiXHy5nVV7o7+kzj
	jf4fZJ+gR4G+VpQfIQRCAkOtjodbWA9bxm60xhJP8eSBwvxteYC8eEL35Qw==
X-Gm-Gg: Acq92OEt57D0Z7oLrb2HmXPHl4edRX25pco0SbueHLAmMtN9EIAoedTinGNE4F3g2Ob
	s/8z/lSE3Wfr4Bx7b4aXo6ADQc+Ss+gzPSvfS8N+MRcijrjlsdul+73D+x80JRytSVwTMAeyCxc
	VNFf7Wn5EXkNEf4PFrZ2Tm7O2CHRXGya7ImfF7Kc6gV87y77+/VatF3q9uq/ZOnEz9CBOq3OGSf
	zoXR/YrRSKD26i2jDkjNRU51ROFTcPGmxUGie376I9lygQtV3wY6kwh7UmlPRM/P6bEzH2X0bxD
	Nj7onFei5Tz/kodtkRBZx2Phx47b33qsAOE3BQNPhw1GS0cdILW5ncIGRX2syUf8Wqr8kWN0oaM
	Rv44fAaQVH1aRvm4SWQc3kdI8naUulZ5lKleAkGdE8dleBrfK31FbiP+or2UIBH+LzqntTA==
X-Received: by 2002:a05:600c:a0d:b0:48e:6db3:ff3a with SMTP id 5b1f17b1804b1-490ec4e6ddfmr42693785e9.16.1781275858766;
        Fri, 12 Jun 2026 07:50:58 -0700 (PDT)
X-Received: by 2002:a05:600c:a0d:b0:48e:6db3:ff3a with SMTP id 5b1f17b1804b1-490ec4e6ddfmr42693115e9.16.1781275858250;
        Fri, 12 Jun 2026 07:50:58 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4921eeb69d7sm2668905e9.15.2026.06.12.07.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 07:50:57 -0700 (PDT)
Message-ID: <eb5f98a0-1fc4-4a5a-839f-8bc3afc44165@redhat.com>
Date: Fri, 12 Jun 2026 16:50:55 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v2 00/29] target/arm: Named CPU models for Arm64 on
 KVM
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: Cornelia Huck <cohuck@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Andrea Bolognani <abologna@redhat.com>, Jiri Denemark <jdenemar@redhat.com>,
 Gavin Shan <gshan@redhat.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
 Sebastian Ott <sebott@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Jinqian Yang <yangjinqian1@huawei.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260605083358.1320563-1-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4U96NnPRPUmVy7xWMcnWW8basK6zwWuOpCbfwBo2VjI_1781275859
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Khushit,

On 6/5/26 10:33 AM, Khushit Shah wrote:
> Hi All,
>
> This is the v2 RFC of the Named CPU models support for Arm64 in QEMU.
> v2 implements all of Planned items that were mentioned in v1.
> v1 link: https://lore.kernel.org/qemu-arm/20260513163356.3033159-1-shaju.abraham@nutanix.com/

Please could you share a branch. This fails to apply on mainline due to
recent changes

Thanks

Eric
>
> Background:
> =============================================================
> Currently QEMU only support -cpu host/max for KVM on Arm64. This disables
> live migration of VMs between hosts that differ in CPU features.
>
> This RFC proposes hierarchical named models for Arm64 under KVM, this
> provides strict contract of CPU features that will be exposed to the guest
> for a given named model. Models can be customized further with feature
> properties (like feat_AES=off, pauth=on, sve=off, etc...). 
>
> The design has three layers: an ARM ID-register field table (single
> source of truth for fields, safe-rules, defaults, arch-defined values); a
> property layer on top (single-field, fractional, and composite properties);
> and a hierarchical named-model layer that picks values for those properties
> with parent-chain inheritance.
>
> The series also implements QMP commands that lets the management layer query
> which models a host can run, what each model resolves to, and which feature
> values the host supports.
>
> Relationship with "customizable host model" series:
> ============================================================
> This RFC overlaps with customizable host model series [1]. The two series
> solve different parts of the same problem: [1] provides the lower layer
> (per-field SYSREG_<REG>_<FIELD> u64 properties on -cpu host,
> writable-mask probing, ID-register writeback).
>
> This series adds the layers above that, like:
> hierarchical named CPU models, default-from-zero baselines, fractional and
> composite properties for named models (sve, pauth, expose-cache),
> property/value names, and QMP introspection (blockers via safe-rule
> validation, supported values, new query-arm-cpu-props-info). This series
> also fixes the host-supports-Nested-Virtualziation-while-qemu-booted-without-it
> writeback case [2] that surfaces once [1]'s writeback lands.
>
> Long term plan is to rebase this series on top of [1]. Few difficulties
> in that will be augmenting the ID regs fields table with safe rules and
> default values, which Eric correctly mentioned in [1] that it cannot
> be inferred from Registers.json.
>
> For property names and values we have no strong preference,
> <SYSREG>_<REG>_<FIELD> with uint64 values or "feat_*" properties with
> string values (SYSREG_ID_AA64ISAR0_AES=2/feat_AES="pmull").
>
> [1]: https://lore.kernel.org/qemu-arm/20260519132905.145643-1-eric.auger@redhat.com/
> [2]: See patch 29 of this series.
>
> TL;DR examples:
>   # Boot with Grace
>   qemu-system-aarch64 -cpu grace-v1 -machine virt,accel=kvm ...
>
>   # Grace with a feature disabled
>   qemu-system-aarch64 -cpu grace-v1,feat_SHA1=off ...
>
>   # Host passthrough with individual feature control
>   qemu-system-aarch64 -cpu host,feat_AES=aes ...
>
>   # named CPU model with composite properties
>   qemu-system-aarch64 -cpu grace-v1,pauth=off,sve=on ...
>
>   # QMP -cpu host query-cpu-model-expansion:
>         "model": {
>             "name": "host",
>             "props": {
>                 "cpu_partnum": 3407,
>                 "feat_SM4": "on",
>                 "feat_SM3": "on",
>                 ....
>             }
>         }
>
>     # QMP -cpu graviton3-v1 query-cpu-model-expansion:
>         "model": {
>             "name": "graviton3-v1",
>             "props": {
>                 "cpu_partnum": 3392,
>                 "feat_SM4": "on",
>                 "feat_SM3": "on",
>                 "feat_RNDR": "on",
>                 ....
>             }
>         }
>
>     # QMP query-cpu-definitions (on Grace host) (blockers for graviton3-v1):
>         {
>             "name": "grace-v1",
>             "typename": "grace-v1-arm-cpu",
>             "static": false,
>             "deprecated": false
>         },
>         {
>             "name": "graviton3-v1",
>             "typename": "graviton3-v1-arm-cpu",
>             "unavailable-features": [
>                 "hw_prop_TGRAN4_2",
>                 "hw_prop_TGRAN64_2",
>                 "hw_prop_TGRAN16_2",
>                 "hw_prop_APA",
>                 "feat_RNDR"
>             ],
>             "static": false,
>             "deprecated": false
>         },
>         ....
>
>     # new QMP query-arm-cpu-props-info (on Grace host):
>         {
>             "name": "feat_SHA1",
>             "type": "boolean",
>             "supported-values": [
>                 "on",
>                 "off"
>             ]
>         },
>         {
>             "name": "feat_AES",
>             "type": "string",
>             "supported-values": [
>                 "off",
>                 "aes",
>                 "pmull"
>             ]
>         },
>         ....
>
> Changes since v1:
>   - Added `query-cpu-definitions` and `query-cpu-model-expansion` QMP
>     support for named models and accompanying properties.
>   - Introduced `query-arm-cpu-props-info` QMP command that returns
>     list of all newly supported properties for -cpu host, and its supported
>     values.
>   - Add composite properties for named models which acts as master "on"/"off"
>     switches for features that compose of broader range of ID registers
>     fields like pauth and sve.
>   - Added `expose-cache` composite with other cache related properties to
>     allow named models to expose cache information to the guest.
>   - Cache the host isar view with and without EL2 support, and make
>     -cpu host with writeback work on host kernel that supports
>     virtualization.
>   - Validate the cpu->isar.idregs before writing back to KVM to catch early
>     errors.
>   - Properties and models are now defined in file rather than using .h.inc 
>     files.
>
> Tested on NVIDIA Grace and AWS Graviton3 hosts (6.18); booted grace-v1,
> graviton3-v1, neoverse-v2-v1, neoverse-v1-v1, and -cpu host with per-feature
> overrides.
>
> Plans for v3:
>   - Some documentation and unit tests.
>   - More properties based on what more the latest kernel supports.
>   - pmu composite property.
>   - Trying to rebase on top of [1].
>   - Splitting this huge series into 3-4 sub series.
>
> Warm Regards,
> Khushit, Shaju
>
> Khushit Shah (20):
>   target/arm: Introduce data-structures for the ARM property layer
>   target/arm: Add all ARM64 properties to host model
>   target/arm: Add Nvidia Grace named model
>   target/arm/kvm: enable writable implementation ID registers
>   target/aarm: Validate cpu->isar.idregs[] before writeback
>   target/arm/kvm: handle DCZID_EL0 specially
>   target/arm: skip GIC, COPDBG and PMU fields during KVM writeback
>   target/arm: Add composite property type to model definitions
>   target/arm: define pauth composite property
>   target/arm: define sve composite property
>   target/arm: Introduce stub files required for qmp support
>   target/arm/qmp: add named models and properties to cpu-model-expansion
>   target/arm/kvm: introduce kvm_arm_get_host_isar helper
>   target/arm/qmp: add query-arm-cpu-props-info
>   target/arm: Report "off" for ID fields gated by vCPU init flags
>   target/arm/qmp: hook blockers in query-cpu-definitions
>   target/arm: Support exposing cache information for named cpu models
>   target/arm: Provide default cache hierarchy
>   target/arm: supported-values and blockers for CCSIDR cache properties
>   target/arm/kvm: fix host model writeback when kernel supports EL2
>
> Shaju Abraham (9):
>   target/arm: named_cpu_model: define containers for ID registers and
>     fields
>   target/arm: Add ID Register field descriptions in cpu-idregs.h.inc
>   target/arm: Add MIDR, REVIDR, AIDR and extra ID regs to cpu-sysregs
>   target/arm: Generate ARM64 ID registers and field tables
>   target/arm: Replace FIELD() macros with IDREG_FIELD expansion
>   target/arm: Define ARM properties
>   target/arm: Add ID register field helper functions
>   target/arm: Add named cpu model infra + graviton3 named model
>   target/arm/kvm: Writeback modified ID registers to KVM
>
>  hw/arm/virt.c                    |   28 +-
>  qapi/misc-arm.json               |   41 +
>  stubs/qmp-arm-gic.c              |    6 +
>  target/arm/arm-cpu-models-stub.c |   18 +
>  target/arm/arm-cpu-models.c      |  620 ++++++++++
>  target/arm/arm-cpu-models.h      |   49 +
>  target/arm/arm-cpu-props-stub.c  |   36 +
>  target/arm/arm-cpu-props.c       | 1212 +++++++++++++++++++
>  target/arm/arm-cpu-props.h       |   70 ++
>  target/arm/arm-qmp-cmds.c        |  128 +-
>  target/arm/cpu-features.h        |  246 +---
>  target/arm/cpu-idregs.c          |  508 ++++++++
>  target/arm/cpu-idregs.h          |  119 ++
>  target/arm/cpu-idregs.h.inc      | 1898 ++++++++++++++++++++++++++++++
>  target/arm/cpu-sysregs.h.inc     |    5 +
>  target/arm/cpu.h                 |    3 +
>  target/arm/cpu64.c               |   31 +-
>  target/arm/kvm-stub.c            |    7 +-
>  target/arm/kvm.c                 |  356 +++++-
>  target/arm/kvm_arm.h             |    7 +-
>  target/arm/meson.build           |   11 +-
>  target/arm/trace-events          |    1 +
>  22 files changed, 5148 insertions(+), 252 deletions(-)
>  create mode 100644 target/arm/arm-cpu-models-stub.c
>  create mode 100644 target/arm/arm-cpu-models.c
>  create mode 100644 target/arm/arm-cpu-models.h
>  create mode 100644 target/arm/arm-cpu-props-stub.c
>  create mode 100644 target/arm/arm-cpu-props.c
>  create mode 100644 target/arm/arm-cpu-props.h
>  create mode 100644 target/arm/cpu-idregs.c
>  create mode 100644 target/arm/cpu-idregs.h
>  create mode 100644 target/arm/cpu-idregs.h.inc
>

