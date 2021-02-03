Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A09C433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 11:07:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 15F6264F65
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 11:07:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15F6264F65
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DD04B099;
	Wed,  3 Feb 2021 06:07:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ikws9TLDCWHr; Wed,  3 Feb 2021 06:07:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FFFD4B1DD;
	Wed,  3 Feb 2021 06:07:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96D274B08E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 06:07:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1U8-cd34cp-c for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 06:07:35 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 867164B099
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 06:07:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612350455;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tbIs2ha3E3bGnI/gxCcwneEZZZ2B4YsJYOjXcFIFvvM=;
 b=AeKDIjgbWndcQAyNvvWnlO23uifBxU0LkTHuLTN/CHA+kbFehKt789cjSA6kpJJYKCPqZL
 PCvnX2kRwvp6/q87fyMLaDtyJgMB4fUupommTDWh1uuwxiS9nnHWcv18LeY0D2FlLEL2GM
 iQcEee1qBClIXEbtkFy1Vqjpas332oY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-ATRE8pVaP4S4zNh4TJrLqA-1; Wed, 03 Feb 2021 06:07:24 -0500
X-MC-Unique: ATRE8pVaP4S4zNh4TJrLqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 791AE1015C81;
 Wed,  3 Feb 2021 11:07:22 +0000 (UTC)
Received: from [10.36.113.43] (ovpn-113-43.ams2.redhat.com [10.36.113.43])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 249474D;
 Wed,  3 Feb 2021 11:07:19 +0000 (UTC)
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
To: Marc Zyngier <maz@kernel.org>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <56041147-0bd8-dbb2-d1ca-550f3db7f05d@redhat.com>
 <adbdbfbcecb65a1eca21afa622679836@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <7808bec4-2ac5-a36d-2960-b4b90574e0d2@redhat.com>
