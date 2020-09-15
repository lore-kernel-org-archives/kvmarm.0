Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B93C433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 08:26:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B2DDB22204
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 08:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2DDB22204
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toshiba.co.jp
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1B644B2D4;
	Tue, 15 Sep 2020 04:26:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BiD+Bm8hUaNR; Tue, 15 Sep 2020 04:26:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB6BA4B2E6;
	Tue, 15 Sep 2020 04:26:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F544B23E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 04:24:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FmSnbvfRSIQX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 04:24:29 -0400 (EDT)
Received: from mo-csw.securemx.jp (mo-csw1116.securemx.jp [210.130.202.158])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 892744B225
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 04:24:29 -0400 (EDT)
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 08F8O4mB018283;
 Tue, 15 Sep 2020 17:24:05 +0900
X-Iguazu-Qid: 2wGrGhpI158j5wifIY
X-Iguazu-QSIG: v=2; s=0; t=1600158244; q=2wGrGhpI158j5wifIY;
 m=9ONToba/4nj4w866iSRtfbf4PZ7e67E/reZeo3waVLM=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
 by relay.securemx.jp (mx-mr1113) id 08F8O14w020484;
 Tue, 15 Sep 2020 17:24:02 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
 by imx12.toshiba.co.jp  with ESMTP id 08F8O1ED016104;
 Tue, 15 Sep 2020 17:24:01 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
 by enc02.toshiba.co.jp  with ESMTP id 08F8O12C029940;
 Tue, 15 Sep 2020 17:24:01 +0900
From: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Try PMD block mappings if PUD mappings are
 not supported
References: <20200910133351.118191-1-alexandru.elisei@arm.com>
 <87363oogp2.fsf@kokedama.swc.toshiba.co.jp>
 <2850b4d3-4399-c44c-0e5e-b01906c80ec7@arm.com>
