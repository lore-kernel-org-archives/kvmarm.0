Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969A9846B
	for <kvmarm@lists.linux.dev>; Thu, 29 Jun 2023 20:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1688071985; x=1719607985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6RZMntIQtXeqgJf/vhdyXoTEzewBJMKRj6T1mYkEF5E=;
  b=ve26/sZHb2czdllsCFqNCK7iTXsT9pOzJjzEGp8QjmLUIeoJTFCjIZ1T
   E+f11fOeGUzz45/HdSmR3QLypQCoJdiRf/VxkEsmwSwbepm2yEK3vG1Lv
   ACvo53aG6fe2oy1oDNUCNAz+a++tDCxBiaI1Rd/FqVHjsIkZFCXuaXcRR
   E=;
X-IronPort-AV: E=Sophos;i="6.01,169,1684800000"; 
   d="scan'208";a="1140354212"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 20:53:04 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id 9E08380694;
	Thu, 29 Jun 2023 20:53:01 +0000 (UTC)
Received: from EX19D030UWB004.ant.amazon.com (10.13.139.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 29 Jun 2023 20:52:55 +0000
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX19D030UWB004.ant.amazon.com (10.13.139.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Thu, 29 Jun 2023 20:52:55 +0000
Received: from EX19D030UWB002.ant.amazon.com ([fe80::8cbd:fcae:56ad:4dfa]) by
 EX19D030UWB002.ant.amazon.com ([fe80::8cbd:fcae:56ad:4dfa%6]) with mapi id
 15.02.1118.030; Thu, 29 Jun 2023 20:52:55 +0000
From: "Jitindar Singh, Suraj" <surajjs@amazon.com>
To: "oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"jingzhangos@google.com" <jingzhangos@google.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"reijiw@google.com" <reijiw@google.com>
Subject: Re: [PATCH] KVM: arm64: Reject attempts to set invalid debug arch
 version
Thread-Topic: [PATCH] KVM: arm64: Reject attempts to set invalid debug arch
 version
Thread-Index: AQHZqsutc1qowGpCIE6MNH7+YjLWgQ==
Date: Thu, 29 Jun 2023 20:52:54 +0000
Message-ID: <0f1c2632dc59c12b62d851a3646e1a7aaff81fca.camel@amazon.com>
References: <20230623205232.2837077-1-oliver.upton@linux.dev>
	 <363ed7f4e5e7b7f19af764f1ee5a5e367f4e6339.camel@amazon.com>
	 <ZJzzP7h0+yyx4odI@thinky-boi>
In-Reply-To: <ZJzzP7h0+yyx4odI@thinky-boi>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.111.174.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6AB63DA11E8454781F061C7820315DA@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

SGkgT2xpdmVyLA0KDQpPbiBXZWQsIDIwMjMtMDYtMjggYXQgMTk6NTggLTA3MDAsIE9saXZlciBV
cHRvbiB3cm90ZToNCj4gSGkgU3VyYWoNCj4gDQo+IE9uIFRodSwgSnVuIDI5LCAyMDIzIGF0IDAx
OjEyOjMxQU0gKzAwMDAsIEppdGluZGFyIFNpbmdoLCBTdXJhag0KPiB3cm90ZToNCj4gPiA+IEBA
IC0xNTAxLDYgKzE1MDIsMTMgQEAgc3RhdGljIGludCBzZXRfaWRfYWE2NGRmcjBfZWwxKHN0cnVj
dA0KPiA+ID4ga3ZtX3ZjcHUNCj4gPiA+ICp2Y3B1LA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGlm
IChwbXV2ZXIgPT0gSURfQUE2NERGUjBfRUwxX1BNVVZlcl9JTVBfREVGKQ0KPiA+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB2YWwgJj0gfklEX0FBNjRERlIwX0VMMV9QTVVWZXJf
TUFTSzsNCj4gPiA+IMKgDQo+ID4gPiArwqDCoMKgwqDCoMKgwqAvKg0KPiA+ID4gK8KgwqDCoMKg
wqDCoMKgICogSURfQUE2NERGUjBfRUwxLkRlYnVnVmVyIGlzIG9uZSBvZiB0aG9zZSBhd2t3YXJk
DQo+ID4gPiBmaWVsZHMNCj4gPiA+IHdpdGggYQ0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgICogbm9u
emVybyBtaW5pbXVtIHNhZmUgdmFsdWUuDQo+ID4gPiArwqDCoMKgwqDCoMKgwqAgKi8NCj4gPiA+
ICvCoMKgwqDCoMKgwqDCoGlmIChkZWJ1Z3ZlciA8IElEX0FBNjRERlIwX0VMMV9EZWJ1Z1Zlcl9J
TVApDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU5WQUw7
DQo+ID4gPiArDQo+ID4gDQo+ID4gQUE2NERGUjBfRUwxX0RlYnVnVmVyIGhhcyBmZWF0dXJlIHR5
cGUgRlRSX0VYQUNUIHNvIHRoZSBndWVzdCB2YWx1ZQ0KPiA+IG11c3QgZXhhY3RseSBtYXRjaCB0
aGUgaG9zdCB2YWx1ZS4gU28gSSBkb24ndCBiZWxpZXZlIHRoaXMgY2hlY2sgaXMNCj4gPiByZXF1
aXJlZC4NCj4gDQo+IEkgZ290IHdhYWFheSBhaGVhZCBvZiBteXNlbGYgYW5kIHNlbnQgdGhpcyBv
dXQgb2YgY29udGV4dC4gQXMgSSBoYWQNCj4gc2FpZA0KPiB0byBNYXJjLCB0aGUgZml4ZXMgaXMg
dXR0ZXIgY3JhcCBvbiB0aGlzIHBhdGNoIHNpbmNlIHdlIGRvbid0IHBlcm1pdA0KPiBjaGFuZ2Vz
IHRvIHRoaXMgZmllbGQuDQoNCkZvciBub3cgdGhpcyBpcyBjb3JyZWN0LiBIb3dldmVyIHdpdGgg
dGhlIHNlcmllcyBmcm9tIEppbmcgZW5hYmxpbmcNCndyaXRlcyB0byBhbGwgZmllbGRzIG9mIHRo
ZXNlIHJlZ2lzdGVycyBbMV0gaXQgd2lsbCBiZSBuZWNlc3NhcnkgaW4NCmZ1dHVyZSB0byBoYXZl
IHN1Y2ggY2hlY2tzIHNvIHBvdGVudGlhbGx5IHdvcnRoIGZvbGRpbmcgdGhpcyBwYXRjaCBpbnRv
DQp0aGF0IHNlcmllcy4NCg0KWzFdDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1hcm0t
a2VybmVsLzIwMjMwNjA3MTk0NTU0Ljg3MzU5LTEtamluZ3poYW5nb3NAZ29vZ2xlLmNvbS8NCg0K
PiANCj4gV2hhdCBJIHdhcyBhY3R1YWxseSBsb29raW5nIGF0IGlzIHJhaXNpbmcgdGhlIGxpbWl0
IGZvciB0aGUgZGVidWcNCj4gYXJjaGl0ZWN0dXJlIG9uIEtWTSBhbmQgcGVybWl0dGluZyBzYWZl
IHZhbHVlcyBsZXNzIHRoYW4gdGhhdCBvZiB0aGUNCj4gaG9zdC4gU28gaW4gaXNvbGF0aW9uIHRo
aXMgaXMgcG9pbnRsZXNzLCBidXQgd2lsbCBiZSB1c2VmdWwgZm9yIGENCj4gZnVuY3Rpb25hbCBj
aGFuZ2UuDQoNClVuZGVyc3Rvb2QuIEkgZ3Vlc3MgZG9pbmcgc29tZXRoaW5nIGxpa2Ugc2V0dGlu
ZyB0aGUgdHlwZSB0bw0KRlRSX0xPV0VSX1NBRkUgaW4ga3ZtX2FybTY0X2Z0cl9zYWZlX3ZhbHVl
KCkuIFRoZW4gdGhpcyBjaGVjayB3aWxsIGJlDQpyZXF1aXJlZCA6KQ0KDQo+IA0KPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoHJldHVybiBzZXRfaWRfcmVnKHZjcHUsIHJkLCB2YWwpOw0KPiA+ID4gwqB9
DQo+ID4gPiDCoA0KPiA+ID4gQEAgLTE1MjIsNiArMTUzMCw3IEBAIHN0YXRpYyBpbnQgc2V0X2lk
X2RmcjBfZWwxKHN0cnVjdCBrdm1fdmNwdQ0KPiA+ID4gKnZjcHUsDQo+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHU2NCB2YWwpDQo+ID4g
PiDCoHsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqB1OCBwZXJmbW9uID0gU1lTX0ZJRUxEX0dFVChJ
RF9ERlIwX0VMMSwgUGVyZk1vbiwgdmFsKTsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoHU4IGNvcGRi
ZyA9IFNZU19GSUVMRF9HRVQoSURfREZSMF9FTDEsIENvcERiZywgdmFsKTsNCj4gPiA+IMKgDQo+
ID4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHBlcmZtb24gPT0gSURfREZSMF9FTDFfUGVyZk1vbl9J
TVBERUYpIHsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdmFsICY9IH5J
RF9ERlIwX0VMMV9QZXJmTW9uX01BU0s7DQo+ID4gPiBAQCAtMTUzNyw2ICsxNTQ2LDkgQEAgc3Rh
dGljIGludCBzZXRfaWRfZGZyMF9lbDEoc3RydWN0IGt2bV92Y3B1DQo+ID4gPiAqdmNwdSwNCj4g
PiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAocGVyZm1vbiAhPSAwICYmIHBlcmZtb24gPCBJRF9ERlIw
X0VMMV9QZXJmTW9uX1BNVXYzKQ0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gLUVJTlZBTDsNCj4gPiA+IMKgDQo+ID4gPiArwqDCoMKgwqDCoMKgwqBpZiAoY29w
ZGJnIDwgSURfREZSMF9FTDFfQ29wRGJnX0FybXY4KQ0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJldHVybiAtRUlOVkFMOw0KPiA+ID4gKw0KPiA+IA0KPiA+IFRoaXMgb25l
IGhhcyB0eXBlIEZUUl9MT1dFUl9TQUZFIGFuZCBzbyB0aGUgY2hlY2sgaXMgcmVxdWlyZWQuDQo+
IA0KPiBTYW1lIGdvZXMgZm9yIHRoaXMgZmllbGQgLS0gYW55IGNoYW5nZXMgYXJlIGZvcmJpZGRl
biBzaW5jZSBpdCBpcyBub3QNCj4gaW4NCj4gdGhlIHdyaXRhYmxlIG1hc2suDQoNCkNvbW1lbnQg
YXMgYWJvdmUuIFRoaXMgaXMgcmVxdWlyZWQgd2hlbiBlbmFibGluZyB3cml0ZXMgdG8gYWxsIGZp
ZWxkcw0KaW4gdGhlIHJlZ2lzdGVyLg0KDQpUaGFua3MsDQpTdXJhag0KDQo+IA0KPiBUaGFua3Mg
Zm9yIGhhdmluZyBhIGxvb2ssIGFwb2xvZ2llcyBmb3IgdGhlIGNvbmZ1c2lvbi4NCj4gDQo+IC0t
DQo+IFRoYW5rcywNCj4gT2xpdmVyDQoNCg==
