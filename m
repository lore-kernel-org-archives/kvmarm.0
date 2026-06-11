Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E1B331230
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 20:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781208992; cv=pass; b=MXIz5F4Tw/ESSCxGWo5f/JhMiYEbxEfYkazTSwVqh5+m4RxqwEXLSTMVYOLuMx1od+COAv55PnimOVA5TW2xX68ac2CxCsvYZvLEGriQyaJd8T7Ju6xe4cbvH2ZZ6O7iZxIlOWmYwdTqAn2YQkRBmXPFfRAQvPYN/b5UfPxoOr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781208992; c=relaxed/simple;
	bh=hJba3+vHUhRZcQprsnZOYpmT859TwISmDOQQW+AUK/A=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tq4zBHXifgYR7pQlpj7fifHkD43KwIffCDPHZssAgIm0pVevd0/smcDYjUbnMirY9K10SdHwGshf4UBLF6T/gu/4jL0lfa0iEsRWy3TYXoxpb0b/Lced6VtIk2BgNarg1sXnYGB7lrBXCI8IYkC826wai6sqg08BHHNsQneuovI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v56LczTV; arc=pass smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v56LczTV"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-13809223fd4so276757c88.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 13:16:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781208990; cv=none;
        d=google.com; s=arc-20240605;
        b=cJpHpNXwvZeivIicI7dSkoW9XmFQH+F1D4mLUVNioJ61LTJtSThiXL0VhhJlP+Ekw+
         1RJ5zfsfAUe++LRjSUmWpQQOnsXoJa+WD4JsDoBWJ0cGfrN56XStjaNHrnpoGEp1Jlhf
         KYHoNO+Is5+iSdh6FbcGME9dLz4GbuXi9ukdbRC2YAbP2lJcS6Dums0lqxp6b/k2j+Gt
         UUBRNXnn6Oxm4LU2o0/B3webEy6j/W4kkDSx6L6yepPresEVuDvkA7mjkTJ29oPwGX7Y
         bPaQxisa8ZcEU05GWbOOTK0lrwfjA1T2OG4l/6jHgsNuMxxhsswXsI3bpRNj2A7rpzBG
         jrVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=c6w4o8cPFnkNvj1bY6N4ohMTXqYLTs78fDk/pXJtYGc=;
        fh=k9u/hPHns2PRcYuLsOSZvENebeLRvcFcA5w0fiOty1k=;
        b=FeuHhGOanCgoogMIPNuu06B114rCr7AWdUiBWKff28ZrPVH8FVfb9A8lbQCGOZMJcX
         sTdbSAbVXx1+c2+m6pbDj4IIJ7qysX54+bvTGjMxWxlD65YqzHlHap8OmL3mmTwgvM1I
         fRJoh1Zl1IKAFd9a/HFNYu5OqCITsvO+e9zO/n/aCm6flfIokIDRWDsfvBCjNFeUsdwI
         x4l5/yaXW2xcLjyyXlUNKQDb7b7O8XEfNbXRWbJolyEH7PBON8JLAsKxmExgjNF3JVP0
         kTT4rIV65ZmgS2SatB/K6c1S8lGL7LCapqXy0Cyo5rDtA0KiaHQM5KWKlHeUPyTJXHDb
         il8g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781208990; x=1781813790; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=c6w4o8cPFnkNvj1bY6N4ohMTXqYLTs78fDk/pXJtYGc=;
        b=v56LczTVdpSjWr50VPgFZMhD9GKu3HUd3wbnK7CJugWCGmYDNegPzd9FBHSAgDpOLG
         Gxl8v5acG5mxYF/iniYB/gq0PGvts9G6vsTL9rHP4gQ8Pm38GGRdh/huK2cDcmGh44/J
         ItwwdohtacL3bWfkGRZ9eSpV8KzEyiOIcG10pWlSSCuYA+PtbqlM41sgqqX3sEZYO4I6
         FZgBLkmQ4jcml3hVU4obcDbs5/wwKphszNfrRlKIbSrqSTguVWGdBD5XTGDLQMl+j4Kf
         syptLPASUD9yOM3cUZ9E+yTTFXPLoWDntheA9guuyaVYe0H2F7MbsIT6T5KrR9BvPO8J
         mIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781208990; x=1781813790;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c6w4o8cPFnkNvj1bY6N4ohMTXqYLTs78fDk/pXJtYGc=;
        b=Y45WTXOGOyHjTkyy7hrYMitiAf3cHwaZWipX87+K1FQPBGLc3uoT5yxfo68ySckm+W
         5koAdczT48YIP4Ekuf49lMQd1f0hV0bkzZpPuQ5yq5Jal2M8YZnrL5qtRdzvQYXtIYxI
         wGsVWD2Bzq3bw4ogsU2JR+7LF0vCKRh6CkQ7YF5U9PYfSfzVLJGjBpX45PSw42ynye7B
         7YLYEHprbhQsedIGqvVagcpt03YukT9gQhK6DPU/FXnFUnyO+uIKfTa68EYUGnNnvsuQ
         iuoWiF77RhhMb0mpGPnPKDPUsbtp+YUkAseDOQhz0ThOJc5yWdCmlJ6tKzwrVv3LTYmF
         Ut9w==
