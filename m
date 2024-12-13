Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D7D13AD1C
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734107511; cv=none; b=uyM0WQTqmo977GGBjCWOpotzR4tKZofTMGf/lyAnn9VX2+riHJ44FM+1mXKaPcOoC2WtKW9GQ+ZH26i+RkUG1mKS3hd0xL2a30ZXB94F4ruyY0MM0Hm6nUdWpPUEKP7IgRucDryEsXBXay0Edf1ibhLSEhiJ/Q5UxNKm1oQsMdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734107511; c=relaxed/simple;
	bh=qlHz+lr4HPDQ7x8wm8r2SfL6WTHQSlXEEM0dDW4sFxk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=K40Kl6wXr0PqU2UIBZ21fFfPJK9g4iGvKtMDNVQQsarcaqV/PH7Km+06dL5rIsN0HgW9M/MPNlnnRopm4TigvQKSiZ8EBi84owKwtcxYtrXPX2NmHDVoxoRKH5aVao4viaHMU7QoZ9hQ2c0WnmgVOjtZVIRI/0NQufupXseNsUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3kuUkje; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3kuUkje"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734107508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qlHz+lr4HPDQ7x8wm8r2SfL6WTHQSlXEEM0dDW4sFxk=;
	b=e3kuUkjeRnMBjxqEGLJl3FmljmHkqblhCP9iubTkOzzfT+wC6sWZoQG9tn0PoDbdFJYgRf
	s+SGtoqQH13MG8UnZkag3s6qdfnMiOzHoC7u0YODua7+CArvQkyWoBBmNa+GMuNi4ltRxs
	8PiaHXWgTJLatwA6vu9nKfeTwgWxAeU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-qSv2Xvm_POC8eRwPoPjBIA-1; Fri, 13 Dec 2024 11:31:47 -0500
X-MC-Unique: qSv2Xvm_POC8eRwPoPjBIA-1
X-Mimecast-MFC-AGG-ID: qSv2Xvm_POC8eRwPoPjBIA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361ac8b25fso11501435e9.2
        for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 08:31:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734107506; x=1734712306;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qlHz+lr4HPDQ7x8wm8r2SfL6WTHQSlXEEM0dDW4sFxk=;
        b=q6QMkQCqRpMkTLhfc7E3btVWJ1dKov8juVO2am2GsKN3Em9fYu1FAGoNT00n+KuCmN
         6o6+zWIU11EwiJqnMZIwAUJag3kgBkCch69lhpc2NWVIQNyK7au5iz9JEkBJp/eVWULB
         cUxqQV18HUecSlpkItxYHEGSDKhEnoqn4/WLcGTR7U4wZnLGItI9IPwoDTf0TwwD/FSR
         yw5nGFcFDjRxgvjXYbcoPeAl6CIQc/14Lfj0yQrcr8zfyAym6s/1TfsUlsNlyKuBfQry
         L18/7uCo1JAEgtfCqB9k56jV6fGP6aZApdWaCK9f7AXMrvuMLckFa4RUYzlEBkf+NwA7
         HZ0A==
X-Gm-Message-State: AOJu0YxBJH32vuK9urw2sxGw3bZtLNKsD3mfi11rOFUpb4gGTuEau4f9
	TCfkDXylTiiZvGBzNPqabTYGo13F0NYm9LVGoEq6FnVfMLaPyg0+dI6U4TRF472rzMZ1g9Z3HXi
	Aao7oXbuc2n/c3W35E7PACCVwY4tCvUALOsRrjqAoypobD4B/92/HNQ==
X-Gm-Gg: ASbGncvVFVWegZqP1J8xUV8z4l6LIQkiiabDRuz3WMcjn7vnFd3XFluxFihg4Xz3qrO
	yxDBeGaDEn4e/rKYm7KT46vJx8ok3CncBzbzR5HUwk9krs2ZsFrs0dQHgkVj5DjqW5bniITfe9D
	f8f5gMXefhMpJB+PCFKZPghS3dY6eYJx/5JpznxBAOIh+PxWSjkLZ+rJLWZ3StLZG45env0/3yx
	cq0+og31q6eLHcCfnywPkGyxzgnsOtPj6QwNk0r3IWOIZNqWEutcyH/MT3ug366dkoyk4Ymglui
	g/Jk/kkvMh5l3WXjs2hDs6IzV9TP
X-Received: by 2002:a05:600c:1da4:b0:434:faa9:5266 with SMTP id 5b1f17b1804b1-4362aa43222mr31872905e9.13.1734107505948;
        Fri, 13 Dec 2024 08:31:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzaBiFcYLOIETWgouIDtQBnlV88BBESWk31ASraRk6McgMUTtlmSvIy7PHCzWNTaauJLwiXQ==
X-Received: by 2002:a05:600c:1da4:b0:434:faa9:5266 with SMTP id 5b1f17b1804b1-4362aa43222mr31872515e9.13.1734107505667;
        Fri, 13 Dec 2024 08:31:45 -0800 (PST)
Received: from rh (p200300f6af0bca008282df582fad0b68.dip0.t-ipconnect.de. [2003:f6:af0b:ca00:8282:df58:2fad:b68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43625717c9fsm53788575e9.44.2024.12.13.08.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 08:31:45 -0800 (PST)
Date: Fri, 13 Dec 2024 17:31:44 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
    catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
    cohuck@redhat.com, eric.auger@redhat.com, yuzenghui@huawei.com, 
    wangzhou1@hisilicon.com, jiangkunkun@huawei.com, 
    jonathan.cameron@huawei.com, anthony.jebson@huawei.com, 
    linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v3 2/3] KVM: arm64: Introduce hypercall support for
 retrieving target implementations
In-Reply-To: <20241209115311.40496-3-shameerali.kolothum.thodi@huawei.com>
Message-ID: <0610c537-292a-1720-34d7-438524009cd4@redhat.com>
References: <20241209115311.40496-1-shameerali.kolothum.thodi@huawei.com> <20241209115311.40496-3-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qkKeDyygvWfyQJsj1_m5klmz51Fk8InnLQwFD6Usaaw_1734107506
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 9 Dec 2024, Shameer Kolothum wrote:

> If the Guest requires migration to multiple targets, this hypercall
> will provide a way to retrieve the target CPU implementations from
> the user space VMM.
>
> Subsequent patch will use this to enable the associated errata.
>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

