Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BDA372EDE
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 11:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781867206; cv=none; b=iFbtBak89hxAzxBLvrIIauRn4fJ2MQK7+HXlGc2aVuPWGGr3Sit0Jp18fro+2amN5T+dbwQABrq2wTis6CAXAMgWQUDIiIZeOLV5BinXmnW3+JxLxRMUGAs/6dvq60mgFNkPLAIc8FSPOM47yXb41K915nvQvhE6nBbFYtdFcpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781867206; c=relaxed/simple;
	bh=6Ftuz/YeU1BrVwtz+GOmCT6y76opWKn1nUdh59yxKwg=;
	h=From:References:MIME-Version:In-Reply-To:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eVEMRZtfb+K/c9NS5+WxMh3g1/R6G/zBBUUDFyj4pkNqRQZehPIZqysktrgdBSmMcga2Yl3eGl3WKB0dp1scP17t2gnSeFT7CDJiJ6o+OAyXZfSj7pIk9V307qW3uRsATYrAX0U2LTT7NUslUKLxlpA47geMlR9F0JmeCzmKb2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eS65jval; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eS65jval"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781867203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Ftuz/YeU1BrVwtz+GOmCT6y76opWKn1nUdh59yxKwg=;
	b=eS65jval0Kqm4UMf9Wd4JljzQIxx976tPJd2C7ndeJZzfUUvkkVPyt8B3yNsVTaGTvpdiY
	Nqso0Ur+anPFfDjKoJX13Y89uXKKGX5E93++owmLZR86ZoSkkG+VXkTehypVh5ueGHzjWJ
	+H00ardAzusCabxDodYeouQf0BxhOLI=
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com
 [74.125.82.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-4p7igXWxMAK9qYZSrRSjGw-1; Fri, 19 Jun 2026 07:06:41 -0400
X-MC-Unique: 4p7igXWxMAK9qYZSrRSjGw-1
X-Mimecast-MFC-AGG-ID: 4p7igXWxMAK9qYZSrRSjGw_1781867200
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30bcb065bfdso3583205eec.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 04:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781867200; x=1782472000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Ftuz/YeU1BrVwtz+GOmCT6y76opWKn1nUdh59yxKwg=;
        b=ogRDQpzwl1uF6b8yyRpU7Gi/Sex+AEo1y9FCuAdWK+9c47DZov6J2WIeb3JmchgpVz
         iE7+Mdw3rdDXQHvG8lRb7C0j2tRm/ieQA+Da+Aw9A2SxVpTtrbOFjqemAS++otEwK68v
         SVbTE9E5q5h4aq2GkhOYyBX3NxYQfXGAMjleWM/NqP+rs42vLfKGtwP7dyRwNWZEIZd4
         oamCthhyiJuCCu4mm+EZFEV+SpXWgZZXZt0ocCXNTQtjnPoONhD+F13uUxgiar9CRmYN
         s0rm82weC1TiXg/aMI724s+HQdevEkJeaZHqV+q9xYbeiRVu7EmYIhc4CEjluBl2c7d4
         Uhgg==
X-Forwarded-Encrypted: i=1; AFNElJ8T1LlS8fXSUz81YUEGuKVi7cujGPJMOfDaD4EFKSXfwMnKCph67YgsH+51agpOEAikRewifEs=@lists.linux.dev
X-Gm-Message-State: AOJu0YycGquRq9NTij3JVsvmfcea4Of/RAUGp+u2pxxebjYC884GwXLo
	ChiL2L31W8WIbPJo7orU8GT2imG1p4RhQ6XHU4HEiqFKDZQX8iTa40YtLdT0nWJ4yot23Ksaykw
	OHlWrKPV3lg9HLEXRv69knmG8uXjokYDMv5kERc+k9W7ROVSoY+D+RJxCb34tZfho/t7ujAnnGr
	D6ztH1Xwptqz+bSxo8J02wf7QIwiHRZzSG
X-Gm-Gg: AfdE7cnjBvLSoSbEaB6SBtI/YdkZAXu4cSxz5mqF4lz0Mby/ztXOb73CxB457FnMm5X
	20nie8O95PjrRVaVydjTHMgxL67SKvtruK5VfoDDxjojcebg7IMelXdE187mZ0FjntHjie0Jx+C
	HWcLzBXMjOAiedsaRijP37Txrfts62b67Iwa5DSUvs9g0c87+k7+JeBMF7IHOrMQgm
X-Received: by 2002:a05:7300:6c84:b0:304:e587:5063 with SMTP id 5a478bee46e88-30c0cff485dmr989881eec.12.1781867200319;
        Fri, 19 Jun 2026 04:06:40 -0700 (PDT)
X-Received: by 2002:a05:7300:6c84:b0:304:e587:5063 with SMTP id
 5a478bee46e88-30c0cff485dmr989854eec.12.1781867199837; Fri, 19 Jun 2026
 04:06:39 -0700 (PDT)
Received: from 744723338238 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 19 Jun 2026 04:06:37 -0700
Received: from 744723338238 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 19 Jun 2026 04:06:37 -0700
From: Andrea Bolognani <abologna@redhat.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
 <20260605083358.1320563-24-khushit.shah@nutanix.com> <ajURCGaS94gwV_px@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ajURCGaS94gwV_px@redhat.com>
Date: Fri, 19 Jun 2026 04:06:37 -0700
X-Gm-Features: AVVi8CcvxopmE1LAhLJ_P5FoKxGosYvlKzKbEpZomnc1BklIe0Caltb9vqbh-Ec
Message-ID: <CABJz62PatHBE1pvgqw=asZgugOE3L5oMsEgj==Qp4ZnyHWhLkw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 23/29] target/arm/qmp: add query-arm-cpu-props-info
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	kvmarm@lists.linux.dev, Eric Auger <eric.auger@redhat.com>, 
	Cornelia Huck <cohuck@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, 
	Richard Henderson <richard.henderson@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Jiri Denemark <jdenemar@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Shameer Kolothum <skolothumtho@nvidia.com>, 
	Sebastian Ott <sebott@redhat.com>, Markus Armbruster <armbru@redhat.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Jinqian Yang <yangjinqian1@huawei.com>, Shaju Abraham <shaju.abraham@nutanix.com>, 
	Mark Cave-Ayland <mark.caveayland@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8-KqXjZEH2rp2jRgZJHgq-UoAL8bzPXADcqUXXtC8z8_1781867200
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2026 at 10:51:04AM +0100, Daniel P. Berrang=C3=A9 wrote:
> On Fri, Jun 05, 2026 at 08:33:52AM +0000, Khushit Shah wrote:
> > Introduce 'query-arm-cpu-props-info' QMP command. This command returns
> > information about ARM CPU model properties, including their name, type,
> > supported values on the given host, and composite parent if any.
>
> Do we have to make this ARM only ?
>
> x86 has named CPU properties too. They are all basically
> booleans so this API offers a superset of functionality
> needed for x86, and thus I'd expect x86 to be folded into
> this new API too.

riscv64 will certainly need something like this too in due time.
So +1 to making it architecture-agnostic.

--=20
Andrea Bolognani / Red Hat / Virtualization

