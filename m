Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94BD4C433E5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:12:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C99E2073E
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQ1Z9K59"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C99E2073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 787514B7AD;
	Mon, 27 Jul 2020 13:12:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QYhH81Xufwc6; Mon, 27 Jul 2020 13:12:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C6DF4B7C1;
	Mon, 27 Jul 2020 13:12:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2422D4B7AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:12:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lq3Z00CUmwFo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 13:12:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD2C14B627
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:12:37 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9B562206E7;
 Mon, 27 Jul 2020 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595869956;
 bh=WogOJT1SpSbDm9BIS5mq+VMEccrmGTd/fbEvNfTWPgM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=lQ1Z9K59C8/AlkD1/eM/JwEqvlO7ySlctuRPoQqZ36nRK1Dy7JlBuq/54o4cIjEcD
 cbn9dbymYVSeLmrss7+oAwKbKw0LEVhdVjYi0OVwO3tnBP+DzAKy8Wn2N0a0srie7z
 DjhgZiDTdIYE3B13+xlYN3P1+D7OOQalV77YMcwg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k06fy-00FNOn-Va; Mon, 27 Jul 2020 18:12:35 +0100
MIME-Version: 1.0
Date: Mon, 27 Jul 2020 18:12:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zhenyu Ye <yezhenyu2@huawei.com>
Subject: Re: [RESEND RFC PATCH v1] arm64: kvm: flush tlbs by range in
 unmap_stage2_range function
In-Reply-To: <f74277fd-5af2-c46f-169f-c15a321165cd@huawei.com>
References: <20200724134315.805-1-yezhenyu2@huawei.com>
 <5d54c860b3b4e7a98e4d53397e6424ae@kernel.org>
 <f74277fd-5af2-c46f-169f-c15a321165cd@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <fb4756b58892fbc2022cf1f5b9320c27@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yezhenyu2@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, steven.price@arm.com, mark.rutland@arm.com, ascull@google.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, arm@kernel.org,
 xiexiangyou@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Wmhlbnl1LAoKT24gMjAyMC0wNy0yNyAxNTo1MSwgWmhlbnl1IFllIHdyb3RlOgo+IEhpIE1hcmMs
