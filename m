Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C608B31B114
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 06:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784703285; cv=none; b=fJqPLUO738c2OmYPXj4XPp4rKCKpuGubtTB/NXRJwe70rOTS70MtVwU+CX6AMjk38m4DRcG9uAFJRYOIzA0xgRyw1p4LPmGx/2Q6gL00GJwz451pszn5BoUFkP0T6gMg6O4+FZalnFyFIfTKoDbDSbLQ00V9YY1P+rC3bMfS2W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784703285; c=relaxed/simple;
	bh=u4XdjN3t6BMT59858ZDHWyxUKE7qJyzRcdB1thNEKcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sPHRFfpEwKELt6Jf4mqU7Tj+ZKw+gUvC7O1WdR6LCOe2YITQpnTJCJqTD67vywaNrOkBrbTMCdr8+9K+Wie3yoAbF1fC3RVoN7zUtBedlLtdZLjOg3Ka37CRE6AwHeSEOdIke3fi9mQxA5NH3wZdXAgFbTHnFer3J2hIgwDhIEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aQPQlp5c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aQPQlp5c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784703282;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9qS3+jlyeK15KPAYimukyJlTAprsGF+GK/BODQqMPw=;
	b=aQPQlp5cT4ueNm+cH8O7ya9rOCQLvQuVW5RBj1Ud73gF8FGaWJSpstfxEBLFq21jwiKxnf
	04FD0rzCY7HxmUSPvq0rIjLiNpGf9YwnOaxIkEobv9Sj9/vMrKFV/q7iaydiamA68H7Wzo
	lMmZsI4+r10wbskmBl9afX6zWhkjLUc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-CEry3XPxO2SVY2_Pm0k-GQ-1; Wed, 22 Jul 2026 02:54:39 -0400
X-MC-Unique: CEry3XPxO2SVY2_Pm0k-GQ-1
X-Mimecast-MFC-AGG-ID: CEry3XPxO2SVY2_Pm0k-GQ_1784703278
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f753a0aa0so2008973f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 23:54:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784703278; x=1785308078;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F9qS3+jlyeK15KPAYimukyJlTAprsGF+GK/BODQqMPw=;
        b=XVRC2sXb6JC+SMTxjYjtgYaZa95WsCOZ3LPlzTA9hbSCQDfMMIhGRInPBPLB0xj6R6
         2PL78pAaW23iCTDQ8W00hsUlu7mxngKBVZJk0bBakkHviY7uoS5qqDB0VZNbQ0c7Mvpt
         uhcyRS3D7qqx+U8vVUlB70prd6JjPn70/ibyifj4SVqmGFh5xHYAakuAcb4WNr8QaDlt
         TIJXx9LU7zsLjTKM58nrncXdvhmfiFJoIEXqKKIg3Fo57zadQ//VSdLDOLk6p8C9aAfy
         /B4VmD2KZlGu0k9AtxF+FGGVqYCQ8vs7iW3YJxUkNtmMJ/ROsJCJzPC++oOFYzav3Wuy
         uXkg==
X-Forwarded-Encrypted: i=1; AHgh+Ro5pS95YpQ519DcHJlNtYlk2ROEL0udptT/B63T98sOHBB8nKF1RZudMRDdSCHbXQ/3rF3abgs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZy9yyWvvIRmQkuslwZsQQ57WLX2M3cNsCd64r7LTY6FdxLCYJ
	g09RPbaDdf1KHGRzPeEPtSjOAloUr6sYcIRLtuQ6UVRKUtnI3VSP/dWDsQYYz5AbaQAZhLeEkJQ
	2UxVTakGoqR37KI4R8eNrB8fQN1s7mQwasSXvjFF/lDexVY+4EVoR4yoRag==
