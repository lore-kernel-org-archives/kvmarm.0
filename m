Return-Path: <SRS0=QomF=6E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE2BC38A30
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 09:54:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E1152145D
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 09:54:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E1152145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC32C4B0CF;
	Mon, 20 Apr 2020 05:54:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PWDYp+sYApTz; Mon, 20 Apr 2020 05:54:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 047D34B14E;
	Mon, 20 Apr 2020 05:54:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 649054B144
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 03:14:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 14UruGNiT2fo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Apr 2020 03:14:36 -0400 (EDT)
Received: from out30-42.freemail.mail.aliyun.com
 (out30-42.freemail.mail.aliyun.com [115.124.30.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E85454B145
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 03:14:35 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01f04428;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=37; SR=0;
 TI=SMTPD_---0Tw1zGGs_1587366866; 
Received: from 30.27.118.66(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0Tw1zGGs_1587366866) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 20 Apr 2020 15:14:28 +0800
Subject: Re: [PATCH] KVM: X86: Fix compile error in svm/sev.c
To: Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
 tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
 benh@kernel.crashing.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, cohuck@redhat.com, heiko.carstens@de.ibm.com,
 gor@linux.ibm.com, sean.j.christopherson@intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
References: <20200419073047.14413-1-tianjia.zhang@linux.alibaba.com>
 <82ce1798-1dab-d271-d084-e9a89bb44e71@intel.com>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <8af45e72-2c68-7641-6968-70fad9c516b7@linux.alibaba.com>
Date: Mon, 20 Apr 2020 15:14:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <82ce1798-1dab-d271-d084-e9a89bb44e71@intel.com>
X-Mailman-Approved-At: Mon, 20 Apr 2020 05:54:38 -0400
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CgpPbiAyMDIwLzQvMTkgMTY6MjQsIFhpYW95YW8gTGkgd3JvdGU6Cj4gT24gNC8xOS8yMDIwIDM6
MzAgUE0sIFRpYW5qaWEgWmhhbmcgd3JvdGU6Cj4+IFRoZSBjb21waWxlciByZXBvcnRlZCB0aGUg
Zm9sbG93aW5nIGNvbXBpbGF0aW9uIGVycm9yczoKPj4KPj4gYXJjaC94ODYva3ZtL3N2bS9zZXYu
YzogSW4gZnVuY3Rpb24g4oCYc2V2X3Bpbl9tZW1vcnnigJk6Cj4+IGFyY2gveDg2L2t2bS9zdm0v
c2V2LmM6MzYxOjM6IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbgo+PiDi
gJhyZWxlYXNlX3BhZ2Vz4oCZIFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9u
XQo+PiDCoMKgwqAgcmVsZWFzZV9wYWdlcyhwYWdlcywgbnBpbm5lZCk7Cj4+IMKgwqDCoCBefn5+
fn5+fn5+fn5+Cj4+Cj4+IFRoZSByZWFzb24gaXMgdGhhdCB0aGUgJ3BhZ2VtYXAuaCcgaGVhZGVy
IGZpbGUgaXMgbm90IGluY2x1ZGVkLgo+Pgo+IAo+IEZZSS4KPiAKPiBCb3JpcyBoYXMgc2VudCB0
aGUgUGF0Y2g6Cj4gaHR0cHM6Ly9sa21sLmtlcm5lbC5vcmcvci8yMDIwMDQxMTE2MDkyNy4yNzk1
NC0xLWJwQGFsaWVuOC5kZQo+IAo+IGFuZCBpdCdzIGFscmVhZHkgaW4ga3ZtIG1hc3Rlci9xdWV1
ZSBicmFuY2gKPiAKPiAKClRoaXMgaXMgdGhlIHNhbWUgZml4LCBwbGVhc2UgaWdub3JlIHRoaXMg
cGF0Y2guCgpUaGFua3MgYW5kIGJlc3QsClRpYW5qaWEKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
