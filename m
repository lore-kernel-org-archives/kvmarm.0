Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42752798F1
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 13:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833727; cv=none; b=Ym77nT4Slb0cV7YwUZAMVz9OJbsOvYs7GfPHFPFBG3dDeX2p3orYY+51iPQabyylkgzH0jl7Sgj5Jl+SOwQEbs/FQsCCn6UahrFYHWXS3YMxMClUNaB3JZwLfPAQB5HMg7igbhqkh/c8MTOacmrLWABHhHYLP+e82uRtq32wJ5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833727; c=relaxed/simple;
	bh=MZn66zt6b+O/DmEtYUoFeKJJpojbXHf5RpVJ5ngWf5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TSCQfjMhjGmqrxQUWti++Ja3Js/lNrocULWDYiszhRHVDYe2l3yY7ApnUxkFej1an+Q2chQeHpJT5fCcDdSzNM26S7Ctth5Pqh9zeP+Kf5fV18qhKAVsDz5n4T4ct44MORmYvid6rapJJe6X7eJMOxt5RWfJltrqCwXRIcFSPE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G6N9WvAi; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G6N9WvAi"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ad1f6aa2f84so1313347966b.0
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 06:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1747833724; x=1748438524; darn=lists.linux.dev;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MZn66zt6b+O/DmEtYUoFeKJJpojbXHf5RpVJ5ngWf5Q=;
        b=G6N9WvAiv28Mv/8n/IOQzJ4CYin/ys3ddtbxwTGxQffttWcLlrwNcwYSgkdSrdNhCG
         RpNE+Q2Z/hLSlUTXsT4uF9WFupXUfyyMo1HjvVNOmDTd7TaKgsULd36z+04BoFSTarFD
         iKYQH29+WeogQZxHUTgFw40yfdwx+jj3vwslN75/C8YagR32DZTGGBaHX5AmEyvDIEx0
         u1rpHhaI6wD3u4WDduOrzs3UC+sVI5GthSTBYfRL505viBPeeySJJDqPI9eq19r8ZWol
         zElcH6S80HPBFc7ScxJAConwC0Kv7j7CvSFxyoqb7XYSEu0jkSo4CY90gyavFaJNuOB8
         4ZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747833724; x=1748438524;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MZn66zt6b+O/DmEtYUoFeKJJpojbXHf5RpVJ5ngWf5Q=;
        b=cu2vPeus7fHti2nIkAXNS45sgcm0rHmktZRmwpu1tUNVCSSyL33Qhaxk6P00so7aht
         iQzr9JuNO693TlgqYmCr9fkgj4QDX1P1aRMc8eCkZxNgrWC4pQrZ/mhjX2NHV/G4XnTE
         N7rqsA1km5wtQqE8fsE4s5vLI7BWc2OKVa9WdNf19bhRQeYkjd+NK3OY6Mz3yrDBKtBh
         g7SxRN+/QkhHD07BDde2E5SyDaOokD9ep9f+dbV72Ab9YJI/vRtJ936UuaTGibVPXIY9
         Ka4YRISZVCtbyciX95jeIXyMXsfaL5ADzLURmYLBCDqDi+GcD2XTn519xSCsK6yerqjF
         NXGw==
X-Forwarded-Encrypted: i=1; AJvYcCUPg1GMHZhAXA8qELSoWDwG98HM+iYp02FidUL2LITegm7QKpayHypNPzHZHif+hQIE3uD+Wdw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYvGy7X+mDthmQK8GEIl/af+MkLkgB1bOrK9Kl7/1AJ5Q6GiXp
	ALxH+XbAnQI+wEqczkvTK6D1ZO52igLwY4Fd4qDz1vs3bnkDDQV0xzhrbySLakgwg+k=
X-Gm-Gg: ASbGncvOAmZ+fxDo/lz5DQ7aFtpyjARDYJ2vVyBQ6ToFO2FuSQdmSwuq7Ah8oZ6Alxm
	+BkCtdANHsjzmvTR5Nu3BTsayjQhUXpg+n/DC6I/I4M1Ut0+N71JBw4hnyzF5Rt4rPwkCJYJF9O
	tZcFRzRX7jMmQU8indeXswMBUO/lavyzzRO9byc9VBIAyw2MN/Lh+rk8MR1JfFxEWvlcRHV3buL
	zhin7RDc0+FM2WSbrCeI7T1wI94+oW+0rBTnq1XTueykfQmvVIWmaR7eBVAHW94DAfNJOAmrtlT
	P8DVyXA9Bw/d7GcvMXpMXqEiYwSOHhNa+a2eQzRWmac+IdympuyfQxPvgCXN0W3EvIKU1mpI
