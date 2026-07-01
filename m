Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C467D233953
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 14:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782914704; cv=none; b=l/d4COnvPJy6FIx8jOtKlZNl3l1SiQ1p9OYmgyyVlKrIEI9OaMVWcqZI3felrgb0bj/kiBpKVRVWUOeDLWSlTroua97ZxKoRcKw5VCrLSIAoTAoRVaRCF+wz1U1La+8iIjw8ntgENm2GyWKpidnii72CoXy1c0G79ikajTCCA1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782914704; c=relaxed/simple;
	bh=jLRi1shH8PjXc7hfGKlds880MgKVpT3AMnonDKUdnjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UGiV1rqKAKbR0/rrAz20gokpOS50ifZLjLnATpIemzJn7pAhrfw30fndyhGXyaD2CdoTXLwtrejLkrj/y7+fVgMscT7VtsQeuiYseGJQtcIoGy4Q53WKnIyGMh1DxYR/r94RKwwIVsEGQNQHuqrEmOCsMA62BuRmcg6GqfxId+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EERoXObI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EERoXObI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782914701;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lec8VUI2yjzTXicodtt6XfLuullf5XdbBMwWNAy7kqg=;
	b=EERoXObIJyrDTKusab6GJJSbzAxf5xc2SSGdrveX87UYlMXG3DphFu1Racpc/2ACWm/Cxa
	7uiC7HrQY/Fj0wCEytVNYy8t2luNF4H+p/VfIS3wmrqTBut25IdlUN7dlVmkWvYjPq0gR/
	eQRo4Gb0CdrnsrTnZ1638ykf7KCQ5oo=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-711-_Xj-DPSWOIC_4IJX3caeeQ-1; Wed, 01 Jul 2026 10:05:00 -0400
X-MC-Unique: _Xj-DPSWOIC_4IJX3caeeQ-1
X-Mimecast-MFC-AGG-ID: _Xj-DPSWOIC_4IJX3caeeQ_1782914699
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5aeb711dff7so321607e87.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Jul 2026 07:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782914699; x=1783519499;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lec8VUI2yjzTXicodtt6XfLuullf5XdbBMwWNAy7kqg=;
        b=XnqxZvxmn4JCL/iLbIiyTceRBxIyH3NCc1iWWznXm1FiemW0qz/dQvZpbzIPs5TBM/
         O9JAJIdzzQlkUYZ2qG2/HQs5I06rfkfKVSqrDrLEJDSaCKCsR7uG517Ksocde72mqt7X
         DLEt1tHb6nm7md7q8xzZxyEGpZvO3kOPAWnSpz0+4MLkO35/ng5vJ6RiFEvhzVfb9oej
         LHkcpNRaVsXeiRYx381/neq2FapxY0vVje6o+h9MP6iswK/OZ4v1Qp87Y0IXZEQnmlOY
         o+WwCz36zGebqKtswFql0+U0kauI2tTtQGiICITNBsiSUw1TnWq8ZQbLzw386y1Qs2zI
         deUw==
X-Forwarded-Encrypted: i=1; AHgh+Rp/Ncyf8c1LP80F8juOkhyY4M8a90nL8gBO+X6GojDvt1ZoPgUSuFtwyTAb11zNOPuPVfnCuds=@lists.linux.dev
X-Gm-Message-State: AOJu0YzuO/EuXsVlFT2cmgERQ2MQGsx01NJWrjiUjuzcQUWq7VVhdKfY
	9zKnXoGUjPOtkWIuh5zTDz9+FoZJsWFmgv1yQIpt4OFeMtPkGhwO0emihyxxmect5XvhQWbEfLE
	c+eso5LVrp31CKq30IwqeR6bTGMbor0fzdYunZ7eWnMLsxWe8Rxampf4MAw==
X-Gm-Gg: AfdE7cnDHJF0i+Y/BkwXEIEblUFuR5oF5Rq7kzeXgqIRjooTmDhbnGU+14w3jvLCr8S
	Yr3SW85CBBVT4GKmRQVD+O3RAQqofPuxEQcr02fq80Hn0rgP2Fjio9MWzTwaD7V1FOqGefwjOId
	PLZeDBpCIPxCBjk9eenxEzSM0tEaDPepEswPSvbjuI/TRwDkFsmdki1+Cv/aZz+ykUXmk6spCaw
	jGBacIjKPoE+BqM9czGGp+ieC1v4wTMCyvmWn2ro0SIKVsvihAQITXNFJIvQLssdlppIMDXZYpe
	dhUG5OolSxHoCnZdrPYEwotbUI/hkjwkV5pQxHQJIlh66J0AE43Dyvu8a2ZQrmP1VEMITPKpXnC
	/8mcpbNHZp3AjawsYjOutIDL31lwAVkDhJHK24KgzfZUF8+0MDX+MVm35FJw=
