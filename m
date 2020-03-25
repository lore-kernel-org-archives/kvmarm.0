Return-Path: <SRS0=r+CV=5K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7FBC43331
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 21:21:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B99520719
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 21:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RgPl37mm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B99520719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AD8D4A2E5;
	Wed, 25 Mar 2020 17:21:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UrYOm0nijud3; Wed, 25 Mar 2020 17:21:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63E5E4B086;
	Wed, 25 Mar 2020 17:21:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DD744A500
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 17:20:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5EeA2W-aeBHS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2020 17:20:58 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25B194A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 17:20:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585171257;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5OAiw4H8RHcYJgUDa0Alkcr13a5bPAHpwGb7bMq8gRE=;
 b=RgPl37mmOfy51RpzmAtBx2ZFtxK/fHrk21eNZDT+ydKtFwuNU88TsAkUdNIQ7N8g4HUrr9
 24/EqQSH4Va58F5hOmNMYJFnrjpR99eZjD3w/chgKEqVFHllyUg0Fv8TfK9+BrQmMLC+TH
 frwqPhcGk39FE1PzyjGqIg7o6Lir7wc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-TBF9AnAZOf6sXTlQ7Bb0AA-1; Wed, 25 Mar 2020 17:20:53 -0400
X-MC-Unique: TBF9AnAZOf6sXTlQ7Bb0AA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE36107ACCD;
 Wed, 25 Mar 2020 21:20:51 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57E20100EBAA;
 Wed, 25 Mar 2020 21:20:45 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 08/13] arm/arm64: ITS: Device and
 collection Initialization
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-9-eric.auger@redhat.com>
 <63f3d8aa-c1e3-f40f-32a1-fb6d22e70541@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c5ce7101-9ea3-8b04-7ec0-cb27dfbdc116@redhat.com>
Date: Wed, 25 Mar 2020 22:20:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <63f3d8aa-c1e3-f40f-32a1-fb6d22e70541@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

