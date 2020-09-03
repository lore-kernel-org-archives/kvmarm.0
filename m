Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C94C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 00:07:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0DF9B20773
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 00:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L3C6RTFK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DF9B20773
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49B534B160;
	Wed,  2 Sep 2020 20:07:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SedtPZM4byna; Wed,  2 Sep 2020 20:06:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28A804B1A2;
	Wed,  2 Sep 2020 20:06:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97DEF4B194
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 20:06:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P+oV2wIVAGCQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 20:06:56 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD4174B160
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 20:06:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599091616;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VmDVqRAk0EWMLZ/zibhLMgMUdJHzrAyAIOw0xyFPlMw=;
 b=L3C6RTFKxZ/Kgtv1tNjIC+AQ5CvsMFDM0i6kvc2XlL+kfeFWaHwXsUHUEcGX6oMHuzARNR
 m0v5OTRW0TB2q7+ioQ4m66GG54cUdyRW3Xb9ri/r5KVt03OGMxGzgFaGBdLQK+ny4aBkqR
 +eoRuMjBjf4SlPOjVhFeLrs+ErRopFQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-gmPt1pM7NfOrB7NaeKGIgA-1; Wed, 02 Sep 2020 20:06:54 -0400
X-MC-Unique: gmPt1pM7NfOrB7NaeKGIgA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93D9A1074642;
 Thu,  3 Sep 2020 00:06:53 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5308818B59;
 Thu,  3 Sep 2020 00:06:51 +0000 (UTC)
Subject: Re: [PATCH 2/2] KVM: arm64: Try PMD block mappings if PUD mappings
 are not supported
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20200901133357.52640-1-alexandru.elisei@arm.com>
 <20200901133357.52640-3-alexandru.elisei@arm.com>
 <583211e4-b997-8539-6147-d86cc0cbdbb2@redhat.com>
 <694973e4-2754-1ef4-914b-d7200472cccb@arm.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <f47e506e-b066-5146-d5f3-39d5afc621d2@redhat.com>
