Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D1325A2AE
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 09:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736078; cv=none; b=KruwFuYDpqvLzKI4vEnwG8SMAk0aeL4+zuY/gaxJGwHG24EuFok44wPiQ5mCvVw/4FgKbzOGiGiK4iVrYcdncEwRLjLMDImskYzG3OW5E2LeH0raztqP6TOG8vfROu6vCDnyij1uN97xVdzKaVgI1KCCj6sSZ9tTOCoppz1A1kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736078; c=relaxed/simple;
	bh=wCBfJiBQ9qt3kn0TmhbDPgExnB+I3XmM7UMdbKbC4SM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ld5nYB21o8mn9gRjT5ByFyYOliB27HlwdIoDn1wnvTkz9Xm5eyShG1HdT6bs2Pu1xTb8jB+NP0W3SfTWd/9osvgSAeiYiotwat+AjIEkQ7FqfGgLTrvFaUp6hqOFt9PU1v6d0rXAR8kqbeum3SQ/Ulo9vAtxOGTlx+oPeyVgbDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a42z4qgu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a42z4qgu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740736075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gbaRwkrcWTPEj+Fi/Ujt3Y6owLjKOxspVmv39/Q4dWw=;
	b=a42z4qgu/KBIs13BAFUtqtChmIlkQiD2qjxN4ReJmriV/5YF8Ppjvm6x1rm2je8qKpn09/
	OKsckClyqwx6z0FB6p3giHHZ2qo2O0Y8zTiUm99uMLjCmAx0xaNZshMJQSFpRmdUKU0fhT
	Nk6Cdr3QESGzj68694j9tTm3xo2u7YA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-zPZ0_ttROUi7EP12AInZsw-1; Fri, 28 Feb 2025 04:47:53 -0500
X-MC-Unique: zPZ0_ttROUi7EP12AInZsw-1
X-Mimecast-MFC-AGG-ID: zPZ0_ttROUi7EP12AInZsw_1740736072
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43ab456333aso18711075e9.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 01:47:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740736072; x=1741340872;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbaRwkrcWTPEj+Fi/Ujt3Y6owLjKOxspVmv39/Q4dWw=;
        b=GrtBdKePUk7CzIZ2NubF4mUeHQlRxCnFiaO083IEqb3u2sA6RG+1TfH6juvoGnVczY
         jaU5KCqqd0srR2D4fc7+AUh5Y8vIfaQ6nejTkUMELO7NeG4br6DLFcrPjjpdR+Xa6KqF
         VJC3ojvvlnuVju7p0/mk535QDPrac8oeRncrSI0NyotqxoCf/wR1QsFOb6YwwjnEQnrV
         D/3QJDEfxVpOBHu38ikpOsFa+tdwIgGr4g1kbwwRB5/CnZUQ0NxPt0V7BYguaUAy7Jx1
         6z7a3KhiVjEKXfPOuqD7jbWr82UnUjf7EcKdHjt4b/N9XZAo0IdlSLfpC2VJEKyUKKwk
         2sSA==
X-Forwarded-Encrypted: i=1; AJvYcCUco0YXW6ed66m5WtZmjIbVbJmAKIsIYznQjct6s5ruzdE7fD1jJfynD/EGhKQZTJUrY2ja36c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzA0n9ZMbPazPhENSGh3hhS8hNXjA6FCf2FIAvaz7Re8IH5OiSu
	iX9BBMLnQy1Cv6XGsNuV7B0Z6sad9XVekXVhRwnHpBAj6xYFCJBtYkaONwOAv3uEZMalI/bLnCH
	qNFkMvJwVsatcdNU9L+LTnkGxJBjQGVZV2+m4ZtPvS4e/rkL0Inr5OA==
