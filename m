Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A7CC4332F
	for <kvmarm@archiver.kernel.org>; Sun, 21 Nov 2021 21:13:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1A624B13A;
	Sun, 21 Nov 2021 16:13:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N3U43pk+pang; Sun, 21 Nov 2021 16:13:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00C104B1DA;
	Sun, 21 Nov 2021 16:13:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 822474B1AC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Nov 2021 07:55:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VeLWG1SevRSb for <kvmarm@lists.cs.columbia.edu>;
 Sun, 21 Nov 2021 07:55:49 -0500 (EST)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34B324B1AF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Nov 2021 07:55:49 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
 Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=IgNSXNY2TpIuc5DjPBel8XiPwVYxmuy/OdeenPYbteI=; b=Vu9vRhXy7bRTzRn551qpp2Sl2x
 zCtr/gMJ4DW8RwOHmzxJxzo7vDlzWes4Hqvf8OhYVQvu8TgUnPYAkp+B7dwWJGxd4qa98SoZOYuWV
 5bhHnd4moc54T+xIGj//+Ct1psMVjPk+Pdg32UPn83uTEm30Y2xWCWDUWG7zzQA8A9jiya3kArabf
 lHB8fd0S9GhuLNI6EX6C0akf58/mnAKpVwdY1c0zqvxOiNqI8W9eVWQtmP2IMzGzdVo5+UUmKjlgh
 pghg+NjWVpziG/dkvqPqodD+6axkmt7LKPKsHXKEoxT0UziAnHuI2HqKcy6sNMq8iwkWYu+xYx/tX
 kWDa6thg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1momMv-00C3xt-Mo; Sun, 21 Nov 2021 12:54:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1momMv-0002Vv-R2; Sun, 21 Nov 2021 12:54:53 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm <kvm@vger.kernel.org>
Subject: [PATCH v5 00/12] KVM: x86/xen: Add in-kernel Xen event channel
 delivery
Date: Sun, 21 Nov 2021 12:54:39 +0000
Message-Id: <20211121125451.9489-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by
 casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mailman-Approved-At: Sun, 21 Nov 2021 16:13:30 -0500
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
 butt3rflyh4ck <butterflyhuangxx@gmail.com>,
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

