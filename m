Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360D9C43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:08:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88D6E206D4
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+23o9D7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88D6E206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 261004B34C;
	Fri,  4 Sep 2020 06:07:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ea9f8u0m1n07; Fri,  4 Sep 2020 06:07:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C64F4B348;
	Fri,  4 Sep 2020 06:07:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D6B74B348
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:07:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wEVCqpxXPDsE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 06:07:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A876A4B144
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:07:53 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 76136206D4;
 Fri,  4 Sep 2020 10:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599214072;
 bh=MqujWJPQC66PeJ28VOdDbtZq/fnwmyZQT6U5RRFWBC0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=c+23o9D7+VSODrqwicDlHvaSHC0EhC75XSISbk/LXKlJ40A6AZwk6oeogysSt0LP8
 gM1Mqy1m6/qvOInFBVduR8fE3LCEn2YqbetJAmO5XmMarGlyFPhqF903damm1azj5h
 s51+GDUOfyWEZT1QPs+eBtv3RWjYn5jqdaEirbfE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kE8dK-00985S-OH; Fri, 04 Sep 2020 11:07:50 +0100
MIME-Version: 1.0
Date: Fri, 04 Sep 2020 11:07:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
In-Reply-To: <5aa43d21-30a1-68c8-2620-60a25e4edfa2@redhat.com>
References: <20200825093953.26493-1-will@kernel.org>
 <f7e20f9c-e14e-5314-f78f-1d73743da84c@redhat.com>
 <3f13fc6e-7234-6c53-cfaa-a5052fcabe6d@redhat.com>
 <29ec59b6-ca36-1bd0-0d19-097ecb999bb2@redhat.com>
 <20200903121651.GA7412@willie-the-truck>
 <5aa43d21-30a1-68c8-2620-60a25e4edfa2@redhat.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <fa494886b9a88ec7b02141f2da44d5a7@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, qperret@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC0wOS0wNCAwMTo1MSwgR2F2aW4gU2hhbiB3cm90ZToKPiBIaSBXaWxsLAo+IAo+IE9u
