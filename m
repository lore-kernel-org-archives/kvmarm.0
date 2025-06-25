Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DD52877DC
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 09:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750843509; cv=none; b=YLOKqoAjaQ/3L/fezbXm41pjH4P/OYhx9JdGlRIEOmuvcNq8Fyxug3/eTGx6rSHDGOJKVj99wPI5w62mjq962xmN4AaJrHWfb9fvmZeGMjbByFr+8f8URYS2r3tNkIh9rxSL7Kdv7rJQJOZfIIsUVg7jplBfp79fPmTNz+8uCIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750843509; c=relaxed/simple;
	bh=d6RgJX06wrFMM3/ixGQZTyJVNxK3MiA9Uy0D9NcTPMc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=P+cGrRYM2AggfkfoVxfI1WTiyjr/Q0oZhbZhsghMeOg7eoY86emy77qpjN3hpoNqMO+fxCXjubmNWXJwuQPf/kjvZFM+lVhAGx8RSDux7CVo5AM634VfFz6E5RoXeQ+zOs62WRsKXG4Wxl9/O7Wx6KHTjALcrPaioztBDI2M5hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZRZ4xhc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZRZ4xhc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750843507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J98pa0OgM1m3PXwe+TSA6SiLP5ra/6pWKwelnbc1vTA=;
	b=FZRZ4xhch33cHopSbAp0srWQIipyffZtcWn6cKudUmiN2B1qHY2t/j271mnoQGYZVtKjFN
	JYnebSfMlq7eMGUH3HmxbiC65rh1adUmv/Rj2xZkqrFJJjwMd29SUafLWyHOSKGVau+InS
	VQPQwBQNn5artQu30Vd253qU7vf01a8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-1BiK8-ymN6Wxp76_fZZwoQ-1; Wed,
 25 Jun 2025 05:25:03 -0400
X-MC-Unique: 1BiK8-ymN6Wxp76_fZZwoQ-1
X-Mimecast-MFC-AGG-ID: 1BiK8-ymN6Wxp76_fZZwoQ_1750843501
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDB9D195608A;
	Wed, 25 Jun 2025 09:25:00 +0000 (UTC)
Received: from localhost (mschlens-int.str.redhat.com [10.33.192.203])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C93CA1956096;
	Wed, 25 Jun 2025 09:24:58 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH v8 12/14] arm/cpu: Add sysreg generation scripts
In-Reply-To: <de402ecb-8d45-4e42-a805-cd3aaef8dc93@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250617153931.1330449-1-cohuck@redhat.com>
 <20250617153931.1330449-13-cohuck@redhat.com> <87h60e1ies.fsf@redhat.com>
 <de402ecb-8d45-4e42-a805-cd3aaef8dc93@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 25 Jun 2025 11:24:55 +0200
Message-ID: <874iw4i36g.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Jun 25 2025, Eric Auger <eric.auger@redhat.com> wrote:

> Hi Connie,
>
> On 6/17/25 5:45 PM, Cornelia Huck wrote:
>> On Tue, Jun 17 2025, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>>> diff --git a/scripts/arm-gen-cpu-sysregs-header.awk b/scripts/arm-gen-cpu-sysregs-header.awk
>>> new file mode 100755
>>> index 000000000000..f92bbbafa727
>>> --- /dev/null
>>> +++ b/scripts/arm-gen-cpu-sysregs-header.awk
>>> @@ -0,0 +1,37 @@
>>> +#!/bin/awk -f
>>> +# SPDX-License-Identifier: GPL-2.0-or-later
>>> +# arm-gen-cpu-sysregs-header.awk: arm64 sysreg header include generator
>>> +#
>>> +# Usage: awk -f arm-gen-cpu-sysregs-header.awk $LINUX_PATH/arch/arm64/tools/sysreg
>>> +
>>> +BEGIN {
>>> +    print "/* SPDX-License-Identifier: GPL-2.0-or-later */"
>> FWIW, checkpatch.pl chokes on this:
>>
>> ^* matches null string many times in regex; marked by <-- HERE in m/^* <-- HERE /"$/ at scripts/checkpatch.pl line 1389.
>> ERROR: Saw unacceptable licenses '*/"', valid choices for QEMU are:
>> GPL-2.0-or-later
>> GPL-2.0-only
>> LGPL-2.1-only
>> LGPL-2.1-or-later
>> BSD-2-Clause
>> BSD-3-Clause
>> MIT
>> total: 1 errors, 0 warnings, 76 lines checked
>
> so don't we need to improve checkpatch.pl to silence this error?

Yes, that would be good, but my perl-fu is basically nonexistant :(

