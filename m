Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4DA260385
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740748900; cv=none; b=XAjTzrDIyHlxoa1mBvvohHgYMT1Lhht5RtBuby7jP8cq8a/9eAkwBgQ1bqPDH8hal5+4UI5GINmByWHBmJBOKw9Hac9O+PAIe0I8SWa9lXSxfP+guDEWH81Bd7LmcFk72I5WH5rfYYiPu+wpx1quWOz4Rk4OzNQZqL3D7I+hPRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740748900; c=relaxed/simple;
	bh=l6BUPhkE6k/x0CwfPSgLak5600ewq8glP4gmW4rpq+4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fFAKKZCpL2mQslPRhpNWYY5aCEUtaUQKqtscXgjozD2nUHMENmYj0HExXXOOkmBa2Ho50qRxC6zmj0P7FIisgX7R2aZi0fkrc1JmU08BCKb1RvsgWoS2fPNxaz6QUd4qEVM0pLfzZBsVTCNZ9bHVBWB3FGPQ/95j/tT9a/yH6T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NN/NIgvc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NN/NIgvc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740748897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uwV/UCRNua3hPz/xf0uGhzgHB0KocC0X/bBVcamfB4g=;
	b=NN/NIgvc3LEHQA2En0tZXPPWTBGnmc9SaxAAMdcQfb0YZpYaQbz5LFI2xmJfdAR4TRkUXu
	4T5Q+JrKRJAvQvp8Tef24GLuGvCaTqO8z7orIT8OkuQzU3Mew2bCfbAVBUJuATn+QLiad5
	OZxsciRT+ErlCfG4CMaq284Y3/ItL9w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-Uv5P0RQEM9KHZalpxlOo9A-1; Fri, 28 Feb 2025 08:21:36 -0500
X-MC-Unique: Uv5P0RQEM9KHZalpxlOo9A-1
X-Mimecast-MFC-AGG-ID: Uv5P0RQEM9KHZalpxlOo9A_1740748895
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43942e82719so15011265e9.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 05:21:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740748895; x=1741353695;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uwV/UCRNua3hPz/xf0uGhzgHB0KocC0X/bBVcamfB4g=;
        b=OyoZjkaQJ918f4Y24sSlw9aKTlYTD9tr4gQTXNfSp5cibEcKCzu/z63hrB3uHirAu1
         2jPPGvMdU2CVacBtMIzcEmoxBy13TEI5uVlLA1+RPUoS6BfmV52Vm102iTEBjP4geJzY
         s1hp0TedYGDSMS8cqNFSkpjdeUhpXc37gHfH3cN1qS2VDaRry6Kyma5zcIcJlb/bEwrY
         +UkSNoI+no4joNqpmZmZLJvTuH+jIiz5haO4py2ewMJv3ElguatnPUFn5m1VxyhG+oUb
         9QsoQuZAVnZbGrrF+2i0Sj5NR3nikVVLRqHnc8iVV0deq56uAAjsZPbOnXO8/rTBhwrF
         lBpw==
X-Forwarded-Encrypted: i=1; AJvYcCUvjKE+eo9KoMSxfKFQuatDnjdcxzgFJYhqyYf3KC3pNqwJ2sDolNUW2BIWqlF0gMaVKfnwHeA=@lists.linux.dev
X-Gm-Message-State: AOJu0YylgcdXtXtAepAxncimxvQV0a9x6FTTF1HBICEfdmXD4rE+pZFK
	jmdPUbJepDZrBwsvWZ5bWakhfeODhw66Uxhh5ubnQkiJ/8XaYmttWUbz6buHKVZaaRTEO3owgS3
	Vj5essEJJsaMKHyQGDdpiCayU68Hh7gCyR7aMdgA9KVgJ6g2tV8fXHg==
