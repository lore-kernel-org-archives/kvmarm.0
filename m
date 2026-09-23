Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB85516153
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180530; cv=none; b=pQ9IKijJhthSZEIeyUkpmK/iF2Qq4L5/SL2O1HqnamU4McofYSi87caH7j+ziaAc+ZLc5YcfgY+YPPwIwTE1Fugzlupyfk6y9zR6ffJNjqzy2oW3qcJ3yE3Gm7KGe5VWX2sZN0Pod3VGjl/yfVcF15CgMO9UtARxBGQ/iKSJUX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180530; c=relaxed/simple;
	bh=aEwMYlRa8Dus7rL/Itjp6vKjQgpWuvqOQ4F8KwCBoHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FSKtfjvG3ZdGoZfErPt7WqRP4sxTlG4vsPBS80iOPqECrm+pmE/sD4JKTVsf6bfcXHJQ3aU5G7PPY7iTO37jqT1NmFEOabVUkmlO20Q1QF5M3ByS+m4R+1e+GUe3Opr/U7a0ovSkgTB+JTwfabxgKw9E4TqtXo070ARiNEjFEwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EmfFWbT1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EmfFWbT1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790180527;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H4D47+Kf84D/M5AvyLwBNOHI4bu1uWl4MXTV5Y9W2XM=;
	b=EmfFWbT1uSnybtncyvEC7BHamgDrRlgTeZUOOAdl4WtoXRhHvcbW1ST/ZpjAZwLHqQjMnV
	cAeH3K61B4OIL/QvJzuxsPkkQgciggGtOL3vsx0i97qpktvGUB89YodnhQ+KNPhEQe7L5p
	xLzf+hpoEzYsCXSABI/yCVnjEuZmkuI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-hitp4Co6Nwytr61utw-n4Q-1; Wed, 23 Sep 2026 12:22:06 -0400
X-MC-Unique: hitp4Co6Nwytr61utw-n4Q-1
X-Mimecast-MFC-AGG-ID: hitp4Co6Nwytr61utw-n4Q_1790180525
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a767b782so8776255e9.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 09:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790180525; x=1790785325;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H4D47+Kf84D/M5AvyLwBNOHI4bu1uWl4MXTV5Y9W2XM=;
        b=qUKyBCbb1sMNvG/PILDzQ8knFNalw5slmaKYd9VTtXJbIkBx7QCzIMmtiR+bAcLYZP
         N82T1GFPc0wx658dvicQ3yBxInlYYqVlekyYTppfLfMuxi8Q8HZIkNphfxLJdtB0bu7S
         cAAQcBOg9af0/FEOa3VdcKn5ct1/aIYrI8uBh5AXEBmrb4bmcAdA2Q22raMMi2d3uf58
         k+9AI28mJcmsT/twz7addH414TRTqVaidfuR5xn9obUrTow0Ywa7vfjFSNfJHzxPmU6c
         d2cZhtDk7BnsbDAHTjDgjiRx4YR/oEiNsP2a/w7u/8lnisyxXR0koCZ/qljCsunauRbJ
         fWeA==
X-Forwarded-Encrypted: i=1; AKwUvBzG9kheRhN+VwwOsw8NiZyxqtMQ2WTk6mNZnY9IP0YRmXxoDDSWml7yF1sEHSB82zjYlqvIUZQ=@lists.linux.dev
X-Gm-Message-State: AFuF++lMNjV97scYvIu/HFUDBrUDGzjM5rCye/9y68xcLY4ntbM/iHxI
	SQusKgdTE1UvZbQXm3ueARFV3F8FhRmWgvBnP0rfI7qe3LqwOL6dIdHghReH/1glJXSumCIG5Bk
	Jt1c2CWquCUNODtry6NKcyb8OL7qITWrkq7gLQZ0jrcAOnQwbhPGK7+cR1A==
X-Gm-Gg: AYBFou3STEvHz/WL2OyEAe68r1GM7odD3C2S0ByhUDbB9SBEhv8km4x4uCwQ6CtYc2p
	By90G0h9gaS1wFk1gg8cBO9QfD3e0zqjwllMtrWvwUJGpLdg557A0VYBy7IWqK9AuEzCNxaYNTR
	1wK1xOPxXsq5kX2f8Sf6+rkx3Aqbr74dhiOUA5yWZEoQo+taENFqtfEO5ZQW63HVxRxeeo3SVD9
	fICLEixQ3CL23z+Ha1HiZs+0wGHPCfXP6X1JSwFZSFDM4GrAovSRbt0IdjtonPgsINpygWz74D3
	j6yPfFUTvZxUTEhSHVy7Imy1o3+YSLNL92RIGzZdN8Q2zk/Y/ExN3TAiS43VrMPgL4lOhKuB2Ka
	tGiyRxaeHYNKSjy3r9oUphlohRYLPTRmKILgW/fQ0VcKx5Y6f