SW50cm9kdWNlIHRoZSBiYXNpYyBjb25jZXB0IG9mIDIgbGV2ZWwgZXZlbnQgY2hhbm5lbHMgZm9y
IGtlcm5lbCBkZWxpdmVyeSwKd2hpY2ggaXMganVzdCBhIHNpbXBsZSBtYXR0ZXIgb2YgYSBmZXcg
dGVzdF9hbmRfc2V0X2JpdCBjYWxscyBvbiBhIG1hcHBlZApzaGFyZWQgaW5mbyBwYWdlLgoKVGhp
cyBjYW4gYmUgdXNlZCBmb3Igcm91dGluZyBNU0kgb2YgcGFzc3Rocm91Z2ggZGV2aWNlcyB0byBQ
SVJRIGV2ZW50CmNoYW5uZWxzIGluIGEgWGVuIGd1ZXN0LCBhbmQgd2UgY2FuIGJ1aWxkIG9uIGl0
IGZvciBkZWxpdmVyaW5nIElQSXMgYW5kCnRpbWVycyBkaXJlY3RseSBmcm9tIHRoZSBrZXJuZWwg
dG9vLgoKdjE6IFVzZSBrdm1fbWFwX2dmbigpIGFsdGhvdWdoIEkgZGlkbid0IHF1aXRlIHNlZSBo
b3cgaXQgd29ya3MuCgp2MjogQXZvaWQga3ZtX21hcF9nZm4oKSBhbmQgaW1wbGVtZW50IGEgc2Fm
ZSBtYXBwaW5nIHdpdGggaW52YWxpZGF0aW9uCiAgICBzdXBwb3J0IGZvciBteXNlbGYuCgp2Mzog
UmVpbnZlbnQgZ2ZuX3RvX3Bmbl9jYWNoZSB3aXRoIHNhbmUgaW52YWxpZGF0aW9uIHNlbWFudGlj
cywgZm9yIG15CiAgICB1c2UgY2FzZSBhcyB3ZWxsIGFzIG5lc3RpbmcuCgp2NDogUmV3b3JrIGRp
cnR5IGhhbmRsaW5nLCBhcyBpdCBiZWNhbWUgYXBwYXJlbnRseSB0aGF0IHdlIG5lZWQgYW4gYWN0
aXZlCiAgICB2Q1BVIGNvbnRleHQgdG8gbWFyayBwYWdlcyBkaXJ0eSBzbyBpdCBjYW4ndCBiZSBk
b25lIGZyb20gdGhlIE1NVQogICAgbm90aWZpZXIgZHVpbmcgdGhlIGludmFsaWRhdGlvbjsgaXQg
aGFzIHRvIGhhcHBlbiBvbiB1bm1hcC4KCnY1OiBGaXggc3BhcnNlIHdhcm5pbmdzIHJlcG9ydGVk
IGJ5IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPi4KCiAgICBGaXggcmV2YWxpZGF0
aW9uIHdoZW4gbWVtc2xvdHMgY2hhbmdlIGJ1dCB0aGUgcmVzdWx0aW5nIEhWQSBzdGF5cwogICAg
dGhlIHNhbWUuIFdlIGNhbiB1c2UgdGhlIHNhbWUga2VybmVsIG1hcHBpbmcgaW4gdGhhdCBjYXNl
LCBpZiB0aGUKICAgIEhWQSDihpIgUEZOIHRyYW5zbGF0aW9uIHdhcyB2YWxpZCBiZWZvcmUuIFNv
IHRoYXQgcHJvYmFibHkgbWVhbnMgd2UKICAgIHNob3VsZG4ndCB1bm1hcCB0aGUgIm9sZF9odmEi
LiBBdWdtZW50IHRoZSB0ZXN0IGNhc2UgdG8gZXhlcmNpc2UKICAgIHRoYXQgb25lIHRvby4KCiAg
ICBJbmNsdWRlIHRoZSBmaXggZm9yIHRoZSBkaXJ0eSByaW5nIHZzLiBYZW4gc2hpbmZvIG9vcHMg
cmVwb3J0ZWQKICAgIGJ5IGJ1dHQzcmZseWg0Y2sgPGJ1dHRlcmZseWh1YW5neHhAZ21haWwuY29t
Pi4KCgpBcyBpbiB0aGUgcHJldmlvdXMgdHdvIHJvdW5kcywgdGhlIGxhc3QgcGF0Y2ggKHRoaXMg
dGltZSBwYXRjaCAxMikgaXMKaW5jbHVkZWQgYXMgaWxsdXN0cmF0aW9uIG9mIGhvdyB3ZSAqbWln
aHQqIHVzZSB0aGlzIGZvciBmaXhpbmcgdGhlIFVBRgpidWdzIGluIG5lc3RpbmcsIGJ1dCBpc24n
dCBpbnRlbmRlZCB0byBiZSBhcHBsaWVkIGFzLWlzLiBQYXRjaGVzIDEtMTEgYXJlLgoKCgpEYXZp
ZCBXb29kaG91c2UgKDEyKToKICAgICAgS1ZNOiBJbnRyb2R1Y2UgQ09ORklHX0hBVkVfS1ZNX0RJ
UlRZX1JJTkcKICAgICAgS1ZNOiBBZGQgTWFrZWZpbGUua3ZtIGZvciBjb21tb24gZmlsZXMsIHVz
ZSBpdCBmb3IgeDg2CiAgICAgIEtWTTogczM5MDogVXNlIE1ha2VmaWxlLmt2bSBmb3IgY29tbW9u
IGZpbGVzCiAgICAgIEtWTTogbWlwczogVXNlIE1ha2VmaWxlLmt2bSBmb3IgY29tbW9uIGZpbGVz
CiAgICAgIEtWTTogUklTQy1WOiBVc2UgTWFrZWZpbGUua3ZtIGZvciBjb21tb24gZmlsZXMKICAg
ICAgS1ZNOiBwb3dlcnBjOiBVc2UgTWFrZWZpbGUua3ZtIGZvciBjb21tb24gZmlsZXMKICAgICAg
S1ZNOiBhcm02NDogVXNlIE1ha2VmaWxlLmt2bSBmb3IgY29tbW9uIGZpbGVzCiAgICAgIEtWTTog
UmVpbnN0YXRlIGdmbl90b19wZm5fY2FjaGUgd2l0aCBpbnZhbGlkYXRpb24gc3VwcG9ydAogICAg
ICBLVk06IHg4Ni94ZW46IE1haW50YWluIHZhbGlkIG1hcHBpbmcgb2YgWGVuIHNoYXJlZF9pbmZv
IHBhZ2UKICAgICAgS1ZNOiB4ODYveGVuOiBBZGQgS1ZNX0lSUV9ST1VUSU5HX1hFTl9FVlRDSE4g
YW5kIGV2ZW50IGNoYW5uZWwgZGVsaXZlcnkKICAgICAgS1ZNOiB4ODY6IEZpeCB3YWxsIGNsb2Nr
IHdyaXRlcyBpbiBYZW4gc2hhcmVkX2luZm8gbm90IHRvIG1hcmsgcGFnZSBkaXJ0eQogICAgICBL
Vk06IHg4NjogRmlyc3QgYXR0ZW1wdCBhdCBjb252ZXJ0aW5nIG5lc3RlZCB2aXJ0dWFsIEFQSUMg
cGFnZSB0byBncGMKCiBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QgICAgICAgICAgICAg
ICAgICAgICB8ICAzMyArKwogYXJjaC9hcm02NC9rdm0vTWFrZWZpbGUgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgIDYgKy0KIGFyY2gvbWlwcy9rdm0vTWFrZWZpbGUgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgICAzICstCiBhcmNoL3Bvd2VycGMva3ZtL01ha2VmaWxlICAgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAgNiArLQogYXJjaC9yaXNjdi9rdm0vTWFrZWZpbGUgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDYgKy0KIGFyY2gvczM5MC9rdm0vTWFrZWZpbGUg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA2ICstCiBhcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9rdm1faG9zdC5oICAgICAgICAgICAgICAgICAgICB8ICAgNCArLQogYXJjaC94ODYva3ZtL0tj
b25maWcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDIgKwogYXJjaC94ODYva3Zt
L01ha2VmaWxlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDcgKy0KIGFyY2gveDg2
L2t2bS9pcnFfY29tbS5jICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEyICsKIGFyY2gv
eDg2L2t2bS92bXgvbmVzdGVkLmMgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDUwICsrLQog
YXJjaC94ODYva3ZtL3ZteC92bXguYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTIg
Ky0KIGFyY2gveDg2L2t2bS92bXgvdm14LmggICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAyICstCiBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAxNSArLQogYXJjaC94ODYva3ZtL3g4Ni5oICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgIDEgLQogYXJjaC94ODYva3ZtL3hlbi5jICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAzNDEgKysrKysrKysrKysrKysrKysrKy0tCiBhcmNoL3g4Ni9rdm0veGVuLmgg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgOSArCiBpbmNsdWRlL2xpbnV4L2t2
bV9kaXJ0eV9yaW5nLmggICAgICAgICAgICAgICAgICAgICB8ICAgOCArLQogaW5jbHVkZS9saW51
eC9rdm1faG9zdC5oICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMTAgKysrKysrKwogaW5j
bHVkZS9saW51eC9rdm1fdHlwZXMuaCAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTggKysK
IGluY2x1ZGUvdWFwaS9saW51eC9rdm0uaCAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEx
ICsKIC4uLi90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0veDg2XzY0L3hlbl9zaGluZm9fdGVzdC5jIHwg
MTg0ICsrKysrKysrKystCiB2aXJ0L2t2bS9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAgNiArCiB2aXJ0L2t2bS9NYWtlZmlsZS5rdm0gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAxNCArCiB2aXJ0L2t2bS9kaXJ0eV9yaW5nLmMgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgMiArLQogdmlydC9rdm0va3ZtX21haW4uYyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgMTYgKy0KIHZpcnQva3ZtL2t2bV9tbS5oICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDQ0ICsrKwogdmlydC9rdm0vbW11X2xvY2suaCAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMjMgLS0KIHZpcnQva3ZtL3BmbmNhY2hl
LmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMzIzICsrKysrKysrKysrKysrKysr
KysKIDI5IGZpbGVzIGNoYW5nZWQsIDExNzMgaW5zZXJ0aW9ucygrKSwgMTAxIGRlbGV0aW9ucygt
KQoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
