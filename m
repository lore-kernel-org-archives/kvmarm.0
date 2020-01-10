Return-Path: <SRS0=Qg2m=27=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A75EC282DD
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 14:20:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA52020721
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 14:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D6t0HQBP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA52020721
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4000F4B189;
	Fri, 10 Jan 2020 09:20:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pf+FudDVaVzr; Fri, 10 Jan 2020 09:19:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 395804B162;
	Fri, 10 Jan 2020 09:19:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D264B162
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 09:19:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KiYWA7YpwdUj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jan 2020 09:19:56 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E31434B161
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 09:19:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578665996;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=aTffNF/e15nm3FHxlKhe7evWawGZzCWvldzrhkLBOYg=;
 b=D6t0HQBP3XIyq41ub+I5mfc59H00ppRP5UUe881sLpPQUxqiQvUV4L754jYSlwlsWSlc7M
 uP+WBFEGEOye8itZvr1RjXSe9QDLDHdY8cBhDz9wywp0Z1xsjZWnV43JXrPy6OlMrVg1Vi
 Bf02X81uTillfkZSprP2IHrDYJSWbIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-s_H5Abn8MCObOiPxEvmLCQ-1; Fri, 10 Jan 2020 09:19:53 -0500
X-MC-Unique: s_H5Abn8MCObOiPxEvmLCQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44D2E108ADA8;
 Fri, 10 Jan 2020 14:19:51 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3360B86CA0;
 Fri, 10 Jan 2020 14:19:48 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 08/16] arm/arm64: ITS: Init the command
 queue
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-9-eric.auger@redhat.com>
 <37c8b078-900b-a474-04a0-0273c3a32aed@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <006eb558-8108-ae6e-8fe3-9ae2f1b725c3@redhat.com>
Date: Fri, 10 Jan 2020 15:19:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <37c8b078-900b-a474-04a0-0273c3a32aed@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

