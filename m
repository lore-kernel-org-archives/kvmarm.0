Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD90C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:26:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62E0320691
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62E0320691
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B23044B237;
	Fri, 15 Jan 2021 12:26:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q8uktxBA+2ym; Fri, 15 Jan 2021 12:26:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A9B4B239;
	Fri, 15 Jan 2021 12:26:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C96684B237
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:26:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DGIcBscdxZ1N for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:26:43 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D054D4B22B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:26:43 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610731603;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VZBYusZAm1Is9olrKmtKLjdUp43A00Oaux7ATOrc+IQ=;
 b=JJAEUe/fl1DgB+E9EYgrxFZjC/JJR6FG86kv8rKudF91L7GmY7xdzhmJiDgQH9e5e1uhQy
 3u0VJp3EPPcVfmCEHRUkcu0ch7utKD8iDghzhJHsq2Ws4mAYY5bt3BHklYsdwRcWO+rh3a
 61kP71k5J7cmi4afCw5PsagJmZkYKbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Ah3VMAcvN4SiSGyadioQJQ-1; Fri, 15 Jan 2021 12:26:39 -0500
X-MC-Unique: Ah3VMAcvN4SiSGyadioQJQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC233107ACF9;
 Fri, 15 Jan 2021 17:26:37 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 37E01100AE30;
 Fri, 15 Jan 2021 17:26:34 +0000 (UTC)
Subject: Re: [PATCH 6/6] KVM: arm64: Upgrade PMU support to ARMv8.4
To: Marc Zyngier <maz@kernel.org>
References: <20210114105633.2558739-1-maz@kernel.org>
 <20210114105633.2558739-7-maz@kernel.org>
 <ec06055b-56ad-1589-7a5d-95d9f47466ce@redhat.com>
 <28dab4367d6ced5a7d7cbc80ee77f68d@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a0f7a8a7-81fc-282c-5b29-b037a425a8f7@redhat.com>
Date: Fri, 15 Jan 2021 18:26:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <28dab4367d6ced5a7d7cbc80ee77f68d@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCk9uIDEvMTUvMjEgNTo0MiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIEVy
aWMsCj4gCj4gT24gMjAyMS0wMS0xNSAxNDowMSwgQXVnZXIgRXJpYyB3cm90ZToKPj4gSGkgTWFy
YywKPj4KPj4gT24gMS8xNC8yMSAxMTo1NiBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gVXBn
cmFkaW5nIHRoZSBQTVUgY29kZSBmcm9tIEFSTXY4LjEgdG8gQVJNdjguNCB0dXJucyBvdXQgdG8g
YmUKPj4+IHByZXR0eSBlYXN5LiBBbGwgdGhhdCBpcyByZXF1aXJlZCBpcyBzdXBwb3J0IGZvciBQ
TU1JUl9FTDEsIHdoaWNoCj4+PiBpcyByZWFkLW9ubHksIGFuZCBmb3Igd2hpY2ggcmV0dXJuaW5n
IDAgaXMgYSB2YWxpZCBvcHRpb24uCj4+Pgo+Pj4gTGV0J3MganVzdCBkbyB0aGF0IGFuZCBhZGp1
c3Qgd2hhdCB3ZSByZXR1cm4gdG8gdGhlIGd1ZXN0Lgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IE1h
cmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4+PiAtLS0KPj4+IMKgYXJjaC9hcm02NC9rdm0v
c3lzX3JlZ3MuYyB8IDUgKysrLS0KPj4+IMKgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vc3lz
X3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPj4+IGluZGV4IDhmNzllYzFmZmZh
Ny4uMmY0ZWNiZDJhYmZiIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3Mu
Ywo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gQEAgLTEwNTEsMTAgKzEw
NTEsMTAgQEAgc3RhdGljIHU2NCByZWFkX2lkX3JlZyhjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUKPj4+
ICp2Y3B1LAo+Pj4gwqDCoMKgwqDCoMKgwqDCoCAvKiBMaW1pdCBkZWJ1ZyB0byBBUk12OC4wICov
Cj4+PiDCoMKgwqDCoMKgwqDCoMKgIHZhbCAmPSB+RkVBVFVSRShJRF9BQTY0REZSMF9ERUJVR1ZF
Uik7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgIHZhbCB8PSBGSUVMRF9QUkVQKEZFQVRVUkUoSURfQUE2
NERGUjBfREVCVUdWRVIpLCA2KTsKPj4+IC3CoMKgwqDCoMKgwqDCoCAvKiBMaW1pdCBndWVzdHMg
dG8gUE1VdjMgZm9yIEFSTXY4LjEgKi8KPj4+ICvCoMKgwqDCoMKgwqDCoCAvKiBMaW1pdCBndWVz
dHMgdG8gUE1VdjMgZm9yIEFSTXY4LjQgKi8KPj4+IMKgwqDCoMKgwqDCoMKgwqAgdmFsID0gY3B1
aWRfZmVhdHVyZV9jYXBfcGVyZm1vbl9maWVsZCh2YWwsCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSURfQUE2NERGUjBfUE1V
VkVSX1NISUZULAo+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAga3ZtX3ZjcHVfaGFzX3BtdSh2Y3B1KSA/Cj4+PiBJRF9BQTY0REZS
MF9QTVVWRVJfOF8xIDogMCk7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fdmNwdV9oYXNfcG11KHZjcHUpID8KPj4+IElE
X0FBNjRERlIwX1BNVVZFUl84XzQgOiAwKTsKPj4+IMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+
PiDCoMKgwqDCoCBjYXNlIFNZU19JRF9ERlIwX0VMMToKPj4+IMKgwqDCoMKgwqDCoMKgwqAgLyog
TGltaXQgZ3Vlc3RzIHRvIFBNVXYzIGZvciBBUk12OC4xICovCj4+IHdoYXQgYWJvdXQgdGhlIGRl
YnVnIHZlcnNpb24gaW4gYWFyY2gzMiBzdGF0ZS4gSXMgaXQgb24gcHVycG9zZSB0aGF0IHlvdQo+
PiBsZWF2ZSBpdCBhcyA4XzE/Cj4gCj4gVGhhdCdzIGEgZ29vZCBwb2ludC4gVGhlcmUgaXMgYWxz
byB0aGUgZmFjdCB0aGF0IHdlIGtlZXAgcmVwb3J0aW5nCj4gU1RBTExfU0xPVCBhcyBhIHZhbGlk
IGV2ZW50IGV2ZW4gaW4gUE1DRUlEMF9FTDEgZGVzcGl0ZSBQTU1JUl9FTDEuU0xPVFMKPiBhbHdh
eXMgcmVwb3J0aW5nIDAuCkh1bSBPSy4gSSBkaWQgbm90IG5vdGljZSB0aGF0IDstKQoKVGhhbmtz
CgpFcmljCj4gCj4gSSdsbCBmaXggdGhhdCBhbmQgcmVzZW5kIHNvbWV0aGluZyBuZXh0IHdlZWsu
Cj4gCj4gVGhhbmtzLAo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
