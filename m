Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011E829ACE4
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 09:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750842994; cv=none; b=tTiaIWrtDovefgWlg9CM21J5wGa3Rjjszml9ly0+gJnVz2E6bJ0urxwLGICfcLp9sT1Nvj3C8zw+tnCr5U5O7uUBSmFRPx7SwVWSKprbAtUEwDONgWvUwbHXIt+RU+u0CiDrs3PvrA6S2lqNwa5ZIT4BkGdi+rBMaXP0wje/fns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750842994; c=relaxed/simple;
	bh=nDqJHzapHliYXJF0yQKqqpWr8K8s77x4Wm/N94XJiRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KkNcluFL0len+35GfxsNSx7EnTgZxbAQpKgEXUUmWDlLiJ2Z71FGbzoc3i7uJ2A00mLCvs6OAB43DsfY6WuoD3NESVAoQPMCiFX60iRJsk5vOLN/EDOXprE5/jZmyYROVUm8h59hg0Z8RqwMg1qv+4d4yuV2kAK6wQ5GS4oAylY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfSwB5SN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfSwB5SN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750842992;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QIocLogfrgK+l1a8CNugq6b9hdRreoiwycFXhnUjGKc=;
	b=dfSwB5SNKQr/lxvly77eEtkzuLXweoP9Jc1UbDoR4BUMt0FDvQqsc0GaMH2dKYD6tciV3U
	2dRP8zR1Gn6ELnHqMIeP16oHdCX90zALdq6hSAuMU2PpL1ZgH2rgLlK0555a35DrHzvanz
	+BuEuOitHvYu7XNtpj+wrvUVvXJpb74=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-9gii4MABMQ-4eWcVjLrJAQ-1; Wed, 25 Jun 2025 05:16:28 -0400
X-MC-Unique: 9gii4MABMQ-4eWcVjLrJAQ-1
X-Mimecast-MFC-AGG-ID: 9gii4MABMQ-4eWcVjLrJAQ_1750842987
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4eee2398bso674463f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 02:16:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750842987; x=1751447787;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QIocLogfrgK+l1a8CNugq6b9hdRreoiwycFXhnUjGKc=;
        b=HMRl9G05ndguSvUn0nBX7KtdyCLrX8jP6F8LTcBYUKK9hppDYiRIOQRhSb5t4GQVBf
         ghm1rEgWzbOdcnbuu9P4gJ6/m5qxxWlOBFgAPR4F5QaAwUzqKpFEbJvr9+AkQElPTUrK
         CpVlahcnD3bPh/Zk1JAqqqs0kvZ4ySJ7alXd9W87qqDQuvyoqX+27TEf0M7rXXNyiD+Y
         /LoeWJK6y9s2KZ7X8VC6FzOktj/vzr0PCHEG7q1C06BhrxOaspfEnSb3YTlzTdjUjGK9
         BXGlYDGf1nJicAl3TLwvJQwh2MVADFZxM8k3A7VJmKACK0Y+OHoCPCYfPhW2nTBdqDEt
         xKFg==
X-Forwarded-Encrypted: i=1; AJvYcCUf6REGL4NZok9vVEOOK11EClAdfFSX+7uXmXypwSXLVdEz0r3F9kBoIEChaLlcb51hyTGeO+w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPxAqvRfV2LO0GeoeGcB0owaUzfhFD8xZVrggKW5Ijt93nRlsB
	h+nsut/4cSDg0z5uh1C6Yp3+Zqlx/BpRqTj8fkPodqXtBW3QK80UxXL4IN6iXBjQsNsSS2TDkn1
	sySIdo4jO1siYXWsCOBcpxhKxxCUfVwrW0P0T95k7CUAep5DcX/5lzR/6Ug==
