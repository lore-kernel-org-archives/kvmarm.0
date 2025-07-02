Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC27158DAC
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 08:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751446029; cv=none; b=V/TUc/g1G8omqliXQgE7Jgs1G4RHQv9fK1dqF9as9TKPcng2YOlUSwUumd4qX8hly0JMXu0YCbanJ3IeLqRfX8ZTqca6Ws+gIHnORxQ5cr3eFSIxsH0wSIlfD63B2bVmGHcxzm3EouMgMO4edrnJkbCf7duVM4Zk4DXtOyDANpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751446029; c=relaxed/simple;
	bh=KhlwainkStX/oJ8cciROZg4iWqWrJJFlm953xEPGoAk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OH41AylhZ/bqX+H416KuzT7J8jSFSrDQNDM08a7rks7ZZ8SwPK+Xm48pJEfRFQ9VLe0qYwLFAO6sW2Wp2iGhNFDnRgrtzfcVaqdonOljJ/HC5e6tUaAPO/t6mvDOi+6702/ghBdVAogPV9XmtOEsaa4k4gv9u8NQLCv+ZnR3I4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OQz0J7JW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OQz0J7JW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751446026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8bmrix3SRkejtxkZeSUfVdsas9XCclL2BdcDpYVHi4M=;
	b=OQz0J7JWCEo4PJv4wgxjpJhgybcr+c9D6QMq1TCWghxmUzYHEUGU0kJ+wkgwzGWF8DAdyz
	BjIq3lTl0ThE5HGCyreHWxiwnbtLHwoqbnJSTuc4fxsyOjE/FnO8H1Gl3UH0mt+gHeOGYE
	7e3L0nHdczLoRYEuxhzdfKk/1yJTKdM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-OiDTYf4FNIeL_xP4JTgzeQ-1; Wed,
 02 Jul 2025 04:47:02 -0400
X-MC-Unique: OiDTYf4FNIeL_xP4JTgzeQ-1
X-Mimecast-MFC-AGG-ID: OiDTYf4FNIeL_xP4JTgzeQ_1751446020
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 208461955EDB;
	Wed,  2 Jul 2025 08:46:59 +0000 (UTC)
Received: from localhost (dhcp-192-236.str.redhat.com [10.33.192.236])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A5AA19560B3;
	Wed,  2 Jul 2025 08:46:56 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Jinqian Yang <yangjinqian1@huawei.com>, eric.auger.pro@gmail.com,
 eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, Zhou
 Wang <wangzhou1@hisilicon.com>, liuyonglong <liuyonglong@huawei.com>
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 07/10] arm/kvm: write back modified ID regs to KVM
In-Reply-To: <ae3f4d26-7a1a-418c-b303-2ed1d9ced4ba@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-8-cohuck@redhat.com>
 <ae3f4d26-7a1a-418c-b303-2ed1d9ced4ba@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 02 Jul 2025 10:46:53 +0200
Message-ID: <878ql7q8si.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jul 02 2025, Jinqian Yang <yangjinqian1@huawei.com> wrote:

> On 2025/4/15 0:38, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
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
>>   target/arm/kvm.c        | 44 ++++++++++++++++++++++++++++++++++++++++-
>>   target/arm/trace-events |  1 +
>>   2 files changed, 44 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index b07d5f16db50..9e4cca1705c8 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -1083,6 +1083,39 @@ void kvm_arm_cpu_post_load(ARMCPU *cpu)
>>       }
>>   }
>>=20=20=20
>> +static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
>> +{
>> +    if (!cpu->writable_map) {
>> +        return;
>> +    }
>> +    for (int i =3D 0; i < NR_ID_REGS; i++) {
>> +        uint64_t writable_mask =3D cpu->writable_map->regs[i];
>> +        uint64_t *cpreg;
>> +
>> +        if (writable_mask) {
>> +            uint64_t previous, new;
>> +            int idx =3D kvm_idx_to_idregs_idx(i);
>> +            ARM64SysReg *sysregdesc;
>> +            uint32_t sysreg;
>> +
>> +            if (idx =3D=3D -1) {
>> +                /* sysreg writable, but we don't know it */
>> +                continue;
>> +            }
>> +            sysregdesc =3D &arm64_id_regs[idx];
>> +            sysreg =3D sysregdesc->sysreg;
>> +            cpreg =3D kvm_arm_get_cpreg_ptr(cpu, idregs_sysreg_to_kvm_r=
eg(sysreg));
>> +            previous =3D *cpreg;
>> +            new =3D cpu->isar.idregs[idx];
>> +            if (previous !=3D new) {
>> +                *cpreg =3D new;
>> +                trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc-=
>name,
>> +                                                            previous, n=
ew);
>> +            }
>> +        }
>> +    }
>> +}
>> +
>>   void kvm_arm_reset_vcpu(ARMCPU *cpu)
>>   {
>>       int ret;
>> @@ -2050,7 +2083,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>       }
>>       cpu->mp_affinity =3D mpidr & ARM64_AFFINITY_MASK;
>>=20=20=20
>> -    return kvm_arm_init_cpreg_list(cpu);
>> +    ret =3D kvm_arm_init_cpreg_list(cpu);
>> +    if (ret) {
>> +        return ret;
>> +    }
>> +    /* overwrite writable ID regs with their updated property values */
>> +    kvm_arm_writable_idregs_to_cpreg_list(cpu);
>> +
>> +    write_list_to_kvmstate(cpu, 3);
>> +
>> +    return 0;
>>   }
>
> Hi,
>
> When I was testing this series, I found a problem. On the host,=20
> SYSREG_ID_AA64MMFR3_EL1_TCRX=3D0x1,
> I configured it to 0x0 in=C2=A0qemu, and qemu cannot start.
> The ID_AA64MMFR3_EL1 TCRX field controls whether the TCR2_EL1 and=20
> TCR2_EL2 registers are used.
> In the kernel, when TCRX is 0, TCR2_EL1 is invisible to the guest, and=20
> when it is 1, it is visible. When we
> configure this field segment to 0, the configuration is not yet written=20
> to KVM, but the cpreg list is initialized,
> adding TCR2_EL1 to the cpreg list. Therefore, after writing the=20
> QEMU-configured registers to KVM, the
> cpreg list needs to be updated again.
>
> @@ -2227,7 +2229,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>
>  =C2=A0 =C2=A0 =C2=A0write_list_to_kvmstate(cpu, 3);
>
> -=C2=A0 =C2=A0 return 0;
> +=C2=A0 =C2=A0 return kvm_arm_init_cpreg_list(cpu);
>  =C2=A0}
>
> The above modification can solve the problem, but it may not be the best=
=20
> way.

Thanks for testing. Indeed, if we write something that changes the
visibility of registers, we need to do an update. Probably needs some
thinking (e.g. what happens if a register disappears, but the user set
some fields?)