X-Gm-Gg: AR+sD12ydulLV1tzSBGeckK+djZbJsN29puiTkZ6WfRnXACnGRYM4ljncuHpeborrWv
	1Lmem3awGUMgtQMQbcsTPvbN5jOv/oEmZYFVWwo1pFbBba+Ee9GGdymjp8jk/NmnBCPjisI7fy6
	roTume/kDwFWjlwBMI3699BbZY2/tfr52OIAUd+5YpKMNtDsLH3mytYocI70VBgyS65n7EeM4sj
	ZztnTtiqOKOp9WaryPivltSMbl5R/uouvmwq1aEAspegYEaLuyLIp2g0NDAckuIMu3O/XecE/2j
	gqUnIClv3uaFINeuedL/Ek0xtc6nY7kdtaRvIky8AUTymZzfJ2DPrusyYcKie21OIfWaf/xJ81+
	0/7W3ZiuydxZLZmU3RCPs+JUbrutKGOhimyE/CJSBwDunfonW
X-Received: by 2002:a5d:5d82:0:b0:47e:9f16:c0bf with SMTP id ffacd0b85a97d-47f62326f0bmr26201945f8f.30.1784703278342;
        Tue, 21 Jul 2026 23:54:38 -0700 (PDT)
X-Received: by 2002:a5d:5d82:0:b0:47e:9f16:c0bf with SMTP id ffacd0b85a97d-47f62326f0bmr26201912f8f.30.1784703277935;
        Tue, 21 Jul 2026 23:54:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c6e9a2sm3227267f8f.35.2026.07.21.23.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 23:54:37 -0700 (PDT)
Message-ID: <980b8a5e-2c9f-4a7b-8014-15cc96831cf0@redhat.com>
Date: Wed, 22 Jul 2026 08:54:35 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 06/19] target/arm/kvm: Read all ID registers from
 KVM
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 prerna.saxena@nutanix.com
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-7-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260716213858.609699-7-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PVW-k6_mj24wg-cNFmevzMyxr4hg4XTSTd-4g_aURFM_1784703278
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/26 11:38 PM, Khushit Shah wrote:
> Try to read all the ID registers from KVM. KVM may return ENOENT, for
> ID registers it does not support reading from userspace. Ignore those
> registers. As this list is small, in future we may anyway want to
> handle those register specially.
>
> We want to do this so that we can expose more or less complete
> host feature view to management stack, as for migration, we want both
> writable and non-writable ID registers to match.
>
> Also remove the unused 'cpu' args throughout the call-chain.
I will integrate this fix in the parent series
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/kvm.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 63b3727e05..42ff731f6e 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -292,14 +292,14 @@ static int kvm_feature_idx_to_idregs_idx(int kidx)
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
> -static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
> +static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
>  {
>      int err = 0;
>      int i;
> @@ -310,26 +310,26 @@ static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
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
> +                warn_report("%s error reading value of host %s register "
> +                                "(ENOENT)", __func__, sysregdesc->name);
if there are expected cases where the read is failing I don't think we
want to warn. Add a trace point instead.
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
>  
>  
>  static void
> -kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
> +kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>  {
>      /* Identify the feature bits corresponding to the host CPU, and
>       * fill out the ARMHostCPUClass fields accordingly. To do this
> @@ -415,8 +415,8 @@ kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
>          SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
>          err = 0;
>      } else {
> -        /* Make sure all writable ID reg values are initialized */
> -        err |= get_host_cpu_idregs(cpu, fd, ahcf);
> +        /* Try to read all the ID registers */
> +        err |= get_host_cpu_idregs(fd, ahcf);
>  
>          /*
>           * temporarily override the CLIDR_EL1 value since some host values
> @@ -595,7 +595,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>      g_free(writable_map);
>  
>      if (!arm_host_cpu_features.dtb_compatible) {
> -        kvm_arm_get_host_cpu_features(cpu, &arm_host_cpu_features);
> +        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
>      }
>  
>      cpu->kvm_target = arm_host_cpu_features.target;
Thanks

Eric

