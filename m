Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE5CC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 13:06:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B25561BCF
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 13:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4B25561BCF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F2184B187;
	Thu, 18 Nov 2021 08:05:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ETIxoyd5pvax; Thu, 18 Nov 2021 08:05:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E50374B1FE;
	Thu, 18 Nov 2021 08:05:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94C724B14C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 12:41:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2jBL+hJaivVE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 12:41:05 -0500 (EST)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D95D4B154
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 12:41:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
 Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=1uTmVWceFyeFzFF12Kb1AEwgWDvyhf/Bhrlut32WigU=; b=FA7jlDlOgsISqwIPXDH2Ot6bQj
 wU8RQi496K1TElvPccyBBkKObng9I/ztfWUm9if2d0ZlgxdzXERI2F2w16p/G1N+LGJK5gQ55Imt3
 2LYwOYo2ej6ez/YUwJUICBTPIlDyM00AjzcfyJECnVvr8A3VHa5mfauKjfLPgQ8XmaOqXVST4VkC9
 r7vEjmROPKF5D0aOb28MqmMJbqbNCReEZmjntJIXE3Y/yclHKPpzWp0maRBd4xwuDjPqeRN3G0j8j
 ua317PE4jft5Ek/d1EkWWz/6UQpufMevbcHTjYgB9ErEGup9Yv1zpvhbF1t4S1ODBCKh/vuqTwoAr
 Apx47PCA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mnOum-00GXWZ-Cq; Wed, 17 Nov 2021 17:40:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1mnOum-001GxB-2V; Wed, 17 Nov 2021 17:40:08 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm <kvm@vger.kernel.org>
Subject: [PATCH v3 00/12] KVM: x86/xen: Add in-kernel Xen event channel
 delivery
