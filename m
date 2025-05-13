Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E74F1A38E1
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 16:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747152953; cv=none; b=FeE0ckJta+kRHYhlStbC7h+pJ46xEVljshEhoH4S1WLInnAUD7QidMOy3sLxLK5k1hOxzEGhwillGcM0w3BtlwLHUB8rtolPPFuOU+g18eDljImaG1e3rg+dz8yl2GYS84NhB50TkUo5s1ARg9batYY7tBCBg000lGsbYzy0V88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747152953; c=relaxed/simple;
	bh=20MS4R1woUiSACr68kf8fJraCW3LrTbnXZXJMjztyi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGIyA4UoKopwrG4plPNutytn/QcwEz6zUrEqPnuzZNFlqgxKuYth1Xr5Lh9dQL1teiJ3CB6TNBxkohZ+n+OKRPYEWfAjMmP8jeVjlTKg5UOHoaDQrDgdrKEkLlDyQr02wpW86vcukKJB4J7RCfX3JgtGw2CTRgfxZ7gzv9jfi4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OOnea6Y+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OOnea6Y+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747152950;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=3H+YxSQA77WT2zoxSF0xFsZjcb58V5BplyA9TltcVTE=;
	b=OOnea6Y+2dfQ925bAyCvgbGFq5vPNFhavziO9Mz+X2Alx7PE0P2ULyCqvPqLyMu4dtOMWt
	+nu4lkBjP3DLHqSrJwSvQ4O5rXHK5cYqkWtsz9aWKh9AFi7hyOYSJKfOrgu5Paj4mIUedZ
	IyYgY8q89udreokirk78EVV9svmYVQw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135-dl3M_j5RPL-4gEjGGkuNrg-1; Tue,
 13 May 2025 12:15:48 -0400
X-MC-Unique: dl3M_j5RPL-4gEjGGkuNrg-1
X-Mimecast-MFC-AGG-ID: dl3M_j5RPL-4gEjGGkuNrg_1747152946
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0896E195608E;
	Tue, 13 May 2025 16:15:46 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.110])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3963A19560A3;
	Tue, 13 May 2025 16:15:39 +0000 (UTC)
Date: Tue, 13 May 2025 17:15:36 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
	philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v6 12/14] arm/cpu: Add sysreg generation scripts
Message-ID: <aCNwKBDtJES0GX3q@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250506085234.855779-1-cohuck@redhat.com>
 <20250506085234.855779-13-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250506085234.855779-13-cohuck@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, May 06, 2025 at 10:52:32AM +0200, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
> 
> Introduce scripts that automate the generation of system register
> definitions from a given linux source tree arch/arm64/tools/sysreg.
> 
> Invocation of
> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
> in scripts directory generates target/arm/cpu-sysregs.h.inc
> containing defines for all system registers.
> 
> [CH: update to handle current kernel sysregs structure, and to emit
>      the re-worked register structures; cpu properties will be added
>      later]
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  scripts/gen-cpu-sysregs-header.awk    | 35 +++++++++++++++++++++++++++
>  scripts/update-aarch64-sysreg-code.sh | 25 +++++++++++++++++++
>  2 files changed, 60 insertions(+)
>  create mode 100755 scripts/gen-cpu-sysregs-header.awk
>  create mode 100755 scripts/update-aarch64-sysreg-code.sh
> 
> diff --git a/scripts/gen-cpu-sysregs-header.awk b/scripts/gen-cpu-sysregs-header.awk
> new file mode 100755
> index 000000000000..b6b207e3c0fd
> --- /dev/null
> +++ b/scripts/gen-cpu-sysregs-header.awk
> @@ -0,0 +1,35 @@
> +#!/bin/awk -f
> +# SPDX-License-Identifier: GPL-2.0

Invalid license name here - hopefully checkpatch.pl is warning
about this.

Same issue as in the other sysreg script in the host CPU model
series.


> diff --git a/scripts/update-aarch64-sysreg-code.sh b/scripts/update-aarch64-sysreg-code.sh
> new file mode 100755
> index 000000000000..721f41a9a516
> --- /dev/null
> +++ b/scripts/update-aarch64-sysreg-code.sh
> @@ -0,0 +1,25 @@
> +#!/bin/sh -e
> +#
> +# Update target/arm/cpu-sysregs.h
> +# from a linux source tree (arch/arm64/tools/sysreg)
> +#
> +# Copyright Red Hat, Inc. 2024
> +#
> +# Authors:
> +#          Eric Auger <eric.auger@redhat.com>

Although its fairly short, this still deserves SPDX-License-Identifier
to be set.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

