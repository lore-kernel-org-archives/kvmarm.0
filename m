Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D70914F9EB
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 15:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747149813; cv=none; b=pT8Mw2unretdTQYKktugMfnagPdl7uE6DsV3QiL/+iPijr6NXgWXOnLzu9ihLQlVaC2orIwZPGZm15GyGhL47GzJ/FodeIuoQFtsERDFlFDdworajAln7ml3HB+uRKrUvc+Ly4Nk63vTUKxGBWdtII2YP0dxnRH61BvjQmkIiZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747149813; c=relaxed/simple;
	bh=W1wUySPSy0bY2pfl0wEDUXt0ALzKHKgSQ7jjhydvnvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2XZbN3LjX6Z9EzP1QxYY2QBGMR1Bhamx6Z3nEpjcKvNKrSzqS9+pzrP1MWxcoUywd/wupv9TUHSmcE/lWsD3snZJMeig1Z4PE1wNIz61WGVsdhXYhB7EBvT2GfTo5OKXItmm5gjM3WZJXfpgupAsvquCuNxvSEB2dG7zAt4Pn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZRsP34et; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZRsP34et"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747149810;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=cgbu7nue8vQ9ere64ITgIcQRi4NqnKKSII3mmlr4q+U=;
	b=ZRsP34etH4pHoTsHtiujKhfL+70Z5mti1uVWYe2NGZ6hDrj6D7dot4V9ByswUmsfHXb6xh
	SJzzPlwC/aXC+QzkHvKUyg9FVuHMDsyv0Sbj4dM99iFhkjCxhgQFJOY4/PAyHG+oqjWPd4
	pjVCV2XhPzyiUaBvzjZRSB/zHTu1Zjc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-195-GJWtSxzUOQ2zpbXRAKwSLg-1; Tue,
 13 May 2025 11:23:26 -0400
X-MC-Unique: GJWtSxzUOQ2zpbXRAKwSLg-1
X-Mimecast-MFC-AGG-ID: GJWtSxzUOQ2zpbXRAKwSLg_1747149804
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB46819560AF;
	Tue, 13 May 2025 15:23:23 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.110])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FEF919560A7;
	Tue, 13 May 2025 15:23:16 +0000 (UTC)
Date: Tue, 13 May 2025 16:23:13 +0100
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
Subject: Re: [PATCH v3 02/10] arm/cpu: Add sysreg properties generation
Message-ID: <aCNj4dFWLkBZrmmh@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-3-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250414163849.321857-3-cohuck@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Apr 14, 2025 at 06:38:41PM +0200, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
> 
> Introduce a script that automates the generation of system register
> properties definitions from a given linux source tree
> arch/arm64/tools/sysreg.
> 
> Invocation of
> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
> in scripts directory additionally generates
> target/arm/cpu-sysreg-properties.c containing definitions for
> feature ID registers.
> 
> update-aarch64-sysreg-code.sh additionally calls
> gen-cpu-sysreg-properties.awk which is inherited from kernel
> arch/arm64/tools/gen-sysreg.awk. All credits to Mark Rutland
> the original author of this script.
> 
> [CH: split off from original patch adding both sysreg definitions
>  and properties]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  scripts/gen-cpu-sysreg-properties.awk | 325 ++++++++++++++++++++++++++
>  scripts/update-aarch64-sysreg-code.sh |   5 +-
>  2 files changed, 329 insertions(+), 1 deletion(-)
>  create mode 100755 scripts/gen-cpu-sysreg-properties.awk
> 
> diff --git a/scripts/gen-cpu-sysreg-properties.awk b/scripts/gen-cpu-sysreg-properties.awk
> new file mode 100755
> index 000000000000..76c37938b168
> --- /dev/null
> +++ b/scripts/gen-cpu-sysreg-properties.awk
> @@ -0,0 +1,325 @@
> +#!/bin/awk -f
> +# SPDX-License-Identifier: GPL-2.0

GPL-2.0 is a deprecated SPDX identifier. checkpatch.pl ought to
have complained about this, requiring GPL-2.0-or-later as the
preference, with GPL-2.0-only requiring justification in the
commit.

> +# gen-cpu-sysreg-properties.awk: arm64 sysreg header generator
> +#
> +# Usage: awk -f gen-cpu-sysreg-properties.awk $LINUX_PATH/arch/arm64/tools/sysreg

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

