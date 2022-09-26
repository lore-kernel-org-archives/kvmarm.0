Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E073C07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 26 Sep 2022 11:02:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C20BD40E62;
	Mon, 26 Sep 2022 07:02:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pBE+1ttOvW0B; Mon, 26 Sep 2022 07:02:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1104B7FD;
	Mon, 26 Sep 2022 07:02:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0644E4B7ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 07:02:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZBdd0yTNftBa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 07:02:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2C0C40E62
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 07:02:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CCF7C1063;
 Mon, 26 Sep 2022 04:02:06 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0DA563F66F;
 Mon, 26 Sep 2022 04:01:58 -0700 (PDT)
Date: Mon, 26 Sep 2022 12:02:54 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests RFC PATCH 13/19] arm: page.h: Add missing
 libcflat.h include
Message-ID: <YzGGuxP9schoXL1C@monolith.localdoman>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-14-alexandru.elisei@arm.com>
 <20220920093956.sh4lunjssia376gf@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220920093956.sh4lunjssia376gf@kamzik>
Cc: nikos.nikoleris@arm.com, pbonzini@redhat.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

SGksCgpPbiBUdWUsIFNlcCAyMCwgMjAyMiBhdCAxMTozOTo1NkFNICswMjAwLCBBbmRyZXcgSm9u
ZXMgd3JvdGU6Cj4gCj4gSSBndWVzcyB0aGlzIHNob3VsZCBiZSBzcXVhc2hlZCBpbnRvIG9uZSBv
ZiB0aGUgZWFybHkgcGF0Y2hlcyBpbiB0aGlzCj4gc2VyaWVzIHNpbmNlIHdlIGRvbid0IGhhdmUg
dGhpcyBpc3N1ZSB3aXRoIHRoZSBjdXJyZW50IGNvZGUuCgpXaWxsIGRvLCB0aGFua3MgZm9yIHRo
ZSBzdWdnZXN0aW9uIQoKQWxleAoKPiAKPiBUaGFua3MsCj4gZHJldwo+IAo+IAo+IE9uIFR1ZSwg
QXVnIDA5LCAyMDIyIGF0IDEwOjE1OjUyQU0gKzAxMDAsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6
Cj4gPiBJbmNsdWRlIGxpYmNmbGF0IGZyb20gcGFnZS5oIHRvIGF2b2lkIGVycm9yIGxpa2UgdGhp
cyBvbmU6Cj4gPiAKPiA+IC9wYXRoL3RvL2t2bS11bml0LXRlc3RzL2xpYi9hc20vcGFnZS5oOjE5
Ojk6IGVycm9yOiB1bmtub3duIHR5cGUgbmFtZSDigJh1NjTigJkKPiA+ICAgIDE5IHwgdHlwZWRl
ZiB1NjQgcHRldmFsX3Q7Cj4gPiAgICAgICB8ICAgICAgICAgXn5+Cj4gPiBbLi5dCj4gPiAvcGF0
aC90by9rdm0tdW5pdC10ZXN0cy9saWIvYXNtL3BhZ2UuaDo0Nzo4OiBlcnJvcjogdW5rbm93biB0
eXBlIG5hbWUg4oCYcGh5c19hZGRyX3TigJkKPiA+ICAgIDQ3IHwgZXh0ZXJuIHBoeXNfYWRkcl90
IF9fdmlydF90b19waHlzKHVuc2lnbmVkIGxvbmcgYWRkcik7Cj4gPiAgICAgICB8ICAgICAgICBe
fn5+fn5+fn5+fgo+ID4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBefn5+fn5+fn5+fgo+ID4gWy4uXQo+ID4gL3BhdGgvdG8va3ZtLXVuaXQtdGVzdHMvbGliL2Fz
bS9wYWdlLmg6NTA6NDc6IGVycm9yOiB1bmtub3duIHR5cGUgbmFtZSDigJhzaXplX3TigJkKPiA+
ICAgIDUwIHwgZXh0ZXJuIHZvaWQgKl9faW9yZW1hcChwaHlzX2FkZHJfdCBwaHlzX2FkZHIsIHNp
emVfdCBzaXplKTsKPiA+IAo+ID4gVGhlIGFybTY0IHZlcnNpb24gb2YgdGhlIGhlYWRlciBhbHJl
YWR5IGluY2x1ZGVzIGxpYmNmbGF0IHNpbmNlIGNvbW1pdAo+ID4gYTJkMDY4NTJmZTU5ICgiYXJt
NjQ6IEFkZCBzdXBwb3J0IGZvciBjb25maWd1cmluZyB0aGUgdHJhbnNsYXRpb24KPiA+IGdyYW51
bGUiKS4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1
LmVsaXNlaUBhcm0uY29tPgo+ID4gLS0tCj4gPiAgbGliL2FybS9hc20vcGFnZS5oIHwgMiArKwo+
ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykKPiA+IAo+ID4gZGlmZiAtLWdpdCBh
L2xpYi9hcm0vYXNtL3BhZ2UuaCBiL2xpYi9hcm0vYXNtL3BhZ2UuaAo+ID4gaW5kZXggOGViNGE4
ODM4MDhlLi4wYTQ2YmRhMDE4YzcgMTAwNjQ0Cj4gPiAtLS0gYS9saWIvYXJtL2FzbS9wYWdlLmgK
PiA+ICsrKyBiL2xpYi9hcm0vYXNtL3BhZ2UuaAo+ID4gQEAgLTgsNiArOCw4IEBACj4gPiAgCj4g
PiAgI2luY2x1ZGUgPGxpbnV4L2NvbnN0Lmg+Cj4gPiAgCj4gPiArI2luY2x1ZGUgPGxpYmNmbGF0
Lmg+Cj4gPiArCj4gPiAgI2RlZmluZSBQQUdFX1NISUZUCQkxMgo+ID4gICNkZWZpbmUgUEFHRV9T
SVpFCQkoX0FDKDEsVUwpIDw8IFBBR0VfU0hJRlQpCj4gPiAgI2RlZmluZSBQQUdFX01BU0sJCSh+
KFBBR0VfU0laRS0xKSkKPiA+IC0tIAo+ID4gMi4zNy4xCj4gPiAKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
