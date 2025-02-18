Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE7026AABB
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739894116; cv=none; b=BeJ1iLf7nAXfdBEmatzc3oKuurcIyOV2bo/nwTPTI3Ndn27mZgrBF6GnvbT8Tr7ZCMPeFSEwn3Z6TOvylgtTUvUwp4m+xJCTwZ/jVQR+jisPag4RdqJWY3GaxMbd7dBx93RBlGiE3UCCVSNHQGqN3nu+rLmU26k750/TytyhKsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739894116; c=relaxed/simple;
	bh=M/DA+J9LXXmTP591fhVEjg+qhvQ/g5F1Gq5sW8QfzZk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q1V+TvPYbNK+BoBTR5m3/t8hun3Ci4vNPxI3FMhJ5xnmvfN4nmLaO5KrQsihLFjljPECrtLyiEM4ryJOnybDdAqZaa+sEX8nVd7+mime6Q1rRhvMvv1uiPI86iltHBrr8DIuOg7XzVnQRZViYQrwcfyv0okmzPfyM2VjzsMG9os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GOAHkQRy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOAHkQRy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739894113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j90RWZALR1P7KicoAf1AmydoBRa+BXoXUs125IAi9hQ=;
	b=GOAHkQRyZkQ69G18ZzCuk41dc+Cof6S7W36k7pOvT/wjlfZxYadafobQxsB6BTf88H/Ugt
	kwtS0H3dUcPOsoDeTJLe8n5HZoP970LI9Gu74Oe82UC19IwuuzPVMKL8ZLH0kTQVgXhNd8
	sEwxaEZhuqTE+no8pv8RgRgCb7m396k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-99-pIBM1XteNju7bqO1WirvZQ-1; Tue,
 18 Feb 2025 10:55:09 -0500
X-MC-Unique: pIBM1XteNju7bqO1WirvZQ-1
X-Mimecast-MFC-AGG-ID: pIBM1XteNju7bqO1WirvZQ_1739894108
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 632AD180087A;
	Tue, 18 Feb 2025 15:55:07 +0000 (UTC)
Received: from localhost (unknown [10.67.24.70])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0263E1800874;
	Tue, 18 Feb 2025 15:55:04 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH 02/15] arm/kvm: add accessors for storing host features
 into idregs
In-Reply-To: <b1a2e796-b2f5-4acc-9d6d-e85d99d67a0d@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-3-cohuck@redhat.com>
 <b1a2e796-b2f5-4acc-9d6d-e85d99d67a0d@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 18 Feb 2025 16:54:58 +0100
Message-ID: <874j0r459p.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Feb 18 2025, Eric Auger <eric.auger@redhat.com> wrote:

> Hi Connie
>
> On 2/7/25 12:02 PM, Cornelia Huck wrote:
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu-sysregs.h |  3 +++
>>  target/arm/cpu64.c       | 25 +++++++++++++++++++++++++
>>  target/arm/kvm.c         | 30 ++++++++++++++++++++++++++++++
>>  3 files changed, 58 insertions(+)
>>
>> diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
>> index de09ebae91a5..54a4fadbf0c1 100644
>> --- a/target/arm/cpu-sysregs.h
>> +++ b/target/arm/cpu-sysregs.h
>> @@ -128,4 +128,7 @@ static const uint32_t id_register_sysreg[NUM_ID_IDX] = {
>>      [CTR_EL0_IDX] = SYS_CTR_EL0,
>>  };
>>  
>> +int get_sysreg_idx(ARMSysRegs sysreg);
>> +uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg);
>> +
>>  #endif /* ARM_CPU_SYSREGS_H */
>> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
>> index 8188ede5cc8a..9ae78253cb34 100644
>> --- a/target/arm/cpu64.c
>> +++ b/target/arm/cpu64.c
>> @@ -736,6 +736,31 @@ static void aarch64_a53_initfn(Object *obj)
>>      define_cortex_a72_a57_a53_cp_reginfo(cpu);
>>  }
>>  
>> +#ifdef CONFIG_KVM
>> +
>> +int get_sysreg_idx(ARMSysRegs sysreg)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < NUM_ID_IDX; i++) {
>> +        if (id_register_sysreg[i] == sysreg) {
> I agree with Richard that if we could get rid of this linear search it
> would be nicer.

FWIW, I have a local branch which reworks the lookup and the macros that
is currently in the "it compiles" stage. Hopefully progressing to the
"it works" stage (provided I'm not preempted by other things again.)

>> +            return i;
>> +        }
>> +    }
>> +    return -1;
>> +}
>> +
>> +uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg)
>> +{
>> +    return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
>> +                         (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK) >> CP_REG_ARM64_SYSREG_OP1_SHIFT,
>> +                         (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK) >> CP_REG_ARM64_SYSREG_CRN_SHIFT,
>> +                         (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK) >> CP_REG_ARM64_SYSREG_CRM_SHIFT,
>> +                         (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK) >> CP_REG_ARM64_SYSREG_OP2_SHIFT);
>> +}
>> +
>> +#endif
>> +
>>  static void aarch64_host_initfn(Object *obj)
>>  {
>>  #if defined(CONFIG_KVM)
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index da30bdbb2349..3b8bb5661f2b 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -246,6 +246,36 @@ static bool kvm_arm_pauth_supported(void)
>>              kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
>>  }
>>  
>> +/* read a 32b sysreg value and store it in the idregs */
>> +static int get_host_cpu_reg32(int fd, ARMHostCPUFeatures *ahcf, ARMSysRegs sysreg)
> those are defined as static but there is no user so this will break
> compilation locally

Hm, didn't see that, but noticed a few other places that are b0rken. I
think I need to fiddle with my config to broaden compilation coverage.

