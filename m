Return-Path: <SRS0=GiKq=ED=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53371C388F7
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 08:56:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7CC162467D
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 08:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wkMLqUhh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CC162467D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C04224B329;
	Wed, 28 Oct 2020 04:56:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PedUnNREWB7Q; Wed, 28 Oct 2020 04:56:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CA664B31E;
	Wed, 28 Oct 2020 04:56:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0564B31E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 04:56:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uScaTUCQ9acF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Oct 2020 04:56:40 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 408594B215
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 04:56:40 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DCBF92467C;
 Wed, 28 Oct 2020 08:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603875399;
 bh=0iBcwhtNo7yS2GiWqKP8c7Z7tmkKnorfThWY3DLtXK0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=wkMLqUhhj70Z7KQpVohbj+eQpKw1sfWjRLyD+RMmNDK4JZxViDtfXnRWFFs/dMCra
 u0jyF6zbs7aBbd6dLmxHFDItPJv2/wgS26SRu3I1SZ0ohoBK3C8FdzyNCJe3UcRzDR
 Rmnm/OW2R3uBoJ8TzEscI2Gst61+nQhdBHA1mA20=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kXhG0-00531w-PR; Wed, 28 Oct 2020 08:56:36 +0000
MIME-Version: 1.0
Date: Wed, 28 Oct 2020 08:56:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Allocate stage-2 pgd pages with
 GFP_KERNEL_ACCOUNT
In-Reply-To: <4ba2ca21-8216-cd4a-4f2d-2ab010a3182e@redhat.com>
References: <20201026144423.24683-1-will@kernel.org>
 <962c401d-4376-7ecf-1a8b-b6ad91ecfe68@redhat.com>
 <bb240736aae6315df28c90463e1c8801@kernel.org>
 <4ba2ca21-8216-cd4a-4f2d-2ab010a3182e@redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <092564e2ebf6a6844d7cda868672a51c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC0xMC0yOCAwNTo1NiwgR2F2aW4gU2hhbiB3cm90ZToKPiBIaSBNYXJjLAo+IAo+IE9u
