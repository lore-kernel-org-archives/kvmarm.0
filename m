Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C0B156677
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748340432; cv=none; b=KIeOLNvR6EK6VvjRmFcyrvZqVeY0oEQ36bZS9L6UAiEKds0h54/seQ4Iw1x6pVhZO18+RRVPEh4l3uZrmVFv6ZidoRzyO8BhX7Xt/tTPy01Y1Gck1/y5XB5NW98BYvR8YYPJ0eTrcCElnlF7PbJfBXLcE+UuCnJSKOfAcd5VtTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748340432; c=relaxed/simple;
	bh=bJt9Y139wAjgWYetRTOgDebXm93m+9iO8Amy7sM1cPM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Gn1umYjbP0ekvzgNAae1eMx4vArJqsRTNULWy0tN00JkYJ03CftAxCjKCWa+A+IGoRvqtXjESJKW+eiBVheu1i5dw/OmtBxtcZl6QZaqG+Ip6C4YTIQ0ri2XfzsUbuuVTGidNYejNT8Ckyidu5XM4ldkIS9YRlOenNBHdZAAif0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b6kVTcTs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b6kVTcTs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748340429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HknLfGhWrCtmGXx/VCFJmPd/NUIKIcmMxx6r3LCgYjI=;
	b=b6kVTcTso6aMvbSLLtobCUh3ODl0mtn272OgTgK3VCZLVCEe0bufo5QE6PDisFpW0x1qbW
	rNk/JeY5F7idDC7iFWhIJMapW4p/9ytyJNVp4YeaLn8imCNcyC2AXYKwlIBUdwBU47GemF
	wRPInDaPlt4lw79jAR57BRQM8eIk1as=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-4AEKlbMTN5ObR0CfXOENTQ-1; Tue,
 27 May 2025 06:07:05 -0400
X-MC-Unique: 4AEKlbMTN5ObR0CfXOENTQ-1
X-Mimecast-MFC-AGG-ID: 4AEKlbMTN5ObR0CfXOENTQ_1748340424
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D94B180036F;
	Tue, 27 May 2025 10:07:02 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B217630001A1;
	Tue, 27 May 2025 10:06:59 +0000 (UTC)
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
Subject: RE: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
 host model
In-Reply-To: <87bjrfbkyz.fsf@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <de7db6bc22ad4f0a8ac1fac718c810a1@huawei.com> <87bjrfbkyz.fsf@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 27 May 2025 12:06:57 +0200
Message-ID: <878qmibc5a.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, May 26 2025, Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, May 23 2025, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
>
>> Hi,
>>
>>> -----Original Message-----
>>> From: Cornelia Huck <cohuck@redhat.com>
>>> Sent: Monday, April 14, 2025 5:39 PM
>>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>>> alex.bennee@linaro.org; maz@kernel.org; oliver.upton@linux.dev;
>>> sebott@redhat.com; Shameerali Kolothum Thodi
>>> <shameerali.kolothum.thodi@huawei.com>; armbru@redhat.com;
>>> berrange@redhat.com; abologna@redhat.com; jdenemar@redhat.com
>>> Cc: agraf@csgraf.de; shahuang@redhat.com; mark.rutland@arm.com;
>>> philmd@linaro.org; pbonzini@redhat.com; Cornelia Huck
>>> <cohuck@redhat.com>
>>> Subject: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
>>> host model
>>
>> [..]
>>
>> )
>>> 
>>> Code also available at
>>> https://gitlab.com/cohuck/qemu/-/tree/arm-cpu-model-
>>> rfcv3?ref_type=heads
>>
>> I had a spin with the above branch, but Qemu boot fails,
>>
>> ERROR:../target/arm/cpu64.c:57:get_sysreg_idx: code should not be reached
>> Bail out! ERROR:../target/arm/cpu64.c:57:get_sysreg_idx: code should not be reached
>>
>> From a quick debug, it looks like the below path results in an invalid ID idx.
>>
>> kvm_arm_expose_idreg_properties()
>>  kvm_idx_to_idregs_idx(0)
>>   get_sysreg_idx(0xc000)  --> id_register seems to start at 0xc008
>>
>> Haven't debugged further.
>>
>> I am running against a 6.15-rc1 kernel after updating the Qemu branch by,
>> ./update-aarch64-sysreg-code.sh  path_to_6.15-rc1
>>
>> Not sure I am  missing anything. Please check and let me know.
>
> Thanks for trying this out; I'll try to re-create this here.
> (I think I've messed up those conversion functions often enough...)

The conversion functions are not at fault here, but we're missing
registers. If we have MIDR and friends writable, they show up in the
masks returned by the kernel, but they are not present in the kernel's
sysreg file where we generate our definitions from, and
kvm_idx_to_idregs_idx() asserts instead of returning an error, which is
kind of suboptimal...

So I see two possible ways to fix this:
- add MIDR and friends to the kernel's sysreg file
- add MIDR and friends in QEMU's cpu-sysregs.h.inc file, and only append
  generated definitions there

First option means one more round trip, second options has more
potential for messing things up if we keep stuff local to QEMU.

