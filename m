Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C80C43331
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 08:51:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBF3A208E4
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 08:51:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iUssBzPf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBF3A208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2CD4B14F;
	Thu,  2 Apr 2020 04:51:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dpE8X4tCetU5; Thu,  2 Apr 2020 04:51:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEB1F4B146;
	Thu,  2 Apr 2020 04:50:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EAC54B147
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 04:50:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vYXdfJIWUZyg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 04:50:57 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 364374B144
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 04:50:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585817457;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=o2ROWoA/Q4kopE0GRuJxFR1Mdzx26gimKSY4bj8fFeY=;
 b=iUssBzPf8HpD79nFzC3HYjWJdqPMU1UNawjTWh2lyXJ94bBMAXAsyyzq9aOvpN/64cp5xd
 U7B1F/iAl+o6d8JzLV+i/R/AL6NBxgR6E1dPxlWORl3OpaeWFACHXRnRNaNAHCACKdEop2
 4bP8/CraCbTBdv8/75G1YSVoTCUlZEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-unMlZHFhMauk_GWmxdC6XA-1; Thu, 02 Apr 2020 04:50:53 -0400
X-MC-Unique: unMlZHFhMauk_GWmxdC6XA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69005800D6C;
 Thu,  2 Apr 2020 08:50:50 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A9451C933;
 Thu,  2 Apr 2020 08:50:47 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 10/13] arm/arm64: ITS: INT functional
 tests
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-11-eric.auger@redhat.com>
 <f7f1d7c4-2321-9123-2394-528af737bfa7@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <fa4e14f6-20ee-982f-0eda-74b101cddf7a@redhat.com>
Date: Thu, 2 Apr 2020 10:50:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <f7f1d7c4-2321-9123-2394-528af737bfa7@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