IDkvMy8yMCAxMDoxNiBQTSwgV2lsbCBEZWFjb24gd3JvdGU6Cj4+IE9uIFRodSwgU2VwIDAzLCAy
MDIwIGF0IDA5OjQ4OjE4UE0gKzEwMDAsIEdhdmluIFNoYW4gd3JvdGU6Cj4+PiBPbiA5LzMvMjAg
OToxMyBQTSwgR2F2aW4gU2hhbiB3cm90ZToKPj4+PiBPbiA5LzMvMjAgNTozNCBQTSwgR2F2aW4g
U2hhbiB3cm90ZToKPj4+Pj4gT24gOC8yNS8yMCA3OjM5IFBNLCBXaWxsIERlYWNvbiB3cm90ZToK
Pj4+Pj4+IEhlbGxvIGZvbGtzLAo+Pj4+Pj4gCj4+Pj4+PiBUaGlzIGlzIHZlcnNpb24gdGhyZWUg
b2YgdGhlIEtWTSBwYWdlLXRhYmxlIHJld29yayB0aGF0IEkgCj4+Pj4+PiBwcmV2aW91c2x5IHBv
c3RlZAo+Pj4+Pj4gaGVyZToKPj4+Pj4+IAo+Pj4+Pj4gIMKgwqAgdjE6IAo+Pj4+Pj4gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIwMDczMDE1MzQwNi4yNTEzNi0xLXdpbGxAa2VybmVsLm9y
Zwo+Pj4+Pj4gIMKgwqAgdjI6IAo+Pj4+Pj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIw
MDgxODEzMjgxOC4xNjA2NS0xLXdpbGxAa2VybmVsLm9yZwo+Pj4+Pj4gCj4+Pj4+PiBDaGFuZ2Vz
IHNpbmNlIHYyIGluY2x1ZGU6Cj4+Pj4+PiAKPj4+Pj4+ICDCoMKgICogUmViYXNlZCBvbnRvIC1y
YzIsIHdoaWNoIGluY2x1ZGVzIHRoZSBjb25mbGljdGluZyBPT00gCj4+Pj4+PiBibG9ja2luZyBm
aXhlcwo+Pj4+Pj4gIMKgwqAgKiBEcm9wcGVkIHRoZSBwYXRjaCB0cnlpbmcgdG8gImZpeCIgdGhl
IG1lbWNhY2hlIGluIAo+Pj4+Pj4ga3ZtX3BoeXNfYWRkcl9pb3JlbWFwKCkKPj4+Pj4+IAo+Pj4+
PiAKPj4+Pj4gSXQncyByZWFsbHkgbmljZSB3b3JrLCBtYWtpbmcgdGhlIGNvZGUgdW5pZmllZC9z
aW1wbGlmaWVkIGdyZWF0bHkuCj4+Pj4+IEhvd2V2ZXIsIGl0IHNlZW1zIGl0IGRvZXNuJ3Qgd29y
ayB3ZWxsIHdpdGggSHVnZVRMQmZzLiBQbGVhc2UgcmVmZXIKPj4+Pj4gdG8gdGhlIGZvbGxvd2lu
ZyB0ZXN0IHJlc3VsdCBhbmQgc2VlIGlmIHlvdSBoYXZlIHF1aWNrIGlkZWEsIG9yIEkKPj4+Pj4g
Y2FuIGRlYnVnIGl0IGEgYml0IDopCj4+IAo+PiBOaWNlIHRlc3RpbmcgbWF0cml4LCBhbmQgdGhh
bmtzIGZvciByZXBvcnRpbmcgdGhlIHByb2JsZW0hCj4+IAo+Pj4+PiBNYWNoaW5lwqDCoMKgwqDC
oMKgwqDCoCBIb3N0wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBHdWVz
dMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFJlc3VsdAo+Pj4+PiA9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KPj4+Pj4gVGh1
bmRlclgywqDCoMKgIFZBX0JJVFM6wqDCoCA0MsKgwqDCoMKgwqDCoMKgwqDCoMKgIFBBR0VfU0la
RTrCoCA0S0LCoMKgwqDCoCBQYXNzZWQKPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IFBBR0VfU0laRTogNjRLQsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDY0
S0LCoMKgwqDCoCBwYXNzZWQKPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFRIUDrC
oMKgwqDCoMKgwqAgZGlzYWJsZWQKPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEh1
Z2VUTEI6wqDCoCBkaXNhYmxlZAo+Pj4+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPj4+Pj4gVGh1bmRlclgywqDCoMKgIFZB
X0JJVFM6wqDCoCA0MsKgwqDCoMKgwqDCoMKgwqDCoMKgIFBBR0VfU0laRTrCoCA0S0LCoMKgwqDC
oCBQYXNzZWQKPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFBBR0VfU0laRTogNjRL
QsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDY0S0LCoMKgwqDCoCBwYXNz
ZWQKPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFRIUDrCoMKgwqDCoMKgwqAgZW5h
YmxlZAo+Pj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSHVnZVRMQjrCoMKgIGRpc2Fi
bGVkCj4+Pj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KPj4+Pj4gVGh1bmRlclgywqDCoMKgIFZBX0JJVFM6wqDCoCA0MsKg
wqDCoMKgwqDCoMKgwqDCoMKgIFBBR0VfU0laRTrCoCA0S0LCoMKgwqDCoCBGYWlsWzFdCj4+Pj4+
ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBQQUdFX1NJWkU6IDY0S0LCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA2NEtCwqDCoMKgwqAgRmFpbFsxXQo+Pj4+PiAgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVEhQOsKgwqDCoMKgwqDCoCBkaXNhYmxlZAo+Pj4+PiAg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSHVnZVRMQjrCoMKgIGVuYWJsZWQKPj4+Pj4gLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCj4+Pj4+IFRodW5kZXJYMsKgwqDCoCBWQV9CSVRTOsKgwqAgMznCoMKgwqDCoMKgwqDCoMKg
wqDCoCBQQUdFX1NJWkU6wqAgNEtCwqDCoMKgwqAgUGFzc2VkCj4+Pj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBQQUdFX1NJWkU6IDRLQsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgNjRLQsKgwqDCoMKgIFBhc3NlZAo+Pj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgVEhQOsKgwqDCoMKgwqDCoCBkaXNhYmxlZAo+Pj4+PiAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgSHVnZVRMQjrCoMKgIGRpc2FibGVkCj4+Pj4+IC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+Pj4+PiBUaHVu
ZGVyWDLCoMKgwqAgVkFfQklUUzrCoMKgIDM5wqDCoMKgwqDCoMKgwqDCoMKgwqAgUEFHRV9TSVpF
OsKgIDRLQsKgwqDCoMKgIFBhc3NlZAo+Pj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
UEFHRV9TSVpFOiA0S0LCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDY0
S0LCoMKgwqDCoCBQYXNzZWQKPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFRIUDrC
oMKgwqDCoMKgwqAgZW5hYmxlZAo+Pj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSHVn
ZVRMQjrCoMKgIGRpc2FibGVkCj4+Pj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4+Pj4+IFRodW5kZXJYMsKgwqDCoCBWQV9C
SVRTOsKgwqAgMznCoMKgwqDCoMKgwqDCoMKgwqDCoCBQQUdFX1NJWkU6IDRLQsKgwqDCoMKgIEZh
aWxbMl0KPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFBBR0VfU0laRTogNEtCwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgNjRLQsKgwqDCoMKgIEZhaWxbMl0K
Pj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFRIUDrCoMKgwqDCoMKgwqAgZGlzYWJs
ZWQKPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEh1Z2VUTEI6wqDCoCBlbmFibGVk
Cj4+Pj4+IAo+Pj4+IAo+Pj4+IEkgZGVidWdnZWQgdGhlIGNvZGUgYW5kIGZvdW5kIHRoZSBpc3N1
ZSBpcyBjYXVzZWQgYnkgdGhlIGZvbGxvd2luZwo+Pj4+IHBhdGNoLgo+Pj4+IAo+Pj4+IFtQQVRD
SCB2MyAwNi8yMV0gS1ZNOiBhcm02NDogQWRkIHN1cHBvcnQgZm9yIHN0YWdlLTIgbWFwKCkvdW5t
YXAoKSAKPj4+PiBpbiBnZW5lcmljIHBhZ2UtdGFibGUKPj4gCj4+IChJIHRoaW5rIHRoaXMgaXMg
anVzdCBhIHN5bXB0b20gb2YgdGhlIHBhZ2UtdGFibGUgYmVpbmcgb3V0IG9mIHdoYWNrKQo+PiAK
Pj4+IFNvcnJ5IHRoYXQgdGhlIGd1ZXN0IGNvdWxkIGhhbmcgc29tZXRpbWVzIHdpdGggYWJvdmUg
Y2hhbmdlcy4gSSBoYXZlIAo+Pj4gbm8gaWRlYSB3aGF0Cj4+PiBoYXMgYmVlbiBoYXBwZW5pbmcg
YmVmb3JlIEknbSBnb2luZyB0byBkZWJ1ZyBmb3IgbW9yZS4uIEknbSBwYXN0aW5nIAo+Pj4gdGhl
IHVzZWQgY29tbWFuZAo+Pj4gYW5kIG91dHB1dCBmcm9tIGd1ZXN0Lgo+PiAKPj4gQ2FuIHlvdSB0
cnkgdGhlIGRpZmYgYmVsb3csIHBsZWFzZT8gSSB0aGluayB3ZSBjYW4gZW5kIHVwIHN0aWNraW5n
IAo+PiBkb3duIGEKPj4gaHVnZS1wYWdlLXNpemVkIG1hcHBpbmcgYXQgYW4gdW5hbGlnbmVkIGFk
ZHJlc3MsIHdoaWNoIGNhdXNlcyB1cyBib3RoIAo+PiB0bwo+PiBvdmVybWFwIGFuZCBhbHNvIHRv
IGZhaWwgdG8gdXNlIHRoZSBodWdlIGdyYW51bGUgZm9yIGEgYmxvY2sgbWFwcGluZy4KPj4gCj4g
Cj4gU2luY2UgdGhlIHRoZSBmb2xsb3dpbmcgY2hhbmdlcyBoYXZlIGJlZW4gZm9sZGVkIHRvIHY0
LCBJIHJlcmFuIHRoZSAKPiB0ZXN0IGNhc2VzCj4gb24gdjQgYW5kIGV2ZXJ5dGhpbmcgd29ya3Mg
ZmluZS4KClRoYW5rcyBhIGxvdCBmb3IgdGhlIGdyZWF0IHRlc3RpbmcgYW5kIHJldmlld2luZyBl
ZmZvcnQhCgo8c2hhbWVsZXNzIGFzaz4KU2luY2UgeW91IG9idmlvdXNseSBoYXZlIGEgdGVzdCBy
aWcgc2V0dXAgZm9yIHRoaXM6IGRvZXMgeW91ciBUWDIgCnN1cHBvcnQgMTZrQgpwYWdlcz8gSWYg
c28sIGNvdWxkIHlvdSBwbGVhc2UgZG8gYW5vdGhlciBydW4gd2l0aCB0aGlzIHBhZ2Ugc2l6ZSBv
biB0aGUgCmhvc3Q/Cjwvc2hhbWVsZXNzIGFzaz4KClRoYW5rcyBhZ2FpbiwKCiAgICAgICAgIE0u
Ci0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
