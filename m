Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85653C18E5A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 13:48:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02DCE20873
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 13:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e57DSEB9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02DCE20873
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D6174A534;
	Wed, 11 Mar 2020 09:48:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RsWvapcPz0sn; Wed, 11 Mar 2020 09:48:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FA334A4F6;
	Wed, 11 Mar 2020 09:48:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A50A54A4C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 09:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pf7ts5TWhwte for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 09:48:22 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 912E14A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 09:48:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583934502;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ojxoxR+MHQtWUQ/abjg7bLaa0SyuDx1Bi9ausr3HrUw=;
 b=e57DSEB9UXOH3K0A9Tu+BMnloQTKorhBRs+lCp6uCGt8b24umDSSvCl/utBWOdK0YDsVUD
 PaQ8eqwAlL4NdKcqdvwEcHyFeEw1I+hpCrC6hMdeGvy20nuJQSZbGAdLGHpFQ5lYg1f3Ty
 kf9azlU3/5H7e0TcFs7aa83ObTZdSgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-TwTOY6s4MGWF3JJ6-DH5-w-1; Wed, 11 Mar 2020 09:48:20 -0400
X-MC-Unique: TwTOY6s4MGWF3JJ6-DH5-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 687EE1005509;
 Wed, 11 Mar 2020 13:48:18 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 114CA60CC0;
 Wed, 11 Mar 2020 13:48:13 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
Date: Wed, 11 Mar 2020 14:48:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: andre.przywara@arm.com, thuth@redhat.com
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

