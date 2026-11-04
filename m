Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793792245;
	b=0rX2fLyWcRuYhlvR66YPSMnBV4s1wrohuD6EfuLetQ0tGV8kjQzQaL6GGpuAc4ulrdbB
	 EF9kyqLdUk0mgk3losYHPU+IbfV4uBZQIZmnHklVd5VU4V2sATmaGlmiEdv8b9CgT0+Bk
	 /GEx3VzDxb7ehkr5z49AoJRssek8ZI7uheLlpFXnbrpN/RD006IrACDJfQUQJaR4aejRj
	 t7IJ3Tno6jMTj+2dpWVt+k/GGuBw8Zd8A+iH6Mf31lNxycGP/tAjZQRd+5bIGEhGJF2+y
	 TGkrl9cB6VoBwKM+ObiBxa4jdowd3Y6oCqzxxVwf+tBAjBuyElui5F07BwICNwGYmqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792245;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:
	 References:MIME-Version:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type;
	bh=ozSGf2zyuVYYLVzmKkiurYsLvvrqYzVSGZ8tHSkd2EU=;
	b=PxVEPbb2vM0YHaRRNSYWnWx6uKzTawHLS/7iKYIIqZu1BrkM9wBeRmL20UH7NV4WPnY9
	 /Fzzk2fONXlkZxHin8IVDh0po1vQg7kNWxJdBBc8SWh0234ssvsMjs73cedneNwLhHGW1
	 idbxBiwL8bZJ67WHcsZpOQk7k9YEuTjbM3V1aNzXrQAD0Tv42T4zrfNimApWWbTxyHxT9
	 hzzV5j7ApV3LFE5jbQOLPktJgVxPrI+vdygFyXmoOYmkwAE0qio670h1b/m/BHLQE3s1n
	 7gV6wqi8ZQ7FqIGMeCRT9SJRJsnCRYR2PHUh2GgwSr/Ct1HCH6XO2SRyGd0taIpSYHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gaBmgHR4;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EAB606EE9B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 11:37:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31EAB606EE9B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gaBmgHR4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793792243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ozSGf2zyuVYYLVzmKkiurYsLvvrqYzVSGZ8tHSkd2EU=;
	b=gaBmgHR4BR5KhzzjedYykjxmp5nDN7co/1bCU/XsQdNXpGylT5z6TuJdOJovX9JFETJ2hA
	7srHc3RDZnBORBpQSg8XIzy8aJqZW63WmXXxJifinADfNHVLH94TrCVBLltR5VfRi7U5fW
	2+PvGYQGc2LRBen0zkH+NWF9s30KFQ4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-_Sx-MYMrNKSCOlX9UZhqCA-1; Wed, 04 Nov 2026 06:37:22 -0500
X-MC-Unique: _Sx-MYMrNKSCOlX9UZhqCA-1
X-Mimecast-MFC-AGG-ID: _Sx-MYMrNKSCOlX9UZhqCA_1793792241
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48e011829easo393220f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 04 Nov 2026 03:37:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793792241; x=1794397041;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ozSGf2zyuVYYLVzmKkiurYsLvvrqYzVSGZ8tHSkd2EU=;
        b=yWyCpYpr6MqktXgy053sXvYl1UUG2fmSs5njdHS7HZyM7msrSq+v97t7XIuL+JngRt
         r+FxALR41TQnUrkQLoc+xU0/Ao1DHxZfIYXy1Vf7ty9QSNTcuFnitG95dPHFQXEKo1OI
         JF8qNZrgYRKvV4DFkW69h/OdPy8HIJ189UNf9O5aoTjGzu4Y2apjKQ1/FhrO+EIZZ2Tk
         Ra/ga+rvB0H+fkwoQsRevxHfJiMNu4mceQdN6qPORRCcDDUF++dwL2byMXzR0p7XSrcn
         OyG6sNi1RtwV5v5UxaYnBJWhM5nolPnxcQVYJ00eFdPc2nWo6kFRKSbII61syfALE/2W
         cerA==
