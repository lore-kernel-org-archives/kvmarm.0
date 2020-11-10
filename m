Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C448C388F7
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 11:13:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A43B42076E
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 11:13:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A43B42076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C02774B7FE;
	Tue, 10 Nov 2020 06:13:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sbk8Jm9G1oFv; Tue, 10 Nov 2020 06:13:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7FE04B7F5;
	Tue, 10 Nov 2020 06:13:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 316724B7F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 06:13:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gcm3MOQAFeT9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 06:13:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD58A4B7EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 06:13:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79E0812FC;
 Tue, 10 Nov 2020 03:13:09 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C45623F6CF;
 Tue, 10 Nov 2020 03:13:08 -0800 (PST)
Date: Tue, 10 Nov 2020 11:13:05 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 0/4] KVM: arm64: Fix get-reg-list regression
Message-ID: <20201110111304.GK6882@arm.com>
References: <20201105091022.15373-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201105091022.15373-1-drjones@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: maz@kernel.org, xu910121@sina.com, kvmarm@lists.cs.columbia.edu
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

T24gVGh1LCBOb3YgMDUsIDIwMjAgYXQgMTA6MTA6MThBTSArMDEwMCwgQW5kcmV3IEpvbmVzIHdy
b3RlOgo+IOW8oOS4nOaXrSA8eHU5MTAxMjFAc2luYS5jb20+IHJlcG9ydGVkIGEgcmVncmVzc2lv
biBzZWVuIHdpdGggQ2VudE9TCj4gd2hlbiBtaWdyYXRpbmcgZnJvbSBhbiBvbGQga2VybmVsIHRv
IGEgbmV3IG9uZS4gVGhlIHByb2JsZW0gd2FzCj4gdGhhdCBRRU1VIHJlamVjdGVkIHRoZSBtaWdy
YXRpb24gc2luY2UgS1ZNX0dFVF9SRUdfTElTVCByZXBvcnRlZAo+IGEgcmVnaXN0ZXIgd2FzIG1p
c3Npbmcgb24gdGhlIGRlc3RpbmF0aW9uLiBFeHRyYSByZWdpc3RlcnMgYXJlIE9LCj4gb24gdGhl
IGRlc3RpbmF0aW9uLCBidXQgbm90IG1pc3Npbmcgb25lcy4gVGhlIHJlZ3Jlc3Npb24gcmVwcm9k
dWNlcwo+IHdpdGggdXBzdHJlYW0ga2VybmVscyB3aGVuIG1pZ3JhdGluZyBmcm9tIGEgNC4xNSBv
ciBsYXRlciBrZXJuZWwsCj4gdXAgdG8gb25lIHdpdGggY29tbWl0IDczNDMzNzYyZmNhZSAoIktW
TTogYXJtNjQvc3ZlOiBTeXN0ZW0gcmVnaXN0ZXIKPiBjb250ZXh0IHN3aXRjaCBhbmQgYWNjZXNz
IHN1cHBvcnQiKSwgdG8gYSBrZXJuZWwgdGhhdCBpbmNsdWRlcyB0aGF0Cj4gY29tbWl0LCBlLmcu
IHRoZSBsYXRlc3QgbWFpbmxpbmUgKDUuMTAtcmMyKS4KPiAKPiBUaGUgZmlyc3QgcGF0Y2ggb2Yg
dGhpcyBzZXJpZXMgaXMgdGhlIGZpeC4gVGhlIG5leHQgdHdvIHBhdGNoZXMsCj4gd2hpY2ggZG9u
J3QgaGF2ZSBhbnkgaW50ZW5kZWQgZnVuY3Rpb25hbCBjaGFuZ2VzLCBhbGxvdyBJRF9TQU5JVElT
RUQKPiB0byBiZSB1c2VkIGZvciByZWdpc3RlcnMgdGhhdCBmbGlwIGJldHdlZW4gZXhwb3Npbmcg
ZmVhdHVyZXMgYW5kCj4gYmVpbmcgUkFaLCB3aGljaCBhbGxvd3Mgc29tZSBjb2RlIHRvIGJlIHJl
bW92ZWQuCj4gCj4gdjM6Cj4gIC0gSW1wcm92ZSBjb21taXQgbWVzc2FnZXMgW0RhdmVdCj4gIC0g
QWRkIG5ldyBwYXRjaCB0byBjb25zb2xpZGF0ZSBSRUdfSElEREVOKiBmbGFncyBbRGF2ZV0KPiAK
PiB2MjoKPiAgLSBDQyBzdGFibGUgW01hcmNdCj4gIC0gT25seSBvbmUgUkFaIGZsYWcgaXMgZW5v
dWdoIFtNYXJjXQo+ICAtIE1vdmUgaWRfdmlzaWJpbGl0eSgpIHVwIGJ5IHJlYWRfaWRfcmVnKCkg
c2luY2UgdGhleSdsbCBsaWtlbHkKPiAgICBiZSBtYWludGFpbmVkIHRvZ2V0aGVyIFtkcmV3XQo+
IAo+IAo+IEFuZHJldyBKb25lcyAoNCk6Cj4gICBLVk06IGFybTY0OiBEb24ndCBoaWRlIElEIHJl
Z2lzdGVycyBmcm9tIHVzZXJzcGFjZQo+ICAgS1ZNOiBhcm02NDogQ29uc29saWRhdGUgUkVHX0hJ
RERFTl9HVUVTVC9VU0VSCj4gICBLVk06IGFybTY0OiBDaGVjayBSQVogdmlzaWJpbGl0eSBpbiBJ
RCByZWdpc3RlciBhY2Nlc3NvcnMKPiAgIEtWTTogYXJtNjQ6IFJlbW92ZSBBQTY0WkZSMF9FTDEg
YWNjZXNzb3JzCj4gCj4gIGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMgfCAxMDggKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3Mu
aCB8ICAxNiArKystLS0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA0MSBpbnNlcnRpb25zKCspLCA4MyBk
ZWxldGlvbnMoLSkKClRoYW5rcyBmb3IgdGhlIHVwZGF0ZXMuCgpMb29rcyBsaWtlIEkgbWlzc2Vk
IHRoZSBvcHBvcnR1bml0eSB0byByZXZpZXcgdGhpcywgYnV0IGp1c3QgZm9yIHRoZQpyZWNvcmQg
KGV2ZW4gaWYgaXQgZG9lc24ndCBhcHBlYXIgaW4gdGhlIHRyZWUpOgoKUmV2aWV3ZWQtYnk6IERh
dmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgoKQ2hlZXJzCi0tLURhdmUKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
