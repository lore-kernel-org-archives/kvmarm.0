Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92270178372
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 09:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750843905; cv=none; b=a8jW5RNEkknTN0Jldpvmq8PCE1ETqRlyecRtoxrwWQPN4KdIeje68NyDfFOs06rAOt+6dWQ1BvqYHpnvv8fE6yWipfFb0ao4U2L7WEXbHWoLKv9UH6TBD49u8l279DlseFcRsmCy+7+32euPe0IONAL2RkIyNvdtFW7IvebLDkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750843905; c=relaxed/simple;
	bh=Vj/KOXTkG519rVMchOgKDL/7skO2f/c7WLHDVPAFGY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hotEXemxI0iV0JFgzNtkJJY3hlSEFzK1ViP1VwKnj6uUtyXanwEVdUdREh32O+HG0qqmOYv77bErKTlqwi8oZ+0DKo+8beYrhHLjkRSYA/iR36FRf2Q7SaCXN68yeBJ4ZuP4+2BcJsQikZiTEASSt/9nhJgXAnoYYLrslF7IdDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NiKbfKUI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NiKbfKUI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750843901;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d4kb+ErCz0mhW0bKU7GDl25eFlTih4IPbtlUUppkujA=;
	b=NiKbfKUIeJRzAYJBgAjIEYxr9QRhN6pXSBL0QWjjhKYgNJA/ViQbZ/GV1OgC55dAij2PFV
	ZJ+mqDdASV1EEYmSOBoN88776b5+eGZdfjoeD07BK+xLOaW9M20gMPuQCRg2Dj4E4f1tte
	XLeUQnUaSd8lIEQMD9o2NrIppGsnrbM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-dfjJrLV7Pvqt1jT_GviMNQ-1; Wed, 25 Jun 2025 05:31:39 -0400
X-MC-Unique: dfjJrLV7Pvqt1jT_GviMNQ-1
X-Mimecast-MFC-AGG-ID: dfjJrLV7Pvqt1jT_GviMNQ_1750843898
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450de98b28eso3426165e9.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 02:31:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750843898; x=1751448698;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d4kb+ErCz0mhW0bKU7GDl25eFlTih4IPbtlUUppkujA=;
        b=oM1HbAMon/HKGXnPPPZM3YyDIISXdSoTK/+0snwQvD7QfX9txhV00e0tuQ7xXjyUJW
         D37QS0nk8TevEryTyWW5h0QXjSRekrnftqrRKZtuieA6cLSAsWpKN1OISEh7UZv8qBVS
         ojHcHiokEZFewh426k9KWaOABS4roFNLEFwHP6qIsH45ilb42BmQQjM4B8CltA5przPN
         WK6mHCMWzS6uBJGJV9XTejnmwEe+txzbS6KwNnVmz3KmE8m3yqCmbPo3z4t0nvWwHqIO
         qpHfUfuYHO5W1+juhPEbGTDbwtMsCjDJw6QBLzzh2AXlypYPkoXY02dGkg68pvkuA4BL
         DZ/g==
X-Forwarded-Encrypted: i=1; AJvYcCXAd2Q71tRwjpN/RFKTLPmFtqmS8ByV4DgTFhpHn1w1v0DVEDj8HCKsI/a2J0UT+Ym+kXHzNUo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwW4yOEDrZeRGuLJuNnnx4CBePOhuJyz7tIEZRwf6MqPeqhuoEd
	MPe4yZ603q6/o/gOmM4zV36h9BgIYOcqsJEy3ywnt/P9zhybQ0sKceBYFGGOWqAaz8UuDSi/3GB
	Wo0L8eYfRHgAw9KGGGFUtLx9+6XxLozkOtLyFYVXwNUCB0RxIIkHGx+qVXQ==
X-Gm-Gg: ASbGncsAtiuCo6zYY7AQ5LRL2wn6EcHY6kgswqLITSOCsrY8xJI3LVMAsmXPReWPX5M
	mFXDLd1qUa5+1iak9Wz3SUgKKTWL91K9BQbaknmUCl04vT1YTRZhi006tJ3zEbxzA2FRb95M8Zg
	yR56Gpo6hz3KTUEzC9IboTQ0Bd0qfRrlL6woenDiZvrEKcmefX2yX0XeyTwxcrBBS/zZLmkYjwf
	ETePO95VoLQ9gI5ntD2qWSCHKTMhQ/EsBWab3JdnehhqNVZ5eDe+QTpyPQ8UIqgMkl5PvTd8XWl
	OaeI4iVDzi/FS5iKpo6SUpUOsQodEz7aEImvUi97YFnmCkfgLsMaHJDkJV2jmwEXx54JfQ==
