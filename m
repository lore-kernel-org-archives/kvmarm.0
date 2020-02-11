Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6575C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 15:32:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59AC22082F
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 15:32:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59AC22082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E07DB4A955;
	Tue, 11 Feb 2020 10:32:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BRm+1fCRWgD9; Tue, 11 Feb 2020 10:32:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFB124AE87;
	Tue, 11 Feb 2020 10:32:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4D774ACF3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 10:32:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vdaGCg5DqK-z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 10:32:30 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 643D04A955
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 10:32:30 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 825A2710FE4D5A09D668;
 Tue, 11 Feb 2020 23:32:25 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 11 Feb 2020
 23:32:15 +0800
Subject: Re: [PATCH kvm-unit-tests v2] arm64: timer: Speed up gic-timer-state
 check
From: Zenghui Yu <yuzenghui@huawei.com>
To: Andrew Jones <drjones@redhat.com>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>
References: <20200211133705.1398-1-drjones@redhat.com>
 <60c6c4c7-1d6b-5b64-adc1-8e96f45332c6@huawei.com>
Message-ID: <83803119-0ea8-078d-628b-537c3d9525b1@huawei.com>
Date: Tue, 11 Feb 2020 23:32:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <60c6c4c7-1d6b-5b64-adc1-8e96f45332c6@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
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

T24gMjAyMC8yLzExIDIyOjUwLCBaZW5naHVpIFl1IHdyb3RlOgo+IEhpIERyZXcsCj4gCj4gT24g
MjAyMC8yLzExIDIxOjM3LCBBbmRyZXcgSm9uZXMgd3JvdGU6Cj4+IExldCdzIGJhaWwgb3V0IG9m
IHRoZSB3YWl0IGxvb3AgaWYgd2Ugc2VlIHRoZSBleHBlY3RlZCBzdGF0ZQo+PiB0byBzYXZlIG92
ZXIgc2l4IHNlY29uZHMgb2YgcnVuIHRpbWUuIE1ha2Ugc3VyZSB3ZSB3YWl0IGEgYml0Cj4+IGJl
Zm9yZSByZWFkaW5nIHRoZSByZWdpc3RlcnMgYW5kIGRvdWJsZSBjaGVjayBhZ2FpbiBhZnRlciwK
Pj4gdGhvdWdoLCB0byBzb21ld2hhdCBtaXRpZ2F0ZSB0aGUgY2hhbmNlIG9mIHNlZWluZyB0aGUg
ZXhwZWN0ZWQKPj4gc3RhdGUgYnkgYWNjaWRlbnQuCj4+Cj4+IFdlIGFsc28gdGFrZSB0aGlzIG9w
cG9ydHVuaXR5IHRvIHB1c2ggbW9yZSBJUlEgc3RhdGUgY29kZSB0bwo+PiB0aGUgbGlicmFyeS4K
Pj4KPj4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+Cj4g
Cj4gWy4uLl0KPiAKPj4gKwo+PiArZW51bSBnaWNfaXJxX3N0YXRlIGdpY19pcnFfc3RhdGUoaW50
IGlycSkKPiAKPiBUaGlzIGlzIGEgKmdlbmVyaWMqIG5hbWUgd2hpbGUgdGhpcyBmdW5jdGlvbiBv
bmx5IGRlYWxzIHdpdGggUFBJLgo+IE1heWJlIHdlIGNhbiB1c2Ugc29tZXRoaW5nIGxpa2UgZ2lj
X3BwaV9zdGF0ZSgpIGluc3RlYWQ/wqAgT3IgeW91Cj4gd2lsbCBoYXZlIHRvIHRha2UgYWxsIGlu
dGVycnVwdCB0eXBlcyBpbnRvIGFjY291bnQgaW4gYSBzaW5nbGUKPiBmdW5jdGlvbiwgd2hpY2gg
aXMgbm90IGEgZWFzeSBqb2IgSSB0aGluay4KCkp1c3QgdG8gZm9sbG93IHVwLCBnaWNfaXJxX2dl
dF9pcnFjaGlwX3N0YXRlKCkvZ2ljX3BlZWtfaXJxKCkgWypdIGlzCnRoZSBMaW51eCBpbXBsZW1l
bnRhdGlvbiBvZiB0aGlzIGZvciBQUElzIGFuZCBTUElzLgoKWypdIGxpbnV4L2RyaXZlcnMvaXJx
Y2hpcC9pcnEtZ2ljLXYzLmMKCgpUaGFua3MsClplbmdodWkKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
