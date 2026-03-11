Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1638237F
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773248757; cv=none; b=El8t6gHIPjdv6ty+eGRFwiQwp+VWDeOHiywAoL63BMFXeGQjJsvfomuM4IRhEpjTDc8FgrjE611atebE30BOG/I+EdQqNeNaaLVcJkbfj67ZVbBWMMEnIFDuYV8tMXbO5Zr/bCoWb+uvmLYoH+UevkhPdOpY+YTuVja6AuhcLos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773248757; c=relaxed/simple;
	bh=vj2yvLGgVITiiLRf6REAXbXzj8fNSDCMYaahdwZynlE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dHXXUIR3kvCbiwCaAzyOjiHUVGrfZNU4Fu9jSpBEii646Eafyrv1dXOzeaB5B/H7ryGiJmIId5cCSkfr/5rXvFXwi9xP91bZ1XmLMuf7sgHXoW8ioKPI4qGtzJnk93vORO+DWtvPXqpdKuFz6oG+qEXWF4byYarMyIUjvNL+22s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YEpJ/3Jx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YEpJ/3Jx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773248755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vj2yvLGgVITiiLRf6REAXbXzj8fNSDCMYaahdwZynlE=;
	b=YEpJ/3JxnogSZPy2HXS4raALcw49GC1V+jB91oC7MFvjPXFiDKJlWA0wHk/0X1Vr89HP/O
	FQ7CNvGQHFND+dEfFyeVsktwMyFcuPVH3vBaCDIvityxZzhVU4KEvkQKg9R2D6rJ+oYW1K
	GBgnUU04QZ+j4igwS800dwUQp9aZ2/w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-8ztcaVwkMwGe5sSgWwwc-A-1; Wed, 11 Mar 2026 13:05:53 -0400
X-MC-Unique: 8ztcaVwkMwGe5sSgWwwc-A-1
X-Mimecast-MFC-AGG-ID: 8ztcaVwkMwGe5sSgWwwc-A_1773248752
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-439c2a0d821so66200f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:05:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773248752; x=1773853552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vj2yvLGgVITiiLRf6REAXbXzj8fNSDCMYaahdwZynlE=;
        b=hg8+cZlzEmw+I4fjUGYASCbKtv6vaMEPQjh5EmKSfLFDp6bEzirC5tx3VGDRk2yuLW
         nrPX7K1TBRmMyCoSdOjn/Sl6La3uMm5UU94dhVuIYjVAYAOZtNNs1czNRp/JAkzCpMu5
         QVGZXFruYxnbUfMhTunKqAkvno+6O+JOgNDr+S1drITxQVUjD3lBwecOJ6rk/g84KpBF
         FkgTx4NjPtqNqtSFWnztWxrviU2NTiezqIPXziTbRMBRthXtBBcmGTzmJrBVXloPufNl
         JrGqMgDsuTZ/STM7oqzr8IVPOMzaS0iJWSaVnfj4jtwAqQ6WwEqiwkWCWlg3F+wxS3A3
         iAkw==
X-Forwarded-Encrypted: i=1; AJvYcCVHHCzJ0NR979qa4tWJ9lbmwHPPpVeOCSXxd+j8sHozPmAxNDgr4fDQsp1CdjzW0g2eI44pSIQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YziLzPe2DZG2PAJsykXZdyiCUWSv7cZyf/Pk3HGBuDFcs6D8Zz9
	XcSIQrryuvz6Z/hnbfT0Xhyzd8O2V4LF0jCKmsAcqdesbQ5ER6uS+iZSctOSKYU6qT7WagTl0sG
	6kbkRYMPTpK3X+JMJuwNeVLGecIyl2nqDDN0P4KRurxwUiLlDgIs3vGGJaxi1xzq3ccA7rOz7uL
	21TTk7J/aZf5R9BzHh2oAK3mQ1XYziGQB3
X-Gm-Gg: ATEYQzx35KDkOaQ1LV0mhUNxMBfT3hJ0F6wD5I9g39Uv18POBgO+y0mrQFu+ogdNIk/
	kpfJKy4crS5DiLlh2dGTWw4givzunV8MwxdogNRsUyOO5aaqLdSvXrrwijtmFJ1FAa074x2ghhv
	Pl6CbTfozsVEemLKkvqC0MDqHYpXrAeFpD8T7obvWRN1zxtr20KiP+gcNGmz5u5a2uTMmfogKne
	CgiCjPAuJVi6hcoIyjUZBnKHmuRiSx9aNISBxBobHJSky6Yx+o+lZZxvsBdHNee1cHJoa7vA/kn
	FA9lyAo=
X-Received: by 2002:a5d:5886:0:b0:439:b6f7:7ed9 with SMTP id ffacd0b85a97d-439f81df2a4mr6786240f8f.10.1773248752130;
        Wed, 11 Mar 2026 10:05:52 -0700 (PDT)
X-Received: by 2002:a5d:5886:0:b0:439:b6f7:7ed9 with SMTP id
 ffacd0b85a97d-439f81df2a4mr6786166f8f.10.1773248751678; Wed, 11 Mar 2026
 10:05:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260306112231.3201502-1-maz@kernel.org> <CABgObfYJqhj3xiM4_+7gCE1x5v5JQhyS0ox4+obrsZwA2W4GYg@mail.gmail.com>
 <867bri70xo.wl-maz@kernel.org>
In-Reply-To: <867bri70xo.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 11 Mar 2026 18:05:40 +0100
X-Gm-Features: AaiRm505BH0B-LgEHk7B9nd4GEA3WrtXkbmONvErj4A6FWFc5cpbN4e0xfK46wI
Message-ID: <CABgObfYjQaTiC7ng3rY1FveMqgzgWvKk1ER6rymfbWNSo74jtQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.0, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Quentin Perret <qperret@google.com>, 
	Yuan Yao <yaoyuan@linux.alibaba.com>, Zenghui Yu <zenghui.yu@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4au0JSy9cZVRPsWtFHUUTizO7i3PEhi4yrmTWSM0dnE_1773248752
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 6:04=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
> As a heads up, I'm about to send another one with a couple of annoying
> fixes, either today or tomorrow morning. Would be great if you could
> stash that one as well.

Thanks for the notice, I will wait and send everything together.


Paolo