Date: Wed, 17 Nov 2021 17:39:51 +0000
Message-Id: <20211117174003.297096-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by
 desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Mailman-Approved-At: Thu, 18 Nov 2021 08:05:18 -0500
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
b2YgdGhpcyBzZXJpZXMgSSByZS1pbnRyb2R1Y2UgYSBzYW5lciBnZm5fdG9fcGZuX2NhY2hlIHdp
dGggTU1VIApub3RpZmllciBzdXBwb3J0IHRvIGdpdmUgaXQgcHJvcGVyIGludmFsaWRhdGlvbiBz
ZW1hbnRpY3MuIFRoaXMgY2FuIG5vdyAKYmUgdXNlZCBmb3IgdGhlIFhlbiBldmVudCBjaGFubmVs
IHN1cHBvcnQgYW5kIHNob3VsZCBhbHNvIGJlIHVzYWJsZSBmb3IgCmZpeGluZyB0aGUgdmFyaW91
cyB1c2UtYWZ0ZXItZnJlZSByYWNlcyBpbiB0aGUgbmVzdGluZyBjb2RlIHRvbyDigJQgdGhlIAps
YXN0IHBhdGNoIGluIHRoaXMgc2VyaWVzIGJlaW5nIGFuIHVudGVzdGVkIHByb29mIG9mIGNvbmNl
cHQgYXR0ZW1wdCBhdCAKZml4aW5nIG9uZSBzdWNoLgoKU2luY2UgYWRkaW5nIGEgQyBmaWxlIGlu
IHZpcnQva3ZtLyB3YXMgc29tZXdoYXQgbW9yZSBwYWluZnVsIHRoYW4gaXQKcmVhbGx5IHNob3Vs
ZCBoYXZlIGJlZW4sIHRoZXJlIGlzIGEgc21hbGwgZGV0b3VyIGludG8gYWxsIHRoZSBhcmNoCnNw
ZWNpZmljIE1ha2VmaWxlcyB0byBtYWtlIHRoZW0gaW5jbHVkZSBhIGNvbW1vbiBvbmUuCgpJbnRl
bmRlZCBmb3IgbWVyZ2luZyB1cCB0byBwYXRjaCAxMS4gUGF0Y2ggMTIgaXMgZm9yIGlsbHVzdHJh
dGlvbi4KCkRhdmlkIFdvb2Rob3VzZSAoMTIpOgogICAgICBLVk06IEludHJvZHVjZSBDT05GSUdf
SEFWRV9LVk1fRElSVFlfUklORwogICAgICBLVk06IEFkZCBNYWtlZmlsZS5rdm0gZm9yIGNvbW1v
biBmaWxlcywgdXNlIGl0IGZvciB4ODYKICAgICAgS1ZNOiBzMzkwOiBVc2UgTWFrZWZpbGUua3Zt
IGZvciBjb21tb24gZmlsZXMKICAgICAgS1ZNOiBtaXBzOiBVc2UgTWFrZWZpbGUua3ZtIGZvciBj
b21tb24gZmlsZXMKICAgICAgS1ZNOiBSSVNDLVY6IFVzZSBNYWtlZmlsZS5rdm0gZm9yIGNvbW1v
biBmaWxlcwogICAgICBLVk06IHBvd2VycGM6IFVzZSBNYWtlZmlsZS5rdm0gZm9yIGNvbW1vbiBm
aWxlcwogICAgICBLVk06IGFybTY0OiBVc2UgTWFrZWZpbGUua3ZtIGZvciBjb21tb24gZmlsZXMK
ICAgICAgS1ZNOiBQcm9wYWdhdGUgdmNwdSBleHBsaWNpdGx5IHRvIG1hcmtfcGFnZV9kaXJ0eV9p
bl9zbG90KCkKICAgICAgS1ZNOiBSZWluc3RhdGUgZ2ZuX3RvX3Bmbl9jYWNoZSB3aXRoIGludmFs
aWRhdGlvbiBzdXBwb3J0CiAgICAgIEtWTTogeDg2L3hlbjogTWFpbnRhaW4gdmFsaWQgbWFwcGlu
ZyBvZiBYZW4gc2hhcmVkX2luZm8gcGFnZQogICAgICBLVk06IHg4Ni94ZW46IEFkZCBLVk1fSVJR
X1JPVVRJTkdfWEVOX0VWVENITiBhbmQgZXZlbnQgY2hhbm5lbCBkZWxpdmVyeQogICAgICBLVk06
IHg4NjogRmlyc3QgYXR0ZW1wdCBhdCBjb252ZXJ0aW5nIG5lc3RlZCB2aXJ0dWFsIEFQSUMgcGFn
ZSB0byBncGMKCiBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QgICAgICAgICAgICAgICAg
ICAgICB8ICAyMSArKwogYXJjaC9hcm02NC9rdm0vTWFrZWZpbGUgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgIDYgKy0KIGFyY2gvYXJtNjQva3ZtL21tdS5jICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHwgICAyICstCiBhcmNoL21pcHMva3ZtL01ha2VmaWxlICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgMyArLQogYXJjaC9wb3dlcnBjL2t2bS9NYWtlZmlsZSAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgIDYgKy0KIGFyY2gvcmlzY3Yva3ZtL01ha2VmaWxlICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA2ICstCiBhcmNoL3MzOTAva3ZtL01ha2VmaWxl
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgNiArLQogYXJjaC94ODYvaW5jbHVkZS9h
c20va3ZtX2hvc3QuaCAgICAgICAgICAgICAgICAgICAgfCAgIDQgKy0KIGFyY2gveDg2L2t2bS9L
Y29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAyICsKIGFyY2gveDg2L2t2
bS9NYWtlZmlsZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA3ICstCiBhcmNoL3g4
Ni9rdm0vaXJxX2NvbW0uYyAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAxMiArCiBhcmNo
L3g4Ni9rdm0vbW11L21tdS5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArLQog
YXJjaC94ODYva3ZtL21tdS9zcHRlLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDIg
Ky0KIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAyICstCiBhcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICA1MCArKystCiBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAxMiArLQogYXJjaC94ODYva3ZtL3ZteC92bXguaCAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgIDIgKy0KIGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgIDE3ICstCiBhcmNoL3g4Ni9rdm0veGVuLmMgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB8IDI4NyArKysrKysrKysrKysrKysrKysrLS0KIGFyY2gveDg2
L2t2bS94ZW4uaCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA5ICsKIGluY2x1
ZGUvbGludXgva3ZtX2RpcnR5X3JpbmcuaCAgICAgICAgICAgICAgICAgICAgIHwgIDE0ICstCiBp
bmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggICAgICAgICAgICAgICAgICAgICAgICAgICB8IDEwMCAr
KysrKystCiBpbmNsdWRlL2xpbnV4L2t2bV90eXBlcy5oICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAxOCArKwogaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgMTEgKwogLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS94ODZfNjQveGVuX3NoaW5m
b190ZXN0LmMgfCAxMTIgKysrKysrKy0KIHZpcnQva3ZtL0tjb25maWcgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICA2ICsKIHZpcnQva3ZtL01ha2VmaWxlLmt2bSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgIDE0ICsKIHZpcnQva3ZtL2RpcnR5X3JpbmcuYyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEwICstCiB2aXJ0L2t2bS9rdm1fbWFpbi5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAzNCArKy0KIHZpcnQva3ZtL3ttbXVfbG9j
ay5oID0+IGt2bV9tbS5ofSAgICAgICAgICAgICAgICAgIHwgIDIzICstCiB2aXJ0L2t2bS9wZm5j
YWNoZS5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDI4MSArKysrKysrKysrKysr
KysrKysrKwogMzEgZmlsZXMgY2hhbmdlZCwgOTkyIGluc2VydGlvbnMoKyksIDg5IGRlbGV0aW9u
cygtKQoKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