IDEwLzI3LzIwIDg6MjcgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMC0xMC0yNiAy
Mzo0MSwgR2F2aW4gU2hhbiB3cm90ZToKPj4+IE9uIDEwLzI3LzIwIDE6NDQgQU0sIFdpbGwgRGVh
Y29uIHdyb3RlOgo+Pj4+IEZvciBjb25zaXN0ZW5jeSB3aXRoIHRoZSByZXN0IG9mIHRoZSBzdGFn
ZS0yIHBhZ2UtdGFibGUgcGFnZSAKPj4+PiBhbGxvY2F0aW9ucwo+Pj4+IChwZXJmb3JtaW5nIHVz
aW5nIGEga3ZtX21tdV9tZW1vcnlfY2FjaGUpLCBlbnN1cmUgdGhhdCBfX0dGUF9BQ0NPVU5UIAo+
Pj4+IGlzCj4+Pj4gaW5jbHVkZWQgaW4gdGhlIEdGUCBmbGFncyBmb3IgdGhlIFBHRCBwYWdlcy4K
Pj4+PiAKPj4+PiBDYzogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPj4+PiBDYzogUXVl
bnRpbiBQZXJyZXQgPHFwZXJyZXRAZ29vZ2xlLmNvbT4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBXaWxs
IERlYWNvbiA8d2lsbEBrZXJuZWwub3JnPgo+Pj4+IC0tLQo+Pj4+IMKgIGFyY2gvYXJtNjQva3Zt
L2h5cC9wZ3RhYmxlLmMgfCAyICstCj4+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pCj4+Pj4gCj4+PiAKPiAKPiBbLi4uXQo+IAo+Pj4gQW5vdGhlciBx
dWVzdGlvbiBpcyB3aHkgdGhlIHBhZ2UtdGFibGUgcGFnZXMgZm9yIGh5cCBtb2RlIGFyZW4ndAo+
Pj4gYWxsb2NhdGVkIHdpdGggX19HRlBfQUNDT1VOVCBpbiBrdm1fcGd0YWJsZV9oeXBfaW5pdCBh
bmQgCj4+PiBoeXBfbWFwX3dhbGtlcigpPwo+PiAKPj4gV2h5IHVzZXIgdGFzayB3b3VsZCB5b3Ug
YWNjb3VudCB0aGUgaHlwZXJ2aXNvciBtYXBwaW5ncyB0bz8gVGhlIHBhZ2UgCj4+IHRhYmxlcwo+
PiB1c2VkIGZvciBIWVAgY29kZSBhbmQgZGF0YSBhcmUgZGVmaW5pdGVseSBub3QgYXR0cmlidXRh
YmxlIHRvIGFueSAKPj4gdGFzay4KPj4gCj4+IFRoZSBrdm0gYW5kIGt2bV92Y3B1IG1hcHBpbmdz
ICpjb3VsZCogYmUgYXR0cmlidXRlZCB0byBhIHVzZXIgdGFzaywgCj4+IGJ1dAo+PiB0aGUgcGFn
ZSB0YWJsZXMgYXJlIGxpa2VseSBzaGFyZWQgd2l0aCBvdGhlciB0YXNrcy4gU28gd2hvIGdldHMg
dGhlIAo+PiBibGFtZT8KPj4gCj4gCj4gQXMgcmVwbGllZCB0byBXaWxsLCB0aGUgcWVtdSBjb3Vs
ZCBiZSBwdXQgaW50byBvbmUgY2dyb3VwIChtZW1vcnkgCj4gY2dyb3VwCj4gc3BlY2lmaWNseSku
IFdpdGhvdXQgX19HRlBfQUNDT1VOVCwgdGhlIGNvbnN1bWVkIG1lbW9yeSBmb3IgdGhlIAo+IHBh
Z2UtdGFibGUKPiBpc24ndCBsaW1pdGVkLiBJIHRoaW5rIHFlbXUgaXMgdGhlIG93bmVyIG9mIHRo
ZSBjb25zdW1lZCBtZW1vcnkgaW4gdGhpcwo+IGNhc2UuCgoqd2hpY2gqIFFFTVU/IFRha2UgdHdv
IHN0cnVjdCBrdm0sIGVhY2ggcmVwcmVzZW50aW5nIGEgVk0sIGVhY2ggY3JlYXRlZApieSBhIHNl
cGFyYXRlIGluc3RhbmNlIG9mIFFFTVUuIFRoZXNlIHR3byBzdHJ1Y3R1cmVzIGhhcHBlbiB0byBz
aGFyZQphIHBoeXNpY2FsIHBhZ2UgKHdoaWNoIGlzIHByZXR0eSBsaWtlbHkgaW4geW91ciBjYXNl
IGdpdmVuIHRoYXQgeW91IHVzZQpjcmF6eSBwYWdlIHNpemVzKS4KCldobyBnZXRzIHRoZSBhY2Nv
dW50aW5nIGZvciB0aGUgcGFnZSB0YWJsZXMgdGhhdCBtYXAgdGhhdCBwYWdlPyBObywgeW91CmFy
ZSBub3QgYWxsb3dlZCB0byBhbGlnbiB0aGUgc2l6ZSBvZiB0aGUgc3RydWN0dXJlIHRvIG1ha2Ug
dGhlIHByb2JsZW0gCmdvCmF3YXkuCgpFaXRoZXIgeW91IGFjY291bnQgdGhlIHBhZ2UgdGFibGVz
IHRvIGJvdGgsIG9yIHlvdSBhY2NvdW50IHRoZW0gdG8gbm9uZQpvZiB0aGVtLiBHaXZlbiB0aGF0
IGJvdGggYXJlIHdyb25nLCBJIGNob29zZSB0aGUgcGF0aCBvZiBsZWFzdCBlZmZvcnQuCgogICAg
ICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