SGkgWmVuZ2h1aSwKCk9uIDMvMzAvMjAgMTI6NDMgUE0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDIwLzMvMjAgMTc6MjQsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+IFRyaWdn
ZXJzIExQSXMgdGhyb3VnaCB0aGUgSU5UIGNvbW1hbmQuCj4+Cj4+IHRoZSB0ZXN0IGNoZWNrcyB0
aGUgTFBJIGhpdHMgdGhlIHJpZ2h0IENQVSBhbmQgdHJpZ2dlcnMKPj4gdGhlIHJpZ2h0IExQSSBp
bnRpZCwgaWUuIHRoZSB0cmFuc2xhdGlvbiBpcyBjb3JyZWN0Lgo+Pgo+PiBVcGRhdGVzIHRvIHRo
ZSBjb25maWcgdGFibGUgYWxzbyBhcmUgdGVzdGVkLCBhbG9uZyB3aXRoIGludgo+PiBhbmQgaW52
YWxsIGNvbW1hbmRzLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2Vy
QHJlZGhhdC5jb20+Cj4gCj4gWy4uLl0KPiAKPiBTbyBJJ3ZlIHRlc3RlZCB0aGlzIHNlcmllcyBh
bmQgZm91bmQgdGhhdCB0aGUgIklOVCIgdGVzdCB3aWxsIHNvbWV0aW1lcwo+IGZhaWwuCj4gCj4g
Im5vdCBvayAxMiAtIGdpY3YzOiBpdHMtbWlncmF0aW9uOiBkZXYyL2V2ZW50aWQ9MjAgdHJpZ2dl
cnMgTFBJIDgxOTUgZW4KPiBQRSAjMyBhZnRlciBtaWdyYXRpb24KPiBub3Qgb2sgMTMgLSBnaWN2
MzogaXRzLW1pZ3JhdGlvbjogZGV2Ny9ldmVudGlkPTI1NSB0cmlnZ2VycyBMUEkgODE5NiBvbgo+
IFBFICMyIGFmdGVyIG1pZ3JhdGlvbiIKPiAKPiBGcm9tIGxvZ3M6Cj4gIklORk86IGdpY3YzOiBp
dHMtbWlncmF0aW9uOiBNaWdyYXRpb24gY29tcGxldGUKPiBJTlQgZGV2X2lkPTIgZXZlbnRfaWQ9
MjAKPiBJTkZPOiBnaWN2MzogaXRzLW1pZ3JhdGlvbjogTm8gTFBJIHJlY2VpdmVkIHdoZXJlYXMg
KGNwdWlkPTMsCj4gaW50aWQ9ODE5NSkgd2FzIGV4cGVjdGVkCj4gRkFJTDogZ2ljdjM6IGl0cy1t
aWdyYXRpb246IGRldjIvZXZlbnRpZD0yMCB0cmlnZ2VycyBMUEkgODE5NSBlbiBQRSAjMwo+IGFm
dGVyIG1pZ3JhdGlvbgo+IElOVCBkZXZfaWQ9NyBldmVudF9pZD0yNTUKPiBJTkZPOiBnaWN2Mzog
aXRzLW1pZ3JhdGlvbjogTm8gTFBJIHJlY2VpdmVkIHdoZXJlYXMgKGNwdWlkPTIsCj4gaW50aWQ9
ODE5Nikgd2FzIGV4cGVjdGVkCj4gRkFJTDogZ2ljdjM6IGl0cy1taWdyYXRpb246IGRldjcvZXZl
bnRpZD0yNTUgdHJpZ2dlcnMgTFBJIDgxOTYgb24gUEUgIzIKPiBhZnRlciBtaWdyYXRpb24iCj4g
Cj4+ICtzdGF0aWMgdm9pZCBjaGVja19scGlfc3RhdHMoY29uc3QgY2hhciAqbXNnKQo+PiArewo+
PiArwqDCoMKgIGJvb2wgcGFzcyA9IGZhbHNlOwo+PiArCj4+ICvCoMKgwqAgbWRlbGF5KDEwMCk7
Cj4gCj4gQWZ0ZXIgY2hhbmdpbmcgdGhpcyB0byAnbWRlbGF5KDEwMDApJywgdGhlIGFib3ZlIGVy
cm9yIGRvZXNuJ3Qgc2hvdyB1cAo+IGFueW1vcmUuIEJ1dCBpdCBzb3VuZHMgc3RyYW5nZSB0aGF0
IDEwMG1zIGlzIG5vdCBlbm91Z2ggdG8gZGVsaXZlciBhCj4gc2luZ2xlIExQSS4gSSBoYXZlbid0
IGRpZyBpdCBmdXJ0aGVyIGJ1dCB3aWxsIGdldCBiYWNrIGhlcmUgbGF0ZXIuCgpEaWQgeW91IGZp
bmQgc29tZSB0aW1lIHRvIGludmVzdGlnYXRlIHRoaXMgaXNzdWUuIENoYW5naW5nIDEwMCB0byAx
MDAwCmhhcyBhIGh1Z2UgaW1wYWN0IG9uIHRoZSBvdmVyYWxsIHRlc3QgZHVyYXRpb24gYW5kIEkg
ZG9uJ3QgdGhpbmsgaXQgaXMKc2Vuc2libGUuIENvdWxkIHlvdSBzZWUgd2hhdCBpcyB5b3VyIG1p
bmltYWwgdmFsdWUgdGhhdCBwYXNzIHRoZSB0ZXN0cz8KClRoYW5rcwoKRXJpYwo+IAo+PiArwqDC
oMKgIHNtcF9ybWIoKTsgLyogcGFpcnMgd2l0aCB3bWIgaW4gbHBpX2hhbmRsZXIgKi8KPj4gK8Kg
wqDCoCBpZiAobHBpX3N0YXRzLm9ic2VydmVkLmNwdV9pZCAhPSBscGlfc3RhdHMuZXhwZWN0ZWQu
Y3B1X2lkIHx8Cj4+ICvCoMKgwqDCoMKgwqDCoCBscGlfc3RhdHMub2JzZXJ2ZWQubHBpX2lkICE9
IGxwaV9zdGF0cy5leHBlY3RlZC5scGlfaWQpIHsKPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChscGlf
c3RhdHMub2JzZXJ2ZWQuY3B1X2lkID09IC0xICYmCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGxwaV9zdGF0cy5vYnNlcnZlZC5scGlfaWQgPT0gLTEpIHsKPj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmVwb3J0X2luZm8oIk5vIExQSSByZWNlaXZlZCB3aGVyZWFzIChjcHVpZD0lZCwgaW50
aWQ9JWQpICIKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJ3YXMg
ZXhwZWN0ZWQiLCBscGlfc3RhdHMuZXhwZWN0ZWQuY3B1X2lkLAo+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbHBpX3N0YXRzLmV4cGVjdGVkLmxwaV9pZCk7Cj4+ICvC
oMKgwqDCoMKgwqDCoCB9IGVsc2Ugewo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXBvcnRf
aW5mbygiVW5leHBlY3RlZCBMUEkgKGNwdWlkPSVkLCBpbnRpZD0lZCkiLAo+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbHBpX3N0YXRzLm9ic2VydmVkLmNwdV9pZCwK
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxwaV9zdGF0cy5vYnNl
cnZlZC5scGlfaWQpOwo+PiArwqDCoMKgwqDCoMKgwqAgfQo+PiArwqDCoMKgIH0gZWxzZSB7Cj4+
ICvCoMKgwqDCoMKgwqDCoCBwYXNzID0gdHJ1ZTsKPj4gK8KgwqDCoCB9Cj4+ICvCoMKgwqAgcmVw
b3J0KHBhc3MsICIlcyIsIG1zZyk7Cj4+ICt9Cj4gCj4gVGhpcyBwYXRjaCBpdHNlbGYgbG9va3Mg
Z29vZCB0byBtZSwKPiBSZXZpZXdlZC1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5j
b20+Cj4gCj4gCj4gVGhhbmtzCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
