Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62A9C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 07:30:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3E9A961461
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 07:30:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E9A961461
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5734B457;
	Thu, 22 Apr 2021 03:30:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Ro+fOswk4wg; Thu, 22 Apr 2021 03:30:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 804B64B469;
	Thu, 22 Apr 2021 03:30:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 990464B3E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 03:30:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7QrGivGIY+sF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 03:30:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6395B4B451
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 03:30:05 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 997EC6145E;
 Thu, 22 Apr 2021 07:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619076603;
 bh=GvHLrkjv+8OSfv0DFhto7kn97jmH4HlTtc9KLl6FFu4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=EEdSmllRyEg3GlL6fG+QQxGmjjh8mn5FNwFOz2dK6HPHJ1DKQtONjppKpwZX6WwKm
 zTUBFONStme9eAX5Yp/tucFTyfUDifV52Jvk8/tweFJz5h0Tkur33U7zK+IqoecPxG
 AfclCDbDXzUtfM6wF4InX3oVYpnK3IIedrZy4BeCuEOvfnQaXLluNnvDW/cOCMdHUN
 4Du5U0a0uJxKBTiXnTTi1OhiOY2WwDNVY3ruGLAnY3bsSS+D0zn0jgIrIGIWA+2518
 UgTkkoL86MmFKi0SjMPoGNYnwfLu3Ag78kGee/2AQLjNwy7ccbIGvoODA1pjeLgfdb
 KGl0OzJVIPfZA==
Date: Thu, 22 Apr 2021 10:29:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2 0/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
Message-ID: <YIEl8aKr8Ly0Zd3O@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
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

