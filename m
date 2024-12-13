Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBF91C3BEB
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734106632; cv=none; b=q+MWO4rhkA2du8vmG3mDXmuEvuN9CreB/ZJHHVb1Uf/ezhcEBiTtPgYhNyxSY4/vedYHJb22AiZXftMgLv3FQ4kgGFYSmiNdN59d00XhCz7QwhrGxCdFTK8tfQdS6Y3HVBC7Jdr+Qmbah07p7Ky/OmEH96lG0K+xTscG6WWsAhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734106632; c=relaxed/simple;
	bh=Mc8m+5THX0rGjtXDbtI/W+2S+F4KR+Fo+OyARm9TdeE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FCLuTHvvwwlPFs8fVVnCR1Glr6JenbOKv77IEP4sVJMMarGkeFr4SwqiPtNRdSfzytS/lfQgVkxYggBX3cR4Q+MndLcJ0Wfmky5DvaREByfnnhwzTRKLc9dUhvhhCu3X7BVmgFzf/DvTNcuE21u0Uu67benQVri3FctRuzDdOcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B2ht/sp5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B2ht/sp5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734106629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VCgH5AryLvd0TODvVd649/Xxmtwsd61I9FaTyvDZ7JI=;
	b=B2ht/sp5EXCCTRpL320gF1m2i320OJ2Bp4rD7EVSSSAveb0zdDUesf7d1sSPcSjgFYv6Dv
	fgMXQ9FELq25ahR6MGciwh+TX2iMPyput2eh5wfAnolNtFhU4N5RzhunfW3KPBJ9uUdXEB
	qDvlszp8dGrj4M4OhEkHapmQkulJBRA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-ro4mGKYUP_Gy4kHmZuyYzQ-1; Fri,
 13 Dec 2024 11:17:06 -0500
X-MC-Unique: ro4mGKYUP_Gy4kHmZuyYzQ-1
X-Mimecast-MFC-AGG-ID: ro4mGKYUP_Gy4kHmZuyYzQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 509551955EA1;
	Fri, 13 Dec 2024 16:17:04 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 337F1300FA9C;
	Fri, 13 Dec 2024 16:17:00 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Richard Henderson <richard.henderson@linaro.org>, eric.auger@redhat.com,
 eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org, alex.bennee@linaro.org,
 maz@kernel.org, oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 02/20] arm/cpu: Add sysreg definitions in
 cpu-sysregs.h
In-Reply-To: <bcc5e5a2-91d4-45b3-9f67-d6b49833a3ef@linaro.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241206112213.88394-1-cohuck@redhat.com>
 <20241206112213.88394-3-cohuck@redhat.com>
 <2a83a49b-6863-4fb8-b5de-c3eacf3cdb77@linaro.org>
 <12a2ef7c-0ba3-49d9-9e08-733b8ca6a753@redhat.com>
 <bcc5e5a2-91d4-45b3-9f67-d6b49833a3ef@linaro.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 13 Dec 2024 17:16:58 +0100
Message-ID: <8734ird0cl.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Dec 12 2024, Richard Henderson <richard.henderson@linaro.org> wrote:

> On 12/12/24 11:46, Eric Auger wrote:
>>> Do we really need anything beyond the defined registers, or even the
>>> defined registers for which qemu knows how to do anything?
>> what do you mean by "defined registers". The end goal is to be able to
>> tune any id reg that the kernel allows to write. So I guess we shall
>> encompass more regs than qemu currently handles.
>
> Defined registers as in "have an architected definition".
>
> E.g. there's no need to set any fields in (op0=0 op1=0 crn=0, crm=0, op2=1), because that 
> isn't a defined system register.  It's in id register space sure, and almost certainly 
> RAZ, but there's no call to either set it or represent it within qemu.
>
> Because you're working to a a symbolic command-line interface, with FEAT_FOO, ID_REG.FIELD 
> names, qemu will (be extended to) handle every register named.

Going from the definitions, we have the potential to generate props for
anything that has been named (do we have named registers/fields that are not
architected?) Exposed on the command line are only those register fields
that are actually writable with the current KVM interface (see patch 18.)

I'm still not quite sure how to continue with FEAT_FOO, but I guess
we're still going to need the ID_REG.FIELD names in any case to handle
differences like DIC in CTR_EL0 mentioned elsewhere in this thread.