X-Forwarded-Encrypted: i=1; AKwUvBxnhEH4bp44IfoM+HPWhnwswmlj97ptHMuNL/4GZGc72Z1UWcXoNbqSLLgsjrNGTJ2zwBeh2y8=@lists.linux.dev
X-Gm-Message-State: APuU4Z/LSBQYQpRKqVg7AY0gL9YpHi17Odo7JJfC854iGS7t30de0NDO
	S4yuRfugXusKoJY5mrR41DVM3s2azl4KKGKvO8Ybu6iP5lVrFWACyenl32/AM4QirzvMmBPpLxE
	VIxIwz6FB6uitpizTAegTVrt7MwMdJNjtAmp1yxFysbd5NmjqSFlK0T7jFw==
X-Gm-Gg: AYBFou3yJSGs5EB5wpJYzZM6/3+14/21v+5OCrGp6BQF0lJdGbpQTcyTuIamwH0/T46
	kJF7rXNKhEtTY7+AlKH2D2QBI5jKhfhbKeBcWV0+Zxsaz5/ccnv6+nxoqMcFcccS2yhQIkGHiEi
	MmRmb000bQL03q6YM/NC7NDO3y1GLOQ2ziNWNGg7/hVSodletyaVZE1j0W5H2BrPaIeFlJkxZqN
	zGtVi4tQqzE57XoZhA2o+cv5wfco4fKPL+ZD1iQgc1Py+9R1UcJSqOVezlXSK6uHZzEpeEC/Ofd
	ZfdloeKtdb60yx2ouaWOgNguaY8r6cnIlT8pjfmY0SRLk3inMIG+12S/jXAu1x/Ez6gqQ1Pp/GD
	OmRsq4ziGnuMsZQX3DH42EybC7fb366SVUjzBE6x59KQAIUNR/BclgWXl11EtqkT+TsJfoFn0/l
	t7xeC09zAtu1AlAqtbXIY90qA1JCV1sIZKtdR/lQ==
X-Received: by 2002:a05:6000:260b:b0:48c:4553:790b with SMTP id ffacd0b85a97d-48e6e50075cmr31750658f8f.48.1793792240868;
        Wed, 04 Nov 2026 03:37:20 -0800 (PST)
X-Received: by 2002:a05:6000:260b:b0:48c:4553:790b with SMTP id ffacd0b85a97d-48e6e50075cmr31750621f8f.48.1793792240514;
        Wed, 04 Nov 2026 03:37:20 -0800 (PST)
Received: from seott-rh (p200300f6af1574019b2c5947d8ec139e.dip0.t-ipconnect.de. [2003:f6:af15:7401:9b2c:5947:d8ec:139e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fece99d67sm3430641f8f.24.2026.11.04.03.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:37:20 -0800 (PST)
Date: Wed, 4 Nov 2026 12:37:19 +0100 (CET)
From: Sebastian Ott <seott@redhat.com>
To: Mark Brown <broonie@kernel.org>
cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
    Oliver Upton <oupton@kernel.org>, Ben Horgan <ben.horgan@arm.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-kernel@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v9 0/3] KVM: selftests: arm64: Improve diagnostics from
 set_id_regs
In-Reply-To: <20261103-kvm-arm64-set-id-regs-aarch64-v9-0-ab32bc79fa9c@kernel.org>
Message-ID: <7db30970-dc9c-702a-2f1a-f52c2e253494@redhat.com>
References: <20261103-kvm-arm64-set-id-regs-aarch64-v9-0-ab32bc79fa9c@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f8FOgzex50xEd_LS49eZ5ibklprecOkpDP0mkrWUugs_1793792241
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 3 Nov 2026, Mark Brown wrote:
> While debugging issues related to aarch64 only systems I ran into
> speedbumps due to the lack of detail in the results reported when the
> guest register read and reset value preservation tests were run, they
> generated an immediately fatal assert without indicating which register
> was being tested. Update these tests to non-fatally report a standard
> kselftest result per register, making it much easier to see what the
> problem being reported is.
>
> A similar issue exists with the validation of the individual bitfields
> in registers due to the use of immediately fatal asserts. Update those
> asserts to be standard kselftest reports.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

For the series:
Reviewed-by: Sebastian Ott <sebott@redhat.com>

