Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C64422E2E
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243858; cv=none; b=p3s8Cde0btVok10RvIu1GilvUqJrcpG6N7fS8H6cjoKqehGTw0MMSKUXCfHKEvmihZkDaMOCqlkyNLTlmujOHJQ5BTz9OMk8YtCeEiojKYn1FVeezaRntEZMk9R+RQMD0sgpBrGyL27bv4MBs0GXQbRvSULEZ0ZGeACAUcK5FoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243858; c=relaxed/simple;
	bh=i+XpXtZaI3xXSr8IERjYFqaGrG3Momb087jJOSf/WDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SA/swB4c1pvUByVPsFS502SGHy6c9Z9Xh6iJvbgOCzMlGNHRGGDlNn7V1bgMjkBbrC3Exam6wb22Y1i74h/S4nRR+IxYdByyZPT3roDr1l9d4hK7N9bVRSw9csbRC8QSaeGRXGS90e51CRDUTGOyO81r3yeYwTqaoKBIMHwzQqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nf/8oCnH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nf/8oCnH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790243842;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XPDUYn2sNH+tuYff9vyFITqIs0ucy3tacjD7MAHGCvo=;
	b=Nf/8oCnHeACcdpJoVKdN3mGN1ZKXNuwIPQsBzeoqIcEq3CQN1B6e392GLDYf/ROz2su6Fh
	QRWdIsHOT9aZG5fnCXQ3TDxbwFJWZ3F0R6VzBU//JI+8aVC3+/oM3qRf1e1E8CUc9ahJU3
	L/jsp8GETl9Xj1kaAnBq9VSx+gDsVmU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-Sk2sOInxN9a0OlGvmaO8yw-1; Thu, 24 Sep 2026 05:57:20 -0400
X-MC-Unique: Sk2sOInxN9a0OlGvmaO8yw-1
X-Mimecast-MFC-AGG-ID: Sk2sOInxN9a0OlGvmaO8yw_1790243839
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4843e59c32dso1490603f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 02:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790243839; x=1790848639;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPDUYn2sNH+tuYff9vyFITqIs0ucy3tacjD7MAHGCvo=;
        b=vdAmKXUNj8qgjzVvwxbNgjp3p23JEGTAz8DOyd04HtodxIP8LWjGdT4TtxMtvr3vQz
         jY42fH3eKoZM44dgUfjld2eShVy21B8puB5padJfCAjQfmFukiJx8t30M/tNQhEbJFKf
         /IA8Vr9wAUV8YNRU2PJE3c2ucA3qvK+A94smlJtTbAtCjchYxQgXjy24nSkCLAvcMWKH
         nfUg/4Rq0cKd18zHqGo9ZLaVYW5WhRLfdFucJ1J3J+PK5AZNg+KZ47i5rfrNQjSdqoM+
         CL2zX3dcQ8nGH/HXnDKNZ2Uql6/7L419gFomwe4tYXoe1aICSJTBDGNgRcBxRV3HVHm/
         kPig==
X-Forwarded-Encrypted: i=1; AKwUvBzfVxWA2Yf8cQ2rtHsMETt51fDDQLp3ceI1dq/2wwdMCjFZM2Jyt7TODV8/oZ8AEcQ2qO9ZHUM=@lists.linux.dev
X-Gm-Message-State: AFuF++leYmUynpX9v3yD5iaFBNjUB8ikJfjZnatnSWi4N14jemBSJbuT
	Oel3Y6VEwc6jgx3cAUGRZ7jq/FeeSjblT1Z4p/k+8kLlBEXSkPfvd1JX8venmZl8neVnFBMEdSI
	OJwwen4gSRjLe0J6pD6h2ZG/DRCaxt7zZQatL8O+3TZWhJ2BuOainWYi6WQ==
X-Gm-Gg: AYBFou1noibaLeRktIl1RLDPMCcCBia43mspD+rfee90hKyBKRa+euNAjXOl4QijgOo
	/rOBgV2bm1NXsk2WBIDFqZO01UMas68fvT7XuoWn6MEqsVGsdBSvD+kr2MW4cv5JMdKe1hGnqOl
	C7Wty1p5crvIn9DCvW5VRojnYO2utJ11aV97q08Mb3ofneaR5LLwUPUDgY8/IMUb7YqHAp2Mba3
	tCXKO+OprH1BEV8I+khwD1GlVdMgLa/AAH6KPu2SxwLw+vwXSBdAojJ9ufl+KxtfRiW9TI9IMXD
	YYZ8y0yPCl2/Ex+3r60KmsDT5Eq0gE10DkjdvTv+/Q35ePji0veezYn6BiLioUiaXw/0PpvA/it
	z812G9blgEEcavX50Tihyw2bfQAbYyiSraBZG0wJjh9w8UKLf
X-Received: by 2002:a05:6000:2913:b0:488:6078:8aef with SMTP id ffacd0b85a97d-48871725c5fmr3067136f8f.20.1790243839448;
        Thu, 24 Sep 2026 02:57:19 -0700 (PDT)
X-Received: by 2002:a05:6000:2913:b0:488:6078:8aef with SMTP id ffacd0b85a97d-48871725c5fmr3067097f8f.20.1790243838957;
        Thu, 24 Sep 2026 02:57:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48868889337sm13769957f8f.34.2026.09.24.02.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 02:57:18 -0700 (PDT)
