Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09452A1C9
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 14:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747234470; cv=none; b=T8oKnSRESadyuFo+jFD/F5ABzmtXFI9QbVtUYY+Cbt4ZInbl/lOIUMZxYvH2RjD986wJOlRKUlHG9pl+I+Vs9xDVLYUVjM7aXvWPZp1rTC7LSThi2iqYg0UvEGPwdy11FiwOoo3oqR5pmsPY3ZKwwvnog9GyUMFchWOzN3/xgW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747234470; c=relaxed/simple;
	bh=XCrh/6OKAQsusvOH+iO7d2h8gaERpOtTD2iQcJk/7zk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=huLYqsI1ARF2TidXObEnz78gf33k/upGRCy/a9zhl9qx77c1srlZ2N7zd+xOjWde89/NhruVF5eM0CKtkTvQY5Ma2MGXkaO5fQWWJkbhSTnLjZTI4FSMr0sOMwQBjNHSSPuvH+KJCEmZByrcmABMJ96rQki8wW4Z25tqIW3K5lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GH2pnmSz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GH2pnmSz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747234466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KF6lDVwcE50AHlY5Ciik4TP5xsofh1kR+7PtPFs+N2U=;
	b=GH2pnmSznkHcZ4WG0x9iX+ylCaM/VBEtyX0jBSS2oR/d5yz66iiKoEJYddZxJBFRmzKOIm
	h76jzJwbHsGTxfGYOWiNbrqucpmbkHJTwBUgDWhQ8iZ9+3PSKo+bbQipxXOS5Jak+Ambn/
	i3N/Ovzz23LRSFHIakG/U40wzABrbK0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-TdhHYpF5MzyBlTdPUz-4JQ-1; Wed,
 14 May 2025 10:54:23 -0400
X-MC-Unique: TdhHYpF5MzyBlTdPUz-4JQ-1
X-Mimecast-MFC-AGG-ID: TdhHYpF5MzyBlTdPUz-4JQ_1747234461
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A45A1956050;
	Wed, 14 May 2025 14:54:20 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C74DC30001A1;
	Wed, 14 May 2025 14:54:17 +0000 (UTC)
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
Subject: Re: [PATCH v6 12/14] arm/cpu: Add sysreg generation scripts
In-Reply-To: <aCNwKBDtJES0GX3q@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250506085234.855779-1-cohuck@redhat.com>
 <20250506085234.855779-13-cohuck@redhat.com> <aCNwKBDtJES0GX3q@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 14 May 2025 16:54:15 +0200
Message-ID: <87ecwrckfc.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, May 13 2025, Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Tue, May 06, 2025 at 10:52:32AM +0200, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>=20
>> Introduce scripts that automate the generation of system register
>> definitions from a given linux source tree arch/arm64/tools/sysreg.
>>=20
>> Invocation of
>> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
>> in scripts directory generates target/arm/cpu-sysregs.h.inc
>> containing defines for all system registers.
>>=20
>> [CH: update to handle current kernel sysregs structure, and to emit
>>      the re-worked register structures; cpu properties will be added
>>      later]
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  scripts/gen-cpu-sysregs-header.awk    | 35 +++++++++++++++++++++++++++
>>  scripts/update-aarch64-sysreg-code.sh | 25 +++++++++++++++++++
>>  2 files changed, 60 insertions(+)
>>  create mode 100755 scripts/gen-cpu-sysregs-header.awk
>>  create mode 100755 scripts/update-aarch64-sysreg-code.sh
>>=20
>> diff --git a/scripts/gen-cpu-sysregs-header.awk b/scripts/gen-cpu-sysreg=
s-header.awk
>> new file mode 100755
>> index 000000000000..b6b207e3c0fd
>> --- /dev/null
>> +++ b/scripts/gen-cpu-sysregs-header.awk
>> @@ -0,0 +1,35 @@
>> +#!/bin/awk -f
>> +# SPDX-License-Identifier: GPL-2.0
>
> Invalid license name here - hopefully checkpatch.pl is warning
> about this.

It might not check .awk scripts?

>
> Same issue as in the other sysreg script in the host CPU model
> series.
>
>
>> diff --git a/scripts/update-aarch64-sysreg-code.sh b/scripts/update-aarc=
h64-sysreg-code.sh
>> new file mode 100755
>> index 000000000000..721f41a9a516
>> --- /dev/null
>> +++ b/scripts/update-aarch64-sysreg-code.sh
>> @@ -0,0 +1,25 @@
>> +#!/bin/sh -e
>> +#
>> +# Update target/arm/cpu-sysregs.h
>> +# from a linux source tree (arch/arm64/tools/sysreg)
>> +#
>> +# Copyright Red Hat, Inc. 2024
>> +#
>> +# Authors:
>> +#          Eric Auger <eric.auger@redhat.com>
>
> Although its fairly short, this still deserves SPDX-License-Identifier
> to be set.

@Eric: do you agree on "GPL-2.0-or-later"?

