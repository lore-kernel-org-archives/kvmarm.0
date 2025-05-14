Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19A52741BD
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 13:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230494; cv=none; b=ssIcaU9VuCbRRmHtxX7Oc1hNt+6cr0dcYv7uXEH5mO46PskLVkH7PT670ViEEMoRXEAi/bvJF6TLj0zj85qtr2BTSsa40Ne4Z6irLd9PxQd2sfEUJl9qV9VdSQLZR5WuFvbPC4/pseG/oQFoLRql+p/pclXCk7DaN1bNIALOcAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230494; c=relaxed/simple;
	bh=HCkJbFlmlMvu/m2SsPDolJ7VX8J/gzvzd6fam2//rM0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oF+7qjeyWhUMLzjUrmkN+uYvxRqvJVuML1EsM/nkahxkBxOKC7oQlDpn7xizk45PJ55Zd7WV2tJk6AMDvCdh0H5BOvywnVUFUoZEkbXYToHKVkTGY3hYUKem85eaww12nEWXLzxGRCE/6MlZWPtbz4rt2yOHWa8iH0dbH4kXrNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZyF3333rdz6H7jl;
	Wed, 14 May 2025 21:45:19 +0800 (CST)
Received: from frapeml100007.china.huawei.com (unknown [7.182.85.133])
	by mail.maildlp.com (Postfix) with ESMTPS id E8EF01400DC;
	Wed, 14 May 2025 21:48:08 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100007.china.huawei.com (7.182.85.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 May 2025 15:47:53 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Wed, 14 May 2025 15:47:53 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>, Cornelia Huck
	<cohuck@redhat.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"alex.bennee@linaro.org" <alex.bennee@linaro.org>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"sebott@redhat.com" <sebott@redhat.com>, "armbru@redhat.com"
	<armbru@redhat.com>, "berrange@redhat.com" <berrange@redhat.com>,
	"abologna@redhat.com" <abologna@redhat.com>, "jdenemar@redhat.com"
	<jdenemar@redhat.com>
CC: "agraf@csgraf.de" <agraf@csgraf.de>, "shahuang@redhat.com"
	<shahuang@redhat.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"philmd@linaro.org" <philmd@linaro.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: RE: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
 host model
Thread-Topic: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
 host model
Thread-Index: AQHbrVvRKlWe4qTsaku+jGkyYZoxlrPQu3UAgAGVOyA=
Date: Wed, 14 May 2025 13:47:52 +0000
Message-ID: <4fcfb4624f90491ebb238de76f04e4e5@huawei.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
 <dadc4acd-97c8-4647-9467-89cd1966a6f2@redhat.com>
In-Reply-To: <dadc4acd-97c8-4647-9467-89cd1966a6f2@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBBdWdlciA8ZXJp
Yy5hdWdlckByZWRoYXQuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBNYXkgMTMsIDIwMjUgNDozMCBQ
TQ0KPiBUbzogQ29ybmVsaWEgSHVjayA8Y29odWNrQHJlZGhhdC5jb20+OyBlcmljLmF1Z2VyLnBy
b0BnbWFpbC5jb207IHFlbXUtDQo+IGRldmVsQG5vbmdudS5vcmc7IHFlbXUtYXJtQG5vbmdudS5v
cmc7IGt2bWFybUBsaXN0cy5saW51eC5kZXY7DQo+IHBldGVyLm1heWRlbGxAbGluYXJvLm9yZzsg
cmljaGFyZC5oZW5kZXJzb25AbGluYXJvLm9yZzsNCj4gYWxleC5iZW5uZWVAbGluYXJvLm9yZzsg
bWF6QGtlcm5lbC5vcmc7IG9saXZlci51cHRvbkBsaW51eC5kZXY7DQo+IHNlYm90dEByZWRoYXQu
Y29tOyBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpDQo+IDxzaGFtZWVyYWxpLmtvbG90aHVtLnRo
b2RpQGh1YXdlaS5jb20+OyBhcm1icnVAcmVkaGF0LmNvbTsNCj4gYmVycmFuZ2VAcmVkaGF0LmNv
bTsgYWJvbG9nbmFAcmVkaGF0LmNvbTsgamRlbmVtYXJAcmVkaGF0LmNvbQ0KPiBDYzogYWdyYWZA
Y3NncmFmLmRlOyBzaGFodWFuZ0ByZWRoYXQuY29tOyBtYXJrLnJ1dGxhbmRAYXJtLmNvbTsNCj4g
cGhpbG1kQGxpbmFyby5vcmc7IHBib256aW5pQHJlZGhhdC5jb20NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2MyAwMC8xMF0ga3ZtL2FybTogSW50cm9kdWNlIGEgY3VzdG9taXphYmxlIGFhcmNoNjQN
Cj4gS1ZNIGhvc3QgbW9kZWwNCg0KWy4uLl0NCg0KPiA+IFdlIHN0aWxsIGhhdmUgdG8gZGVhbCB3
aXRoIE1JRFIvUkVWSURSL0FJRFIgZGlmZmVyZW5jZXMgYnkgZXhwbG9pdGluZw0KPiA+DQo+IGh0
dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xp
bnV4LmdpdC9jb21taXQ/aQ0KPiBkPWQzMDBiMDE2OGVhOGZkNTAyMmExNDEzYmQzN2FiNjNmNGU1
YTdkNGQNCj4gPiAoaW4gYSBkaWZmZXJlbnQgc2VyaWVzLikNCj4gU2hhbWVlciwgZG8geW91IHBs
YW4gdG8gY29udHJpYnV0ZSB0aGUgcWVtdSBpbnRlZ3JhdGlvbiBvZiB0aGlzIGZlYXR1cmUNCj4g
eW91IGRldmVsb3BwZWQgb24ga2VybmVsIHNpZGU7IG9yIGRvIHlvdSBhbGxvdyB1cyB0byBpbnRl
Z3JhdGUgaXQgaW4NCj4gdGhpcyBzZXJpZXM/DQoNClllcywgaXQncyBvbiBteSBUb0RvIGxpc3Qu
IEknbGwgZmlyc3QgZ28gdGhyb3VnaCB0aGlzIHNlcmllcyBhbmQgdGhlbiB3b3JrIG9uDQphZGRp
bmcgdGhlIGFib3ZlIHN1cHBvcnQgb24gdG9wIG9mIGl0Lg0KDQpUaGFua3MsDQpTaGFtZWVyDQoN
Cg==
