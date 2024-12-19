Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6659A1C69D
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734592054; cv=none; b=RHgTU5S3j+RWe/CStfBTW57RPd7UVmEz589LVf59vTlKRO6EOt08gs18TBEbx97z4khnsB7Uv5XLr7qoVlWqEgQoYHUKiR0AOphUCpk60LDCYMyblS6HfoJYiUmk6ErmCJ4vDkvSR0VJTfYZ0KVQlHC+RIGPGklkvs/4mwrXkus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734592054; c=relaxed/simple;
	bh=y/g+DO/frO3gfF6knk4+qz7GxvrSi46KwpPF/fRn7qU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fnOYdgUyP++BL3Fxz3vLFZ+beFPFNxrKY5UFLjbSVnTBnS6vRqt074iRoau8B9VPFeZpr04ezGFY7cnc7haJSxhn5T/3dkC8Vfwi13Z2OhChFj4SVYxrBQTkUbC90a4cuiEFzq2bQKfUK4hp7oqCTqNq7GOa5enmCymSaBEKnbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cd12INHc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cd12INHc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734592051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afzDjWdmHz4qABK1tbadYQM9+9HuRIkAqnVm/boty0o=;
	b=cd12INHct51vLZOGfm8+eWkBcrWisbLMSZgqstERqWojFmyAplfXVRE/IuBfIjC4LTWA02
	eKqOGxg0rjobglNXWJk8bAir6I0tRs/UsbbqCjEyUBl42u2V5EmiBXkBm0tptYQHCN+vLy
	TjAK4O45e0u+q8Iu7dGmevdDANvjcdU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-tzn7NqL_M6-2qMAe-DvrIQ-1; Thu,
 19 Dec 2024 02:07:28 -0500
X-MC-Unique: tzn7NqL_M6-2qMAe-DvrIQ-1
X-Mimecast-MFC-AGG-ID: tzn7NqL_M6-2qMAe-DvrIQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3084B19560B2;
	Thu, 19 Dec 2024 07:07:26 +0000 (UTC)
Received: from localhost (unknown [10.39.192.67])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD44919560AD;
	Thu, 19 Dec 2024 07:07:21 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
 wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
 jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
 linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v4 2/3] KVM: arm64: Introduce hypercall support for
 retrieving target implementations
In-Reply-To: <20241218105345.73472-3-shameerali.kolothum.thodi@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com>
 <20241218105345.73472-3-shameerali.kolothum.thodi@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 19 Dec 2024 08:07:17 +0100
Message-ID: <87o718b17e.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XPE5EYof9D3qhfUN6ybjluG3xr4Sw7wZnJZMLPklwcc_1734592046
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Wed, Dec 18 2024, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> If the Guest requires migration to multiple targets, this hypercall
> will provide a way to retrieve the target CPU implementations from
> the user space VMM.
>
> Subsequent patch will use this to enable the associated errata.
>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  Documentation/virt/kvm/arm/hypercalls.rst | 30 +++++++++++++++++++++++
>  include/linux/arm-smccc.h                 |  7 ++++++
>  2 files changed, 37 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

