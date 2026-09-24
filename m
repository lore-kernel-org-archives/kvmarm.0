Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE074399C4
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 07:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236338; cv=none; b=KLT6og+85CsbI5qzrUGmuscoVRfYvRlOUUOyqIKeUPuI9BEiv85vFHLPSqAjP6Xc8LKQABiL4Dw6AnUeCUddDTjgEv8hL3cj4DOAu3Uz7gEHUvUHxF0CwotE/dn2Ow7FqtBxPMC+RpTdV5MBJdMWRNuVxu1qhZp5HmyfmutJuPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236338; c=relaxed/simple;
	bh=7uqKKYSwbr4T0nTICxQZfS2g0ypmX+MIK3/MMuhJZI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YtyrerUnRg7gunTYbLr3QaMfZPjI1OsYdnsme8xw4N9NPXAICnlUiwnrXjQuq3ml65Qww7m766jHiWIQ1izb625KQwKtQQwQcuo6pkMKChAdZ0rvcRfwdRZft8354SzndMyYptxxiR7K3Oca7j4NvpxzDazl8JE5npTCs1B4C4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NA8GSlDe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NA8GSlDe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790236335;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DLO1msRp/2LG5/BpgvzBWAQdAT0K72y8KNtstRsiuMI=;
	b=NA8GSlDecXO+BTmR0Jx++hfHcB9kRWxWaHKxUBIteUt3wINSNN+RHwPEOfR5knmjbHB9Jn
	Ew+x6T7AfCdWlyoGj5DlsQBWlNUddLspNcG3TDJhPq8SXATCiY7g8ytFeBsPSzvTGPWJ/6
	M40rUxsWSWYmypezt1FTakA/LW28fKM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-IPwSu0F3NH-D-CalNA1VLA-1; Thu, 24 Sep 2026 03:52:14 -0400
X-MC-Unique: IPwSu0F3NH-D-CalNA1VLA-1
X-Mimecast-MFC-AGG-ID: IPwSu0F3NH-D-CalNA1VLA_1790236333
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e6ba4abdfso21176275e9.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 00:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236333; x=1790841133;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DLO1msRp/2LG5/BpgvzBWAQdAT0K72y8KNtstRsiuMI=;
        b=QK+sEGba0UmZKYUIugv7UytpBUDZb2IgnZKQ3JNtOM4AAgaARooP6Z8t+DyiHk0SnT
         IeZdEQaOlOOraSmQvyoWZ7xa/dd/3a5gkW6RVj1W5W6IaOtwbhSmgnpP+hCfHzjW+eXs
         x6FJgUvV8Kw2/+JR5nolTnTGPshTVd9Au/zvV50L1lhZIIvEj7Bk+5AXkY66c49k67KY
         CXeqOmgiggg1p3DJlmKn8CuXzHHd1yTnv8JZBtTtupSywRre5NWVGOGOph7dRBHIV+/U
         8xM/+Jp5QWkvZDjyAs+Pcfie0QYdfeszVXn2FCriZVPDbaSVTkCkCv3ntw7F0PR/pp9Y
         UrIg==
X-Forwarded-Encrypted: i=1; AKwUvBy9sqUYenT/QPT13wMWPvqOXuzUgRLHTTHrhVW0jXgOmapViUqfK8YZmxMuwBtIUucnHJ1LH7o=@lists.linux.dev
X-Gm-Message-State: AFuF++k8pIyiz6WEMd0RNq3ABl6Cs6qOhuu5+ifaORzanZjcJeLVC5Hv
	WlDw3bkadPWpJSv+hUDZjeCqDM++Af5c8grgHOXFFIOOyQRUm36IbyLBgze32LqIjAxV+i/P8V0
	HhAIt73mP8xNSLfAjhoCFN2us2O8aiqe/sOHZK8UfNiYPKW0lQOSinCmpItq1A8uncA==
