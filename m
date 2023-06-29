Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612CE10ED
	for <kvmarm@lists.linux.dev>; Thu, 29 Jun 2023 01:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1688001153; x=1719537153;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D86m0LmFIDwjWtC1s1td5OpXFMS3HKfyrt9Jc4zOB0Q=;
  b=kp7XY6chJ7049tfVSK5YLUs8QrIiezTfS6AYD0u98Kc75nY340cAPBDe
   dKlV13gRowjVMJVnpljEEAVORzg+V7oPI+9T434mQW4dwt9NLN3FFq6ah
   CN6ZZFj8mwEWr9T2UvDyrZ3cQjVdZFFK6F8kThiwO5djvfljdQTgPNMsZ
   Y=;
X-IronPort-AV: E=Sophos;i="6.01,167,1684800000"; 
   d="scan'208";a="348435144"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 01:12:32 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id 2A39140DBD;
	Thu, 29 Jun 2023 01:12:32 +0000 (UTC)
Received: from EX19D030UWB004.ant.amazon.com (10.13.139.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 29 Jun 2023 01:12:31 +0000
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX19D030UWB004.ant.amazon.com (10.13.139.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Thu, 29 Jun 2023 01:12:31 +0000
Received: from EX19D030UWB002.ant.amazon.com ([fe80::8cbd:fcae:56ad:4dfa]) by
 EX19D030UWB002.ant.amazon.com ([fe80::8cbd:fcae:56ad:4dfa%6]) with mapi id
 15.02.1118.030; Thu, 29 Jun 2023 01:12:31 +0000
From: "Jitindar Singh, Suraj" <surajjs@amazon.com>
To: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "jingzhangos@google.com"
	<jingzhangos@google.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "reijiw@google.com" <reijiw@google.com>
Subject: Re: [PATCH] KVM: arm64: Reject attempts to set invalid debug arch
 version
Thread-Topic: [PATCH] KVM: arm64: Reject attempts to set invalid debug arch
 version
Thread-Index: AQHZqibHo6VK4BfX50OpbZyEvrkaMQ==
Date: Thu, 29 Jun 2023 01:12:31 +0000
Message-ID: <363ed7f4e5e7b7f19af764f1ee5a5e367f4e6339.camel@amazon.com>
References: <20230623205232.2837077-1-oliver.upton@linux.dev>
In-Reply-To: <20230623205232.2837077-1-oliver.upton@linux.dev>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.111.86.59]
Content-Type: text/plain; charset="utf-8"
Content-ID: <41D9C86623FBC1429B20FCE8DC9C00F3@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

SGkgT2xpdmVyLAoKT24gRnJpLCAyMDIzLTA2LTIzIGF0IDIwOjUyICswMDAwLCBPbGl2ZXIgVXB0
b24gd3JvdGU6Cj4gVGhlIGRlYnVnIGFyY2hpdGVjdHVyZSBpcyBtYW5kYXRvcnkgaW4gQVJNdjgs
IHNvIEtWTSBzaG91bGQgbm90IGFsbG93Cj4gdXNlcnNwYWNlIHRvIGNvbmZpZ3VyZSBhIHZDUFUg
d2l0aCBsZXNzIHRoYW4gdGhhdC4gT2YgY291cnNlLCB0aGlzCj4gaXNuJ3QKPiBoYW5kbGVkIGVs
ZWdhbnRseSBieSB0aGUgZ2VuZXJpYyBJRCByZWdpc3RlciBwbHVtYmluZywgYXMgdGhlCj4gcmVz
cGVjdGl2ZQo+IElEIHJlZ2lzdGVyIGZpZWxkcyBoYXZlIGEgbm9uemVybyBzdGFydGluZyB2YWx1
ZS4KPiAKPiBBZGQgYW4gZXhwbGljaXQgY2hlY2sgZm9yIGRlYnVnIHZlcnNpb25zIGxlc3MgdGhh
biB2OCBvZiB0aGUKPiBhcmNoaXRlY3R1cmUuCj4gCj4gRml4ZXM6IGMxMThjZWFkMDdhNyAoIktW
TTogYXJtNjQ6IFVzZSBnZW5lcmljIHNhbml0aXNhdGlvbiBmb3IKPiBJRF8oQUE2NClERlIwX0VM
MSIpCj4gU2lnbmVkLW9mZi1ieTogT2xpdmVyIFVwdG9uIDxvbGl2ZXIudXB0b25AbGludXguZGV2
Pgo+IC0tLQo+IMKgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyB8IDEyICsrKysrKysrKysrKwo+
IMKgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPiBpbmRl
eCAxYTEzYmFiMWEwNmMuLjViMjUwNTNhOGUwNCAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2t2
bS9zeXNfcmVncy5jCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+IEBAIC0xNDgy
LDYgKzE0ODIsNyBAQCBzdGF0aWMgaW50IHNldF9pZF9hYTY0ZGZyMF9lbDEoc3RydWN0IGt2bV92
Y3B1Cj4gKnZjcHUsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkLAo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1
NjQgdmFsKQo+IMKgewo+ICvCoMKgwqDCoMKgwqDCoHU4IGRlYnVndmVyID0gU1lTX0ZJRUxEX0dF
VChJRF9BQTY0REZSMF9FTDEsIERlYnVnVmVyLCB2YWwpOwo+IMKgwqDCoMKgwqDCoMKgwqB1OCBw
bXV2ZXIgPSBTWVNfRklFTERfR0VUKElEX0FBNjRERlIwX0VMMSwgUE1VVmVyLCB2YWwpOwo+IMKg
Cj4gwqDCoMKgwqDCoMKgwqDCoC8qCj4gQEAgLTE1MDEsNiArMTUwMiwxMyBAQCBzdGF0aWMgaW50
IHNldF9pZF9hYTY0ZGZyMF9lbDEoc3RydWN0IGt2bV92Y3B1Cj4gKnZjcHUsCj4gwqDCoMKgwqDC
oMKgwqDCoGlmIChwbXV2ZXIgPT0gSURfQUE2NERGUjBfRUwxX1BNVVZlcl9JTVBfREVGKQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdmFsICY9IH5JRF9BQTY0REZSMF9FTDFfUE1V
VmVyX01BU0s7Cj4gwqAKPiArwqDCoMKgwqDCoMKgwqAvKgo+ICvCoMKgwqDCoMKgwqDCoCAqIElE
X0FBNjRERlIwX0VMMS5EZWJ1Z1ZlciBpcyBvbmUgb2YgdGhvc2UgYXdrd2FyZCBmaWVsZHMKPiB3
aXRoIGEKPiArwqDCoMKgwqDCoMKgwqAgKiBub256ZXJvIG1pbmltdW0gc2FmZSB2YWx1ZS4KPiAr
wqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqBpZiAoZGVidWd2ZXIgPCBJRF9BQTY0
REZSMF9FTDFfRGVidWdWZXJfSU1QKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBy
ZXR1cm4gLUVJTlZBTDsKPiArCgpBQTY0REZSMF9FTDFfRGVidWdWZXIgaGFzIGZlYXR1cmUgdHlw
ZSBGVFJfRVhBQ1Qgc28gdGhlIGd1ZXN0IHZhbHVlCm11c3QgZXhhY3RseSBtYXRjaCB0aGUgaG9z
dCB2YWx1ZS4gU28gSSBkb24ndCBiZWxpZXZlIHRoaXMgY2hlY2sgaXMKcmVxdWlyZWQuCgo+IMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gc2V0X2lkX3JlZyh2Y3B1LCByZCwgdmFsKTsKPiDCoH0KPiDC
oAo+IEBAIC0xNTIyLDYgKzE1MzAsNyBAQCBzdGF0aWMgaW50IHNldF9pZF9kZnIwX2VsMShzdHJ1
Y3Qga3ZtX3ZjcHUKPiAqdmNwdSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHU2NCB2YWwpCj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDCoHU4IHBl
cmZtb24gPSBTWVNfRklFTERfR0VUKElEX0RGUjBfRUwxLCBQZXJmTW9uLCB2YWwpOwo+ICvCoMKg
wqDCoMKgwqDCoHU4IGNvcGRiZyA9IFNZU19GSUVMRF9HRVQoSURfREZSMF9FTDEsIENvcERiZywg
dmFsKTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAocGVyZm1vbiA9PSBJRF9ERlIwX0VMMV9Q
ZXJmTW9uX0lNUERFRikgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdmFsICY9
IH5JRF9ERlIwX0VMMV9QZXJmTW9uX01BU0s7Cj4gQEAgLTE1MzcsNiArMTU0Niw5IEBAIHN0YXRp
YyBpbnQgc2V0X2lkX2RmcjBfZWwxKHN0cnVjdCBrdm1fdmNwdQo+ICp2Y3B1LAo+IMKgwqDCoMKg
wqDCoMKgwqBpZiAocGVyZm1vbiAhPSAwICYmIHBlcmZtb24gPCBJRF9ERlIwX0VMMV9QZXJmTW9u
X1BNVXYzKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU5WQUw7
Cj4gwqAKPiArwqDCoMKgwqDCoMKgwqBpZiAoY29wZGJnIDwgSURfREZSMF9FTDFfQ29wRGJnX0Fy
bXY4KQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVJTlZBTDsKPiAr
CgpUaGlzIG9uZSBoYXMgdHlwZSBGVFJfTE9XRVJfU0FGRSBhbmQgc28gdGhlIGNoZWNrIGlzIHJl
cXVpcmVkLgoKVGhhbmtzLApTdXJhagoKPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHNldF9pZF9y
ZWcodmNwdSwgcmQsIHZhbCk7Cj4gwqB9Cj4gwqAKPiAKPiBiYXNlLWNvbW1pdDogMTkyZGYyYWEw
MTEzZGRkZGVlMmE5M2U0NTNmZjQ2NjEwODA3YjQyNQoK
