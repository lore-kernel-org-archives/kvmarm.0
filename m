Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78188488
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747236373; cv=none; b=UEJYiAJtfeNoeqx3elbAnycNmvgonjcTd7TcvQF0DrVPAdSgdvlsgfC9TPoX33HOTeMWRHKMetoyK+FZa7XlB10aB7HXioprquFHdF71/eXlKiD8PeYQ6ytpxF654rEgb1pTZKf4sfkGtDmY5r5i6vl/Nl8zAlCEGnJLQdsaKNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747236373; c=relaxed/simple;
	bh=pl2nKffzTqrq0Eb7u/m9iKr58psZXtX2jFoZuNyzANA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SpfPHLxnzgHM5Li1CrFGgTgehqiHRZ2gkT/Yfi2GA+Oz5QR1WgOs/LtRRT0Hue95Kn/4g/eYcOAOVd7bk/zHd1VMX8e6JWVwAJj4XHkFNOEeYi03IbE7hWaeldR7xhCn2+ZazOftP78M5H1eZFNePZy9sUJiTw6k9qj+l2XuHIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y4SkxPX4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y4SkxPX4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747236370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QTW8LjvZra41+tt3U/t37D/X61KI8S/1vdXHso4lMuE=;
	b=Y4SkxPX4g1Eg0uB4LOTFeXcPJydg8YBZShveO7ZOfWXqocIjrrwlxwj+9xDVlzfj9z7YwX
	Z5K0+RK8cixvHN7ahvxiK26Wc/D/XYlJmWWGeFVnYDGYxMoru7bpH5ccxOx5ZJRep0z9XL
	C341jR0KcE011MqvhSZUPUcXSEJuMgI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-ek8D87iENguM2airTLJE2A-1; Wed,
 14 May 2025 11:26:07 -0400
X-MC-Unique: ek8D87iENguM2airTLJE2A-1
X-Mimecast-MFC-AGG-ID: ek8D87iENguM2airTLJE2A_1747236365
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A557218001E0;
	Wed, 14 May 2025 15:26:04 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D8E51955F24;
	Wed, 14 May 2025 15:26:02 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, agraf@csgraf.de,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH v3 02/10] arm/cpu: Add sysreg properties generation
In-Reply-To: <aCNj4dFWLkBZrmmh@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-3-cohuck@redhat.com> <aCNj4dFWLkBZrmmh@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 14 May 2025 17:25:59 +0200
Message-ID: <878qmzciyg.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, May 13 2025, Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Mon, Apr 14, 2025 at 06:38:41PM +0200, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>=20
>> Introduce a script that automates the generation of system register
>> properties definitions from a given linux source tree
>> arch/arm64/tools/sysreg.
>>=20
>> Invocation of
>> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
>> in scripts directory additionally generates
>> target/arm/cpu-sysreg-properties.c containing definitions for
>> feature ID registers.
>>=20
>> update-aarch64-sysreg-code.sh additionally calls
>> gen-cpu-sysreg-properties.awk which is inherited from kernel
>> arch/arm64/tools/gen-sysreg.awk. All credits to Mark Rutland
>> the original author of this script.
>>=20
>> [CH: split off from original patch adding both sysreg definitions
>>  and properties]
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  scripts/gen-cpu-sysreg-properties.awk | 325 ++++++++++++++++++++++++++
>>  scripts/update-aarch64-sysreg-code.sh |   5 +-
>>  2 files changed, 329 insertions(+), 1 deletion(-)
>>  create mode 100755 scripts/gen-cpu-sysreg-properties.awk
>>=20
>> diff --git a/scripts/gen-cpu-sysreg-properties.awk b/scripts/gen-cpu-sys=
reg-properties.awk
>> new file mode 100755
>> index 000000000000..76c37938b168
>> --- /dev/null
>> +++ b/scripts/gen-cpu-sysreg-properties.awk
>> @@ -0,0 +1,325 @@
>> +#!/bin/awk -f
>> +# SPDX-License-Identifier: GPL-2.0
>
> GPL-2.0 is a deprecated SPDX identifier. checkpatch.pl ought to
> have complained about this, requiring GPL-2.0-or-later as the
> preference, with GPL-2.0-only requiring justification in the
> commit.

GPL-2.0 is inherited from the Linux script mentioned; not sure if
GPL-2.0-only would be the correct fit here?

