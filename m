Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC29156D7
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 10:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684319014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eU4/kWoSUy/twutiXTRQkS0LhOrBuJa5CPATWrYQIws=;
	b=RNFgJ+d27j0uFlni1tUPzk3XJM+lQ/QxCblY4AtabMCBtYQtLmSk4zxCG950EALmAWZG8z
	4JOCFn9gs9w2+lxNXEAYNNy12ZVnhY1Es7Zkej4vGj7Ma2JxcJY2e/K8+px1uOU2ScWnVs
	0lIM+4hv6SnehVv8BtsvBdJILasTyF0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-dyfsjo8GMoOB2aa5YHpVjw-1; Wed, 17 May 2023 06:23:31 -0400
X-MC-Unique: dyfsjo8GMoOB2aa5YHpVjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 654643C0CD44;
	Wed, 17 May 2023 10:23:30 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 243804078908;
	Wed, 17 May 2023 10:23:30 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, steven.price@arm.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] arm64: Add missing Set/Way CMO encodings
In-Reply-To: <20230515204601.1270428-2-maz@kernel.org>
Organization: Red Hat GmbH
References: <20230515204601.1270428-1-maz@kernel.org>
 <20230515204601.1270428-2-maz@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Wed, 17 May 2023 12:23:29 +0200
Message-ID: <87wn1745pa.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2

On Mon, May 15 2023, Marc Zyngier <maz@kernel.org> wrote:

> Add the missing Set/Way CMOs that apply to tagged memory.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 6 ++++++
>  1 file changed, 6 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