X-Received: by 2002:a05:6512:31ca:b0:5ae:aaa8:eb21 with SMTP id 2adb3069b0e04-5aec67a2c1dmr631170e87.14.1782914698918;
        Wed, 01 Jul 2026 07:04:58 -0700 (PDT)
X-Received: by 2002:a05:6512:31ca:b0:5ae:aaa8:eb21 with SMTP id 2adb3069b0e04-5aec67a2c1dmr631140e87.14.1782914698392;
        Wed, 01 Jul 2026 07:04:58 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aec8991affsm20145e87.13.2026.07.01.07.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 07:04:57 -0700 (PDT)
Message-ID: <1f338105-9d60-4239-b4aa-fa2e442d338a@redhat.com>
Date: Wed, 1 Jul 2026 16:04:54 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v6 08/17] target/arm/cpu-idregs.h.inc: Generate enum
 values
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
 <20260616132625.1732031-9-eric.auger@redhat.com>
 <F517E5C6-EF76-4D2A-97E8-6C232E3CE3DB@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <F517E5C6-EF76-4D2A-97E8-6C232E3CE3DB@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LXQ3-Qiv4COw5uOhEEy2uzjivAVEqnPekBvHGfwYso8_1782914699
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Khushit,

On 6/19/26 8:28 AM, Khushit Shah wrote:
> From f0e489cebdac1ba94b8082bc240f2d889555f7ea Mon Sep 17 00:00:00 2001
> From: Khushit Shah <khushit.shah@nutanix.com>
> Date: Fri, 19 Jun 2026 11:54:29 +0530
> Subject: [PATCH] scripts: bug fixes in update-aarch64-cpu-sysreg-properties
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
> While rebasing I found two bugs here:
> - It outputs incorrect value for field that defined a ValueRange.
>    For example, CTX_CMPs (and all similar fields).
> - decimal 10 might be incorrectly parsed as to 2.

OK thanks, I will integrate this in next respin

Eric
>
> Sending inline patch that I have added.
> ---
>  .../update-aarch64-cpu-sysreg-properties.py   | 56 ++++++++++++-------
>  1 file changed, 35 insertions(+), 21 deletions(-)
>  mode change 100644 => 100755 scripts/update-aarch64-cpu-sysreg-properties.py
>
> diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
> old mode 100644
> new mode 100755
> index 9e829fda2e..2e28b03598
> --- a/scripts/update-aarch64-cpu-sysreg-properties.py
> +++ b/scripts/update-aarch64-cpu-sysreg-properties.py
> @@ -106,6 +106,29 @@ def collect_fields(item, bit_offset=0):
>  
>      return fields
>  
> +def parse_value_int(raw_val):
> +    if raw_val is None or isinstance(raw_val, bool):
> +        return None
> +
> +    # may already be real number
> +    if isinstance(raw_val, int):
> +        return raw_val
> +
> +    raw_str = str(raw_val).strip()
> +
> +    if "'" in raw_str:
> +        # quoted bitstring like "'0100'"
> +        bits = raw_str.replace("'", "")
> +        try:
> +            return int(bits, 2)
> +        except ValueError:
> +            return None
> +
> +    # unquoted, try decimal
> +    try:
> +        return int(raw_str, 0)
> +    except ValueError:
> +        return None
>  
>  def extract_field_enums(field):
>      enums = []
> @@ -124,32 +147,23 @@ def extract_field_enums(field):
>      if not isinstance(val_entries, list):
>          return enums
>  
> +    # A Values.ValueRange field specifies start and end value for a range.
> +    # Don't enumerate anything for them.
> +    for val_entry in val_entries:
> +        if isinstance(val_entry, dict) and \
> +           val_entry.get("_type") == "Values.ValueRange":
> +               return []
> +
>      for val_entry in val_entries:
>          if not isinstance(val_entry, dict):
>              continue
> -            
> +
>          if val_entry.get("_type") == "Values.Value":
> -            raw_val = val_entry.get("value")
> -            if raw_val is None:
> +            int_val = parse_value_int(val_entry.get("value"))
> +            if int_val is None:
>                  continue
> -                
> -            # some of the values have ' like "'0100'"
> -            raw_val_str = str(raw_val).strip().replace("'", "")
> -            
> -            try:
> -                # convert into bin 
> -                int_val = int(raw_val_str, 2)
> -            except ValueError:
> -                try:
> -                    # Fallback to dec if not bin
> -                    int_val = int(raw_val_str, 0)
> -                except ValueError:
> -                    continue
> -            
> -            enums.append({
> -                'value': int_val
> -            })
> -            
> +            enums.append({'value': int_val})
> +
>      return enums
>  
>  def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
> --
> 2.52.0
>
>
>

