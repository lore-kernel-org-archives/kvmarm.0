Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EE121644E
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 13:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728652674; cv=none; b=e+cDmz/591lya1UEdujMWtaWRAbpf9IwBVvltYKXsUpfhdxph9Ycc49U2FqrRew1kQSvfT9mgvXSRyReufpDhn+5y6CRQAOMBRZz9xMQx1Lr4whS2B0QnuEMiRokCHs/8nalCdYmD3pO/7Bp7sF21PSKcjh7Q3WFfbEARFqziyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728652674; c=relaxed/simple;
	bh=PzbHYT+r+LlIimh4ZmLISHrTUCc3ei/OLb6mIQlprTE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GRyGPhAcUcvx7f33hB+fWp1TncOGM6pIoj6g+lPpzMnNmBv7bSx56uOleaCCfP7lj97FAoqngTodmhRUTjuoiW6+T8eaMf7TXtbTopoYWsd6weiLTTneg5IlOG7xigNo+xIQtdAwHl4oJ6XwAMchnlLGGIeeQrQ7zOyi3hQc4AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UqZCB9GB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UqZCB9GB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728652672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8Kbxyl/M4BFxeV3rqd0HGiWKMPxu8TepjKDEI/Trb5E=;
	b=UqZCB9GBUUSUXcApnWGcz/YkXOdbDzcpCCetumP3BvxGj0i+Y1dMmsfYIKbVM6AHcApaeY
	MLtsQDDIH5NHREcq/EQxSC9D1gOm/G0zreCvwTZzAHn0sUkron/vaLxV3Zi4kccgbri6Q3
	itaklsD9u6cmyTQVl+Bas+5LrkqHGQU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-379-N8rLqyR8OUC8mYCJ08fZIQ-1; Fri,
 11 Oct 2024 09:17:48 -0400
X-MC-Unique: N8rLqyR8OUC8mYCJ08fZIQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 831E91956096;
	Fri, 11 Oct 2024 13:17:45 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5077919560AA;
	Fri, 11 Oct 2024 13:17:42 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 eric.auger@redhat.com, yuzenghui@huawei.com, wangzhou1@hisilicon.com,
 jiangkunkun@huawei.com, jonathan.cameron@huawei.com,
 anthony.jebson@huawei.com, linux-arm-kernel@lists.infradead.org,
 linuxarm@huawei.com
Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
In-Reply-To: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 11 Oct 2024 15:17:40 +0200
Message-ID: <87jzeerd6z.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Fri, Oct 11 2024, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Hi,
>
> On ARM64 platforms most of the errata workarounds are based on CPU
> MIDR/REVIDR values and a number of these workarounds need to be
> implemented by the Guest kernel as well. This creates a problem when
> Guest needs to be migrated to a platform that differs in these
> MIDR/REVIDR values even if the VMM can come up with a common minimum
> feature list for the Guest using the recently introduced "Writable
> ID registers" support.
>
> (This is roughly based on a discussion I had with Marc and Oliver
> at KVM forum. Marc outlined his idea for a solution and this is an
> attempt to implement it. Thanks to both and I take all the blame
> if this is nowhere near what is intended/required)
>
> This RFC proposes a solution to handle the above issue by introducing
> the following,
>
> 1. A new VM IOCTL,
>    KVM_ARM_SET_MIGRN_TARGET_CPUS  _IOW(KVMIO,  0xb7, struct kvm_arm_migrn_cpus)
>    This can be used by the userspace(VMM) to set the target CPUs the
>    Guest will run in its lifetime. See patch #2
> 2. Add hypercall support for Guest kernel to retrieve any migration
>    errata bitmap(ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_ERRATA)
>    The above will return the bitmaps in R0-R3 registers. See patch #4
> 3. The "capability" field in struct arm64_cpu_capabilities is a generated
>    one at present and may get renumbered or reordered. Hence, we can't use
>    this directly for migration errata bitmaps. Instead, introduced
>    "migartion_safe_cap", which has to be set statically for any
>    erratum that needs to be enabled and is safe for migration
>    purposes. See patches 3 & 6.
> 4. Rest of the patches includes the plumbing required to populate the
>    errata bitmap based on the target CPUs set by the VMM and update the
>    system_cap based on it.
>
> ToDos:-
>   -We still need a way to  handle the error in setting the invariant
>    registers(MIDR/REVIDR/AIDR) during Guest migration. Perhaps we can
>    handle it in userspace?
> -  Possibly we could do better to avoid the additional "migartion_safe_cap" use.
>    Suggestions welcome.
>   -There are errata that require more than MIDR/REVIDR, eg: CTR_EL0.
>    How to handle those?
>   -Check for locking requirements if any.
>
> This is lightly tested on a HiSilicon ARM64 platform.
>
> Please take a look and let me know your thoughts.

So, I've only taken a very quick look at it, but IIUC, the idea is for
the VMM to do the following:
- figure out where we want to possibly run
- figure out the least common denominator for writable features
- tell KVM about the possible target cpu resp. the errata it wants
- build a frankencpu via the writable id reg infrastructure, fiddling
  with invariant handling as needed?

(Sorry, it's late in the week :)

