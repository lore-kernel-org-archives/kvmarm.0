Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C59264A84
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745426185; cv=none; b=sv+J5a8r1Xwtw30LXsAtMk6r4osdIxdX7LQUzjK3aUShmuGeWua8jtRARzQXt034Zk1TLTBX48ZO2W6Q37tIbacuXv1Y9M2sJwzXXmA/vOgbzBMDpI/wImd4xSZ/jsq2yzjVeB9WcrsudBiFxhf13roXMi7OPONPS9k/RPOGXLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745426185; c=relaxed/simple;
	bh=gOYAltqxMUlpRjp4ssKS1jd4eneI5dfSiyhFRgDCStM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhOGBr4N1tuIX4n4pp5entaNZMoebhim/Yob7SP/C1oc0VtPEiSCQTVI5zCuwPPs5yWUnnm4SgbS249j0EjPO390F5m41BzS/76I1Af6xSouGeSZcCzNWVrQk87lMe/RLqRNge9onEqr5jMz5IrePCU3FhDkYPjhQCvuKplXQdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=kAQVfvir; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="kAQVfvir"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1745426154; x=1746030954; i=markus.elfring@web.de;
	bh=gOYAltqxMUlpRjp4ssKS1jd4eneI5dfSiyhFRgDCStM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kAQVfvirK/xjqkt14z8Flu0y+l+s16U3BxHcopal+hQ5iONTF8Ww4J9je/OjduPr
	 fa6rUGmv/VueRAR752FpMKCPNBsIRZJNsyYoxy/llXAmYVNZoq5dxbNyX5K6owmfy
	 Zl4zevGmaiyZ7rw4cFwHtUQLz+vbujig3f0gLTF4MmTA/mTOOqnk0d8LJ1Vj0/d51
	 TKEu9HY1j6FfKn9AM4/on4mjiFlnIw9NM2ruGxhJnW1FpxWYar2b3gCb1fq8w5VHr
	 9kjtweHlfDKM6Dn+qzqfAZKFZQw+Y02wgGxaG8lduRAQgeTI531o2btbwDIkNxxQ4
	 4cun2PHgtICQVuQ+YQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.6]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M6pYY-1uBSpY1UJK-00GTPt; Wed, 23
 Apr 2025 18:35:54 +0200
Message-ID: <43712874-6f1d-435c-98b2-30ac44d25309@web.de>
Date: Wed, 23 Apr 2025 18:35:50 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [PATCH v3 2/6] coccinelle: misc: Add field_modify script
To: Jie Luo <quic_luoj@quicinc.com>, cocci@inria.fr,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Julia Lawall <Julia.Lawall@inria.fr>, Marc Zyngier <maz@kernel.org>,
 Nicolas Palix <nicolas.palix@imag.fr>, Oliver Upton
 <oliver.upton@linux.dev>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Suzuki Poulouse <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Yury Norov <yury.norov@gmail.com>, Zenghui Yu <yuzenghui@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
 "Kiran Kumar C.S.K" <quic_kkumarcs@quicinc.com>,
 Lei Wei <quic_leiwei@quicinc.com>, Pavithra R <quic_pavir@quicinc.com>,
 Suruchi Agarwal <quic_suruchia@quicinc.com>, quic_linchen@quicinc.com
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-2-6f7992aafcb7@quicinc.com>
 <a1be0efc-a4c9-461d-a01a-8fb830b2c68d@web.de>
 <0ee48e2f-58db-49b0-b651-dcc0e517465e@quicinc.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <0ee48e2f-58db-49b0-b651-dcc0e517465e@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:lGmGLFuUIXdZtK0t76Y7z/TLyWEnsgb+nkpeau+LW99SAidKHeo
 9YY3J0b3cjOcIXGym7BNSTWEF4yiV5NHbHyVqJL0pHTKMJH8jJ5l9pjh+J/3gbQhXKDccEd
 3zocvbiemgMFiZGsMJEWv2DhzSY6g5MmG1/LS4KXQWwHQAyG8+2uECgBA8FxretNTCQgZL/
 4iRXjqXpDP9QI4K6qFhVA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3Sp7cn4vrhw=;tPPbn82Wxe3rJ06l7ddBGtnXHNM
 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
 bB7p+0c2xRXllM3zJi1qqnfV6pB+F/us1mSxvUbcyq+1xYBJJ4x/SKrD7CXuTSce35BAq+GyD
 rrcGRkqHU1rQnNj8fXqUggpxw4KL+V7zz10azSfcvH4i+hM51HdvFXieEfbG0EMuUpECyE6CR
 l08CcYyXPQid+O465GbtCnkVUJEQuGCLq8if9135bnt3GkgniV0slN0h54XnJFlvDzThBJlU8
 Z8M1RHX8+jO9LOha0HzQKIxdTyI+xqca3b7IxZPEOXZuMrPa5mIq+mtGc6hHx/jZSnq6DLj0x
 6N/PXPyd2gaB14vEtGIjvvOwo+w4vPFSd/9K6qkgATYB68MpvyPZkGdsTxkgmiOvPm9PL3tg0
 lxApZ6oa7fpT8JeqHmLh8Dcfof4lKSNFZWEsicgzcBaKRvwizCt3iIacX3kMF0T3Q+QaFlWVW
 IoSTSDPfDvnzrupdo0O6q3MG8ErXpP32O7Q+bz1+LiBpBY1hcvW96oGq/4I6xU8j6Cgvk4EIu
 0U7x4SefYw054vN2uF/fDNCg8vPl5p2URHDjQUzsppQXw7LA9xyRjS025Q9r/sBfeK0DAEQmo
 nV9m69Bg9KiwtHi4+S4gfxi2RvWJc2Xjjj5llXj/u6pYDrIHd+IU5o0i0eIvHtVzA==