SGkgWmVuZ2h1aSwKCk9uIDMvMTEvMjAgMTI6NTkgUE0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDIwLzMvMTAgMjI6NTQsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+IFRyaWdn
ZXJzIExQSXMgdGhyb3VnaCB0aGUgSU5UIGNvbW1hbmQuCj4+Cj4+IHRoZSB0ZXN0IGNoZWNrcyB0
aGUgTFBJIGhpdHMgdGhlIHJpZ2h0IENQVSBhbmQgdHJpZ2dlcnMKPj4gdGhlIHJpZ2h0IExQSSBp
bnRpZCwgaWUuIHRoZSB0cmFuc2xhdGlvbiBpcyBjb3JyZWN0Lgo+Pgo+PiBVcGRhdGVzIHRvIHRo
ZSBjb25maWcgdGFibGUgYWxzbyBhcmUgdGVzdGVkLCBhbG9uZyB3aXRoIGludgo+PiBhbmQgaW52
YWxsIGNvbW1hbmRzLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2Vy
QHJlZGhhdC5jb20+Cj4+Cj4+IC0tLQo+IAo+IFsuLi5dCj4gCj4+ICtzdGF0aWMgdm9pZCB0ZXN0
X2l0c190cmlnZ2VyKHZvaWQpCj4+ICt7Cj4+ICvCoMKgwqAgc3RydWN0IGl0c19jb2xsZWN0aW9u
ICpjb2wzLCAqY29sMjsKPj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2RldmljZSAqZGV2MiwgKmRldjc7
Cj4+ICsKPj4gK8KgwqDCoCBpZiAoaXRzX3ByZXJlcXVpc2l0ZXMoNCkpCj4+ICvCoMKgwqDCoMKg
wqDCoCByZXR1cm47Cj4+ICsKPj4gK8KgwqDCoCBkZXYyID0gaXRzX2NyZWF0ZV9kZXZpY2UoMiAv
KiBkZXYgaWQgKi8sIDggLyogbmJfaXRlcyAqLyk7Cj4+ICvCoMKgwqAgZGV2NyA9IGl0c19jcmVh
dGVfZGV2aWNlKDcgLyogZGV2IGlkICovLCA4IC8qIG5iX2l0ZXMgKi8pOwo+PiArCj4+ICvCoMKg
wqAgY29sMyA9IGl0c19jcmVhdGVfY29sbGVjdGlvbigzIC8qIGNvbCBpZCAqLywgMy8qIHRhcmdl
dCBQRSAqLyk7Cj4+ICvCoMKgwqAgY29sMiA9IGl0c19jcmVhdGVfY29sbGVjdGlvbigyIC8qIGNv
bCBpZCAqLywgMi8qIHRhcmdldCBQRSAqLyk7Cj4+ICsKPj4gK8KgwqDCoCBnaWN2M19scGlfc2V0
X2NvbmZpZyg4MTk1LCBMUElfUFJPUF9ERUZBVUxUKTsKPj4gK8KgwqDCoCBnaWN2M19scGlfc2V0
X2NvbmZpZyg4MTk2LCBMUElfUFJPUF9ERUZBVUxUKTsKPj4gKwo+PiArwqDCoMKgIGl0c19zZW5k
X2ludmFsbChjb2wyKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9pbnZhbGwoY29sMyk7Cj4gCj4gVGhl
c2UgdHdvIElOVkFMTHMgc2hvdWxkIGJlIGlzc3VlZCBhZnRlciBjb2wyIGFuZCBjb2wzIGFyZSBt
YXBwZWQsCj4gb3RoZXJ3aXNlIHRoaXMgd2lsbCBjYXVzZSB0aGUgSU5WQUxMIGNvbW1hbmQgZXJy
b3IgYXMgcGVyIHRoZSBzcGVjCj4gKHRob3VnaCBLVk0gZG9lc24ndCBjb21wbGFpbiBpdCBhdCBh
bGwpLgpZZXMgeW91J3JlIHJpZ2h0LiByZWFkaW5nIHRoZSBzcGVjIGFnYWluOgoKQSBjb21tYW5k
IGVycm9yIG9jY3VycyBpZiBhbnkgb2YgdGhlIGZvbGxvd2luZyBhcHBseToKLi4vLi4KVGhlIGNv
bGxlY3Rpb24gc3BlY2lmaWVkIGJ5IElDSUQgaGFzIG5vdCBiZWVuIG1hcHBlZCB0byBhbiBSRGJh
c2UgdXNpbmcKTUFQQy4KCkJ1dCBhcyBtZW50aW9ubmVkIGluIHRoZSBjb3ZlciBsZXR0ZXIsIG5v
IHJlYWwgbWVhbnMgdG8gcmV0cmlldmUgdGhlCmVycm9yIGF0IHRoZSBtb21lbnQuCgo+IAo+PiAr
Cj4+ICvCoMKgwqAgcmVwb3J0X3ByZWZpeF9wdXNoKCJpbnQiKTsKPj4gK8KgwqDCoCAvKgo+PiAr
wqDCoMKgwqAgKiBkZXY9MiwgZXZlbnRpZD0yMMKgIC0+IGxwaT0gODE5NSwgY29sPTMKPj4gK8Kg
wqDCoMKgICogZGV2PTcsIGV2ZW50aWQ9MjU1IC0+IGxwaT0gODE5NiwgY29sPTIKPj4gK8KgwqDC
oMKgICogVHJpZ2dlciBkZXYyLCBldmVudGlkPTIwIGFuZCBkZXY3LCBldmVudGlkPTI1NQo+PiAr
wqDCoMKgwqAgKiBDaGVjayBib3RoIExQSXMgaGl0Cj4+ICvCoMKgwqDCoCAqLwo+PiArCj4+ICvC
oMKgwqAgaXRzX3NlbmRfbWFwZChkZXYyLCB0cnVlKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9tYXBk
KGRldjcsIHRydWUpOwo+PiArCj4+ICvCoMKgwqAgaXRzX3NlbmRfbWFwYyhjb2wzLCB0cnVlKTsK
Pj4gK8KgwqDCoCBpdHNfc2VuZF9tYXBjKGNvbDIsIHRydWUpOwo+PiArCj4+ICvCoMKgwqAgaXRz
X3NlbmRfbWFwdGkoZGV2MiwgODE5NSAvKiBscGkgaWQgKi8sIDIwIC8qIGV2ZW50IGlkICovLCBj
b2wzKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9tYXB0aShkZXY3LCA4MTk2IC8qIGxwaSBpZCAqLywg
MjU1IC8qIGV2ZW50IGlkICovLCBjb2wyKTsKPj4gKwo+PiArwqDCoMKgIGxwaV9zdGF0c19leHBl
Y3QoMywgODE5NSk7Cj4+ICvCoMKgwqAgaXRzX3NlbmRfaW50KGRldjIsIDIwKTsKPj4gK8KgwqDC
oCBjaGVja19scGlfc3RhdHMoImRldj0yLCBldmVudGlkPTIwwqAgLT4gbHBpPSA4MTk1LCBjb2w9
MyIpOwo+PiArCj4+ICvCoMKgwqAgbHBpX3N0YXRzX2V4cGVjdCgyLCA4MTk2KTsKPj4gK8KgwqDC
oCBpdHNfc2VuZF9pbnQoZGV2NywgMjU1KTsKPj4gK8KgwqDCoCBjaGVja19scGlfc3RhdHMoImRl
dj03LCBldmVudGlkPTI1NSAtPiBscGk9IDgxOTYsIGNvbD0yIik7Cj4+ICsKPj4gK8KgwqDCoCBy
ZXBvcnRfcHJlZml4X3BvcCgpOwo+PiArCj4+ICvCoMKgwqAgcmVwb3J0X3ByZWZpeF9wdXNoKCJp
bnYvaW52YWxsIik7Cj4+ICsKPj4gK8KgwqDCoCAvKgo+PiArwqDCoMKgwqAgKiBkaXNhYmxlIDgx
OTUsIGNoZWNrIGRldjIvZXZlbnRpZD0yMCBkb2VzIG5vdCB0cmlnZ2VyIHRoZQo+PiArwqDCoMKg
wqAgKiBjb3JyZXNwb25kaW5nIExQSQo+PiArwqDCoMKgwqAgKi8KPj4gK8KgwqDCoCBnaWN2M19s
cGlfc2V0X2NvbmZpZyg4MTk1LCBMUElfUFJPUF9ERUZBVUxUICYgfkxQSV9QUk9QX0VOQUJMRUQp
Owo+PiArwqDCoMKgIGl0c19zZW5kX2ludihkZXYyLCAyMCk7Cj4+ICsKPj4gK8KgwqDCoCBscGlf
c3RhdHNfZXhwZWN0KC0xLCAtMSk7Cj4+ICvCoMKgwqAgaXRzX3NlbmRfaW50KGRldjIsIDIwKTsK
Pj4gK8KgwqDCoCBjaGVja19scGlfc3RhdHMoImRldjIvZXZlbnRpZD0yMCBkb2VzIG5vdCB0cmln
Z2VyIGFueSBMUEkiKTsKPj4gKwo+PiArwqDCoMKgIC8qCj4+ICvCoMKgwqDCoCAqIHJlLWVuYWJs
ZSB0aGUgTFBJIGJ1dCB3aWxsaW5nbHkgZG8gbm90IGNhbGwgaW52YWxsCj4+ICvCoMKgwqDCoCAq
IHNvIHRoZSBjaGFuZ2UgaW4gY29uZmlnIGlzIG5vdCB0YWtlbiBpbnRvIGFjY291bnQuCj4+ICvC
oMKgwqDCoCAqIFRoZSBMUEkgc2hvdWxkIG5vdCBoaXQKPj4gK8KgwqDCoMKgICovCj4+ICvCoMKg
wqAgZ2ljdjNfbHBpX3NldF9jb25maWcoODE5NSwgTFBJX1BST1BfREVGQVVMVCk7Cj4+ICvCoMKg
wqAgbHBpX3N0YXRzX2V4cGVjdCgtMSwgLTEpOwo+PiArwqDCoMKgIGl0c19zZW5kX2ludChkZXYy
LCAyMCk7Cj4+ICvCoMKgwqAgY2hlY2tfbHBpX3N0YXRzKCJkZXYyL2V2ZW50aWQ9MjAgc3RpbGwg
ZG9lcyBub3QgdHJpZ2dlciBhbnkgTFBJIik7Cj4+ICsKPj4gK8KgwqDCoCAvKiBOb3cgY2FsbCB0
aGUgaW52YWxsIGFuZCBjaGVjayB0aGUgTFBJIGhpdHMgKi8KPj4gK8KgwqDCoCBpdHNfc2VuZF9p
bnZhbGwoY29sMyk7Cj4+ICvCoMKgwqAgbHBpX3N0YXRzX2V4cGVjdCgzLCA4MTk1KTsKPj4gK8Kg
wqDCoCBpdHNfc2VuZF9pbnQoZGV2MiwgMjApOwo+PiArwqDCoMKgIGNoZWNrX2xwaV9zdGF0cygi
ZGV2Mi9ldmVudGlkPTIwIG5vdyB0cmlnZ2VycyBhbiBMUEkiKTsKPj4gKwo+PiArwqDCoMKgIHJl
cG9ydF9wcmVmaXhfcG9wKCk7Cj4+ICsKPj4gK8KgwqDCoCByZXBvcnRfcHJlZml4X3B1c2goIm1h
cGQgdmFsaWQ9ZmFsc2UiKTsKPj4gK8KgwqDCoCAvKgo+PiArwqDCoMKgwqAgKiBVbm1hcCBkZXZp
Y2UgMiBhbmQgY2hlY2sgdGhlIGV2ZW50aWQgMjAgZm9ybWVybHkKPj4gK8KgwqDCoMKgICogYXR0
YWNoZWQgdG8gaXQgZG9lcyBub3QgaGl0IGFueW1vcmUKPj4gK8KgwqDCoMKgICovCj4+ICsKPj4g
K8KgwqDCoCBpdHNfc2VuZF9tYXBkKGRldjIsIGZhbHNlKTsKPj4gK8KgwqDCoCBscGlfc3RhdHNf
ZXhwZWN0KC0xLCAtMSk7Cj4+ICvCoMKgwqAgaXRzX3NlbmRfaW50KGRldjIsIDIwKTsKPj4gK8Kg
wqDCoCBjaGVja19scGlfc3RhdHMoIm5vIExQSSBhZnRlciBkZXZpY2UgdW5tYXAiKTsKPj4gK8Kg
wqDCoCByZXBvcnRfcHJlZml4X3BvcCgpOwo+PiArCj4+ICvCoMKgwqAgLyogVW5tYXAgdGhlIGNv
bGxlY3Rpb24gdGhpcyB0aW1lIGFuZCBjaGVjayBubyBMUEkgZG9lcyBoaXQgKi8KPj4gK8KgwqDC
oCByZXBvcnRfcHJlZml4X3B1c2goIm1hcGMgdmFsaWQ9ZmFsc2UiKTsKPj4gK8KgwqDCoCBpdHNf
c2VuZF9tYXBjKGNvbDIsIGZhbHNlKTsKPiAKPiBBbmQgYXMgZm9yIHRoZSBNQVBDLCB0aGUgc3Bl
YyBzYXlzOgo+IAo+ICIgV2hlbiBWIGlzIDA6Cj4gQmVoYXZpb3IgaXMgdW5wcmVkaWN0YWJsZSBp
ZiB0aGVyZSBhcmUgaW50ZXJydXB0cyB0aGF0IGFyZSBtYXBwZWQgdG8gdGhlCj4gc3BlY2lmaWVk
IGNvbGxlY3Rpb24sIHdpdGggdGhlIHJlc3RyaWN0aW9uIHRoYXQgZnVydGhlciB0cmFuc2xhdGlv
bgo+IHJlcXVlc3RzIGZyb20gdGhhdCBkZXZpY2UgYXJlIGlnbm9yZWQuICIKPiAKPiBTbyB0aGlz
IGNvbGxlY3Rpb24tdW5tYXAgdGVzdCBtYXkgbm90IG1ha2Ugc2Vuc2U/Cm1ha2VzIHNlbnNlLiBS
ZW1vdmluZyBpdC4KPiAKPj4gK8KgwqDCoCBscGlfc3RhdHNfZXhwZWN0KC0xLCAtMSk7Cj4+ICvC
oMKgwqAgaXRzX3NlbmRfaW50KGRldjcsIDI1NSk7Cj4+ICvCoMKgwqAgY2hlY2tfbHBpX3N0YXRz
KCJubyBMUEkgYWZ0ZXIgY29sbGVjdGlvbiB1bm1hcCIpOwo+PiArwqDCoMKgIHJlcG9ydF9wcmVm
aXhfcG9wKCk7Cj4+ICt9Cj4gCj4gWy4uLl0KPiAKPiBPdGhlcndpc2UgbG9va3MgZ29vZC4KVGhh
bmtzIQoKRXJpYwo+IAo+IAo+IFRoYW5rcywKPiBaZW5naHVpCj4gCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
