Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25F714884C
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747405040; cv=none; b=m5J8RUk/ZaoIi2VTF4HzbUEUt6Gsxo7gUjv5MoCj80/jNhBQMlKIFdpviYh9Ukken2vfz42qHrEYwHYcKyjdpaokrSzYCbV0wR6+nouZVgkqZwoSY4JA/gd8cGpxj++9jL0wVFjmf7zx6a4nEUXba9CDMMzJ9lrYWvd+wpKtTIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747405040; c=relaxed/simple;
	bh=ENx+qCzlWxL/Tu+I9kT+kNn9SOax+0FqCL8HPl5eosA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lkY3FyVAgFkWG6UOPEkstatTYq0LzCh+ICuW7JUfM6qH5jlIgYHj9K7873awz3Ncco8s/aG0yJ3p+pQ3ajSsVQ3oDaOTR8PKAi9U1KA081Pm58gSyjFHo58KChSaMKaIDtt5IkSDfj6RJAQZ6zHPaCdg4OSFYcBgufuXQIoW6IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CJqUmLsJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJqUmLsJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747405037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TERTr/nzmmczkc5dKkRLFBUYCo0L45Zgj3qT12f3LLU=;
	b=CJqUmLsJ4ng4ExAc9S3KKFTfwJA82XHS1vmt+xFcexv1e12Y967J0dBPbNiE2bpPnjCLow
	LgEfL36ROVv22G1H3SardKd7WXBbLQLMFZLZ6NkgxipT7w3VbPD2wsWPh/hH5FkGz2Uz0z
	T1q8mMy1y2VPGYhZlJxuRaPP2p6SE0I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-489-GNsxUTNXPbqjfztNOK0eSw-1; Fri,
 16 May 2025 10:17:13 -0400
X-MC-Unique: GNsxUTNXPbqjfztNOK0eSw-1
X-Mimecast-MFC-AGG-ID: GNsxUTNXPbqjfztNOK0eSw_1747405031
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF948195608C;
	Fri, 16 May 2025 14:17:09 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D154B195608D;
	Fri, 16 May 2025 14:17:07 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 06/10] arm/kvm: Allow reading all the writable ID
 registers
In-Reply-To: <a706e9a2-0a49-4296-ba0a-8001f433b8b8@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-7-cohuck@redhat.com>
 <a706e9a2-0a49-4296-ba0a-8001f433b8b8@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 16 May 2025 16:17:05 +0200
Message-ID: <871psod4im.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, May 13 2025, Eric Auger <eric.auger@redhat.com> wrote:

> On 4/14/25 6:38 PM, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
(...)

>> +static bool
>> +kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf,
>> +                              bool exhaustive)
> maybe the exhaustive term shall be replaced by handle_writable_id_regs
> which tells more explicitly what it does

Maybe get_all_writable_id_regs?

>>  {
>>      /* Identify the feature bits corresponding to the host CPU, and
>>       * fill out the ARMHostCPUClass fields accordingly. To do this

(...)

>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>> index 8d1f20ca8d89..90ba4f7d8987 100644
>> --- a/target/arm/kvm_arm.h
>> +++ b/target/arm/kvm_arm.h
>> @@ -141,8 +141,12 @@ uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu);
>>   *
>>   * Set up the ARMCPU struct fields up to match the information probed
>>   * from the host CPU.
>> + *
>> + * @cpu: cpu object
>> + * @exhaustive: if true, all the feature ID regs are queried instead of
> s/queried/handled
>> + *              a subset

And make this "if true, additionally get the contents of all writable ID
registers as well"?

>>   */
>> -void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
>> +void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool exhaustive);

