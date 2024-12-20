Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22B51BDAA0
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 16:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734711437; cv=none; b=IaObn2mvpp2y7Id+BWnLILXWooAfk6o33NNb4aiKy6p0FdugMKhC885fmnFTTQTvu5IIslzJnV75dqPHbq4et9J0vRkLNyjPeUlO/qr7erzrucVrg8N6cPag3+9e/tOe1R7GeIw6Dy7Yc+Uhn/p9Kysvgn5SuKpuV4f44MfgEsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734711437; c=relaxed/simple;
	bh=mszzA/qJ728WolpEREiXIsDTbeCEknDTxVpVaI2vk/A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cbfLeGWL+fuW2al9Ze3O6zUMYm2AaHv/sub4pI9kwW13XTC1iyJhcpGwDFf55ZEvafyJfbdy5kj7N1/N5chrN+6ungjlQK+NS8dOJVJUHX+34eUUeG8bpR9cP/j7YjtN394zxqryngb9H4nuhFi8fDSIEDLhwGSlayN03iDxOF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C3MuYbfy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C3MuYbfy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734711434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RwN5A8m4ojC8zocdAFvRxWYXijSSWi5WNEXx5l/wHI4=;
	b=C3MuYbfyWN/Aczv/m+uPrxUy+5qjtxfIVdMQU6Y78exzmpsPqS1n/livPPMpZcSRSIvtXs
	g2NEolaigrXkEUwz3qeSGa4wtPl4utnArwYwqlHJO9rr3wfc7sZ+6L/gtqEIIrRh6VkOg8
	mnwq7oeKjRXEFzA2KMycgGjlx3bTZEA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-208-inbgGH3gNGycdQ_GQQdWKQ-1; Fri,
 20 Dec 2024 11:17:11 -0500
X-MC-Unique: inbgGH3gNGycdQ_GQQdWKQ-1
X-Mimecast-MFC-AGG-ID: inbgGH3gNGycdQ_GQQdWKQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E32571944D32;
	Fri, 20 Dec 2024 16:17:07 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 661581956053;
	Fri, 20 Dec 2024 16:17:05 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Kashyap Chamarthy <kchamart@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, Daniel =?utf-8?Q?P=2E_Berrang?=
 =?utf-8?Q?=C3=A9?=
 <berrange@redhat.com>, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64
 KVM host model
In-Reply-To: <Z2Vak-hbCMaxm-JJ@gezellig>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241206112213.88394-1-cohuck@redhat.com>
 <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
 <Z1qoa8yXscTSAJ9e@redhat.com> <8734it1bv6.fsf@redhat.com>
 <1fea79e4-7a31-4592-8495-7b18cd82d02b@redhat.com>
 <Z2QE9AqZnpGM5sWD@gezellig> <8634ijrh8q.wl-maz@kernel.org>
 <Z2Q2rWj9cV0W_XVq@gezellig> <86zfkrptmj.wl-maz@kernel.org>
 <Z2Vak-hbCMaxm-JJ@gezellig>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 20 Dec 2024 17:17:02 +0100
Message-ID: <87cyhmba81.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Dec 20 2024, Kashyap Chamarthy <kchamart@redhat.com> wrote:

> Related tangent on CPU feature discoverability on ARM:
>
> Speaking of "Neoverse-N1", looking at a system that I have access to,
> the `lscpu` output does not say anything about who the integrator is; it
> only says:
>
>     ...
>     Vendor ID:                ARM
>     Model name:             Neoverse-N1
>     ...
>
> I realize, `lscpu` displays only whatever the kernel knows.  Nothing in
> `dmidecode` either.
>
> Also, it looks like there's no equivalent of a "CPUID" instruction (I
> realize it is x86-specific) on ARM.  Although, I came across a Google
> Git repo that seems to implement a bespoke, "aarch64_cpuid".  From a
> what I see, it seems to fetch the "Main ID Register" (MIDR_EL1) - I
> don't know enough about it to understand its implications:
>
>     https://github.com/google/cpu_features/blob/main/src/impl_aarch64_cpuid.c

My guess is that this is mostly for "we have code that looks for a cpuid
like on x86, let's provide some code on arm that gives something that is
at least somewhat useful."

For "CPU feature discoverability", I don't think that there's any way
other than looking at the actual id registers. It would be nice if you
could at least know that "there are some <unspecified> differences in
features" by comparing MIDR/REVIDR/AIDR, but that's not the case IIRC?

[Anyway, I'm off for the year :)]

