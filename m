Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B00C2D0E5
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 12:38:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FDA1206E6
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 12:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jei6MkZo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FDA1206E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4BC04B1DA;
	Mon, 30 Mar 2020 08:38:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xHH-ww-AnDMN; Mon, 30 Mar 2020 08:38:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 675C64B1CF;
	Mon, 30 Mar 2020 08:38:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2F4B4B1B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 08:38:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a+jhtf6qW5p0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 08:38:45 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5A14B1B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 08:38:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585571925;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Z4cUzeidLCschmMx+521qeR+2AGe9fkhbWsqAhHXFkg=;
 b=Jei6MkZohwWkaJ0GFaOPY+9Wyuch94fZKKz9l/VPvrNx7L66Ahn45CvhnAYmYUu3pFt7C6
 JDq9n8Dt6Veurj2Hkx7F1+EqAurISyI1pD/VQcwynZuezHaHizoT+7eddi1kxwmQMLpOS3
 QuXk5q/T9LzJ51K/TLzeUwlEFUWBOoA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-e6d9mGMXOOW6hD0m0hqhTQ-1; Mon, 30 Mar 2020 08:38:41 -0400
X-MC-Unique: e6d9mGMXOOW6hD0m0hqhTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A27618AB2C4;
 Mon, 30 Mar 2020 12:38:40 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 89E3C5DA66;
 Mon, 30 Mar 2020 12:38:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 13/13] arm/arm64: ITS: pending table
 migration test
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-14-eric.auger@redhat.com>
 <296c574b-810c-9c90-a613-df732a9ac193@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <ea74559c-2ab4-752c-e587-2bf40eab14b0@redhat.com>
Date: Mon, 30 Mar 2020 14:38:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <296c574b-810c-9c90-a613-df732a9ac193@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