SGkgWmVuZ2h1aSwKCk9uIDMvMjUvMjAgOToxMCBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBF
cmljLAo+IAo+IE9uIDIwMjAvMy8yMCAxNzoyNCwgRXJpYyBBdWdlciB3cm90ZToKPj4gSW50cm9k
dWNlIGFuIGhlbHBlciBmdW5jdGlvbnMgdG8gcmVnaXN0ZXIKPj4gLSBhIG5ldyBkZXZpY2UsIGNo
YXJhY3Rlcml6ZWQgYnkgaXRzIGRldmljZSBpZCBhbmQgdGhlCj4+IMKgwqAgbWF4IG51bWJlciBv
ZiBldmVudCBJRHMgdGhhdCBkaW1lbnNpb24gaXRzIElUVCAoSW50ZXJydXB0Cj4+IMKgwqAgVHJh
bnNsYXRpb24gVGFibGUpLsKgIFRoZSBmdW5jdGlvbiBhbGxvY2F0ZXMgdGhlIElUVC4KPj4KPj4g
LSBhIG5ldyBjb2xsZWN0aW9uLCBjaGFyYWN0ZXJpemVkIGJ5IGl0cyBJRCBhbmQgdGhlCj4+IMKg
wqAgdGFyZ2V0IHByb2Nlc3NpbmcgZW5naW5lIChQRSkuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEVy
aWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPj4KPj4gLS0tCj4+Cj4+IHYzIC0+IHY0
Ogo+PiAtIHJlbW92ZSB1bnVzZWQgaXRzX2Jhc2VyIHZhcmlhYmxlIGZyb20gaXRzX2NyZWF0ZV9k
ZXZpY2UoKQo+PiAtIHVzZSBnZXRfb3JkZXIoKQo+PiAtIGRldmljZS0+aXR0IGJlY29tZXMgYSBH
VkEgaW5zdGVhZCBvZiBHUEEKPj4KPj4gdjIgLT4gdjM6Cj4+IC0gcy9yZXBvcnRfYWJvcnQvYXNz
ZXJ0Cj4+Cj4+IHYxIC0+IHYyOgo+PiAtIHMvbmJfL25yXwo+PiAtLS0KPj4gwqAgbGliL2FybTY0
L2FzbS9naWMtdjMtaXRzLmggfCAxOSArKysrKysrKysrKysrKysrKysrCj4+IMKgIGxpYi9hcm02
NC9naWMtdjMtaXRzLmPCoMKgwqDCoCB8IDM4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrCj4+IMKgIDIgZmlsZXMgY2hhbmdlZCwgNTcgaW5zZXJ0aW9ucygrKQo+Pgo+PiBk
aWZmIC0tZ2l0IGEvbGliL2FybTY0L2FzbS9naWMtdjMtaXRzLmggYi9saWIvYXJtNjQvYXNtL2dp
Yy12My1pdHMuaAo+PiBpbmRleCA0NjgzMDExLi5hZGNiNjQyIDEwMDY0NAo+PiAtLS0gYS9saWIv
YXJtNjQvYXNtL2dpYy12My1pdHMuaAo+PiArKysgYi9saWIvYXJtNjQvYXNtL2dpYy12My1pdHMu
aAo+PiBAQCAtMzEsNiArMzEsMTkgQEAgc3RydWN0IGl0c19iYXNlciB7Cj4+IMKgIH07Cj4+IMKg
IMKgICNkZWZpbmUgR0lUU19CQVNFUl9OUl9SRUdTwqDCoMKgwqDCoMKgwqAgOAo+PiArI2RlZmlu
ZSBHSVRTX01BWF9ERVZJQ0VTwqDCoMKgwqDCoMKgwqAgOAo+PiArI2RlZmluZSBHSVRTX01BWF9D
T0xMRUNUSU9OU8KgwqDCoMKgwqDCoMKgIDgKPj4gKwo+PiArc3RydWN0IGl0c19kZXZpY2Ugewo+
PiArwqDCoMKgIHUzMiBkZXZpY2VfaWQ7wqDCoMKgIC8qIGRldmljZSBJRCAqLwo+PiArwqDCoMKg
IHUzMiBucl9pdGVzO8KgwqDCoCAvKiBNYXggSW50ZXJydXB0IFRyYW5zbGF0aW9uIEVudHJpZXMg
Ki8KPj4gK8KgwqDCoCB2b2lkICppdHQ7wqDCoMKgIC8qIEludGVycnVwdCBUcmFuc2xhdGlvbiBU
YWJsZSBHVkEgKi8KPj4gK307Cj4+ICsKPj4gK3N0cnVjdCBpdHNfY29sbGVjdGlvbiB7Cj4+ICvC
oMKgwqAgdTY0IHRhcmdldF9hZGRyZXNzOwo+PiArwqDCoMKgIHUxNiBjb2xfaWQ7Cj4+ICt9Owo+
PiDCoCDCoCBzdHJ1Y3QgaXRzX2RhdGEgewo+PiDCoMKgwqDCoMKgIHZvaWQgKmJhc2U7Cj4+IEBA
IC0zOSw2ICs1MiwxMCBAQCBzdHJ1Y3QgaXRzX2RhdGEgewo+PiDCoMKgwqDCoMKgIHN0cnVjdCBp
dHNfYmFzZXIgY29sbF9iYXNlcjsKPj4gwqDCoMKgwqDCoCBzdHJ1Y3QgaXRzX2NtZF9ibG9jayAq
Y21kX2Jhc2U7Cj4+IMKgwqDCoMKgwqAgc3RydWN0IGl0c19jbWRfYmxvY2sgKmNtZF93cml0ZTsK
Pj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2RldmljZSBkZXZpY2VzW0dJVFNfTUFYX0RFVklDRVNdOwo+
PiArwqDCoMKgIHUzMiBucl9kZXZpY2VzO8KgwqDCoMKgwqDCoMKgIC8qIEFsbG9jYXRlZCBEZXZp
Y2VzICovCj4+ICvCoMKgwqAgc3RydWN0IGl0c19jb2xsZWN0aW9uIGNvbGxlY3Rpb25zW0dJVFNf
TUFYX0NPTExFQ1RJT05TXTsKPj4gK8KgwqDCoCB1MzIgbnJfY29sbGVjdGlvbnM7wqDCoMKgIC8q
IEFsbG9jYXRlZCBDb2xsZWN0aW9ucyAqLwo+PiDCoCB9Owo+PiDCoCDCoCBleHRlcm4gc3RydWN0
IGl0c19kYXRhIGl0c19kYXRhOwo+PiBAQCAtOTMsNSArMTEwLDcgQEAgZXh0ZXJuIHZvaWQgaXRz
X3BhcnNlX3R5cGVyKHZvaWQpOwo+PiDCoCBleHRlcm4gdm9pZCBpdHNfaW5pdCh2b2lkKTsKPj4g
wqAgZXh0ZXJuIGludCBpdHNfYmFzZXJfbG9va3VwKGludCBpLCBzdHJ1Y3QgaXRzX2Jhc2VyICpi
YXNlcik7Cj4+IMKgIGV4dGVybiB2b2lkIGl0c19lbmFibGVfZGVmYXVsdHModm9pZCk7Cj4+ICtl
eHRlcm4gc3RydWN0IGl0c19kZXZpY2UgKml0c19jcmVhdGVfZGV2aWNlKHUzMiBkZXZfaWQsIGlu
dCBucl9pdGVzKTsKPj4gK2V4dGVybiBzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gKml0c19jcmVhdGVf
Y29sbGVjdGlvbih1MzIgY29sX2lkLCB1MzIKPj4gdGFyZ2V0X3BlKTsKPiAKPiBNYXliZSB1c2Ug
J3UxNiBjb2xfaWQnPwpmYWlyIGVub3VnaC4gQXQgdGhpcyBwb2ludCwgbm90IHN1cmUgdGhpcyBp
cyB3b3J0aCBhIHJlc3BpbiB0aG91Z2ggOy0pCj4gCj4gQmVzaWRlcywKPiBSZXZpZXdlZC1ieTog
WmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+ClRoYW5rcyEKCkVyaWMKCgoKCj4gCj4g
Cj4gVGhhbmtzCj4gCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
