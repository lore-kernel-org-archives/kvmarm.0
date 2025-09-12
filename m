Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978BC274FDB
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 11:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757676834; cv=none; b=jhaWszcswoeFhuYWHgTX7J4Qj5A7HmICaAdYkxrUqmyMRcp342r806DDK0MdOJmRta7rHvkavL3bg7+GaV4v37ODX+AhQrG0j+eD+F3suyRanZryADU8cz2/6RFzSLM/b9MutFgACr3eQsYGtbCK/K8LVgU4w24mYSTKMWJ+zRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757676834; c=relaxed/simple;
	bh=XBHAModFzS9RT7TpF2/ykWjDQcNt9+bCE4YK2ZwUuV0=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=rtwsR6nkdRNX2mu62IdTqak2j+LpHxMHsQHcY4ShtayQoKz19uxapSte1jVzX75CdT4wPLqZh/JHo61ITxLVLYNycCt0fHXC/CvYI7AQUblD9PP7bEPOAKzV4c0aF/AQZXVbKF1B5mJt38pMnxuO87Stw7eW5yvrFxjlBlvzrSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OOPJOgRR; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOPJOgRR"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-32dea064b51so565661a91.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 04:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757676832; x=1758281632; darn=lists.linux.dev;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Me3gQ2+XLChgmuRgGxhLuD7lEdljJYpRCmXxWniexUs=;
        b=OOPJOgRRN7yTIG1QY7YkmG+D8bqyoLyd6oleoQECGl8wsiE+aEzMI6beO6f3mijwc4
         pNfQuJ1PGKpNpJgOyBPm7XTXiZCib8iZ+TjzY9Fh5jKW68PfdYQpvYNHOLX1PBU/sKc8
         NE60/L0m6+HTfwCfO5EPi5xsL8nBar4wWhtstJGZkih61TIu85BFsEhjUVSj0l+NukFQ
         4LrJhd26nG63hpdDuBjgyyJ4Yev4+224wswVjYumtW9Eq6wCSlWaAF/5TQElCwZ8AiXI
         hX1XS+NcXebuBkKxxV+MfWOtmaU5/wQ2HiuDAdvDvUKpUDXuEAJfGzSSRzQkmRrqixoK
         tMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757676832; x=1758281632;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Me3gQ2+XLChgmuRgGxhLuD7lEdljJYpRCmXxWniexUs=;
        b=qvYjDUwh+w573PxePIK9nHARVWv0ttZvGYgWfcYk1/5DFF0tPz4uMmE801Wag3X1mB
         LJAkvXiGNbZ/wzDMZ4a/T6Gj6jDoAxWKtJb0bPZNPvdGWpXVOXAeV009w1cZaHlCQe5W
         rh/FTlhk9R3JrLRWetqOKUtGUzsInHt88ag56d2sH7cRLvt001dWaBETey0/Q08Lw8vh
         kkRyH499NTApBjVIxcSkmiZuDb6RWPyLQ+0Frhn5tdPHhpCbwoLRyDmLas9WuvgQ9SLN
         qCA8KIBrdKoJn10x4YivFbDwfXpNegf94qlc5JPAbV6HlrKnRYeVwYueaD+inhWftHeX
         2xKg==
X-Forwarded-Encrypted: i=1; AJvYcCW0MRfqSqnZM+vK0lyWPyL1Z2OUVcY5Te2C1KZbVI0WnE164B82Ir9fXhqPfn0w0hpzXX51joQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUU9aDmWpEhZ/NoidtomFFhkJEVO/8qgvWmyxlM5rLgQxSM4vT
	8XFbug/Z7sQn7kpNpmlsZDY2WRWCeyJI1NAgaR9FuNLZh9XsbIhqbYYy
