Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFFA20E716
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734014843; cv=none; b=SzYn9Ifh+hFD2I/9FhfCS0b8lBkDV1z7Elw/KYqnE8RKkpNBOTgGX+Km4zGtDQyiOwMZFd3cSL0jODk6qaaTomMGR4R4BLIBvmw/3gR2ZjIC+SF9EWvnIooUYN28h53kL1k2RTWvQw9l49bbG8cOIary1s8h1SxXoHwG6kgJ5B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734014843; c=relaxed/simple;
	bh=3j9h0iq5MwP7mYNSIfQfxbzT5cPytaeJ4W51ylLBJAk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GDoPjzfAeJUDDkvlzIC2qQsewIkCZv8gqor0VGNGTkrS+nznzML3LUzkClBGtzxiVK0ZwNFMHalQ9/yEQlycl7VwyPJznwvgElFP0hYd6RuABaYOOcEFqVS8UClhfYFW9hNqD/3N56BvOE4iaiomyLMQZ8ubdihCv0pTCZIg+1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gkmkX4p2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gkmkX4p2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734014840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QNyu7PrLKlSrIw3AX5TXyxxmoYr6/tZMz1aY7e1v5Yc=;
	b=gkmkX4p2XT1+Xx2uejhMUtFH4GL/qOyKOP1DW41Wuc+lGDljqt8KvDOwbBv5vyhp8W3LO7
	INoVDLjQ19V51TLXLbn9KiMVrLd1U8Yx4JXrTblbsuK+IOLgPk+gQO78w7CIenMbuxclB4
	9d97G/3fDd3CANHUPLfIGnhG9fCvHzU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-jpxLElgtPm6A4DdBYkvaPw-1; Thu,
 12 Dec 2024 09:47:18 -0500
X-MC-Unique: jpxLElgtPm6A4DdBYkvaPw-1
X-Mimecast-MFC-AGG-ID: jpxLElgtPm6A4DdBYkvaPw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 096A2195606D;
	Thu, 12 Dec 2024 14:46:59 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFF8F300FA97;
	Thu, 12 Dec 2024 14:46:57 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Sebastian Ott <sebott@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64
 KVM host model
In-Reply-To: <90431f60-e366-50e9-e95e-2ec9c6812056@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241206112213.88394-1-cohuck@redhat.com>
 <90431f60-e366-50e9-e95e-2ec9c6812056@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 12 Dec 2024 15:46:55 +0100
Message-ID: <878qslc61s.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Dec 12 2024, Sebastian Ott <sebott@redhat.com> wrote:

> On Fri, 6 Dec 2024, Cornelia Huck wrote:
>> A respin/update on the aarch64 KVM cpu models. Also available at
>> gitlab.com/cohuck/qemu arm-cpu-model-rfcv2
>>
>> Find Eric's original cover letter below, so that I do not need to
>> repeat myself on the aspects that have not changed since RFCv1 :)
>>
>> Changes from RFCv1:
>>
>> Rebased on more recent QEMU (some adaptions in the register conversions
>> of the first few patches.)
>>
>> Based on feedback, I have removed the "custom" cpu model; instead, I
>> have added the new SYSREG_<REG>_<FIELD> properties to the "host" model.
>> This works well if you want to tweak anything that does not correspond
>> to the existing properties for the host model; however, if you e.g.
>> wanted to tweak sve, you have two ways to do so -- we'd probably either
>> want to check for conflicts, or just declare precedence. The kvm-specific
>> props remain unchanged, as they are orthogonal to this configuration.
>>
>> The cpu model expansion for the "host" model now dumps the new SYSREG_
>> properties in addition to the existing host model properties; this is a
>> bit ugly, but I don't see a good way on how to split this up.
>>
>
> I gave this a spin today and successfully migrated a VM between 2 similar
> machines that only differ in the DIC bit of the cache type register using:
>
>  	-cpu host,SYSREG_CTR_EL0_DIC=0
>
> This allows me to get rid of my horrid qemu hacks to achieve the same.

Great, thanks for testing!

