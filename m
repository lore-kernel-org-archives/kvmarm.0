Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6362F94BC
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 09:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750843430; cv=none; b=trF6lbImF2qD/FrNQqjU10Ap09eXvp1JcU0bP/shuJuKzGGvbm/39CR11//4pVvUIVxWV0IkcxvGsTebyDN939BjHy0ByKYdy60gaEiSDrZG7pWNBFqm8nLqSx48IH2/NpnHJLlzBYb6ziOSdc4Qu2K04B+A7Y0e6BQsPkjdigU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750843430; c=relaxed/simple;
	bh=0oYI3PM4hlR+p5GWManhnmLfX4M2RxgirTaOiYQopLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BTH0tps4mOJEgjLVJw6zifGpvfWU3Cqe7h/SXdL87mgqeEQyYDGiMskLGickBv8xB9MskPGv2K3Tqfk5vTLV9hHw3mfkWo1YHA68a6nzc/JiEnfF/lV+xt04Wd0l0GyJ2bKZzie3VV1otOqOhWZz94gDdgNH2OdN/Iawj11YX38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EbAlDXl8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EbAlDXl8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750843427;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=bZ+XYuox0wC95cywpvr8h67ROsM30izGhUHLxDsrux8=;
	b=EbAlDXl84z+ilfUPAc2V8escLTLxP81D9jk05dVxfYxl+V9ffb8JHTfMIDiSWHZWaMi3Jk
	0zg+OEZbbr7v7VE4OAR3uCtFPi75pHYHZ2H7127tNkS6nm8z+uAidMhKZBmdqWMR3b1a2B
	01J6nvO+ZSaWqTw2zZVm90xZXFyO2h0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-pPsRU3IcO_eApNH12hmkAQ-1; Wed,
 25 Jun 2025 05:23:43 -0400
X-MC-Unique: pPsRU3IcO_eApNH12hmkAQ-1
X-Mimecast-MFC-AGG-ID: pPsRU3IcO_eApNH12hmkAQ_1750843422
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8E331809C89;
	Wed, 25 Jun 2025 09:23:40 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.177])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91DCC19560A3;
	Wed, 25 Jun 2025 09:23:33 +0000 (UTC)
Date: Wed, 25 Jun 2025 10:23:29 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
	philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v8 12/14] arm/cpu: Add sysreg generation scripts
Message-ID: <aFvAEXWi7PUbVAud@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250617153931.1330449-1-cohuck@redhat.com>
 <20250617153931.1330449-13-cohuck@redhat.com>
 <87h60e1ies.fsf@redhat.com>
 <de402ecb-8d45-4e42-a805-cd3aaef8dc93@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <de402ecb-8d45-4e42-a805-cd3aaef8dc93@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Jun 25, 2025 at 11:16:22AM +0200, Eric Auger wrote:
> Hi Connie,
> 
> On 6/17/25 5:45 PM, Cornelia Huck wrote:
> > On Tue, Jun 17 2025, Cornelia Huck <cohuck@redhat.com> wrote:
> >
> >> diff --git a/scripts/arm-gen-cpu-sysregs-header.awk b/scripts/arm-gen-cpu-sysregs-header.awk
> >> new file mode 100755
> >> index 000000000000..f92bbbafa727
> >> --- /dev/null
> >> +++ b/scripts/arm-gen-cpu-sysregs-header.awk
> >> @@ -0,0 +1,37 @@
> >> +#!/bin/awk -f
> >> +# SPDX-License-Identifier: GPL-2.0-or-later
> >> +# arm-gen-cpu-sysregs-header.awk: arm64 sysreg header include generator
> >> +#
> >> +# Usage: awk -f arm-gen-cpu-sysregs-header.awk $LINUX_PATH/arch/arm64/tools/sysreg
> >> +
> >> +BEGIN {
> >> +    print "/* SPDX-License-Identifier: GPL-2.0-or-later */"
> > FWIW, checkpatch.pl chokes on this:
> >
> > ^* matches null string many times in regex; marked by <-- HERE in m/^* <-- HERE /"$/ at scripts/checkpatch.pl line 1389.
> > ERROR: Saw unacceptable licenses '*/"', valid choices for QEMU are:
> > GPL-2.0-or-later
> > GPL-2.0-only
> > LGPL-2.1-only
> > LGPL-2.1-or-later
> > BSD-2-Clause
> > BSD-3-Clause
> > MIT
> > total: 1 errors, 0 warnings, 76 lines checked
> 
> so don't we need to improve checkpatch.pl to silence this error?

Its regex gets confused by the trailing " after the comment end. We
could fix it, but ignoring the error is also valid as this is a
highly unusual file that's not likely to be common through our
source tree.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