X-Gm-Gg: ASbGncsI+F4UyNvvGL1hBkQP1HTmf9dsYCPnzadRGgMg2ExlZeA0jIxHxnp+YJS+M56
	8ZlbyBcszAu3fQPkxMda6SWUwtFZgAFngIvlnu3ogVFiTvKAoQK0aWSuged9s4Yo+btANIallMR
	1gBjNOE8dhNaTob4owyZiInxOP/XNl8MB4Auja3ZGRvIgIlUKxNwMoGAlO2QPv1MdlUnJdm3LPw
	XTiq0jElQPsfOvqATkTX87gLq0+ZuJX8nrkTML2ola5FY9F0RkoUBZoLazUnbA0BpqBh/nVhQpn
	W+pWfuIK00BjIuVIUpPScGXZEZ4ou71L09O55Uqpu8vk1kW9yuwqp89D5ivYcUKMUlKDRHC7+mK
	0VhT0VzPnOZgGI7w2Gkwp+yn1/vi7hyjaYwhTC12Mg6Vou6cxCMZ8K2/JpOiwQMGlXxqEIT+xLM
	FsoZFmMDY=
X-Google-Smtp-Source: AGHT+IG4CQOrsidgDKZqODfMcOoJgWe/C+OuZOd1ih4oVDYDwhAJqojGn09l0Bnkzu0cbpihXieC8w==
X-Received: by 2002:a17:90b:3889:b0:32d:5721:df96 with SMTP id 98e67ed59e1d1-32de4f808f5mr2582134a91.32.1757676831756;
        Fri, 12 Sep 2025 04:33:51 -0700 (PDT)
Received: from smtpclient.apple (p73a27f58.hyognt01.ap.so-net.ne.jp. [115.162.127.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd7ceecfasm2203933a91.7.2025.09.12.04.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 04:33:51 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Itaru Kitayama <itaru.kitayama@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] PMCR_EL0.N is RAZ/WI. At least a build failes in Ubuntu 22.04 LTS. Remove the set function.
Date: Fri, 12 Sep 2025 20:33:39 +0900
Message-Id: <3FEB4D87-EEAF-4A21-BCBC-291A4A7C2230@gmail.com>
References: <867by4c4v1.wl-maz@kernel.org>
Cc: Itaru Kitayama <itaru.kitayama@linux.dev>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 K Poulose Suzuki <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>
In-Reply-To: <867by4c4v1.wl-maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>
X-Mailer: iPhone Mail (22G100)



> On Sep 12, 2025, at 20:01, Marc Zyngier <maz@kernel.org> wrote:
>=20
> =EF=BB=BFOn Fri, 12 Sep 2025 09:27:40 +0100,
> Itaru Kitayama <itaru.kitayama@linux.dev> wrote:
>>=20
>> Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
>=20
> This isn't an acceptable commit message.
>=20
>> ---
>> Seen a build failure with old Ubuntu 22.04 LTS, while the latest release
>> has no build issue, a write to the bit fields is RAZ/WI, remove the
>> function.
>> ---
>> tools/testing/selftests/kvm/arm64/vpmu_counter_access.c | 6 ------
>> 1 file changed, 6 deletions(-)
>>=20
>> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/to=
ols/testing/selftests/kvm/arm64/vpmu_counter_access.c
>> index f16b3b27e32ed7ca57481f27d689d47783aa0345..56214a4430be90b3e1d840f27=
19b22dd44f0b49b 100644
>> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
>> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
>> @@ -45,11 +45,6 @@ static uint64_t get_pmcr_n(uint64_t pmcr)
>>    return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
>> }
>>=20
>> -static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
>> -{
>> -    u64p_replace_bits((__u64 *) pmcr, pmcr_n, ARMV8_PMU_PMCR_N);
>> -}
>> -
>> static uint64_t get_counters_mask(uint64_t n)
>> {
>>    uint64_t mask =3D BIT(ARMV8_PMU_CYCLE_IDX);
>> @@ -490,7 +485,6 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t p=
mcr_n, bool expect_fail)
>>     * Setting a larger value of PMCR.N should not modify the field, and
>>     * return a success.
>>     */
>> -    set_pmcr_n(&pmcr, pmcr_n);
>>    vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
>>    pmcr =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
>>=20
>>=20
>=20
> So what are you fixing here? A build failure? A semantic defect?
> Something else? What makes this a valid change?
>=20
> Frankly, I have no idea.
>=20
> But KVM definitely allows PMCR_EL0.N to be written from userspace, and
> that's not going to change.
>=20

Then I=E2=80=99ll drop this patch.

Thanks,
Itaru.

>    M.
>=20
> --
> Without deviation from the norm, progress is not possible.
