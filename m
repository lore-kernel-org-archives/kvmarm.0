Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283C7C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 19:46:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 986A961A56
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 19:46:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 986A961A56
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BF494B236;
	Thu, 18 Nov 2021 14:46:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W+nqGiWA3NPh; Thu, 18 Nov 2021 14:46:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E89684B222;
	Thu, 18 Nov 2021 14:46:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7A3B4B1E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 14:24:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yUldSlrTsp80 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 14:24:15 -0500 (EST)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB2084B1AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 14:24:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
 :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
 Sender:Reply-To:Content-ID:Content-Description;
 bh=dY7Tt+ADu2oQp52XUsO3VZxqjQj7MzSBRXMcpbCbafM=; b=WoRuVORo9B/4wm/C+f4RvGG6R5
 aSUlxt0MYkOWLrvIgcfDvIr6UXShHu6loY5lSDBiU4FXuXgp3uspwRzYskh1Vs0x+Y53tK7p3vn/+
 ZjMS5DvaH8e0oC/2BcGEHKvjs+1WptAZ4FhRVASSjAXe0I60rDRJ6dyyjWPnh9cgyFCuKyilaytvL
 pJluZNiT0bwovPzhRdqmRPs1ZauvCLfEzEFBRXf3uCL1xUUDMSI+n0zj7a52oRJa//NNrrLSKe5bX
 qlCpX75DD9121jX1HXfgGNlPWl6zYrgFS/RdDFdi+eoCK7Q6hIhil60eqnxdT/fcHrzlvDtVCn6sx
 ikJ6CUsQ==;
Received: from [2a01:4c8:1087:8341:4271:4cd3:119b:a847] (helo=[IPv6:::1])
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mnn08-00GkGi-FB; Thu, 18 Nov 2021 19:23:16 +0000
Date: Thu, 18 Nov 2021 19:23:12 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_08/12=5D_KVM=3A_Propagate_vcpu?=
 =?US-ASCII?Q?_explicitly_to_mark=5Fpage=5Fdirty=5Fin=5Fslot=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <YZagjzYUsixbFre9@google.com>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-9-dwmw2@infradead.org>
 <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
 <4c48546b-eb4a-dff7-cc38-5df54f73f5d4@redhat.com>
 <20b5952e76c54a3a5dfe5a898e3b835404ac6fb1.camel@infradead.org>
 <YZaeL5YztL3p1nLM@google.com> <YZagjzYUsixbFre9@google.com>
Message-ID: <35AEC3FD-B46A-451D-B7D5-4B1BDD5407BD@infradead.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by
 desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Mailman-Approved-At: Thu, 18 Nov 2021 14:46:47 -0500
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

CgpPbiAxOCBOb3ZlbWJlciAyMDIxIDE4OjUwOjU1IEdNVCwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOgo+T24gVGh1LCBOb3YgMTgsIDIwMjEsIFNlYW4gQ2hy
aXN0b3BoZXJzb24gd3JvdGU6Cj4+IE9uIFRodSwgTm92IDE4LCAyMDIxLCBEYXZpZCBXb29kaG91
c2Ugd3JvdGU6Cj4+ID4gVGhhdCBsZWF2ZXMgdGhlIG9uZSBpbiBURFAgTU1VIGhhbmRsZV9jaGFu
Z2VkX3NwdGVfZGlydHlfbG9nKCkgd2hpY2gKPj4gPiBBRkFJQ1QgY2FuIHRyaWdnZXIgdGhlIHNh
bWUgY3Jhc2ggc2VlbiBieSBidXR0M3JmbHloNGNrIOKAlCBjYW4ndCB0aGF0Cj4+ID4gaGFwcGVu
IGZyb20gYSB0aHJlYWQgd2hlcmUga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKSBpcyBOVUxMIHRvbz8g
Rm9yIHRoYXQKPj4gPiBvbmUgSSdtIG5vdCBzdXJlLgo+PiAKPj4gSSB0aGluayBjb3VsZCBiZSB0
cmlnZ2VyIGluIHRoZSBURFAgTU1VIHZpYSBrdm1fbW11X25vdGlmaWVyX3JlbGVhc2UoKQo+PiAt
PiBrdm1fbW11X3phcF9hbGwoKSwgZS5nLiBpZiB0aGUgdXNlcnNwYWNlIFZNTSBleGl0cyB3aGls
ZSBkaXJ0eSBsb2dnaW5nIGlzCj4+IGVuYWJsZWQuICBUaGF0IHNob3VsZCBiZSBlYXN5IHRvIChk
aXMpcHJvdmUgdmlhIGEgc2VsZnRlc3QuCj4KPlNjcmF0Y2ggdGhhdCwgdGhlIGRpcnR5IGxvZyB1
cGRhdGUgaXMgZ3VhcmRlZCBieSB0aGUgbmV3X3NwdGUgYmVpbmcgcHJlc2VudCwgc28KPnphcHBp
bmcgb2YgYW55IGtpbmQgd29uJ3QgdHJpZ2dlciBpdC4KPgo+Q3VycmVudGx5LCBJIGJlbGlldmUg
dGhlIG9ubHkgcGF0aCB0aGF0IHdvdWxkIGNyZWF0ZSBhIHByZXNlbnQgU1BURSB3aXRob3V0IGFu
Cj5hY3RpdmUgdkNQVSBpcyBtbXVfbm90aWZlci5jaGFuZ2VfcHRlLCBidXQgdGhhdCBzcXVlYWtz
IGJ5IGJlY2F1c2UgaXRzIHJlcXVpcmVkCj50byBiZSB3cmFwcGVkIHdpdGggaW52YWxpZGF0ZV9y
YW5nZV97c3RhcnQsZW5kfShNTVVfTk9USUZZX0NMRUFSKSwgYW5kIEtWTSB6YXBzCj5pbiB0aGF0
IHNpdHVhdGlvbi4KCklzIGl0IHN1ZmZpY2llbnQgdG8gaGF2ZSAqYW4qIGFjdGl2ZSB2Q1BVPyAg
V2hhdCBpZiBhIFZNTSBoYXMgdGhyZWFkcyBmb3IgYWN0aXZlIHZDUFVzIGJ1dCBpcyBkb2luZyBt
bWFwL211bm1hcCBvbiBhICpkaWZmZXJlbnQqIHRocmVhZD8gRG9lcyB0aGF0IG5vdCBzdWZmZXIg
dGhlIHNhbWUgY3Jhc2g/CgoKLS0gClNlbnQgZnJvbSBteSBBbmRyb2lkIGRldmljZSB3aXRoIEst
OSBNYWlsLiBQbGVhc2UgZXhjdXNlIG15IGJyZXZpdHkuCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
