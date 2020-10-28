Return-Path: <SRS0=GiKq=ED=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B35C4363A
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 19:20:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 121CE24813
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 19:20:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 121CE24813
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49BAB4B2EC;
	Wed, 28 Oct 2020 15:20:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PTRvmsABytrv; Wed, 28 Oct 2020 15:20:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C1E04B313;
	Wed, 28 Oct 2020 15:20:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFCAA4B302
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 15:20:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NpWG-396YePH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Oct 2020 15:20:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D60AE4B2EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 15:20:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68985176C;
 Wed, 28 Oct 2020 12:20:35 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8FAC3F68F;
 Wed, 28 Oct 2020 12:20:33 -0700 (PDT)
Subject: Re: [PATCH 08/11] KVM: arm64: Inject AArch32 exceptions from HYP
To: Marc Zyngier <maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-9-maz@kernel.org>
 <b4ef5e3e-a1a4-948f-bc9d-4bd297cb26a6@arm.com>
 <6b30a9c9d082aeabc6cb81aca97b5398@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <3691596f-fb42-a6e0-8aca-5a1605219c23@arm.com>
Date: Wed, 28 Oct 2020 19:20:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <6b30a9c9d082aeabc6cb81aca97b5398@kernel.org>
Content-Language: en-GB
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
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

SGkgTWFyYywKCk9uIDI3LzEwLzIwMjAgMTk6MjEsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+ICtz
dGF0aWMgaW5saW5lIHUzMiBfX3ZjcHVfcmVhZF9jcDE1KGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwgaW50IHJlZykKPj4+ICt7Cj4+PiArwqDCoMKgIHJldHVybiBfX3ZjcHVfcmVhZF9zeXNf
cmVnKHZjcHUsIHJlZyAvIDIpOwo+Pj4gK30KCj4+IERvZXNuJ3QgdGhpcyByZS1pbXBsZW1lbnQg
dGhlIGlzc3VlIDMyMDRiZTQxMDlhZCBiaWFzZWQ/Cgo+IEkgZG9uJ3QgdGhpbmsgaXQgZG9lcy4g
VGhlIGlzc3VlIGV4aXN0ZWQgd2hlbiBhY2Nlc3NpbmcgdGhlIDMyYml0IHNoYWRvdywKPiBhbmQg
d2UgaGFkIHRvIHBpY2sgd2hpY2ggc2lkZSBvZiB0aGUgNjRiaXQgcmVnaXN0ZXIgaGFkIG91ciAz
MmJpdCB2YWx1ZS4KPiBIZXJlLCB3ZSBkaXJlY3RseSBhY2Nlc3MgdGhlIDY0Yml0IGZpbGUsIHdo
aWNoIGlzIHNhZmUuCgpCZWNhdXNlIGl0cyBub3QgYWNjZXNzaW5nIHRoZSBjb3BybyB1bmlvbiwg
YW5kIHRoZSB0d28gdXNlcnMgYXJlIGJvdGggc3RyYWlnaHQgZm9yd2FyZAphbGlhc2VzLgoKLi4u
CgpXaGF0IGRvIEkgZ2V0IGlmIEkgY2FsbDoKfCBfX3ZjcHVfcmVhZF9jcDE1KHZjcHUsIGM2X0lG
QVIpOwoKV29uJ3QgdGhpcyByZXR1cm4gdGhlIHZhbHVlIG9mIGM2X0RGQVIgaW5zdGVhZCBhcyB0
aGV5IGxpdmUgaW4gdGhlIHNhbWUgNjQgYml0IHJlZ2lzdGVyLgoKCj4gQnV0IHRoaW5raW5nIG9m
IGl0LCB3ZSBtYXkgYXMgd2VsbCBjaGFuZ2UgdGhlIGNhbGwgc2l0ZXMgdG8gZGlyZWN0bHkKPiB1
c2UgdGhlIDY0Yml0IGVudW0sIHJhdGhlciB0aGFuIHBsYXlpbmcgZ2FtZXMKCkdyZWF0IQoKCj4g
KHdlIHVzZWQgdG8gdXNlIHRoZSAzMmJpdCBkZWZpbml0aW9uIGZvciB0aGUgc2FrZSBvZiB0aGUg
ZGVmdW5jdCAzMmJpdCBwb3J0KS4KCgpUaGFua3MsCgpKYW1lcwpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
