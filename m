Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDAD7D3EB;
	Thu,  8 Feb 2024 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707407366; cv=none; b=bT4q3PhzKiqmiIlhSFWXDIJFzIU/xf/odGGvUtR7dqUp/QOE8wjGRX14SRc2yPXp2wHu5J6FoX454c1lLOb4rORr67di2rl578bgaSXY8WDdJG1SPQQYToWaa+dW7sb8eRrqgyt+6hE3Fr/kAX7Rg/qULMAQLmYwvLRrUKg/h7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707407366; c=relaxed/simple;
	bh=BEcEV0D5IQ431DQcUruSNLgppo2SX01S80AkJUYx/9M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hQIfF0xfBw/CXVzyvc5E7tI2vLJWAbPehN3oQSxvbGwS9bADljXCsAnxC/8laVYBXTA9yO28ZS48MrG8NGLBm01lEWx4z2JK/19n4CauRi5t0qagfuT5OCJF8I0rcyRycjhE+hlQvqhcEgevX27ApVMOD41uGV1tgmWt6iKluqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW1Y66779z67Xkv;
	Thu,  8 Feb 2024 23:46:02 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 0AA44140DEC;
	Thu,  8 Feb 2024 23:49:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 15:49:20 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Thu, 8 Feb 2024 15:49:20 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
Subject: RE: [RFC PATCH v2 0/7] iommu/arm-smmu-v3: Use pinned KVM VMID for
 stage 2
Thread-Topic: [RFC PATCH v2 0/7] iommu/arm-smmu-v3: Use pinned KVM VMID for
 stage 2
