Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4312EC3F2C6
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 09:07:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C4797208E4
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 09:07:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TnGP2ZXf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4797208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CDA14A523;
	Wed, 11 Mar 2020 05:07:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 82-M-ok6BhE8; Wed, 11 Mar 2020 05:07:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BF8F4A524;
	Wed, 11 Mar 2020 05:07:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 097934A524
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 05:07:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xYbqzI-qgfwh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 05:07:47 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFAB44A523
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 05:07:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583917666;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=90odkQRcEuNdf2jJohXDHYVWT8ef6QX7pd7255D7wy8=;
 b=TnGP2ZXfjzr1nlUoJqDjjnJLvT01j6ascktvdZEemzBTP/TY46HCS9WMUYLGYTo+IBIWLc
 uOxzLsKZvXwXzdehxSXdnCwUb/+oIzYsWq8j2iTbCkmqORydCLvgzsQ038TICegwWDk5TH
 XSxzojUzJwEZBscCJ1U5kik7H8vbf9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-isU5ogb3Pq-TV_LPOEpLBQ-1; Wed, 11 Mar 2020 05:07:42 -0400
X-MC-Unique: isU5ogb3Pq-TV_LPOEpLBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9F86107ACC4;
 Wed, 11 Mar 2020 09:07:40 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 695545D9C9;
 Wed, 11 Mar 2020 09:07:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 05/13] arm/arm64: gicv3: Set the LPI
 config and pending tables
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-6-eric.auger@redhat.com>
 <cd3bab7d-a585-b091-621c-0ae712b82b3c@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <97357581-9712-b467-764c-d32f354b6f3c@redhat.com>
Date: Wed, 11 Mar 2020 10:07:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <cd3bab7d-a585-b091-621c-0ae712b82b3c@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

