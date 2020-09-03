Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D14C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 11:13:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AEBE9206EB
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 11:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WX5IxOe1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEBE9206EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9BB24B1AC;
	Thu,  3 Sep 2020 07:13:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XNKjUgPaS5Nh; Thu,  3 Sep 2020 07:13:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A51144B1AA;
	Thu,  3 Sep 2020 07:13:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3874B1AA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 07:13:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vxktbL3uYuV3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 07:13:49 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A36C24B1A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 07:13:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599131629;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=aMcgR7EBGnY7A/vQ7XtO4JDBUOjqG5feF5q3PLerMSc=;
 b=WX5IxOe1SqwV+rbQWXhL/O8NXUMJKq3iYXY3Sk8yTHArDFTcISHnC8Zer0KrORUqZqAg0o
 2sYwOjbPKV6vPrOmbgepsYBA1n0fE/m7c7mPiWvVDYm25/VAoy85AmJZcRqNFwUzN8E8dj
 8DQgZ7e3KHM1x/fbfdKtx7c+9IYArE4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-77OlPFr0NyiZbtuM-Jn5sg-1; Thu, 03 Sep 2020 07:13:47 -0400
X-MC-Unique: 77OlPFr0NyiZbtuM-Jn5sg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1FF810ABDB1;
 Thu,  3 Sep 2020 11:13:45 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3ADB95D9CC;
 Thu,  3 Sep 2020 11:13:43 +0000 (UTC)