X-Gm-Gg: ASbGnctYb71DnWqTho5bSzncjpQaFPONsy0C+qo80g712HhZJyTcaOhWqt9pzW34ucw
	VWM+HlUIaohZvqPfgpWpc57GGKtIX3xRAfVV4dsr6mxxH0ze2aUALZR/VwvEyqUlVzvQhjmMLPJ
	sJ+URteqxkB8ljJlDy7BBPxowlsWpuSPRLklU2vyDx9scYD+I3fB2zy8F+OBTXDQispHBIyNH82
	Qg7jB9X0vIpPGCJC+mtTxrfk3oOAruoptSaTgOK7yj3o2551PbuEuc1GI9tHHSJ02hSzhzg11Et
	IGHko4b14rJCBPZbZuwp1Isw8BJIK1E4bpKbpLgznzcx53uCwuAcDa0K3nGr2zLz83OeDA==
X-Received: by 2002:a05:6000:2b10:b0:3a5:8a68:b815 with SMTP id ffacd0b85a97d-3a6ed660d0emr1189740f8f.46.1750842987103;
        Wed, 25 Jun 2025 02:16:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGURgYmHWDumCXTRkaYhVf9XwSz9b7gl2TQ2wHUSZZkFCUqJFO9cqaoCPyutX8+Eo4kVEBmrA==
X-Received: by 2002:a05:6000:2b10:b0:3a5:8a68:b815 with SMTP id ffacd0b85a97d-3a6ed660d0emr1189715f8f.46.1750842986645;
        Wed, 25 Jun 2025 02:16:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f279dsm4167515f8f.64.2025.06.25.02.16.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 02:16:25 -0700 (PDT)
Message-ID: <de402ecb-8d45-4e42-a805-cd3aaef8dc93@redhat.com>
Date: Wed, 25 Jun 2025 11:16:22 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v8 12/14] arm/cpu: Add sysreg generation scripts
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250617153931.1330449-1-cohuck@redhat.com>
 <20250617153931.1330449-13-cohuck@redhat.com> <87h60e1ies.fsf@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87h60e1ies.fsf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f5duwMh1W__OQHVKkI6LnXeVNkIeapTTZMecobT2fYU_1750842987
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Connie,

On 6/17/25 5:45 PM, Cornelia Huck wrote:
> On Tue, Jun 17 2025, Cornelia Huck <cohuck@redhat.com> wrote:
>
>> diff --git a/scripts/arm-gen-cpu-sysregs-header.awk b/scripts/arm-gen-cpu-sysregs-header.awk
>> new file mode 100755
>> index 000000000000..f92bbbafa727
>> --- /dev/null
>> +++ b/scripts/arm-gen-cpu-sysregs-header.awk
>> @@ -0,0 +1,37 @@
>> +#!/bin/awk -f
>> +# SPDX-License-Identifier: GPL-2.0-or-later
>> +# arm-gen-cpu-sysregs-header.awk: arm64 sysreg header include generator
>> +#
>> +# Usage: awk -f arm-gen-cpu-sysregs-header.awk $LINUX_PATH/arch/arm64/tools/sysreg
>> +
>> +BEGIN {
>> +    print "/* SPDX-License-Identifier: GPL-2.0-or-later */"
> FWIW, checkpatch.pl chokes on this:
>
> ^* matches null string many times in regex; marked by <-- HERE in m/^* <-- HERE /"$/ at scripts/checkpatch.pl line 1389.
> ERROR: Saw unacceptable licenses '*/"', valid choices for QEMU are:
> GPL-2.0-or-later
> GPL-2.0-only
> LGPL-2.1-only
> LGPL-2.1-or-later
> BSD-2-Clause
> BSD-3-Clause
> MIT
> total: 1 errors, 0 warnings, 76 lines checked

so don't we need to improve checkpatch.pl to silence this error?

Cheers

Eric
>
>
>> +    print "/* GENERATED FILE, DO NOT EDIT */"
>> +    print "/* use arm-gen-cpu-sysregs-header.awk to regenerate */"
>> +} END {
>> +    print ""
>> +}
>> +

