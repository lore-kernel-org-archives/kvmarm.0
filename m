Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8338944C
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 09:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695290032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oScJ/a+uhztebC1q0641Ww8fqQPACYFLZgqPLc3dXRQ=;
	b=VPvUMOtQ3o8k3Mb72Zeg93+697X/IGTNbvzjeqJLDzhCYdy7knkFnpZbw+9m5QyVv2EYCo
	dQluD1zHOuTuWSL1YRJCxT6Diw2iW3ge7A2lIOyV0I5uF6bZAzHtcmwGkmtLzIVVOgbpPY
	DTq5zytitwGLKYrxkVoaa7RDNK5cVGc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-Po7R4gYgN1mHDmaUmTvJ-g-1; Thu, 21 Sep 2023 05:53:44 -0400
X-MC-Unique: Po7R4gYgN1mHDmaUmTvJ-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 301683C02545;
	Thu, 21 Sep 2023 09:53:43 +0000 (UTC)
Received: from localhost (unknown [10.39.195.13])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C84F840C2010;
	Thu, 21 Sep 2023 09:53:42 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Jing Zhang
 <jingzhangos@google.com>
Subject: Re: [PATCH v10 01/12] KVM: arm64: Allow userspace to get the
 writable masks for feature ID registers
In-Reply-To: <20230920183310.1163034-2-oliver.upton@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
 <20230920183310.1163034-2-oliver.upton@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Thu, 21 Sep 2023 11:53:41 +0200
Message-ID: <874jjn26oq.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

On Wed, Sep 20 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> From: Jing Zhang <jingzhangos@google.com>
>
> While the Feature ID range is well defined and pretty large, it isn't
> inconceivable that the architecture will eventually grow some other
> ranges that will need to similarly be described to userspace.
>
> Add a VM ioctl to allow userspace to get writable masks for feature ID
> registers in below system register space:
> op0 = 3, op1 = {0, 1, 3}, CRn = 0, CRm = {0 - 7}, op2 = {0 - 7}
> This is used to support mix-and-match userspace and kernels for writable
> ID registers, where userspace may want to know upfront whether it can
> actually tweak the contents of an idreg or not.
>
> Add a new capability (KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES) that
> returns a bitmap of the valid ranges, which can subsequently be
> retrieved, one at a time by setting the index of the set bit as the
> range identifier.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

<process>I think you need to add your s-o-b here.</process>

> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +
>  arch/arm64/include/uapi/asm/kvm.h | 32 +++++++++++++++
>  arch/arm64/kvm/arm.c              | 10 +++++
>  arch/arm64/kvm/sys_regs.c         | 66 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  2 +
>  5 files changed, 112 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

