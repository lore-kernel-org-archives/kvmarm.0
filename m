Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC56E1FECBE
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 12:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737982245; cv=none; b=qM/yyeGAYpXvcnq/1P0XTYsBV9qYdmYmbmVGIzwhj3JVEXwgwHfgmZKU/iM2ZoZuSLeH+nk6hTl4nh84UsXewmLrfkUrgZcutuPXR12Rc48UaGDfMLW3MB/MKG1g38TGW4NeIALyaCbmtfaoicoQTRThz/UAL1q+GhQzznhEdF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737982245; c=relaxed/simple;
	bh=FCqfs1i898HbQvpOy9M2d5SsLkYf7BHj/YAb8VN/Kpo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gZ08mv5gKTBQu0Dd8Vm7F2W9IKipWsBVKa0QYPrJD0jPWtIuZ72LCdfNJ0QmrIjpZidVvLUdNh1IUPF18G8Wbc2zDOYlsMPhJuzDV3F8UmG2hgppVnb1OalhDnxXReH0wVXzbM4y0btZOWFO/6sxQbottl+3xv3J88Ti0iSziFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hLy7qNK9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hLy7qNK9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737982242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fxX+mEqKJD0CHD6qtOyAAeaxEGqT+AqliDTEYbLd0Ro=;
	b=hLy7qNK9P7AyNhkUE+QTLtnRQIcA0NQm7g5GqvxMOblZJib6VPVPwvuO9U12zVw+FCjXQd
	tiDpFQipZ2BwxajAG7lnT9kaHGaOs3H3KMpIBS67cj1qC/HwDyNJBWr2P/aDK1S7cbxGex
	LwUpV6uqiCPwkBiu1pfsKx1xurEGc/U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-7x30Q1uBOwWnTcmbkIgsxw-1; Mon,
 27 Jan 2025 07:50:36 -0500
X-MC-Unique: 7x30Q1uBOwWnTcmbkIgsxw-1
X-Mimecast-MFC-AGG-ID: 7x30Q1uBOwWnTcmbkIgsxw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3B0919560B0;
	Mon, 27 Jan 2025 12:50:33 +0000 (UTC)
Received: from localhost (dhcp-192-212.str.redhat.com [10.33.192.212])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26AAE195608E;
	Mon, 27 Jan 2025 12:50:31 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
 wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
 jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
 linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v5 2/4] KVM: arm64: Introduce hypercall support for
 retrieving target implementations
In-Reply-To: <20250124151732.6072-3-shameerali.kolothum.thodi@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
 <20250124151732.6072-3-shameerali.kolothum.thodi@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 27 Jan 2025 13:50:29 +0100
Message-ID: <87zfjc7756.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KU2qvGFvpr5UCsF2mX5dbMiDSLDXQoNvqoKF1tMwQ5Q_1737982234
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Fri, Jan 24 2025, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> If the Guest requires migration to multiple targets, these hypercalls
> will provide a way to retrieve the target CPU implementations from
> the user space VMM.
>
> Subsequent patch will use this to enable the associated errata.
>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  Documentation/virt/kvm/arm/hypercalls.rst | 59 +++++++++++++++++++++++
>  include/linux/arm-smccc.h                 | 15 ++++++
>  2 files changed, 74 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

