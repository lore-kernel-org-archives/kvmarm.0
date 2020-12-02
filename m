Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0685C64E7B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 14:24:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1631221EB
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 14:24:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1631221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C65F4B3BC;
	Wed,  2 Dec 2020 09:24:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4F+c+3Jpz4IB; Wed,  2 Dec 2020 09:24:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B684B348;
	Wed,  2 Dec 2020 09:24:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35A154B340
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 09:24:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RL5F5D+z-v1q for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 09:24:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0B3F4B32C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 09:24:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 939DD30E;
 Wed,  2 Dec 2020 06:24:34 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A050C3F718;
 Wed,  2 Dec 2020 06:24:33 -0800 (PST)
Subject: Re: [RFC PATCH v3 01/16] KVM: arm64: Initialize VCPU mdcr_el2 before
 loading it
To: James Morse <james.morse@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-2-alexandru.elisei@arm.com>
 <2058bc39-b2ea-602e-8e94-6caf470151ec@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <6103d61d-d22e-218e-0618-7cb7ee27ac82@arm.com>
Date: Wed, 2 Dec 2020 14:25:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <2058bc39-b2ea-602e-8e94-6caf470151ec@arm.com>
Content-Language: en-US
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

SGkgSmFtZXMsCgpNYW55IHRoYW5rcyBmb3IgaGF2aW5nIGEgbG9vayBhdCB0aGUgc2VyaWVzIQoK
T24gMTEvMTkvMjAgNDo1OCBQTSwgSmFtZXMgTW9yc2Ugd3JvdGU6Cj4gSGkgQWxleCwKPgo+IE9u
IDI3LzEwLzIwMjAgMTc6MjYsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+IFdoZW4gYSBWQ1BV
IGlzIGNyZWF0ZWQsIHRoZSBrdm1fdmNwdSBzdHJ1Y3QgaXMgaW5pdGlhbGl6ZWQgdG8gemVybyBp
bgo+PiBrdm1fdm1faW9jdGxfY3JlYXRlX3ZjcHUoKS4gT24gVkhFIHN5c3RlbXMsIHRoZSBmaXJz
dCB0aW1lCj4+IHZjcHUuYXJjaC5tZGNyX2VsMiBpcyBsb2FkZWQgb24gaGFyZHdhcmUgaXMgaW4g
dmNwdV9sb2FkKCksIGJlZm9yZSBpdCBpcwo+PiBzZXQgdG8gYSBzZW5zaWJsZSB2YWx1ZSBpbiBr
dm1fYXJtX3NldHVwX2RlYnVnKCkgbGF0ZXIgaW4gdGhlIHJ1biBsb29wLiBUaGUKPj4gcmVzdWx0
IGlzIHRoYXQgS1ZNIGV4ZWN1dGVzIGZvciBhIHNob3J0IHRpbWUgd2l0aCBNRENSX0VMMiBzZXQg
dG8gemVyby4KPj4KPj4gVGhpcyBpcyBtb3N0bHkgaGFybWxlc3MgYXMgd2UgZG9uJ3QgbmVlZCB0
byB0cmFwIGRlYnVnIGFuZCBTUEUgcmVnaXN0ZXIKPj4gYWNjZXNzZXMgZnJvbSBFTDEgKHdlJ3Jl
IHN0aWxsIHJ1bm5pbmcgaW4gdGhlIGhvc3QgYXQgRUwyKSwgYnV0IHdlIGRvIHNldAo+PiBNRENS
X0VMMi5IUE1OIHRvIDAgd2hpY2ggaXMgY29uc3RyYWluZWQgdW5wcmVkaWN0YWJsZSBhY2NvcmRp
bmcgdG8gQVJNIERESQo+PiAwNDg3Ri5iLCBwYWdlIEQxMy0zNjIwOyB0aGUgcmVxdWlyZWQgYmVo
YXZpb3IgZnJvbSB0aGUgaGFyZHdhcmUgaW4gdGhpcwo+PiBjYXNlIGlzIHRvIHJlc2VydmUgYW4g
dW5rb3duIG51bWJlciBvZiByZWdpc3RlcnMgZm9yIEVMMiBhbmQgRUwzIGV4Y2x1c2l2ZQo+PiB1
c2UuCj4+Cj4+IEluaXRpYWxpemUgbWRjcl9lbDIgaW4ga3ZtX3ZjcHVfdmNwdV9maXJzdF9ydW5f
aW5pdCgpLCBzbyB3ZSBjYW4gYXZvaWQgdGhlCj4+IGNvbnN0cmFpbmVkIHVucHJlZGljdGFibGUg
YmVoYXZpb3IgYW5kIHRvIGVuc3VyZSB0aGF0IHRoZSBNRENSX0VMMiByZWdpc3Rlcgo+PiBoYXMg
dGhlIHNhbWUgdmFsdWUgYWZ0ZXIgZWFjaCB2Y3B1X2xvYWQoKSwgaW5jbHVkaW5nIHRoZSBmaXJz
dCB0aW1lIHRoZQo+PiBWQ1BVIGlzIHJ1bi4KPgo+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9r
dm0vZGVidWcuYyBiL2FyY2gvYXJtNjQva3ZtL2RlYnVnLmMKPj4gaW5kZXggN2E3ZTQyNTYxNmI1
Li4yMmVlNDQ4YWVlMmIgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2RlYnVnLmMKPj4g
KysrIGIvYXJjaC9hcm02NC9rdm0vZGVidWcuYwo+PiBAQCAtNjgsNiArNjgsNTkgQEAgdm9pZCBr
dm1fYXJtX2luaXRfZGVidWcodm9pZCkKPj4gK3N0YXRpYyB2b2lkIGt2bV9hcm1fc2V0dXBfbWRj
cl9lbDIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgaG9zdF9tZGNyKQo+PiArewo+PiArCWJv
b2wgdHJhcF9kZWJ1ZyA9ICEodmNwdS0+YXJjaC5mbGFncyAmIEtWTV9BUk02NF9ERUJVR19ESVJU
WSk7Cj4+ICsKPj4gKwkvKgo+PiArCSAqIFRoaXMgYWxzbyBjbGVhcnMgTURDUl9FTDJfRTJQQl9N
QVNLIHRvIGRpc2FibGUgZ3Vlc3QgYWNjZXNzCj4+ICsJICogdG8gdGhlIHByb2ZpbGluZyBidWZm
ZXIuCj4+ICsJICovCj4+ICsJdmNwdS0+YXJjaC5tZGNyX2VsMiA9IGhvc3RfbWRjciAmIE1EQ1Jf
RUwyX0hQTU5fTUFTSzsKPj4gKwl2Y3B1LT5hcmNoLm1kY3JfZWwyIHw9IChNRENSX0VMMl9UUE0g
fAo+PiArCQkJCU1EQ1JfRUwyX1RQTVMgfAo+PiArCQkJCU1EQ1JfRUwyX1RQTUNSIHwKPj4gKwkJ
CQlNRENSX0VMMl9URFJBIHwKPj4gKwkJCQlNRENSX0VMMl9URE9TQSk7Cj4+ICsJaWYgKHZjcHUt
Pmd1ZXN0X2RlYnVnKSB7Cj4+ICsJCS8qIFJvdXRlIGFsbCBzb2Z0d2FyZSBkZWJ1ZyBleGNlcHRp
b25zIHRvIEVMMiAqLwo+PiArCQl2Y3B1LT5hcmNoLm1kY3JfZWwyIHw9IE1EQ1JfRUwyX1RERTsK
Pj4gKwkJaWYgKHZjcHUtPmd1ZXN0X2RlYnVnICYgS1ZNX0dVRVNUREJHX1VTRV9IVykKPj4gKwkJ
CXRyYXBfZGVidWcgPSB0cnVlOwo+PiArCX0KPiBUaGlzIGhhZCBtZSBjb25mdXNlZCBmb3IgYSB3
aGlsZS4uLiBjb3VsZCB5b3UgaGludCB0aGF0IHRoaXMgaXMgd2hlbiB0aGUgZ3Vlc3QgaXMgYmVp
bmcKPiAnZXh0ZXJuYWwnIGRlYnVnZ2VkIGJ5IHRoZSBWTU0/IChpdHMgY2xlYXItZXIgYmVmb3Jl
IHRoaXMgY2hhbmdlKQoKSSBjYW4gcHV0IGEgY29tbWVudCBhYm92ZSB0aGUgaWYgc3RhdGVtZW50
IHNpbWlsYXIgdG8gdGhlIG9uZSBmcm9tCmt2bV9hcm1fc2V0dXBfZGVidWcoKSwgd2hlcmUgdGhp
cyBjb2RlIGlzIGxpZnRlZCBmcm9tOgoKwqDCoMKgwqDCoMKgwqAgLyogSXMgdGhlIFZDUFUgYmVp
bmcgZGVidWdnZWQgYnkgdXNlcnNwYWNlPyAqLwoKV2hhdCBkbyB5b3UgdGhpbms/CgpUaGFua3Ms
CkFsZXgKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
