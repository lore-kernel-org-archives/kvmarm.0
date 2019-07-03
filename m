Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC549C0650E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 17:46:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69BD321881
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 17:46:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69BD321881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4F1E4A4F7;
	Wed,  3 Jul 2019 13:46:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2mf2NsSbeVwV; Wed,  3 Jul 2019 13:46:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA9A4A508;
	Wed,  3 Jul 2019 13:46:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 285704A4F9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 13:46:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZWDIE6B3Pvu3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jul 2019 13:46:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F384A4F7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 13:46:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F961344;
 Wed,  3 Jul 2019 10:46:12 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 723E93F718;
 Wed,  3 Jul 2019 10:46:10 -0700 (PDT)
Date: Wed, 3 Jul 2019 18:46:08 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: "Zhang, Lei" <zhang.lei@jp.fujitsu.com>
Subject: Re: [PATCH V3] KVM: arm64: Implement vq_present() as a macro
Message-ID: <20190703174605.GX2790@e103592.cambridge.arm.com>
References: <be823e68faffc82a6f621c16ce1bd45990d92791.1560160681.git.viresh.kumar@linaro.org>
 <8898674D84E3B24BA3A2D289B872026A78BA95D6@G01JPEXMBKW03>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8898674D84E3B24BA3A2D289B872026A78BA95D6@G01JPEXMBKW03>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: "Okamoto, Takayuki" <tokamoto@jp.fujitsu.com>,
 Marc Zyngier <marc.zyngier@arm.com>, 'Viresh Kumar' <viresh.kumar@linaro.org>,
 Will Deacon <will.deacon@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, "Mizuma,
 Masayoshi" <masayoshi.mizuma@fujitsu.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "Indoh, Takao" <indou.takao@fujitsu.com>
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

