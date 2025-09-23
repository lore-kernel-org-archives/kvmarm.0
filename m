Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B171E1DEC
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758616757; cv=none; b=U1yP7Y6gBgr1CIe0IPviOf4EvxQQFlJGbU4jmZOxCXeJRRe0mSrvYhsbKPrqgx5x+6qZ8YqcsREtuW0bwGocnrdRlvgU0DJ387ShDdJDc4oPYg7aoY+CjCHhixifiphLcyiZKNwU1vkZ3nOnr3OZdWQr8sUFbYvi2rpsAbW8lwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758616757; c=relaxed/simple;
	bh=5KXYO8/Bm9DXMCe3t4S4ugeHDvQmxrq0oPCZUEzD2eI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nBQE1ok0j/13JPdV6/4+YtgJNX0KtxNbjk3G7XYAcVZk+YvpCmNYWnnfQq1Y2ai02jFp+1rtPEFa5mEDO/QIpaJzKai4YlH0tq2OKuiry0Gj6o+T5U4r3CcHUBeNqhqDZERx//Hp7jZf+3zn0lv8+fhWjmKq/k1Ja6IeaenjNA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=fRD6Ajv6; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="fRD6Ajv6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758616755; x=1790152755;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5KXYO8/Bm9DXMCe3t4S4ugeHDvQmxrq0oPCZUEzD2eI=;
  b=fRD6Ajv6/h5HpB2dEV+OD7Ed9CCdOr50++8mCfKMWp8E+ANV6iB2E4YM
   ePTK8dF7dyaoVig2QG5ocKYK2n6tDVJCIaXe7pKXvBUJIhizp6fg8s/uL
   K8AEfjFVFu5Y405aSab3FS3SbOVZIMqxY/ygxgDGnUnI5KVCOzPkYr37h
   1hZjCi+lD82HG9mCnIL2NaEWrO6LQbadDCNWADeiE8fZTzO2LBqyG1+2U
   bQWSd5Kqr9FubIpNp3ggEM5/h8KS65yy4MdpJt9mpfopZKKdXNJRsWUzj
   iITyfVKoAy1hp7q1zq8uUf8VIgeRq/EjA3y110EZtk+x+2sXXEL7WBPOa
   w==;
X-CSE-ConnectionGUID: Tb/wMrrNQ5+sRYUoh6j56A==
X-CSE-MsgGUID: qx5d8uHqSAK98pM/Q/bnUA==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="3552561"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 08:39:13 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:3772]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.110:2525] with esmtp (Farcaster)
 id 4f49d128-0360-4923-9b19-64f0ae0d438e; Tue, 23 Sep 2025 08:39:13 +0000 (UTC)
X-Farcaster-Flow-ID: 4f49d128-0360-4923-9b19-64f0ae0d438e
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 23 Sep 2025 08:39:12 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 23 Sep 2025
 08:39:09 +0000
Message-ID: <97759f51-385b-4ce4-8766-d00ed5af580b@amazon.com>
Date: Tue, 23 Sep 2025 10:39:07 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Implement KVM_TRANSLATE ioctl for arm64
To: Priscilla Lam <prl@amazon.com>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <christoffer.dall@arm.com>, <dwmw@amazon.co.uk>, <gurugubs@amazon.com>,
	<jgrall@amazon.co.uk>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>
References: <86frcd1tp4.wl-maz@kernel.org>
 <20250923082955.66602-1-prl@amazon.com>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20250923082955.66602-1-prl@amazon.com>
X-ClientProxiedBy: EX19D037UWB003.ant.amazon.com (10.13.138.115) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