SGkgWmVuZ2h1aSwKCk9uIDEyLzIwLzE5IDg6MTAgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDE5LzEyLzE2IDIyOjAyLCBFcmljIEF1Z2VyIHdyb3RlOgo+PiBBbGxv
Y2F0ZSB0aGUgY29tbWFuZCBxdWV1ZSBhbmQgaW5pdGlhbGl6ZSByZWxhdGVkIHJlZ2lzdGVyczoK
Pj4gQ0JBU0VSLCBDUkVBRFIsIENXUklURVIuCj4+Cj4+IFRoZSBjb21tYW5kIHF1ZXVlIGlzIDY0
a0IuIFRoaXMgYWltcyBhdCBub3QgYm90aGluZyB3aXRoIGZ1bGxuZXNzLgo+Pgo+PiBTaWduZWQt
b2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+IC0tLQo+PiDCoCBs
aWIvYXJtL2FzbS9naWMtdjMtaXRzLmggfMKgIDcgKysrKysrKwo+PiDCoCBsaWIvYXJtL2dpYy12
My1pdHMuY8KgwqDCoMKgIHwgMzcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kwo+PiDCoCAyIGZpbGVzIGNoYW5nZWQsIDQ0IGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdp
dCBhL2xpYi9hcm0vYXNtL2dpYy12My1pdHMuaCBiL2xpYi9hcm0vYXNtL2dpYy12My1pdHMuaAo+
PiBpbmRleCAwZDExYWVkLi5lZDQyNzA3IDEwMDY0NAo+PiAtLS0gYS9saWIvYXJtL2FzbS9naWMt
djMtaXRzLmgKPj4gKysrIGIvbGliL2FybS9hc20vZ2ljLXYzLWl0cy5oCj4+IEBAIC0xMTMsMTAg
KzExMywxNyBAQCBzdHJ1Y3QgaXRzX2Jhc2VyIHsKPj4gwqDCoMKgwqDCoCBpbnQgZXN6Owo+PiDC
oCB9Owo+PiDCoCArc3RydWN0IGl0c19jbWRfYmxvY2sgewo+PiArwqDCoMKgIHU2NMKgwqDCoMKg
IHJhd19jbWRbNF07Cj4+ICt9Owo+PiArCj4+IMKgIHN0cnVjdCBpdHNfZGF0YSB7Cj4+IMKgwqDC
oMKgwqAgdm9pZCAqYmFzZTsKPj4gwqDCoMKgwqDCoCBzdHJ1Y3QgaXRzX3R5cGVyIHR5cGVyOwo+
PiDCoMKgwqDCoMKgIHN0cnVjdCBpdHNfYmFzZXIgYmFzZXJbR0lUU19CQVNFUl9OUl9SRUdTXTsK
Pj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2NtZF9ibG9jayAqY21kX2Jhc2U7Cj4+ICvCoMKgwqAgc3Ry
dWN0IGl0c19jbWRfYmxvY2sgKmNtZF93cml0ZTsKPj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2NtZF9i
bG9jayAqY21kX3JlYWRyOwo+IAo+IEkgdGhpbmsgd2UgY2FuIGp1c3QgZ2V0IHJpZCBvZiB0aGUg
J2NtZF9yZWFkcicuIEFzIEdJVFNfQ1JFQURSIGlzCj4gZ2VuZXJhbGx5IG1hbmlwdWxhdGVkIGJ5
IHRoZSBJVFMsIGFuZCAuLi4KPiAKPj4gwqAgfTsKPj4gwqAgwqAgZXh0ZXJuIHN0cnVjdCBpdHNf
ZGF0YSBpdHNfZGF0YTsKPj4gZGlmZiAtLWdpdCBhL2xpYi9hcm0vZ2ljLXYzLWl0cy5jIGIvbGli
L2FybS9naWMtdjMtaXRzLmMKPj4gaW5kZXggMGI1YTcwMC4uOGI2YTA5NSAxMDA2NDQKPj4gLS0t
IGEvbGliL2FybS9naWMtdjMtaXRzLmMKPj4gKysrIGIvbGliL2FybS9naWMtdjMtaXRzLmMKPj4g
QEAgLTE4OCwzICsxODgsNDAgQEAgdm9pZCBzZXRfcGVuZGluZ190YWJsZV9iaXQoaW50IHJkaXN0
LCBpbnQgbiwgYm9vbAo+PiBzZXQpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBieXRlICY9IH5tYXNr
Owo+PiDCoMKgwqDCoMKgICpwdHIgPSBieXRlOwo+PiDCoCB9Cj4+ICsKPj4gKy8qKgo+PiArICog
aW5pdF9jbWRfcXVldWU6IEFsbG9jYXRlIHRoZSBjb21tYW5kIHF1ZXVlIGFuZCBpbml0aWFsaXpl
Cj4+ICsgKiBDQkFTRVIsIENSRUFEUiwgQ1dSSVRFUgo+PiArICovCj4+ICt2b2lkIGluaXRfY21k
X3F1ZXVlKHZvaWQpOwo+PiArdm9pZCBpbml0X2NtZF9xdWV1ZSh2b2lkKQo+PiArewo+PiArwqDC
oMKgIHVuc2lnbmVkIGxvbmcgbiA9IFNaXzY0SyA+PiBQQUdFX1NISUZUOwo+PiArwqDCoMKgIHVu
c2lnbmVkIGxvbmcgb3JkZXIgPSBmbHMobik7Cj4+ICvCoMKgwqAgdTY0IGNiYXNlciwgdG1wOwo+
PiArCj4+ICvCoMKgwqAgaXRzX2RhdGEuY21kX2Jhc2UgPSAodm9pZCAqKXZpcnRfdG9fcGh5cyhh
bGxvY19wYWdlcyhvcmRlcikpOwo+PiArCj4+ICvCoMKgwqAgY2Jhc2VyID0gKCh1NjQpaXRzX2Rh
dGEuY21kX2Jhc2XCoMKgwqAgfAo+PiArwqDCoMKgwqDCoMKgwqDCoCBHSVRTX0NCQVNFUl9XYVdi
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8Cj4+ICvCoMKgwqDCoMKgwqDCoMKgIEdJVFNf
Q0JBU0VSX0lubmVyU2hhcmVhYmxlwqDCoMKgwqAgfAo+PiArwqDCoMKgwqDCoMKgwqDCoCAoU1pf
NjRLIC8gU1pfNEsgLSAxKSB8Cj4+ICvCoMKgwqDCoMKgwqDCoMKgIEdJVFNfQ0JBU0VSX1ZBTElE
KTsKPj4gKwo+PiArwqDCoMKgIHdyaXRlcShjYmFzZXIsIGl0c19kYXRhLmJhc2UgKyBHSVRTX0NC
QVNFUik7Cj4gCj4gLi4uIihDUkVBRFIpIGlzIGNsZWFyZWQgdG8gMCB3aGVuIGEgdmFsdWUgaXMg
d3JpdHRlbiB0byBHSVRTX0NCQVNFUi4iCj4gLS0gZnJvbSBJSEkwMDY5RSA5LjE5LjMKPiAKPj4g
K8KgwqDCoCB0bXAgPSByZWFkcShpdHNfZGF0YS5iYXNlICsgR0lUU19DQkFTRVIpOwo+PiArCj4+
ICvCoMKgwqAgaWYgKCh0bXAgXiBjYmFzZXIpICYgR0lUU19DQkFTRVJfU0hBUkVBQklMSVRZX01B
U0spIHsKPj4gK8KgwqDCoMKgwqDCoMKgIGlmICghKHRtcCAmIEdJVFNfQ0JBU0VSX1NIQVJFQUJJ
TElUWV9NQVNLKSkgewo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjYmFzZXIgJj0gfihHSVRT
X0NCQVNFUl9TSEFSRUFCSUxJVFlfTUFTSyB8Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgR0lUU19DQkFTRVJfQ0FDSEVBQklMSVRZX01BU0spOwo+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBjYmFzZXIgfD0gR0lUU19DQkFTRVJfbkM7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHdyaXRlcShjYmFzZXIsIGl0c19kYXRhLmJhc2UgKyBHSVRTX0NCQVNFUik7Cj4+ICvCoMKg
wqDCoMKgwqDCoCB9Cj4+ICvCoMKgwqAgfQo+PiArCj4+ICvCoMKgwqAgaXRzX2RhdGEuY21kX3dy
aXRlID0gaXRzX2RhdGEuY21kX2Jhc2U7Cj4+ICvCoMKgwqAgaXRzX2RhdGEuY21kX3JlYWRyID0g
aXRzX2RhdGEuY21kX2Jhc2U7Cj4+ICvCoMKgwqAgd3JpdGVxKDAsIGl0c19kYXRhLmJhc2UgKyBH
SVRTX0NXUklURVIpOwo+PiArwqDCoMKgIHdyaXRlcSgwLCBpdHNfZGF0YS5iYXNlICsgR0lUU19D
UkVBRFIpOwo+IAo+IFNvIHRoaXMgd3JpdGVxKCkgaXMgYWxzbyBub3QgbmVlZGVkLgo+IAo+IE9y
IEkndmUganVzdCBtaXNzZWQgdGhlIHBvaW50IHRoYXQgdGhpcyBpcyBkb25lIGJ5IGludGVudGlv
biB0byB0ZXN0Cj4gIndoZXRoZXIgdGhlIEdJVFNfQ1JFQURSIGltcGxlbWVudGVkIGJ5IEtWTSBp
cyBXcml0ZSBJZ25vcmVkIj8KPiBJZiBzbywgcGxlYXNlIGlnbm9yZSBhbGwgb2YgdGhlIGNvbW1l
bnRzIGFib3ZlIDopCk5vIEkgbXVzdCBhZG1pdCB0aGlzIHdhcyBub3QgZG9uZSBvbiBwdXJwb3Nl
LiBJIGNhbiByZW1vdmUgaXQgZnJvbSB0aGUKaXRzX2RhdGEgc3RydWN0IGF0IHRoZSBtb21lbnQu
CgpUaGFua3MKCkVyaWMKPiAKPiAKPiBUaGFua3MsCj4gWmVuZ2h1aQo+IAoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
