Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E5DC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 20 Nov 2021 10:36:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FDD24B164;
	Sat, 20 Nov 2021 05:36:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dE2y1swRiWJ1; Sat, 20 Nov 2021 05:36:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B733E4B1B2;
	Sat, 20 Nov 2021 05:36:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F7914B10D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Nov 2021 05:29:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aCEat0Od36uH for <kvmarm@lists.cs.columbia.edu>;
 Sat, 20 Nov 2021 05:29:08 -0500 (EST)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEC594B10E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Nov 2021 05:29:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
 Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=TRQbOF8/4m0nHVfskdWnV/CbhyujsfdkdJEMQwMkjO0=; b=rbKCaOFZ5JgbTWc13zVz+5G7pi
 KBsQiaKHv+h4s104PvBQTp/kMM6/OdJCllxmEOyK5rvtMsQSX46f5Kl9Z7EymiscQymAkHvlJOzzz
 4wfNgKl/OSoEhCEgRijyPyzUCTwgBZLGoQv1EKqX8xdLP88DagjU/O+5OIBKY2OoWzc0Nrc8gEbea
 58vMK2VKRZrZ484UmWfULmUrPnSj2kHDYl4O6wELuu4GZwiFjdj6JKMWUAxSxOZAZw2hOPDLSn5yU
 /iGuOmWhPC9CieBa65vESz2HpuvVn6zz7wBgOgj/SimKg5bMS6vVbHenWynsGrQpqppawbeIlgWkd
 10UdTq7g==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1moNbR-00H55u-Hg; Sat, 20 Nov 2021 10:28:13 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1moNbQ-0002K2-3l; Sat, 20 Nov 2021 10:28:12 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm <kvm@vger.kernel.org>
Subject: PATCH v4 00/11] KVM: x86/xen: Add in-kernel Xen event channel delivery
Date: Sat, 20 Nov 2021 10:27:59 +0000
Message-Id: <20211120102810.8858-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by
 desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Mailman-Approved-At: Sat, 20 Nov 2021 05:36:05 -0500
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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

