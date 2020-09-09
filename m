Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B128C43461
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 09:58:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BA4D21973
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 09:58:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJFdn171"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BA4D21973
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECFEF4B5F4;
	Wed,  9 Sep 2020 05:58:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6nS0DO4vjF2T; Wed,  9 Sep 2020 05:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE3A44B37E;
	Wed,  9 Sep 2020 05:58:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E4D4B35F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 05:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sk1ZEyfgQok4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 05:58:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D80A14B348
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 05:58:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599645529;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9GYfr76gMmlD7R8eAq7IC3Rm6lO9WVaWytangZoFZ6w=;
 b=OJFdn171GP3mPeL8u3kh+eXGreMNeahab1y7g5EJs1Hzp5qH+z9S14qy2Z/AieufJ5eERF
 /dNL/Phi/i2/gupDyLNwqIYqYhyw4F6oGUFgtaVaoz6Mxls7XxYFZz1mJ4gfWC/0kK7dJl
 2dLgyml4K7TEJ3FHP2zrXhnVUD+Sgsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-M-G5JZA-MZ6V-0MfQAepgA-1; Wed, 09 Sep 2020 05:58:46 -0400
X-MC-Unique: M-G5JZA-MZ6V-0MfQAepgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D80021007466;
 Wed,  9 Sep 2020 09:58:43 +0000 (UTC)
Received: from [10.36.115.123] (ovpn-115-123.ams2.redhat.com [10.36.115.123])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A7125D9E8;
 Wed,  9 Sep 2020 09:58:40 +0000 (UTC)
Subject: Re: [PATCH v3 2/5] KVM: arm64: Use event mask matching architecture
 revision
To: Marc Zyngier <maz@kernel.org>
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-3-maz@kernel.org>
 <2e1257aa-9e8c-89ba-c09b-3cfee38c8486@redhat.com>
 <a84f6d17414c0fae3df1038f0e17e225@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <17ffe591-7416-a467-0c31-9c316f0bfc2a@redhat.com>
Date: Wed, 9 Sep 2020 11:58:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a84f6d17414c0fae3df1038f0e17e225@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, graf@amazon.com,
 Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKCk9uIDkvOS8yMCAxMTo1NCBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIEVy
