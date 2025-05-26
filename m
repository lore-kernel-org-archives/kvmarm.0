Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F84192D87
	for <kvmarm@lists.linux.dev>; Mon, 26 May 2025 12:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748263457; cv=none; b=JzNGU6Y7xCQGXRcJeIJjcY5OzPX2i7I0e+0UzENrXLTMbmBMDczTTHfiFJJD+OcB+/Lf2B1vEziNJmm4V03XOPfprSKD9JIKxHuJVyA+98fOs2/1TPPsJnej93NoVtYn+4zyaWbCq56jm5cccEJlHte2IV5NPUDCarhwEgdAbzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748263457; c=relaxed/simple;
	bh=yTofMcjZMfdrY64T5IBjXPa7UAqDUr1w3T7Wm0DmAqo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OmLuU2y2wgSic0l4vepvKhF7T/qKfqbJPqLByM40uQet0wo3hk9PLwY4zjw5MFMvz26Y5kIDSR6Mg2HcdfZ0dBEDztjajdsfT/Mj4F+KtkJmOehEakSqvp/mvQvps6vzOBUy/KLkBTv50V8EckjWqYbAFqPvdV0E8k2+NS3ti3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aN+lkm1N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aN+lkm1N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748263455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QKPLW6aaHPX36hnLpuBW8AALVcYrg6oBYgcThXgBJw=;
	b=aN+lkm1NCa+nOqTjK7hO7oVajhmmMcILS09u4C54/qeFWfO3Fr0PUz+i3iVrjc72q7K5Wz
	OeTLToJDz7D/p/eE6B6qXo6t0zknyXPF5gFC7/2ACqpM3LiAn2NRCj66p1lcSgvfU4JPaf
	bznV51Q00gEVk3IHeAo5Xt9wQctq84Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-dMj72G03M5yEDm9qF2LNeQ-1; Mon,
 26 May 2025 08:44:11 -0400
X-MC-Unique: dMj72G03M5yEDm9qF2LNeQ-1
X-Mimecast-MFC-AGG-ID: dMj72G03M5yEDm9qF2LNeQ_1748263449
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC4E4180035E;
	Mon, 26 May 2025 12:44:08 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D22FD180049D;
	Mon, 26 May 2025 12:44:06 +0000 (UTC)
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
In-Reply-To: <de7db6bc22ad4f0a8ac1fac718c810a1@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <de7db6bc22ad4f0a8ac1fac718c810a1@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 26 May 2025 14:44:04 +0200
Message-ID: <87bjrfbkyz.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, May 23 2025, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> Hi,
>
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
>> Subject: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
>> host model
>
> [..]
>
> )
>> 
>> Code also available at
>> https://gitlab.com/cohuck/qemu/-/tree/arm-cpu-model-
>> rfcv3?ref_type=heads
>
> I had a spin with the above branch, but Qemu boot fails,
>
> ERROR:../target/arm/cpu64.c:57:get_sysreg_idx: code should not be reached
> Bail out! ERROR:../target/arm/cpu64.c:57:get_sysreg_idx: code should not be reached
>
> From a quick debug, it looks like the below path results in an invalid ID idx.
>
> kvm_arm_expose_idreg_properties()
>  kvm_idx_to_idregs_idx(0)
>   get_sysreg_idx(0xc000)  --> id_register seems to start at 0xc008
>
> Haven't debugged further.
>
> I am running against a 6.15-rc1 kernel after updating the Qemu branch by,
> ./update-aarch64-sysreg-code.sh  path_to_6.15-rc1
>
> Not sure I am  missing anything. Please check and let me know.

Thanks for trying this out; I'll try to re-create this here.
(I think I've messed up those conversion functions often enough...)

