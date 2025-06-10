Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1383929290A
	for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749563462; cv=none; b=dWBtkgXSqmfW1DL1uU1+W1uS8GebVIAQ1sn86mINHPkqt4pIfZFSKgbCawJX3u6tEEw9DDQTQXc4TKcqb3SB4bv1XpKD4pO6VWSiGFF4U9cNKnxElPSVbHN++L3hV+I5M40Iiwn9nhFPhUrRem4TlNTnlCb+hlo7AIjIDT1BOXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749563462; c=relaxed/simple;
	bh=fCWo4p6w2JPe7ViveNlz3g71884eQAB+OoO7SI2RnyM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rBL9MYYGMiwbzYmjR/HEhj7kwOR6OFVfr4uzG2u2X7fT+2G4InUD4giFQk4E8We4zHGqMJijMDPCqVxq2NimSAtN4ODxEg3iZS+2J/ZIoMR6ofUf+CGMqLLKAD7TKoVLdMNAPRUf/lJL1+D/OFl/637U5PAW+qlc4dFSW6xcD5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nt38qrD/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nt38qrD/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749563459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HJqiqUuKDfLyn4xBaXlEtsThAwLIgSsxyIFy+RU8IDE=;
	b=Nt38qrD/VVET1UdY9BcuTegvw+ORfLQ61IquKw2uAlvFY+UcvB4RgZHcB4CjN5JyiG7Crw
	4EKNnMzUMe/w7MxMDct3wa+E6ceNfOLK8iKrCvLQmw5ORKZdWil2Cth5nc09FMpKpYTkmN
	GcLEjqCWFEOywjzXIZP3lpXWDv9dUeU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-Bv7EE2iIMEq2Pzb6retojw-1; Tue, 10 Jun 2025 09:50:56 -0400
X-MC-Unique: Bv7EE2iIMEq2Pzb6retojw-1
X-Mimecast-MFC-AGG-ID: Bv7EE2iIMEq2Pzb6retojw_1749563456
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f8fd1856so2270351f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 06:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749563455; x=1750168255;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8AZiv2BWFM4GhtysbZzbwwVGm/Lo1Gm6qrn3+2ylp4E=;
        b=XE4KwfsMHmbHe1dt0HcIYVdhEK5LFeIuan+7t/kQh1i9y78TPdk6YknEeqlGDXWW/L
         hbQtenz7BeRLrvZrGtlDil5L9ItAUilDP0MUn7pwmhflm8/Sxi1rEmEUQRpeXOrqrFHT
         ehP7K3ZXpAPJ9Tm7KV+1PY3f08F4RmRakbi3HZ6NzgoKo5aYQeJCqRjumxJvmi4wpS6h
         qCuawUdIf20aygTyEIaZtl9AXCFsrIxDSXvAq9kagqD8DvYuNpPXwT4UF97mo7wbEQLB
         BkscnYhn//0QKHQSsQ1xoqaP/XumcrYXxNkEzkzlAfEDgLg3IzSZwCvSQLteGm36KrAb
         8uNw==
X-Forwarded-Encrypted: i=1; AJvYcCVG4lQkbA9du5NQRFo4fkvvEOWYUB5viMVF7OqsxUbga4erE+dW2Hi66t0unVLtYPzPeEh0TPw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHKn53TKYs6zYzKZE2pRw0HfIDKsRK6vJCgY4u2X0LCDahLO4b
	X+u5sdGxbXJ4+ENOf1/2NZGWqTo20x/NwSkb/0BXwGe/bE8bvn6dFPa5RBBqJxqBjKMy9uHR+k0
	5qXxpxjNpbjDACPD7VlNUaH2XsZy9LtA1UC5XJRX2/qRzE/sebRPGfu/fcQ==
X-Gm-Gg: ASbGnctZCOatQqWSzlGyWtzdEi2kLdcutQ52bEuCIFoH6Z+0+Ym/hZH+lfGb1pVD0sn
	ntyozrNJl9T6UqyBi8JOoMXpUiEYStK+MMF711S+8KAPLj+FeZpdNnc/irNbn8AUkZMlo2phyCK
	LNbN1NsJirKlTYetGXz3NSJ2eXZsKfQ4onJ8cQvGB7zEnxCjJROgbouqIybUGjY8UJX55rUWcSk
	0T12OvM1KyqUW37/EweVrR9WWn68/qxVFeMBjccg8fT0F4nC8EwGW5QeGNnHDVnbJyPbOYiM524
	RfCalbsKDZelDuydSfm9MUHhFVTF8601ythNpLnk+DB4pi+R3g3iKcDtn9EsAz2ZBpjaJJs=
X-Received: by 2002:a05:6000:2389:b0:3a4:f786:4fa1 with SMTP id ffacd0b85a97d-3a5316841c4mr14614315f8f.2.1749563455524;
        Tue, 10 Jun 2025 06:50:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJKrB4JYjJGiymCLMDjzBOek1jTekdNGl4zWkT4PdFepViV8CQdeLU5rPmaZjMcFcjiosmIg==
X-Received: by 2002:a05:6000:2389:b0:3a4:f786:4fa1 with SMTP id ffacd0b85a97d-3a5316841c4mr14614288f8f.2.1749563455083;
        Tue, 10 Jun 2025 06:50:55 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-452fba4621csm131448645e9.13.2025.06.10.06.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 06:50:54 -0700 (PDT)
Date: Tue, 10 Jun 2025 15:50:53 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Miguel Luis <miguel.luis@oracle.com>
cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
    Colton Lewis <coltonlewis@google.com>, 
    Ricardo Koller <ricarkol@google.com>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, Shuah Khan <shuah@kernel.org>, 
    "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
    "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] KVM: arm64: selftests: arch_timer_edge_cases
 fixes
In-Reply-To: <B77F70F2-EECA-4E10-9F00-972F6AE27831@oracle.com>
Message-ID: <8f15a5d6-0f73-194a-8fa2-b7ba8cc8c5b2@redhat.com>
References: <20250605103613.14544-1-sebott@redhat.com> <B77F70F2-EECA-4E10-9F00-972F6AE27831@oracle.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nL4WDNCTyRmqfk2AntpNjjL0fYVfX5a9lWRHComtITw_1749563456
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463806286-426200590-1749563454=:18875"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463806286-426200590-1749563454=:18875
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hej Miguel,

On Mon, 9 Jun 2025, Miguel Luis wrote:
>> On 5 Jun 2025, at 10:36, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Some small fixes for arch_timer_edge_cases that I stumbled upon
>> while debugging failures for this selftest on ampere-one.
>>
>
> I’ve tested this test under three circumstances:
>
> 1) Original (!HAS_EL2 && !HAS_EL2_E2H0)
>
> 2) HAS_EL2 && HAS_EL2_E2H0
>
> 3) HAS_EL2 && !HAS_EL2_E2H0
>
> Tests 1) and 2) returned in approx. the same amount of real time (about 12s) although 3) doesn’t
> seem to return at all.

I've never really looked at nested stuff, I'll try to set smth up and see
if I can reproduce that..

Thanks,
Sebastian
---1463806286-426200590-1749563454=:18875--