T24gVGh1LCBBcHIgMjIsIDIwMjEgYXQgMDM6MDA6MjBQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3Jv
dGU6Cj4gCj4gT24gMjAyMS80LzIxIDE0OjUxLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+ID4gRnJv
bTogTWlrZSBSYXBvcG9ydCA8cnBwdEBsaW51eC5pYm0uY29tPgo+ID4gCj4gPiBIaSwKPiA+IAo+
ID4gVGhlc2UgcGF0Y2hlcyBhaW0gdG8gcmVtb3ZlIENPTkZJR19IT0xFU19JTl9aT05FIGFuZCBl
c3NlbnRpYWxseSBoYXJkd2lyZQo+ID4gcGZuX3ZhbGlkX3dpdGhpbigpIHRvIDEuCj4gPiAKPiA+
IFRoZSBpZGVhIGlzIHRvIG1hcmsgTk9NQVAgcGFnZXMgYXMgcmVzZXJ2ZWQgaW4gdGhlIG1lbW9y
eSBtYXAgYW5kIHJlc3RvcmUKPiA+IHRoZSBpbnRlbmRlZCBzZW1hbnRpY3Mgb2YgcGZuX3ZhbGlk
KCkgdG8gZGVzaWduYXRlIGF2YWlsYWJpbGl0eSBvZiBzdHJ1Y3QKPiA+IHBhZ2UgZm9yIGEgcGZu
Lgo+ID4gCj4gPiBXaXRoIHRoaXMgdGhlIGNvcmUgbW0gd2lsbCBiZSBhYmxlIHRvIGNvcGUgd2l0
aCB0aGUgZmFjdCB0aGF0IGl0IGNhbm5vdCB1c2UKPiA+IE5PTUFQIHBhZ2VzIGFuZCB0aGUgaG9s
ZXMgY3JlYXRlZCBieSBOT01BUCByYW5nZXMgd2l0aGluIE1BWF9PUkRFUiBibG9ja3MKPiA+IHdp
bGwgYmUgdHJlYXRlZCBjb3JyZWN0bHkgZXZlbiB3aXRob3V0IHRoZSBuZWVkIGZvciBwZm5fdmFs
aWRfd2l0aGluLgo+ID4gCj4gPiBUaGUgcGF0Y2hlcyBhcmUgb25seSBib290IHRlc3RlZCBvbiBx
ZW11LXN5c3RlbS1hYXJjaDY0IHNvIEknZCByZWFsbHkKPiA+IGFwcHJlY2lhdGUgbWVtb3J5IHN0
cmVzcyB0ZXN0cyBvbiByZWFsIGhhcmR3YXJlLgo+ID4gCj4gPiBJZiB0aGlzIGFjdHVhbGx5IHdv
cmtzIHdlJ2xsIGJlIG9uZSBzdGVwIGNsb3NlciB0byBkcm9wIGN1c3RvbSBwZm5fdmFsaWQoKQo+
ID4gb24gYXJtNjQgYWx0b2dldGhlci4KPiAKPiBIaSBNaWtl77yMSSBoYXZlIGEgcXVlc3Rpb24s
IHdpdGhvdXQgSE9MRVNfSU5fWk9ORSwgdGhlIHBmbl92YWxpZF93aXRoaW4oKSBpbgo+IG1vdmVf
ZnJlZXBhZ2VzX2Jsb2NrKCktPm1vdmVfZnJlZXBhZ2VzKCkKPiB3aWxsIGJlIG9wdGltaXplZCwg
aWYgdGhlcmUgYXJlIGhvbGVzIGluIHpvbmUsIHRoZSAnc3RydWNlIHBhZ2UnKG1lbW9yeSBtYXAp
Cj4gZm9yIHBmbiByYW5nZSBvZiBob2xlIHdpbGwgYmUgZnJlZSBieQo+IGZyZWVfbWVtbWFwKCks
IGFuZCB0aGVuIHRoZSBwYWdlIHRyYXZlcnNlIGluIHRoZSB6b25lKHdpdGggaG9sZXMpIGZyb20K
PiBtb3ZlX2ZyZWVwYWdlcygpIHdpbGwgbWVldCB0aGUgd3JvbmcgcGFnZe+8jAo+IHRoZW4gaXQg
Y291bGQgcGFuaWMgYXQgUGFnZUxSVShwYWdlKSB0ZXN0LCBjaGVjayBsaW5rWzFdLAoKRmlyc3Qs
IEhPTEVTX0lOX1pPTkUgbmFtZSB1cyBodWdlbHkgbWlzbGVhZGluZywgdGhpcyBjb25maWd1cmF0
aW9uIG9wdGlvbgpoYXMgbm90aGluZyB0byB0byB3aXRoIG1lbW9yeSBob2xlcywgYnV0IHJhdGhl
ciBpdCBpcyB0aGVyZSB0byBkZWFsIHdpdGgKaG9sZXMgb3IgdW5kZWZpbmVkIHN0cnVjdCBwYWdl
cyBpbiB0aGUgbWVtb3J5IG1hcCwgd2hlbiB0aGVzZSBob2xlcyBjYW4gYmUKaW5zaWRlIGEgTUFY
X09SREVSX05SX1BBR0VTIHJlZ2lvbi4KCkluIGdlbmVyYWwgcGZuIHdhbGtlcnMgdXNlIHBmbl92
YWxpZCgpIGFuZCBwZm5fdmFsaWRfd2l0aGluKCkgdG8gYXZvaWQKYWNjZXNzaW5nICptaXNzaW5n
KiBzdHJ1Y3QgcGFnZXMsIGxpa2UgdGhvc2UgdGhhdCBhcmUgZnJlZWQgYXQKZnJlZV9tZW1tYXAo
KS4gQnV0IG9uIGFybTY0IHRoZXNlIHRlc3RzIGFsc28gZmlsdGVyIG91dCB0aGUgbm9tYXAgZW50
cmllcwpiZWNhdXNlIHRoZWlyIHN0cnVjdCBwYWdlcyBhcmUgbm90IGluaXRpYWxpemVkLgoKVGhl
IHBhbmljIHlvdSByZWZlciB0byBoYXBwZW5lZCBiZWNhdXNlIHRoZXJlIHdhcyBhbiB1bmluaXRp
YWxpemVkIHN0cnVjdApwYWdlIGluIHRoZSBtaWRkbGUgb2YgTUFYX09SREVSX05SX1BBR0VTIHJl
Z2lvbiBiZWNhdXNlIGl0IGNvcnJlc3BvbmRlZCB0bwpub21hcCBtZW1vcnkuCgpXaXRoIHRoZXNl
IGNoYW5nZXMgSSBtYWtlIHN1cmUgdGhhdCBzdWNoIHBhZ2VzIHdpbGwgYmUgcHJvcGVybHkgaW5p
dGlhbGl6ZWQKYXMgUGFnZVJlc2VydmVkIGFuZCB0aGUgcGZuIHdhbGtlcnMgd2lsbCBiZSBhYmxl
IHRvIHJlbHkgb24gdGhlIG1lbW9yeSBtYXAuCgpOb3RlIGFsc28sIHRoYXQgZnJlZV9tZW1tYXAo
KSBhbGlnbnMgdGhlIHBhcnRzIGJlaW5nIGZyZWVkIG9uIE1BWF9PUkRFUgpib3VuZGFyaWVzLCBz
byB0aGVyZSB3aWxsIGJlIG5vIG1pc3NpbmcgcGFydHMgaW4gdGhlIG1lbW9yeSBtYXAgd2l0aGlu
IGEKTUFYX09SREVSX05SX1BBR0VTIHJlZ2lvbi4KIAo+ICJUaGUgaWRlYSBpcyB0byBtYXJrIE5P
TUFQIHBhZ2VzIGFzIHJlc2VydmVkIGluIHRoZSBtZW1vcnkgbWFwIiwgSSBzZWUgdGhlCj4gcGF0
Y2gyIGNoZWNrIG1lbWJsb2NrX2lzX25vbWFwKCkgaW4gbWVtb3J5IHJlZ2lvbgo+IG9mIG1lbWJs
b2NrLCBidXQgaXQgc2VlbXMgdGhhdCBtZW1ibG9ja19tYXJrX25vbWFwKCkgaXMgbm90IGNhbGxl
ZChtYXliZSBJCj4gbWlzc2VkKSwgdGhlbiBtZW1tYXBfaW5pdF9yZXNlcnZlZF9wYWdlcygpIHdv
bid0Cj4gd29yaywgc28gc2hvdWxkIHRoZSBIT0xFU19JTl9aT05FIHN0aWxsIGJlIG5lZWRlZCBm
b3IgZ2VuZXJpYyBtbSBjb2RlPwo+IAo+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51
eC1hcm0ta2VybmVsLzU0MTE5M2E2LTJiY2UtZjA0Mi01YmIyLTg4OTEzZDVmMTA0N0Bhcm0uY29t
Lwo+IAoKLS0gClNpbmNlcmVseSB5b3VycywKTWlrZS4KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
