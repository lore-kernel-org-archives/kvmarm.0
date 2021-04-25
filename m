Return-Path: <SRS0=ELNw=JW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31BFC433ED
	for <kvmarm@archiver.kernel.org>; Sun, 25 Apr 2021 06:59:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D78961208
	for <kvmarm@archiver.kernel.org>; Sun, 25 Apr 2021 06:59:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D78961208
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3174B52A;
	Sun, 25 Apr 2021 02:59:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uW2nexjsQjHl; Sun, 25 Apr 2021 02:59:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 826284B0B2;
	Sun, 25 Apr 2021 02:59:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3406B4B090
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Apr 2021 02:59:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 36kdzJzCQn7P for <kvmarm@lists.cs.columbia.edu>;
 Sun, 25 Apr 2021 02:59:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8A8E4B51D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Apr 2021 02:59:31 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40FB46023B;
 Sun, 25 Apr 2021 06:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619333969;
 bh=ALZmUg3aLVOMwTOpSkzKAu3QbSkOH0nkV19EGy5CnWY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ZTkBA1bAi227vq8nv7Y3635yQJXT4Dm9rXiN9XadbtKqV0vegdA4EYsMfQGwBg7bh
 fTxh7S3Q+utvZRMgunLLzZR2H6SWAqRs3SM0bbIezJGwNJ65hYW0SQ0rDrnNxdsRgk
 STaTVMIop+tRNiVtTjMmeBPPfXP+Bu2zJxuAaeBZGvk5awCTT47WPZgCi5q3p7hga+
 7ZWjc0MfUT2awSF/RVlYPYoagO5R328dq/OVCYOIwewc9wMN+zkbedbqEtHk3lQ9k+
 1DmOGz2COpdWYXfZ03tPJqud7ZB8paNMhg5qZsTaOuzMEH5A83kANNkAAxOfZCfv0n
 sqFwgjLUO+5Yg==
Date: Sun, 25 Apr 2021 09:59:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2 0/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
Message-ID: <YIUTSDnWe97vX1YP@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
 <YIEl8aKr8Ly0Zd3O@kernel.org>
 <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
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