Date: Tue, 15 Sep 2020 17:23:59 +0900
In-Reply-To: <2850b4d3-4399-c44c-0e5e-b01906c80ec7@arm.com> (Alexandru
 Elisei's message of "Fri, 11 Sep 2020 17:26:11 +0100")
X-TSB-HOP: ON
Message-ID: <87mu1rmork.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 15 Sep 2020 04:26:56 -0400
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

SGkgQWxleCwKCkFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4gd3Jp
dGVzOgoKPiBIaSBQdW5pdCwKPgo+IFRoYW5rIHlvdSBmb3IgaGF2aW5nIGEgbG9vayEKPgo+IE9u
IDkvMTEvMjAgOTozNCBBTSwgUHVuaXQgQWdyYXdhbCB3cm90ZToKPj4gSGkgQWxleGFuZHJ1LAo+
Pgo+PiBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4YW5kcnUuZWxpc2VpQGFybS5jb20+IHdyaXRlczoK
Pj4KPj4+IFdoZW4gdXNlcnNwYWNlIHVzZXMgaHVnZXRsYmZzIGZvciB0aGUgVk0gbWVtb3J5LCB1
c2VyX21lbV9hYm9ydCgpIHRyaWVzIHRvCj4+PiB1c2UgdGhlIHNhbWUgYmxvY2sgc2l6ZSB0byBt
YXAgdGhlIGZhdWx0aW5nIElQQSBpbiBzdGFnZSAyLiBJZiBzdGFnZSAyCj4+PiBjYW5ub3QgdGhl
IHNhbWUgYmxvY2sgbWFwcGluZyBiZWNhdXNlIHRoZSBibG9jayBzaXplIGRvZXNuJ3QgZml0IGlu
IHRoZQo+Pj4gbWVtc2xvdCBvciB0aGUgbWVtc2xvdCBpcyBub3QgcHJvcGVybHkgYWxpZ25lZCwg
dXNlcl9tZW1fYWJvcnQoKSB3aWxsIGZhbGwKPj4+IGJhY2sgdG8gYSBwYWdlIG1hcHBpbmcsIHJl
Z2FyZGxlc3Mgb2YgdGhlIGJsb2NrIHNpemUuIFdlIGNhbiBkbyBiZXR0ZXIgZm9yCj4+PiBQVUQg
YmFja2VkIGh1Z2V0bGJmcyBieSBjaGVja2luZyBpZiBhIFBNRCBibG9jayBtYXBwaW5nIGlzIHN1
cHBvcnRlZCBiZWZvcmUKPj4+IGRlY2lkaW5nIHRvIHVzZSBhIHBhZ2UuCj4+IEkgdGhpbmsgdGhp
cyB3YXMgZGlzY3Vzc2VkIGluIHRoZSBwYXN0Lgo+Pgo+PiBJIGhhdmUgYSB2YWd1ZSByZWNvbGxl
Y3Rpb24gb2YgdGhlcmUgYmVpbmcgYSBwcm9ibGVtIGlmIHRoZSB1c2VyIGFuZAo+PiBzdGFnZSAy
IG1hcHBpbmdzIGdvIG91dCBvZiBzeW5jIC0gY2FuJ3QgcmVjYWxsIHRoZSBleGFjdCBkZXRhaWxz
Lgo+Cj4gSSdtIG5vdCBzdXJlIHdoYXQgeW91IG1lYW4gYnkgdGhlIHR3byB0YWJsZXMgZ29pbmcg
b3V0IG9mIHN5bmMuIEknbSBsb29raW5nIGF0Cj4gRG9jdW1lbnRhdGlvbi92bS91bmV2aWN0YWJs
ZS1scnUucnN0IGFuZCB0aGlzIGlzIHdoYXQgaXQgc2F5cyByZWdhcmRpbmcgaHVnZXRsYmZzOgo+
Cj4gIlZNQXMgbWFwcGluZyBodWdldGxiZnMgcGFnZSBhcmUgYWxyZWFkeSBlZmZlY3RpdmVseSBw
aW5uZWQgaW50byBtZW1vcnkuwqAgV2UKPiBuZWl0aGVyIG5lZWQgbm9yIHdhbnQgdG8gbWxvY2so
KSB0aGVzZSBwYWdlcy7CoCBIb3dldmVyLCB0byBwcmVzZXJ2ZSB0aGUgcHJpb3IKPiBiZWhhdmlv
ciBvZiBtbG9jaygpIC0gYmVmb3JlIHRoZSB1bmV2aWN0YWJsZS9tbG9jayBjaGFuZ2VzIC0gbWxv
Y2tfZml4dXAoKSB3aWxsCj4gY2FsbCBtYWtlX3BhZ2VzX3ByZXNlbnQoKSBpbiB0aGUgaHVnZXRs
YmZzIFZNQSByYW5nZSB0byBhbGxvY2F0ZSB0aGUgaHVnZSBwYWdlcwo+IGFuZCBwb3B1bGF0ZSB0
aGUgcHRlcy4iCj4KPiBQbGVhc2UgY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcsIGJ1dCBteSBpbnRl
cnByZXRhdGlvbiBpcyB0aGF0IG9uY2UgYSBodWdldGxiZnMKPiBwYWdlIGhhcyBiZWVuIG1hcHBl
ZCBpbiBhIHByb2Nlc3MnIGFkZHJlc3Mgc3BhY2UsIHRoZSBvbmx5IHdheSB0byB1bm1hcCBpdCBp
cyB2aWEKPiBtdW5tYXAuIElmIHRoYXQncyB0aGUgY2FzZSwgdGhlIEtWTSBtbXUgbm90aWZpZXIg
c2hvdWxkIHRha2UgY2FyZSBvZiB1bm1hcHBpbmcKPiBmcm9tIHN0YWdlIDIgdGhlIGVudGlyZSBt
ZW1vcnkgcmFuZ2UgYWRkcmVzc2VkIGJ5IHRoZSBodWdldGxiZnMgcGFnZXMsCj4gcmlnaHQ/CgpZ
b3UncmUgcmlnaHQgLSBJIG1hbmFnZWQgdG8gY29uZnVzZSBteXNlbGYuIFRoaW5raW5nIGFib3V0
IGl0IHdpdGggYSBiaXQKbW9yZSBjb250ZXh0LCBJIGRvbid0IHNlZSBhIHByb2JsZW0gd2l0aCB3
aGF0IHRoZSBwYXRjaCBpcyBkb2luZy4KCkFwb2xvZ2llcyBmb3IgdGhlIG5vaXNlLgoKPj4KPj4g
UHV0dGluZyBpdCBvdXQgdGhlcmUgaW4gY2FzZSBhbnlib2R5IGVsc2Ugb24gdGhlIHRocmVhZCBj
YW4gcmVjYWxsIHRoZQo+PiBkZXRhaWxzIG9mIHRoZSBwcmV2aW91cyBkaXNjdXNzaW9uIChvZmZs
aXN0KS4KPj4KPj4gVGhvdWdoIHRoaW5ncyBtYXkgaGF2ZSBjaGFuZ2VkIGFuZCBpZiBpdCBwYXNz
ZXMgdGVzdGluZyAtIHRoZW4gbWF5YmUgSQo+PiBhbSBtaXMtcmVtZW1iZXJpbmcuIEknbGwgdGFr
ZSBhIGNsb3NlciBsb29rIGF0IHRoZSBwYXRjaCBhbmQgc2hvdXQgb3V0Cj4+IGlmIEkgbm90aWNl
IGFueXRoaW5nLgo+Cj4gVGhlIHRlc3QgSSByYW4gd2FzIHRvIGJvb3QgYSBWTSBhbmQgcnVuIGx0
cCAod2l0aCBwcmludGsncyBzcHJpbmtsZWQgaW4gdGhlIGhvc3QKPiBrZXJuZWwgdG8gc2VlIHdo
YXQgcGFnZSBzaXplIGFuZCB3aGVyZSBpdCBnZXRzIG1hcHBlZC91bm1hcHBlZCBhdCBzdGFnZSAy
KS4gRG8geW91Cj4gbWluZCByZWNvbW1lbmRpbmcgb3RoZXIgdGVzdHMgdGhhdCBJIG1pZ2h0IHJ1
bj8KCllvdSBtYXkgd2FudCB0byBwdXQgdGhlIGNoYW5nZXMgdGhyb3VnaCBWTSBzYXZlIC8gcmVz
dG9yZSBhbmQgLyBvciBsaXZlCm1pZ3JhdGlvbi4gSXQgc2hvdWxkIGhlbHAgY2F0Y2ggYW55IGlz
c3VlcyB3aXRoIHRyYW5zaXRpb25pbmcgZnJvbQpodWdlcGFnZXMgdG8gcmVndWxhciBwYWdlcy4K
CkhvcGUgdGhhdCBoZWxwcy4KClRoYW5rcywKUHVuaXQKClsuLi5dCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