RXZlbnQgY2hhbm5lbHMsIHllYWguIFRoYXQgcmVhbGx5IGlzIHdoZXJlIEkgc3RhcnRlZC4KCkl0
IHdhcyBhbGwgc28gc2ltcGxlIGluIEpvYW8gYW5kIEFua3VyJ3Mgb3JpZ2luYWwgdmVyc2lvbiBh
dCAKaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMva3ZtL21zZzE4MjU1Ni5odG1sIOKAlCBq
dXN0IGEgaGFuZGZ1bApvZiBzaW1wbGUgdGVzdF9hbmRfc2V0X2JpdCgpIGNhbGxzIG9uIHRoZSBt
YXBwZWQgcGFnZS4KCldoZW4gSSBwb3N0ZWQgdjEgSSBkaWRuJ3QgcXVpdGUgdW5kZXJzdGFuZCBo
b3cgc3RlYWwgdGltZSBhbmQgbmVzdGluZwp3ZXJlIHNhZmVseSB1c2luZyB0aGUga3ZtX21hcF9n
Zm4oKSBmdW5jdGlvbiwgYW5kIEkgcG9zdGVkIHRoZSBYZW4KcGFydCBkZWNsYXJpbmcgdGhhdCBJ
IGhhZCAicmVkdWNlZCBpdCB0byBhIHByZXZpb3VzbHkgc29sdmVkIHByb2JsZW0iLgoKVGhlbiBJ
IGZyb3duZWQgYXQga3ZtX21hcF9nZm4oKSBmb3IgYSBiaXQgbG9uZ2VyLCBjb25jbHVkZWQgaXQg
d2FzCmJhc2ljYWxseSBpbXBvc3NpYmxlIHRvIHVzZSBpdCBzYWZlbHkgb24gaXRzIG93biBiZWNh
dXNlIHRoZSBwYWdlIGl0Cm1hcHMgbWlnaHQgYmVsb25nIHRvIGFub3RoZXIgZ3Vlc3QgYnkgdGhl
IHRpbWUgaXQgZXZlbiByZXR1cm5zIHRvIGl0cwpjYWxsZXIsIGFuZCBwb3N0ZWQgYSB2MiBpbiB3
aGljaCBJIGRpZCBzb21ldGhpbmcgc2FmZXIgZm9yIG15c2VsZiBieQpob29raW5nIGludG8gdGhl
IE1NVSBub3RpZmllcnMuCgpJIHRoZW4gZml4ZWQgdGhlIHN0ZWFsIHRpbWUgcmVwb3J0aW5nLCBh
bmQga2lsbGVkIGdmbl90b19wZm5fY2FjaGUsCnVuZGVyIHNlcGFyYXRlIGNvdmVyLgoKSW4gdjMg
b2YgdGhpcyBzZXJpZXMgSSByZS1pbnRyb2R1Y2VkIGEgc2FuZXIgZ2ZuX3RvX3Bmbl9jYWNoZSB3
aXRoIE1NVSAKbm90aWZpZXIgc3VwcG9ydCB0byBnaXZlIGl0IHByb3BlciBpbnZhbGlkYXRpb24g
c2VtYW50aWNzLiBUaGlzIGNhbiBub3cgCmJlIHVzZWQgZm9yIHRoZSBYZW4gZXZlbnQgY2hhbm5l
bCBzdXBwb3J0IGFuZCBzaG91bGQgYWxzbyBiZSB1c2FibGUgZm9yIApmaXhpbmcgdGhlIHZhcmlv
dXMgdXNlLWFmdGVyLWZyZWUgcmFjZXMgaW4gdGhlIG5lc3RpbmcgY29kZSB0b28g4oCUIHRoZSAK
bGFzdCBwYXRjaCBpbiB0aGlzIHNlcmllcyBiZWluZyBhbiB1bnRlc3RlZCBwcm9vZiBvZiBjb25j
ZXB0IGF0dGVtcHQgYXQgCmZpeGluZyBvbmUgc3VjaC4KClNpbmNlIGFkZGluZyBhIEMgZmlsZSBp
biB2aXJ0L2t2bS8gd2FzIHNvbWV3aGF0IG1vcmUgcGFpbmZ1bCB0aGFuIGl0CnJlYWxseSBzaG91
bGQgaGF2ZSBiZWVuLCB0aGVyZSBpcyBhIHNtYWxsIGRldG91ciBpbnRvIGFsbCB0aGUgYXJjaApz
cGVjaWZpYyBNYWtlZmlsZXMgdG8gbWFrZSB0aGVtIGluY2x1ZGUgYSBjb21tb24gb25lLgoKdjQ6
IFJld29yayB0aGUgZGlydHkgbWFya2luZyBnaXZlbiB0aGUgcmVsZXZhdGlvbiB0aGF0IGl0IGNh
biBvbmx5IGJlIApkb25lIGZyb20gdGhlIGNvbnRleHQgb2YgYW4gYWN0aXZlIHZDUFUuIFNvIGp1
c3QgZGVmZXIgaXQgdG8gaGFwcGVuIGluIAp0aGUgdW5tYXAuIEFsc28gaW50cm9kdWNlIGEgbGln
aHR3ZWlnaHQgdW5tYXAgY2FsbCBpbnN0ZWFkIG9mIGp1c3QgdGhlIApmdWxsIGRlc3Ryb3kuIERv
Y3VtZW50IHRoZSBYZW4gc2hhcmVkIGluZm8gcGFnZSBhcyBOT1QgcGFydGljaXBhdGluZyBpbiAK
ZGlydHkgdHJhY2tpbmcuIEZpeCBhIHR5cG8gaW4gdGhlIENPTkZJR19IQVZFX0tWTV9ESVJUWV9S
SU5HIHBhdGNoIHdoaWNoIApwcmV2ZW50ZWQgdGhlIGNhcGFiaWxpdHkgZnJvbSBiZWluZyBhZHZl
cnRpc2VkLgoKSW50ZW5kZWQgZm9yIG1lcmdpbmcgdXAgdG8gcGF0Y2ggMTAuIFBhdGNoIDExIGlz
IGZvciBpbGx1c3RyYXRpb24uCgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
