Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9045C433E1
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 07:46:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DD942064B
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 07:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h23w2HAB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DD942064B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94E7C4B2A9;
	Fri,  3 Jul 2020 03:46:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s08-1dkht4-b; Fri,  3 Jul 2020 03:46:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 541F64B293;
	Fri,  3 Jul 2020 03:46:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1EC74B286
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 03:45:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9EnVRGoqehlX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2020 03:45:58 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99AC14B262
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 03:45:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593762358;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=svaBVRBSIxn/zApRlrGVfk5FjuBOJPoIWjV60nWSuWc=;
 b=h23w2HAB8PbNaL0OjtLhfNbGPTCvwI5KocMVOVMRg4MfIzEbpvrATkld0S8zk95zOG7F9i
 bMSIX0T01PTiHbUICmGx6Qhwx4aVFXRDMtJCPG/jAw9bpgEVbh56d46S8R7Y98QTI91wE/
 C4wPpBtHxViYgEHD+MmTZ/wvfz+x2yI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-R-k6Uxd2MQyU2O1h0UxpBA-1; Fri, 03 Jul 2020 03:45:56 -0400
X-MC-Unique: R-k6Uxd2MQyU2O1h0UxpBA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0473E10506E1;
 Fri,  3 Jul 2020 07:45:55 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BC2B6111F;
 Fri,  3 Jul 2020 07:45:52 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 8/8] arm64: microbench: Add vtimer
 latency test
To: Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-9-wangjingyi11@huawei.com>
 <88eacd00-1951-f6de-aa7c-bda48ece4fde@redhat.com>
 <5a43242d-2c0b-d8d1-b12d-7436e7d03e52@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a4bcb265-90c9-d5f3-c353-85f876cd5472@redhat.com>
