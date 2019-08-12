Return-Path: <SRS0=K58P=WI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0474DC433FF
	for <kvmarm@archiver.kernel.org>; Mon, 12 Aug 2019 10:39:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8DF89208C2
	for <kvmarm@archiver.kernel.org>; Mon, 12 Aug 2019 10:39:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DF89208C2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E369A4A562;
	Mon, 12 Aug 2019 06:39:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NUihMsBIfBVV; Mon, 12 Aug 2019 06:39:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6788F4A558;
	Mon, 12 Aug 2019 06:39:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B1E4A558
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Aug 2019 06:39:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8J7pYdhMnafD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Aug 2019 06:39:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 221DB4A521
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Aug 2019 06:39:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0EAD1715;
 Mon, 12 Aug 2019 03:39:19 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 250763F706;
 Mon, 12 Aug 2019 03:39:18 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH 9/9] arm64: Retrieve stolen time as paravirtualized guest
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-10-steven.price@arm.com>
 <5d763c8e-9c06-c448-2644-25bfa0e57e8c@huawei.com>
Message-ID: <07075994-3a32-8f20-23d8-1759ec2874e3@arm.com>
Date: Mon, 12 Aug 2019 11:39:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5d763c8e-9c06-c448-2644-25bfa0e57e8c@huawei.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMDkvMDgvMjAxOSAxNDo1MSwgWmVuZ2h1aSBZdSB3cm90ZToKWy4uLl0KPiBIaSBTdGV2ZW4s
Cj4gCj4gU2luY2UgdXNlcnNwYWNlIGlzIG5vdCBpbnZvbHZlZCB5ZXQgKHJpZ2h0PyksIG5vIG9u
ZSB3aWxsIGNyZWF0ZSB0aGUKPiBQVl9USU1FIGRldmljZSBmb3IgZ3Vlc3QgKGFuZCBubyBvbmUg
d2lsbCBzcGVjaWZ5IHRoZSBJUEEgb2YgdGhlIHNoYXJlZAo+IHN0b2xlbiB0aW1lIHJlZ2lvbiks
IGFuZCBJIGd1ZXNzIHdlIHdpbGwgZ2V0IGEgIm5vdCBzdXBwb3J0ZWQiIGVycm9yCj4gaGVyZS4K
PiAKPiBTbyB3aGF0IHNob3VsZCB3ZSBkbyBpZiB3ZSB3YW50IHRvIHRlc3QgdGhpcyBzZXJpZXMg
bm93P8KgIEFueSB1c2Vyc3BhY2UKPiB0b29scz/CoCBJZiBubywgZG8geW91IGhhdmUgYW55IHBs
YW5zIGZvciB1c2Vyc3BhY2UgZGV2ZWxvcGluZz8gOy0pCgpBdCB0aGUgbW9tZW50IEkgaGF2ZSB0
aGUgZm9sbG93aW5nIHBhdGNoIHRvIGt2bXRvb2wgd2hpY2ggY3JlYXRlcyB0aGUKUFZfVElNRSBk
ZXZpY2UgLSB0aGlzIGlzbid0IGluIGEgc3RhdGUgdG8gZ28gdXBzdHJlYW0sIGFuZCBNYXJjIGhh
cwphc2tlZCB0aGF0IEkgcmV3b3JrIHRoZSBtZW1vcnkgYWxsb2NhdGlvbiwgc28gdGhpcyB3aWxs
IG5lZWQgdG8gY2hhbmdlLgoKSXQncyBhIGxpdHRsZSB1Z2x5IGFzIGl0IHNpbXBseSByZXNlcnZl
cyB0aGUgZmlyc3QgcGFnZSBvZiBSQU0gdG8gdXNlCmZvciB0aGUgUFYgdGltZSBzdHJ1Y3R1cmVz
LgoKLS0tLTg8LS0tLQpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUgYi9NYWtlZmlsZQppbmRleCAzODYy
MTEyLi5hNzk5NTZiIDEwMDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtlZmlsZQpAQCAtMTU4
LDcgKzE1OCw3IEBAIGVuZGlmCiAjIEFSTQogT0JKU19BUk1fQ09NTU9OCQk6PSBhcm0vZmR0Lm8g
YXJtL2dpYy5vIGFybS9naWN2Mm0ubyBhcm0vaW9wb3J0Lm8gXAogCQkJICAgYXJtL2t2bS5vIGFy
bS9rdm0tY3B1Lm8gYXJtL3BjaS5vIGFybS90aW1lci5vIFwKLQkJCSAgIGFybS9wbXUubworCQkJ
ICAgYXJtL3BtdS5vIGFybS9wdnRpbWUubwogSERSU19BUk1fQ09NTU9OCQk6PSBhcm0vaW5jbHVk
ZQogaWZlcSAoJChBUkNIKSwgYXJtKQogCURFRklORVMJCSs9IC1EQ09ORklHX0FSTQpkaWZmIC0t
Z2l0IGEvYXJtL2ZkdC5jIGIvYXJtL2ZkdC5jCmluZGV4IGM4MGU2ZGEuLjE5ZWNjYmMgMTAwNjQ0
Ci0tLSBhL2FybS9mZHQuYworKysgYi9hcm0vZmR0LmMKQEAgLTExOSw2ICsxMTksNyBAQCBzdGF0
aWMgaW50IHNldHVwX2ZkdChzdHJ1Y3Qga3ZtICprdm0pCiAKIAkvKiBDcmVhdGUgbmV3IHRyZWUg
d2l0aG91dCBhIHJlc2VydmUgbWFwICovCiAJX0ZEVChmZHRfY3JlYXRlKGZkdCwgRkRUX01BWF9T
SVpFKSk7CisJX0ZEVChmZHRfYWRkX3Jlc2VydmVtYXBfZW50cnkoZmR0LCBrdm0tPmFyY2gubWVt
b3J5X2d1ZXN0X3N0YXJ0LCA0MDk2KSk7CiAJX0ZEVChmZHRfZmluaXNoX3Jlc2VydmVtYXAoZmR0
KSk7CiAKIAkvKiBIZWFkZXIgKi8KZGlmZiAtLWdpdCBhL2FybS9rdm0uYyBiL2FybS9rdm0uYwpp
bmRleCAxZjg1ZmM2Li44YmJmZWYxIDEwMDY0NAotLS0gYS9hcm0va3ZtLmMKKysrIGIvYXJtL2t2
bS5jCkBAIC0xMSw2ICsxMSw4IEBACiAjaW5jbHVkZSA8bGludXgva3ZtLmg+CiAjaW5jbHVkZSA8
bGludXgvc2l6ZXMuaD4KIAoraW50IHB2dGltZV9jcmVhdGUoc3RydWN0IGt2bSAqa3ZtKTsKKwog
c3RydWN0IGt2bV9leHQga3ZtX3JlcV9leHRbXSA9IHsKIAl7IERFRklORV9LVk1fRVhUKEtWTV9D
QVBfSVJRQ0hJUCkgfSwKIAl7IERFRklORV9LVk1fRVhUKEtWTV9DQVBfT05FX1JFRykgfSwKQEAg
LTg2LDYgKzg4LDEwIEBAIHZvaWQga3ZtX19hcmNoX2luaXQoc3RydWN0IGt2bSAqa3ZtLCBjb25z
dCBjaGFyICpodWdldGxiZnNfcGF0aCwgdTY0IHJhbV9zaXplKQogCS8qIENyZWF0ZSB0aGUgdmly
dHVhbCBHSUMuICovCiAJaWYgKGdpY19fY3JlYXRlKGt2bSwga3ZtLT5jZmcuYXJjaC5pcnFjaGlw
KSkKIAkJZGllKCJGYWlsZWQgdG8gY3JlYXRlIHZpcnR1YWwgR0lDIik7CisKKwkvKiBTZXR1cCBQ
ViB0aW1lICovCisJaWYgKHB2dGltZV9jcmVhdGUoa3ZtKSkKKwkJZGllKCJGYWlsZWQgdG8gaW5p
dGlhbGlzZSBQViB0aW1lIik7CiB9CiAKICNkZWZpbmUgRkRUX0FMSUdOCVNaXzJNCmRpZmYgLS1n
aXQgYS9hcm0vcHZ0aW1lLmMgYi9hcm0vcHZ0aW1lLmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5k
ZXggMDAwMDAwMC4uYWJjYWFiMwotLS0gL2Rldi9udWxsCisrKyBiL2FybS9wdnRpbWUuYwpAQCAt
MCwwICsxLDc3IEBACisjaW5jbHVkZSAia3ZtL2t2bS5oIgorCisjZGVmaW5lIEtWTV9ERVZfVFlQ
RV9BUk1fUFZfVElNRSAoS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX0lUUysyKQorCisvKiBEZXZpY2Ug
Q29udHJvbCBBUEk6IFBWX1RJTUUgKi8KKyNkZWZpbmUgS1ZNX0RFVl9BUk1fUFZfVElNRV9QQURE
UgkwCisjZGVmaW5lIEtWTV9ERVZfQVJNX1BWX1RJTUVfRlJFUVVFTkNZCTMKKworI2RlZmluZSBL
Vk1fREVWX0FSTV9QVl9USU1FX1NUCQkwCisjZGVmaW5lIEtWTV9ERVZfQVJNX1BWX1RJTUVfTFBU
CQkxCisKK3N0YXRpYyBpbnQgcHZ0aW1lX2ZkOworCitpbnQgcHZ0aW1lX2NyZWF0ZShzdHJ1Y3Qg
a3ZtICprdm0pOworCitpbnQgcHZ0aW1lX2NyZWF0ZShzdHJ1Y3Qga3ZtICprdm0pCit7CisJaW50
IGVycjsKKwl1NjQgbHB0X3BhZGRyID0gMHgxMDAwMDAwMDsKKwl1NjQgc3RfcGFkZHIgPSBscHRf
cGFkZHIgKyA0MDk2OworCXUzMiBmcmVxdWVuY3kgPSAxMDAgKiAxMDAwICogMTAwMDsKKworCXBy
aW50ZigibHB0X3BhZGRyPSVsbHhcbiIsIGxwdF9wYWRkcik7CisKKwlzdHJ1Y3Qga3ZtX2NyZWF0
ZV9kZXZpY2UgcHZ0aW1lX2RldmljZSA9IHsKKwkJLnR5cGUgPSBLVk1fREVWX1RZUEVfQVJNX1BW
X1RJTUUsCisJCS5mbGFncyA9IDAsCisJfTsKKworCWVyciA9IGlvY3RsKGt2bS0+dm1fZmQsIEtW
TV9DUkVBVEVfREVWSUNFLCAmcHZ0aW1lX2RldmljZSk7CisJaWYgKGVycikgeworCQlwcmludGYo
IkZhaWxlZCB0byBjcmVhdGUgUFYgZGV2aWNlXG4iKTsKKwkJcmV0dXJuIDA7CisJfQorCisJcHZ0
aW1lX2ZkID0gcHZ0aW1lX2RldmljZS5mZDsKKworCXN0cnVjdCBrdm1fZGV2aWNlX2F0dHIgbHB0
X2Jhc2UgPSB7CisJCS5ncm91cCA9IEtWTV9ERVZfQVJNX1BWX1RJTUVfUEFERFIsCisJCS5hdHRy
ID0gS1ZNX0RFVl9BUk1fUFZfVElNRV9MUFQsCisJCS5hZGRyID0gKHU2NCkodW5zaWduZWQgbG9u
ZykmbHB0X3BhZGRyCisJfTsKKwlzdHJ1Y3Qga3ZtX2RldmljZV9hdHRyIHN0X2Jhc2UgPSB7CisJ
CS5ncm91cCA9IEtWTV9ERVZfQVJNX1BWX1RJTUVfUEFERFIsCisJCS5hdHRyID0gS1ZNX0RFVl9B
Uk1fUFZfVElNRV9TVCwKKwkJLmFkZHIgPSAodTY0KSh1bnNpZ25lZCBsb25nKSZzdF9wYWRkcgor
CX07CisKKwlzdHJ1Y3Qga3ZtX2RldmljZV9hdHRyIGxwdF9mcmVxID0geworCQkuZ3JvdXAgPSBL
Vk1fREVWX0FSTV9QVl9USU1FX0ZSRVFVRU5DWSwKKwkJLmF0dHIgPSBLVk1fREVWX0FSTV9QVl9U
SU1FX0xQVCwKKwkJLmFkZHIgPSAodTY0KSh1bnNpZ25lZCBsb25nKSZmcmVxdWVuY3kKKwl9Owor
CisJZXJyID0gaW9jdGwocHZ0aW1lX2ZkLCBLVk1fU0VUX0RFVklDRV9BVFRSLCAmbHB0X2Jhc2Up
OworCWlmIChlcnIpIHsKKwkJcGVycm9yKCJpb2N0bCBscHRfYmFzZSBmYWlsZWQiKTsKKwkJcHJp
bnRmKCJJZ25vcmluZyBMUFQuLi5cbiIpOworCX0KKwllcnIgPSBpb2N0bChwdnRpbWVfZmQsIEtW
TV9TRVRfREVWSUNFX0FUVFIsICZzdF9iYXNlKTsKKwlpZiAoZXJyKSB7CisJCXBlcnJvcigiaW9j
dGwgc3RfYmFzZSBmYWlsZWQiKTsKKwkJZ290byBvdXRfZXJyOworCX0KKwllcnIgPSBpb2N0bChw
dnRpbWVfZmQsIEtWTV9TRVRfREVWSUNFX0FUVFIsICZscHRfZnJlcSk7CisJaWYgKGVycikgewor
CQlwZXJyb3IoImlvY3RsIGxwdF9mcmVxIGZhaWxlZCIpOworCQlwcmludGYoIklnbm9yaW5nIExQ
VC4uLlxuIik7CisJfQorCisJcHJpbnRmKCJQViB0aW1lIHNldHVwXG4iKTsKKworCXJldHVybiAw
Oworb3V0X2VycjoKKwljbG9zZShwdnRpbWVfZmQpOworCXJldHVybiBlcnI7Cit9Cl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
