Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1B3497B96
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069298; cv=none; b=a/ezutElaROHEu7VjxbdgGmOf4mfHq6Ccdpgu0WmD6YCUb6P+mDCd4dVcwRUVnBkjfVvTZEMXmY4yE2DfncI8ns9Pdb6GVZw+QgR3mJx89YcLSV94CkdLtFDW8zBU+EZElUElWf79tJK/tHAxg6OjkveTl99Xgph0KBaJm0MQf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069298; c=relaxed/simple;
	bh=GSRCyukxtIpsyvGi8QnhchVSEkvmjduTCgZI5ZuS48g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GHReFvYDvJiTGx3xLoUNZp7w21i9Zmf4O6uiqQnT0PDME+cGzBts4Vc04XBdHMIJqbo8pdzsgaokE3tUgHhp451KcuS1XW01ZQ63m/NwdEn6NhSZormfkUUShctoREBvAsmcX4kIaD6m3NIog8s79TN5Cs3vpuCB7zmRMO/1BGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4lYJfFc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4lYJfFc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792069296;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YktKNEMcPDogZ6g30J7csBDy/fG8Te7xH2b46prd+6M=;
	b=F4lYJfFcXpISsssaEgQDJZRUNqHVqRJj94MHxKUo2oEbo7+JGLIYRRs6qwwnQiSs9RGtJX
	dIkObKxEJbiW2UDM9vLfMDzPp/yjnK73nrBQugznFJj8B4NYzb1U+udozk221+RA7Zblf5
	FyZl85ZkKCedQdBGwXxj0BzJ1kWy7f4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-niVoIj3kNR-QDxoMxkKRSA-1; Thu, 15 Oct 2026 13:01:35 +0000
X-MC-Unique: niVoIj3kNR-QDxoMxkKRSA-1
X-Mimecast-MFC-AGG-ID: niVoIj3kNR-QDxoMxkKRSA_1792069294
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48df730c035so380826f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 06:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792069294; x=1792674094;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YktKNEMcPDogZ6g30J7csBDy/fG8Te7xH2b46prd+6M=;
        b=EZOy+hw/NGK0hyz/vNTeeas614gk9dvUu6Q0ZeqXvgOuQ+35tWBpdbcbY+y6CCXVpo
         pVX8j63DEMnS9xeaWsaSEGn02GCN1b/8JCxKuqH9KScCR3q3swE6caklZBDmpjWVBWZ8
         tU50tqCzAfbPi7pWPVSBzgAO8VakjG5a9mQp4g3kGl388owtQpB3VKBNjpD4YA9WGQJX
         ZOLRHRnqywUk990rXUQxMNFFvWdxOC5oPIJmHdqcWm/cs3iJsMUks50cwTeHXxW5kusK
         +/SuOKlmqMBwxUYGI8FGohRUba094ZvoYMw1+7rw++7dOMkiucX9Q/0w498cPNsk96O8
         J8mQ==
X-Forwarded-Encrypted: i=1; AKwUvBwKg7/gOVS9582l6m9dMEvXjQuRwUL+hIY13jTSrHeyVgnA5wBJAhsFQKwZ6wDchTX4LVYl8Gw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLD28Ze8PO1tg0RSdSMxuHxT0znqgwDMCkROAnMtfWSf65jxYEm
	6ztwVuMsGmt6lX3BBjfm2YKX5dqyAJppGTh8RDLFTqR7oFgt+RG0jsZy+POScPyRrbkwyNNT3Fq
	wJtrbvUyr0EF3ytM3z/78IPysmaafivmLQdgUbNlN5hmOhBr4tFle3jt20g==
X-Gm-Gg: AYBFou1AJ0kGQIsGmk0J3cPUp6DYiiV8vMb5N6gKWhT3sdOkE9N9Lbd57hzY0GuTeaE
	Qn82WMz7btj9Vj6NqBpxXUG+McWLKW0hPeSPqqrdhhw4GpIG5+tUTVxKWe8ULmdkRMoIjnAik8Y
	VrkEwrrpgH7KXB8Xv6rRO3WdSBgOqHUFNAROO4bUb2YEBAnPpFN3WPGrWB1f503rV1cEtF+Uruh
	lJwozA2Z/VByiJAvV3GRb2TjVoiMRczMfXJ6SjvfcjCG2zn+zFqzd85GBMrGM0s9/WDZqbOmd/Z
	aSZoun0T6y+ZS1G9AACYfuLksk5O+uslx4+Zv36lAIoZR+4wGpQ6v4s3nxEGWnfLWTCS1sujrRD
	ZrT3g91Rd1rdHpbvdtKGEmCLHQ5aGPkfGwQscnbuPl4grS6L2