SGkgWmVuZ2h1aSwKCk9uIDMvMzAvMjAgMjowNiBQTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBF
cmljLAo+IAo+IE9uIDIwMjAvMy8yMCAxNzoyNCwgRXJpYyBBdWdlciB3cm90ZToKPj4gQWRkIHR3
byBuZXcgbWlncmF0aW9uIHRlc3RzLiBPbmUgdGVzdGluZyB0aGUgbWlncmF0aW9uIG9mCj4+IGEg
dG9wb2xvZ3kgd2hlcmUgY29sbGVjdGlvbiB3ZXJlIHVubWFwcGVkLiBUaGUgc2Vjb25kIHRlc3QK
Pj4gY2hlY2tzIHRoZSBtaWdyYXRpb24gb2YgdGhlIHBlbmRpbmcgdGFibGUuCj4+Cj4+IFNpZ25l
ZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPiAKPiBbLi4uXQo+
IAo+PiBAQCAtNjU5LDYgKzY3OCwxNSBAQCBzdGF0aWMgaW50IGl0c19wcmVyZXF1aXNpdGVzKGlu
dCBuYl9jcHVzKQo+PiDCoMKgwqDCoMKgIHJldHVybiAwOwo+PiDCoCB9Cj4+IMKgICtzdGF0aWMg
dm9pZCBzZXRfbHBpKHN0cnVjdCBpdHNfZGV2aWNlICpkZXYsIHUzMiBldmVudGlkLCB1MzIgcGh5
c2lkLAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gKmNv
bCkKPj4gK3sKPj4gK8KgwqDCoCBhc3NlcnQoZGV2ICYmIGNvbCk7Cj4+ICsKPj4gK8KgwqDCoCBp
dHNfc2VuZF9tYXB0aShkZXYsIHBoeXNpZCwgZXZlbnRpZCwgY29sKTsKPj4gK8KgwqDCoCBnaWN2
M19scGlfc2V0X2NvbmZpZyhwaHlzaWQsIExQSV9QUk9QX0RFRkFVTFQpOwo+PiArfQo+IAo+IEkn
ZCBzYXkgd2UgY2FuIGp1c3QgZHJvcCB0aGlzIGhlbHBlciBhbmQgb3Blbi1jb2RlIGl0IGFueXdo
ZXJlCj4gbmVjZXNzYXJpbHkuIFRoZSBuYW1lICdzZXRfbHBpJyBkb2Vzbid0IHRlbGwgbWUgdG9v
IG11Y2ggYWJvdXQKPiB3aGF0IGhhcyBiZWVuIGltcGxlbWVudGVkIGluc2lkZSB0aGUgaGVscGVy
Lgo+IAo+PiArCj4+IMKgIC8qCj4+IMKgwqAgKiBTZXR1cCB0aGUgY29uZmlndXJhdGlvbiBmb3Ig
dGhvc2UgbWFwcGluZ3M6Cj4+IMKgwqAgKiBkZXZfaWQ9MiBldmVudD0yMCAtPiB2Y3B1IDMsIGlu
dGlkPTgxOTUKPj4gQEAgLTc5MCw2ICs4MTgsMTA4IEBAIHN0YXRpYyB2b2lkIHRlc3RfaXRzX21p
Z3JhdGlvbih2b2lkKQo+PiDCoMKgwqDCoMKgIGl0c19zZW5kX2ludChkZXY3LCAyNTUpOwo+PiDC
oMKgwqDCoMKgIGNoZWNrX2xwaV9zdGF0cygiZGV2Ny9ldmVudGlkPTI1NSB0cmlnZ2VycyBMUEkg
ODE5NiBvbiBQRSAjMgo+PiBhZnRlciBtaWdyYXRpb24iKTsKPj4gwqAgfQo+PiArCj4+ICtzdGF0
aWMgdm9pZCB0ZXN0X21pZ3JhdGVfdW5tYXBwZWRfY29sbGVjdGlvbih2b2lkKQo+PiArewo+PiAr
wqDCoMKgIHN0cnVjdCBpdHNfY29sbGVjdGlvbiAqY29sOwo+PiArwqDCoMKgIHN0cnVjdCBpdHNf
ZGV2aWNlICpkZXYyLCAqZGV2NzsKPj4gK8KgwqDCoCBpbnQgcGUwID0gMDsKPj4gK8KgwqDCoCB1
OCBjb25maWc7Cj4+ICsKPj4gK8KgwqDCoCBpZiAoaXRzX3NldHVwMSgpKQo+PiArwqDCoMKgwqDC
oMKgwqAgcmV0dXJuOwo+PiArCj4+ICvCoMKgwqAgY29sID0gaXRzX2NyZWF0ZV9jb2xsZWN0aW9u
KHBlMCwgcGUwKTsKPj4gK8KgwqDCoCBkZXYyID0gaXRzX2dldF9kZXZpY2UoMik7Cj4+ICvCoMKg
wqAgZGV2NyA9IGl0c19nZXRfZGV2aWNlKDcpOwo+PiArCj4+ICvCoMKgwqAgLyogTUFQVEkgd2l0
aCB0aGUgY29sbGVjdGlvbiB1bm1hcHBlZCAqLwo+PiArwqDCoMKgIHNldF9scGkoZGV2MiwgMCwg
ODE5MiwgY29sKTsKPiAKPiAuLi4gYW5kIGl0J3Mgb25seSBpbnZva2VkIGhlcmUuCj4gCj4+ICsK
Pj4gK8KgwqDCoCBwdXRzKCJOb3cgbWlncmF0ZSB0aGUgVk0sIHRoZW4gcHJlc3MgYSBrZXkgdG8g
Y29udGludWUuLi5cbiIpOwo+PiArwqDCoMKgICh2b2lkKWdldGNoYXIoKTsKPj4gK8KgwqDCoCBy
ZXBvcnRfaW5mbygiTWlncmF0aW9uIGNvbXBsZXRlIik7Cj4+ICsKPj4gK8KgwqDCoCAvKiBvbiB0
aGUgZGVzdGluYXRpb24sIG1hcCB0aGUgY29sbGVjdGlvbiAqLwo+PiArwqDCoMKgIGl0c19zZW5k
X21hcGMoY29sLCB0cnVlKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9pbnZhbGwoY29sKTsKPj4gKwo+
PiArwqDCoMKgIGxwaV9zdGF0c19leHBlY3QoMiwgODE5Nik7Cj4+ICvCoMKgwqAgaXRzX3NlbmRf
aW50KGRldjcsIDI1NSk7Cj4+ICvCoMKgwqAgY2hlY2tfbHBpX3N0YXRzKCJkZXY3L2V2ZW50aWQ9
IDI1NSB0cmlnZ2VyZWQgTFBJIDgxOTYgb24gUEUgIzIiKTsKPj4gKwo+PiArwqDCoMKgIGNvbmZp
ZyA9IGdpY3YzX2xwaV9nZXRfY29uZmlnKDgxOTIpOwo+PiArwqDCoMKgIHJlcG9ydChjb25maWcg
PT0gTFBJX1BST1BfREVGQVVMVCwKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgICJDb25maWcgb2Yg
TFBJIDgxOTIgd2FzIHByb3Blcmx5IG1pZ3JhdGVkIik7Cj4+ICsKPj4gK8KgwqDCoCBscGlfc3Rh
dHNfZXhwZWN0KHBlMCwgODE5Mik7Cj4+ICvCoMKgwqAgaXRzX3NlbmRfaW50KGRldjIsIDApOwo+
PiArwqDCoMKgIGNoZWNrX2xwaV9zdGF0cygiZGV2Mi9ldmVudGlkID0gMCB0cmlnZ2VyZWQgTFBJ
IDgxOTIgb24gUEUwIik7Cj4+ICt9Cj4+ICsKPj4gK3N0YXRpYyB2b2lkIHRlc3RfaXRzX3BlbmRp
bmdfbWlncmF0aW9uKHZvaWQpCj4+ICt7Cj4+ICvCoMKgwqAgc3RydWN0IGl0c19kZXZpY2UgKmRl
djsKPj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gKmNvbGxlY3Rpb25bMl07Cj4+ICvC
oMKgwqAgaW50ICpleHBlY3RlZCA9IG1hbGxvYyhucl9jcHVzICogc2l6ZW9mKGludCkpOwo+PiAr
wqDCoMKgIGludCBwZTAgPSBucl9jcHVzIC0gMSwgcGUxID0gbnJfY3B1cyAtIDI7Cj4+ICvCoMKg
wqAgdTY0IHBlbmRiYXNlcjsKPj4gK8KgwqDCoCB2b2lkICpwdHI7Cj4+ICvCoMKgwqAgaW50IGk7
Cj4+ICsKPj4gK8KgwqDCoCBpZiAoaXRzX3ByZXJlcXVpc2l0ZXMoNCkpCj4+ICvCoMKgwqDCoMKg
wqDCoCByZXR1cm47Cj4+ICsKPj4gK8KgwqDCoCBkZXYgPSBpdHNfY3JlYXRlX2RldmljZSgyIC8q
IGRldiBpZCAqLywgOCAvKiBuYl9pdGVzICovKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9tYXBkKGRl
diwgdHJ1ZSk7Cj4+ICsKPj4gK8KgwqDCoCBjb2xsZWN0aW9uWzBdID0gaXRzX2NyZWF0ZV9jb2xs
ZWN0aW9uKHBlMCwgcGUwKTsKPj4gK8KgwqDCoCBjb2xsZWN0aW9uWzFdID0gaXRzX2NyZWF0ZV9j
b2xsZWN0aW9uKHBlMSwgcGUxKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9tYXBjKGNvbGxlY3Rpb25b
MF0sIHRydWUpOwo+PiArwqDCoMKgIGl0c19zZW5kX21hcGMoY29sbGVjdGlvblsxXSwgdHJ1ZSk7
Cj4+ICsKPj4gK8KgwqDCoCAvKiBkaXNhYmxlIGxwaSBhdCByZWRpc3QgbGV2ZWwgKi8KPj4gK8Kg
wqDCoCBnaWN2M19scGlfcmRpc3RfZGlzYWJsZShwZTApOwo+PiArwqDCoMKgIGdpY3YzX2xwaV9y
ZGlzdF9kaXNhYmxlKHBlMSk7Cj4+ICsKPj4gK8KgwqDCoCAvKiBscGlzIGFyZSBpbnRlcmxlYXZl
ZCBpbmJldHdlZW4gdGhlIDIgUEVzICovCj4+ICvCoMKgwqAgZm9yIChpID0gMDsgaSA8IDI1Njsg
aSsrKSB7Cj4+ICvCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gKmNvbCA9IGkg
JSAyID8gY29sbGVjdGlvblswXSA6Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb2xsZWN0aW9uWzFdOwo+PiArwqDCoMKgwqDCoMKg
wqAgaW50IHZjcHUgPSBjb2wtPnRhcmdldF9hZGRyZXNzID4+IDE2Owo+PiArCj4+ICvCoMKgwqDC
oMKgwqDCoCBpdHNfc2VuZF9tYXB0aShkZXYsIExQSShpKSwgaSwgY29sKTsKPj4gK8KgwqDCoMKg
wqDCoMKgIGdpY3YzX2xwaV9zZXRfY29uZmlnKExQSShpKSwgTFBJX1BST1BfREVGQVVMVCk7Cj4+
ICvCoMKgwqDCoMKgwqDCoCBnaWN2M19scGlfc2V0X2Nscl9wZW5kaW5nKHZjcHUsIExQSShpKSwg
dHJ1ZSk7Cj4+ICvCoMKgwqAgfQo+PiArwqDCoMKgIGl0c19zZW5kX2ludmFsbChjb2xsZWN0aW9u
WzBdKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9pbnZhbGwoY29sbGVjdGlvblsxXSk7Cj4+ICsKPj4g
K8KgwqDCoCAvKiBDbGVhciB0aGUgUFRaIGJpdCBvbiBlYWNoIHBlbmRiYXNlciAqLwo+PiArCj4+
ICvCoMKgwqAgZXhwZWN0ZWRbcGUwXSA9IDEyODsKPj4gK8KgwqDCoCBleHBlY3RlZFtwZTFdID0g
MTI4Owo+IAo+IERvIHdlIG5lZWQgdG8gaW5pdGlhbGl6ZSBleHBlY3RlZFtdIGZvciBvdGhlciBQ
RXM/IE9yIGl0IGhhcyBhbHdheXMKPiBiZWVuIHplcm9lZCBieSB0aGUga3ZtLXVuaXQtdGVzdHMg
aW1wbGVtZW50YXRpb24gb2YgbWFsbG9jKCk/Cj4gCj4+ICsKPj4gK8KgwqDCoCBwdHIgPSBnaWN2
M19kYXRhLnJlZGlzdF9iYXNlW3BlMF0gKyBHSUNSX1BFTkRCQVNFUjsKPj4gK8KgwqDCoCBwZW5k
YmFzZXIgPSByZWFkcShwdHIpOwo+PiArwqDCoMKgIHdyaXRlcShwZW5kYmFzZXIgJiB+R0lDUl9Q
RU5EQkFTRVJfUFRaLCBwdHIpOwo+PiArCj4+ICvCoMKgwqAgcHRyID0gZ2ljdjNfZGF0YS5yZWRp
c3RfYmFzZVtwZTFdICsgR0lDUl9QRU5EQkFTRVI7Cj4+ICvCoMKgwqAgcGVuZGJhc2VyID0gcmVh
ZHEocHRyKTsKPj4gK8KgwqDCoCB3cml0ZXEocGVuZGJhc2VyICYgfkdJQ1JfUEVOREJBU0VSX1BU
WiwgcHRyKTsKPj4gKwo+PiArwqDCoMKgIGdpY3YzX2xwaV9yZGlzdF9lbmFibGUocGUwKTsKPj4g
K8KgwqDCoCBnaWN2M19scGlfcmRpc3RfZW5hYmxlKHBlMSk7Cj4gCj4gSSBkb24ndCBrbm93IGhv
dyB0aGUgbWlncmF0aW9uIGdldHMgaW1wbGVtZW50ZWQgaW4ga3ZtLXVuaXQtdGVzdHMuCj4gQnV0
IGlzIHRoZXJlIGFueSBndWFyYW50ZWUgdGhhdCB0aGUgTFBJcyB3aWxsIG9ubHkgYmUgdHJpZ2dl
cmVkIG9uIHRoZQo+IGRlc3RpbmF0aW9uIHNpZGU/IEFzIG9uY2UgdGhlIEVuYWJsZUxQSXMgYml0
IGJlY29tZXMgMSwgVkdJQyB3aWxsIHN0YXJ0Cj4gcmVhZGluZyB0aGUgcGVuZGluZyBiaXQgaW4g
Z3Vlc3QgbWVtb3J5IGFuZCBwb3RlbnRpYWxseSBpbmplY3RpbmcgTFBJcwo+IGludG8gdGhlIHRh
cmdldCB2Y3B1IChpbiB0aGUgc291cmNlIHNpZGUpLgoKSSBleHBlY3Qgc29tZSBMUElzIHRvIGhp
dCBvbiBzb3VyY2UgYW5kIHNvbWUgb3RoZXJzIHRvIGhpdCBvbiB0aGUKZGVzdGluYXRpb24uIFRv
IG1lLCB0aGlzIGRvZXMgbm90IHJlYWxseSBtYXR0ZXIgYXMgbG9uZyBhcyB0aGUgaGFuZGxlcnMK
Z2V0cyBjYWxsZWQgYW5kIGFjY3VtdWxhdGUgdGhlIHN0YXRzLiBHaXZlbiB0aGUgbnVtYmVyIG9m
IExQSXMsIHdlIHdpbGwKYXQgbGVhc3QgdGVzdCB0aGUgbWlncmF0aW9uIG9mIHNvbWUgb2YgdGhl
IHBlbmRpbmcgYml0cyBhbmQgZXNwZWNpYWxseQphZGphY2VudCBvbmVzLiBJdCBkb2VzIHdvcmsg
YXMgaXQgYWxsb3dzIHRvIHRlc3QgeW91ciBmaXg6CgpjYTE4NWIyNjA5NTEgIEtWTTogYXJtL2Fy
bTY0OiB2Z2ljOiBEb24ndCByZWx5IG9uIHRoZSB3cm9uZyBwZW5kaW5nIHRhYmxlCgpUaGFua3MK
CkVyaWMKPiAKPj4gKwo+PiArwqDCoMKgIHB1dHMoIk5vdyBtaWdyYXRlIHRoZSBWTSwgdGhlbiBw
cmVzcyBhIGtleSB0byBjb250aW51ZS4uLlxuIik7Cj4+ICvCoMKgwqAgKHZvaWQpZ2V0Y2hhcigp
Owo+PiArwqDCoMKgIHJlcG9ydF9pbmZvKCJNaWdyYXRpb24gY29tcGxldGUiKTsKPj4gKwo+PiAr
wqDCoMKgIC8qIGxldCdzIHdhaXQgZm9yIHRoZSAyNTYgTFBJcyB0byBiZSBoYW5kbGVkICovCj4+
ICvCoMKgwqAgbWRlbGF5KDEwMDApOwo+PiArCj4+ICvCoMKgwqAgY2hlY2tfbHBpX2hpdHMoZXhw
ZWN0ZWQsICIxMjggTFBJcyBvbiBib3RoIFBFMCBhbmQgUEUxIGFmdGVyCj4+IG1pZ3JhdGlvbiIp
Owo+PiArfQo+IAo+IAo+IFRoYW5rcywKPiBaZW5naHVpCj4gCj4gCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
