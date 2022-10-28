Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ADA23A3
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 11:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666957060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7oxL0Wn6bgvSdMNJpuJx00jMn03xxj9+wteuUP1B+kQ=;
	b=TghEMDgvRYOSjqvAnSovtlsFOQSg+h7DGRQK480bRrVrrS2SwSk27TBagWVcF6bVI3v0So
	FH53eUhT1wK+6v814k/dlNQQeKk3RQeshtQdic4GI33bcq1oEaRaDQmfhDZhtkW5vfkbAd
	5C7dYM8mwdRdHuimLeBzhNcI4KQmrcA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-TldeBCsyNLa3XMgP1Ho9Qg-1; Fri, 28 Oct 2022 07:37:37 -0400
X-MC-Unique: TldeBCsyNLa3XMgP1Ho9Qg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B925B3C0F67B;
	Fri, 28 Oct 2022 11:37:36 +0000 (UTC)
Received: from localhost (unknown [10.39.193.13])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B09949BB61;
	Fri, 28 Oct 2022 11:37:36 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
In-Reply-To: <20221025160730.40846-1-cohuck@redhat.com>
Organization: Red Hat GmbH
References: <20221025160730.40846-1-cohuck@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Fri, 28 Oct 2022 13:37:34 +0200
Message-ID: <87a65gkwld.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Message-ID: <20221028113734.I52jh-1ix0x4YMM_lrBX75s6ARvna1PWynQCQIlcacE@z>

On Tue, Oct 25 2022, Cornelia Huck <cohuck@redhat.com> wrote:

> KVM/arm64 development is moving to a new mailing list (see
> https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
> kvm-unit-tests should advertise the new list as well.
>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 90ead214a75d..649de509a511 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -67,7 +67,8 @@ ARM
>  M: Andrew Jones <andrew.jones@linux.dev>
>  S: Supported
>  L: kvm@vger.kernel.org
> -L: kvmarm@lists.cs.columbia.edu
> +L: kvmarm@lists.linux.dev
> +L: kvmarm@lists.cs.columbia.edu (deprecated)

As the days of the Columbia list really seem to be numbered (see
https://lore.kernel.org/all/364100e884023234e4ab9e525774d427@kernel.org/),
should we maybe drop it completely from MAINTAINERS, depending on when
this gets merged?

>  F: arm/
>  F: lib/arm/
>  F: lib/arm64/

