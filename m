Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FDCC43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 00:52:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3177220716
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 00:52:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKOg1/oK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3177220716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 874AF4B315;
	Thu,  3 Sep 2020 20:52:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kuy7rM3IK3TR; Thu,  3 Sep 2020 20:52:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 639394B318;
	Thu,  3 Sep 2020 20:52:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08474B312
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 20:52:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vT+WVcguz6Ma for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 20:52:08 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C810A4B2BB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 20:52:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599180728;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=urcn3Qq5vDhbHmFKrXlRkh4PASkGwZfYZdw02Bvmql8=;
 b=VKOg1/oKpC6UZ0scXO11d2z3CR2B056M6Hmow0UB72RpNsP1XvIWHizAEtTujSf5z2XBtx
 nCNjtRV3k4TTYvAbQBw2BcTqwtz9NECxADNYRPZHHtVUQC8rdq5zTN8DKVDy+ZAjMt+Xtc
 2x6qVvxfNh7CAN0YV6QXi0bHbrWYL0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-mML0KhKkPw2Mg7ofnMbqPg-1; Thu, 03 Sep 2020 20:52:04 -0400
X-MC-Unique: mML0KhKkPw2Mg7ofnMbqPg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32F5C81F033;
 Fri,  4 Sep 2020 00:52:03 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CE495D9CC;
 Fri,  4 Sep 2020 00:52:00 +0000 (UTC)