Message-ID: <aabcb61b-8341-423f-b113-e7ab2b34c2ac@redhat.com>
Date: Thu, 24 Sep 2026 11:57:16 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 08/25] target/arm/kvm: handle writeback for special
 ID register fields
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 ping@khushitshah.com, sandesh.patel@nutanix.com
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-9-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-9-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NRBAOByuUiCVkvid0lEDcIZWM413IOu7eFEhh8Od47I_1790243839
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/21/26 2:32 PM, Khushit Shah wrote:
> Some fields should not be written back to KVM for various reasons:
>  - ID_AA64PFR0_EL1.GIC / ID_PFR1_EL1.GIC are fabricated by KVM based on
>    the gic-version property.
>  - KVM does not allow writing 0 to ID_DFR0_EL1.CopDbg, which breaks
>    booting an AArch64-only guest on a host that also supports AArch32.
>  - ID_DFR0_EL1.PerfMon is populated by KVM even for AArch64-only guests
>    but is not writable there.
>  - MPIDR_EL1 is managed by KVM based on vCPU index.
>  - Hold off writing back CLIDR_EL1 until we properly support exposing
>    cache topology to a KVM guest.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/cpu-idregs.c |  6 ++++++
>  target/arm/cpu-idregs.h |  2 ++
>  target/arm/kvm.c        | 40 +++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 47 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
> index d58b8ed063..1f7ebfe9bb 100644
> --- a/target/arm/cpu-idregs.c
> +++ b/target/arm/cpu-idregs.c
> @@ -107,3 +107,9 @@ bool arm_field_is_writable(const ARM64SysRegField *field)
>      return (arm64_id_regs[field->index].writable_mask & field_mask)
>             == field_mask;
>  }
> +
> +bool field_matches(const ARM64SysRegField *field, ARMIDRegisterIdx index,
> +                   const char *name)
> +{
> +    return field->index == index && !strcmp(field->name, name);
> +}
> diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
> index aab1a79db1..8ef3f9350e 100644
> --- a/target/arm/cpu-idregs.h
> +++ b/target/arm/cpu-idregs.h
> @@ -35,4 +35,6 @@ extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
>  
>  uint64_t arm_get_field_mask(const ARM64SysRegField *field);
>  bool arm_field_is_writable(const ARM64SysRegField *field);
> +bool field_matches(const ARM64SysRegField *field, ARMIDRegisterIdx index,
> +                   const char *name);
>  #endif
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 2d94b3a884..70d9a07580 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1317,10 +1317,40 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
>      return true;
>  }
>  
> +static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
> +{
> +    /*
> +     * GIC is controlled by the gic-version property and fabricated by KVM
> +     * when the vGIC device is created, so a named CPU model must not touch
> +     * it. KVM also rejects writing 0 to ID_DFR0_EL1.CopDbg, which breaks
> +     * booting a model that lacks AArch32 support on a host that supports
> +     * it. MPIDR_EL1 is managed by KVM based on vCPU index, skip writing it
> +     * back. Similarly, skip writing back CLIDR_EL1 till we properly
> +     * support exposing cache for KVM guest.
> +     */
> +    return field_matches(field, ID_AA64PFR0_EL1_IDX, "GIC")
> +        || field_matches(field, ID_PFR1_EL1_IDX, "GIC")
> +        || field_matches(field, ID_DFR0_EL1_IDX, "CopDbg")
> +        || field->index == MPIDR_EL1_IDX
> +        || field->index == CLIDR_EL1_IDX;

what does happen for SMIDR_EL1 and GMID_EL1 whose value could not be
initialized from host. The setter for any of their field shall fail.
> +}
> +
> +static bool
> +arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field)
> +{
> +    /*
> +     * KVM populates ID_DFR0_EL1.PerfMon even for AArch64-only guests but
> +     * does not expose it as writable there, so skip it when it is not
> +     * writable.
> +     */
> +    return field_matches(field, ID_DFR0_EL1_IDX, "PerfMon");
> +}
> +
>  /*
>   * Copy writable ID reg fields from isar.idregs[] into the KVM cpreg list,
>   * so the subsequent write_list_to_kvmstate() pushes them to KVM.
> - * Only writable fields are copied.
> + * Only writable fields are copied; fields that must not be written back
> + * (see arm_field_skip_writeback_*) are skipped.
>   * Returns -1 if any vCPU's ID reg value differs from the host value and the
>   * field is not writable.
>   */
> @@ -1357,6 +1387,14 @@ static int kvm_arm_write_idregs_to_cpreg_list(ARMCPU *cpu)
>                  continue;
>              }
>  
> +            if (arm_field_skip_writeback_always(field) ||
> +                (!arm_field_is_writable(field) &&
> +                 arm_field_skip_writeback_if_not_writable(field))) {
> +                /* Never write this field back; keep KVM's value. */
> +                writable_mask &= ~field_mask;
> +                continue;
> +            }
> +
>              if (!arm_field_is_writable(field)) {
>                  error_report("%s.%s is not writable: host=0x%" PRIx64
>                               ", requested=0x%" PRIx64,
v9 has changed the way new field values are stored. writable field props
and non writable field props could have different setters. A non
writable field setter just needs to check the new value is the same as
the current host value. No need to record the new value in the hashtable
for further commitment.

Eric

