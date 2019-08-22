Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DF6C3A59D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:25:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4FA55233A2
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:25:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FA55233A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30ECD4A52E;
	Thu, 22 Aug 2019 05:08:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id da9CCP2ucEdq; Thu, 22 Aug 2019 05:08:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5374E4A52B;
	Thu, 22 Aug 2019 05:08:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46E3A4A52B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 05:08:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1mybpyebtnw5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 05:08:49 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C0E94A4DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 05:08:49 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 77D0E308403B;
 Thu, 22 Aug 2019 09:08:48 +0000 (UTC)
Received: from [10.36.116.105] (ovpn-116-105.ams2.redhat.com [10.36.116.105])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F88210016F3;
 Thu, 22 Aug 2019 09:08:45 +0000 (UTC)
Subject: Re: Can we boot a 512U kvm guest?
To: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
 qemu-arm@nongnu.org
References: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
Date: Thu, 22 Aug 2019 11:08:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.40]); Thu, 22 Aug 2019 09:08:48 +0000 (UTC)
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>
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

SGkgWmVuZ2h1aSwKCk9uIDgvMTMvMTkgMTA6NTAgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
Zm9sa3MsCj4gCj4gU2luY2UgY29tbWl0IGUyNTAyOGM4ZGVkMCAoIktWTTogYXJtL2FybTY0OiBC
dW1wIFZHSUNfVjNfTUFYX0NQVVMgdG8KPiA1MTIiKSwgd2Ugc2VlbWVkIHRvIGJlIGFsbG93ZWQg
dG8gYm9vdCBhIDUxMlUgZ3Vlc3QuwqAgQnV0IEkgZmFpbGVkIHRvCj4gc3RhcnQgaXQgdXAgd2l0
aCB0aGUgbGF0ZXN0IFFFTVUuwqAgSSBndWVzcyB0aGVyZSBhcmUgYXQgbGVhc3QgKnR3byoKPiBy
ZWFzb25zIChsaW1pdGF0aW9ucykuCj4gCj4gRmlyc3QgSSBnb3QgYSBRRU1VIGFib3J0Ogo+IMKg
wqDCoMKgImt2bV9zZXRfaXJxOiBJbnZhbGlkIGFyZ3VtZW50Igo+IAo+IEVuYWJsZSB0aGUgdHJh
Y2Vfa3ZtX2lycV9saW5lKCkgdW5kZXIgZGVidWdmcywgd2hlbiBpdCBjb21lZCB3aXRoCj4gdmNw
dS0yNTYsIEkgZ290Ogo+IMKgwqDCoMKgIkluamVjdCBVTktOT1dOIGludGVycnVwdCAoMyksIHZj
cHUtPmlkeDogMCwgbnVtOiAyMywgbGV2ZWw6IDAiCj4gYW5kIGt2bV92bV9pb2N0bF9pcnFfbGlu
ZSgpIHJldHVybnMgLUVJTlZBTCB0byB1c2VyLXNwYWNlLi4uCj4gCj4gU28gdGhlIHRoaW5nIGlz
IHRoYXQgd2Ugb25seSBoYXZlIDggYml0cyBmb3IgdmNwdV9pbmRleCBmaWVsZCAoWzIzOjE2XSkK
PiBpbiBLVk1fSVJRX0xJTkUgaW9jdGwuwqAgaXJxX3R5cGUgZmllbGQgd2lsbCBiZSBjb3JydXB0
ZWQgaWYgd2UgaW5qZWN0IGEKPiBQUEkgdG8gdmNwdS0yNTYsIHdob3NlIHZjcHVfaW5kZXggd2ls
bCB0YWtlIDkgYml0cy4KPiAKPiBJIHRlbXBvcmFyaWx5IHBhdGNoZWQgdGhlIEtWTSBhbmQgUUVN
VSB3aXRoIHRoZSBmb2xsb3dpbmcgZGlmZjoKPiAKPiAtLS04PC0tLQo+IGRpZmYgLS1naXQgYS9h
cmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPiBiL2FyY2gvYXJtNjQvaW5jbHVkZS91
YXBpL2FzbS9rdm0uaAo+IGluZGV4IDk1NTE2YTQuLjM5YTBmYjEgMTAwNjQ0Cj4gLS0tIGEvYXJj
aC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCj4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRl
L3VhcGkvYXNtL2t2bS5oCj4gQEAgLTMyNSwxMCArMzI1LDEwIEBAIHN0cnVjdCBrdm1fdmNwdV9l
dmVudHMgewo+IMKgI2RlZmluZcKgwqAgS1ZNX0FSTV9WQ1BVX1RJTUVSX0lSUV9QVElNRVLCoMKg
wqDCoMKgwqDCoCAxCj4gCj4gwqAvKiBLVk1fSVJRX0xJTkUgaXJxIGZpZWxkIGluZGV4IHZhbHVl
cyAqLwo+IC0jZGVmaW5lIEtWTV9BUk1fSVJRX1RZUEVfU0hJRlTCoMKgwqDCoMKgwqDCoCAyNAo+
IC0jZGVmaW5lIEtWTV9BUk1fSVJRX1RZUEVfTUFTS8KgwqDCoMKgwqDCoMKgIDB4ZmYKPiArI2Rl
ZmluZSBLVk1fQVJNX0lSUV9UWVBFX1NISUZUwqDCoMKgwqDCoMKgwqAgMjgKPiArI2RlZmluZSBL
Vk1fQVJNX0lSUV9UWVBFX01BU0vCoMKgwqDCoMKgwqDCoCAweGYKPiDCoCNkZWZpbmUgS1ZNX0FS
TV9JUlFfVkNQVV9TSElGVMKgwqDCoMKgwqDCoMKgIDE2Cj4gLSNkZWZpbmUgS1ZNX0FSTV9JUlFf
VkNQVV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhmZgo+ICsjZGVmaW5lIEtWTV9BUk1fSVJRX1ZDUFVf
TUFTS8KgwqDCoMKgwqDCoMKgIDB4ZmZmCj4gwqAjZGVmaW5lIEtWTV9BUk1fSVJRX05VTV9TSElG
VMKgwqDCoMKgwqDCoMKgIDAKPiDCoCNkZWZpbmUgS1ZNX0FSTV9JUlFfTlVNX01BU0vCoMKgwqDC
oMKgwqDCoCAweGZmZmYKPiAKPiAtLS04PC0tLQo+IAo+IEl0IG1ha2VzIHRoaW5ncyBhIGJpdCBi
ZXR0ZXIsIGl0IGFsc28gaW1tZWRpYXRlbHkgQlJFQUtzIHRoZSBhcGkgd2l0aAo+IG9sZCB2ZXJz
aW9ucy4KPiAKPiAKPiBOZXh0IGNvbWVzIG9uZSBtb3JlIFFFTVUgYWJvcnQgKHdpdGggdGhlICJm
aXgiIGFib3ZlKToKPiDCoMKgwqDCoCJGYWlsZWQgdG8gc2V0IGRldmljZSBhZGRyZXNzOiBObyBz
cGFjZSBsZWZ0IG9uIGRldmljZSIKPiAKPiBXZSByZWdpc3RlciB0d28gaW8gZGV2aWNlcyAocmRf
ZGV2IGFuZCBzZ2lfZGV2KSBvbiBLVk1fTU1JT19CVVMgZm9yCj4gZWFjaCByZWRpc3RyaWJ1dG9y
LiA1MTIgdmNwdXMgdGFrZSAxMDI0IGlvIGRldmljZXMsIHdoaWNoIGlzIGJleW9uZCB0aGUKPiBt
YXhpbXVtIGxpbWl0YXRpb24gb2YgdGhlIGN1cnJlbnQga2VybmVsIC0gTlJfSU9CVVNfREVWUyAo
MTAwMCkuCj4gU28gd2UgZ2V0IGEgRU5PU1BDIGVycm9yIGhlcmUuCgpEbyB5b3UgcGxhbiB0byBz
ZW5kIGEgcGF0Y2ggZm9yIGluY3JlYXNpbmcgdGhlIE5SX0lPQlVTX0RFVlM/IE90aGVyd2lzZQpJ
IGNhbiBkbyBpdC4KCllvdSBtZW50aW9uZWQgeW91IHN0YXJ0ZWQgd29ya2luZyBvbiB0aGUgUUVN
VSBmaXguIERvIHlvdSBwbGFuIHRvIHN1Ym1pdApwYXRjaGVzIHRvIHRoZSBNTCBvciBkbyB5b3Ug
d2FudCBtZSB0byBhdHRlbXB0IHRvIGZpeCB0aGUgc2l0dWF0aW9uIG9uCnVzZXJzcGFjZT8KClRo
YW5rcwoKRXJpYwo+IAo+IAo+IEkgZG9uJ3Qga25vdyBpZiB0aGUgc2ltaWxhciBwcm9ibGVtcyBo
YXZlIGJlZW4gZGlzY3Vzc2VkIGJlZm9yZSBpbiBNTC4KPiBJcyBpdCB0aW1lIHRvIHJlYWxseSBz
dXBwb3J0IHRoZSA1MTJVIGd1ZXN0Pwo+IAo+IAo+IFRoYW5rcywKPiB6ZW5naHVpCj4gCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
