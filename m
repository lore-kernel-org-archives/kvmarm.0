Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C9B39BFFC
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 06:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173113; cv=none; b=NV3qTBepuNvNvz5HdYszOx1f776bjbCfK+ULPdSItsqjXQ05AMhc6Kal1C7mn1iUru9rEXFDppyXIol+P2Igg555dTjg+K9X1QrqT1VqncV4arjV4aKEn5JVGPqhhSelj2KQP570PRJYXAKjt+hrzz6KmKSOs+/xwOv57X8FtGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173113; c=relaxed/simple;
	bh=i2kLlC0fP9iZQAXe0BIye7m9Z1BJ8qzCIthsBwQBdjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sIBI5OLqIU+jfK+cwFwE+8vMsn+D1DlnAQ5RIGaaYkjuk3iDl82XAOiCqClf1UZnWEKddfVGVA6BwlUZtFq29nW018pSe1h0/P/f6FuwTtHd2375Ek829aqf2Cv3jfJcEoWql79mg6du0JyZaaHi3CeJf6DpzN+OkUmPV+cDDB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UWJA0ltu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWJA0ltu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779173110;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMy8vCv1+apXPJHbx27hsjeWyMULOd2K4r1D0AR/RlI=;
	b=UWJA0ltuwRGFj15G6SZp9KxRt/fmwoij70c2iNVsuTn1JNTvI9PWRuz1qgx8YEAEtdbXsM
	a6NzJMK++26AvLSFPamPr+TzPa7jstKlfQ0gIAagjKY51Tw0Q6cfALHEs0cyAQmiqd0lCO
	yXe4IJvJyAIeCp+QlXbufhmDcyqIOZ0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-VltMNzYxONmDM1BKSpTvFw-1; Tue, 19 May 2026 02:45:07 -0400
X-MC-Unique: VltMNzYxONmDM1BKSpTvFw-1
X-Mimecast-MFC-AGG-ID: VltMNzYxONmDM1BKSpTvFw_1779173106
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48eb0da933fso25707035e9.0
        for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 23:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173106; x=1779777906;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMy8vCv1+apXPJHbx27hsjeWyMULOd2K4r1D0AR/RlI=;
        b=djS31umBIOftOM0EllRVjsXr8IkhSI3kT2PUbe5hCTeUbUnv4Fdza/U6pSHj8qK65E
         fnXKbbWN0fysdWvSA/6GyAs/cK6Vz3XaCugk0vMrs9SH/4kJIIDE5y6lOUBE5lEFwT/u
         E6CgyiDI+tWvEERBac+8VNutsnLgYiaqPZPeAL8+S/bCM25FNTA9CCn8VxClaofxtovr
         r/1w+vSB7JpqofYNnGy7hGItZq95lq4XjOHXkF950IBnCx0YV0b36DH252m2lNXIoIjA
         WBfE9o++vX55bcvpHYw71uJ+MWVg2QQGAn6Dh0hnxYFmJIbWuA31QtD0gO1SlNwOIRkp
         7IgA==
X-Forwarded-Encrypted: i=1; AFNElJ9K8SgODNxswolJSp4R64X4Adhzw4QvCW3Q+Xzwf04x4WiVD9yyvBhdTLiLrYsmQvSJYvvXevY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxW2/RYIuHK7oyEQt98LhXU4WYR/DwNVaOuMgvij+HGXJeqbw7a
	8QfBmtMVEftQQYP8SWQNF7DM90VjsAQyhuqT45sUI3PPuAqD8uslhjoU1AYxoPs5yOvI7M1fjlK
	2/XoiDKfpUtJquNNdtdGkyJDEYgy3mtdy+aeEbxe8fNblW//Ui80WTLzDnw==
X-Gm-Gg: Acq92OF7ZSdlXm5WCU1TxWy9kGpF2wjwlLUNJCTK/Wy084ZT5fKp1zJJ6w7xj722RbW
	N5mTwr9INw0mLsFNfHO087jrxkrooiz5ujuaD3vbrpEC8UKY3WgfMCwmj7jGyGuJy8hPdCHfAU7
	t3Huq84OxTMD+sDb6JfBY6qiS/h6+8pUuGQr8WkWKuSj015iSGmmJ/xhh9vjs9Rri5/9dQoLgHW
	VvSATYnj8/8oHtmww5ZpaqyFSWuvXliUCdjwUD0PHQFh8MrACAjUnHByAnMhy06Hke3xbVRAeyi
	2rrG8sWsi+djYe84cLb+FJyoBiLOiM0ut5+wBneqPV7RB1acBoRaGoXkYfQDkiXtkZjG6WD0IQ6
	VZXxSj+zQaZ5oLri7eEcx5/BK80qGG8CK3y3fnOIFTmn49I0/sZAj78zQDlIi9PZvSYz8xg==
X-Received: by 2002:a05:600c:a4f:b0:48f:e230:2a24 with SMTP id 5b1f17b1804b1-48fe66204e8mr260842595e9.31.1779173106403;
        Mon, 18 May 2026 23:45:06 -0700 (PDT)
