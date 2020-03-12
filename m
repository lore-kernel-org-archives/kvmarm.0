Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B3EC10DCE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 16:40:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67CA42067C
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 16:40:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67CA42067C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC25B4A95B;
	Thu, 12 Mar 2020 12:40:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cttY8csyWCYC; Thu, 12 Mar 2020 12:40:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE8114A650;
	Thu, 12 Mar 2020 12:40:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0A044A650
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 12:40:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q-xE6Liv1-dg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 12:40:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 952154A319
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 12:40:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06A8E30E;
 Thu, 12 Mar 2020 09:40:42 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EE4D3F6CF;
 Thu, 12 Mar 2020 09:40:40 -0700 (PDT)
Date: Thu, 12 Mar 2020 16:40:36 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: =?utf-8?B?UsOpbWk=?= Denis-Courmont <remi@remlab.net>
Subject: Re: [PATCH] arm64: move kimage_vaddr to .rodata
Message-ID: <20200312164035.GA21120@lakrids.cambridge.arm.com>
References: <20200312094002.153302-1-remi@remlab.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200312094002.153302-1-remi@remlab.net>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: catalin.marinas@arm.com, ard.biesheuvel@linaro.org,
 linux-kernel@vger.kernel.org, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gVGh1LCBNYXIgMTIsIDIwMjAgYXQgMTE6NDA6MDJBTSArMDIwMCwgUsOpbWkgRGVuaXMtQ291
cm1vbnQgd3JvdGU6Cj4gRnJvbTogUmVtaSBEZW5pcy1Db3VybW9udCA8cmVtaS5kZW5pcy5jb3Vy
bW9udEBodWF3ZWkuY29tPgo+IAo+IFRoaXMgZGF0dW0gaXMgbm90IHJlZmVyZW5jZWQgZnJvbSAu
aWRtYXAudGV4dDogaXQgZG9lcyBub3QgbmVlZCB0byBiZQo+IG1hcHBlZCBpbiBpZG1hcC4gTGV0
cyBtb3ZlIGl0IHRvIC5yb2RhdGEgYXMgaXQgaXMgbmV2ZXIgd3JpdHRlbiB0byBhZnRlcgo+IGVh
cmx5IGJvb3Qgb2YgdGhlIHByaW1hcnkgQ1BVLgo+IChNYXliZSAuZGF0YS5yb19hZnRlcl9pbml0
IHdvdWxkIGJlIGNsZWFuZXIgdGhvdWdoPykKCkNhbiB3ZSBtb3ZlIHRoaXMgaW50byBhcmNoL2Fy
bTY0L21tL21tdS5jLCB3aGVyZSB3ZSBhbHJlYWR5IGhhdmUKa2ltYWdlX3ZvZmZzZXQ6Cgp8IHU2
NCBraW1hZ2Vfdm9mZnNldCBfX3JvX2FmdGVyX2luaXQ7CnwgRVhQT1JUX1NZTUJPTChraW1hZ2Vf
dm9mZnNldCk7CgouLi4gb3IgaXMgaXQgbm90IHBvc3NpYmxlIHRvIGluaXRpYWxpemUga2ltYWdl
X3ZhZGRyIGNvcnJlY3RseSBpbiBDPwoKVGhhbmtzLApNYXJrLgoKPiAKPiBTaWduZWQtb2ZmLWJ5
OiBSw6ltaSBEZW5pcy1Db3VybW9udCA8cmVtaUByZW1sYWIubmV0Pgo+IC0tLQo+ICBhcmNoL2Fy
bTY0L2tlcm5lbC9oZWFkLlMgfCAxMiArKysrKysrLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDcg
aW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02
NC9rZXJuZWwvaGVhZC5TIGIvYXJjaC9hcm02NC9rZXJuZWwvaGVhZC5TCj4gaW5kZXggNmUwOGVl
MmI0ZDU1Li44ZTVjMGUwMDQwZTQgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rZXJuZWwvaGVh
ZC5TCj4gKysrIGIvYXJjaC9hcm02NC9rZXJuZWwvaGVhZC5TCj4gQEAgLTQ1NywxNyArNDU3LDE5
IEBAIFNZTV9GVU5DX1NUQVJUX0xPQ0FMKF9fcHJpbWFyeV9zd2l0Y2hlZCkKPiAgCWIJc3RhcnRf
a2VybmVsCj4gIFNZTV9GVU5DX0VORChfX3ByaW1hcnlfc3dpdGNoZWQpCj4gIAo+ICsJLnB1c2hz
ZWN0aW9uICIucm9kYXRhIiwgImEiCj4gK1NZTV9EQVRBX1NUQVJUKGtpbWFnZV92YWRkcikKPiAr
CS5xdWFkCQlfdGV4dCAtIFRFWFRfT0ZGU0VUCj4gK1NZTV9EQVRBX0VORChraW1hZ2VfdmFkZHIp
Cj4gK0VYUE9SVF9TWU1CT0woa2ltYWdlX3ZhZGRyKQo+ICsJLnBvcHNlY3Rpb24KPiArCj4gIC8q
Cj4gICAqIGVuZCBlYXJseSBoZWFkIHNlY3Rpb24sIGJlZ2luIGhlYWQgY29kZSB0aGF0IGlzIGFs
c28gdXNlZCBmb3IKPiAgICogaG90cGx1ZyBhbmQgbmVlZHMgdG8gaGF2ZSB0aGUgc2FtZSBwcm90
ZWN0aW9ucyBhcyB0aGUgdGV4dCByZWdpb24KPiAgICovCj4gIAkuc2VjdGlvbiAiLmlkbWFwLnRl
eHQiLCJhd3giCj4gIAo+IC1TWU1fREFUQV9TVEFSVChraW1hZ2VfdmFkZHIpCj4gLQkucXVhZAkJ
X3RleHQgLSBURVhUX09GRlNFVAo+IC1TWU1fREFUQV9FTkQoa2ltYWdlX3ZhZGRyKQo+IC1FWFBP
UlRfU1lNQk9MKGtpbWFnZV92YWRkcikKPiAtCj4gIC8qCj4gICAqIElmIHdlJ3JlIGZvcnR1bmF0
ZSBlbm91Z2ggdG8gYm9vdCBhdCBFTDIsIGVuc3VyZSB0aGF0IHRoZSB3b3JsZCBpcwo+ICAgKiBz
YW5lIGJlZm9yZSBkcm9wcGluZyB0byBFTDEuCj4gLS0gCj4gMi4yNS4xCj4gCj4gCj4gX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBsaW51eC1hcm0ta2Vy
bmVsIG1haWxpbmcgbGlzdAo+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZwo+
IGh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJtLWtl
cm5lbApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
