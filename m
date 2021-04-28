Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC55C43461
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 13:59:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2018D61446
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 13:59:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2018D61446
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 655CF4B26E;
	Wed, 28 Apr 2021 09:59:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NEzKKsBVg5iC; Wed, 28 Apr 2021 09:59:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A1084B268;
	Wed, 28 Apr 2021 09:59:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA3564B103
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 09:59:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O6Dine40L2fD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 09:59:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48D3F4AC80
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 09:59:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81EA4ED1;
 Wed, 28 Apr 2021 06:59:39 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BCF23F882;
 Wed, 28 Apr 2021 06:59:38 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test into
 KVM and TCG variants
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
 Marc Zyngier <maz@kernel.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
 <20210428101844.22656-2-alex.bennee@linaro.org>
 <eaed3c63988513fe2849c2d6f22937af@kernel.org> <87fszasjdg.fsf@linaro.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <996210ae-9c63-54ff-1a65-6dbd63da74d2@arm.com>
Date: Wed, 28 Apr 2021 15:00:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <87fszasjdg.fsf@linaro.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGksCgpPbiA0LzI4LzIxIDE6MDYgUE0sIEFsZXggQmVubsOpZSB3cm90ZToKPiBNYXJjIFp5bmdp
ZXIgPG1hekBrZXJuZWwub3JnPiB3cml0ZXM6Cj4KPj4gT24gMjAyMS0wNC0yOCAxMToxOCwgQWxl
eCBCZW5uw6llIHdyb3RlOgo+Pj4gQSBmZXcgb2YgdGhlIGl0cy10cmlnZ2VyIHRlc3RzIHJlbHkg
b24gSU1QREVGIGJlaGF2aW91ciB3aGVyZSBjYWNoZXMKPj4+IGFyZW4ndCBmbHVzaGVkIGJlZm9y
ZSBpbnZhbGwgZXZlbnRzLiBIb3dldmVyIFRDRyBlbXVsYXRpb24gZG9lc24ndAo+Pj4gbW9kZWwg
YW55IGludmFsbCBiZWhhdmlvdXIgYW5kIGFzIHdlIGNhbid0IHByb2JlIGZvciBpdCB3ZSBuZWVk
IHRvIGJlCj4+PiB0b2xkLiBTcGxpdCB0aGUgdGVzdCBpbnRvIGEgS1ZNIGFuZCBUQ0cgdmFyaWFu
dCBhbmQgc2tpcCB0aGUgaW52YWxsCj4+PiB0ZXN0cyB3aGVuIHVuZGVyIFRDRy4KPj4+IFNpZ25l
ZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPj4+IENjOiBT
aGFzaGkgTWFsbGVsYSA8c2hhc2hpLm1hbGxlbGFAbGluYXJvLm9yZz4KPj4+IC0tLQo+Pj4gIGFy
bS9naWMuYyAgICAgICAgIHwgNjAgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tLS0tLS0tLS0KPj4+ICBhcm0vdW5pdHRlc3RzLmNmZyB8IDExICsrKysrKysrLQo+Pj4gIDIg
ZmlsZXMgY2hhbmdlZCwgNDUgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pCj4+PiBkaWZm
IC0tZ2l0IGEvYXJtL2dpYy5jIGIvYXJtL2dpYy5jCj4+PiBpbmRleCA5ODEzNWVmLi45NmEzMjlk
IDEwMDY0NAo+Pj4gLS0tIGEvYXJtL2dpYy5jCj4+PiArKysgYi9hcm0vZ2ljLmMKPj4+IEBAIC0z
Niw2ICszNiw3IEBAIHN0YXRpYyBzdHJ1Y3QgZ2ljICpnaWM7Cj4+PiAgc3RhdGljIGludCBhY2tl
ZFtOUl9DUFVTXSwgc3B1cmlvdXNbTlJfQ1BVU107Cj4+PiAgc3RhdGljIGludCBpcnFfc2VuZGVy
W05SX0NQVVNdLCBpcnFfbnVtYmVyW05SX0NQVVNdOwo+Pj4gIHN0YXRpYyBjcHVtYXNrX3QgcmVh
ZHk7Cj4+PiArc3RhdGljIGJvb2wgdW5kZXJfdGNnOwo+Pj4gIHN0YXRpYyB2b2lkIG5yX2NwdV9j
aGVjayhpbnQgbnIpCj4+PiAgewo+Pj4gQEAgLTczNCwzMiArNzM1LDM4IEBAIHN0YXRpYyB2b2lk
IHRlc3RfaXRzX3RyaWdnZXIodm9pZCkKPj4+ICAJLyoKPj4+ICAJICogcmUtZW5hYmxlIHRoZSBM
UEkgYnV0IHdpbGxpbmdseSBkbyBub3QgY2FsbCBpbnZhbGwKPj4+ICAJICogc28gdGhlIGNoYW5n
ZSBpbiBjb25maWcgaXMgbm90IHRha2VuIGludG8gYWNjb3VudC4KPj4+IC0JICogVGhlIExQSSBz
aG91bGQgbm90IGhpdAo+Pj4gKwkgKiBUaGUgTFBJIHNob3VsZCBub3QgaGl0LiBUaGlzIGRvZXMg
aG93ZXZlciBkZXBlbmQgb24KPj4+ICsJICogaW1wbGVtZW50YXRpb24gZGVmaW5lZCBiZWhhdmlv
dXIgLSB1bmRlciBRRU1VIFRDRyBlbXVsYXRpb24KPj4+ICsJICogaXQgY2FuIHF1aXRlIGNvcnJl
Y3RseSBwcm9jZXNzIHRoZSBldmVudCBkaXJlY3RseS4KPj4gSXQgbG9va3MgdG8gbWUgdGhhdCB5
b3UgYXJlIHVzaW5nIGFuIElNUERFRiBiZWhhdmlvdXIgb2YgKlRDRyoKPj4gaGVyZS4gVGhlIHBy
b2dyYW1taW5nIG1vZGVsIG1hbmRhdGVzIHRoYXQgdGhlcmUgaXMgYW4gaW52YWxpZGF0aW9uCj4+
IGlmIHlvdSBjaGFuZ2UgdGhlIGNvbmZpZ3VyYXRpb24gb2YgdGhlIExQSS4KPiBCdXQgZG9lcyBp
dCBtYW5kYXRlIHRoYXQgdGhlIExQSSBjYW5ub3QgYmUgc2VudCB1bnRpbCB0aGUgaW52YWxpZGF0
aW9uPwoKSSB0aGluayBNYXJjIGlzIHJlZmVycmluZyB0byB0aGlzIHNlY3Rpb24gb2YgdGhlIEdJ
QyBhcmNoaXRlY3R1cmUgKEFybSBJSEkgMDA2OUYsCnBhZ2UgNS04MiwgSSd2ZSBoaWdobGlnaHRl
ZCB0aGUgaW50ZXJlc3RpbmcgYml0cyk6CgoiQSBSZWRpc3RyaWJ1dG9yIGNhbiBjYWNoZSB0aGUg
aW5mb3JtYXRpb24gZnJvbSB0aGUgTFBJIENvbmZpZ3VyYXRpb24gdGFibGVzCnBvaW50ZWQgdG8g
YnkgR0lDUl9QUk9QQkFTRVIsIHdoZW4gR0lDUl9DVExSLkVuYWJsZUxQSSA9PSAxLCBzdWJqZWN0
IHRvIGFsbCBvZiB0aGUKZm9sbG93aW5nIHJ1bGVzOgoqIFdoZXRoZXIgb3Igbm90IG9uZSBvciBt
b3JlIGNhY2hlcyBhcmUgcHJlc2VudCBpcyBJTVBMRU1FTlRBVElPTiBERUZJTkVELiBXaGVyZQph
dCBsZWFzdCBvbmUgY2FjaGUgaXMgcHJlc2VudCwgdGhlIHN0cnVjdHVyZSBhbmQgc2l6ZSBpcyBJ
TVBMRU1FTlRBVElPTiBERUZJTkVELgoqIEFuIExQSSBDb25maWd1cmF0aW9uIHRhYmxlIGVudHJ5
IG1pZ2h0IGJlIGFsbG9jYXRlZCBpbnRvIHRoZSBjYWNoZSBhdCBhbnkgdGltZS4KKiBBIGNhY2hl
ZCBMUEkgQ29uZmlndXJhdGlvbiB0YWJsZSBlbnRyeSBpcyBub3QgZ3VhcmFudGVlZCB0byByZW1h
aW4gaW4gdGhlIGNhY2hlLgoqIEEgY2FjaGVkIExQSSBDb25maWd1cmF0aW9uIHRhYmxlIGVudHJ5
ICppcyBub3QgZ3VhcmFudGVlZCB0byByZW1haW4gaW5jb2hlcmVudAp3aXRoIG1lbW9yeSouCiog
QSBjaGFuZ2UgdG8gdGhlIExQSSBjb25maWd1cmF0aW9uICppcyBub3QgZ3VhcmFudGVlZCB0byBi
ZSB2aXNpYmxlIHVudGlsIGFuCmFwcHJvcHJpYXRlIGludmFsaWRhdGlvbiBvcGVyYXRpb24gaGFz
IGNvbXBsZXRlZCoiCgpJIGludGVycHJldCB0aGF0IGFzIHRoYXQgYW4gSU5WQUxMIGd1YXJhbnRl
ZXMgdGhhdCBhIGNoYW5nZSBpcyB2aXNpYmxlLCBidXQgaXQgdGhlCmNoYW5nZSBjYW4gYmVjb21l
IHZpc2libGUgZXZlbiB3aXRob3V0IHRoZSBJTlZBTEwuCgpUaGUgdGVzdCByZWxpZXMgb24gdGhl
IGZhY3QgdGhhdCBjaGFuZ2VzIHRvIHRoZSBMUEkgdGFibGVzIGFyZSBub3QgdmlzaWJsZSAqdW5k
ZXIKS1ZNKiB1bnRpbCB0aGUgSU5WQUxMIGNvbW1hbmQsIGJ1dCB0aGF0J3Mgbm90IG5lY2Vzc2Fy
aWx5IHRoZSBjYXNlIG9uIHJlYWwKaGFyZHdhcmUuIFRvIG1hdGNoIHRoZSBzcGVjLCBJIHRoaW5r
IHRoZSB0ZXN0ICJkZXYyL2V2ZW50aWQ9MjAgc3RpbGwgZG9lcyBub3QKdHJpZ2dlciBhbnkgTFBJ
IiBzaG91bGQgYmUgcmVtb3ZlZCBhbmQgdGhlIHN0YXRzIHJlc2V0IHNob3VsZCB0YWtlIHBsYWNl
IGJlZm9yZQp0aGUgY29uZmlndXJhdGlvbiBmb3IgTFBJIDgxOTUgaXMgc2V0IHRvIHRoZSBkZWZh
dWx0LgoKVGhhbmtzLAoKQWxleAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