Date: Fri, 3 Jul 2020 09:45:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <5a43242d-2c0b-d8d1-b12d-7436e7d03e52@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: maz@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgSmluZ3lpLAoKT24gNy8zLzIwIDk6NDEgQU0sIEppbmd5aSBXYW5nIHdyb3RlOgo+IEhpIEVy
aWMsIERyZXcsCj4gCj4gT24gNy8yLzIwMjAgOTozNiBQTSwgQXVnZXIgRXJpYyB3cm90ZToKPj4g
SGkgSmluZ3lpLAo+Pgo+PiBPbiA3LzIvMjAgNTowMSBBTSwgSmluZ3lpIFdhbmcgd3JvdGU6Cj4+
PiBUcmlnZ2VyIFBQSXMgYnkgc2V0dGluZyB1cCBhIDEwbXNlYyB0aW1lciBhbmQgdGVzdCB0aGUg
bGF0ZW5jeS4KPj4KPj4gc28gZm9yIGVhY2ggaXRlcmF0aW9uIHRoZSBhY2N1bXVsYXRlZCB2YWx1
ZWQgaXMgMTAgbXMgKyBsYXRlbmN5LCByaWdodD8KPj4gYW5kIHdoYXQgaXMgcHJpbnRlZCBhdCB0
aGUgZW5kIGRvZXMgaW5jbHVkZSB0aGUgYWNjdW11bGF0ZWQgcGVyaW9kcy4KPj4gV291bGRuJ3Qg
aXQgbWFrZSBzZW5zZSB0byBoYXZlIGEgdGVzdC0+cG9zdCgpIHRoYXQgc3Vic3RyYWN0IHRoaXMg
dmFsdWUuCj4+IFlvdSB3b3VsZCBuZWVkIHRvIHN0b3JlIHRoZSBhY3R1YWwgbnVtYmVyIG9mIGl0
ZXJhdGlvbnMuCj4+Cj4+IFRoYW5rcwo+Pgo+PiBFcmljCj4gCj4gVGhhdCdzIHJpZ2h0LCB0aGUg
cmVzdWx0IGluZGljYXRlcyAxMG1zICsgbGF0ZW5jeSwgd2hpY2ggaXMgYSAxMG1zZWMKPiB0aW1l
ciBhY3R1YWxseSBjb3N0cy4gSSB0aGluayB1c2luZyB0aGUgZGlmZmVyZW5jZSBpbnN0ZWFkIG9m
IHRoZSB0b3RhbAo+IHRpbWUgY29zdCBjYW4gYmUgYSBsaXR0bGUgY29uZnVzaW5nIGhlcmUuIE1h
eWJlIHdlIGNhbiB1c2UgdGVzdC0+cG9zdCgpCj4gdG8gZ2V0IHRoZSBsYXRlbmN5IGFuZCBwcmlu
dCBhbiBleHRyYSByZXN1bHQgaW4gbG9ncz8gRG8geW91IGhhdmUgYW55Cj4gb3BpbmlvbnMgb24g
dGhhdD8KCmZvciBvdGhlciBpbnRlcnJ1cHRzIHlvdSBvbmx5IHByaW50IHRoZSBsYXRlbmN5LCBy
aWdodD8gSGVyZSBpZiBJCnVuZGVyc3RhbmQgY29ycmVjdGx5IHlvdSB1c2UgdGhlIHRpbWVyIHRv
IHRyaWdnZXIgdGhlIFBQSSBidXQgc3RpbGwgeW91CmNhcmUgYWJvdXQgdGhlIGxhdGVuY3ksIGhl
bmNlIG15IHN1Z2dlc3Rpb24gdG8gb25seSBwcmludCB0aGUgbGF0ZW5jeS4KClRoYW5rcwoKRXJp
Ywo+IAo+IFRoYW5rcywKPiBKaW5neWkKPiAKPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBKaW5neWkg
V2FuZyA8d2FuZ2ppbmd5aTExQGh1YXdlaS5jb20+Cj4+PiAtLS0KPj4+IMKgIGFybS9taWNyby1i
ZW5jaC5jIHwgNTYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0KPj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA1NSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
Cj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2FybS9taWNyby1iZW5jaC5jIGIvYXJtL21pY3JvLWJlbmNo
LmMKPj4+IGluZGV4IDRjOTYyYjcuLjY4MjIwODQgMTAwNjQ0Cj4+PiAtLS0gYS9hcm0vbWljcm8t
YmVuY2guYwo+Pj4gKysrIGIvYXJtL21pY3JvLWJlbmNoLmMKPj4+IEBAIC0yMyw4ICsyMywxMyBA
QAo+Pj4gwqAgI2luY2x1ZGUgPGFzbS9naWMtdjMtaXRzLmg+Cj4+PiDCoCDCoCAjZGVmaW5lIE5U
SU1FUyAoMVUgPDwgMTYpCj4+PiArI2RlZmluZSBOVElNRVNfTUlOT1IgKDFVIDw8IDgpCj4+PiDC
oCAjZGVmaW5lIE1BWF9OUyAoNSAqIDEwMDAgKiAxMDAwICogMTAwMFVMKQo+Pj4gwqAgKyNkZWZp
bmUgSVJRX1ZUSU1FUsKgwqDCoMKgwqDCoMKgIDI3Cj4+PiArI2RlZmluZSBBUkNIX1RJTUVSX0NU
TF9FTkFCTEXCoMKgwqAgKDEgPDwgMCkKPj4+ICsjZGVmaW5lIEFSQ0hfVElNRVJfQ1RMX0lNQVNL
wqDCoMKgICgxIDw8IDEpCj4+PiArCj4+PiDCoCBzdGF0aWMgdTMyIGNudGZycTsKPj4+IMKgIMKg
IHN0YXRpYyB2b2xhdGlsZSBib29sIGlycV9yZWFkeSwgaXJxX3JlY2VpdmVkOwo+Pj4gQEAgLTMz
LDkgKzM4LDE2IEBAIHN0YXRpYyB2b2lkICgqd3JpdGVfZW9pcikodTMyIGlycXN0YXQpOwo+Pj4g
wqAgwqAgc3RhdGljIHZvaWQgZ2ljX2lycV9oYW5kbGVyKHN0cnVjdCBwdF9yZWdzICpyZWdzKQo+
Pj4gwqAgewo+Pj4gK8KgwqDCoCB1MzIgaXJxc3RhdCA9IGdpY19yZWFkX2lhcigpOwo+Pj4gwqDC
oMKgwqDCoCBpcnFfcmVhZHkgPSBmYWxzZTsKPj4+IMKgwqDCoMKgwqAgaXJxX3JlY2VpdmVkID0g
dHJ1ZTsKPj4+IC3CoMKgwqAgZ2ljX3dyaXRlX2VvaXIoZ2ljX3JlYWRfaWFyKCkpOwo+Pj4gK8Kg
wqDCoCBnaWNfd3JpdGVfZW9pcihpcnFzdGF0KTsKPj4+ICsKPj4+ICvCoMKgwqAgaWYgKGlycXN0
YXQgPT0gSVJRX1ZUSU1FUikgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIHdyaXRlX3N5c3JlZygoQVJD
SF9USU1FUl9DVExfSU1BU0sgfCBBUkNIX1RJTUVSX0NUTF9FTkFCTEUpLAo+Pj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNudHZfY3RsX2VsMCk7Cj4+PiArwqDCoMKgwqDCoMKg
wqAgaXNiKCk7Cj4+PiArwqDCoMKgIH0KPj4+IMKgwqDCoMKgwqAgaXJxX3JlYWR5ID0gdHJ1ZTsK
Pj4+IMKgIH0KPj4+IMKgIEBAIC0xODksNiArMjAxLDQ3IEBAIHN0YXRpYyB2b2lkIGxwaV9leGVj
KHZvaWQpCj4+PiDCoMKgwqDCoMKgIGFzc2VydF9tc2coaXJxX3JlY2VpdmVkLCAiZmFpbGVkIHRv
IHJlY2VpdmUgTFBJIGluIHRpbWUsIGJ1dAo+Pj4gcmVjZWl2ZWQgJWQgc3VjY2Vzc2Z1bGx5XG4i
LCByZWNlaXZlZCk7Cj4+PiDCoCB9Cj4+PiDCoCArc3RhdGljIGJvb2wgdGltZXJfcHJlcCh2b2lk
KQo+Pj4gK3sKPj4+ICvCoMKgwqAgc3RhdGljIHZvaWQgKmdpY19pc2VuYWJsZXI7Cj4+PiArCj4+
PiArwqDCoMKgIGdpY19lbmFibGVfZGVmYXVsdHMoKTsKPj4+ICvCoMKgwqAgaW5zdGFsbF9pcnFf
aGFuZGxlcihFTDFIX0lSUSwgZ2ljX2lycV9oYW5kbGVyKTsKPj4+ICvCoMKgwqAgbG9jYWxfaXJx
X2VuYWJsZSgpOwo+Pj4gKwo+Pj4gK8KgwqDCoCBnaWNfaXNlbmFibGVyID0gZ2ljdjNfc2dpX2Jh
c2UoKSArIEdJQ1JfSVNFTkFCTEVSMDsKPj4+ICvCoMKgwqAgd3JpdGVsKDEgPDwgMjcsIGdpY19p
c2VuYWJsZXIpOwo+Pj4gK8KgwqDCoCB3cml0ZV9zeXNyZWcoQVJDSF9USU1FUl9DVExfRU5BQkxF
LCBjbnR2X2N0bF9lbDApOwo+Pj4gK8KgwqDCoCBpc2IoKTsKPj4+ICsKPj4+ICvCoMKgwqAgZ2lj
X3ByZXBfY29tbW9uKCk7Cj4+PiArwqDCoMKgIHJldHVybiB0cnVlOwo+Pj4gK30KPj4+ICsKPj4+
ICtzdGF0aWMgdm9pZCB0aW1lcl9leGVjKHZvaWQpCj4+PiArewo+Pj4gK8KgwqDCoCB1NjQgYmVm
b3JlX3RpbWVyOwo+Pj4gK8KgwqDCoCB1NjQgdGltZXJfMTBtczsKPj4+ICvCoMKgwqAgdW5zaWdu
ZWQgdHJpZXMgPSAxIDw8IDI4Owo+Pj4gK8KgwqDCoCBzdGF0aWMgaW50IHJlY2VpdmVkID0gMDsK
Pj4+ICsKPj4+ICvCoMKgwqAgaXJxX3JlY2VpdmVkID0gZmFsc2U7Cj4+PiArCj4+PiArwqDCoMKg
IGJlZm9yZV90aW1lciA9IHJlYWRfc3lzcmVnKGNudHZjdF9lbDApOwo+Pj4gK8KgwqDCoCB0aW1l
cl8xMG1zID0gY250ZnJxIC8gMTAwOwo+Pj4gK8KgwqDCoCB3cml0ZV9zeXNyZWcoYmVmb3JlX3Rp
bWVyICsgdGltZXJfMTBtcywgY250dl9jdmFsX2VsMCk7Cj4+PiArwqDCoMKgIHdyaXRlX3N5c3Jl
ZyhBUkNIX1RJTUVSX0NUTF9FTkFCTEUsIGNudHZfY3RsX2VsMCk7Cj4+PiArwqDCoMKgIGlzYigp
Owo+Pj4gKwo+Pj4gK8KgwqDCoCB3aGlsZSAoIWlycV9yZWNlaXZlZCAmJiB0cmllcy0tKQo+Pj4g
K8KgwqDCoMKgwqDCoMKgIGNwdV9yZWxheCgpOwo+Pj4gKwo+Pj4gK8KgwqDCoCBpZiAoaXJxX3Jl
Y2VpdmVkKQo+Pj4gK8KgwqDCoMKgwqDCoMKgICsrcmVjZWl2ZWQ7Cj4+PiArCj4+PiArwqDCoMKg
IGFzc2VydF9tc2coaXJxX3JlY2VpdmVkLCAiZmFpbGVkIHRvIHJlY2VpdmUgUFBJIGluIHRpbWUs
IGJ1dAo+Pj4gcmVjZWl2ZWQgJWQgc3VjY2Vzc2Z1bGx5XG4iLCByZWNlaXZlZCk7Cj4+PiArfQo+
Pj4gKwo+Pj4gwqAgc3RhdGljIHZvaWQgaHZjX2V4ZWModm9pZCkKPj4+IMKgIHsKPj4+IMKgwqDC
oMKgwqAgYXNtIHZvbGF0aWxlKCJtb3YgdzAsICMweDRiMDAwMDAwOyBodmMgIzAiIDo6OiAidzAi
KTsKPj4+IEBAIC0yMzYsNiArMjg5LDcgQEAgc3RhdGljIHN0cnVjdCBleGl0X3Rlc3QgdGVzdHNb
XSA9IHsKPj4+IMKgwqDCoMKgwqAgeyJpcGkiLMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaXBpX3By
ZXAswqDCoMKgIGlwaV9leGVjLMKgwqDCoMKgwqDCoMKgIE5USU1FUyzCoMKgwqDCoMKgwqDCoAo+
Pj4gdHJ1ZX0sCj4+PiDCoMKgwqDCoMKgIHsiaXBpX2h3IizCoMKgwqDCoMKgwqDCoCBpcGlfaHdf
cHJlcCzCoMKgwqAgaXBpX2V4ZWMswqDCoMKgwqDCoMKgwqAKPj4+IE5USU1FUyzCoMKgwqDCoMKg
wqDCoCB0cnVlfSwKPj4+IMKgwqDCoMKgwqAgeyJscGkiLMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
bHBpX3ByZXAswqDCoMKgIGxwaV9leGVjLMKgwqDCoMKgwqDCoMKgIE5USU1FUyzCoMKgwqDCoMKg
wqDCoAo+Pj4gdHJ1ZX0sCj4+PiArwqDCoMKgIHsidGltZXJfMTBtcyIswqDCoMKgwqDCoMKgwqAg
dGltZXJfcHJlcCzCoMKgwqAgdGltZXJfZXhlYyzCoMKgwqDCoMKgwqDCoAo+Pj4gTlRJTUVTX01J
Tk9SLMKgwqDCoCB0cnVlfSwKPj4+IMKgIH07Cj4+PiDCoCDCoCBzdHJ1Y3QgbnNfdGltZSB7Cj4+
Pgo+Pgo+Pgo+PiAuCj4+Cj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
