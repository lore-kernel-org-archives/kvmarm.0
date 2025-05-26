Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3CD1BE238
	for <kvmarm@lists.linux.dev>; Mon, 26 May 2025 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748263066; cv=none; b=f7kZ/nKIyOxtH+nIaEwV+RVom6PhPqbx3cXiJTDZHqiNCMNq/C0SkH4RMP/mvCEaAZiIWD/AACdaF9dZ/wXQCes1kC5VQpDo6b+oXLRvlQNpc9I9bWBbkUgLQfthsZCrJOLft5nnnhMJ9dHyyrjyiWBJPASdA7Fc8dgQHehYZjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748263066; c=relaxed/simple;
	bh=kpbKAeqHaOlXHCl9Kwqv02gPUspKAJP/JvCmqulBsL8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AObVSZ+tutqT4DKJ2ep3E+9Dankk2ERbb9chHUs/+MOikZhHp1Cp27nSJ2M9XU25yWbWwB5axpWxI9H2dwK8cnk1d49/kYajX1BwaU7Dd9q76EY634C+yXhT6wDHrxO742vTgW2ZIz5xtfoZ+MH2MTjuebskFUa+kzJlaO8H3WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LgxbWC0s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LgxbWC0s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748263063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bdtrnT9RkpG11o+5p+F4BXtRoB0VKLAec4NLA2DCwqM=;
	b=LgxbWC0s9mbN+WAe/0qruECTGllL9jweX1pH7CXsMh3mrKUoyWAqLZkXAbCNCWRDj6ww/s
	tUXOiDFdhiilnASoq79ZSmnSZ12pmMsuc9RvJx0Zr7cUcmO/X4WMmEPBSd07+AhfZ2SoL/
	Z179fsuLcxFNPtDARDT8XvbEpwCuNak=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-vjeMu_RjNlC9nfbj3I-ifw-1; Mon,
 26 May 2025 08:37:39 -0400
X-MC-Unique: vjeMu_RjNlC9nfbj3I-ifw-1
X-Mimecast-MFC-AGG-ID: vjeMu_RjNlC9nfbj3I-ifw_1748263058
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D69AE1956089;
	Mon, 26 May 2025 12:37:36 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E902195608D;
	Mon, 26 May 2025 12:37:33 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>, "qemu-devel@nongnu.org"
 <qemu-devel@nongnu.org>, "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "alex.bennee@linaro.org" <alex.bennee@linaro.org>, "maz@kernel.org"
 <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "sebott@redhat.com" <sebott@redhat.com>, "armbru@redhat.com"
 <armbru@redhat.com>, "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>, "jdenemar@redhat.com"
 <jdenemar@redhat.com>
Cc: "agraf@csgraf.de" <agraf@csgraf.de>, "shahuang@redhat.com"
 <shahuang@redhat.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>
Subject: RE: [PATCH v3 06/10] arm/kvm: Allow reading all the writable ID
 registers
In-Reply-To: <ee2e2631faf640f3807c08c6acd95732@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-7-cohuck@redhat.com>
 <ee2e2631faf640f3807c08c6acd95732@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 26 May 2025 14:37:31 +0200
Message-ID: <87ecwbbl9w.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, May 23 2025, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

>> -----Original Message-----
>> From: Cornelia Huck <cohuck@redhat.com>
>> Sent: Monday, April 14, 2025 5:39 PM
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> alex.bennee@linaro.org; maz@kernel.org; oliver.upton@linux.dev;
>> sebott@redhat.com; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; armbru@redhat.com;
>> berrange@redhat.com; abologna@redhat.com; jdenemar@redhat.com
>> Cc: agraf@csgraf.de; shahuang@redhat.com; mark.rutland@arm.com;
>> philmd@linaro.org; pbonzini@redhat.com; Cornelia Huck
>> <cohuck@redhat.com>
>> Subject: [PATCH v3 06/10] arm/kvm: Allow reading all the writable ID
>> registers
>> 
>> From: Eric Auger <eric.auger@redhat.com>
>> 
>> At the moment kvm_arm_get_host_cpu_features() reads a subset of the
>> ID regs. As we want to introduce properties for all writable ID reg
>> fields, we want more genericity and read more default host register
>> values.
>> 
>> Introduce a new get_host_cpu_idregs() helper and add a new exhaustive
>> boolean parameter to kvm_arm_get_host_cpu_features() and
>> kvm_arm_set_cpu_features_from_host() to select the right behavior.
>> The host cpu model will keep the legacy behavior unless the writable
>> id register interface is available.
>> 
>> A writable_map IdRegMap is introduced in the CPU object. A subsequent
>> patch will populate it.
>> 
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu-sysregs.h |  2 ++
>>  target/arm/cpu.h         |  3 ++
>>  target/arm/cpu64.c       |  2 +-
>>  target/arm/kvm.c         | 78 ++++++++++++++++++++++++++++++++++++++--
>>  target/arm/kvm_arm.h     |  9 +++--
>>  target/arm/trace-events  |  1 +
>>  6 files changed, 89 insertions(+), 6 deletions(-)

(...)

>> +/*
>> + * get_host_cpu_idregs: Read all the writable ID reg host values
>> + *
>> + * Need to be called once the writable mask has been populated
>> + * Note we may want to read all the known id regs but some of them are
>> not
>> + * writable and return an error, hence the choice of reading only those
>> which
>> + * are writable. Those are also readable!
>> + */
>> +static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures
>> *ahcf)
>> +{
>> +    int err = 0;
>> +    int i;
>> +
>> +    for (i = 0; i < NUM_ID_IDX; i++) {
>> +        ARM64SysReg *sysregdesc = &arm64_id_regs[i];
>> +        ARMSysRegs sysreg = sysregdesc->sysreg;
>> +        uint64_t writable_mask = cpu->writable_map-
>> >regs[idregs_idx_to_kvm_idx(i)];
>> +        uint64_t *reg;
>> +        int ret;
>> +
>> +        if (!writable_mask) {
>> +            continue;
>> +        }
>> +
>> +        reg = &ahcf->isar.idregs[i];
>> +        ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
>
> I think we can use get_host_cpu_reg() here.

We'd need to rejiggle the tracing a bit, though.

Looking at this, maybe we have too many cross-indexing variants, I'll
check and see if we can simplify that a bit.

>
>> +        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
>> +        if (ret) {
>> +            error_report("%s error reading value of host %s register (%m)",
>> +                         __func__, sysregdesc->name);
>> +
>> +            err = ret;
>> +        }
>> +    }
>> +    return err;
>> +}
>> +
>> +static bool
>> +kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures
>> *ahcf,
>> +                              bool exhaustive)
>>  {
>>      /* Identify the feature bits corresponding to the host CPU, and
>>       * fill out the ARMHostCPUClass fields accordingly. To do this
>> @@ -398,6 +465,11 @@ static bool
>> kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>          err |= get_host_cpu_reg(fd, ahcf, ID_DFR1_EL1_IDX);
>>          err |= get_host_cpu_reg(fd, ahcf, ID_MMFR5_EL1_IDX);
>> 
>> +        /* Make sure writable ID reg values are read */
>> +        if (exhaustive) {
>> +            err |= get_host_cpu_idregs(cpu, fd, ahcf);
>> +        }
>
>
> Also if we do this a bit above can we avoid reading the ID registers twice
> if "exhaustive=true" ?

It's probably not performance critical as we just do this once, but
let's try that anyway.

