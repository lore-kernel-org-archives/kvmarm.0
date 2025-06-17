Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70FC2ED872
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175136; cv=none; b=pJetfEtCAjsosbxyPHLstl2cHQ7cyneMrA2QhNfn6d5xq8ZvptuByJwJKkq4hVx1PYUh/8ip/HkIG2bs9ncjf2hvni7xqgGYUBHXSywoBZjrF9JdiKsD8KaRWJ8XAzjzQbKmc08ewGgKsExCprr5bhabmTMaxoo2ks9rxhiEa6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175136; c=relaxed/simple;
	bh=dgGieE0z6G/5uJYgTJf+H3e0UA7uV1V+O2tj/bT4n/c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oVZo9oznBotKEowgoaK1ORy3yF3SCfHGdzuFiXzhZMDRNhPzmqfg25ra5w6Dzh+ZlpkcrzDS3O63mjDTgqJ76geojHoXLG8JBXKNkaGaEhWE4cC3jpMFamjITGoAy7w3ubbhCsqH4ZgESNYTsuXKBUZybnBxlk+r72YYAkl4PFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZzhkYJtK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZzhkYJtK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pimc7ToHXzj5NjsL3cnFa44sV45BUXzhB1gmiO8PNfc=;
	b=ZzhkYJtKoAecutdOyLuKOYUiWwdqHbd6sSoxfvBYddaKy9IoLOwPaq5mlyibyEkbeNKnDO
	VuF/U73m0ktSkcktg75u7k1BU4qIV9W4QidMj2tg2HeteUAt4Awe6VNbOHTiJhCKSnAumR
	+/cwrCaibWUDK8BSgEhNBy9fI2+XVws=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-KFe1QetPPQC4DZGrfoLaKw-1; Tue,
 17 Jun 2025 11:45:27 -0400
X-MC-Unique: KFe1QetPPQC4DZGrfoLaKw-1
X-Mimecast-MFC-AGG-ID: KFe1QetPPQC4DZGrfoLaKw_1750175119
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37CE81800284;
	Tue, 17 Jun 2025 15:45:19 +0000 (UTC)
Received: from localhost (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 257B130001B1;
	Tue, 17 Jun 2025 15:45:17 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH v8 12/14] arm/cpu: Add sysreg generation scripts
In-Reply-To: <20250617153931.1330449-13-cohuck@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250617153931.1330449-1-cohuck@redhat.com>
 <20250617153931.1330449-13-cohuck@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 17 Jun 2025 17:45:15 +0200
Message-ID: <87h60e1ies.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Jun 17 2025, Cornelia Huck <cohuck@redhat.com> wrote:

> diff --git a/scripts/arm-gen-cpu-sysregs-header.awk b/scripts/arm-gen-cpu-sysregs-header.awk
> new file mode 100755
> index 000000000000..f92bbbafa727
> --- /dev/null
> +++ b/scripts/arm-gen-cpu-sysregs-header.awk
> @@ -0,0 +1,37 @@
> +#!/bin/awk -f
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# arm-gen-cpu-sysregs-header.awk: arm64 sysreg header include generator
> +#
> +# Usage: awk -f arm-gen-cpu-sysregs-header.awk $LINUX_PATH/arch/arm64/tools/sysreg
> +
> +BEGIN {
> +    print "/* SPDX-License-Identifier: GPL-2.0-or-later */"

FWIW, checkpatch.pl chokes on this:

^* matches null string many times in regex; marked by <-- HERE in m/^* <-- HERE /"$/ at scripts/checkpatch.pl line 1389.
ERROR: Saw unacceptable licenses '*/"', valid choices for QEMU are:
GPL-2.0-or-later
GPL-2.0-only
LGPL-2.1-only
LGPL-2.1-or-later
BSD-2-Clause
BSD-3-Clause
MIT
total: 1 errors, 0 warnings, 76 lines checked


> +    print "/* GENERATED FILE, DO NOT EDIT */"
> +    print "/* use arm-gen-cpu-sysregs-header.awk to regenerate */"
> +} END {
> +    print ""
> +}
> +