4oCmDQo+PiAtcmVnICY9IH5tYXNrOw0KPj4gLXJlZyB8PSBGSUVMRF9QUkVQDQo+PiArwqDCoMKg
wqDCoMKgIEZJRUxEX01PRElGWQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIChtYXNrLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJnJlZywN
Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZhbA0KPj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICk7DQrigKYNCj4gV2l0aCB0aGlzIGNvZGUg
dmFyaWFudCwgdGhlcmUgaXMgbm8gc3BhY2UgcHJpb3IgdG8gJnJlZywgaGVyZSBpcyB0aGUNCj4g
ZXhhbXBsZSBjb2RlIGNoYW5nZXMgZ2VuZXJhdGVkIGJ5IHRoZSBTbVBMIGNvZGUgYXMgYmVsb3cs
IGlzIHRoaXMgZXhwZWN0ZWQ/DQrigKYNCj4gKysrIGIvZHJpdmVycy9waHkvc3RhcmZpdmUvcGh5
LWpoNzExMC1kcGh5LXR4LmMNCj4gQEAgLTI0NCw4ICsyNDQsNyBAQCBzdGF0aWMgaW50IHN0Zl9k
cGh5X2NvbmZpZ3VyZShzdHJ1Y3QgcGh5DQo+IMKgwqDCoMKgwqDCoMKgIGkgPSBzdGZfZHBoeV9n
ZXRfY29uZmlnX2luZGV4KGJpdHJhdGUpOw0KPiANCj4gwqDCoMKgwqDCoMKgwqAgdG1wID0gcmVh
ZGwoZHBoeS0+dG9wc3lzICsgU1RGX0RQSFlfQVBCSUZTQUlGX1NZU0NGRygxMDApKTsNCj4gLcKg
wqDCoMKgwqDCoCB0bXAgJj0gflNURl9EUEhZX1JFRkNMS19JTl9TRUw7DQo+IC3CoMKgwqDCoMKg
wqAgdG1wIHw9IEZJRUxEX1BSRVAoU1RGX0RQSFlfUkVGQ0xLX0lOX1NFTCwgU1RGX0RQSFlfUkVG
Q0xLXzEyTSk7DQo+ICvCoMKgwqDCoMKgwqAgRklFTERfTU9ESUZZKFNURl9EUEhZX1JFRkNMS19J
Tl9TRUwsJnRtcCwgU1RGX0RQSFlfUkVGQ0xLXzEyTSk7DQo+IMKgwqDCoMKgwqDCoMKgIHdyaXRl
bCh0bXAsIGRwaHktPnRvcHN5cyArIFNURl9EUEhZX0FQQklGU0FJRl9TWVNDRkcoMTAwKSk7DQoN
ClRoZSBDb2NjaW5lbGxlIHNvZnR3YXJlIGlzIHN0aWxsIGV2b2x2aW5nIHNvbWVob3cuDQpUaHVz
IHlvdXIgdGVzdCByZXN1bHQgY2FuIHRyaWdnZXIgZnVydGhlciBkZXZlbG9wbWVudCBjb25zaWRl
cmF0aW9ucy4NCkkgaG9wZSB0aGF0IGNsYXJpZmljYXRpb25zIGFuZCBjb3JyZXNwb25kaW5nIGlt
cHJvdmVtZW50cyBjYW4gYmUgYWNoaWV2ZWQNCmFsc28gYWNjb3JkaW5nIHRvIHN1Y2ggc291cmNl
IGNvZGUgbGF5b3V0IGNvbmNlcm5zLg0KDQpSZWdhcmRzLA0KTWFya3VzDQo=