X-Google-Smtp-Source: AGHT+IHt+dgduV/hBym4KkA1LBbxXWQM2ER2oN53h/LH6idBpPbFln4IbInqwE+1bELqjceK1zV7XA==
X-Received: by 2002:a17:907:60d2:b0:ad5:54ec:6b3c with SMTP id a640c23a62f3a-ad554ec711bmr1419813766b.27.1747833723850;
        Wed, 21 May 2025 06:22:03 -0700 (PDT)
Received: from [192.168.62.38] (server.hotelpassage.eu. [88.146.207.194])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d278adcsm893295666b.84.2025.05.21.06.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 06:22:03 -0700 (PDT)
Message-ID: <c7064b0c-5a86-4138-b8d4-a90bd7e6751c@suse.com>
Date: Wed, 21 May 2025 15:22:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from
 add_wait_queue_priority()
To: Sean Christopherson <seanjc@google.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>,
 David Matlack <dmatlack@google.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
References: <20250519185514.2678456-1-seanjc@google.com>
 <20250519185514.2678456-9-seanjc@google.com>
 <20250520191816.GJ16434@noisy.programming.kicks-ass.net>
 <aC0AEJX0FIMl9lDy@google.com>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <aC0AEJX0FIMl9lDy@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------idgL64wWd0XJbGhVIRhfCOsT"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------idgL64wWd0XJbGhVIRhfCOsT
Content-Type: multipart/mixed; boundary="------------DjGcuZBWqEwJAq0pbLlY034h";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>,
 David Matlack <dmatlack@google.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Message-ID: <c7064b0c-5a86-4138-b8d4-a90bd7e6751c@suse.com>