X-Received: by 2002:a05:600c:a4f:b0:48f:e230:2a24 with SMTP id 5b1f17b1804b1-48fe66204e8mr260842105e9.31.1779173105959;
        Mon, 18 May 2026 23:45:05 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c834besm323327435e9.3.2026.05.18.23.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 23:45:05 -0700 (PDT)
Message-ID: <4e056a04-56e2-43ea-ba62-a2953efff080@redhat.com>
Date: Tue, 19 May 2026 08:45:03 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 11/17] arm/kvm: write back modified ID regs to KVM
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>, yangjinqian1@huawei.com
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-12-eric.auger@redhat.com>
 <IA0PR12MB75555B2C69AC473011333C72AB3D2@IA0PR12MB7555.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <IA0PR12MB75555B2C69AC473011333C72AB3D2@IA0PR12MB7555.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u5X5g1Rx4W2mxlg7V-vR_KbDvNvk72LmKOjulv_2Beo_1779173106
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/8/26 3:03 PM, Shameer Kolothum Thodi wrote:
> Hi Eric,
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 03 May 2026 08:34
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
>> <skolothumtho@nvidia.com>; philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [PATCH v4 11/17] arm/kvm: write back modified ID regs to KVM
>>
>> External email: Use caution opening links or attachments
>>
>>
>> We want to give a chance to override the value of host ID regs.
>> In a previous patch we made sure all their values could be fetched
>> through kvm_get_one_reg() calls before their modification. After
>> their potential modification we need to make sure we write back
>> the values through kvm_set_one_reg() calls.
>>
>> Make sure the cpreg_list is modified with updated values and
>> transfer those values back to kvm.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/kvm.c        | 59
>> ++++++++++++++++++++++++++++++++++++++++-
>>  target/arm/trace-events |  1 +
>>  2 files changed, 59 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 1a9b91bf8a..ca9a7d9439 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -275,6 +275,21 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
>>      return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
>>  }
>>
>> +static int kvm_feature_idx_to_idregs_idx(int kidx)
>> +{
>> +    int op1, crm, op2;
>> +    ARMSysRegs sysreg;
>> +
>> +    op1 = kidx / 64;
>> +    if (op1 == 2) {
>> +        op1 = 3;
>> +    }
>> +    crm = (kidx % 64) / 8;
>> +    op2 = kidx % 8;
>> +    sysreg = ENCODE_ID_REG(3, op1, 0, crm, op2);
>> +    return get_sysreg_idx(sysreg);
>> +}
>> +
>>  static int idregs_idx_to_kvm_feature_idx(ARMIDRegisterIdx idx)
>>  {
>>      ARMSysRegs sysreg = id_register_sysreg[idx];
>> @@ -1197,6 +1212,39 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
>>      return true;
>>  }
>>
>> +static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
>> +{
>> +    if (!cpu->writable_map) {
>> +        return;
>> +    }
>> +    for (int i = 0; i < NR_ID_REG_MASKS; i++) {
>> +        uint64_t writable_mask = cpu->writable_map->regs[i];
>> +        uint64_t *cpreg;
>> +
>> +        if (writable_mask) {
>> +            uint64_t previous, new;
>> +            int idx = kvm_feature_idx_to_idregs_idx(i);
>> +            ARM64SysReg *sysregdesc;
>> +            uint32_t sysreg;
>> +
>> +            if (idx == -1) {
>> +                /* sysreg writable, but we don't know it */
>> +                continue;
>> +            }
>> +            sysregdesc = &arm64_id_regs[idx];
>> +            sysreg = sysregdesc->sysreg;
>> +            cpreg = kvm_arm_get_cpreg_ptr(cpu,
>> idregs_sysreg_to_kvm_reg(sysreg));
>> +            previous = *cpreg;
>> +            new = cpu->isar.idregs[idx];
>> +            if (previous != new) {
>> +                *cpreg = new;
>> +                trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->name,
>> +                                                            previous, new);
>> +            }
>> +        }
>> +    }
>> +}
>> +
>>  void kvm_arm_reset_vcpu(ARMCPU *cpu)
>>  {
>>      int ret;
>> @@ -2148,7 +2196,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>      }
>>      cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
>>
>> -    return kvm_arm_init_cpreg_list(cpu);
>> +    ret = kvm_arm_init_cpreg_list(cpu);
>> +    if (ret) {
>> +        return ret;
>> +    }
>> +    /* overwrite writable ID regs with their updated property values */
>> +    kvm_arm_writable_idregs_to_cpreg_list(cpu);
>> +
>> +    write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
> KVM may hide registers based on ID register fields when features
> are disabled. Updating writable ID registers after KVM_GET_REG_LIST
> can result in a mismatched register list and failures when setting
> registers.
>
> This was reported on v3:
> https://lore.kernel.org/qemu-devel/ae3f4d26-7a1a-418c-b303-2ed1d9ced4ba@huawei.com/

Effectively I failed to address Jinqian's comment. This should be fixed
in next respin

Thanks to both of you!

Eric
>
> Is this fixed someway in this series? I am not sure. I have faced the
> same issue on NV platforms as well.
>
> Thanks,
> Shameer
>

