Return-Path: <SRS0=GiKq=ED=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4491DC388F7
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 05:56:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 788CD2231B
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 05:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLPAvIku"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 788CD2231B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1D94B421;
	Wed, 28 Oct 2020 01:56:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FTJaolyoTpJx; Wed, 28 Oct 2020 01:56:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD00F4B41F;
	Wed, 28 Oct 2020 01:56:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 127704B417
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 01:56:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zvylNGuaOZm3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Oct 2020 01:56:15 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41A034B41F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 01:56:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603864575;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7A2PwOA7rI4QtxUd/DMjlXVpNwu2MHmCvUDow0OAa6o=;
 b=DLPAvIkuk9EOX/mZu/oObX4ym4JeVsd5gHCZEQNa6xFWD6efDIynFOZwx5+44utuCkVGjP
 +9OzeNJam457i3CSrANgKbNxP8poU9+5j+vr6bC8y1IVyvjmGfZ/5w1uG3O2VQOJ5m1Qy1
 erJZne5GcbOwwk73+49H1ha3y8YJiXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-wdp_Guw7OmeNnCVE_VbRYQ-1; Wed, 28 Oct 2020 01:56:10 -0400
X-MC-Unique: wdp_Guw7OmeNnCVE_VbRYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 770161009E27;
 Wed, 28 Oct 2020 05:56:09 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B3EA60C07;
 Wed, 28 Oct 2020 05:56:07 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: Allocate stage-2 pgd pages with
 GFP_KERNEL_ACCOUNT
To: Marc Zyngier <maz@kernel.org>
References: <20201026144423.24683-1-will@kernel.org>
 <962c401d-4376-7ecf-1a8b-b6ad91ecfe68@redhat.com>
 <bb240736aae6315df28c90463e1c8801@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <4ba2ca21-8216-cd4a-4f2d-2ab010a3182e@redhat.com>
Date: Wed, 28 Oct 2020 16:56:05 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <bb240736aae6315df28c90463e1c8801@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

SGkgTWFyYywKCk9uIDEwLzI3LzIwIDg6MjcgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAy
MDIwLTEwLTI2IDIzOjQxLCBHYXZpbiBTaGFuIHdyb3RlOgo+PiBPbiAxMC8yNy8yMCAxOjQ0IEFN
LCBXaWxsIERlYWNvbiB3cm90ZToKPj4+IEZvciBjb25zaXN0ZW5jeSB3aXRoIHRoZSByZXN0IG9m
IHRoZSBzdGFnZS0yIHBhZ2UtdGFibGUgcGFnZSBhbGxvY2F0aW9ucwo+Pj4gKHBlcmZvcm1pbmcg
dXNpbmcgYSBrdm1fbW11X21lbW9yeV9jYWNoZSksIGVuc3VyZSB0aGF0IF9fR0ZQX0FDQ09VTlQg
aXMKPj4+IGluY2x1ZGVkIGluIHRoZSBHRlAgZmxhZ3MgZm9yIHRoZSBQR0QgcGFnZXMuCj4+Pgo+
Pj4gQ2M6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4+PiBDYzogUXVlbnRpbiBQZXJy
ZXQgPHFwZXJyZXRAZ29vZ2xlLmNvbT4KPj4+IFNpZ25lZC1vZmYtYnk6IFdpbGwgRGVhY29uIDx3
aWxsQGtlcm5lbC5vcmc+Cj4+PiAtLS0KPj4+IMKgIGFyY2gvYXJtNjQva3ZtL2h5cC9wZ3RhYmxl
LmMgfCAyICstCj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRp
b24oLSkKPj4+Cj4+CgpbLi4uXQoKPj4gQW5vdGhlciBxdWVzdGlvbiBpcyB3aHkgdGhlIHBhZ2Ut
dGFibGUgcGFnZXMgZm9yIGh5cCBtb2RlIGFyZW4ndAo+PiBhbGxvY2F0ZWQgd2l0aCBfX0dGUF9B
Q0NPVU5UIGluIGt2bV9wZ3RhYmxlX2h5cF9pbml0IGFuZCBoeXBfbWFwX3dhbGtlcigpPwo+IAo+
IFdoeSB1c2VyIHRhc2sgd291bGQgeW91IGFjY291bnQgdGhlIGh5cGVydmlzb3IgbWFwcGluZ3Mg
dG8/IFRoZSBwYWdlIHRhYmxlcwo+IHVzZWQgZm9yIEhZUCBjb2RlIGFuZCBkYXRhIGFyZSBkZWZp
bml0ZWx5IG5vdCBhdHRyaWJ1dGFibGUgdG8gYW55IHRhc2suCj4gCj4gVGhlIGt2bSBhbmQga3Zt
X3ZjcHUgbWFwcGluZ3MgKmNvdWxkKiBiZSBhdHRyaWJ1dGVkIHRvIGEgdXNlciB0YXNrLCBidXQK
PiB0aGUgcGFnZSB0YWJsZXMgYXJlIGxpa2VseSBzaGFyZWQgd2l0aCBvdGhlciB0YXNrcy4gU28g
d2hvIGdldHMgdGhlIGJsYW1lPwo+IAoKQXMgcmVwbGllZCB0byBXaWxsLCB0aGUgcWVtdSBjb3Vs
ZCBiZSBwdXQgaW50byBvbmUgY2dyb3VwIChtZW1vcnkgY2dyb3VwCnNwZWNpZmljbHkpLiBXaXRo
b3V0IF9fR0ZQX0FDQ09VTlQsIHRoZSBjb25zdW1lZCBtZW1vcnkgZm9yIHRoZSBwYWdlLXRhYmxl
Cmlzbid0IGxpbWl0ZWQuIEkgdGhpbmsgcWVtdSBpcyB0aGUgb3duZXIgb2YgdGhlIGNvbnN1bWVk
IG1lbW9yeSBpbiB0aGlzCmNhc2UuCgpDaGVlcnMsCkdhdmluCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
