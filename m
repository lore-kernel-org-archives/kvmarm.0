Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD93F37702B
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 06:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779863862; cv=none; b=uhc/QxYqhP9xE7zAaxEK7kHxYV3JkFDQhHbARf0xd3jFHlG+QhNYyMewA88Z1U9Of4WfaXeJJUPUgxV5jocsg0qQzUQWtQNL30OicL7NMosWW5MRCCxm91n5X0orSCb4EKIKHxMKVbDPPRHti5jFwT8hkXOzeDVU1OBTPtTxOYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779863862; c=relaxed/simple;
	bh=99hv26laU3xOjDxYBDwbdj8sZVc8KA0FHocO0j3PfOc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=X/oXPlNt6R+5wD6Hhonr/1ve1M6ay1tiahkBvhYRvHfVbJpq+3bHMLpU2wU9TSr3gtYFOA4K4AqDXhw9eUNorTD0kuSHppgQiN2mOf/7W0tLIlBdeQd2r+Dwdsu8zJvhrgJqyi3ZgrmcFX8gFDc7eJzOUqirDu4V2VUkTUoMMh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=brKlfoge; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="brKlfoge"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779863858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=99hv26laU3xOjDxYBDwbdj8sZVc8KA0FHocO0j3PfOc=;
	b=brKlfogeUhurMiJZjW2M7HTeeVd3cbg0CJyTzZH4MdiviTeiIXRRdnVsF887pXd4yrRrYr
	3lOue79DUK4JVabyWL0QhR2TTI5P70oSD0+BESoZEsnOxq5pjEo0z480JNB8cY+YJkwBhd
	U9IAFyW9jDuu2GlbY5TNNVUlwBDmwb0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-_wR7l0kuNC-Us0uE5qormg-1; Wed, 27 May 2026 02:37:36 -0400
X-MC-Unique: _wR7l0kuNC-Us0uE5qormg-1
X-Mimecast-MFC-AGG-ID: _wR7l0kuNC-Us0uE5qormg_1779863855
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44d9ace59efso6690085f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 23:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779863855; x=1780468655;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99hv26laU3xOjDxYBDwbdj8sZVc8KA0FHocO0j3PfOc=;
        b=iLgAXjJPyKIX9kNnmLApbVXT89U0f4N50GN2KYqN76BuE9TzZwiuHjtWzoaxiwRZV4
         9I2JbMU5iqwc0OHrmCV/4YyDqTnpKMO1gBx+D5lYYfYfVXlZzQugmLb61DsrqqoZe/7u
         OuR/2d3/Cs5C6Qoi5TFyPkV0UIjejoKWfYt3l/69ldoGftTijLbHB9yoMdfnTH/zc9Lp
         MbSUQb+ieVtmqNjZjokyeySJMSzbLTEErFh2Jx2ZoX7KEJN3pgcSERVgadWuVpyZGskF
         QEhWjXLFIq9SLYk3Tq9yMf0IQXUcZY19eXAAcjQLK5tW184zkn3sdqXmhx89mNLht0fj
         gATQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ihbKAMmn0rVJ5Swj6K/FklivC581nimFt/yFHj2ot8NTGmmOBFGhjliz0cSu/n3HTkgxbyVQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyK4K6jKqkqBQR0ze9TEJjd3FXC5FhoVsOMP4kKoYyMESximEk3
	VwlbemyTACvWexm9ez/x50CEx7bFg4G/W9EyAj+iNby+3Im+p9RGPD34nXo7juxQ8NR4pwAnYX5
	G+ngeqJHxCRHdQgP0yo/2l+78Q3hkaiTHsByUpgmvB+KjW5yrObmt6uw+yw==
X-Gm-Gg: Acq92OEDAM7B2ArvTu98flVxZdCo5zC6gfO3PYYYfZULRbEh02kgEDp6cyqTl/BFDhm
	MsaQuF1/JjEYDSA5GKHJeb0byV9SfeFtD+gADvmf/8ej3mRAS1JOj0gSJgS/+G5QpdvQTnNNRg8
	soKOHn88IX18WcKfrlIQVkRa5wboUNjuFl08Y6FqSQAdDwWg24AdKGgc2ktoNo4Mgay5/QVVRm1
	xAgFkoB9lDpgD6/+o6n8bxxhQy3bg4U5z2bOr0z6DCZqG4pWGkoERfT/G44B/WUBPIZRZ95qgiP
	TUJViWcZn3UPTKsQH1GENwmhp2jDFTj/Qo9P2bzzHVa4W1isKK1t1sRZgbF57wJ7X97mLkSd35S
	/n6VOmTILeqfQ7W2TfkT8qZeiwVtFC4h8WjugxH++f1550ue7x+bWfoR2FLjwB0QPz1bYY18=
X-Received: by 2002:a05:600c:6209:b0:490:601f:d776 with SMTP id 5b1f17b1804b1-490601fd9admr239463885e9.3.1779863855075;
        Tue, 26 May 2026 23:37:35 -0700 (PDT)
X-Received: by 2002:a05:600c:6209:b0:490:601f:d776 with SMTP id 5b1f17b1804b1-490601fd9admr239463355e9.3.1779863854687;
        Tue, 26 May 2026 23:37:34 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904561a33dsm342690905e9.11.2026.05.26.23.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 23:37:34 -0700 (PDT)
Date: Wed, 27 May 2026 08:37:32 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
    skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
    berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Subject: Re: [PATCH v5 18/18] arm/cpu-features: document ID reg properties
In-Reply-To: <20260519132905.145643-19-eric.auger@redhat.com>
Message-ID: <1cc64955-1bc3-452b-b783-664acb2f8dea@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-19-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F9X5YsdhwZPkLIZm8Usq8hmOi3mZCH33tu5R_3eCckg_1779863855
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:
> From: Cornelia Huck <cohuck@redhat.com>
>
> Add some documentation for how individual ID registers can be
> configured with the host cpu model.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
> docs/system/arm/cpu-features.rst | 106 ++++++++++++++++++++++++++++---
> 1 file changed, 98 insertions(+), 8 deletions(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 10b0eff27e..6203757781 100644
> --- a/docs/system/arm/cpu-features.rst
[...]
> +2. Additionally, the ``host`` CPU model on KVM allows to configure optional
> +CPU features via the corresponding ID registers. The host kernel allows
> +to write a subset of ID register fields. The host model exposes
> +properties for each writable ID register field. Those options are named
> +SYSREG_<IDREG>_<FIELD>. IDREG and FIELD names are those used in the
> +ARM ARM Reference Manual. Their availability depend on the host capability

^
ARM ARM

Reviewed-by: Sebastian Ott <sebott@redhat.com>