X-Forwarded-Encrypted: i=1; AFNElJ+8Ig9BumlJVYt9+jJFn0K03f/Yl4Jrd5fmSxh8NtKOF440QkLajTDFwTl7Fm1vrdStR/tD5P4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcIjaU+KJNe2W/GEcz2PnuGMzvAM53wvm4E57SlLZnLBOHbBZq
	V/93mqN2+SLk0BSdmYwbagovO3Ad0kz35vrODYA8DiK5Kwv5UJljyEa7ByDXZwnYf+u2TUMBFNC
	bNYQ947zqcbEes8cOvGwONb4eUSDrQv7I8NQsm/z2
X-Gm-Gg: Acq92OFlRpPgWvB/Vd+L1F4N5bLznHd76NBk4YCGim0bTzb2afkBp6hguTI17WPlRoZ
	Hkgdvf8dUk1UYsNPpR+L/198nKxJhjPoerpjICjmtzGoULP7Oqljl9ed4tkztmmf911rNLdknsy
	kfJfKf8PzmN2EZ03WO6daiPQ0iLyIkuToZa12zUpPJ0P/Km6Jg4k2R+0fDNhHchKLh3UUVAhabR
	0KK8QHTsAZiiLXYw4ISM742y4U1RgF2yJ0irnHvavbh2snE6k2h7sVhD8OHzeVOFWkglkDFtK43
	ZF81+VIAPl6Pz0WT7LK5X86imCOwvGpEwFDdIK2PA9Yx28tLRmhJnPUfEggsrdC++mCMjQ==
X-Received: by 2002:a05:7022:fd04:b0:137:fb6c:5355 with SMTP id
 a92af1059eb24-1384211e6fcmr2478309c88.3.1781208989421; Thu, 11 Jun 2026
 13:16:29 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 11 Jun 2026 13:16:28 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 11 Jun 2026 13:16:28 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aisHySKe0PwM5DSg@google.com>
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-2-vipinsh@google.com>
 <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com> <aisHySKe0PwM5DSg@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 11 Jun 2026 13:16:28 -0700
X-Gm-Features: AVVi8CeGqWOzdSyzWUUivrRwH0AG_QWu1g0DCt9ZOfKtFkCXDKefnGkWsFu90NU
Message-ID: <CAEvNRgE-qt8DAjOeE5ANpXzrgEKs+2_wh4YSmY=pe6krngBXqQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] KVM: selftest: Create KVM selftest runner
To: Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jun 10, 2026, Ackerley Tng wrote:
>> Vipin Sharma <vipinsh@google.com> writes:
>> My (future) use case is that with hugepages, I want to run something
>> like
>>
>>   ./guest_memfd_test --order=0
>>   ./guest_memfd_test --order=9
>>   ./guest_memfd_test --order=18
>>
>> And 0, 9 and 18 are the supported HugeTLB orders on the machine being
>> tested. I'd like to iterate over supported HugeTLB orders at runner
>> runtime instead of at build time.
>
> No.  The right way to handle this is to define testcases for the "interesting"
> sizes, and then rely on the test itself to SKIP if the size is unsupported.  This
> is no different than a test that requires EPT, or nested VMX, or nested SVM, etc.

That should work too. So at build time I'd make it define all the
possible HugeTLB sizes on every arch, and then skip as necessary.

Why though, why not find the supported sizes at runtime?
