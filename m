Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41631B011B
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 15:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898129; cv=none; b=fyjN2XyosDcEhY3n2Bm1mLUdq5SqbtDfwvmBBV+41qfNUq8VuCFzlo/ER/jNpO/q3BCfkmjs/iK4+cJwawl6y4EChvacvYbSrvJeLNFBouI7im6/ZpnBL5J7ZCG8g//nO/kiZ10D8I/43ZJYUALOVCyAIkDGn6OyRu/doPIu38Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898129; c=relaxed/simple;
	bh=WXDyiIOVolAmzJbYyxk8eS5y+XK8OPN0eXXBY4rQ97I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=R2251VyqYuFG8YHUvQfmuGvPziuH8E+ZHOp5DEOtVbsNdcpmTqtUwDM4+DnyYj6IgsrBeuHRn8hBJ2/voswhP5bxp/8RcZJYfLRAR0/kJVtRJ6QAeexpbcgwaUO9oiT+gFagW2yHypwP0RrlkWhzROlCRZOReh3EMfUqsAf3B5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=axqeHxn2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="axqeHxn2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718898126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WXDyiIOVolAmzJbYyxk8eS5y+XK8OPN0eXXBY4rQ97I=;
	b=axqeHxn2WufrlkKoZNBT/hfpeKeXociAfumsjBjWGvuQ573tl6i8RBL9OTqQEFjf783FDV
	GS+CEh+/M0Jsj11GafOnXiCx8FB9fYhVB6ZaVgIfnMrE4mTthGWfW+qG8XNT1zQhto6SIy
	bD3XSInz1MGhyu0R37IMaPeNQ2JifCs=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-co6RQQpWMpq3eH2xX8entQ-1; Thu, 20 Jun 2024 11:42:02 -0400
X-MC-Unique: co6RQQpWMpq3eH2xX8entQ-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-25cb4261a5cso952666fac.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 08:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718898122; x=1719502922;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WXDyiIOVolAmzJbYyxk8eS5y+XK8OPN0eXXBY4rQ97I=;
        b=AjfrAONag8tHkM17q47VsPOtFFI0gVDVxiUQv8EeJjDub4oYh9EGb4mytLiD0d1tWx
         Wl3Sgau5kUhXXkRIdoZ0UHGA52IHEWZz5SBtjeJxgNNao6oaexT0vGeYoDpgYFlmjidq
         BGrFdu9QgcCmEJliUeDhGlsK0gLAM/tc83FgAnWRCXvUk2YmX2B0RLkBSjGY4jYQtKkx
         Hgpko55p7m3vX2kZDEFeJjReQbpew8pgBK/BlpTtI/MDmBsrB1ueRjjzodmMnkZEmK6f
         kpxNayRng9v9hWSmsh8YMSTNey/zIbgOUCJncphDCqwGP1/V+3N5koD7v6bxdRe9ai2m
         wC4g==
X-Gm-Message-State: AOJu0Yxz1wr8msy8HSxsGtb5WcvMbcAMZ0yh4zl8SxzJqSULM52m/VaH
	m3ghFdl+SyUVUpMj4g6NGym/Dlbf1w7G4hzmXu1Wr5eW0Hz1pjvD4eeBPogRFrjY6XLKLFCWMxt
	hAA7jaaMzA/eqvSRguRrOzztLUx9qVFK7o16OBWy2HanjIkP8yFmHPw==
X-Received: by 2002:a05:6870:8a29:b0:255:2cc6:db59 with SMTP id 586e51a60fabf-25c949a4384mr5206987fac.22.1718898122115;
        Thu, 20 Jun 2024 08:42:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECy6MpJCSL34r6nqz7WxiddHs20IWVB6NF5jm95VxIJO0blWdQ6yaWxoYzVB9pkyUlpr0yUA==
X-Received: by 2002:a05:6870:8a29:b0:255:2cc6:db59 with SMTP id 586e51a60fabf-25c949a4384mr5206973fac.22.1718898121823;
        Thu, 20 Jun 2024 08:42:01 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79a4f164806sm435245285a.93.2024.06.20.08.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:42:01 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:41:57 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v5 02/10] KVM: arm64: Make idregs debugfs iterator search
 sysreg table directly
In-Reply-To: <20240619174036.483943-3-oliver.upton@linux.dev>
Message-ID: <ea451852-b6e2-4304-4ae8-bc51bb4030b7@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <20240619174036.483943-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 19 Jun 2024, Oliver Upton wrote:
> CTR_EL0 complicates the existing scheme for iterating feature ID
> registers, as it is not in the contiguous range that we presently
> support. Just search the sysreg table for the Nth feature ID register in
> anticipation of this. Yes, the debugfs interface has quadratic time
> completixy now. Boo hoo.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

