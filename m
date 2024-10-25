Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08FC2064F5
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 12:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729860939; cv=none; b=XHRfBhNYLs7airfVSw4x51YusDfb+rvl/NsZrI5Ef88WhTfLttcu5gxBk9SoJ9rkgbccYWjly2bZtkunpigI4N6f7uX/YAQv3RZ9Se3ow8IhSUrdzA5R+z0/2WS1nFFo0/geBDEiDZQUaVNpcH8EMuIvn1Av88stzpkrlC5mFak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729860939; c=relaxed/simple;
	bh=jtbsOCdoGRt1aC/xCgKnqav1xhNs7CdP5Wywc3qmCHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jt8sET1ySWiq2gVrg4DN+QwlDbM1I/5AkLlPh0otqioDTBvQWfpM4w/smSoaTon3ioUEwBIsajoadsBcUHD9Ws1Sj3cC7cjaUfoyXwfAJdG8PL6SwtMOGf/WGSA436olqnAe27f5CelunW+fVtwEPn0IwupolWoU7kMr0gUmPNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BMAdzpqX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BMAdzpqX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729860933;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=e77XIlvulyf/f9Y8TZIkfwjukkAPIINCx9VWzDIMND4=;
	b=BMAdzpqXI2x1ioGA8eNW4mdLzvBD+/35/nlzCCyRFFMrqhaPjXSgIfynuBL+aUPLeO3Gdn
	coZXmGDoEYruROovNQq4sGiL1aSaVe5YSK0NkwPimXlzOwqafd/UGvd2KoVSbZKQNycPTF
	lWSkHTOGANmLg0w5Uj8GXi12bwfWhMY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-134-wj34u_MyPpag_U4is72eEw-1; Fri,
 25 Oct 2024 08:55:30 -0400
X-MC-Unique: wj34u_MyPpag_U4is72eEw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 225771956048;
	Fri, 25 Oct 2024 12:55:28 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.164])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 994B519560A2;
	Fri, 25 Oct 2024 12:55:22 +0000 (UTC)
Date: Fri, 25 Oct 2024 13:55:19 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
	pbonzini@redhat.com
Subject: Re: [RFC 13/21] arm/cpu: Add infra to handle generated ID register
 definitions
Message-ID: <ZxuVN905-TnOnHNn@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-14-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241025101959.601048-14-eric.auger@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Oct 25, 2024 at 12:17:32PM +0200, Eric Auger wrote:
> The known ID regs are described in a new initialization function
> dubbed initialize_cpu_sysreg_properties(). That code will be
> automatically generated from linux arch/arm64/tools/sysreg. For the
> time being let's just describe a single id reg, CTR_EL0. In this
> description we only care about non RES/RAZ fields, ie. named fields.
> 
> The registers are populated in a 3x8x8 array and their fields are
> added in a sorted list.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  target/arm/cpu-custom.h            | 58 ++++++++++++++++++++++++++++++
>  target/arm/cpu-sysreg-properties.c | 41 +++++++++++++++++++++
>  target/arm/cpu64.c                 |  2 ++
>  target/arm/meson.build             |  1 +
>  4 files changed, 102 insertions(+)
>  create mode 100644 target/arm/cpu-custom.h
>  create mode 100644 target/arm/cpu-sysreg-properties.c
> 
> diff --git a/target/arm/cpu-custom.h b/target/arm/cpu-custom.h
> new file mode 100644
> index 0000000000..1952095bf7
> --- /dev/null
> +++ b/target/arm/cpu-custom.h
> @@ -0,0 +1,58 @@
> +#ifndef ARM_CPU_CUSTOM_H
> +#define ARM_CPU_CUSTOM_H

License header her.


> diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-properties.c
> new file mode 100644
> index 0000000000..753e7c9127
> --- /dev/null
> +++ b/target/arm/cpu-sysreg-properties.c
> @@ -0,0 +1,41 @@
> +/*
> + * QEMU ARM CPU SYSREG PROPERTIES
> + * to be generated from linux sysreg
> + *
> + * Copyright (c) 2024, Inc. 2024

                        ^^^^  missing company name :-)


> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see
> + * <http://www.gnu.org/licenses/gpl-2.0.html>
> + */
> +
> +#include "cpu-custom.h"
> +
> +ARM64SysReg arm64_id_regs[NR_ID_REGS];
> +
> +void initialize_cpu_sysreg_properties(void)
> +{
> +    memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * NR_ID_REGS);

                                ^^^ just sizeof(arm64_id_regs)

> +    /* CTR_EL0 */
> +    ARM64SysReg *CTR_EL0 = arm64_sysreg_get(3, 3, 0, 0, 1);
> +    CTR_EL0->name = "CTR_EL0";
> +    arm64_sysreg_add_field(CTR_EL0, "TMinline", 32, 37);
> +    arm64_sysreg_add_field(CTR_EL0, "DIC", 29, 29);
> +    arm64_sysreg_add_field(CTR_EL0, "IDC", 28, 28);
> +    arm64_sysreg_add_field(CTR_EL0, "CWG", 24, 27);
> +    arm64_sysreg_add_field(CTR_EL0, "ERG", 20, 23);
> +    arm64_sysreg_add_field(CTR_EL0, "DMinLine", 16, 19);
> +    arm64_sysreg_add_field(CTR_EL0, "L1Ip", 14, 15);
> +    arm64_sysreg_add_field(CTR_EL0, "IminLine", 0, 3);
> +}
> +

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

