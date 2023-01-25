Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A854A20
	for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 04:37:18 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id z13so16802531plg.6
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 20:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WO4GpmDSCs0S854pshGkZUEPT69IcB0aJp3A2QbXxAU=;
        b=NjfDfL86fBgRGbkayyp567ulj0sP4RgCggm2zRbKDACmcUvv2H+INIeRgNO24RsD+E
         Oy7bsR0zPAf+n7lCT493PULnK7+VJsqU/A2rcqazWHIuEjyYFnedlbRspQWkun46yoG7
         Pn34bedMhEyXdjFKy7QRK+ysr0yptHSxsiVNXxnxUpoIHkGc32kjTAnuSDPecC8GMVqb
         lxCS+kmsoUUJvkZ2YUTlJZQ9z1i/Vjd4pirpX1T8vn4jp9RWnMqIrg04ZlX5kmfgqDJB
         yeT7HYsAbUbkEMlVDXTKLLiGFQxp3deqd5UGsjmpT6CHriDIz/IynkN7yxoq38PJi1yW
         yM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WO4GpmDSCs0S854pshGkZUEPT69IcB0aJp3A2QbXxAU=;
        b=hflhA/LlMLWKpU0VEvlyul28Gif7kS7Zlc4SY1lk/D9Fa8ZCsFInAUsD2QBAyIN2LG
         KSxAVdNkK8zQo2nja/FFwH6DpiWtxrYanEVbqQ/Xzx/edgiCzdrZIWYXCAdNuU6Ti+CE
         Ey+hAtal7khBIomrAkwORP+MzDMQ7wPe/mW5jWeLK7LgGp34/PAWkDKhOBcwA3h/9sGE
         TiX9vN78DWv9khQTFGYSD9GnfKtBxLjEz/iVCnVhlbVujZX4oa4nVAQYvANQfvMdG690
         bpRtE/JidX/W44PbU8532wlGgUNeYd+KGyCnYkALLjXYXwlIzVuqdXdMX/828qCcTCYq
         nEZA==
X-Gm-Message-State: AFqh2kpvcYeD//NqTXsV4Zjmzhn1g/3pIcB3EcDA6OQzEmTLwmGsD9t+
	4o7peCP31VP0zNdSb1pxQDQyaSkbnrmfSBOoyQunaQ==
X-Google-Smtp-Source: AMrXdXuar2zro7h1CyWUyGP6uMC4vWzwKdCkCenLjuKqrP+ipVK6jvRtMOJN0+ExZ20gsKOdPKsGLF+OKl81gSk5B9g=
X-Received: by 2002:a17:90a:8546:b0:227:1d0b:5379 with SMTP id
 a6-20020a17090a854600b002271d0b5379mr3368427pjw.103.1674621437753; Tue, 24
 Jan 2023 20:37:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109211754.67144-1-ricarkol@google.com> <20230109211754.67144-5-ricarkol@google.com>
 <31614401-8669-1f74-aa01-bed3ad3d2cf0@redhat.com>
In-Reply-To: <31614401-8669-1f74-aa01-bed3ad3d2cf0@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 24 Jan 2023 20:37:01 -0800
Message-ID: <CAAeT=FxYxE6xvQ5Q_MAG74EN0FC2P6xg_mAg=7GPC2h2LiA8cw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/4] arm: pmu: Print counter values as hexadecimals
To: eric.auger@redhat.com
Cc: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com, 
	oliver.upton@linux.dev
Content-Type: text/plain; charset="UTF-8"

> On 1/9/23 22:17, Ricardo Koller wrote:
> > The arm/pmu test prints the value of counters as %ld.  Most tests start
> > with counters around 0 or UINT_MAX, so having something like -16 instead of
> > 0xffff_fff0 is not very useful.
> >
> > Report counter values as hexadecimals.
> >
> > Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