Date: Thu, 3 Sep 2020 10:06:49 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <694973e4-2754-1ef4-914b-d7200472cccb@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgQWxleCwKCk9uIDkvMi8yMCA3OjAxIFBNLCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+IE9u
IDkvMi8yMCAyOjIzIEFNLCBHYXZpbiBTaGFuIHdyb3RlOgo+PiBPbiA5LzEvMjAgMTE6MzMgUE0s
IEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+PiBXaGVuIHVzZXJzcGFjZSB1c2VzIGh1Z2V0bGJm
cyBmb3IgdGhlIFZNIG1lbW9yeSwgdXNlcl9tZW1fYWJvcnQoKSB0cmllcyB0bwo+Pj4gdXNlIHRo
ZSBzYW1lIGJsb2NrIHNpemUgdG8gbWFwIHRoZSBmYXVsdGluZyBJUEEgaW4gc3RhZ2UgMi4gSWYg
c3RhZ2UgMgo+Pj4gY2Fubm90IHVzZSB0aGUgc2FtZSBzaXplIG1hcHBpbmcgYmVjYXVzZSB0aGUg
YmxvY2sgc2l6ZSBkb2Vzbid0IGZpdCBpbiB0aGUKPj4+IG1lbXNsb3Qgb3IgdGhlIG1lbXNsb3Qg
aXMgbm90IHByb3Blcmx5IGFsaWduZWQsIHVzZXJfbWVtX2Fib3J0KCkgd2lsbCBmYWxsCj4+PiBi
YWNrIHRvIGEgcGFnZSBtYXBwaW5nLCByZWdhcmRsZXNzIG9mIHRoZSBibG9jayBzaXplLiBXZSBj
YW4gZG8gYmV0dGVyIGZvcgo+Pj4gUFVEIGJhY2tlZCBodWdldGxiZnMgYnkgY2hlY2tpbmcgaWYg
YSBQTUQgYmxvY2sgbWFwcGluZyBpcyBwb3NzaWJsZSBiZWZvcmUKPj4+IGRlY2lkaW5nIHRvIHVz
ZSBhIHBhZ2UuCj4+Pgo+Pj4gdm1hX3BhZ2VzaXplIGlzIGFuIHVuc2lnbmVkIGxvbmcsIHVzZSAx
VUwgaW5zdGVhZCBvZiAxVUxMIHdoZW4gYXNzaWduaW5nCj4+PiBpdHMgdmFsdWUuCj4+Pgo+Pj4g
U2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29t
Pgo+Pj4gLS0tCj4+PiAgwqAgYXJjaC9hcm02NC9rdm0vbW11LmMgfCAxOSArKysrKysrKysrKysr
Ky0tLS0tCj4+PiAgwqAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDUgZGVsZXRp
b25zKC0pCj4+PgoKUmV2aWV3ZWQtYnk6IEdhdmluIFNoYW4gPGdzaGFuQHJlZGhhdC5jb20+Cgo+
Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL21tdS5jIGIvYXJjaC9hcm02NC9rdm0vbW11
LmMKPj4+IGluZGV4IDI1ZTdkYzUyYzA4Ni4uZjU5MGY3MzU1Y2RhIDEwMDY0NAo+Pj4gLS0tIGEv
YXJjaC9hcm02NC9rdm0vbW11LmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4+PiBA
QCAtMTg3MSwxNSArMTg3MSwyNCBAQCBzdGF0aWMgaW50IHVzZXJfbWVtX2Fib3J0KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwKPj4+IHBoeXNfYWRkcl90IGZhdWx0X2lwYSwKPj4+ICDCoMKgwqDCoMKg
IGVsc2UKPj4+ICDCoMKgwqDCoMKgwqDCoMKgwqAgdm1hX3NoaWZ0ID0gUEFHRV9TSElGVDsKPj4+
ICDCoCAtwqDCoMKgIHZtYV9wYWdlc2l6ZSA9IDFVTEwgPDwgdm1hX3NoaWZ0Owo+Pj4gIMKgwqDC
oMKgwqAgaWYgKGxvZ2dpbmdfYWN0aXZlIHx8Cj4+PiAtwqDCoMKgwqDCoMKgwqAgKHZtYS0+dm1f
ZmxhZ3MgJiBWTV9QRk5NQVApIHx8Cj4+PiAtwqDCoMKgwqDCoMKgwqAgIWZhdWx0X3N1cHBvcnRz
X3N0YWdlMl9odWdlX21hcHBpbmcobWVtc2xvdCwgaHZhLCB2bWFfcGFnZXNpemUpKSB7Cj4+PiAr
wqDCoMKgwqDCoMKgwqAgKHZtYS0+dm1fZmxhZ3MgJiBWTV9QRk5NQVApKSB7Cj4+PiAgwqDCoMKg
wqDCoMKgwqDCoMKgIGZvcmNlX3B0ZSA9IHRydWU7Cj4+PiAtwqDCoMKgwqDCoMKgwqAgdm1hX3Bh
Z2VzaXplID0gUEFHRV9TSVpFOwo+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoCB2bWFfc2hpZnQgPSBQ
QUdFX1NISUZUOwo+Pj4gIMKgwqDCoMKgwqAgfQo+Pj4gICAKPj4KPj4gSXQgbG9va3MgaW5jb3Jy
ZWN0IGJlY2F1c2UgQHZtYV9wYWdlc2l6ZSB3YXNuJ3QgaW5pdGlhbGl6ZWQgd2hlbgo+PiBpdCdz
IHBhc3NlZCB0byBmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBwaW5nKCkgZm9yIHRoZSBj
aGVja2luZy4KPj4gSXQncyBhc3N1bWVkIHlvdSBtaXNzZWQgdGhlIGZvbGxvd2luZyBjaGFuZ2Vz
IGFjY29yZGluZyB0byB0aGUgY29tbWl0Cj4+IGxvZzoKPj4KPj4gIMKgwqAgZmF1bHRfc3VwcG9y
dHNfc3RhZ2UyX2h1Z2VfbWFwcGluZyhtZW1zbG90LCBodmEsICgxVUwgPDwgdm1hX3NoaWZ0KSkK
PiAKPiBJJ20gbm90IHN1cmUgd2hhdCB5b3UgbWVhbi4gTWF5YmUgeW91J3ZlIG1pc3JlYWQgdGhl
IGRpZmY/IEJlY2F1c2UgdGhlIGFib3ZlIGNhbGwKPiB0byBmYXVsdF9zdXBwb3J0c19zdGFnZTJf
aHVnZV9tYXBwaW5nKCkgd2FzIHJlbW92ZWQgYnkgdGhlIHBhdGNoLgo+IAoKWWVhaCwgeW91ciBn
dWVzcyBpcyBjb3JyZWN0IGFzIEkgbG9va2VkIGludG8gdGhlIHJlbW92ZWQgY29kZSA6KQoKPj4g
ICAKPj4+ICvCoMKgwqAgaWYgKHZtYV9zaGlmdCA9PSBQVURfU0hJRlQgJiYKPj4+ICvCoMKgwqDC
oMKgwqDCoCAhZmF1bHRfc3VwcG9ydHNfc3RhZ2UyX2h1Z2VfbWFwcGluZyhtZW1zbG90LCBodmEs
IFBVRF9TSVpFKSkKPj4+ICvCoMKgwqDCoMKgwqDCoCB2bWFfc2hpZnQgPSBQTURfU0hJRlQ7Cj4+
PiArCj4+PiArwqDCoMKgIGlmICh2bWFfc2hpZnQgPT0gUE1EX1NISUZUICYmCj4+PiArwqDCoMKg
wqDCoMKgwqAgIWZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBpbmcobWVtc2xvdCwgaHZh
LCBQTURfU0laRSkpIHsKPj4+ICvCoMKgwqDCoMKgwqDCoCBmb3JjZV9wdGUgPSB0cnVlOwo+Pj4g
K8KgwqDCoMKgwqDCoMKgIHZtYV9zaGlmdCA9IFBBR0VfU0hJRlQ7Cj4+PiArwqDCoMKgIH0KPj4+
ICsKPj4+ICvCoMKgwqAgdm1hX3BhZ2VzaXplID0gMVVMIDw8IHZtYV9zaGlmdDsKPj4+ICs+wqDC
oMKgwqDCoMKgIC8qCj4+PiAgwqDCoMKgwqDCoMKgICogVGhlIHN0YWdlMiBoYXMgYSBtaW5pbXVt
IG9mIDIgbGV2ZWwgdGFibGUgKEZvciBhcm02NCBzZWUKPj4+ICDCoMKgwqDCoMKgwqAgKiBrdm1f
YXJtX3NldHVwX3N0YWdlMigpKS4gSGVuY2UsIHdlIGFyZSBndWFyYW50ZWVkIHRoYXQgd2UgY2Fu
Cj4+PiBAQCAtMTg4OSw3ICsxODk4LDcgQEAgc3RhdGljIGludCB1c2VyX21lbV9hYm9ydChzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4+PiBwaHlzX2FkZHJfdCBmYXVsdF9pcGEsCj4+PiAgwqDCoMKg
wqDCoMKgICovCj4+PiAgwqDCoMKgwqDCoCBpZiAodm1hX3BhZ2VzaXplID09IFBNRF9TSVpFIHx8
Cj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgICh2bWFfcGFnZXNpemUgPT0gUFVEX1NJWkUgJiYga3Zt
X3N0YWdlMl9oYXNfcG1kKGt2bSkpKQo+Pj4gLcKgwqDCoMKgwqDCoMKgIGdmbiA9IChmYXVsdF9p
cGEgJiBodWdlX3BhZ2VfbWFzayhoc3RhdGVfdm1hKHZtYSkpKSA+PiBQQUdFX1NISUZUOwo+Pj4g
K8KgwqDCoMKgwqDCoMKgIGdmbiA9IChmYXVsdF9pcGEgJiB+KHZtYV9wYWdlc2l6ZSAtIDEpKSA+
PiBQQUdFX1NISUZUOwo+Pj4gIMKgwqDCoMKgwqAgbW1hcF9yZWFkX3VubG9jayhjdXJyZW50LT5t
bSk7Cj4+PiAgwqAgwqDCoMKgwqDCoCAvKiBXZSBuZWVkIG1pbmltdW0gc2Vjb25kK3RoaXJkIGxl
dmVsIHBhZ2VzICovCj4+Pgo+PgoKVGhhbmtzLApHYXZpbgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
