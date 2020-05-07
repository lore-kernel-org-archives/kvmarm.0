Return-Path: <SRS0=Tpw5=6V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C12C38A2A
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 13:12:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3168D20838
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 13:12:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3168D20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A148E4B31D;
	Thu,  7 May 2020 09:12:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xzI1YIs6s3W3; Thu,  7 May 2020 09:12:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B05C4B312;
	Thu,  7 May 2020 09:12:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E3354B2CC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 09:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w-ye1x5lZIqy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 09:04:44 -0400 (EDT)
Received: from out30-54.freemail.mail.aliyun.com
 (out30-54.freemail.mail.aliyun.com [115.124.30.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05D5F4B27D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 09:04:43 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R881e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e07425;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=37; SR=0;
 TI=SMTPD_---0TxqomBt_1588856677; 
Received: from 30.27.116.247(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0TxqomBt_1588856677) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 07 May 2020 21:04:38 +0800
Subject: Re: [PATCH v4 2/7] KVM: arm64: clean up redundant 'kvm_run' parameters
To: Marc Zyngier <maz@kernel.org>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-3-tianjia.zhang@linux.alibaba.com>
 <35eb095a344b4192b912385bc02c54e6@kernel.org>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <f093f6cf-4892-7c8f-d3aa-e908d5740cba@linux.alibaba.com>
Date: Thu, 7 May 2020 21:04:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <35eb095a344b4192b912385bc02c54e6@kernel.org>
X-Mailman-Approved-At: Thu, 07 May 2020 09:12:15 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-mips@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, chenhuacai@gmail.com, mpe@ellerman.id.au,
 joro@8bytes.org, x86@kernel.org, borntraeger@de.ibm.com, mingo@redhat.com,
 thuth@redhat.com, gor@linux.ibm.com, kvm-ppc@vger.kernel.org, bp@alien8.de,
 tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 tsbogend@alpha.franken.de, cohuck@redhat.com, sean.j.christopherson@intel.com,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
 linuxppc-dev@lists.ozlabs.org
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

CgpPbiAyMDIwLzUvNSAxNjozOSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFRpYW5qaWEsCj4g
Cj4gT24gMjAyMC0wNC0yNyAwNTozNSwgVGlhbmppYSBaaGFuZyB3cm90ZToKPj4gSW4gdGhlIGN1
cnJlbnQga3ZtIHZlcnNpb24sICdrdm1fcnVuJyBoYXMgYmVlbiBpbmNsdWRlZCBpbiB0aGUgJ2t2
bV92Y3B1Jwo+PiBzdHJ1Y3R1cmUuIEZvciBoaXN0b3JpY2FsIHJlYXNvbnMsIG1hbnkga3ZtLXJl
bGF0ZWQgZnVuY3Rpb24gcGFyYW1ldGVycwo+PiByZXRhaW4gdGhlICdrdm1fcnVuJyBhbmQgJ2t2
bV92Y3B1JyBwYXJhbWV0ZXJzIGF0IHRoZSBzYW1lIHRpbWUuIFRoaXMKPj4gcGF0Y2ggZG9lcyBh
IHVuaWZpZWQgY2xlYW51cCBvZiB0aGVzZSByZW1haW5pbmcgcmVkdW5kYW50IHBhcmFtZXRlcnMu
Cj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFRpYW5qaWEgWmhhbmcgPHRpYW5qaWEuemhhbmdAbGludXgu
YWxpYmFiYS5jb20+Cj4gCj4gT24gdGhlIGZhY2Ugb2YgaXQsIHRoaXMgbG9va3MgT0ssIGJ1dCBJ
IGhhdmVuJ3QgdHJpZWQgdG8gcnVuIHRoZQo+IHJlc3VsdGluZyBrZXJuZWwuIEknbSBub3Qgb3Bw
b3NlZCB0byB0YWtpbmcgdGhpcyBwYXRjaCAqaWYqIHRoZXJlCj4gaXMgYW4gYWdyZWVtZW50IGFj
cm9zcyBhcmNoaXRlY3R1cmVzIHRvIHRha2UgdGhlIHNlcmllcyAoSSB2YWx1ZQo+IGNvbnNpc3Rl
bmN5IG92ZXIgdGhlIGphbml0b3JpYWwgZXhlcmNpc2UpLgo+IAo+IEFub3RoZXIgdGhpbmcgaXMg
dGhhdCB0aGlzIGlzIGdvaW5nIHRvIGNvbmZsaWN0IHdpdGggdGhlIHNldCBvZgo+IHBhdGNoZXMg
dGhhdCBtb3ZlIHRoZSBLVk0vYXJtIGNvZGUgYmFjayB3aGVyZSBpdCBiZWxvbmdzIChhcmNoL2Fy
bTY0L2t2bSksCj4gc28gSSdkIHByb2JhYmx5IGNoZXJyeS1waWNrIHRoYXQgb25lIGRpcmVjdGx5
Lgo+IAo+IFRoYW5rcywKPiAKPiAgwqDCoMKgwqDCoMKgwqAgTS4KPiAKCkRvIEkgbmVlZCB0byBz
dWJtaXQgdGhpcyBzZXQgb2YgcGF0Y2hlcyBzZXBhcmF0ZWx5IGZvciBlYWNoIAphcmNoaXRlY3R1
cmU/IENvdWxkIGl0IGJlIG1lcmdlZCBhdCBvbmNlLCBpZiBuZWNlc3NhcnksIEkgd2lsbApyZXN1
Ym1pdCBiYXNlZCBvbiB0aGUgbGF0ZXN0IG1haW5saW5lLgoKVGhhbmtzLApUaWFuamlhCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
