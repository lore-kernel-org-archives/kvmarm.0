Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF7FC433E5
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:26:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62CEF2063A
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="z5HKSUqw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62CEF2063A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF02F4BF71;
	Mon, 17 Aug 2020 04:26:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QQRw2kBiNSrR; Mon, 17 Aug 2020 04:26:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB5C74BF60;
	Mon, 17 Aug 2020 04:26:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE3B94BD34
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:26:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K6uWVmhWq8gM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 04:26:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D45B84BD2D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:26:21 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A194E207FB;
 Mon, 17 Aug 2020 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597652780;
 bh=DqrhFlbqsLKUbQeyFxnK0Kuuu4I7hstm5T+jbg9Evrs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=z5HKSUqwTqfvkxm/ePqE7aOX/IGBddSo4Kyjs9A8hSnGpHylUuJGDOnFkjOlw/U9/
 KkOnC5r+iRVraYQqDayVeenJpwxRA/QR7yvL/ExiGB4i1R3UUqOiA505g8nDnqlgjz
 j4tbijNIWMeZjXw/IpTb/plWqL1YNjPdC6fGZRKM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k7aTD-003UEx-7D; Mon, 17 Aug 2020 09:26:19 +0100
MIME-Version: 1.0
Date: Mon, 17 Aug 2020 09:26:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
In-Reply-To: <d9aa5414-490e-179f-d789-3c929ffe0727@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
 <0bd81d1da9040fce660af46763507ac2@kernel.org>
 <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
 <b175763e4f4f08ecdae46e6e87b0bc81@kernel.org>
 <d9aa5414-490e-179f-d789-3c929ffe0727@huawei.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <9d2dcee37f9c2509cb9556f74b6f5277@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com,
 wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

