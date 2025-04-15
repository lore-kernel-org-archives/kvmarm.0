Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC762918C2
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 09:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744710897; cv=none; b=jp4JQbkFONW/Yzfs7XadUBx2G/Ppn+4xVzzmhf6veO3yebx78UvT1/urDvh+3Pc4bmrMc4Jq0zpjHcpRvxx+qtddRSpxRzvCxnKF++jkcPYwkWNGQpObO8RLciFEY7f5hT9fbSJOiO6Z49YV7Fo5EeTd+ooPMiW4pNt+pMsRNms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744710897; c=relaxed/simple;
	bh=WTRN9IN+JIRLK73X4xPWP7i1D9IMNTbPPMvn2Z2SbEo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gREBhGlZPto8HdtqJfjwHzUKIFeasG1tmohunBS6kMLKK8bDB57qywOmyzwvqkwFuzIQZAAhhcozRugZrSpj502yiP9YUIbS3XVZ6+S8ItltjSlJ2oCwcZ/8vIdWCtanuSpIIK+KXJ+kBcewyOzK1G/3MWnMsVqpTbQQWrENEYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+Tgh7CC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+Tgh7CC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744710894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zfu+55ya+LNp+fnrMbsION4V9pzLKLFVggb5s8FgwLA=;
	b=N+Tgh7CCduJLWtobonyt6p18mv6mWTiJk4pC0dyY/8+DlIbVC+theIQg7WRHWgeW5Y3fak
	LwMOZb3C9u9NarALRCI9QRFevkPbNqF1BC8fvHxLy9X9nv6jUWEh63P9NPs+KKPRSaPwRH
	saniYHoJ83RNyrWIvdKLpTD8MtSdig8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-237-3fd-xUXcMnCxHSbgIPPQqA-1; Tue,
 15 Apr 2025 05:54:51 -0400
X-MC-Unique: 3fd-xUXcMnCxHSbgIPPQqA-1
X-Mimecast-MFC-AGG-ID: 3fd-xUXcMnCxHSbgIPPQqA_1744710889
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEC6D180035C;
	Tue, 15 Apr 2025 09:54:48 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D564F19560AD;
	Tue, 15 Apr 2025 09:54:46 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 eric.auger.pro@gmail.com,
 eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 pbonzini@redhat.com
Subject: Re: [PATCH v3 07/10] arm/kvm: write back modified ID regs to KVM
In-Reply-To: <5f9a4bc5-5569-437f-8e8d-f386dd51e33a@linaro.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-8-cohuck@redhat.com>
 <5f9a4bc5-5569-437f-8e8d-f386dd51e33a@linaro.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 15 Apr 2025 11:54:44 +0200
Message-ID: <87sem9sqaj.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Apr 15 2025, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> On 14/4/25 18:38, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>=20
>> We want to give a chance to override the value of host ID regs.
>> In a previous patch we made sure all their values could be fetched
>> through kvm_get_one_reg() calls before their modification. After
>> their potential modification we need to make sure we write back
>> the values through kvm_set_one_reg() calls.
>>=20
>> Make sure the cpreg_list is modified with updated values and
>> transfer those values back to kvm.
>>=20
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   target/arm/kvm.c        | 44 ++++++++++++++++++++++++++++++++++++++++-
>>   target/arm/trace-events |  1 +
>>   2 files changed, 44 insertions(+), 1 deletion(-)
>
>
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
>
> s/3/KVM_PUT_FULL_STATE/?

Indeed, that's more obvious. Thanks!

