Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B75C433E5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 14:52:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D5C32078E
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 14:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D5C32078E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D53064B260;
	Mon, 27 Jul 2020 10:52:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fRMGqEM6-9xL; Mon, 27 Jul 2020 10:52:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D80374B267;
	Mon, 27 Jul 2020 10:52:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D174B1A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 10:52:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cfj7tRbCfDlj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 10:51:58 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F0294B158
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 10:51:58 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 1CF99BE30548D6D8FEA0;
 Mon, 27 Jul 2020 22:51:52 +0800 (CST)
Received: from [127.0.0.1] (10.174.186.173) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0;
 Mon, 27 Jul 2020 22:51:43 +0800
Subject: Re: [RESEND RFC PATCH v1] arm64: kvm: flush tlbs by range in
 unmap_stage2_range function
To: Marc Zyngier <maz@kernel.org>
References: <20200724134315.805-1-yezhenyu2@huawei.com>
 <5d54c860b3b4e7a98e4d53397e6424ae@kernel.org>
From: Zhenyu Ye <yezhenyu2@huawei.com>
Message-ID: <f74277fd-5af2-c46f-169f-c15a321165cd@huawei.com>
Date: Mon, 27 Jul 2020 22:51:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5d54c860b3b4e7a98e4d53397e6424ae@kernel.org>
X-Originating-IP: [10.174.186.173]
X-CFilter-Loop: Reflected
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, steven.price@arm.com, linux-mm@kvack.org,
 arm@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

SGkgTWFyYywKCk9uIDIwMjAvNy8yNiAxOjQwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAy
MC0wNy0yNCAxNDo0MywgWmhlbnl1IFllIHdyb3RlOgo+PiBOb3cgaW4gdW5tYXBfc3RhZ2UyX3Jh
bmdlKCksIHdlIGZsdXNoIHRsYnMgb25lIGJ5IG9uZSBqdXN0IGFmdGVyIHRoZQo+PiBjb3JyZXNw
b25kaW5nIHBhZ2VzIGNsZWFyZWQuwqAgSG93ZXZlciwgdGhpcyBtYXkgY2F1c2Ugc29tZSBwZXJm
b3JtYW5jZQo+PiBwcm9ibGVtcyB3aGVuIHRoZSB1bm1hcCByYW5nZSBpcyB2ZXJ5IGxhcmdlIChz
dWNoIGFzIHdoZW4gdGhlIHZtCj4+IG1pZ3JhdGlvbiByb2xsYmFjaywgdGhpcyBtYXkgY2F1c2Ug
dm0gZG93bnRpbWUgdG9vIGxvb2cpLgo+IAo+IFlvdSBrZWVwIHJlc2VuZGluZyB0aGlzIHBhdGNo
LCBidXQgeW91IGRvbid0IGdpdmUgYW55IG51bWJlcnMKPiB0aGF0IHdvdWxkIGJhY2sgeW91ciBh
c3NlcnRpb24uCgpJIGhhdmUgdGVzdGVkIHRoZSBkb3dudGltZSBvZiB2bSBtaWdyYXRpb24gcm9s
bGJhY2sgb24gYXJtNjQsIGFuZCBmb3VuZAp0aGUgZG93bnRpbWUgY291bGQgZXZlbiB0YWtlIHVw
IHRvIDdzLiAgVGhlbiBJIHRyYWNlZCB0aGUgY29zdCBvZgp1bm1hcF9zdGFnZTJfcmFuZ2UoKSBh
bmQgZm91bmQgaXQgY291bGQgdGFrZSBhIG1heGltdW0gb2YgMS4ycy4gIFRoZQp2bSBjb25maWd1
cmF0aW9uIGlzIGFzIGZvbGxvd3MgKHdpdGggaGlnaCBtZW1vcnkgcHJlc3N1cmUsIHRoZSBkaXJ0
eQpyYXRlIGlzIGFib3V0IDUwME1CL3MpOgoKICA8bWVtb3J5IHVuaXQ9J0dpQic+MTkyPC9tZW1v
cnk+CiAgPHZjcHUgcGxhY2VtZW50PSdzdGF0aWMnPjQ4PC92Y3B1PgogIDxtZW1vcnlCYWNraW5n
PgogICAgPGh1Z2VwYWdlcz4KICAgICAgPHBhZ2Ugc2l6ZT0nMScgdW5pdD0nR2lCJyBub2Rlc2V0
PScwJy8+CiAgICA8L2h1Z2VwYWdlcz4KICA8L21lbW9yeUJhY2tpbmc+CgpBZnRlciB0aGlzIHBh
dGNoIGFwcGxpZWQsIHRoZSBjb3N0IG9mIHVubWFwX3N0YWdlMl9yYW5nZSgpIGNhbiByZWR1Y2Ug
dG8KMTZtcywgYW5kIFZNIGRvd250aW1lIGNhbiBiZSBsZXNzIHRoYW4gMXMuCgpUaGUgZm9sbG93
aW5nIGZpZ3VyZSBzaG93cyBhIGNsZWFyIGNvbXBhcmlzb246CgoJICAgICAgfAl2bSBkb3dudGlt
ZSAgfAljb3N0IG9mIHVubWFwX3N0YWdlMl9yYW5nZSgpCi0tLS0tLS0tLS0tLS0tKy0tLS0tLS0t
LS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KYmVmb3JlIGNoYW5nZSB8
CQk3cyAgIHwJCTEyMDAgbXMKYWZ0ZXIgIGNoYW5nZSB8CQkxcyAgIHwJCSAgMTYgbXMKLS0tLS0t
LS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQoKPj4gKwo+PiArwqDCoMKgIGlmICgoZW5kIC0gc3RhcnQpID49IDUxMiA8PCAoUEFHRV9TSElG
VCAtIDEyKSkgewo+PiArwqDCoMKgwqDCoMKgwqAgX190bGJpKHZtYWxsczEyZTFpcyk7Cj4gCj4g
QW5kIHdoYXQgaXMgdGhpcyBtYWdpYyB2YWx1ZSBiYXNlZCBvbj8gWW91IGRvbid0IGV2ZW4gbWVu
dGlvbiBpbiB0aGUKPiBjb21taXQgbG9nIHRoYXQgeW91IGFyZSB0YWtpbmcgdGhpcyBzaG9ydGN1
dC4KPiAKCgpJZiB0aGUgcGFnZSBudW0gaXMgYmlnZ2VyIHRoYW4gNTEyLCBmbHVzaCBhbGwgdGxi
cyBvZiB0aGlzIHZtIHRvIGF2b2lkCnNvZnQgbG9jay11cHMgb24gbGFyZ2UgVExCIGZsdXNoaW5n
IHJhbmdlcy4gIEp1c3QgbGlrZSB3aGF0IHRoZQpmbHVzaF90bGJfcmFuZ2UoKSBkb2VzLgoKClRo
YW5rcywKWmhlbnl1CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