Subject: Re: [PATCH v3 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
From: Gavin Shan <gshan@redhat.com>
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <f7e20f9c-e14e-5314-f78f-1d73743da84c@redhat.com>
Message-ID: <3f13fc6e-7234-6c53-cfaa-a5052fcabe6d@redhat.com>
Date: Thu, 3 Sep 2020 21:13:40 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <f7e20f9c-e14e-5314-f78f-1d73743da84c@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

SGkgV2lsbCwKCk9uIDkvMy8yMCA1OjM0IFBNLCBHYXZpbiBTaGFuIHdyb3RlOgo+IE9uIDgvMjUv
MjAgNzozOSBQTSwgV2lsbCBEZWFjb24gd3JvdGU6Cj4+IEhlbGxvIGZvbGtzLAo+Pgo+PiBUaGlz
IGlzIHZlcnNpb24gdGhyZWUgb2YgdGhlIEtWTSBwYWdlLXRhYmxlIHJld29yayB0aGF0IEkgcHJl
dmlvdXNseSBwb3N0ZWQKPj4gaGVyZToKPj4KPj4gwqDCoCB2MTogaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvci8yMDIwMDczMDE1MzQwNi4yNTEzNi0xLXdpbGxAa2VybmVsLm9yZwo+PiDCoMKgIHYy
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjAwODE4MTMyODE4LjE2MDY1LTEtd2lsbEBr
ZXJuZWwub3JnCj4+Cj4+IENoYW5nZXMgc2luY2UgdjIgaW5jbHVkZToKPj4KPj4gwqDCoCAqIFJl
YmFzZWQgb250byAtcmMyLCB3aGljaCBpbmNsdWRlcyB0aGUgY29uZmxpY3RpbmcgT09NIGJsb2Nr
aW5nIGZpeGVzCj4+IMKgwqAgKiBEcm9wcGVkIHRoZSBwYXRjaCB0cnlpbmcgdG8gImZpeCIgdGhl
IG1lbWNhY2hlIGluIGt2bV9waHlzX2FkZHJfaW9yZW1hcCgpCj4+Cj4gCj4gSXQncyByZWFsbHkg
bmljZSB3b3JrLCBtYWtpbmcgdGhlIGNvZGUgdW5pZmllZC9zaW1wbGlmaWVkIGdyZWF0bHkuCj4g
SG93ZXZlciwgaXQgc2VlbXMgaXQgZG9lc24ndCB3b3JrIHdlbGwgd2l0aCBIdWdlVExCZnMuIFBs
ZWFzZSByZWZlcgo+IHRvIHRoZSBmb2xsb3dpbmcgdGVzdCByZXN1bHQgYW5kIHNlZSBpZiB5b3Ug
aGF2ZSBxdWljayBpZGVhLCBvciBJCj4gY2FuIGRlYnVnIGl0IGEgYml0IDopCj4gCj4gCj4gTWFj
aGluZcKgwqDCoMKgwqDCoMKgwqAgSG9zdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgR3Vlc3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBSZXN1bHQKPiA9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
PiBUaHVuZGVyWDLCoMKgwqAgVkFfQklUUzrCoMKgIDQywqDCoMKgwqDCoMKgwqDCoMKgwqAgUEFH
RV9TSVpFOsKgIDRLQsKgwqDCoMKgIFBhc3NlZAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
UEFHRV9TSVpFOiA2NEtCwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgNjRL
QsKgwqDCoMKgIHBhc3NlZAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVEhQOsKgwqDCoMKg
wqDCoCBkaXNhYmxlZAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSHVnZVRMQjrCoMKgIGRp
c2FibGVkCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCj4gVGh1bmRlclgywqDCoMKgIFZBX0JJVFM6wqDCoCA0MsKgwqDCoMKg
wqDCoMKgwqDCoMKgIFBBR0VfU0laRTrCoCA0S0LCoMKgwqDCoCBQYXNzZWQKPiAgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIFBBR0VfU0laRTogNjRLQsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIDY0S0LCoMKgwqDCoCBwYXNzZWQKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIFRIUDrCoMKgwqDCoMKgwqAgZW5hYmxlZAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
SHVnZVRMQjrCoMKgIGRpc2FibGVkCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+IFRodW5kZXJYMsKgwqDCoCBWQV9CSVRT
OsKgwqAgNDLCoMKgwqDCoMKgwqDCoMKgwqDCoCBQQUdFX1NJWkU6wqAgNEtCwqDCoMKgwqAgRmFp
bFsxXQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgUEFHRV9TSVpFOiA2NEtCwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgNjRLQsKgwqDCoMKgIEZhaWxbMV0KPiAgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIFRIUDrCoMKgwqDCoMKgwqAgZGlzYWJsZWQKPiAgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIEh1Z2VUTEI6wqDCoCBlbmFibGVkCj4gLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gVGh1bmRl
clgywqDCoMKgIFZBX0JJVFM6wqDCoCAzOcKgwqDCoMKgwqDCoMKgwqDCoMKgIFBBR0VfU0laRTrC
oCA0S0LCoMKgwqDCoCBQYXNzZWQKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFBBR0VfU0la
RTogNEtCwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA2NEtCwqDCoMKg
wqAgUGFzc2VkCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBUSFA6wqDCoMKgwqDCoMKgIGRp
c2FibGVkCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBIdWdlVExCOsKgwqAgZGlzYWJsZWQK
PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0KPiBUaHVuZGVyWDLCoMKgwqAgVkFfQklUUzrCoMKgIDM5wqDCoMKgwqDCoMKgwqDC
oMKgwqAgUEFHRV9TSVpFOsKgIDRLQsKgwqDCoMKgIFBhc3NlZAo+ICDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgUEFHRV9TSVpFOiA0S0LCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIDY0S0LCoMKgwqDCoCBQYXNzZWQKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFRI
UDrCoMKgwqDCoMKgwqAgZW5hYmxlZAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSHVnZVRM
QjrCoMKgIGRpc2FibGVkCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiBUaHVuZGVyWDLCoMKgwqAgVkFfQklUUzrCoMKgIDM5
wqDCoMKgwqDCoMKgwqDCoMKgwqAgUEFHRV9TSVpFOiA0S0LCoMKgwqDCoCBGYWlsWzJdCj4gIMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBQQUdFX1NJWkU6IDRLQsKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIDY0S0LCoMKgwqDCoCBGYWlsWzJdCj4gIMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBUSFA6wqDCoMKgwqDCoMKgIGRpc2FibGVkCj4gIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBIdWdlVExCOsKgwqAgZW5hYmxlZAo+IAoKSSBkZWJ1Z2dlZCB0aGUgY29kZSBhbmQg
Zm91bmQgdGhlIGlzc3VlIGlzIGNhdXNlZCBieSB0aGUgZm9sbG93aW5nCnBhdGNoLgoKW1BBVENI
IHYzIDA2LzIxXSBLVk06IGFybTY0OiBBZGQgc3VwcG9ydCBmb3Igc3RhZ2UtMiBtYXAoKS91bm1h
cCgpIGluIGdlbmVyaWMgcGFnZS10YWJsZQoKV2l0aCB0aGUgZm9sbG93aW5nIGNvZGUgY2hhbmdl
cyBhcHBsaWVkIG9uIHRvcCBvZiB0aGlzIHNlcmllcywgbm8KaG9zdCBrZXJuZWwgY3Jhc2ggZm91
bmQgYW5kIGh1Z2V0bGJmcyB3b3JrcyBmb3IgbWUuIEhvd2V2ZXIsIEkgZG9uJ3QKdGhpbmsgaXQn
cyBjb3JyZWN0IGZpeCB0byBoYXZlLiBJIGd1ZXNzIHdlIHN0aWxsIHdhbnQgdG8gaW52YWxpZGF0
ZQp0aGUgcGFnZSB0YWJsZSBlbnRyeSAoYXQgbGV2ZWwjMiB3aGVuIFBBR0VfU0laRSBpcyA2NEtC
IG9uIGhvc3QpIGluCnN0YWdlMl9tYXBfd2Fsa190YWJsZV9wcmUoKSBhcyB3ZSdyZSBnb2luZyB0
byBjdXQgb2ZmIHRoZSBicmFuY2ggdG8KdGhlIHN1Ym9yZGluYXRlIHRhYmxlcy9lbnRyaWVzLiBI
b3dldmVyLCBzdGFnZTJfbWFwX3dhbGtfdGFibGVfcG9zdCgpCnN0aWxsIG5lZWQgdGhlIG9yaWdp
bmFsIHBhZ2UgdGFibGUgZW50cnkgdG8gcmVsZWFzZSB0aGUgc3Vib3JkaW5hdGUKcGFnZSBwcm9w
ZXJseS4gU28gSSBndWVzcyB0aGUgcHJvcGVyIGZpeCB3b3VsZCBiZSB0byBjYWNoZSB0aGUgb3Jp
Z2luYWwKcGFnZSB0YWJsZSBlbnRyeSBpbiBhZHZhbmNlLCBvciB5b3UgbWlnaHQgaGF2ZSBiZXR0
ZXIgaWRlYSA6KQoKSSB3aWxsIGFsc28gcmVwbHkgdG8gUEFUQ0hbMDYvMjFdIHRvIHRvIG1ha2Ug
dGhlIHJlcGx5IGNoYWluIGNvbXBsZXRlLgoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2h5
cC9wZ3RhYmxlLmMgYi9hcmNoL2FybTY0L2t2bS9oeXAvcGd0YWJsZS5jCmluZGV4IDZlOGNhMWVj
MTJiNC4uZjRlYWNmZGQ3M2NiIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2bS9oeXAvcGd0YWJs
ZS5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL2h5cC9wZ3RhYmxlLmMKQEAgLTQ5NCw4ICs0OTQsOCBA
QCBzdGF0aWMgaW50IHN0YWdlMl9tYXBfd2Fsa190YWJsZV9wcmUodTY0IGFkZHIsIHU2NCBlbmQs
IHUzMiBsZXZlbCwKICAgICAgICAgaWYgKCFrdm1fYmxvY2tfbWFwcGluZ19zdXBwb3J0ZWQoYWRk
ciwgZW5kLCBkYXRhLT5waHlzLCBsZXZlbCkpCiAgICAgICAgICAgICAgICAgcmV0dXJuIDA7CiAg
Ci0gICAgICAga3ZtX3NldF9pbnZhbGlkX3B0ZShwdGVwKTsKLSAgICAgICBrdm1fY2FsbF9oeXAo
X19rdm1fdGxiX2ZsdXNoX3ZtaWRfaXBhLCBkYXRhLT5tbXUsIGFkZHIsIDApOworICAgICAgIC8v
a3ZtX3NldF9pbnZhbGlkX3B0ZShwdGVwKTsKKyAgICAgICAvL2t2bV9jYWxsX2h5cChfX2t2bV90
bGJfZmx1c2hfdm1pZF9pcGEsIGRhdGEtPm1tdSwgYWRkciwgMCk7CiAgICAgICAgIGRhdGEtPmFu
Y2hvciA9IHB0ZXA7CiAgICAgICAgIHJldHVybiAwOwogIH0KCkZvciB0aGUgaW5pdGlhbCBkZWJ1
Z2dpbmcsIEkgYWRkIHNvbWUgcHJpbnRrIGFyb3VuZCBhbmQgZ2V0IHRoZSBmb2xsb3dpbmcKb3V0
cHV0LCBmb3IgRllJLiBJdCBpbmRpY2F0ZXMgd2UncmUgcmVsZWFzaW5nIHBhZ2UgYXQgcGh5c2lj
YWwgYWRkcmVzcwoweDAgYW5kIG9idmlvdXNseSBpbmNvcnJlY3QuCgogICAgWyAgMTExLjU4NjE4
MF0gc3RhZ2UyX21hcF93YWxrX3RhYmxlX3Bvc3Q6IGFkZHI9MHg0MDAwMDAwMCwgZW5kPTB4NjAw
MDAwMDAsIGxldmVsPTIsIGFuY2hvckAweGZmZmZmYzBmMTkxYzAwMTAsIHB0ZXBAMHhmZmZmZmMw
ZjE5MWMwMDEwCgogICAgc3RhdGljIGludCBzdGFnZTJfbWFwX3dhbGtfdGFibGVfcG9zdCh1NjQg
YWRkciwgdTY0IGVuZCwgdTMyIGxldmVsLAogICAgICAgICBpZiAoIWRhdGEtPmFuY2hvcikKICAg
ICAgICAgICAgICAgICByZXR1cm4gMDsKICAKKyAgICAgICBpZiAoKnB0ZXAgPT0gMHgwKSB7Cisg
ICAgICAgICAgICAgICBwcl93YXJuKCIlczogYWRkcj0weCVsbHgsIGVuZD0weCVsbHgsIGxldmVs
PSVkLCBhbmNob3JAMHglbHgsIHB0ZXBAMHglbHhcbiIsCisgICAgICAgICAgICAgICAgICAgICAg
ICBfX2Z1bmNfXywgYWRkciwgZW5kLCBsZXZlbCwgKHVuc2lnbmVkIGxvbmcpKGRhdGEtPmFuY2hv
ciksCisgICAgICAgICAgICAgICAgICAgICAgICh1bnNpZ25lZCBsb25nKXB0ZXApOworICAgICAg
IH0KKwogICAgICAgICBmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcpa3ZtX3B0ZV9mb2xsb3coKnB0
ZXApKTsKICAgICAgICAgcHV0X3BhZ2UodmlydF90b19wYWdlKHB0ZXApKTsKCkJ5IHRoZSB3YXks
IEkndmUgZmluaXNoZWQgdGhlIGNvZGUgcmV2aWV3LiBJIGxlYXZlIHRob3NlIG5WSEUgcGF0Y2hl
cyB0byBBbGV4IGZvciBoaXMKcmV2aWV3LiBJIHRoaW5rIHRoZSB0ZXN0aW5nIGlzIGFsc28gZmlu
aXNoZWQgdW50aWwgeW91IG5lZWQgbWUgdG8gaGF2ZSBtb3JlIHRlc3RpbmcuCldpdGggdGhlIGlz
c3VlIGZpeGVkLCBmZWVsIGZyZWUgdG8gYWRkIGZvciB0aGlzIHNlcmllczoKClRlc3RlZC1ieTog
R2F2aW4gU2hhbiA8Z3NoYW5AcmVkaGF0LmNvbT4KClRoYW5rcywKR2F2aW4KCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
