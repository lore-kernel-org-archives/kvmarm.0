Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5D8321E
	for <kvmarm@lists.linux.dev>; Thu,  9 Mar 2023 09:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678352881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BRkepo0G/I/dl+YsBNN3SwCHdTMQGfCSCw0ryRI4zAQ=;
	b=auwWb8nb/zOlw18gx/k7PBVIynJhiQlj6TwUrWhM6Uf1FGCcE9KSfSp3uEnUP1g0kvI+FK
	gRU0efdlTD/fTor0wTp5euUmD/h1f6FHAQuNOP1JTKkFCn9ePtyGuMeDoB72o9bLtQu/g2
	3X3WLbQZJ2a8d5WdoAtdnRh6SkIwv8Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-ql9adJ74OfOzsDV8rSQOOA-1; Thu, 09 Mar 2023 04:07:58 -0500
X-MC-Unique: ql9adJ74OfOzsDV8rSQOOA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 155BC2807D69;
	Thu,  9 Mar 2023 09:07:58 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA9C51121314;
	Thu,  9 Mar 2023 09:07:57 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver
 Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] KVM: selftests: Add coverage of MTE system registers
In-Reply-To: <20230308-kvm-arm64-test-mte-regs-v1-1-f92a377e486f@kernel.org>
Organization: Red Hat GmbH
References: <20230308-kvm-arm64-test-mte-regs-v1-1-f92a377e486f@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Thu, 09 Mar 2023 10:07:56 +0100
Message-ID: <878rg6jnrn.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

On Wed, Mar 08 2023, Mark Brown <broonie@kernel.org> wrote:

> Verify that a guest with MTE has access to the MTE registers. Since MTE is
> enabled as a VM wide capability we need to add support for doing that in
> the process.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 33 ++++++++++++++++++++++
>  1 file changed, 33 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