X-Received: by 2002:a05:600d:108:10b0:453:79cb:7c86 with SMTP id 5b1f17b1804b1-4537b722e5cmr41194875e9.3.1750843898169;
        Wed, 25 Jun 2025 02:31:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUXitgn9o5HGaBbsL83/BsZlB9vIxZ2oB5zHbv3/LG2dAPZPrsPMW3HFNeDWIB+0JpmJcK0Q==
X-Received: by 2002:a05:600d:108:10b0:453:79cb:7c86 with SMTP id 5b1f17b1804b1-4537b722e5cmr41194605e9.3.1750843897660;
        Wed, 25 Jun 2025 02:31:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538236694esm14290065e9.28.2025.06.25.02.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 02:31:36 -0700 (PDT)
Message-ID: <3bf1b8eb-4ce2-4d33-9aa0-9c9f4c1afa17@redhat.com>
Date: Wed, 25 Jun 2025 11:31:35 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v8 12/14] arm/cpu: Add sysreg generation scripts
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, agraf@csgraf.de,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250617153931.1330449-1-cohuck@redhat.com>
 <20250617153931.1330449-13-cohuck@redhat.com> <87h60e1ies.fsf@redhat.com>
 <de402ecb-8d45-4e42-a805-cd3aaef8dc93@redhat.com>
 <aFvAEXWi7PUbVAud@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <aFvAEXWi7PUbVAud@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: esbVUqP7-5FKQllMjBXFo_Vp9WqRQHDEHU7TS1jaDd0_1750843898
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Daniel,

On 6/25/25 11:23 AM, Daniel P. Berrangé wrote:
> On Wed, Jun 25, 2025 at 11:16:22AM +0200, Eric Auger wrote:
>> Hi Connie,
>>
>> On 6/17/25 5:45 PM, Cornelia Huck wrote:
>>> On Tue, Jun 17 2025, Cornelia Huck <cohuck@redhat.com> wrote:
>>>
>>>> diff --git a/scripts/arm-gen-cpu-sysregs-header.awk b/scripts/arm-gen-cpu-sysregs-header.awk
>>>> new file mode 100755
>>>> index 000000000000..f92bbbafa727
>>>> --- /dev/null
>>>> +++ b/scripts/arm-gen-cpu-sysregs-header.awk
>>>> @@ -0,0 +1,37 @@
>>>> +#!/bin/awk -f
>>>> +# SPDX-License-Identifier: GPL-2.0-or-later
>>>> +# arm-gen-cpu-sysregs-header.awk: arm64 sysreg header include generator
>>>> +#
>>>> +# Usage: awk -f arm-gen-cpu-sysregs-header.awk $LINUX_PATH/arch/arm64/tools/sysreg
>>>> +
>>>> +BEGIN {
>>>> +    print "/* SPDX-License-Identifier: GPL-2.0-or-later */"
>>> FWIW, checkpatch.pl chokes on this:
>>>
>>> ^* matches null string many times in regex; marked by <-- HERE in m/^* <-- HERE /"$/ at scripts/checkpatch.pl line 1389.
>>> ERROR: Saw unacceptable licenses '*/"', valid choices for QEMU are:
>>> GPL-2.0-or-later
>>> GPL-2.0-only
>>> LGPL-2.1-only
>>> LGPL-2.1-or-later
>>> BSD-2-Clause
>>> BSD-3-Clause
>>> MIT
>>> total: 1 errors, 0 warnings, 76 lines checked
>> so don't we need to improve checkpatch.pl to silence this error?
> Its regex gets confused by the trailing " after the comment end. We
> could fix it, but ignoring the error is also valid as this is a
> highly unusual file that's not likely to be common through our
> source tree.
Makes sense. We are good then.

Thanks!

Eric
>
>
> With regards,
> Daniel

