From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Tue, 5 Mar 2019 09:47:49 +0000
Message-ID: <20190305094747.GJ3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <8898674D84E3B24BA3A2D289B872026A6A33657E@G01JPEXMBKW03>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 503DE49F94
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Mar 2019 04:47:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RfBtYFgzwVQj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Mar 2019 04:47:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E070549E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Mar 2019 04:47:55 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <8898674D84E3B24BA3A2D289B872026A6A33657E@G01JPEXMBKW03>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Zhang, Lei" <zhang.lei@jp.fujitsu.com>
Cc: "Okamoto, Takayuki" <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Julien Grall <julien.grall@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gU3VuLCBNYXIgMDMsIDIwMTkgYXQgMDI6NDA6NTdBTSArMDAwMCwgWmhhbmcsIExlaSB3cm90
ZToKPiBIaSBEYXZlLAo+IAo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0KPiA+IEZyb206
IGxpbnV4LWFybS1rZXJuZWwgPGxpbnV4LWFybS1rZXJuZWwtYm91bmNlc0BsaXN0cy5pbmZyYWRl
YWQub3JnPiBPbgo+ID4gQmVoYWxmIE9mIERhdmUgTWFydGluCj4gPiBTZW50OiBUdWVzZGF5LCBG
ZWJydWFyeSAxOSwgMjAxOSA0OjUyIEFNCj4gPiBUbzoga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQo+ID4gQ2M6IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz47IE9r
YW1vdG8sIFRha2F5dWtpL+WyoeacrCDpq5jlubgKPiA+IDx0b2thbW90b0BqcC5mdWppdHN1LmNv
bT47IENocmlzdG9mZmVyIERhbGwgPGNkYWxsQGtlcm5lbC5vcmc+OyBBcmQKPiA+IEJpZXNoZXV2
ZWwgPGFyZC5iaWVzaGV1dmVsQGxpbmFyby5vcmc+OyBNYXJjIFp5bmdpZXIKPiA+IDxtYXJjLnp5
bmdpZXJAYXJtLmNvbT47IENhdGFsaW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+
OyBXaWxsCj4gPiBEZWFjb24gPHdpbGwuZGVhY29uQGFybS5jb20+OyBaaGFuZywgTGVpL+W8tSDp
m7cKPiA+IDx6aGFuZy5sZWlAanAuZnVqaXRzdS5jb20+OyBKdWxpZW4gR3JhbGwgPGp1bGllbi5n
cmFsbEBhcm0uY29tPjsgQWxleCBCZW5uw6llCj4gPiA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz47
IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZwo+ID4gU3ViamVjdDogW1BBVENI
IHY1IDAwLzI2XSBLVk06IGFybTY0OiBTVkUgZ3Vlc3Qgc3VwcG9ydAo+ID4gCj4gPiBUaGlzIHNl
cmllcyBpbXBsZW1lbnRzIHN1cHBvcnQgZm9yIGFsbG93aW5nIEtWTSBndWVzdHMgdG8gdXNlIHRo
ZSBBcm0KPiA+IFNjYWxhYmxlIFZlY3RvciBFeHRlbnNpb24gKFNWRSksIHN1cGVyc2VkaW5nIHRo
ZSBwcmV2aW91cyB2NCBzZXJpZXMgWzFdLgo+ID4gCj4gPiBUaGUgcGF0Y2hlcyBhcmUgYWxzbyBh
dmFpbGFibGUgb24gYSBicmFuY2ggZm9yIHJldmlld2VyIGNvbnZlbmllbmNlLiBbMl0KPiA+IAo+
ID4gVGhlIHBhdGNoZXMgYXJlIGJhc2VkIG9uIHY1LjAtcmM2Lgo+ID4gCj4gPiBUaGV5IGRlcGVu
ZCBvbiBhbm90aGVyIHNtYWxsIHNlcmllcyBjdXJyZW50bHkgdW5kZXIgcmV2aWV3IFszXSB0aGF0
IGRvZXMgYSBiaXQKPiA+IG9mIHJlbGV2YW50IHJlZmFjdG9yaW5nIChhcyB3ZWxsIGFzIGZpeGlu
ZyBhbiBhbm9tYWx5IG5vdCBkaXJlY3RseSByZWxhdGVkIHRvIHRoaXMKPiA+IHNlcmllcykuICBB
IGJhc2UgYnJhbmNoIFs0XSBpcyBwcm92aWRlZCBzbyB0aGF0IHJldmlld2VycyBkb24ndCBuZWVk
IHRvIGh1bnQKPiA+IGRvd24gYm90aCBzZXJpZXMgaW5kZXBlbmRlbnRseS4KPiBbPl0gCj4gSSB0
ZXN0ZWQgdGhlIHBhdGNoIG9uIEE2NEZYIGNoaXAgd2hpY2ggU1ZFIGZlYXR1cmUgaGFkIGJlZW4g
aW1wbGVtZW50ZWQuCj4gQWxsIG9mIHRlc3RzIGhhdmUgYmVlbiBwYXNzZWQuCj4gUGxlYXNlIGFk
ZCBmb2xsb3dzIDoKPiBUZXN0ZWQtYnk6IHpoYW5nLmxlaSA8emhhbmcubGVpQGpwLmZ1aml0c3Uu
Y29tPgoKVGhhbmtzIGZvciB0aGlzIQoKVGhlcmUgd2lsbCBiZSBhdCBsZWFzdCBvbmUgbW9yZSBp
dGVyYXRpb24gb2YgdGhpcyBzZXJpZXMgYmVmb3JlIGl0IGlzCmZpbmFsLCBzbyBpdCB3b3VsZCBi
ZSBnb29kIGlmIHlvdSBjYW4gdGVzdCBhZ2FpbiB3aGVuIEkgcmVwb3N0LgoKSSdsbCBtYWtlIHN1
cmUgdGhhdCB5b3UgYXJlIG9uIENjLgoKQ2hlZXJzCi0tLURhdmUKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
