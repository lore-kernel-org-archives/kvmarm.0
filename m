Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553ED312836
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779370039; cv=none; b=GROg4PV7RDMcjvPXC9OrVBmFtnvmbryHdHLwO/AzLinUiXDgpztGoXdrjmw+SbVA6GX1sy2kdDT7pGzKrrnzluBONNfxtW8sATWUObJvP42T/zwl3TDw1KG1UF0YrhI5d4T/qsXo5/8v2uTm0gHeiVCLS/3EZT/tXiJjMlmxPyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779370039; c=relaxed/simple;
	bh=h6iUSiBbCT5Svqkko9/OoPK+JRbR5kp8DOmVXofDJ3k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=QtrR3MGWytFsiYxeh0mpD3dxztjcj02b+/DXoBoNlv/yCad1XjsmzzHKB51iEVNLZdZHzSD2bS/J9VjNi7L4E/uFo7m6joL7qUcN+vq7izq8Go+SFa5IdiR8/DKn3ZSBOCjMmBTtKRB2DmV7NBBYpMSpeR7sMTQrQ39Igo14NLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T2duJLzm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T2duJLzm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779370037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=taoyeZO92Lo+Y2zM4lue4L7ITuLtAyqN4pStN57kKx4=;
	b=T2duJLzmTzUwjGn5/q2UB61Fq/El4YdUlpSAAZ2Bf8Z6oOxTkjD8KWg9B9M75N8Kb6Fhpy
	8wAkoJEx8LV5lVXdT7UeLKHt8YTZy3h6BnDEFNlzphxq/Lzegopsm8TuIS0oXHJqdfi733
	39l+Y8vfG8UWOCyZmvTm/iNVpEdZCQs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-V_aStt4AP0GfxMwjo4Mcsw-1; Thu, 21 May 2026 09:27:05 -0400
X-MC-Unique: V_aStt4AP0GfxMwjo4Mcsw-1
X-Mimecast-MFC-AGG-ID: V_aStt4AP0GfxMwjo4Mcsw_1779370024
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4903dcb32f8so2018725e9.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779370024; x=1779974824;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=taoyeZO92Lo+Y2zM4lue4L7ITuLtAyqN4pStN57kKx4=;
        b=nO08o+uxOQOn/9GrJ7VX+h0krR/qI35GDgRItvpQ2W/99wc89roDNSFbW5tBJvcNRW
         N/iMtPGcZ0u8HQJOeDzIFiyakUZppdX5hWaxo++CaCYlT2DFV4RkqEN5VEKcmLz7XdWU
         oE6RVklNn4YHiaSvYlhJwML5gCUWSjiDAG3kznQlZ3uoV7x6rtAk5Mo9Xh8mqlH5Guf2
         dMR96rjDbnZaiTU3jnPJyfMIeg8rkXU7Z9gvN5HTMBZbEWIsCzVfFGbKRWRW8CjAynGJ
         aIS73ApH31blKzM1WZhUDM5vCOuYFHWti0guxZZXLjCSvHlvE4TYGhxfX3aO7mGjUUy7
         /fMQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Qm1SdBo52ad99Db27JnSAJKl8IGlBALk4+zCtJSa63bjNTt/RrnusKej6bcf1fNig7aJJgoI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/qiXok4u2o1kBDM1YMm0dtNK5H2pX/J3inojofankhar/ikIH
	ode8jYFh6Luv8dwUwi1QcpjIbOLisGO4xQ9NwvWQZ2alTO6SmrYmvohU57D0uTIJY3AEWscOTIW
	wr5f8r5B6rsKAgHTTENgZc6qpEydPz3XijdX34riMcQOh9vrUs1SG84D7aQ==
X-Gm-Gg: Acq92OE/h6pG/Kf9n+WdIhfTmxDrTGb10INoYFZgLDQPSlInofDJrdfDxu8gywaH7uV
	RrsbWlHIwvaPUT39H8nyBQBP8C0//jxv3Ewo7jLx0oCyI/ymEs8rYSmiKxcRYng4YqmNFHyLRZN
	N3uoisBFlzrfMgHxZAftyy83hqaeTLkbec0Id43Ucw1xLpX+23XOiDlFD7+DgRmcYJ2X0xFtMdA
	VmxzxVk942hEu88WJls6d1OaW1uV3RrfhA4bNmJm8fziWIoNO7gmQ+X05dX1Nbs/IyR/7qmh9zz
	NdnLsiPSe48p//2DfD5seqHtFVuTOjd8EsSFSOF8XP0p5rGUNKyVaO1EGnb+qUFRzHjL4csuPeP
	LVRL//I5pUaPwSvLAcK/zjVMmYo3HSBjjEubA9y+QGYBIkc+BA46rSF2KIOgYUHH+8eAxm5U=
X-Received: by 2002:a05:600c:6c8:b0:48f:f199:79f7 with SMTP id 5b1f17b1804b1-490360c4820mr25083325e9.27.1779370023746;
        Thu, 21 May 2026 06:27:03 -0700 (PDT)
X-Received: by 2002:a05:600c:6c8:b0:48f:f199:79f7 with SMTP id 5b1f17b1804b1-490360c4820mr25082805e9.27.1779370023291;
        Thu, 21 May 2026 06:27:03 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903cae778asm24857635e9.13.2026.05.21.06.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:27:02 -0700 (PDT)
Date: Thu, 21 May 2026 15:27:01 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, Cornelia Huck <cohuck@redhat.com>, 
    richard.henderson@linaro.org, skolothumtho@nvidia.com, philmd@linaro.org, 
    maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com, 
    armbru@redhat.com, berrange@redhat.com, abologna@redhat.com, 
    jdenemar@redhat.com
Subject: Re: [PATCH v5 08/18] target/arm/cpu_idregs: generate tables for
 Arm64 ID registers and fields
In-Reply-To: <20260519132905.145643-9-eric.auger@redhat.com>
Message-ID: <b6b3f600-220c-0b3c-25a1-5a253ba1d7e2@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-9-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ahC-2abG9NV0TWlke-c6t7ZP040fb0TDXsuWDsudSDs_1779370024
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:
> From: Shaju Abraham <shaju.abraham@nutanix.com>
>
> Include cpu-idregs.h.inc multiple times with different definitions for the
> X-macros. This will generate tables for all Arm64 ID registers and their
> fields. Additionally, initialize the tables with all architecturally defined
> values. These tables will be consumed by the property layer in future
> patches.
>
> Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
> Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
> target/arm/cpu-idregs.c | 50 +++++++++++++++++++++++++++++++++++++++++
> target/arm/meson.build  |  1 +
> 2 files changed, 51 insertions(+)
> create mode 100644 target/arm/cpu-idregs.c
>
> diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
> new file mode 100644
> index 0000000000..f79b22680c
> --- /dev/null
> +++ b/target/arm/cpu-idregs.c
> @@ -0,0 +1,50 @@
> +/*
> + *   ARM ID register field table.
> + *
> + *   Builds the per-id-register field descriptor arrays and the global
> + *   arm_idregs[] table.

arm64_id_regs[]

Reviewed-by: Sebastian Ott <sebott@redhat.com>

