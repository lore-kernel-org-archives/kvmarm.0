Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037E03FF8AE
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779806539; cv=none; b=BDNqIzl4GjDBJ88fBoM1yFcvNZVedCfRbcNzLkH8lyloP26ffKMbDXUqt6Soq7r0QeqqyACGB6RObhC44CaUM7ASdq1C9EQdaCHQH87bg5zR659g1Lhkhj4LF6ekeyNQJSpqLzhsJudI2BVchfZ9dSWhzNagjIX4uoZh7DYXvR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779806539; c=relaxed/simple;
	bh=tAZw5nBqf0KWKBCjIM/iXDShpWcgx4rPdqiD73aSiVw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=dw2q3B6yed5a8I7gG2mzTdQ8qvCX5ap8S7uWtX+er60+yppRopZXArBQMKxYmUzZVZtPjukmu9f0GypOeQwXAXeAWRpryZs6JMdapSsVfx1LfZf+zSL1v5YHTIirNn6kXEO4JWWOLRMjzWmfY09wRh8W4b8f98y17yeDb6yDxp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LKC8yVob; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LKC8yVob"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779806534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fZDdsIz6mWe2PYk4uTEblQ6F35azGLkwHQC1mtzNnlk=;
	b=LKC8yVobj2LUZbt54+Z2vTSXiONZPEBdBvyfHOBEODtgAzzgfcuUxSuVlYLTJbJE3sAIAz
	NhYZbsRwv28gwZ5MhWjEjx3N8IzdPO0k6qJjadH05i8+XuzSMJ6eqNIiR8nPSl/92Fe6ac
	+O2P+HdOEXdkalgQj4Ykb2fgWKBYdak=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-aXIj3kYhOhyUarhvLoRWCg-1; Tue, 26 May 2026 10:42:10 -0400
X-MC-Unique: aXIj3kYhOhyUarhvLoRWCg-1
X-Mimecast-MFC-AGG-ID: aXIj3kYhOhyUarhvLoRWCg_1779806529
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44f65835b77so7740765f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 07:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779806529; x=1780411329;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fZDdsIz6mWe2PYk4uTEblQ6F35azGLkwHQC1mtzNnlk=;
        b=mMh72IVqWbRCaMAgUDEcaSy4f2vJXM+0Pkd6sfKMWeFWxZuv6/WWrX4WByVDkJQMyc
         mSyPVpibIH2HNzkug3mRCP3AXJ00ZvvjqHhmT1+s3bYkQB2G34vqhJtgJg5JEdp2Yovj
         gVcq0SXMwDpkTbOOQEVZGSLQca1g2Rds7EXuqMGlgDXTTZN3fDKTFQQyq2l0A/SgMR1W
         ml5Mb8U9FGq7k0nSe7KiKTH60W53SDWcbwHBlQLHMc77eoVet0gxHnc9Q56rRFy915ip
         l5rYGCyuzQh+iYfVIKcGlrnE3riQr1cypZMgnXC1Rqe8p9gupxo6lQU+KcNoTCxKrRhY
         6KAQ==
X-Forwarded-Encrypted: i=1; AFNElJ9YoE2mbyMR+UeAix+isEnmzKpHwa6+QaSTLof4bSPM6b7ZINfZVguJJ0O5xEMoF7jdKK8Xslw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqEnKUZkO4hPZ0iiqmn4o22z0Ok03NNsj/8AkXuwHJg0maqH+o
	iNWFBdSGKuAdqLImhcPPwcpc3CYwYcgqMJOhBVc6LbDWTxSISGK8HNfkg8sISkqohdL6vTvfbAD
	5nGfan4oN2jdQ8XKYzxgx6z2DH3XuOTZt1+SHxtAXVnvD9terPjeWJmazsA==
X-Gm-Gg: Acq92OEblnoKRw2U0FFFKuKznTreQt3HSRv/G591PhsKpVWyR0tum4l2MA3qf0eVMMM
	g+zjuPrhQkiBdqk0gOs+X6/MM2/Eoj7N/Fpqnm37Hnk8ekUxojuiBV8o0HzMMxpZ7uLwditHEJo
	Q1BbUpAQYEFPu+JGqR8ti2ZxwiADQEtoDK6s9zx2uW4fyWxswaVexLyYyt3BsQ/sSBF+yhfncDk
	E0TOLeZiYsN1kRbiLpcrXSvSSe8P6wVNLCXKwInOJQtk0tvR1yZbFYd8rv+8pimLXPTchVwqfSs
	UW84+9i5tUk6cgLJtNDGrgW9rvwl+zrAfgCZGZ9W9O0pfIcT/PClcHxVQv1Xf/eoHZosWFuouP5
	/0wF7xJGSBQb+6fUiXKxOyFwY9c5DXsDg+/C4i0+mhsjMSTMNlzouMw28RE+dUCx0eKHLbJA=
X-Received: by 2002:a5d:64c2:0:b0:45e:b2b9:705a with SMTP id ffacd0b85a97d-45eb38baf74mr29795860f8f.23.1779806528959;
        Tue, 26 May 2026 07:42:08 -0700 (PDT)
X-Received: by 2002:a5d:64c2:0:b0:45e:b2b9:705a with SMTP id ffacd0b85a97d-45eb38baf74mr29795768f8f.23.1779806528242;
        Tue, 26 May 2026 07:42:08 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9b980sm33049781f8f.3.2026.05.26.07.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 07:42:07 -0700 (PDT)
Date: Tue, 26 May 2026 16:42:06 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
    skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
    berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Subject: Re: [PATCH v5 13/18] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
In-Reply-To: <20260519132905.145643-14-eric.auger@redhat.com>
Message-ID: <0d3a2287-e94f-3eb1-018d-b4dd74275ab2@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-14-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 68J-nZ13Y4kxElhbsrEHRrO27cjV9Om0HAy2pdBQdY8_1779806529
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:
> This helper decode the ID reg writable mask, matches it against
> ID reg fields defined in target/arm/cpu-idregs.h.inc and
> for each writable named field, generates a uint64 property.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
[...]
> +static int
> +decode_idreg_writemap(Object *obj, int index, uint64_t map, ARM64SysReg *reg)
> +{
> +    int i = ctz64(map);
> +    int nb_sysreg_props = 0;
> +
> +    while (map) {
> +        ARM64SysRegField *field = get_field(i, reg);
> +        int lower, upper;
> +        char *prop_name;
> +        uint64_t mask;
> +
> +        if (!field) {
> +            warn_report("%s bit %d of %s is writable but no named field "
> +                        "in target/arm/cpu-idregs.h.inc",
> +                        __func__, i, reg->name);
> +            warn_report("%s is target/arm/cpu-idregs.h.inc?", __func__);
 							^
 							up-to-date?

Reviewed-by: Sebastian Ott <sebott@redhat.com>