Date: Wed, 3 Feb 2021 12:07:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <adbdbfbcecb65a1eca21afa622679836@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKT24gMi8zLzIxIDExOjM2IEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkgRXJp
YywKPiAKPiBPbiAyMDIxLTAxLTI3IDE3OjUzLCBBdWdlciBFcmljIHdyb3RlOgo+PiBIaSBNYXJj
LAo+Pgo+PiBPbiAxLzI1LzIxIDE6MjYgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IFVwZ3Jh
ZGluZyB0aGUgUE1VIGNvZGUgZnJvbSBBUk12OC4xIHRvIEFSTXY4LjQgdHVybnMgb3V0IHRvIGJl
Cj4+PiBwcmV0dHkgZWFzeS4gQWxsIHRoYXQgaXMgcmVxdWlyZWQgaXMgc3VwcG9ydCBmb3IgUE1N
SVJfRUwxLCB3aGljaAo+Pj4gaXMgcmVhZC1vbmx5LCBhbmQgZm9yIHdoaWNoIHJldHVybmluZyAw
IGlzIGEgdmFsaWQgb3B0aW9uIGFzIGxvbmcKPj4+IGFzIHdlIGRvbid0IGFkdmVydGlzZSBTVEFM
TF9TTE9UIGFzIGFuIGltcGxlbWVudGVkIGV2ZW50Lgo+Pj4KPj4+IExldCdzIGp1c3QgZG8gdGhh
dCBhbmQgYWRqdXN0IHdoYXQgd2UgcmV0dXJuIHRvIHRoZSBndWVzdC4KPj4+Cj4+PiBTaWduZWQt
b2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPgo+Pj4gLS0tCj4+PiDCoGFyY2gv
YXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmggfMKgIDMgKysrCj4+PiDCoGFyY2gvYXJtNjQva3Zt
L3BtdS1lbXVsLmPCoMKgwqDCoMKgwqAgfMKgIDYgKysrKysrCj4+PiDCoGFyY2gvYXJtNjQva3Zt
L3N5c19yZWdzLmPCoMKgwqDCoMKgwqAgfCAxMSArKysrKysrLS0tLQo+Pj4gwqAzIGZpbGVzIGNo
YW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4+Pgo+Pj4gZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmgKPj4+IGIvYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9zeXNyZWcuaAo+Pj4gaW5kZXggOGI1ZTdlNWMzY2M4Li4yZmIzZjM4NjU4OGMgMTAw
NjQ0Cj4+PiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+PiArKysgYi9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+PiBAQCAtODQ2LDcgKzg0NiwxMCBAQAo+
Pj4KPj4+IMKgI2RlZmluZSBJRF9ERlIwX1BFUkZNT05fU0hJRlTCoMKgwqDCoMKgwqDCoCAyNAo+
Pj4KPj4+ICsjZGVmaW5lIElEX0RGUjBfUEVSRk1PTl84XzDCoMKgwqDCoMKgwqDCoCAweDMKPj4+
IMKgI2RlZmluZSBJRF9ERlIwX1BFUkZNT05fOF8xwqDCoMKgwqDCoMKgwqAgMHg0Cj4+PiArI2Rl
ZmluZSBJRF9ERlIwX1BFUkZNT05fOF80wqDCoMKgwqDCoMKgwqAgMHg1Cj4+PiArI2RlZmluZSBJ
RF9ERlIwX1BFUkZNT05fOF81wqDCoMKgwqDCoMKgwqAgMHg2Cj4+Pgo+Pj4gwqAjZGVmaW5lIElE
X0lTQVI0X1NXUF9GUkFDX1NISUZUwqDCoMKgwqDCoMKgwqAgMjgKPj4+IMKgI2RlZmluZSBJRF9J
U0FSNF9QU1JfTV9TSElGVMKgwqDCoMKgwqDCoMKgIDI0Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9rdm0vcG11LWVtdWwuYyBiL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+IGluZGV4
IDM5OGY2ZGYxYmJlNC4uNzJjZDcwNGE4MzY4IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9r
dm0vcG11LWVtdWwuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+Pj4gQEAg
LTc5NSw2ICs3OTUsMTIgQEAgdTY0IGt2bV9wbXVfZ2V0X3BtY2VpZChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsCj4+PiBib29sIHBtY2VpZDEpCj4+PiDCoMKgwqDCoMKgwqDCoMKgIGJhc2UgPSAwOwo+
Pj4gwqDCoMKgwqAgfSBlbHNlIHsKPj4+IMKgwqDCoMKgwqDCoMKgwqAgdmFsID0gcmVhZF9zeXNy
ZWcocG1jZWlkMV9lbDApOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qCj4+PiArwqDCoMKgwqDCoMKg
wqDCoCAqIERvbid0IGFkdmVydGlzZSBTVEFMTF9TTE9ULCBhcyBQTU1JUl9FTDAgaXMgaGFuZGxl
ZAo+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBhcyBSQVoKPj4+ICvCoMKgwqDCoMKgwqDCoMKgICov
Cj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKHZjcHUtPmt2bS0+YXJjaC5wbXV2ZXIgPj0gSURfQUE2
NERGUjBfUE1VVkVSXzhfNCkKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZhbCAmPSB+QklU
X1VMTChBUk1WOF9QTVVWM19QRVJGQ1RSX1NUQUxMX1NMT1QgLSAzMik7Cj4+IHdoYXQgYWJvdXQg
dGhlIFNUQUxMX1NMT1RfQkFDS0VORCBhbmQgRlJPTlRFTkQgZXZlbnRzIHRoZW4/Cj4gCj4gQXJl
bid0IHRoZXNlIGEgbWFuZGF0b3J5IEFSTXY4LjEgZmVhdHVyZT8gSSBkb24ndCBzZWUgYSByZWFz
b24gdG8KPiBkcm9wIHRoZW0uCgpJIHVuZGVyc3RhbmQgdGhlIDMgYXJlIGxpbmtlZCB0b2dldGhl
ci4KCkluIEQ3LjExIGl0IGlzIHNhaWQKIgpXaGVuIGFueSBvZiB0aGUgZm9sbG93aW5nIGNvbW1v
biBldmVudHMgYXJlIGltcGxlbWVudGVkLCBhbGwgdGhyZWUgb2YKdGhlbSBhcmUgaW1wbGVtZW50
ZWQ6CjB4MDAzRCAsIFNUQUxMX1NMT1RfQkFDS0VORCwgTm8gb3BlcmF0aW9uIHNlbnQgZm9yIGV4
ZWN1dGlvbiBvbiBhIFNsb3QKZHVlIHRvIHRoZSBiYWNrZW5kLAoweDAwM0UgLCBTVEFMTF9TTE9U
X0ZST05URU5ELCBObyBvcGVyYXRpb24gc2VudCBmb3IgZXhlY3V0aW9uIG9uIGEgU2xvdApkdWUg
dG8gdGhlIGZyb250ZW5kLgoweDAwM0YgLCBTVEFMTF9TTE9ULCBObyBvcGVyYXRpb24gc2VudCBm
b3IgZXhlY3V0aW9uIG9uIGEgU2xvdC4KIgoKVGhhbmtzCgpFcmljCgo+IAo+Pj4gwqDCoMKgwqDC
oMKgwqDCoCBiYXNlID0gMzI7Cj4+PiDCoMKgwqDCoCB9Cj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtNjQva3ZtL3N5c19yZWdzLmMgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCj4+PiBp
bmRleCA4Zjc5ZWMxZmZmYTcuLjVkYTUzNmFiNzM4ZCAxMDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJt
NjQva3ZtL3N5c19yZWdzLmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPj4+
IEBAIC0xMDUxLDE2ICsxMDUxLDE2IEBAIHN0YXRpYyB1NjQgcmVhZF9pZF9yZWcoY29uc3Qgc3Ry
dWN0IGt2bV92Y3B1Cj4+PiAqdmNwdSwKPj4+IMKgwqDCoMKgwqDCoMKgwqAgLyogTGltaXQgZGVi
dWcgdG8gQVJNdjguMCAqLwo+Pj4gwqDCoMKgwqDCoMKgwqDCoCB2YWwgJj0gfkZFQVRVUkUoSURf
QUE2NERGUjBfREVCVUdWRVIpOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoCB2YWwgfD0gRklFTERfUFJF
UChGRUFUVVJFKElEX0FBNjRERlIwX0RFQlVHVkVSKSwgNik7Cj4+PiAtwqDCoMKgwqDCoMKgwqAg
LyogTGltaXQgZ3Vlc3RzIHRvIFBNVXYzIGZvciBBUk12OC4xICovCj4+PiArwqDCoMKgwqDCoMKg
wqAgLyogTGltaXQgZ3Vlc3RzIHRvIFBNVXYzIGZvciBBUk12OC40ICovCj4+PiDCoMKgwqDCoMKg
wqDCoMKgIHZhbCA9IGNwdWlkX2ZlYXR1cmVfY2FwX3BlcmZtb25fZmllbGQodmFsLAo+Pj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IElEX0FBNjRERlIwX1BNVVZFUl9TSElGVCwKPj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV92Y3B1X2hhc19wbXUodmNwdSkg
Pwo+Pj4gSURfQUE2NERGUjBfUE1VVkVSXzhfMSA6IDApOwo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3ZjcHVfaGFzX3Bt
dSh2Y3B1KSA/Cj4+PiBJRF9BQTY0REZSMF9QTVVWRVJfOF80IDogMCk7Cj4+PiDCoMKgwqDCoMKg
wqDCoMKgIGJyZWFrOwo+Pj4gwqDCoMKgwqAgY2FzZSBTWVNfSURfREZSMF9FTDE6Cj4+PiAtwqDC
oMKgwqDCoMKgwqAgLyogTGltaXQgZ3Vlc3RzIHRvIFBNVXYzIGZvciBBUk12OC4xICovCj4+PiAr
wqDCoMKgwqDCoMKgwqAgLyogTGltaXQgZ3Vlc3RzIHRvIFBNVXYzIGZvciBBUk12OC40ICovCj4+
PiDCoMKgwqDCoMKgwqDCoMKgIHZhbCA9IGNwdWlkX2ZlYXR1cmVfY2FwX3BlcmZtb25fZmllbGQo
dmFsLAo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIElEX0RGUjBfUEVSRk1PTl9TSElGVCwKPj4+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV92Y3B1X2hhc19w
bXUodmNwdSkgPwo+Pj4gSURfREZSMF9QRVJGTU9OXzhfMSA6IDApOwo+Pj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3ZjcHVf
aGFzX3BtdSh2Y3B1KSA/Cj4+PiBJRF9ERlIwX1BFUkZNT05fOF80IDogMCk7Cj4+PiDCoMKgwqDC
oMKgwqDCoMKgIGJyZWFrOwo+Pj4gwqDCoMKgwqAgfQo+Pj4KPj4+IEBAIC0xNDk2LDYgKzE0OTYs
NyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYwo+Pj4gc3lzX3JlZ19kZXNjc1td
ID0gewo+Pj4KPj4+IMKgwqDCoMKgIHsgU1lTX0RFU0MoU1lTX1BNSU5URU5TRVRfRUwxKSwgYWNj
ZXNzX3BtaW50ZW4sIHJlc2V0X3Vua25vd24sCj4+PiBQTUlOVEVOU0VUX0VMMSB9LAo+Pj4gwqDC
oMKgwqAgeyBTWVNfREVTQyhTWVNfUE1JTlRFTkNMUl9FTDEpLCBhY2Nlc3NfcG1pbnRlbiwgcmVz
ZXRfdW5rbm93biwKPj4+IFBNSU5URU5TRVRfRUwxIH0sCj4+ICJLVk06IGFybTY0OiBIaWRlIFBN
VSByZWdpc3RlcnMgZnJvbSB1c2Vyc3BhY2Ugd2hlbiBub3QgYXZhaWxhYmxlIgo+PiBjaGFuZ2Vk
IHRoZSBhYm92ZSwgZG9lc24ndCBpdD8KPiAKPiBZZXMsIHRoYXQncyBiZWNhdXNlIHRoZSBmaXgg
ZGlkbid0IG1ha2UgaXQgaW4gbWFpbmxpbmUgYmVmb3JlCj4gNS4xMS1yYzUsIGFuZCBJIGJhc2Vk
IHRoaXMgb24gLXJjNC4gSSdsbCBmaXggaXQgYXQgbWVyZ2UgdGltZS4KPiAKPiBUaGFua3MsCj4g
Cj4gwqDCoMKgwqDCoMKgwqAgTS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