T24gMjAyMC0wOC0xNyAwMjo0NiwgSmluZ3lpIFdhbmcgd3JvdGU6Cj4gT24gOC8xMS8yMDIwIDM6
NDkgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMC0wOC0xMSAwMjo0OCwgSmluZ3lp
IFdhbmcgd3JvdGU6CgpbLi4uXQoKPj4+IEFzIEkgbWVudGlvbmVkIGJlZm9yZSwgd2Ugd2FudCB0
byBhZGQgdkxQSSBkaXJlY3QgaW5qZWN0aW9uIHRlc3QKPj4+IGluIEtVVCwgbWVhbndoaWxlIG1l
YXN1cmUgdGhlIGxhdGVuY3kgb2YgaGFyZHdhcmUgdkxQSSBpbmplY3Rpb24uCj4+PiAKPj4+IFN1
cmUsIHZMUEkgaXMgdHJpZ2dlcmVkIGJ5IGhhcmR3YXJlLiBTaW5jZSBrZXJuZWwgc3VwcG9ydHMg
c2VuZGluZwo+Pj4gSVRTIElOVCBjb21tYW5kIGluIGd1ZXN0IHRvIHRyaWdnZXIgdkxQSSwgSSB3
b25kZXIgaWYgaXQgaXMgcG9zc2libGUKPj4gCj4+IFNvIGNhbiB0aGUgaG9zdC4KPj4gCj4+PiB0
byBhZGQgYW4gZXh0cmEgaW50ZXJmYWNlIHRvIG1ha2UgYSB2TFBJIGhhcmR3YXJlLW9mZmxvYWQo
anVzdCBhcwo+Pj4ga3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoKSBkb2VzKS4gSWYgc28sIHZn
aWNfaXRzX3RyaWdnZXJfbXNpKCkKPj4+IGNhbiBpbmplY3QgdkxQSSBkaXJlY3RseSBpbnN0ZWFk
IG9mIHVzaW5nIExSLgo+PiAKPj4gVGhlIGludGVyZmFjZSBleGlzdHMsIGl0IGlzIGluIGRlYnVn
ZnMuIEJ1dCBpdCBtYW5kYXRlcyB0aGF0IHRoZQo+PiBkZXZpY2UgZXhpc3RzLiBBbmQgbm8sIEkg
YW0gbm90IHdpbGxpbmcgdG8gYWRkIGFuIGV4dHJhIEtWTSB1c2Vyc3BhY2UKPj4gQVBJIGZvciB0
aGlzLgo+PiAKPj4gVGhlIHdob2xlIGNvbmNlcHQgb2YgaW5qZWN0aW5nIGFuIElOVCB0byBtZWFz
dXJlIHRoZSBwZXJmb3JtYW5jZQo+PiBvZiBHSUN2NCBpcyBzbGlnaHRseSBib25rZXJzLCBhY3R1
YWxseS4gTW9zdCBvZiB0aGUgY29zdCBpcyBwYWlkCj4+IG9uIHRoZSBpbmplY3Rpb24gcGF0aCAo
cXVldWluZyBhIHBhaXIgb2YgY29tbWFuZCwgd2FpdGluZyB1bnRpbAo+PiB0aGUgSVRTIHdha2Vz
IHVwIGFuZCBnZW5lcmF0ZSB0aGUgc2lnbmFsLi4uKS4KPj4gCj4+IFdoYXQgeW91IHJlYWxseSB3
YW50IHRvIG1lYXN1cmUgaXMgdGhlIHRpbWUgZnJvbSBnZW5lcmF0aW9uIG9mCj4+IHRoZSBMUEkg
YnkgYSBkZXZpY2UgdW50aWwgdGhlIGd1ZXN0IGFja25vd2xlZGdlcyB0aGUgaW50ZXJydXB0Cj4+
IHRvIHRoZSBkZXZpY2UgaXRzZWxmLiBhbmQgdGhpcyBjYW4gb25seSBiZSBpbXBsZW1lbnRlZCBp
biB0aGUKPj4gZGV2aWNlLgo+PiAKPj4gIMKgwqDCoMKgwqDCoMKgIE0uCj4gCj4gT0sgdW5kZXJz
dG9vZC4gSSBqdXN0IHRob3VnaHQgbWVhc3VyaW5nIHRoZSBsYXRlbmN5IG9mIHRoZSBwYXRoCj4g
a3ZtLT5ndWVzdCBjYW4gYmUgdXNlZnVsLgoKVGhhdCdzIHRoZSBwcm9ibGVtLiBUaGVyZSBpcyBu
byB3YXkgeW91IGNhbiBpbXBsZW1lbnQgdGhpcywgYmVjYXVzZQp5b3UgY2Fubm90IGRpc3Rpbmd1
aXNoIGluamVjdGlvbiBsYXRlbmN5IGZyb20gdGhlIGRlbGl2ZXJ5IGxhdGVuY3kuCkFuZCBmcmFu
a2x5LCBpdCBkb2Vzbid0IG1hdHRlciwgYmVjYXVzZSB0aGUgaHlwZXJ2aXNvciBpcyBub3Qgb24K
dGhhdCBwYXRoIGF0IGFsbCAoaWYgaXQgaXMgc2xvdywgdGhhdCdzIGJlY2F1c2UgdGhlIEhXIGlz
IHNsb3csIGFuZAp5b3UgY2FuJ3QgY2hhbmdlIGFueXRoaW5nIGluIEtWTSB0byBtYWtlIGl0IGJl
dHRlcikuCgpPbiB0aGUgb3RoZXIgaGFuZCwgbWVhc3VyaW5nIHRoZSBsYXRlbmN5IG9mIGEgZ3Vl
c3QgYmVpbmcgc2NoZWR1bGVkCmJhY2sgaW4gd2hlbiBibG9ja2VkIG9uIFdGSSB3b3VsZCBiZSBt
dWNoIG1vcmUgcmVsZXZhbnQsIGFzIHRoaXMgaXMKZXhhY3RseSB3aGF0IHdvdWxkIGhhcHBlbiBv
biBkZWxpdmVyeSBvZiBhIGRvb3JiZWxsLgoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRl
YWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
