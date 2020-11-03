Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987C4C388F2
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 11:18:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2CDC2076E
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 11:18:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2CDC2076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC5424B3CA;
	Tue,  3 Nov 2020 06:18:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vuAoLNz1W5Ff; Tue,  3 Nov 2020 06:18:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB0734B3C3;
	Tue,  3 Nov 2020 06:18:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 455E14B3C3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 06:18:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B3sUfFx8GlUs for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 06:18:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4CF54B2AD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 06:18:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AB62101E;
 Tue,  3 Nov 2020 03:18:23 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FEAE3F66E;
 Tue,  3 Nov 2020 03:18:22 -0800 (PST)
Date: Tue, 3 Nov 2020 11:18:19 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Don't hide ID registers from userspace
Message-ID: <20201103111816.GG6882@arm.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-2-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201102185037.49248-2-drjones@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: maz@kernel.org, xu910121@sina.com, kvmarm@lists.cs.columbia.edu,
 stable@vger.kernel.org
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

T24gTW9uLCBOb3YgMDIsIDIwMjAgYXQgMDc6NTA6MzVQTSArMDEwMCwgQW5kcmV3IEpvbmVzIHdy
b3RlOgo+IElEIHJlZ2lzdGVycyBhcmUgUkFaIHVudGlsIHRoZXkndmUgYmVlbiBhbGxvY2F0ZWQg
YSBwdXJwb3NlLCBidXQKPiB0aGF0IGRvZXNuJ3QgbWVhbiB0aGV5IHNob3VsZCBiZSByZW1vdmVk
IGZyb20gdGhlIEtWTV9HRVRfUkVHX0xJU1QKPiBsaXN0LiBTbyBmYXIgd2Ugb25seSBoYXZlIG9u
ZSByZWdpc3RlciwgU1lTX0lEX0FBNjRaRlIwX0VMMSwgdGhhdAo+IGlzIGhpZGRlbiBmcm9tIHVz
ZXJzcGFjZSB3aGVuIGl0cyBmdW5jdGlvbiBpcyBub3QgcHJlc2VudC4gUmVtb3ZpbmcKPiB0aGUg
dXNlcnNwYWNlIHZpc2liaWxpdHkgY2hlY2tzIGlzIGVub3VnaCB0byByZWV4cG9zZSBpdCwgYXMg
aXQKPiBhbHJlYWR5IGJlaGF2ZXMgYXMgUkFaIHdoZW4gdGhlIGZ1bmN0aW9uIGlzIG5vdCBwcmVz
ZW50LgoKUGxlYWUgc3RhdGUgd2hhdCB0aGUgcGF0Y2ggZG9lcy4gIChUaGUgc3ViamVjdCBsaW5l
IHNlcnZlcyBhcyBhIHN1bW1hcnkKb2YgdGhhdCwgYnV0IHRoZSBjb21taXQgbWVzc2FnZSBzaG91
bGQgbWFrZSBzZW5zZSB3aXRob3V0IGl0LikKCkFsc28sIGhvdyBleGFjdGx5ICF2Y3B1X2hhc19z
dmUoKSBjYXVzZXMgSURfQUE2NFpGUjBfRUwxIHRvIGJlaGF2ZSBhcwpSQVogd2l0aCB0aGlzIGNo
YW5nZT8gIChJJ20gbm90IHNheWluZyBpdCBkb2Vzbid0LCBidXQgdGhlIGNvZGUgaXMgbm90CnRy
aXZpYWwgdG8gZm9sbG93Li4uKQoKPiAKPiBGaXhlczogNzM0MzM3NjJmY2FlICgiS1ZNOiBhcm02
NC9zdmU6IFN5c3RlbSByZWdpc3RlciBjb250ZXh0IHN3aXRjaCBhbmQgYWNjZXNzIHN1cHBvcnQi
KQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NS4yKwo+IFJlcG9ydGVkLWJ5OiDl
vKDkuJzml60gPHh1OTEwMTIxQHNpbmEuY29tPgo+IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBKb25l
cyA8ZHJqb25lc0ByZWRoYXQuY29tPgo+IC0tLQo+ICBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5j
IHwgMTggKy0tLS0tLS0tLS0tLS0tLS0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMTcgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5c19y
ZWdzLmMgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCj4gaW5kZXggZmIxMmQzZWY0MjNhLi42
ZmYwYzE1NTMxY2EgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+ICsr
KyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPiBAQCAtMTE5NSwxNiArMTE5NSw2IEBAIHN0
YXRpYyB1bnNpZ25lZCBpbnQgc3ZlX3Zpc2liaWxpdHkoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LAo+ICAJcmV0dXJuIFJFR19ISURERU5fVVNFUiB8IFJFR19ISURERU5fR1VFU1Q7Cj4gIH0K
PiAgCj4gLS8qIFZpc2liaWxpdHkgb3ZlcnJpZGVzIGZvciBTVkUtc3BlY2lmaWMgSUQgcmVnaXN0
ZXJzICovCj4gLXN0YXRpYyB1bnNpZ25lZCBpbnQgc3ZlX2lkX3Zpc2liaWxpdHkoY29uc3Qgc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LAo+IC0JCQkJICAgICAgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVz
YyAqcmQpCj4gLXsKPiAtCWlmICh2Y3B1X2hhc19zdmUodmNwdSkpCj4gLQkJcmV0dXJuIDA7Cj4g
LQo+IC0JcmV0dXJuIFJFR19ISURERU5fVVNFUjsKCkluIGxpZ2h0IG9mIHRoaXMgY2hhbmdlLCBJ
IHRoaW5rIHRoYXQgUkVHX0hJRERFTl9HVUVTVCBhbmQKUkVHX0hJRERFTl9VU0VSIGFyZSBhbHdh
eXMgZWl0aGVyIGJvdGggc2V0IG9yIGJvdGggY2xlYXIuICBHaXZlbiB0aGUKZGlzY3Vzc2lvbiBv
biB0aGlzIGlzc3VlLCBJJ20gdGhpbmtpbmcgaXQgcHJvYmFibHkgZG9lc24ndCBldmVuIG1ha2UK
c2Vuc2UgZm9yIHRoZXNlIHRvIGJlIGluZGVwZW5kZW50ICg/KQoKSWYgUkVHX0hJRERFTl9VU0VS
IGlzIHJlYWxseSByZWR1bmRhbnQsIEkgc3VnZ2VzdCBzdHJpcHBpbmcgaXQgb3V0IGFuZApzaW1w
bGlmeWluZyB0aGUgY29kZSBhcHByb3ByaWF0ZWx5LgoKKEluIGVmZmVjdCwgSSB0aGluayB5b3Vy
IFJBWiBmbGFnIHdpbGwgZG8gY29ycmVjdGx5IHdoYXQgUkVHX0hJRERFTl9VU0VSCndhcyB0cnlp
bmcgdG8gYWNoaWV2ZS4pCgo+IC19Cj4gLQo+ICAvKiBHZW5lcmF0ZSB0aGUgZW11bGF0ZWQgSURf
QUE2NFpGUjBfRUwxIHZhbHVlIGV4cG9zZWQgdG8gdGhlIGd1ZXN0ICovCj4gIHN0YXRpYyB1NjQg
Z3Vlc3RfaWRfYWE2NHpmcjBfZWwxKGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiAgewo+
IEBAIC0xMjMxLDkgKzEyMjEsNiBAQCBzdGF0aWMgaW50IGdldF9pZF9hYTY0emZyMF9lbDEoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LAo+ICB7Cj4gIAl1NjQgdmFsOwo+ICAKPiAtCWlmIChXQVJOX09O
KCF2Y3B1X2hhc19zdmUodmNwdSkpKQo+IC0JCXJldHVybiAtRU5PRU5UOwo+IC0KPiAgCXZhbCA9
IGd1ZXN0X2lkX2FhNjR6ZnIwX2VsMSh2Y3B1KTsKPiAgCXJldHVybiByZWdfdG9fdXNlcih1YWRk
ciwgJnZhbCwgcmVnLT5pZCk7Cj4gIH0KPiBAQCAtMTI0Niw5ICsxMjMzLDYgQEAgc3RhdGljIGlu
dCBzZXRfaWRfYWE2NHpmcjBfZWwxKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPiAgCWludCBlcnI7
Cj4gIAl1NjQgdmFsOwo+ICAKPiAtCWlmIChXQVJOX09OKCF2Y3B1X2hhc19zdmUodmNwdSkpKQo+
IC0JCXJldHVybiAtRU5PRU5UOwo+IC0KPiAgCWVyciA9IHJlZ19mcm9tX3VzZXIoJnZhbCwgdWFk
ZHIsIGlkKTsKPiAgCWlmIChlcnIpCj4gIAkJcmV0dXJuIGVycjsKPiBAQCAtMTUxOCw3ICsxNTAy
LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2Mgc3lzX3JlZ19kZXNjc1tdID0g
ewo+ICAJSURfU0FOSVRJU0VEKElEX0FBNjRQRlIxX0VMMSksCj4gIAlJRF9VTkFMTE9DQVRFRCg0
LDIpLAo+ICAJSURfVU5BTExPQ0FURUQoNCwzKSwKPiAtCXsgU1lTX0RFU0MoU1lTX0lEX0FBNjRa
RlIwX0VMMSksIGFjY2Vzc19pZF9hYTY0emZyMF9lbDEsIC5nZXRfdXNlciA9IGdldF9pZF9hYTY0
emZyMF9lbDEsIC5zZXRfdXNlciA9IHNldF9pZF9hYTY0emZyMF9lbDEsIC52aXNpYmlsaXR5ID0g
c3ZlX2lkX3Zpc2liaWxpdHkgfSwKPiArCXsgU1lTX0RFU0MoU1lTX0lEX0FBNjRaRlIwX0VMMSks
IGFjY2Vzc19pZF9hYTY0emZyMF9lbDEsIC5nZXRfdXNlciA9IGdldF9pZF9hYTY0emZyMF9lbDEs
IC5zZXRfdXNlciA9IHNldF9pZF9hYTY0emZyMF9lbDEsIH0sCj4gIAlJRF9VTkFMTE9DQVRFRCg0
LDUpLAo+ICAJSURfVU5BTExPQ0FURUQoNCw2KSwKPiAgCUlEX1VOQUxMT0NBVEVEKDQsNyksCgpP
dGhlcndpc2UgbG9va3MgcmVhc29uYWJsZS4KCkNoZWVycwotLS1EYXZlCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