X-Received: by 2002:a05:600c:6384:b0:4a1:7741:ec43 with SMTP id 5b1f17b1804b1-4a18e4b8966mr356115335e9.26.1792069292179;
        Thu, 15 Oct 2026 06:01:32 -0700 (PDT)
X-Received: by 2002:a05:600c:6384:b0:4a1:7741:ec43 with SMTP id 5b1f17b1804b1-4a18e4b8966mr356114555e9.26.1792069291618;
        Thu, 15 Oct 2026 06:01:31 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd640be0sm53714835e9.1.2026.10.15.06.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 06:01:29 -0700 (PDT)
Message-ID: <4ea14973-ac46-497c-80f6-499487f733cc@redhat.com>
Date: Thu, 15 Oct 2026 15:01:27 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 10/25] target/arm: fix SVE and PAuth finalize for
 named CPU models
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
 <20260921123249.1708067-11-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-11-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yWXOH1n0aW11iwRrf0Gm9J1Oc2jJjZORKmccI3MWW7o_1792069294
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> As named CPU models define their feature set explicitly, their SVE
> vector lengths and PAuth fields must not be derived from the host.
>
> When SVE is enabled without an sve<N> setting, require the named model
> to specify its supported vector lengths rather than inheriting them from
> the host.
>
> Named models set PAuth ID register fields directly through SYSREG_
> properties. Preserve these values in PAuth finalization.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/cpu64.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 7487b48cc9..a0114b0fa2 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -38,6 +38,7 @@
>  #include "internals.h"
>  #include "cpu-features.h"
>  #include "cpu-idregs.h"
> +#include "cpu-models.h"
>  #include "trace.h"
>  
>  /* convert between <register>_IDX and SYS_<register> */
> @@ -134,6 +135,21 @@ void aarch64_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
>              return;
>          }
>  
> +#ifndef CONFIG_USER_ONLY
I don't get why do you need that #ifndef? 
> +        /*
> +         * If SVE is enabled but no vector lengths are specified, we must not
> +         * default to the host's supported lengths for named CPU models.
> +         */
> +        {
> +            ARMCPUClass *acc = ARM_CPU_GET_CLASS(cpu);
> +            if (acc->info && arm_find_model(acc->info->name)) {
> +                error_setg(errp,
> +                           "Named CPU models with SVE must set vector lengths");
> +                return;
> +            }
> +        }
> +#endif
> +
>          if (kvm_enabled()) {
>              /* Disabling a supported length disables all larger lengths. */
>              tmp = vq_init & vq_supported;
> @@ -556,6 +572,23 @@ void aarch64_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
>      ARMISARegisters *isar = &cpu->isar;
>      uint64_t isar1, isar2;
>  
> +#ifndef CONFIG_USER_ONLY
> +    /*
> +     * For named CPU models the model props write the authoritative
> +     * APA/API/APA3/GPA/GPI/GPA3 values directly into cpu->isar through
all those fields ar not KVM writable currently.

> +     * SYSREG_ properties, so do not override them here. Since other code
> +     * relies on cpu->prop_pauth, mirror the resulting pauth state into
> +     * cpu->prop_pauth.
> +     */
> +    {
> +        ARMCPUClass *acc = ARM_CPU_GET_CLASS(cpu);
> +        if (acc->info && arm_find_model(acc->info->name)) {
> +            cpu->prop_pauth = cpu_isar_feature(aa64_pauth, cpu);
> +            return;
> +        }
> +    }
> +#endif
If I understand correctly all the isar1/isar2 manipulations afterwards
only affect TCG. 
In KVM mode, although isar1/isar2 fields are reset afterwards this does
not impact the guest view so most probably the isa1/2 reset + finale
update could be moved to the !hw_accel block and you put that addition
in the hwaccel_enabled() block, or am i wrong?

Thanks

Eric
> +
>      /*
>       * These properties enable or disable Pauth as a whole, or change
>       * the pauth algorithm, but do not change the set of features that