T24gVGh1LCBBcHIgMjIsIDIwMjEgYXQgMTE6Mjg6MjRQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3Jv
dGU6Cj4gCj4gT24gMjAyMS80LzIyIDE1OjI5LCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+ID4gT24g
VGh1LCBBcHIgMjIsIDIwMjEgYXQgMDM6MDA6MjBQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3JvdGU6
Cj4gPiA+IE9uIDIwMjEvNC8yMSAxNDo1MSwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiA+ID4gPiBG
cm9tOiBNaWtlIFJhcG9wb3J0IDxycHB0QGxpbnV4LmlibS5jb20+Cj4gPiA+ID4gCj4gPiA+ID4g
SGksCj4gPiA+ID4gCj4gPiA+ID4gVGhlc2UgcGF0Y2hlcyBhaW0gdG8gcmVtb3ZlIENPTkZJR19I
T0xFU19JTl9aT05FIGFuZCBlc3NlbnRpYWxseSBoYXJkd2lyZQo+ID4gPiA+IHBmbl92YWxpZF93
aXRoaW4oKSB0byAxLgo+ID4gPiA+IAo+ID4gPiA+IFRoZSBpZGVhIGlzIHRvIG1hcmsgTk9NQVAg
cGFnZXMgYXMgcmVzZXJ2ZWQgaW4gdGhlIG1lbW9yeSBtYXAgYW5kIHJlc3RvcmUKPiA+ID4gPiB0
aGUgaW50ZW5kZWQgc2VtYW50aWNzIG9mIHBmbl92YWxpZCgpIHRvIGRlc2lnbmF0ZSBhdmFpbGFi
aWxpdHkgb2Ygc3RydWN0Cj4gPiA+ID4gcGFnZSBmb3IgYSBwZm4uCj4gPiA+ID4gCj4gPiA+ID4g
V2l0aCB0aGlzIHRoZSBjb3JlIG1tIHdpbGwgYmUgYWJsZSB0byBjb3BlIHdpdGggdGhlIGZhY3Qg
dGhhdCBpdCBjYW5ub3QgdXNlCj4gPiA+ID4gTk9NQVAgcGFnZXMgYW5kIHRoZSBob2xlcyBjcmVh
dGVkIGJ5IE5PTUFQIHJhbmdlcyB3aXRoaW4gTUFYX09SREVSIGJsb2Nrcwo+ID4gPiA+IHdpbGwg
YmUgdHJlYXRlZCBjb3JyZWN0bHkgZXZlbiB3aXRob3V0IHRoZSBuZWVkIGZvciBwZm5fdmFsaWRf
d2l0aGluLgo+ID4gPiA+IAo+ID4gPiA+IFRoZSBwYXRjaGVzIGFyZSBvbmx5IGJvb3QgdGVzdGVk
IG9uIHFlbXUtc3lzdGVtLWFhcmNoNjQgc28gSSdkIHJlYWxseQo+ID4gPiA+IGFwcHJlY2lhdGUg
bWVtb3J5IHN0cmVzcyB0ZXN0cyBvbiByZWFsIGhhcmR3YXJlLgo+ID4gPiA+IAo+ID4gPiA+IElm
IHRoaXMgYWN0dWFsbHkgd29ya3Mgd2UnbGwgYmUgb25lIHN0ZXAgY2xvc2VyIHRvIGRyb3AgY3Vz
dG9tIHBmbl92YWxpZCgpCj4gPiA+ID4gb24gYXJtNjQgYWx0b2dldGhlci4KPiA+ID4gSGkgTWlr
Ze+8jEkgaGF2ZSBhIHF1ZXN0aW9uLCB3aXRob3V0IEhPTEVTX0lOX1pPTkUsIHRoZSBwZm5fdmFs
aWRfd2l0aGluKCkgaW4KPiA+ID4gbW92ZV9mcmVlcGFnZXNfYmxvY2soKS0+bW92ZV9mcmVlcGFn
ZXMoKQo+ID4gPiB3aWxsIGJlIG9wdGltaXplZCwgaWYgdGhlcmUgYXJlIGhvbGVzIGluIHpvbmUs
IHRoZSAnc3RydWNlIHBhZ2UnKG1lbW9yeSBtYXApCj4gPiA+IGZvciBwZm4gcmFuZ2Ugb2YgaG9s
ZSB3aWxsIGJlIGZyZWUgYnkKPiA+ID4gZnJlZV9tZW1tYXAoKSwgYW5kIHRoZW4gdGhlIHBhZ2Ug
dHJhdmVyc2UgaW4gdGhlIHpvbmUod2l0aCBob2xlcykgZnJvbQo+ID4gPiBtb3ZlX2ZyZWVwYWdl
cygpIHdpbGwgbWVldCB0aGUgd3JvbmcgcGFnZe+8jAo+ID4gPiB0aGVuIGl0IGNvdWxkIHBhbmlj
IGF0IFBhZ2VMUlUocGFnZSkgdGVzdCwgY2hlY2sgbGlua1sxXSwKPiA+IEZpcnN0LCBIT0xFU19J
Tl9aT05FIG5hbWUgdXMgaHVnZWx5IG1pc2xlYWRpbmcsIHRoaXMgY29uZmlndXJhdGlvbiBvcHRp
b24KPiA+IGhhcyBub3RoaW5nIHRvIHRvIHdpdGggbWVtb3J5IGhvbGVzLCBidXQgcmF0aGVyIGl0
IGlzIHRoZXJlIHRvIGRlYWwgd2l0aAo+ID4gaG9sZXMgb3IgdW5kZWZpbmVkIHN0cnVjdCBwYWdl
cyBpbiB0aGUgbWVtb3J5IG1hcCwgd2hlbiB0aGVzZSBob2xlcyBjYW4gYmUKPiA+IGluc2lkZSBh
IE1BWF9PUkRFUl9OUl9QQUdFUyByZWdpb24uCj4gPiAKPiA+IEluIGdlbmVyYWwgcGZuIHdhbGtl
cnMgdXNlIHBmbl92YWxpZCgpIGFuZCBwZm5fdmFsaWRfd2l0aGluKCkgdG8gYXZvaWQKPiA+IGFj
Y2Vzc2luZyAqbWlzc2luZyogc3RydWN0IHBhZ2VzLCBsaWtlIHRob3NlIHRoYXQgYXJlIGZyZWVk
IGF0Cj4gPiBmcmVlX21lbW1hcCgpLiBCdXQgb24gYXJtNjQgdGhlc2UgdGVzdHMgYWxzbyBmaWx0
ZXIgb3V0IHRoZSBub21hcCBlbnRyaWVzCj4gPiBiZWNhdXNlIHRoZWlyIHN0cnVjdCBwYWdlcyBh
cmUgbm90IGluaXRpYWxpemVkLgo+ID4gCj4gPiBUaGUgcGFuaWMgeW91IHJlZmVyIHRvIGhhcHBl
bmVkIGJlY2F1c2UgdGhlcmUgd2FzIGFuIHVuaW5pdGlhbGl6ZWQgc3RydWN0Cj4gPiBwYWdlIGlu
IHRoZSBtaWRkbGUgb2YgTUFYX09SREVSX05SX1BBR0VTIHJlZ2lvbiBiZWNhdXNlIGl0IGNvcnJl
c3BvbmRlZCB0bwo+ID4gbm9tYXAgbWVtb3J5Lgo+ID4gCj4gPiBXaXRoIHRoZXNlIGNoYW5nZXMg
SSBtYWtlIHN1cmUgdGhhdCBzdWNoIHBhZ2VzIHdpbGwgYmUgcHJvcGVybHkgaW5pdGlhbGl6ZWQK
PiA+IGFzIFBhZ2VSZXNlcnZlZCBhbmQgdGhlIHBmbiB3YWxrZXJzIHdpbGwgYmUgYWJsZSB0byBy
ZWx5IG9uIHRoZSBtZW1vcnkgbWFwLgo+ID4gCj4gPiBOb3RlIGFsc28sIHRoYXQgZnJlZV9tZW1t
YXAoKSBhbGlnbnMgdGhlIHBhcnRzIGJlaW5nIGZyZWVkIG9uIE1BWF9PUkRFUgo+ID4gYm91bmRh
cmllcywgc28gdGhlcmUgd2lsbCBiZSBubyBtaXNzaW5nIHBhcnRzIGluIHRoZSBtZW1vcnkgbWFw
IHdpdGhpbiBhCj4gPiBNQVhfT1JERVJfTlJfUEFHRVMgcmVnaW9uLgo+IAo+IE9rLCB0aGFua3Ms
IHdlIG1ldCBhIHNhbWUgcGFuaWMgbGlrZSB0aGUgbGluayBvbiBhcm0zMih3aXRob3V0Cj4gSE9M
RVNfSU5fWk9ORSksCj4gCj4gdGhlIHNjaGVtZSBmb3IgYXJtNjQgY291bGQgYmUgc3VpdCBmb3Ig
YXJtMzIsIHJpZ2h0PwoKSW4gZ2VuZXJhbCB5ZXMuIFlvdSBqdXN0IG5lZWQgdG8gbWFrZSBzdXJl
IHRoYXQgdXNhZ2Ugb2YgcGZuX3ZhbGlkKCkgaW4KYXJjaC9hcm0gZG9lcyBub3QgcHJlc3VtZSB0
aGF0IGl0IHRlc3RzIHNvbWV0aGluZyBiZXlvbmQgYXZhaWxhYmlsaXR5IG9mCnN0cnVjdCBwYWdl
IGZvciBhIHBmbi4KIAo+wqBJIHdpbGwgdHJ5IHRoZSBwYXRjaHNldCB3aXRoIHNvbWUgY2hhbmdl
cyBvbiBhcm0zMiBhbmQgZ2l2ZSBzb21lCj4gZmVlZGJhY2suCj4gCj4gQWdhaW4sIHRoZSBzdHVw
aWQgcXVlc3Rpb24sIHdoZXJlIHdpbGwgbWFyayB0aGUgcmVnaW9uIG9mIG1lbWJsb2NrIHdpdGgK
PiBNRU1CTE9DS19OT01BUCBmbGFnID8KIApOb3Qgc3VyZSBJIHVuZGVyc3RhbmQgdGhlIHF1ZXN0
aW9uLiBUaGUgbWVtb3J5IHJlZ2lvbnMgd2l0aCAibm9tYXAiCnByb3BlcnR5IGluIHRoZSBkZXZp
Y2UgdHJlZSB3aWxsIGJlIG1hcmtlZCBNRU1CTE9DS19OT01BUC4KIAo+ID4gPiAiVGhlIGlkZWEg
aXMgdG8gbWFyayBOT01BUCBwYWdlcyBhcyByZXNlcnZlZCBpbiB0aGUgbWVtb3J5IG1hcCIsIEkg
c2VlIHRoZQo+ID4gPiBwYXRjaDIgY2hlY2sgbWVtYmxvY2tfaXNfbm9tYXAoKSBpbiBtZW1vcnkg
cmVnaW9uCj4gPiA+IG9mIG1lbWJsb2NrLCBidXQgaXQgc2VlbXMgdGhhdCBtZW1ibG9ja19tYXJr
X25vbWFwKCkgaXMgbm90IGNhbGxlZChtYXliZSBJCj4gPiA+IG1pc3NlZCksIHRoZW4gbWVtbWFw
X2luaXRfcmVzZXJ2ZWRfcGFnZXMoKSB3b24ndAo+ID4gPiB3b3JrLCBzbyBzaG91bGQgdGhlIEhP
TEVTX0lOX1pPTkUgc3RpbGwgYmUgbmVlZGVkIGZvciBnZW5lcmljIG1tIGNvZGU/Cj4gPiA+IAo+
ID4gPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtYXJtLWtlcm5lbC81NDExOTNh
Ni0yYmNlLWYwNDItNWJiMi04ODkxM2Q1ZjEwNDdAYXJtLmNvbS8KPiA+ID4gCgotLSAKU2luY2Vy
ZWx5IHlvdXJzLApNaWtlLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