Cj4gCj4gT24gMjAyMC83LzI2IDE6NDAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMC0w
Ny0yNCAxNDo0MywgWmhlbnl1IFllIHdyb3RlOgo+Pj4gTm93IGluIHVubWFwX3N0YWdlMl9yYW5n
ZSgpLCB3ZSBmbHVzaCB0bGJzIG9uZSBieSBvbmUganVzdCBhZnRlciB0aGUKPj4+IGNvcnJlc3Bv
bmRpbmcgcGFnZXMgY2xlYXJlZC7CoCBIb3dldmVyLCB0aGlzIG1heSBjYXVzZSBzb21lIAo+Pj4g
cGVyZm9ybWFuY2UKPj4+IHByb2JsZW1zIHdoZW4gdGhlIHVubWFwIHJhbmdlIGlzIHZlcnkgbGFy
Z2UgKHN1Y2ggYXMgd2hlbiB0aGUgdm0KPj4+IG1pZ3JhdGlvbiByb2xsYmFjaywgdGhpcyBtYXkg
Y2F1c2Ugdm0gZG93bnRpbWUgdG9vIGxvb2cpLgo+PiAKPj4gWW91IGtlZXAgcmVzZW5kaW5nIHRo
aXMgcGF0Y2gsIGJ1dCB5b3UgZG9uJ3QgZ2l2ZSBhbnkgbnVtYmVycwo+PiB0aGF0IHdvdWxkIGJh
Y2sgeW91ciBhc3NlcnRpb24uCj4gCj4gSSBoYXZlIHRlc3RlZCB0aGUgZG93bnRpbWUgb2Ygdm0g
bWlncmF0aW9uIHJvbGxiYWNrIG9uIGFybTY0LCBhbmQgZm91bmQKPiB0aGUgZG93bnRpbWUgY291
bGQgZXZlbiB0YWtlIHVwIHRvIDdzLiAgVGhlbiBJIHRyYWNlZCB0aGUgY29zdCBvZgo+IHVubWFw
X3N0YWdlMl9yYW5nZSgpIGFuZCBmb3VuZCBpdCBjb3VsZCB0YWtlIGEgbWF4aW11bSBvZiAxLjJz
LiAgVGhlCj4gdm0gY29uZmlndXJhdGlvbiBpcyBhcyBmb2xsb3dzICh3aXRoIGhpZ2ggbWVtb3J5
IHByZXNzdXJlLCB0aGUgZGlydHkKPiByYXRlIGlzIGFib3V0IDUwME1CL3MpOgo+IAo+ICAgPG1l
bW9yeSB1bml0PSdHaUInPjE5MjwvbWVtb3J5Pgo+ICAgPHZjcHUgcGxhY2VtZW50PSdzdGF0aWMn
PjQ4PC92Y3B1Pgo+ICAgPG1lbW9yeUJhY2tpbmc+Cj4gICAgIDxodWdlcGFnZXM+Cj4gICAgICAg
PHBhZ2Ugc2l6ZT0nMScgdW5pdD0nR2lCJyBub2Rlc2V0PScwJy8+Cj4gICAgIDwvaHVnZXBhZ2Vz
Pgo+ICAgPC9tZW1vcnlCYWNraW5nPgoKVGhpcyBtZWFucyBub3RoaW5nIHRvIG1lLCBJJ20gYWZy
YWlkLgoKPiAKPiBBZnRlciB0aGlzIHBhdGNoIGFwcGxpZWQsIHRoZSBjb3N0IG9mIHVubWFwX3N0
YWdlMl9yYW5nZSgpIGNhbiByZWR1Y2UgCj4gdG8KPiAxNm1zLCBhbmQgVk0gZG93bnRpbWUgY2Fu
IGJlIGxlc3MgdGhhbiAxcy4KPiAKPiBUaGUgZm9sbG93aW5nIGZpZ3VyZSBzaG93cyBhIGNsZWFy
IGNvbXBhcmlzb246Cj4gCj4gCSAgICAgIHwJdm0gZG93bnRpbWUgIHwJY29zdCBvZiB1bm1hcF9z
dGFnZTJfcmFuZ2UoKQo+IC0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiBiZWZvcmUgY2hhbmdlIHwJCTdzICAgfAkJMTIwMCBt
cwo+IGFmdGVyICBjaGFuZ2UgfAkJMXMgICB8CQkgIDE2IG1zCj4gLS0tLS0tLS0tLS0tLS0rLS0t
LS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoKSSBkb24ndCBz
ZWUgaG93IHlvdSB0dXJuIGEgMS4xODRzIHJlZHVjdGlvbiBpbnRvIGEgNnMgZ2Fpbi4KU3VyZWx5
IHRoZXJlIGlzIG1vcmUgdG8gaXQgdGhhbiB3aGF0IHlvdSBwb3N0ZWQuCgo+Pj4gKwo+Pj4gK8Kg
wqDCoCBpZiAoKGVuZCAtIHN0YXJ0KSA+PSA1MTIgPDwgKFBBR0VfU0hJRlQgLSAxMikpIHsKPj4+
ICvCoMKgwqDCoMKgwqDCoCBfX3RsYmkodm1hbGxzMTJlMWlzKTsKPj4gCj4+IEFuZCB3aGF0IGlz
IHRoaXMgbWFnaWMgdmFsdWUgYmFzZWQgb24/IFlvdSBkb24ndCBldmVuIG1lbnRpb24gaW4gdGhl
Cj4+IGNvbW1pdCBsb2cgdGhhdCB5b3UgYXJlIHRha2luZyB0aGlzIHNob3J0Y3V0Lgo+PiAKPiAK
PiAKPiBJZiB0aGUgcGFnZSBudW0gaXMgYmlnZ2VyIHRoYW4gNTEyLCBmbHVzaCBhbGwgdGxicyBv
ZiB0aGlzIHZtIHRvIGF2b2lkCj4gc29mdCBsb2NrLXVwcyBvbiBsYXJnZSBUTEIgZmx1c2hpbmcg
cmFuZ2VzLiAgSnVzdCBsaWtlIHdoYXQgdGhlCj4gZmx1c2hfdGxiX3JhbmdlKCkgZG9lcy4KCkkn
bSBub3Qgc3VyZSB0aGlzIGlzIGFwcGxpY2FibGUgaGVyZSwgYW5kIGl0IGRvZXNuJ3QgbWVhbgp0
aGlzIGlzIGFzIGdvb2Qgb24gb3RoZXIgc3lzdGVtcy4KClRoYW5rcywKCiAgICAgICAgIE0uCi0t
IApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