T24gV2VkLCBKdWwgMDMsIDIwMTkgYXQgMTI6MDQ6MTFQTSArMDAwMCwgWmhhbmcsIExlaSB3cm90
ZToKPiBIaSBndXlzLAo+IAo+IEkgY2FuJ3Qgc3RhcnQgdXAgS1ZNIGd1ZXN0IG9zIHdpdGggU1ZF
IGZlYXR1cmUgd2l0aCB5b3VyIHBhdGNoLgo+IFRoZSBlcnJvciBtZXNzYWdlIGlzIAo+IHFlbXUt
c3lzdGVtLWFhcmNoNjQ6IGt2bV9pbml0X3ZjcHUgZmFpbGVkOiBJbnZhbGlkIGFyZ3VtZW50Lgo+
IAo+IE15IHRlc3QgZW52aXJvbWVudC4KPiBrZXJuZWwgIGxpbnV4LTUuMi1yYzYKPiBxZW11ICBb
UWVtdS1kZXZlbF0gW1BBVENIIHYyIDAwLzE0XSB0YXJnZXQvYXJtL2t2bTogZW5hYmxlIFNWRSBp
biBndWVzdHMgaHR0cHM6Ly9saXN0cy5nbnUub3JnL2FyY2hpdmUvaHRtbC9xZW11LWRldmVsLzIw
MTktMDYvbXNnMDQ5NDUuaHRtbAo+IEtWTSBzdGFydCB1cCBvcHRpb24KPiAtbWFjaGluZSB2aXJ0
LGdpYy12ZXJzaW9uPWhvc3QsYWNjZWw9a3ZtIFwKPiAtY3B1IGhvc3QgXAo+IC1tYWNoaW5lIHR5
cGU9dmlydCBcCj4gLW5vZ3JhcGhpYyBcCj4gLXNtcCAxNiBcIC1tIDQwOTYgXAo+IC1kcml2ZSBp
Zj1ub25lLGZpbGU9L3Jvb3QvaW1hZ2UucWNvdzIsaWQ9aGQwLGZvcm1hdD1xY293MiBcCj4gLWRl
dmljZSB2aXJ0aW8tYmxrLWRldmljZSxkcml2ZT1oZDAgXAo+IC1uZXRkZXYgdXNlcixpZD1teW5l
dDAscmVzdHJpY3Q9b2ZmLGhvc3Rmd2Q9dGNwOjozODAwMS06MjIgXAo+IC1kZXZpY2UgdmlydGlv
LW5ldC1kZXZpY2UsbmV0ZGV2PW15bmV0MCBcCj4gLWJpb3MgL3Jvb3QvUUVNVV9FRkkuZmQKPiAK
PiBzdmVfdnFfYXZhaWxhYmxlIGZ1bmN0aW9uJ3MgcmV0dXJuIHZhbHVlJyB0eXBlIGlzIGJvb2wu
Cj4gQnV0IHZxX3ByZXNlbnQgaXMgbWFjcm8sIHNvIHRoZSB2YWx1ZSBpcyBub3Qgb25seSBUUlVF
LCBGQUxTRSBidXQgYWxzbyBzb21lIG51bWJlcnMuCj4gU28gSXQgZmFpbGVkIGF0IAo+IGlmICh2
cV9wcmVzZW50KHZxcywgdnEpICE9IHN2ZV92cV9hdmFpbGFibGUodnEpKS4KPiBJIHRoaW5rIGl0
IGlzIG5lc3NhcnkgdG8gbWFrZSB2cV9wcmVzZW50IG1hY3JvJ3MgdmFsdWUgb25seSBUUlVFIGFu
ZCBGQUxTRS4KPiAKPiBhcmNoL2FybTY0L2t2bS9ndWVzdC5jCj4gc3RhdGljIGludCBzZXRfc3Zl
X3ZscyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGNvbnN0IHN0cnVjdCBrdm1fb25lX3JlZyAqcmVn
KQo+IAlmb3IgKHZxID0gU1ZFX1ZRX01JTjsgdnEgPD0gbWF4X3ZxOyArK3ZxKQo+IAkJaWYgKHZx
X3ByZXNlbnQodnFzLCB2cSkgIT0gc3ZlX3ZxX2F2YWlsYWJsZSh2cSkp44CALy8gSXQgZmFpbGVk
IGF0IGhlcmUuCj4gCQkJcmV0dXJuIC1FSU5WQUw7Cj4gCj4gTXkgcGF0Y2ggYXMgZm9sbG93cy4K
PiBJIGhhdmUgc3RhcnRlZCB1cCBLVk0gZ3Vlc3Qgb3Mgc3VjY2Vzc2Z1bGx5IHdpdGggU1ZFIGZl
YXR1cmUgd2l0aCB0aGlzIHBhdGNoLgo+IAo+IENvdWxkIHlvdSByZXZpZXcgYW5kIG1lcmdlIG15
IHBhdGNoPwoKWy4uLl0KClRoYW5rcyBmb3IgcmVwb3J0aW5nIHRoaXMhICBJdCBsb29rcyBsaWtl
IHdlIGRpZG4ndCByZWFsaXNlIHdlIGRyb3BwZWQKdGhlIGltcGxpY2l0IGNhc3QgdG8gYm9vbCB3
aGVuIHRoZSByZXN1bHQgd2FzIHJldHVybmVkIGZyb20gdGhlIG9yaWdpbmFsCnZlcnNpb24gb2Yg
dnFfcHJlc2VudCgpLgoKWW91ciBmaXggbG9va3Mgc2Vuc2libGUgdG8gbWUuCgpGb3IgdGhlIGZ1
dHVyZSwgc2VlIERvY3VtZW50YXRpb24vcHJvY2Vzcy9zdWJtaXR0aW5nLXBhdGNoZXMucnN0IGZv
cgpndWlkYW5jZSBvbiBob3cgdG8gcHJlcGFyZSBhIHBhdGNoIGZvciBzdWJtaXNzaW9uLgoKSG93
ZXZlciwgZHVlIHRvIHRoZSBmYWN0IHRoYXQgd2UncmUgYWxyZWFkeSBhdCAtcmM3IEkndmUgd3Jp
dHRlbiBhCmNvbW1pdCBtZXNzYWdlIGZvciB0aGUgcGF0Y2ggYW5kIHJlcG9zdGVkIFsxXS4gIFNp
bmNlIHRoZSBmaXggaXMgeW91cnMsCkknbGwga2VlcCB5b3VyIGF1dGhvcnNoaXAgYW5kIFMtby1C
LgoKUGxlYXNlIHJldGVzdCB3aGVuIHlvdSBjYW4gKHRob3VnaCB0aGUgZGlmZiBzaG91bGQgYmUg
dGhlIHNhbWUpLgoKTm90ZSwgeW91ciBtYWlsIHNlZW1zIHRvIGJlIGNvcnJ1cHRlZCwgYnV0IHNp
bmNlIHRoZSBkaWZmIGlzIGEgb25lLWxpbmUKZml4LCBJJ20gcHJldHR5IGNvbmZpZGVudCBJIGRl
Y29kZWQgaXQgY29ycmVjdGx5LiAgSWYgYW55dGhpbmcgbG9va3MKd3JvbmcsIHBsZWFzZSBsZXQg
bWUga25vdy4KClsuLi5dCgpDaGVlcnMKLS0tRGF2ZQoKClsxXSBbUEFUQ0hdIEtWTTogYXJtNjQv
c3ZlOiBGaXggdnFfcHJlc2VudCgpIG1hY3JvIHRvIHlpZWxkIGEgYm9vbApodHRwOi8vbGlzdHMu
aW5mcmFkZWFkLm9yZy9waXBlcm1haWwvbGludXgtYXJtLWtlcm5lbC8yMDE5LUp1bHkvNjY0NzQ1
Lmh0bWwKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