Subject: Re: [PATCH v3 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
To: Will Deacon <will@kernel.org>
References: <20200825093953.26493-1-will@kernel.org>
 <f7e20f9c-e14e-5314-f78f-1d73743da84c@redhat.com>
 <3f13fc6e-7234-6c53-cfaa-a5052fcabe6d@redhat.com>
 <29ec59b6-ca36-1bd0-0d19-097ecb999bb2@redhat.com>
 <20200903121651.GA7412@willie-the-truck>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <5aa43d21-30a1-68c8-2620-60a25e4edfa2@redhat.com>
Date: Fri, 4 Sep 2020 10:51:58 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200903121651.GA7412@willie-the-truck>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

SGkgV2lsbCwKCk9uIDkvMy8yMCAxMDoxNiBQTSwgV2lsbCBEZWFjb24gd3JvdGU6Cj4gT24gVGh1
LCBTZXAgMDMsIDIwMjAgYXQgMDk6NDg6MThQTSArMTAwMCwgR2F2aW4gU2hhbiB3cm90ZToKPj4g
T24gOS8zLzIwIDk6MTMgUE0sIEdhdmluIFNoYW4gd3JvdGU6Cj4+PiBPbiA5LzMvMjAgNTozNCBQ
TSwgR2F2aW4gU2hhbiB3cm90ZToKPj4+PiBPbiA4LzI1LzIwIDc6MzkgUE0sIFdpbGwgRGVhY29u
IHdyb3RlOgo+Pj4+PiBIZWxsbyBmb2xrcywKPj4+Pj4KPj4+Pj4gVGhpcyBpcyB2ZXJzaW9uIHRo
cmVlIG9mIHRoZSBLVk0gcGFnZS10YWJsZSByZXdvcmsgdGhhdCBJIHByZXZpb3VzbHkgcG9zdGVk
Cj4+Pj4+IGhlcmU6Cj4+Pj4+Cj4+Pj4+ICDCoMKgIHYxOiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9yLzIwMjAwNzMwMTUzNDA2LjI1MTM2LTEtd2lsbEBrZXJuZWwub3JnCj4+Pj4+ICDCoMKgIHYy
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjAwODE4MTMyODE4LjE2MDY1LTEtd2lsbEBr
ZXJuZWwub3JnCj4+Pj4+Cj4+Pj4+IENoYW5nZXMgc2luY2UgdjIgaW5jbHVkZToKPj4+Pj4KPj4+
Pj4gIMKgwqAgKiBSZWJhc2VkIG9udG8gLXJjMiwgd2hpY2ggaW5jbHVkZXMgdGhlIGNvbmZsaWN0
aW5nIE9PTSBibG9ja2luZyBmaXhlcwo+Pj4+PiAgwqDCoCAqIERyb3BwZWQgdGhlIHBhdGNoIHRy
eWluZyB0byAiZml4IiB0aGUgbWVtY2FjaGUgaW4ga3ZtX3BoeXNfYWRkcl9pb3JlbWFwKCkKPj4+
Pj4KPj4+Pgo+Pj4+IEl0J3MgcmVhbGx5IG5pY2Ugd29yaywgbWFraW5nIHRoZSBjb2RlIHVuaWZp
ZWQvc2ltcGxpZmllZCBncmVhdGx5Lgo+Pj4+IEhvd2V2ZXIsIGl0IHNlZW1zIGl0IGRvZXNuJ3Qg
d29yayB3ZWxsIHdpdGggSHVnZVRMQmZzLiBQbGVhc2UgcmVmZXIKPj4+PiB0byB0aGUgZm9sbG93
aW5nIHRlc3QgcmVzdWx0IGFuZCBzZWUgaWYgeW91IGhhdmUgcXVpY2sgaWRlYSwgb3IgSQo+Pj4+
IGNhbiBkZWJ1ZyBpdCBhIGJpdCA6KQo+IAo+IE5pY2UgdGVzdGluZyBtYXRyaXgsIGFuZCB0aGFu
a3MgZm9yIHJlcG9ydGluZyB0aGUgcHJvYmxlbSEKPiAKPj4+PiBNYWNoaW5lwqDCoMKgwqDCoMKg
wqDCoCBIb3N0wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBHdWVzdMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFJlc3VsdAo+Pj4+ID09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQo+Pj4+IFRodW5kZXJY
MsKgwqDCoCBWQV9CSVRTOsKgwqAgNDLCoMKgwqDCoMKgwqDCoMKgwqDCoCBQQUdFX1NJWkU6wqAg
NEtCwqDCoMKgwqAgUGFzc2VkCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFBBR0Vf
U0laRTogNjRLQsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDY0S0LCoMKg
wqDCoCBwYXNzZWQKPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVEhQOsKgwqDCoMKg
wqDCoCBkaXNhYmxlZAo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBIdWdlVExCOsKg
wqAgZGlzYWJsZWQKPj4+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPj4+PiBUaHVuZGVyWDLCoMKgwqAgVkFfQklUUzrCoMKg
IDQywqDCoMKgwqDCoMKgwqDCoMKgwqAgUEFHRV9TSVpFOsKgIDRLQsKgwqDCoMKgIFBhc3NlZAo+
Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBQQUdFX1NJWkU6IDY0S0LCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA2NEtCwqDCoMKgwqAgcGFzc2VkCj4+Pj4gIMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFRIUDrCoMKgwqDCoMKgwqAgZW5hYmxlZAo+Pj4+ICDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBIdWdlVExCOsKgwqAgZGlzYWJsZWQKPj4+PiAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCj4+Pj4gVGh1bmRlclgywqDCoMKgIFZBX0JJVFM6wqDCoCA0MsKgwqDCoMKgwqDCoMKgwqDC
oMKgIFBBR0VfU0laRTrCoCA0S0LCoMKgwqDCoCBGYWlsWzFdCj4+Pj4gIMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIFBBR0VfU0laRTogNjRLQsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIDY0S0LCoMKgwqDCoCBGYWlsWzFdCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIFRIUDrCoMKgwqDCoMKgwqAgZGlzYWJsZWQKPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgSHVnZVRMQjrCoMKgIGVuYWJsZWQKPj4+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPj4+PiBUaHVuZGVyWDLC
oMKgwqAgVkFfQklUUzrCoMKgIDM5wqDCoMKgwqDCoMKgwqDCoMKgwqAgUEFHRV9TSVpFOsKgIDRL
QsKgwqDCoMKgIFBhc3NlZAo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBQQUdFX1NJ
WkU6IDRLQsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgNjRLQsKgwqDC
oMKgIFBhc3NlZAo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBUSFA6wqDCoMKgwqDC
oMKgIGRpc2FibGVkCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEh1Z2VUTEI6wqDC
oCBkaXNhYmxlZAo+Pj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+Pj4+IFRodW5kZXJYMsKgwqDCoCBWQV9CSVRTOsKgwqAg
MznCoMKgwqDCoMKgwqDCoMKgwqDCoCBQQUdFX1NJWkU6wqAgNEtCwqDCoMKgwqAgUGFzc2VkCj4+
Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFBBR0VfU0laRTogNEtCwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA2NEtCwqDCoMKgwqAgUGFzc2VkCj4+Pj4gIMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFRIUDrCoMKgwqDCoMKgwqAgZW5hYmxlZAo+Pj4+ICDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBIdWdlVExCOsKgwqAgZGlzYWJsZWQKPj4+PiAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQo+Pj4+IFRodW5kZXJYMsKgwqDCoCBWQV9CSVRTOsKgwqAgMznCoMKgwqDCoMKgwqDCoMKgwqDC
oCBQQUdFX1NJWkU6IDRLQsKgwqDCoMKgIEZhaWxbMl0KPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgUEFHRV9TSVpFOiA0S0LCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCA2NEtCwqDCoMKgwqAgRmFpbFsyXQo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBUSFA6wqDCoMKgwqDCoMKgIGRpc2FibGVkCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIEh1Z2VUTEI6wqDCoCBlbmFibGVkCj4+Pj4KPj4+Cj4+PiBJIGRlYnVnZ2VkIHRoZSBjb2Rl
IGFuZCBmb3VuZCB0aGUgaXNzdWUgaXMgY2F1c2VkIGJ5IHRoZSBmb2xsb3dpbmcKPj4+IHBhdGNo
Lgo+Pj4KPj4+IFtQQVRDSCB2MyAwNi8yMV0gS1ZNOiBhcm02NDogQWRkIHN1cHBvcnQgZm9yIHN0
YWdlLTIgbWFwKCkvdW5tYXAoKSBpbiBnZW5lcmljIHBhZ2UtdGFibGUKPiAKPiAoSSB0aGluayB0
aGlzIGlzIGp1c3QgYSBzeW1wdG9tIG9mIHRoZSBwYWdlLXRhYmxlIGJlaW5nIG91dCBvZiB3aGFj
aykKPiAKPj4gU29ycnkgdGhhdCB0aGUgZ3Vlc3QgY291bGQgaGFuZyBzb21ldGltZXMgd2l0aCBh
Ym92ZSBjaGFuZ2VzLiBJIGhhdmUgbm8gaWRlYSB3aGF0Cj4+IGhhcyBiZWVuIGhhcHBlbmluZyBi
ZWZvcmUgSSdtIGdvaW5nIHRvIGRlYnVnIGZvciBtb3JlLi4gSSdtIHBhc3RpbmcgdGhlIHVzZWQg
Y29tbWFuZAo+PiBhbmQgb3V0cHV0IGZyb20gZ3Vlc3QuCj4gCj4gQ2FuIHlvdSB0cnkgdGhlIGRp
ZmYgYmVsb3csIHBsZWFzZT8gSSB0aGluayB3ZSBjYW4gZW5kIHVwIHN0aWNraW5nIGRvd24gYQo+
IGh1Z2UtcGFnZS1zaXplZCBtYXBwaW5nIGF0IGFuIHVuYWxpZ25lZCBhZGRyZXNzLCB3aGljaCBj
YXVzZXMgdXMgYm90aCB0bwo+IG92ZXJtYXAgYW5kIGFsc28gdG8gZmFpbCB0byB1c2UgdGhlIGh1
Z2UgZ3JhbnVsZSBmb3IgYSBibG9jayBtYXBwaW5nLgo+IAoKU2luY2UgdGhlIHRoZSBmb2xsb3dp
bmcgY2hhbmdlcyBoYXZlIGJlZW4gZm9sZGVkIHRvIHY0LCBJIHJlcmFuIHRoZSB0ZXN0IGNhc2Vz
Cm9uIHY0IGFuZCBldmVyeXRoaW5nIHdvcmtzIGZpbmUuCgpUaGFua3MsCkdhdmluCgo+IC0tLT44
Cj4gCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL21tdS5jIGIvYXJjaC9hcm02NC9rdm0v
bW11LmMKPiBpbmRleCBmMjhlMDNkY2I4OTcuLjNiZmY5NDJlNWYzMyAxMDA2NDQKPiAtLS0gYS9h
cmNoL2FybTY0L2t2bS9tbXUuYwo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4gQEAgLTcz
NywxMSArNzM3LDExIEBAIHN0YXRpYyBpbnQgdXNlcl9tZW1fYWJvcnQoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LCBwaHlzX2FkZHJfdCBmYXVsdF9pcGEsCj4gICAgICAgICAgYm9vbCBleGVjX2ZhdWx0
Owo+ICAgICAgICAgIGJvb2wgZGV2aWNlID0gZmFsc2U7Cj4gICAgICAgICAgdW5zaWduZWQgbG9u
ZyBtbXVfc2VxOwo+IC0gICAgICAgZ2ZuX3QgZ2ZuID0gZmF1bHRfaXBhID4+IFBBR0VfU0hJRlQ7
Cj4gICAgICAgICAgc3RydWN0IGt2bSAqa3ZtID0gdmNwdS0+a3ZtOwo+ICAgICAgICAgIHN0cnVj
dCBrdm1fbW11X21lbW9yeV9jYWNoZSAqbWVtY2FjaGUgPSAmdmNwdS0+YXJjaC5tbXVfcGFnZV9j
YWNoZTsKPiAgICAgICAgICBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYTsKPiAgICAgICAgICBz
aG9ydCB2bWFfc2hpZnQ7Cj4gKyAgICAgICBnZm5fdCBnZm47Cj4gICAgICAgICAga3ZtX3Bmbl90
IHBmbjsKPiAgICAgICAgICBib29sIGxvZ2dpbmdfYWN0aXZlID0gbWVtc2xvdF9pc19sb2dnaW5n
KG1lbXNsb3QpOwo+ICAgICAgICAgIHVuc2lnbmVkIGxvbmcgdm1hX3BhZ2VzaXplOwo+IEBAIC03
ODAsNyArNzgwLDkgQEAgc3RhdGljIGludCB1c2VyX21lbV9hYm9ydChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHBoeXNfYWRkcl90IGZhdWx0X2lwYSwKPiAgICAgICAgICB9Cj4gICAKPiAgICAgICAg
ICBpZiAodm1hX3BhZ2VzaXplID09IFBNRF9TSVpFIHx8IHZtYV9wYWdlc2l6ZSA9PSBQVURfU0la
RSkKPiAtICAgICAgICAgICAgICAgZ2ZuID0gKGZhdWx0X2lwYSAmIGh1Z2VfcGFnZV9tYXNrKGhz
dGF0ZV92bWEodm1hKSkpID4+IFBBR0VfU0hJRlQ7Cj4gKyAgICAgICAgICAgICAgIGZhdWx0X2lw
YSAmPSBodWdlX3BhZ2VfbWFzayhoc3RhdGVfdm1hKHZtYSkpOwo+ICsKPiArICAgICAgIGdmbiA9
IGZhdWx0X2lwYSA+PiBQQUdFX1NISUZUOwo+ICAgICAgICAgIG1tYXBfcmVhZF91bmxvY2soY3Vy
cmVudC0+bW0pOwo+ICAgCj4gICAgICAgICAgaWYgKGZhdWx0X3N0YXR1cyAhPSBGU0NfUEVSTSkg
ewo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
