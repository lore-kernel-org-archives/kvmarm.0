Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262909461
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 09:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695290189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=euGyxfvn6xH67AeWq/hogwCBGT3EWUuZanu0YmGfM6A=;
	b=CpMbkW+iFMGeokbNfWVTauwniEWDd2oLFwpaChJJ0Kyfl/s1xQBO6g8WYP22ohQdIUTi65
	6wVUCk6FSOvUPFMsuTgHr4tYD8Pc9djds/k42d4VbrJPaurmp4lOxKQaTireDjk4TrwVOu
	LL6xumZArsl0fp9Edrq108ZeP/5VhXU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-O0vRPV8IM2eUicDLLTfj6Q-1; Thu, 21 Sep 2023 05:56:25 -0400
X-MC-Unique: O0vRPV8IM2eUicDLLTfj6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40E16811E94;
	Thu, 21 Sep 2023 09:56:24 +0000 (UTC)
Received: from localhost (unknown [10.39.195.13])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0448E51E3;
	Thu, 21 Sep 2023 09:56:23 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui
 Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Jing Zhang
 <jingzhangos@google.com>
Subject: Re: [PATCH v10 02/12] KVM: arm64: Document
 KVM_ARM_GET_REG_WRITABLE_MASKS
In-Reply-To: <20230920183310.1163034-3-oliver.upton@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
 <20230920183310.1163034-3-oliver.upton@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Thu, 21 Sep 2023 11:56:22 +0200
Message-ID: <871qer26k9.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5

On Wed, Sep 20 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> From: Jing Zhang <jingzhangos@google.com>
>
> Add some basic documentation on how to get feature ID register writable
> masks from userspace.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 43 ++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