aWMsCj4gCj4gT24gMjAyMC0wOS0wOSAxMDozOCwgQXVnZXIgRXJpYyB3cm90ZToKPj4gSGkgTWFy
YywKPj4KPj4gT24gOS84LzIwIDk6NTggQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IFRoZSBQ
TVUgY29kZSBzdWZmZXJzIGZyb20gYSBzbWFsbCBkZWZlY3Qgd2hlcmUgd2UgYXNzdW1lIHRoYXQg
dGhlIGV2ZW50Cj4+PiBudW1iZXIgcHJvdmlkZWQgYnkgdGhlIGd1ZXN0IGlzIGFsd2F5cyAxNiBi
aXQgd2lkZSwgZXZlbiBpZiB0aGUgQ1BVIG9ubHkKPj4+IGltcGxlbWVudHMgdGhlIEFSTXY4LjAg
YXJjaGl0ZWN0dXJlLiBUaGlzIGlzbid0IHJlYWxseSBwcm9ibGVtYXRpYyBpbgo+Pj4gdGhlIHNl
bnNlIHRoYXQgdGhlIGV2ZW50IG51bWJlciBlbmRzIHVwIGluIGEgc3lzdGVtIHJlZ2lzdGVyLCBj
cm9wcGluZwo+Pj4gaXQgdG8gdGhlIHJpZ2h0IHdpZHRoLCBidXQgc3RpbGwgdGhpcyBuZWVkcyBm
aXhpbmcuCj4+Pgo+Pj4gSW4gb3JkZXIgdG8gbWFrZSBpdCB3b3JrLCBsZXQncyBwcm9iZSB0aGUg
dmVyc2lvbiBvZiB0aGUgUE1VIHRoYXQgdGhlCj4+PiBndWVzdCBpcyBnb2luZyB0byB1c2UuIFRo
aXMgaXMgZG9uZSBieSB0ZW1wb3JhcmlseSBjcmVhdGluZyBhIGtlcm5lbAo+Pj4gZXZlbnQgYW5k
IGxvb2tpbmcgYXQgdGhlIFBNVVZlciBmaWVsZCB0aGF0IGhhcyBiZWVuIHNhdmVkIGF0IHByb2Jl
IHRpbWUKPj4+IGluIHRoZSBhc3NvY2lhdGVkIGFybV9wbXUgc3RydWN0dXJlLiBUaGlzIGluIHR1
cm4gZ2V0cyBzYXZlZCBpbiB0aGUga3ZtCj4+PiBzdHJ1Y3R1cmUsIGFuZCBzdWJzZXF1ZW50bHkg
dXNlZCB0byBjb21wdXRlIHRoZSBldmVudCBtYXNrIHRoYXQgZ2V0cwo+Pj4gdXNlZCB0aHJvdWdo
b3V0IHRoZSBQTVUgY29kZS4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1h
ekBrZXJuZWwub3JnPgo+Pj4gLS0tCj4+PiDCoGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hv
c3QuaCB8wqAgMiArCj4+PiDCoGFyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmPCoMKgwqDCoMKgwqDC
oMKgIHwgODEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQo+Pj4gwqAyIGZpbGVzIGNo
YW5nZWQsIDc4IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4+Pgo+Pj4gZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+Pj4gYi9hcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL2t2bV9ob3N0LmgKPj4+IGluZGV4IDY1NTY4YjIzODY4YS4uNmNkNjBiZTY5YzI4
IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCj4+PiAr
KysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPj4+IEBAIC0xMTAsNiArMTEw
LDggQEAgc3RydWN0IGt2bV9hcmNoIHsKPj4+IMKgwqDCoMKgwqAgKiBzdXBwb3J0ZWQuCj4+PiDC
oMKgwqDCoMKgICovCj4+PiDCoMKgwqDCoCBib29sIHJldHVybl9uaXN2X2lvX2Fib3J0X3RvX3Vz
ZXI7Cj4+PiArCj4+PiArwqDCoMKgIHVuc2lnbmVkIGludCBwbXV2ZXI7Cj4+PiDCoH07Cj4+Pgo+
Pj4gwqBzdHJ1Y3Qga3ZtX3ZjcHVfZmF1bHRfaW5mbyB7Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9rdm0vcG11LWVtdWwuYyBiL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+IGluZGV4
IDkzZDc5N2RmNDJjNi4uOGE1ZjY1NzYzODE0IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9r
dm0vcG11LWVtdWwuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+Pj4gQEAg
LTIwLDYgKzIwLDIwIEBAIHN0YXRpYyB2b2lkIGt2bV9wbXVfc3RvcF9jb3VudGVyKHN0cnVjdCBr
dm1fdmNwdQo+Pj4gKnZjcHUsIHN0cnVjdCBrdm1fcG1jICpwbWMpOwo+Pj4KPj4+IMKgI2RlZmlu
ZSBQRVJGX0FUVFJfQ0ZHMV9LVk1fUE1VX0NIQUlORUQgMHgxCj4+Pgo+Pj4gK3N0YXRpYyB1MzIg
a3ZtX3BtdV9ldmVudF9tYXNrKHN0cnVjdCBrdm0gKmt2bSkKPj4+ICt7Cj4+PiArwqDCoMKgIHN3
aXRjaCAoa3ZtLT5hcmNoLnBtdXZlcikgewo+Pj4gK8KgwqDCoCBjYXNlIDE6wqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAvKiBBUk12OC4wICovCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIEdFTk1B
U0soOSwgMCk7Cj4+PiArwqDCoMKgIGNhc2UgNDrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIEFS
TXY4LjEgKi8KPj4+ICvCoMKgwqAgY2FzZSA1OsKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyogQVJN
djguNCAqLwo+Pj4gK8KgwqDCoCBjYXNlIDY6wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBBUk12
OC41ICovCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIEdFTk1BU0soMTUsIDApOwo+Pj4gK8Kg
wqDCoCBkZWZhdWx0OsKgwqDCoMKgwqDCoMKgIC8qIFNob3VsZG4ndCBiZSB0aGVyZSwganVzdCBm
b3Igc2FuaXR5ICovCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4+PiArwqDCoMKgIH0K
Pj4+ICt9Cj4+PiArCj4+PiDCoC8qKgo+Pj4gwqAgKiBrdm1fcG11X2lkeF9pc182NGJpdCAtIGRl
dGVybWluZSBpZiBzZWxlY3RfaWR4IGlzIGEgNjRiaXQgY291bnRlcgo+Pj4gwqAgKiBAdmNwdTog
VGhlIHZjcHUgcG9pbnRlcgo+Pj4gQEAgLTEwMCw3ICsxMTQsNyBAQCBzdGF0aWMgYm9vbCBrdm1f
cG11X2lkeF9oYXNfY2hhaW5fZXZ0eXBlKHN0cnVjdAo+Pj4ga3ZtX3ZjcHUgKnZjcHUsIHU2NCBz
ZWxlY3RfaWR4KQo+Pj4gwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gZmFsc2U7Cj4+Pgo+Pj4gwqDC
oMKgwqAgcmVnID0gUE1FVlRZUEVSMF9FTDAgKyBzZWxlY3RfaWR4Owo+Pj4gLcKgwqDCoCBldmVu
dHNlbCA9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIHJlZykgJiBBUk1WOF9QTVVfRVZUWVBFX0VWRU5U
Owo+Pj4gK8KgwqDCoCBldmVudHNlbCA9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIHJlZykgJgo+Pj4g
a3ZtX3BtdV9ldmVudF9tYXNrKHZjcHUtPmt2bSk7Cj4+Pgo+Pj4gwqDCoMKgwqAgcmV0dXJuIGV2
ZW50c2VsID09IEFSTVY4X1BNVVYzX1BFUkZDVFJfQ0hBSU47Cj4+PiDCoH0KPj4+IEBAIC00OTUs
NyArNTA5LDcgQEAgdm9pZCBrdm1fcG11X3NvZnR3YXJlX2luY3JlbWVudChzdHJ1Y3Qga3ZtX3Zj
cHUKPj4+ICp2Y3B1LCB1NjQgdmFsKQo+Pj4KPj4+IMKgwqDCoMKgwqDCoMKgwqAgLyogUE1TV0lO
QyBvbmx5IGFwcGxpZXMgdG8gLi4uIFNXX0lOQyEgKi8KPj4+IMKgwqDCoMKgwqDCoMKgwqAgdHlw
ZSA9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNRVZUWVBFUjBfRUwwICsgaSk7Cj4+PiAtwqDCoMKg
wqDCoMKgwqAgdHlwZSAmPSBBUk1WOF9QTVVfRVZUWVBFX0VWRU5UOwo+Pj4gK8KgwqDCoMKgwqDC
oMKgIHR5cGUgJj0ga3ZtX3BtdV9ldmVudF9tYXNrKHZjcHUtPmt2bSk7Cj4+PiDCoMKgwqDCoMKg
wqDCoMKgIGlmICh0eXBlICE9IEFSTVY4X1BNVVYzX1BFUkZDVFJfU1dfSU5DUikKPj4+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsKPj4+Cj4+PiBAQCAtNTc4LDcgKzU5Miw3IEBA
IHN0YXRpYyB2b2lkIGt2bV9wbXVfY3JlYXRlX3BlcmZfZXZlbnQoc3RydWN0Cj4+PiBrdm1fdmNw
dSAqdmNwdSwgdTY0IHNlbGVjdF9pZHgpCj4+PiDCoMKgwqDCoCBkYXRhID0gX192Y3B1X3N5c19y
ZWcodmNwdSwgcmVnKTsKPj4+Cj4+PiDCoMKgwqDCoCBrdm1fcG11X3N0b3BfY291bnRlcih2Y3B1
LCBwbWMpOwo+Pj4gLcKgwqDCoCBldmVudHNlbCA9IGRhdGEgJiBBUk1WOF9QTVVfRVZUWVBFX0VW
RU5UOwo+Pj4gK8KgwqDCoCBldmVudHNlbCA9IGRhdGEgJiBrdm1fcG11X2V2ZW50X21hc2sodmNw
dS0+a3ZtKTs7Cj4+Pgo+Pj4gwqDCoMKgwqAgLyogU29mdHdhcmUgaW5jcmVtZW50IGV2ZW50IGRv
ZXMndCBuZWVkIHRvIGJlIGJhY2tlZCBieSBhIHBlcmYKPj4+IGV2ZW50ICovCj4+PiDCoMKgwqDC
oCBpZiAoZXZlbnRzZWwgPT0gQVJNVjhfUE1VVjNfUEVSRkNUUl9TV19JTkNSICYmCj4+PiBAQCAt
Njc5LDE3ICs2OTMsNjggQEAgc3RhdGljIHZvaWQga3ZtX3BtdV91cGRhdGVfcG1jX2NoYWluZWQo
c3RydWN0Cj4+PiBrdm1fdmNwdSAqdmNwdSwgdTY0IHNlbGVjdF9pZHgpCj4+PiDCoHZvaWQga3Zt
X3BtdV9zZXRfY291bnRlcl9ldmVudF90eXBlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IGRh
dGEsCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHU2NCBzZWxl
Y3RfaWR4KQo+Pj4gwqB7Cj4+PiAtwqDCoMKgIHU2NCByZWcsIGV2ZW50X3R5cGUgPSBkYXRhICYg
QVJNVjhfUE1VX0VWVFlQRV9NQVNLOwo+Pj4gK8KgwqDCoCB1NjQgcmVnLCBtYXNrOwo+Pj4gKwo+
Pj4gK8KgwqDCoCBtYXNrwqAgPcKgIEFSTVY4X1BNVV9FVlRZUEVfTUFTSzsKPj4+ICvCoMKgwqAg
bWFzayAmPSB+QVJNVjhfUE1VX0VWVFlQRV9FVkVOVDsKPj4+ICvCoMKgwqAgbWFzayB8PSBrdm1f
cG11X2V2ZW50X21hc2sodmNwdS0+a3ZtKTsKPj4+Cj4+PiDCoMKgwqDCoCByZWcgPSAoc2VsZWN0
X2lkeCA9PSBBUk1WOF9QTVVfQ1lDTEVfSURYKQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgPyBQ
TUNDRklMVFJfRUwwIDogUE1FVlRZUEVSMF9FTDAgKyBzZWxlY3RfaWR4Owo+Pj4KPj4+IC3CoMKg
wqAgX192Y3B1X3N5c19yZWcodmNwdSwgcmVnKSA9IGV2ZW50X3R5cGU7Cj4+PiArwqDCoMKgIF9f
dmNwdV9zeXNfcmVnKHZjcHUsIHJlZykgPSBkYXRhICYgbWFzazsKPj4+Cj4+PiDCoMKgwqDCoCBr
dm1fcG11X3VwZGF0ZV9wbWNfY2hhaW5lZCh2Y3B1LCBzZWxlY3RfaWR4KTsKPj4+IMKgwqDCoMKg
IGt2bV9wbXVfY3JlYXRlX3BlcmZfZXZlbnQodmNwdSwgc2VsZWN0X2lkeCk7Cj4+PiDCoH0KPj4+
Cj4+PiArc3RhdGljIGludCBrdm1fcG11X3Byb2JlX3BtdXZlcih2b2lkKQo+Pj4gK3sKPj4+ICvC
oMKgwqAgc3RydWN0IHBlcmZfZXZlbnRfYXR0ciBhdHRyID0geyB9Owo+Pj4gK8KgwqDCoCBzdHJ1
Y3QgcGVyZl9ldmVudCAqZXZlbnQ7Cj4+PiArwqDCoMKgIHN0cnVjdCBhcm1fcG11ICpwbXU7Cj4+
PiArwqDCoMKgIGludCBwbXV2ZXIgPSAweGY7Cj4+PiArCj4+PiArwqDCoMKgIC8qCj4+PiArwqDC
oMKgwqAgKiBDcmVhdGUgYSBkdW1teSBldmVudCB0aGF0IG9ubHkgY291bnRzIHVzZXIgY3ljbGVz
LiBBcyB3ZSdsbAo+Pj4gbmV2ZXIKPj4+ICvCoMKgwqDCoCAqIGxlYXZlIHRoaW5nIGZ1bmN0aW9u
IHdpdGggdGhlIGV2ZW50IGJlaW5nIGxpdmUsIGl0IHdpbGwgbmV2ZXIKPj4+ICvCoMKgwqDCoCAq
IGNvdW50IGFueXRoaW5nLiBCdXQgaXQgYWxsb3dzIHVzIHRvIHByb2JlIHNvbWUgb2YgdGhlIFBN
VQo+Pj4gK8KgwqDCoMKgICogZGV0YWlscy4gWWVzLCB0aGlzIGlzIHRlcnJpYmxlLgo+PiBJIGZh
aWwgdG8gdW5kZXJzdGFuZCB3aHkgd2UgY2FuJ3QgZGlyZWN0bHkgcmVhZCBJRF9ERlIwX0VMMS5Q
ZXJmTW9uPwo+IAo+IEJlY2F1c2UgeW91J3JlIG1pc3NpbmcgdGhlIGJpZy1saXR0bGUgbmlnaHRt
YXJlLiBXaGF0IHlvdSByZWFkIG9uIHRoZQo+IGN1cnJlbnQgQ1BVIGlzIGlycmVsZXZhbnQuIFlv
dSB3YW50IHRvIHJlYWQgdGhlIFBNVSB2ZXJzaW9uIG9uIHRoZSBQTVUKPiB0aGF0IGlzIGdvaW5n
IHRvIGFjdHVhbGx5IGJlIHVzZWQgKGFuZCB0aGF0J3MgdGhlIHdoYXRldmVyIHBlcmYgZGVjaWRl
cwo+IHRvIHVzZSBhdCB0aGlzIHBvaW50KS4KPiAKPiBUaGF0J3MgYWxzbyB0aGUgcmVhc29uIHdo
eSBQTVUgaW4gZ3Vlc3RzIG9ubHkgd29yayBpbiBCTCBzeXN0ZW1zCj4gb24gb25lIGNsYXNzIG9m
IENQVXMgb25seS4KPiAKPiBZZXMsIGFsbCBDUFVzIHNob3VsZCBoYXZlIHRoZSBzYW1lIFBNVSB2
ZXJzaW9uLiBVbmZvcnR1bmF0ZWx5LAo+IHRoYXQncyBub3QgYWx3YXlzIHRoZSBjYXNlLi4uCgpB
aCBPSy4gSSBGb3Jnb3QgdGhpcy4uLgoKVGhhbmtzCgpFcmljCj4gCj4gwqDCoMKgwqDCoMKgwqAg
TS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