X-Gm-Gg: AYBFou2nE3D90EDW5ZPtc+8504ckgIWi3y+T5RTtace8zc1WhHRR7YbnFfAOo15VO4U
	Q1/ciSKcSyK1QxUK3mKO3jxAr8ALhuVxaw2A9uatgA0kwxVS20Y8/nj5pd5FcAMAbLIl5CaCAfh
	CzCGGNn5OVAz31xlFNsSYgSo8q3tvviOiHzKcrTi9oJnivx0vatCb1w2IRuWdpCgwkxDocy7gw+
	k8WHYi73s1j0VJjhhIbmCJaBU0NiWW5lU1ix8FhZ5Ovqy4pmbRQiXlGg+ibDBnhA6IqtrVWeqf7
	/qMLOJqRQWbxhFQBI3S5gbAD/SjtK0NSylyzoTnmChDdJeowQz3ghCrvAMC36QQ5nUZEpD2Qtjp
	lgpPim+hhtkRjnP9WHykbAq5b5HeplEmvv0I22Kxi0ytoQBQT
X-Received: by 2002:a05:600c:4e55:b0:49f:bd3c:bc1a with SMTP id 5b1f17b1804b1-49fe66f506fmr24471875e9.21.1790236332850;
        Thu, 24 Sep 2026 00:52:12 -0700 (PDT)
X-Received: by 2002:a05:600c:4e55:b0:49f:bd3c:bc1a with SMTP id 5b1f17b1804b1-49fe66f506fmr24471365e9.21.1790236332485;
        Thu, 24 Sep 2026 00:52:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c5c41asm91577345e9.4.2026.09.24.00.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 00:52:11 -0700 (PDT)
Message-ID: <9f40a560-dccb-4c14-b6d0-2dfbd64badba@redhat.com>
Date: Thu, 24 Sep 2026 09:52:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 05/25] target/arm/kvm: read all ID registers from
 KVM
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
 <20260921123249.1708067-6-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-6-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uzMcZuOHcGyC49e2yrKNPO3wHOqaeZU6kEg2kenj_oA_1790236333
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Khushit,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> Try to read all ID registers from KVM. KVM may return ENOENT for
> registers that it does not support reading from userspace; ignore
> those registers. Some registers may still require special handling.
>
> This exposes a more complete host feature view to the management
> stack. For migration, both writable and non-writable ID registers
> must match.
>
> Add a tracepoint for ID register reads that fail with ENOENT.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/kvm.c        | 29 ++++++++++++++---------------
>  target/arm/trace-events |  1 +
>  2 files changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index f8d349a461..d9d0623a2a 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -330,12 +330,12 @@ static int kvm_feature_idx_to_idregs_idx(int kidx)
>  }
>  
>  /*
> - * get_host_cpu_idregs: Read all the writable ID reg host values
> + * get_host_cpu_idregs: Read all the ID reg host values
>   *
> - * Need to be called once the writable mask has been populated
> - * Note we may want to read all the known id regs but some of them are not
> - * writable and return an error, hence the choice of reading only those which
> - * are writable. Those are also readable!
> + * We currently try to read all the registers. If the read fails with
> + * ENOENT (KVM does not identify the ID register) ignore it.
> + * Some of the registers that errored with ENOENT will anyway need special
> + * handling.
>   */
>  static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
In the parent series I can add a parameter to select if we want only
writable id regs to be read or all id regs
>  {
> @@ -348,19 +348,18 @@ static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
>          uint64_t *reg;
>          int ret;
>  
> -        if (!sysregdesc->writable_mask) {
> -            continue;
> -        }
> -
>          reg = &ahcf->isar.idregs[i];
>          ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
> -        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
>          if (ret) {
> -            error_report("%s error reading value of host %s register (%m)",
> -                         __func__, sysregdesc->name);
> -
> -            err = ret;
> +            if (errno == ENOENT) {
> +                trace_get_host_cpu_idreg_not_found(sysregdesc->name);
> +            } else {
> +                error_report("%s error reading value of host %s register"
> +                            " (%m)", __func__, sysregdesc->name);
> +                err = ret;
> +            }
>          }
> +        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
>      }
>      return err;
>  }
> @@ -482,7 +481,7 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>          SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
>          err = 0;
>      } else {
> -        /* Make sure all writable ID reg values are initialized */
> +        /* Try to read all the ID registers */
>          err |= get_host_cpu_idregs(fd, ahcf);
>  
>          /*
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index bbf2e5dfa2..2bb7766f7f 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -14,6 +14,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>  # kvm.c
>  kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>  get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
> +get_host_cpu_idreg_not_found(const char *name) "host %s register not readable from KVM"
>  kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
>  kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
>  
Eric

