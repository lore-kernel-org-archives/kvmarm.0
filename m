Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEB35258
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 10:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684319067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6kCDd/wHVYniWnWaYfQFj8W3J0td+4UsnrwjwgtLZpc=;
	b=JCvY+TrXctuF7SCjgKhLPmaKCrGtfzJFEAq1HG0xrLOx1brymbdcmH+BN95kIPClUf8FFf
	j0NO74KigepetdNc2eA4iwMUN/R1tyc3Mah+A8eRXRwRVi3eHCkiByAwXVXNVhsTLM7BFE
	KAs1GCya+gUTCENYpjNK8V77ZXCFwHA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-lMgLT-zQMsGLAlrxWEDyQQ-1; Wed, 17 May 2023 06:24:21 -0400
X-MC-Unique: lMgLT-zQMsGLAlrxWEDyQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 890AB101A54F;
	Wed, 17 May 2023 10:24:20 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5101E1121314;
	Wed, 17 May 2023 10:24:20 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, steven.price@arm.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Handle trap of tagged Set/Way CMOs
In-Reply-To: <20230515204601.1270428-3-maz@kernel.org>
Organization: Red Hat GmbH
References: <20230515204601.1270428-1-maz@kernel.org>
 <20230515204601.1270428-3-maz@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Wed, 17 May 2023 12:24:19 +0200
Message-ID: <87ttwb45nw.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

On Mon, May 15 2023, Marc Zyngier <maz@kernel.org> wrote:

> We appear to have missed the Set/Way CMOs when adding MTE support.
> Not that we really expect anyone to use them, but you never know
> what stupidity some people can come up with...
>
> Treat these mostly like we deal with the classic S/W CMOs, only
> with an additional check that MTE really is enabled.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