X-Gm-Gg: ASbGncvUXtnYXqyO9wGVCUgyu2QCI5Zj5e7nwc7t4aCQjnrrrrz/Qs1CqF5T1W6DAW7
	EBw0yYVjfbbcSuEsAVrvUyvvdXxUe5Rpp9JIJ7q2MJoidmjE1XcIAapDwDlhD4XcOU3nSVzbe5W
	k95EY0HMAbmGVfgVRvdl+RgB/ULsTNllfsBfaj2+XjDF9FPVPKa4ViN5xE3fsSOtTHclWcxhxOZ
	7Yk0DeezT9CcowLZH7lDfMqSjOfT+tdP8GxQDlIXFiZ1vWkMaUHwhRoBg2bNvHDL9AByxAqaaMK
	GZX6Z4WXelKktaZY6iOpVTOJI0KYXtSHUvd1uLl+sP/usCcXM95IH7uQlPNOizlm
X-Received: by 2002:a05:600c:444d:b0:439:96aa:e502 with SMTP id 5b1f17b1804b1-43ba66e6317mr23309985e9.12.1740736072035;
        Fri, 28 Feb 2025 01:47:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMpqZHtWw25x/CXdE0O8ZmJYjwLSdDkcdsLYEE0B4k1HyvrahzYWDeM3cITJYP04WPN9mI8g==
X-Received: by 2002:a05:600c:444d:b0:439:96aa:e502 with SMTP id 5b1f17b1804b1-43ba66e6317mr23308625e9.12.1740736069879;
        Fri, 28 Feb 2025 01:47:49 -0800 (PST)
Received: from rh (p200300f6af284000f9ca1328aeaacdd4.dip0.t-ipconnect.de. [2003:f6:af28:4000:f9ca:1328:aeaa:cdd4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab2ee361dsm70304345e9.0.2025.02.28.01.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 01:47:48 -0800 (PST)
Date: Fri, 28 Feb 2025 10:47:47 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Mark Brown <broonie@kernel.org>
cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
    Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v4 5/5] KVM: selftests: arm64: Test writes to
 MIDR,REVIDR,AIDR
In-Reply-To: <ac594b9c-4bbb-46c8-9391-e7a68ce4de5b@sirena.org.uk>
Message-ID: <aad785e6-59ac-0e27-f567-9ef7af45636b@redhat.com>
References: <20250225005401.679536-1-oliver.upton@linux.dev> <20250225005401.679536-6-oliver.upton@linux.dev> <ac594b9c-4bbb-46c8-9391-e7a68ce4de5b@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4zKdPkVuzVQ4HM6kc23IbjIYXL2Z0LU8jiisWOsv_Sw_1740736072
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 27 Feb 2025, Mark Brown wrote:

> On Mon, Feb 24, 2025 at 04:54:01PM -0800, Oliver Upton wrote:
>
>> Assert that MIDR_EL1, REVIDR_EL1, AIDR_EL1 are writable from userspace,
>> that the changed values are visible to guests, and that they are
>> preserved across a vCPU reset.
>
> This newly added test fails with pKVM on every platform I've looked at:
>
> # ok 92 ID_AA64PFR1_EL1.MPAM_frac not arbitrarily modifiable
> # ==== Test Assertion Failure ====
> #   arm64/set_id_regs.c:557: test_reg_vals[encoding_to_range_idx(uc.args[2])] == uc.args[3]
> #   pid=3711 tid=3711 errno=4 - Interrupted system call
> #      1	0x000000000040287f: test_guest_reg_read at set_id_regs.c:557
> #      2	0x0000000000401df3: main at set_id_regs.c:710
> #      3	0x0000ffff9b207543: ?? ??:0
> #      4	0x0000ffff9b207617: ?? ??:0
> #      5	0x000000000040206f: _start at ??:?
> #   0x410fd035 != 0 (test_reg_vals[encoding_to_range_idx(uc.args[2])] != uc.args[3])
> not ok 8 selftests: kvm: set_id_regs # exit=254
>

Hm, I did test with kvm-arm.mode=nvhe but not with protected. When I do
now, this fails even earlier for me - with the ctr_el0 reg.