SGkgWmVuZ2h1aSwKCk9uIDMvMTEvMjAgNzo0MiBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBF
cmljLAo+IAo+IE9uIDIwMjAvMy8xMCAyMjo1NCwgRXJpYyBBdWdlciB3cm90ZToKPj4gQWxsb2Nh
dGUgdGhlIExQSSBjb25maWd1cmF0aW9uIGFuZCBwZXIgcmUtZGlzdHJpYnV0b3IgcGVuZGluZyB0
YWJsZS4KPj4gU2V0IHJlZGlzdHJpYnV0b3IncyBQUk9QQkFTRVIgYW5kIFBFTkRCQVNFUi4gVGhl
IExQSXMgYXJlIGVuYWJsZWQKPj4gYnkgZGVmYXVsdCBpbiB0aGUgY29uZmlnIHRhYmxlLgo+Pgo+
PiBBbHNvIGludHJvZHVjZSBhIGhlbHBlciByb3V0aW5lIHRoYXQgYWxsb3dzIHRvIHNldCB0aGUg
cGVuZGluZyB0YWJsZQo+PiBiaXQgZm9yIGEgZ2l2ZW4gTFBJLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5
OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+Cj4+IC0tLQo+Pgo+PiB2NCAt
PiB2NToKPj4gLSBNb3ZlZCBzb21lIHJlZm9ybWF0dGluZ3MgcHJldmlvdXNseSBkb25lIGluCj4+
IMKgwqAgImFybS9hcm02NDogSVRTOiBpdHNfZW5hYmxlX2RlZmF1bHRzIiwgaW4gdGhpcyBwYXRj
aAo+PiAtIGFkZGVkIGFzc2VydCghZ2ljdjNfcmVkaXN0X2Jhc2UoKSkgaW4gZ2ljdjNfbHBpX2Fs
bG9jX3RhYmxlcygpCj4+IC0gcmV2ZXJ0IGZvcl9lYWNoX3ByZXNlbnRfY3B1KCkgY2hhbmdlCj4+
Cj4+IHYyIC0+IHYzOgo+PiAtIE1vdmUgdGhlIGhlbHBlcnMgaW4gbGliL2FybS9naWMtdjMuYyBh
bmQgcHJlZml4IHRoZW0gd2l0aCAiZ2ljdjNfIgo+PiDCoMKgIGFuZCBhZGQgX2xwaSBwcmVmaXgg
dG9vCj4+Cj4+IHYxIC0+IHYyOgo+PiAtIHJlbW92ZSBtZW1vcnkgYXR0cmlidXRlcwo+PiAtLS0K
Pj4gwqAgbGliL2FybS9hc20vZ2ljLXYzLmggfCAxNSArKysrKysrKysrKysrCj4+IMKgIGxpYi9h
cm0vZ2ljLXYzLmPCoMKgwqDCoCB8IDUzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrCj4+IMKgIDIgZmlsZXMgY2hhbmdlZCwgNjggaW5zZXJ0aW9ucygrKQo+Pgo+
PiBkaWZmIC0tZ2l0IGEvbGliL2FybS9hc20vZ2ljLXYzLmggYi9saWIvYXJtL2FzbS9naWMtdjMu
aAo+PiBpbmRleCA0N2RmMDUxLi4wNjRjYzY4IDEwMDY0NAo+PiAtLS0gYS9saWIvYXJtL2FzbS9n
aWMtdjMuaAo+PiArKysgYi9saWIvYXJtL2FzbS9naWMtdjMuaAo+PiBAQCAtNTAsNiArNTAsMTUg
QEAKPj4gwqAgI2RlZmluZSBNUElEUl9UT19TR0lfQUZGSU5JVFkoY2x1c3Rlcl9pZCwgbGV2ZWwp
IFwKPj4gwqDCoMKgwqDCoCAoTVBJRFJfQUZGSU5JVFlfTEVWRUwoY2x1c3Rlcl9pZCwgbGV2ZWwp
IDw8Cj4+IElDQ19TR0kxUl9BRkZJTklUWV8jIyBsZXZlbCAjIyBfU0hJRlQpCj4+IMKgICsjZGVm
aW5lIEdJQ1JfUFJPUEJBU0VSX0lEQklUU19NQVNLwqDCoMKgICgweDFmKQo+IAo+IEFnYWluIHRo
aXMgY2FuIGJlIGRyb3BwZWQsIGJ1dCBub3QgYSBwcm9ibGVtLgpPSwo+IAo+PiArCj4+ICsjZGVm
aW5lIEdJQ1JfUEVOREJBU0VSX1BUWsKgwqDCoMKgwqDCoMKgIEJJVF9VTEwoNjIpCj4+ICsKPj4g
KyNkZWZpbmUgTFBJX1BST1BfR1JPVVAxwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoMSA8PCAxKQo+
PiArI2RlZmluZSBMUElfUFJPUF9FTkFCTEVEwqDCoMKgwqDCoMKgwqAgKDEgPDwgMCkKPj4gKyNk
ZWZpbmUgTFBJX1BST1BfREVGQVVMVF9QUklPwqDCoMKgwqDCoMKgwqAgMHhhMAo+PiArI2RlZmlu
ZSBMUElfUFJPUF9ERUZBVUxUwqDCoMKgwqDCoMKgwqAgKExQSV9QUk9QX0RFRkFVTFRfUFJJTyB8
Cj4+IExQSV9QUk9QX0dST1VQMSB8IExQSV9QUk9QX0VOQUJMRUQpCj4+ICsKPj4gwqAgI2luY2x1
ZGUgPGFzbS9hcmNoX2dpY3YzLmg+Cj4+IMKgIMKgICNpZm5kZWYgX19BU1NFTUJMWV9fCj4+IEBA
IC02Niw2ICs3NSw4IEBAIHN0cnVjdCBnaWN2M19kYXRhIHsKPj4gwqDCoMKgwqDCoCB2b2lkICpk
aXN0X2Jhc2U7Cj4+IMKgwqDCoMKgwqAgdm9pZCAqcmVkaXN0X2Jhc2VzW0dJQ1YzX05SX1JFRElT
VFNdOwo+PiDCoMKgwqDCoMKgIHZvaWQgKnJlZGlzdF9iYXNlW05SX0NQVVNdOwo+PiArwqDCoMKg
IHU4ICpscGlfcHJvcDsKPj4gK8KgwqDCoCB2b2lkICpscGlfcGVuZFtOUl9DUFVTXTsKPj4gwqDC
oMKgwqDCoCB1bnNpZ25lZCBpbnQgaXJxX25yOwo+PiDCoCB9Owo+PiDCoCBleHRlcm4gc3RydWN0
IGdpY3YzX2RhdGEgZ2ljdjNfZGF0YTsKPj4gQEAgLTgyLDYgKzkzLDEwIEBAIGV4dGVybiB2b2lk
IGdpY3YzX3dyaXRlX2VvaXIodTMyIGlycXN0YXQpOwo+PiDCoCBleHRlcm4gdm9pZCBnaWN2M19p
cGlfc2VuZF9zaW5nbGUoaW50IGlycSwgaW50IGNwdSk7Cj4+IMKgIGV4dGVybiB2b2lkIGdpY3Yz
X2lwaV9zZW5kX21hc2soaW50IGlycSwgY29uc3QgY3B1bWFza190ICpkZXN0KTsKPj4gwqAgZXh0
ZXJuIHZvaWQgZ2ljdjNfc2V0X3JlZGlzdF9iYXNlKHNpemVfdCBzdHJpZGUpOwo+PiArZXh0ZXJu
IHZvaWQgZ2ljdjNfbHBpX3NldF9jb25maWcoaW50IG4sIHU4IHZhbCk7Cj4+ICtleHRlcm4gdTgg
Z2ljdjNfbHBpX2dldF9jb25maWcoaW50IG4pOwo+IAo+IFRoZXNlIHR3byBkZWNsYXJhdGlvbnMg
Y2FuIGJlIGRyb3BwZWQsIGFuZCBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvCj4gbW92ZSB0aGVpciBt
YWNybyBpbXBsZW1lbnRhdGlvbnMgaGVyZSAodGhleSdyZSBub3cgaW4gcGF0Y2ggIzcpLgo+IEJ1
dCBhbHNvIG5vdCBhIHByb2JsZW0uCk9LCj4gCj4+ICtleHRlcm4gdm9pZCBnaWN2M19scGlfc2V0
X2Nscl9wZW5kaW5nKGludCByZGlzdCwgaW50IG4sIGJvb2wgc2V0KTsKPj4gK2V4dGVybiB2b2lk
IGdpY3YzX2xwaV9hbGxvY190YWJsZXModm9pZCk7Cj4+IMKgIMKgIHN0YXRpYyBpbmxpbmUgdm9p
ZCBnaWN2M19kb193YWl0X2Zvcl9yd3Aodm9pZCAqYmFzZSkKPj4gwqAgewo+PiBkaWZmIC0tZ2l0
IGEvbGliL2FybS9naWMtdjMuYyBiL2xpYi9hcm0vZ2ljLXYzLmMKPj4gaW5kZXggZmVlY2I1ZS4u
ZDc1MmJkNCAxMDA2NDQKPj4gLS0tIGEvbGliL2FybS9naWMtdjMuYwo+PiArKysgYi9saWIvYXJt
L2dpYy12My5jCj4+IEBAIC01LDYgKzUsNyBAQAo+PiDCoMKgICovCj4+IMKgICNpbmNsdWRlIDxh
c20vZ2ljLmg+Cj4+IMKgICNpbmNsdWRlIDxhc20vaW8uaD4KPj4gKyNpbmNsdWRlIDxhbGxvY19w
YWdlLmg+Cj4+IMKgIMKgIHZvaWQgZ2ljdjNfc2V0X3JlZGlzdF9iYXNlKHNpemVfdCBzdHJpZGUp
Cj4+IMKgIHsKPj4gQEAgLTE0NywzICsxNDgsNTUgQEAgdm9pZCBnaWN2M19pcGlfc2VuZF9zaW5n
bGUoaW50IGlycSwgaW50IGNwdSkKPj4gwqDCoMKgwqDCoCBjcHVtYXNrX3NldF9jcHUoY3B1LCAm
ZGVzdCk7Cj4+IMKgwqDCoMKgwqAgZ2ljdjNfaXBpX3NlbmRfbWFzayhpcnEsICZkZXN0KTsKPj4g
wqAgfQo+PiArCj4+ICsjaWYgZGVmaW5lZChfX2FhcmNoNjRfXykKPj4gKwo+PiArLyoKPj4gKyAq
IGFsbG9jX2xwaV90YWJsZXMgLSBBbGxvY2F0ZSBMUEkgY29uZmlnIGFuZCBwZW5kaW5nIHRhYmxl
cwo+PiArICogYW5kIHNldCBQUk9QQkFTRVIgKHNoYXJlZCBieSBhbGwgcmRpc3RyaWJ1dG9ycykg
YW5kIHBlcgo+PiArICogcmVkaXN0cmlidXRvciBQRU5EQkFTRVIuCj4+ICsgKgo+PiArICogZ2lj
djNfc2V0X3JlZGlzdF9iYXNlKCkgbXVzdCBiZSBjYWxsZWQgYmVmb3JlCj4+ICsgKi8KPj4gK3Zv
aWQgZ2ljdjNfbHBpX2FsbG9jX3RhYmxlcyh2b2lkKQo+PiArewo+PiArwqDCoMKgIHVuc2lnbmVk
IGxvbmcgbiA9IFNaXzY0SyA+PiBQQUdFX1NISUZUOwo+PiArwqDCoMKgIHVuc2lnbmVkIGxvbmcg
b3JkZXIgPSBmbHMobik7Cj4+ICvCoMKgwqAgdTY0IHByb3BfdmFsOwo+PiArwqDCoMKgIGludCBj
cHU7Cj4+ICsKPj4gK8KgwqDCoCBhc3NlcnQoIWdpY3YzX3JlZGlzdF9iYXNlKCkpOwo+IAo+IEkg
Z3Vlc3MgeW91IHdhbnRlZCBhc3NlcnQoZ2ljdjNfcmVkaXN0X2Jhc2UoKSk/IFdpdGggdGhpcyBj
b25maXJtZWQsCmRhbW4sIGEgbGFzdCBtaW51dGUgY2hhbmdlIEkgbXVzdCBoYXZlIGZhaWxlZCB0
byB0ZXN0PyEgSW5kZWVkIHlvdSdyZSByaWdodC4KPiAKPiBSZXZpZXdlZC1ieTogWmVuZ2h1aSBZ
dSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+ClRoYW5rcyEKCj4gCj4gCj4gVGhhbmtzCj4gCj4+ICsK
Pj4gK8KgwqDCoCBnaWN2M19kYXRhLmxwaV9wcm9wID0gYWxsb2NfcGFnZXMob3JkZXIpOwo+PiAr
Cj4+ICvCoMKgwqAgLyogSUQgYml0cyA9IDEzLCBpZS4gdXAgdG8gMTRiIExQSSBJTlRJRCAqLwo+
PiArwqDCoMKgIHByb3BfdmFsID0gKHU2NCkodmlydF90b19waHlzKGdpY3YzX2RhdGEubHBpX3By
b3ApKSB8IDEzOwo+PiArCj4+ICvCoMKgwqAgZm9yX2VhY2hfcHJlc2VudF9jcHUoY3B1KSB7Cj4+
ICvCoMKgwqDCoMKgwqDCoCB1NjQgcGVuZF92YWw7Cj4+ICvCoMKgwqDCoMKgwqDCoCB2b2lkICpw
dHI7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIHB0ciA9IGdpY3YzX2RhdGEucmVkaXN0X2Jhc2Vb
Y3B1XTsKPj4gKwo+PiArwqDCoMKgwqDCoMKgwqAgd3JpdGVxKHByb3BfdmFsLCBwdHIgKyBHSUNS
X1BST1BCQVNFUik7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIGdpY3YzX2RhdGEubHBpX3BlbmRb
Y3B1XSA9IGFsbG9jX3BhZ2VzKG9yZGVyKTsKPj4gK8KgwqDCoMKgwqDCoMKgIHBlbmRfdmFsID0g
KHU2NCkodmlydF90b19waHlzKGdpY3YzX2RhdGEubHBpX3BlbmRbY3B1XSkpOwo+PiArwqDCoMKg
wqDCoMKgwqAgd3JpdGVxKHBlbmRfdmFsLCBwdHIgKyBHSUNSX1BFTkRCQVNFUik7Cj4+ICvCoMKg
wqAgfQo+PiArfQo+PiArCj4+ICt2b2lkIGdpY3YzX2xwaV9zZXRfY2xyX3BlbmRpbmcoaW50IHJk
aXN0LCBpbnQgbiwgYm9vbCBzZXQpCj4+ICt7Cj4+ICvCoMKgwqAgdTggKnB0ciA9IGdpY3YzX2Rh
dGEubHBpX3BlbmRbcmRpc3RdOwo+PiArwqDCoMKgIHU4IG1hc2sgPSAxIDw8IChuICUgOCksIGJ5
dGU7Cj4+ICsKPj4gK8KgwqDCoCBwdHIgKz0gKG4gLyA4KTsKPj4gK8KgwqDCoCBieXRlID0gKnB0
cjsKPj4gK8KgwqDCoCBpZiAoc2V0KQo+PiArwqDCoMKgwqDCoMKgwqAgYnl0ZSB8PcKgIG1hc2s7
Cj4+ICvCoMKgwqAgZWxzZQo+PiArwqDCoMKgwqDCoMKgwqAgYnl0ZSAmPSB+bWFzazsKPj4gK8Kg
wqDCoCAqcHRyID0gYnl0ZTsKPj4gK30KPj4gKyNlbmRpZiAvKiBfX2FhcmNoNjRfXyAqLwo+Pgo+
IAo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
