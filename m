Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3304F13D53C
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 09:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714123550; cv=none; b=KYznn9ADoiBlW9RM0KAyvgvjqgubY+9sW903cpvMrSRtqcC0Fcjd3jm5AfJjJflyRE+n72poUP+zwOb7MFVl+iBVbhcBhOBjStIk2vum/yh48BTfapJuCSCe9D1kNy8Fd88BOaAsey2MeNW/HB/Ww5O8VjAxdS3bFoYVynCg5Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714123550; c=relaxed/simple;
	bh=v/8fP7ljlfNYu8p9ZmxbNzZV08oGzX9HMMT08K/tl/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lHjx/CjjrsriSEnQAYyveGDg45rHBOPrrlb99zSEnEwNU4TQfGbqjCY4wq9zfgGE0zHT/UAD3F9+AZd8LrLzWQSA2pKl9EHU+4r+TFJtbT2+DpnVXKU4FUS751R7UBbiCXxu0+QQNBiAzU54gN6b4mFnR0Sb9vEzW0x4KGKSi3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EpLXYj4M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EpLXYj4M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714123548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aI+0tk0N0rfZ0+RaTapxWMbQJR8XZdeH/fzJ04k7BlA=;
	b=EpLXYj4Modg5E4H1cHYXLiUvQmHYFUwXMGkBmNlMPmwg4B4X93C5/kdcJMbSYgh8vb3kaV
	4M/hH0+2obn04u8QRmNkfJOI5E16aZZcQln9QNxf4cLgGiEho9zUhA5KZpmaifM6ogdfxX
	jcaBs/cjHHbcgiJ/cc8KMreXeIgt06I=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-59qsAdofN4iYW5h2RmALzA-1; Fri, 26 Apr 2024 05:25:46 -0400
X-MC-Unique: 59qsAdofN4iYW5h2RmALzA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1850346a12.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 02:25:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714123545; x=1714728345;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aI+0tk0N0rfZ0+RaTapxWMbQJR8XZdeH/fzJ04k7BlA=;
        b=IHamueOCCg17POPQccCnCY5gOpGcGqTW3/HMlvW9B4vtBHR9fwbmc/Iuh/TZWoYzky
         BmWWIjZZTgAN02LgzPowBDSD4MBTKObGFsfkiPkEjDC2L7Vu0Ry+GT/d31Vfo/DXzEXa
         c28hxevG6l9Dot7rbNsobybHiU1ZgXJYwf5wRAV1oNgDjdEKO5Ph+CzVAN/kG2KGmzNE
         w1LtEv8GrwfUWwtzHRWMoxliu1VDsR5XOgozvKZsPbbje2tFp2Htk4+mhafWZaaA+2Zc
         81h8++WuCHkF9sXJp/h3h2CmYAl4ur8O+JTwoztzkQbTdugbHoUBufbkqRbiWd76DQBb
         ZN/g==
X-Forwarded-Encrypted: i=1; AJvYcCUk8/MvrBusNB1jCE2Z0DaNxYBkuErcKBh1agWY8LrLOpc476n+nSZ2juEokZLXKX/sSWy+1JoXblRAZvNZEjrX1xbc3fs8
X-Gm-Message-State: AOJu0Ywf5mrB9faAIiKaTuogFZ+sKb9AA9hxKybg3DXXWpHOQ9L6kghA
	nLXtgkPMVaZPstIJCI6EWBYtM759Enz0Mg0QpEtWLo5aL60OaTlDTfcTzidWfKsG3B3zwPWuD9V
	nULESNg5KJq6SaQTBUvRLH3scdxx52qs0oCif04cVOal2fOdcqpKWEQ==
X-Received: by 2002:a17:902:cec3:b0:1ea:482f:f41e with SMTP id d3-20020a170902cec300b001ea482ff41emr9963254plg.15.1714123545324;
        Fri, 26 Apr 2024 02:25:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvlGXSv/tKHY50Dw7+RKb6bmu/jV2eWJbng5XCKDvWXp8D8BnGzOt+jBjaEMTVQZ+CP26+DQ==
X-Received: by 2002:a17:902:cec3:b0:1ea:482f:f41e with SMTP id d3-20020a170902cec300b001ea482ff41emr9963218plg.15.1714123545006;
        Fri, 26 Apr 2024 02:25:45 -0700 (PDT)
Received: from [192.168.68.50] ([43.252.112.88])
        by smtp.gmail.com with ESMTPSA id r3-20020a170902be0300b001e27462b988sm15054500pls.61.2024.04.26.02.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Apr 2024 02:25:44 -0700 (PDT)
Message-ID: <0a96abc4-8205-447d-9e7d-03397de5ada8@redhat.com>
Date: Fri, 26 Apr 2024 19:25:36 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/16] ACPI: scan: switch to flags for
 acpi_scan_check_and_detach()
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, x86@kernel.org, Russell King
 <linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Salil Mehta <salil.mehta@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, linuxarm@huawei.com,
 justin.he@arm.com, jianyong.wu@arm.com
References: <20240418135412.14730-1-Jonathan.Cameron@huawei.com>
 <20240418135412.14730-8-Jonathan.Cameron@huawei.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240418135412.14730-8-Jonathan.Cameron@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/24 23:54, Jonathan Cameron wrote:
> Precursor patch adds the ability to pass a uintptr_t of flags into
> acpi_scan_check_and detach() so that additional flags can be
> added to indicate whether to defer portions of the eject flow.
> The new flag follows in the next patch.
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> ---
> v7: No change
> v6: Based on internal feedback switch to less invasive change
>      to using flags rather than a struct.
> ---
>   drivers/acpi/scan.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