X-Gm-Gg: ASbGncshBw44DYPntQdtIH4mIegT+uxNJnbMMi7IHO06+oyP3lf/SzjlR7ZBDo88MAn
	br8MKqo+SUEhlaj9RdyNnCDSEL1dWws3rOucz5eV8Ye8c5+ExjwTEfbkp/73zL68ZJIFBCvCXfo
	8QcndtErLOfdk1p+c3UKtVGAdzV9evZOMQhlI1j94mnaQfgAfdnP6L1X5fw+RxX05XBQrfnpbst
	IxBnVX139zLhPw1+kWV/LCDBAj3LYwg2TbDyZeU6uBVTJK/uNVDtOADieuwlmlmjBdgL1x4siOJ
	FHBhEeEz+BwA7mfylU1k+jcP93LCZP5R7nH7QBxUYRaOCdjEP6Pk6wSTdrtHAoEb
X-Received: by 2002:a05:600c:1ca3:b0:439:985b:17d6 with SMTP id 5b1f17b1804b1-43ba6a84156mr24045615e9.27.1740748894942;
        Fri, 28 Feb 2025 05:21:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQbI4OrKRTQFg/d8IgZ9AqqAKChaekqW19EuZTsTiM4MTLrBpnvyx67dhl1ujzlAUxysbong==
X-Received: by 2002:a05:600c:1ca3:b0:439:985b:17d6 with SMTP id 5b1f17b1804b1-43ba6a84156mr24045365e9.27.1740748894556;
        Fri, 28 Feb 2025 05:21:34 -0800 (PST)
Received: from rh (p200300f6af284000f9ca1328aeaacdd4.dip0.t-ipconnect.de. [2003:f6:af28:4000:f9ca:1328:aeaa:cdd4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43b7a28b75esm55688755e9.34.2025.02.28.05.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 05:21:34 -0800 (PST)
Date: Fri, 28 Feb 2025 14:21:33 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Mark Brown <broonie@kernel.org>
cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
    Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v4 5/5] KVM: selftests: arm64: Test writes to
 MIDR,REVIDR,AIDR
In-Reply-To: <aad785e6-59ac-0e27-f567-9ef7af45636b@redhat.com>
Message-ID: <c0ee9e23-59bc-6017-21fd-a751f9451f27@redhat.com>
References: <20250225005401.679536-1-oliver.upton@linux.dev> <20250225005401.679536-6-oliver.upton@linux.dev> <ac594b9c-4bbb-46c8-9391-e7a68ce4de5b@sirena.org.uk> <aad785e6-59ac-0e27-f567-9ef7af45636b@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: inQLFR46pNKsIqxmtz_ymy0pEpsFHpXSX3FnGxY50YA_1740748895
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 28 Feb 2025, Sebastian Ott wrote:
> On Thu, 27 Feb 2025, Mark Brown wrote:
>
>>  On Mon, Feb 24, 2025 at 04:54:01PM -0800, Oliver Upton wrote:
>>
>>>  Assert that MIDR_EL1, REVIDR_EL1, AIDR_EL1 are writable from userspace,
>>>  that the changed values are visible to guests, and that they are
>>>  preserved across a vCPU reset.
>>
>>  This newly added test fails with pKVM on every platform I've looked at:
>> 
>> #  ok 92 ID_AA64PFR1_EL1.MPAM_frac not arbitrarily modifiable
>> #  ==== Test Assertion Failure ====
>> #    arm64/set_id_regs.c:557: 
>> #    test_reg_vals[encoding_to_range_idx(uc.args[2])] == uc.args[3]
>> #    pid=3711 tid=3711 errno=4 - Interrupted system call
>> #       1	0x000000000040287f: test_guest_reg_read at set_id_regs.c:557
>> #       2	0x0000000000401df3: main at set_id_regs.c:710
>> #       3	0x0000ffff9b207543: ?? ??:0
>> #       4	0x0000ffff9b207617: ?? ??:0
>> #       5	0x000000000040206f: _start at ??:?
>> #    0x410fd035 != 0 (test_reg_vals[encoding_to_range_idx(uc.args[2])] != 
>> #    uc.args[3])
>>  not ok 8 selftests: kvm: set_id_regs # exit=254
>> 
>
> Hm, I did test with kvm-arm.mode=nvhe but not with protected. When I do
> now, this fails even earlier for me - with the ctr_el0 reg.

For the CTR issue we're not setting the trap for pkvm. It works if I just
set HCR_TID2 - I still have to figure out how to do that only when needed
like we do it for the "normal" VHE case.

For MIDR it looks like we're not setting up VPIDR_EL2 for pkvm.

Sebastian