SGkgUHJpc2NpbGxhLAoKT24gMjMuMDkuMjUgMTA6MjksIFByaXNjaWxsYSBMYW0gd3JvdGU6Cj4g
SGkgT2xpdmVyIGFuZCBNYXJjLAo+Cj4gVGhhbmtzIGZvciB0aGUgZGV0YWlsZWQgZmVlZGJhY2su
Cj4KPj4gQnV0IGF0IHRoZSBlbmQgb2YgdGhlIGRheSwgd2hhdCBkbyB5b3UgbmVlZCBLVk1fVFJB
TlNMQVRFIGZvcj8gVGhpcwo+PiBpbnRlcmZhY2UgaXMgYW4gYWJzb2x1dGUgdHVyZCB0aGF0IGlz
IHVuYWJsZSB0byByZXByZXNlbnQgdGhlIGJhcmUKPj4gbWluaW11bSBvZiB0aGUgYXJjaGl0ZWN0
dXJlICh3cml0YWJsZSBieSB3aG9tPyBwaHlzaWNhbCBhZGRyZXNzIGluCj4+IHdoaWNoIHRyYW5z
bGF0aW9uIHJlZ2ltZT8gd2hhdCBhYm91dCBTMiB0cmFuc2xhdGlvbnM/KSwgYW5kIGlzIGJldHRl
cgo+PiBsZWZ0IGluIHRoZSAidXR0ZXIgYnJhaW4gZmFydCIgY2F0ZWdvcnkuCj4gUmVnYXJkaW5n
IG1vdGl2YXRpb24sIHRoaXMgcGF0Y2ggaXMgaW50ZW5kZWQgdG8gZ2l2ZSBhIHVzZXJzcGFjZSB2
bW0KPiB0aGUgYWJpbGl0eSB0byBoYW5kbGUgbm9uLUlTViBndWVzdCBmYXVsdHMuIFRoZSBBcm0g
QXJtIChEREkgMDQ4N0wuYiwKPiBzZWN0aW9uIEIzLjEzLjYpIG5vdGVzIHRoYXQgZm9yIGxvYWQv
c3RvcmUgcGFpciBmYXVsdHMsIHRoZSBzeW5kcm9tZQo+IG1heSBub3QgcHJvdmlkZSB0aGUgc3Bl
Y2lmaWNzIG9mIHRoZSBhY2Nlc3MgdGhhdCBmYXVsdGVkLiBJbiB0aG9zZQo+IGNhc2VzLCB0aGUg
dm1tIG11c3QgbWFudWFsbHkgZGVjb2RlIHRoZSBpbnN0cnVjdGlvbiB0byBlbXVsYXRlIGl0LiBU
aGUKPiBpbnRyb2R1Y3Rpb24gb2YgS1ZNX0NBUF9BUk1fTklTVl9UT19VU0VSCj4gKGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2t2bS8yMDE5MTEyMDE2NDIzNi4yOTM1OS0yLW1hekBrZXJuZWwub3Jn
LykKPiBzZWVtcyB0byBoYXZlIGFudGljaXBhdGVkIHRoYXQgZmxvdyBieSBhbGxvd2luZyBleGl0
cyB0byB1c2Vyc3BhY2Ugb24KPiB0cmFwcGVkIE5JU1YgaW5zdHJ1Y3Rpb25zLiBXaGF0IGlzIHN0
aWxsIG1pc3NpbmcgaXMgYSByZWxpYWJsZSB3YXkgZm9yCj4gdXNlcnNwYWNlIHRvIHF1ZXJ5IFZB
LT5JUEEgdHJhbnNsYXRpb25zIGluIG9yZGVyIHRvIGNvbXBsZXRlIGVtdWxhdGlvbi4KCgpBbGwg
bW9kZXJuIE9TcyBjb25zdHJhaW4gdGhlbXNlbHZlcyB0byBvbmx5IElTViBlbmFibGVkIE1NSU8g
Cmluc3RydWN0aW9ucy4gTklTViBpcyByZWFsbHkgb25seSB1c2VmdWwgdG8gcnVuIG5vbiBoeXBl
cnZpc29yIAplbmxpZ2h0ZW5lZCBndWVzdHMuIERpZCB5b3UgZW5jb3VudGVyIGEgcmVhbCB3b3Js
ZCBPUyB0aGF0IHdhcyBjYXVzaW5nIApOSVNWIGZhdWx0cz8gQW5kIGlmIHNvLCB3aGF0IHdhcyBj
YXVzaW5nIHRoZXNlPyBJdCdzIG1vc3QgbGlrZWx5IGEgCmRyaXZlciBvciBPUyBidWcuCgpBbGV4
CgoKCgpBbWF6b24gV2ViIFNlcnZpY2VzIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgK
VGFtYXJhLURhbnotU3RyLiAxMwoxMDI0MyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJp
c3RpYW4gU2NobGFlZ2VyCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJn
IHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAzNjUgNTM4IDU5Nwo=