Subject: Re: [PATCH v2 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from
 add_wait_queue_priority()
References: <20250519185514.2678456-1-seanjc@google.com>
 <20250519185514.2678456-9-seanjc@google.com>
 <20250520191816.GJ16434@noisy.programming.kicks-ass.net>
 <aC0AEJX0FIMl9lDy@google.com>
In-Reply-To: <aC0AEJX0FIMl9lDy@google.com>

--------------DjGcuZBWqEwJAq0pbLlY034h
Content-Type: multipart/mixed; boundary="------------am4Ts5qW4sbdeEquBHmBBqW7"

--------------am4Ts5qW4sbdeEquBHmBBqW7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjEuMDUuMjUgMDA6MjAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IE9uIFR1
ZSwgTWF5IDIwLCAyMDI1LCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4+IE9uIE1vbiwgTWF5
IDE5LCAyMDI1IGF0IDExOjU1OjEwQU0gLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+Pj4gRHJvcCB0aGUgc2V0dGluZyBvZiBXUV9GTEFHX0VYQ0xVU0lWRSBmcm9tIGFk
ZF93YWl0X3F1ZXVlX3ByaW9yaXR5KCkgdG8NCj4+PiBkaWZmZXJlbnRpYXRlIGl0IGZyb20g
YWRkX3dhaXRfcXVldWVfcHJpb3JpdHlfZXhjbHVzaXZlKCkuICBUaGUgb25lIGFuZA0KPj4+
IG9ubHkgdXNlciBhZGRfd2FpdF9xdWV1ZV9wcmlvcml0eSgpLCBYZW4gcHJpdmNtZCdzIGly
cWZkX3dha2V1cCgpLA0KPj4+IHVuY29uZGl0aW9uYWxseSByZXR1cm5zICcwJywgaS5lLiBk
b2Vzbid0IGFjdHVhbGx5IG9wZXJhdGUgaW4gZXhjbHVzaXZlDQo+Pj4gbW9kZS4NCj4+DQo+
PiBJIGZpbmQ6DQo+Pg0KPj4gZHJpdmVycy9odi9tc2h2X2V2ZW50ZmQuYzogICAgICBhZGRf
d2FpdF9xdWV1ZV9wcmlvcml0eSh3cWgsICZpcnFmZC0+aXJxZmRfd2FpdCk7DQo+PiBkcml2
ZXJzL3hlbi9wcml2Y21kLmM6ICBhZGRfd2FpdF9xdWV1ZV9wcmlvcml0eSh3cWgsICZraXJx
ZmQtPndhaXQpOw0KPj4NCj4+IEkgbWVhbiwgaXQgbWlnaHQgc3RpbGwgYmUgdHJ1ZSBhbmQg
YWxsLCBidXQgaHlwZXJ2IHNlZW1zIHRvIGFsc28gdXNlDQo+PiB0aGlzIG5vdy4NCj4gDQo+
IE9oIEZGUywgYW5vdGhlciAiaGVhdmlseSBpbnNwaXJlZCBieSBLVk0iLiAgSSBzaG91bGQg
aGF2ZSBicmliZWQgc29tZW9uZSB0byB0YWtlDQo+IHRoaXMgc2VyaWVzIHdoZW4gSSBoYWQg
dGhlIGNoYW5jZS4gICpzaWdoKg0KPiANCj4gVW5mb3J0dW5hdGVseSwgdGhlIEh5cGVyLVYg
Y29kZSBkb2VzIGFjdHVhbGx5IG9wZXJhdGUgaW4gZXhjbHVzaXZlIG1vZGUuICBVbmxlc3MN
Cj4geW91IGhhdmUgYSBiZXR0ZXIgaWRlYSwgSSdsbCB0d2VhayB0aGUgc2VyaWVzIHRvOg0K
PiANCj4gICAgMS4gRHJvcCBXUV9GTEFHX0VYQ0xVU0lWRSBmcm9tIGFkZF93YWl0X3F1ZXVl
X3ByaW9yaXR5KCkgYW5kIGhhdmUgdGhlIGNhbGxlcnMNCj4gICAgICAgZXhwbGljaXRseSBz
ZXQgdGhlIGZsYWcsDQo+ICAgIDIuIEFkZCBhIHBhdGNoIHRvIGRyb3AgV1FfRkxBR19FWENM
VVNJVkUgZnJvbSBYZW4gcHJpdmNtZCBlbnRpcmVseS4NCj4gICAgMy4gSW50cm9kdWNlIGFk
ZF93YWl0X3F1ZXVlX3ByaW9yaXR5X2V4Y2x1c2l2ZSgpIGFuZCBzd2l0Y2ggS1ZNIHRvIHVz
ZSBpdC4NCj4gDQo+IFRoYXQgaGFzIGFuIGFkZGVkIGJvbnVzIG9mIGludHJvZHVjaW5nIHRo
ZSBYZW4gY2hhbmdlIGluIGEgZGVkaWNhdGVkIHBhdGNoLCBpLmUuDQo+IGlzIHByb2JhYmx5
IGEgc2VxdWVuY2UgYW55d2F5cy4NCg0KV29ya3MgZm9yIG1lLg0KDQoNCkp1ZXJnZW4NCg0K
PiANCj4gQWx0ZXJuYXRpdmVseSwgSSBjb3VsZCByZXdyaXRlIHRoZSBIeXBlci1WIGNvZGUg
YSBsYSB0aGUgS1ZNIGNoYW5nZXMsIGJ1dCBJJ20gbm90DQo+IGZlZWxpbmcgdmVyeSBjaGFy
aXRhYmxlIGF0IHRoZSBtb21lbnQgKHRoZSBjb21wbGV0ZSBsYWNrIG9mIGRvY3VtZW50YXRp
b24gZm9yDQo+IHRoZWlyIGlvY3RsIGRvZXNuJ3QgaGVscCkuDQoNCg==
--------------am4Ts5qW4sbdeEquBHmBBqW7
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------am4Ts5qW4sbdeEquBHmBBqW7--

--------------DjGcuZBWqEwJAq0pbLlY034h--

--------------idgL64wWd0XJbGhVIRhfCOsT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgt03oFAwAAAAAACgkQsN6d1ii/Ey81
SQf/WrMJHiQA+0WvcB1rsWU19kFdz1C19eu6rnXWCIB2DM+jaYcem+Q63W3ya0OD2yb3bO+7LMBE
ojSbEBlZjAAB3nGa5GoQ/yC+BXhKMPRpWc/hOFFjV4AqbT901xzIW0WnCr2xkwpwEr9WXy+VHl4R
cfTQJwPuBRj0ELt7dOwh5P+DqplenzjFFkmTMqQvNVwT6uR1PHaLWvsUBbotVczyDwrpJHb2B9Kd
N6M2V2djjnZpK/7zLp9zEwvlAB3sLNZ91OnkmS2jYlHEi6PJFaRuNH77+vpamVMmMqUxZm7d//GN
+BZ21KN8L2ERiecqjgehAu6Lc6D0OWuIiY3rHDmJ9w==
=4n1T
-----END PGP SIGNATURE-----

--------------idgL64wWd0XJbGhVIRhfCOsT--
