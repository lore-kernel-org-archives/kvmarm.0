Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23859C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 15:17:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C076230FB
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 15:17:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C076230FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F21E94B5F8;
	Mon, 25 Jan 2021 10:17:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zOu7X5UaRKoA; Mon, 25 Jan 2021 10:17:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C64DA4B5EB;
	Mon, 25 Jan 2021 10:17:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E4C4B5E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 10:17:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l+VSWsZem-fs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 10:17:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF0B4B47B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 10:17:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 906B81042;
 Mon, 25 Jan 2021 07:17:08 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBF5E3F68F;
 Mon, 25 Jan 2021 07:17:07 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 11/12] lib: arm64: gic-v3-its: Add wmb()
 barrier before INT command
To: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
 drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
 <20201217141400.106137-12-alexandru.elisei@arm.com>
 <bb0faa84-d12f-05b7-9913-155ebfcb3073@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <91d1faad-684b-174c-8e08-1920a5eff08b@arm.com>
Date: Mon, 25 Jan 2021 15:16:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <bb0faa84-d12f-05b7-9913-155ebfcb3073@arm.com>
Content-Language: en-US
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

SGkgQW5kcmUsCgpPbiAxMi8xOC8yMCA2OjM2IFBNLCBBbmRyw6kgUHJ6eXdhcmEgd3JvdGU6Cj4g
T24gMTcvMTIvMjAyMCAxNDoxMywgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gVGhlIElUUyB0
ZXN0cyB1c2UgdGhlIElOVCBjb21tYW5kIGxpa2UgYW4gU0dJLiBUaGUgaXRzX3NlbmRfaW50KCkg
ZnVuY3Rpb24KPj4ga2lja3MgYSBDUFUgYW5kIHRoZW4gdGhlIHRlc3QgY2hlY2tzIHRoYXQgdGhl
IGludGVycnVwdCB3YXMgb2JzZXJ2ZWQgYXMKPj4gZXhwZWN0ZWQgaW4gY2hlY2tfbHBpX3N0YXRz
KCkuIFRoaXMgaXMgZG9uZSBieSB1c2luZyBscGlfc3RhdHMub2JzZXJ2ZWQgYW5kCj4+IGxwaV9z
dGF0cy5leHBlY3RlZCwgd2hlcmUgdGhlIHRhcmdldCBDUFUgb25seSB3cml0ZXMgdG8gbHBpX3N0
YXRzLm9ic2VydmVkLAo+PiBhbmQgdGhlIHNvdXJjZSBDUFUgcmVhZHMgaXQgYW5kIGNvbXBhcmVz
IHRoZSB2YWx1ZXMgd2l0aAo+PiBscGlfc3RhdHMuZXhwZWN0ZWQuCj4+Cj4+IFRoZSBmYWN0IHRo
YXQgdGhlIHRhcmdldCBDUFUgZG9lc24ndCByZWFkIGRhdGEgd3JpdHRlbiBieSB0aGUgc291cmNl
IENQVQo+PiBtZWFucyB0aGF0IHdlIGRvbid0IG5lZWQgdG8gZG8gaW50ZXItcHJvY2Vzc29yIG1l
bW9yeSBzeW5jaHJvbml6YXRpb24KPj4gZm9yIHRoYXQgYmV0d2VlbiB0aGUgdHdvIGF0IHRoZSBt
b21lbnQuCj4+Cj4+IFRoZSBhY2tlZCBhcnJheSBpcyB1c2VkIGJ5IGl0cy1wZW5kaW5nLW1pZ3Jh
dGlvbiB0ZXN0LCBidXQgdGhlIHJlc2V0IHZhbHVlCj4+IGZvciBhY2tlZCAoemVybykgaXMgdGhl
IHNhbWUgYXMgdGhlIGluaXRpYWxpemF0aW9uIHZhbHVlIGZvciBzdGF0aWMKPj4gdmFyaWFibGVz
LCBzbyBtZW1vcnkgc3luY2hyb25pemF0aW9uIGlzIGFnYWluIG5vdCBuZWVkZWQuCj4+Cj4+IEhv
d2V2ZXIsIHRoYXQgaXMgYWxsIGFib3V0IHRvIGNoYW5nZSB3aGVuIHdlIG1vZGlmeSBhbGwgSVRT
IHRlc3RzIHRvIHVzZQo+PiB0aGUgc2FtZSBmdW5jdGlvbnMgYXMgdGhlIElQSSB0ZXN0cy4gQWRk
IGEgd3JpdGUgbWVtb3J5IGJhcnJpZXIgdG8KPj4gaXRzX3NlbmRfaW50KCksIHNpbWlsYXIgdG8g
dGhlIGdpY3YzX2lwaV9zZW5kX21hc2soKSwgd2hpY2ggaGFzIHNpbWlsYXIKPj4gc2VtYW50aWNz
Lgo+IEkgYWdyZWUgdG8gdGhlIHJlcXVpcmVtZW50IGZvciBoYXZpbmcgdGhlIGJhcnJpZXIsIGJ1
dCBhbSBub3Qgc3VyZSB0aGlzCj4gaXMgdGhlIHJpZ2h0IHBsYWNlLiBXb3VsZG4ndCBpdCBiZSBi
ZXR0ZXIgdG8gaGF2ZSB0aGUgYmFycmllciBpbiB0aGUKPiBjYWxsZXJzPwo+Cj4gQmVzaWRlczog
VGhpcyBjb21tYW5kIGlzIHdyaXR0ZW4gdG8gdGhlIGNvbW1hbmQgcXVldWUgKGluIG5vcm1hbAo+
IG1lbW9yeSksIHRoZW4gd2Ugbm90aWZ5IHRoZSBJVFMgdmlhIGFuIE1NSU8gd3JpdGVxLiBBbmQg
dGhpcyBvbmUgaGFzIGEKPiAid21iIiBiYXJyaWVyIGFscmVhZHkgKHRob3VnaCBmb3Igb3RoZXIg
cmVhc29ucykuCgpIYWQgYW5vdGhlciBsb29rLCBhbmQgeW91J3JlIHRvdGFsbHkgcmlnaHQ6IGl0
c19wb3N0X2NvbW1hbmRzKCkgYWxyZWFkeSBoYXMgYQp3bWIoKSBpbiB3cml0ZXEoKSwgdGhhbmsg
eW91IGZvciBwb2ludGluZyBpdCBvdXQuIFRoaXMgbWFrZXMgdGhlIHdtYigpIHdoaWNoIEkndmUK
YWRkZWQgcG9pbnRsZXNzLCBJJ2xsIGRyb3AgdGhlIHBhdGNoIHNpbmNlIGl0IGRvZXNuJ3QgYWRk
IHVzZWZ1bC4KClRoYW5rcywKQWxleAo+Cj4gQ2hlZXJzLAo+IEFuZHJlCj4KPgo+PiBTdWdnZXN0
ZWQtYnk6IEF1Z2VyIEVyaWMgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPj4gU2lnbmVkLW9mZi1i
eTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPgo+PiAtLS0KPj4g
IGxpYi9hcm02NC9naWMtdjMtaXRzLWNtZC5jIHwgNiArKysrKysKPj4gIDEgZmlsZSBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL2xpYi9hcm02NC9naWMtdjMtaXRz
LWNtZC5jIGIvbGliL2FybTY0L2dpYy12My1pdHMtY21kLmMKPj4gaW5kZXggMzQ1NzRmNzFkMTcx
Li4zMjcwMzE0N2VlODUgMTAwNjQ0Cj4+IC0tLSBhL2xpYi9hcm02NC9naWMtdjMtaXRzLWNtZC5j
Cj4+ICsrKyBiL2xpYi9hcm02NC9naWMtdjMtaXRzLWNtZC5jCj4+IEBAIC0zODUsNiArMzg1LDEy
IEBAIHZvaWQgX19pdHNfc2VuZF9pbnQoc3RydWN0IGl0c19kZXZpY2UgKmRldiwgdTMyIGV2ZW50
X2lkLCBib29sIHZlcmJvc2UpCj4+ICB7Cj4+ICAJc3RydWN0IGl0c19jbWRfZGVzYyBkZXNjOwo+
PiAgCj4+ICsJLyoKPj4gKwkgKiBUaGUgSU5UIGNvbW1hbmQgaXMgdXNlZCBieSB0ZXN0cyBhcyBh
biBJUEkuIEVuc3VyZSBzdG9yZXMgdG8gTm9ybWFsCj4+ICsJICogbWVtb3J5IGFyZSB2aXNpYmxl
IHRvIG90aGVyIENQVXMgYmVmb3JlIHNlbmRpbmcgdGhlIExQSS4KPj4gKwkgKi8KPj4gKwl3bWIo
KTsKPj4gKwo+PiAgCWRlc2MuaXRzX2ludF9jbWQuZGV2ID0gZGV2Owo+PiAgCWRlc2MuaXRzX2lu
dF9jbWQuZXZlbnRfaWQgPSBldmVudF9pZDsKPj4gIAlkZXNjLnZlcmJvc2UgPSB2ZXJib3NlOwo+
PgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