X-Received: by 2002:a05:600c:1f8c:b0:49c:fc6e:a3d2 with SMTP id 5b1f17b1804b1-49fdf12f2b5mr49459785e9.17.1790180524564;
        Wed, 23 Sep 2026 09:22:04 -0700 (PDT)
X-Received: by 2002:a05:600c:1f8c:b0:49c:fc6e:a3d2 with SMTP id 5b1f17b1804b1-49fdf12f2b5mr49459355e9.17.1790180524146;
        Wed, 23 Sep 2026 09:22:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde18555bsm91240255e9.2.2026.09.23.09.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 09:22:03 -0700 (PDT)
Message-ID: <59aff568-9101-4f0a-ae62-61a32b8c1935@redhat.com>
Date: Wed, 23 Sep 2026 18:22:01 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 01/25] target/arm: expose SYSREG_ props for
 REVIDR_EL1 and AIDR_EL1
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
 <20260921123249.1708067-2-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-2-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lh-xzI5-kIZubfAn8VAZBBXyFAdC7y4AhdaL-dHl3zI_1790180525
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Khushit,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> REVIDR_EL1 and AIDR_EL1 are implementation-defined and have no named
> fields in Registers.json.
>
> Emit dummy VAL fields covering the full register for these registers
> in scripts/update-aarch64-cpu-sysreg-properties.py, then remove the
> special case for these in kvm_arm_expose_idreg_properties(), exposing
> them as SYSREG_ props.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  scripts/update-aarch64-cpu-sysreg-properties.py |  9 +++++++++
>  target/arm/cpu-idregs.h.inc                     |  2 ++
>  target/arm/kvm.c                                | 10 +---------
>  3 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
> index 0b4e4d3e0c..2269063408 100644
> --- a/scripts/update-aarch64-cpu-sysreg-properties.py
> +++ b/scripts/update-aarch64-cpu-sysreg-properties.py
> @@ -246,6 +246,15 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
>          # Sort decreasing lsbs
>          sorted_fields = sorted(unique_fields.items(),
>                                 key=lambda x: x[1]['lsb'], reverse=True)
> +        if len(sorted_fields) == 0:
> +            # For cases like REVIDR_EL1, add a dummy field covering the
> +            # full register.
> +            sorted_fields.append(('VAL', {
though I think it is important the property name stays SYSREG_REVIDR_EL1
and not SYSREG_REVIDR_EL1_VAL so I guess we need either a property alias
or a special handling for those regs (better as alias were not really
meant for that purpose I think).

Eric
> +                'lsb': 0,
> +                'msb': 63,
> +                'width': 64,
> +                'enums': []
> +            }))
>  
>          for unique_key, bits in sorted_fields:
>              enums_list = bits.get('enums', [])
> diff --git a/target/arm/cpu-idregs.h.inc b/target/arm/cpu-idregs.h.inc
> index c7e93c48b7..bc52112430 100644
> --- a/target/arm/cpu-idregs.h.inc
> +++ b/target/arm/cpu-idregs.h.inc
> @@ -12,6 +12,7 @@
>  /* IDREG_END(REG) */
>  
>  IDREG_START(AIDR_EL1)
> +    IDREG_FIELD(AIDR_EL1, VAL, 0, 64)
>  IDREG_END(AIDR_EL1)
>  
>  IDREG_START(CLIDR_EL1)
> @@ -2438,6 +2439,7 @@ IDREG_START(MVFR2_EL1)
>  IDREG_END(MVFR2_EL1)
>  
>  IDREG_START(REVIDR_EL1)
> +    IDREG_FIELD(REVIDR_EL1, VAL, 0, 64)
>  IDREG_END(REVIDR_EL1)
>  
>  IDREG_START(SMIDR_EL1)
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index e3a0dc07de..8a823d0324 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -554,15 +554,7 @@ void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
>          ARM64SysReg *sysregdesc = &regs[i];
>  
>          if (sysregdesc->writable_mask) {
> -            /*
> -             * special case REVIDR_EL1 and AIDR_EL1 which are writable but
> -             * do not expose named fields. They will need to be handled
> -             * separately
> -             */
> -            if (strcmp(sysregdesc->name, "REVIDR_EL1") &&
> -                strcmp(sysregdesc->name, "AIDR_EL1")) {
> -                decode_idreg_writemap(obj, sysregdesc);
> -            }
> +            decode_idreg_writemap(obj, sysregdesc);
>          }
>      }
>  }