Thread-Index: AQHaWqKd0D2tjroZbEixT8fjcriLLrEAk6EAgAAD2wA=
Date: Thu, 8 Feb 2024 15:49:20 +0000
Message-ID: <416d8150d3ce4a67901a3ff7a596e4e8@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208153532.GO31743@ziepe.ca>
In-Reply-To: <20240208153532.GO31743@ziepe.ca>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gR3VudGhvcnBl
IDxqZ2dAemllcGUuY2E+DQo+IFNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSA4LCAyMDI0IDM6MzYg
UE0NCj4gVG86IFNoYW1lZXIgS29sb3RodW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVh
d2VpLmNvbT4NCj4gQ2M6IGt2bWFybUBsaXN0cy5saW51eC5kZXY7IGlvbW11QGxpc3RzLmxpbnV4
LmRldjsgbGludXgtYXJtLQ0KPiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXhhcm1A
aHVhd2VpLmNvbTsga2V2aW4udGlhbkBpbnRlbC5jb207DQo+IGFsZXgud2lsbGlhbXNvbkByZWRo
YXQuY29tOyBtYXpAa2VybmVsLm9yZzsgb2xpdmVyLnVwdG9uQGxpbnV4LmRldjsNCj4gd2lsbEBr
ZXJuZWwub3JnOyByb2Jpbi5tdXJwaHlAYXJtLmNvbTsgamVhbi1waGlsaXBwZUBsaW5hcm8ub3Jn
Ow0KPiBqb25hdGhhbi5jYW1lcm9uQGh1YXdlaS5jb20NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFU
Q0ggdjIgMC83XSBpb21tdS9hcm0tc21tdS12MzogVXNlIHBpbm5lZCBLVk0gVk1JRA0KPiBmb3Ig
c3RhZ2UgMg0KPiANCj4gT24gVGh1LCBGZWIgMDgsIDIwMjQgYXQgMDM6MTg6MzBQTSArMDAwMCwg
U2hhbWVlciBLb2xvdGh1bSB3cm90ZToNCj4gPiBIaSwNCj4gPg0KPiA+IE9uIGFuIEFSTTY0IHN5
c3RlbSB3aXRoIGEgU01NVXYzIGltcGxlbWVudGF0aW9uIHRoYXQgZnVsbHkgc3VwcG9ydHMNCj4g
PiBCcm9hZGNhc3QgVExCIE1haW50ZW5hbmNlKEJUTSkgZmVhdHVyZSBhcyBwYXJ0IG9mIHRoZSBE
aXN0cmlidXRlZA0KPiA+IFZpcnR1YWwgTWVtb3J5KERWTSkgcHJvdG9jb2wsIHRoZSBDUFUgVExC
IGludmFsaWRhdGUgaW5zdHJ1Y3Rpb25zIGFyZQ0KPiA+IHJlY2VpdmVkIGJ5IFNNTVV2My4gVGhp
cyBpcyB2ZXJ5IHVzZWZ1bCB3aGVuIHRoZSBTTU1VdjMgc2hhcmVzIHRoZQ0KPiA+IHBhZ2UgdGFi
bGVzIHdpdGggdGhlIENQVShlZzogR3Vlc3QgU1ZBIHVzZSBjYXNlKS4gRm9yIHRoaXMgdG8gd29y
aywNCj4gPiB0aGUgU01NVXYzIG11c3QgdXNlIHRoZSBzYW1lIFZNSUQgdGhhdCBpcyBhbGxvY2F0
ZWQgYnkgS1ZNIHRvIGNvbmZpZ3VyZQ0KPiA+IHRoZSBuZXN0ZWQgc3RhZ2UgMihTMikgdHJhbnNs
YXRpb25zLg0KPiANCj4gQWggc28geW91IGFyZSBnb2luZyBhbGwgdGhlIHdheSBhbmQgbG9va2lu
ZyB0byBlbmFibGUgQlRNIHdpdGhpbiBhDQo+IHZTVkEgZW52aXJvbm1lbnQgdG9vPw0KDQpZZXMs
IGVhZ2VyIHRvIGdldCB0aGUgdlNWQSBzdXBwb3J0IPCfmIogSXRzIGJlZW4gYWdlcyBhbmQgdGly
ZWQgb2YgcmViYXNpbmcgZm9yIG91cg0KcHJpdmF0ZSBnaXQgZm9yIHRoZSB2U1ZBIGNhc2VzIS4N
Cg0KQWxzbyBmb3IgSG9zdCBTVkEsIHNpbmNlIHdlIGFyZSB1c2luZyBTMSBub3csIEkgZG9u4oCZ
dCB0aGluayB0aGlzIG1hdHRlcnMgdGhhdCBtdWNoLg0KDQooSSBkbyBoYXZlIHNvbWUgcXVlc3Rp
b25zIG9uIHRoZSBpb21tdWZkIGJhc2VkIHZTVkEgLCBidXQgSSB3aWxsIGNvbWUgYmFjayB0byBp
dCwNCm9uY2UgSSBjbGVhbnVwIG15IFFlbXUgYnJhbmNoIGZvciB0aGF0LikNCg0KPiANCj4gPiBB
biBlYXJsaWVyIHByb3Bvc2FsIHNlbnQgb3V0WzFdIGEgd2hpbGUgYmFjayByZXN1bHRlZCBpbiBj
aGFuZ2luZyB0aGUNCj4gPiBBUk02NC9LVk0gVk1JRCBhbGxvY2F0b3Igc2ltaWxhciB0byB0aGUg
QVNJRCBhbGxvY2F0b3IgdG8gbWFrZSBpdA0KPiA+IGJldHRlciBzdWl0ZWQgZm9yIHRoaXMuDQo+
ID4NCj4gPiBUaGlzIFJGQyBhZGRzLA0KPiA+ICAtU3VwcG9ydCBmb3IgcGlubmVkIEtWTSBWTUlE
Lg0KPiA+ICAtU3VwcG9ydCBhc3NvY2lhdGluZyBLVk0gcG9pbnRlciBhbmQgaW9tbXVmZCBjdHgu
DQo+ID4gIC1DaGFuZ2VzIHRvIGRvbWFpbl9hbGxvY191c2VyKCkgdG8gcmVjZWl2ZSBhIGt2bSBw
b2ludGVyLg0KPiA+ICAtQ29uZmlndXJlIFNNTVVWMyBTMiB1c2luZyBLVk0gVk1JRA0KPiA+ICAt
RmluYWxseSBlbmFibGUgQlRNIG9ubHkgaWYgU01NVVYzIHN1cHBvcnRzIFMxIHRyYW5zbGF0aW9u
LiBUaGlzDQo+ID4gICBpcyB0byBtYWtlIHN1cmUgdGhhdCBQQUdJTkcgZG9tYWlucyBhbHdheXMg
dXNlIFMxIGFuZCBTMiBpcyBvbmx5DQo+ID4gICB1c2VkIGZvciBuZXN0ZWQgZG9tYWlucyB3aXRo
IGEgdmFsaWQgS1ZNLiBUaGUgaWRlYSBpcyB0byBtYWtlIHN1cmUNCj4gPiAgIHdoZW4gQlRNIGlz
IGVuYWJsZWQgaW4gR3Vlc3QsIHdlIHVzZSBLVk0gVk1JRCBmb3IgUzIuDQo+ID4NCj4gPiBOb3Qg
c3VyZSBJIG1pc3MgYW55IGV4cGxpY2l0IFRMQiBpbnZhbGlkYXRpb25zIHdpdGggYW55IHVzZSBj
YXNlDQo+ID4gdGhhdCBtYXkgY29uZmlndXJlIGEgUzIgd2l0aCBhIHByaXZhdGUgVk1JRCB0aGF0
IG1hdGNoZXMgYSBLVk0NCj4gPiBvbmUuDQo+ID4NCj4gPiBUaGlzIGlzIGJhc2VkIG9uIEphc29u
J3Mgb25nb2luZyBTTU1VdjMgcmVmYWN0b3Igc2VyaWVzWzJdLg0KPiANCj4gSSdtIGdsYWQgdG8g
c2VlIHRoaXMsIHRoYW5rIHlvdSBmb3IgZmluaXNoaW5nIHRoZSBCVE0gc3R1ZmYhDQo+IA0KPiBJ
ZiBzb21lb25lIGlzIHVzaW5nIGl0IEkgd29uZGVyIGlmIHdlIG5lZWQgdG8gZ2V0IGEgbW9yZSBz
b2xpZCBhbnN3ZXINCj4gb24gdGhlIHJhY2VzIHdpdGggaW52YWxpZGF0aW9uIGFuIEFTSUQgcmVh
c3NpZ24uLiBJIGFkZGVkIHNvbWUgbm90ZXMNCj4gaW4gY29tbWVudHMgaW4gcGFydCAyIGFmdGVy
IEkgYXVkaXRlZCBhbGwgb2YgaXQuDQoNCkkgc2F3IHRoYXQgb25lLiBUaGUgbWFpbiBwb2ludCBo
ZXJlIGlzLCBpZiB3ZSBndWFyYW50ZWUgdGhhdCBCVE0gaXMgb25seSB1c2VkDQpmb3IgYSBuZXN0
ZWQgUzIgY2FzZSBhbmQgdGhlcmUgd2lsbCBiZSBhIHBpbm5lZCBLVk0gVk1JRCBmb3IgdGhhdCwg
SSBhbSANCm5vdCBzdXJlIHdlIG5lZWQgdG8gd29ycnkgYWJvdXQgYW55IFMyIHJlbGF0ZWQgY29u
ZmxpY3RzIGluIFRMQklzLg0KDQpUaGFua3MsDQpTaGFtZWVyDQo=
