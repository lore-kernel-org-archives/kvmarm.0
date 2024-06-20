Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3633171A5
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 15:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898400; cv=none; b=LWhpN1NdVBU79eljn1PxjiHXlH/5HQh+a7VsMBzEk5SGgxtKP0e6Ppowo4TjoExhiF2EVmogquZgI9qaq6G94FBfvvBqvfQ019F1T8Nu9IPMNyUJgYpr4qDi/3aaDdNjzA9ZHP+jbxLLdwvHdI1mStx2ZR4GGdtG8XTvNel2YNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898400; c=relaxed/simple;
	bh=uF6C7gHFKrkBYo6xSl1ge0QDwxr5Plvds6Mu7amm89o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OE61x4o4EES1tfCAhQrpZ0pr4jW5B0hSE8SUW/n8cuqtXnehQUlvvoMTGuxxhfQjKS1uJjKJoUlYd9wQErxoktNG7zhHfoW97lrUS2DNe5xn17rH2V107lvr5fscuMAju/9SCIsrD3O/feSQSvI+X6XehFpCnzg7yRJKRRgc/FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L5XYUSCI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L5XYUSCI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718898397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uF6C7gHFKrkBYo6xSl1ge0QDwxr5Plvds6Mu7amm89o=;
	b=L5XYUSCIodJqaWX4vtCb0VpI6f+Bef7StQ7A/yJj4VH8M+k7HqPM0A1i5pFLtktAh7e3p/
	TQOTgXRVzClv9anKNeqtcaInxeC49urGhS7Gv2Ritycqb5D4vVm3nktxtFd5WCHgAxw8ZL
	SrlZ/lbe8Dr8nlQFbFoCeMJjzcFmXX8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-xJl3CEqEOf2sIoUjgME0sA-1; Thu, 20 Jun 2024 11:46:36 -0400
X-MC-Unique: xJl3CEqEOf2sIoUjgME0sA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7955b3dd7b3so123731685a.3
        for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 08:46:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718898396; x=1719503196;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uF6C7gHFKrkBYo6xSl1ge0QDwxr5Plvds6Mu7amm89o=;
        b=DOT32zlMGDxyGOUURvQtzd462ReNUeSVY49YnW7xaYu0hBUciArXdh78pfYZczEP6x
         lx8rhyRchkKxz7qL0YP8rFCCmxOZwM5ftQnhde66Q16qY49487aGv38bKy+BRCF5mPWs
         lAJHCSB5Q3R+Vvlw5kzDrCKPL7Nz4Q/yvSZ+7bYwsNkeFWLGHySNmBXvvYwiMuWXH33/
         BIYSHIChE7/5UG2L4ugFXVtDipvAbEFE89eZo7gaAGMngVa5jlVJJpocD/e/CVIsU0pY
         upZ/APno3+eInpLQ4lnp/nwP3Zdbw5rnkUdZsxo1HptZGppEgP3zXOjLNg3G72FV72Re
         z3Bg==
X-Gm-Message-State: AOJu0Yzi43ee9nT7QkZDlEVQxbGplrKu+iP+RZC+UyghQneB0LwuM7Ld
	j/uwSHVnJ84W4wyRf6cmVW7dcNYNyb9xxSM/vyNzaBO1mpM27PU4mW0tB/0XUMVdtXeaysbX6xg
	EyHkigkgLPbWnZpZp/Z6QSWdxEWIai+p0tWUi/DAiG6o2oWxPyructQ==
X-Received: by 2002:a05:620a:2a13:b0:797:b319:c3a2 with SMTP id af79cd13be357-79bb3e61a76mr660858885a.39.1718898395882;
        Thu, 20 Jun 2024 08:46:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvF7kzHhpl3Y2VkCSeY2wlxx6zj8TRfWIMxW0CtZ9BbQCs3ltp2iuNa2jtr+W5mGIVX0RnbQ==
X-Received: by 2002:a05:620a:2a13:b0:797:b319:c3a2 with SMTP id af79cd13be357-79bb3e61a76mr660856185a.39.1718898395486;
        Thu, 20 Jun 2024 08:46:35 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-441ef4eefaesm75726391cf.21.2024.06.20.08.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:46:35 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:46:31 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v5 04/10] KVM: arm64: Add helper for writing ID regs
In-Reply-To: <20240619174036.483943-5-oliver.upton@linux.dev>
Message-ID: <2997a6e4-d60f-623e-e3bb-72e458456dbb@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <20240619174036.483943-5-oliver.upton@linux.dev>
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
> Replace the remaining usage of IDREG() with a new helper for setting the
> value of a feature ID register, with the benefit of cramming in some
> extra sanity checks.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

