Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC63FC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 20 Nov 2021 10:36:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 783404B10D;
	Sat, 20 Nov 2021 05:36:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sPFfoIHCfFpI; Sat, 20 Nov 2021 05:36:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFE924B186;
	Sat, 20 Nov 2021 05:36:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 345EF4B129
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Nov 2021 05:29:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mbXAd-eN9f4z for <kvmarm@lists.cs.columbia.edu>;
 Sat, 20 Nov 2021 05:29:08 -0500 (EST)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4F3F4B118
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Nov 2021 05:29:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
 Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Reply-To:Content-ID:Content-Description;
 bh=CfsPll4/NdPuO0toqkRUmnZ03yoAM6IomYyn/Hv8YUw=; b=lDvGLdHU6s89Lp+FfbSx8JRQr7
 S9cELf+pj/hpLk7u43/rBSdPpxRy1oaE4Rc1eJ8cgCT7F5EHNfgpmUyLv2g7Kr0EGIYzDA6LeQ4IW
 uqtDt4/f697C488QG4DY2ugmRqwio+nP5mAVhMQdIubEyqlUV4hMoj7tG9+kJlqF+VrU2qv/3mduz
 7sbvFWiKj3Cuw0PLq77tSSgYJ3bANDX6eVixBewnt9obd1NMyfdWvOA9LrUwLVh7CGlbyMvr1mWLg
 SY9rkM2ZwA/IpjU9TfKeXxcmX1muhggaZvgrLYJx85mFMNaVzOze+zrcihfNabiX94qzu4ci+lszN
 tTsOBqJw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1moNbR-00H55t-Hr; Sat, 20 Nov 2021 10:28:13 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1moNbQ-0002KT-TJ; Sat, 20 Nov 2021 10:28:12 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm <kvm@vger.kernel.org>
Subject: [PATCH v4 09/11] KVM: x86/xen: Maintain valid mapping of Xen
 shared_info page
Date: Sat, 20 Nov 2021 10:28:08 +0000
Message-Id: <20211120102810.8858-10-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211120102810.8858-1-dwmw2@infradead.org>
References: <20211120102810.8858-1-dwmw2@infradead.org>
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

RnJvbTogRGF2aWQgV29vZGhvdXNlIDxkd213QGFtYXpvbi5jby51az4KClVzZSB0aGUgbmV3bHkg
cmVpbnN0YXRlZCBnZm5fdG9fcGZuX2NhY2hlIHRvIG1haW50YWluIGEga2VybmVsIG1hcHBpbmcK
b2YgdGhlIFhlbiBzaGFyZWRfaW5mbyBwYWdlIHNvIHRoYXQgaXQgY2FuIGJlIGFjY2Vzc2VkIGlu
IGF0b21pYyBjb250ZXh0LgoKTm90ZSB0aGF0IHdlIGRvIG5vdCBwYXJ0aWNpcGF0ZSBpbiBkaXJ0
eSB0cmFja2luZyBmb3IgdGhlIHNoYXJlZCBpbmZvCnBhZ2UgYW5kIHdlIGRvIG5vdCBleHBsaWNp
dGx5IG1hcmsgaXQgZGlydHkgZXZlcnkgc2luZ2xlIHRpbSB3ZSBkZWxpdmVyCmFuIGV2ZW50IGNo
YW5uZWwgaW50ZXJydXB0cy4gV2Ugd291bGRuJ3Qgd2FudCB0byBkbyB0aGF0IGV2ZW4gaWYgd2Ug
KmRpZCoKaGF2ZSBhIHZhbGlkIHZDUFUgY29udGV4dCB3aXRoIHdoaWNoIHRvIGRvIHNvLgoKU2ln
bmVkLW9mZi1ieTogRGF2aWQgV29vZGhvdXNlIDxkd213QGFtYXpvbi5jby51az4KLS0tCiBEb2N1
bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QgIHwgMTIgKysrKysrKysrKysrCiBhcmNoL3g4Ni9p
bmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgIDIgKy0KIGFyY2gveDg2L2t2bS94ZW4uYyAgICAgICAg
ICAgICAgfCAyNSArKysrKysrKysrKysrKy0tLS0tLS0tLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDI3
IGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRp
b24vdmlydC9rdm0vYXBpLnJzdCBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdAppbmRl
eCBhZWViMDcxYzc2ODguLjQ1NTY2NGMzOWQ0MiAxMDA2NDQKLS0tIGEvRG9jdW1lbnRhdGlvbi92
aXJ0L2t2bS9hcGkucnN0CisrKyBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdApAQCAt
MzcxLDYgKzM3MSw5IEBAIFRoZSBiaXRzIGluIHRoZSBkaXJ0eSBiaXRtYXAgYXJlIGNsZWFyZWQg
YmVmb3JlIHRoZSBpb2N0bCByZXR1cm5zLCB1bmxlc3MKIEtWTV9DQVBfTUFOVUFMX0RJUlRZX0xP
R19QUk9URUNUMiBpcyBlbmFibGVkLiAgRm9yIG1vcmUgaW5mb3JtYXRpb24sCiBzZWUgdGhlIGRl
c2NyaXB0aW9uIG9mIHRoZSBjYXBhYmlsaXR5LgogCitOb3RlIHRoYXQgdGhlIFhlbiBzaGFyZWQg
aW5mbyBwYWdlLCBpZiBjb25maWd1cmVkLCBzaGFsbCBhbHdheXMgYmUgYXNzdW1lZAordG8gYmUg
ZGlydHkuIEtWTSB3aWxsIG5vdCBleHBsaWNpdGx5IG1hcmsgaXQgc3VjaC4KKwogNC45IEtWTV9T
RVRfTUVNT1JZX0FMSUFTCiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIApAQCAtNTEzNCw2ICs1
MTM3LDE1IEBAIEtWTV9YRU5fQVRUUl9UWVBFX1NIQVJFRF9JTkZPCiAgIG5vdCBhd2FyZSBvZiB0
aGUgWGVuIENQVSBpZCB3aGljaCBpcyB1c2VkIGFzIHRoZSBpbmRleCBpbnRvIHRoZQogICB2Y3B1
X2luZm9bXSBhcnJheSwgc28gY2Fubm90IGtub3cgdGhlIGNvcnJlY3QgZGVmYXVsdCBsb2NhdGlv
bi4KIAorICBOb3RlIHRoYXQgdGhlIHNoYXJlZCBpbmZvIHBhZ2UgbWF5IGJlIGNvbnN0YW50bHkg
d3JpdHRlbiB0byBieSBLVk07CisgIGl0IGNvbnRhaW5zIHRoZSBldmVudCBjaGFubmVsIGJpdG1h
cCB1c2VkIHRvIGRlbGl2ZXIgaW50ZXJydXB0cyB0bworICBhIFhlbiBndWVzdCwgYW1vbmdzdCBv
dGhlciB0aGluZ3MuIEl0IGlzIGV4ZW1wdCBmcm9tIGRpcnR5IHRyYWNraW5nCisgIG1lY2hhbmlz
bXMg4oCUIEtWTSB3aWxsIG5vdCBleHBsaWNpdGx5IG1hcmsgdGhlIHBhZ2UgYXMgZGlydHkgZWFj
aAorICB0aW1lIGFuIGV2ZW50IGNoYW5uZWwgaW50ZXJydXB0IGlzIGRlbGl2ZXJlZCB0byB0aGUg
Z3Vlc3QhIFRodXMsCisgIHVzZXJzcGFjZSBzaG91bGQgYWx3YXlzIGFzc3VtZSB0aGF0IHRoZSBk
ZXNpZ25hdGVkIEdGTiBpcyBkaXJ0eSBpZgorICBhbnkgdkNQVSBoYXMgYmVlbiBydW5uaW5nIG9y
IGFueSBldmVudCBjaGFubmVsIGludGVycnVwdHMgY2FuIGJlCisgIHJvdXRlZCB0byB0aGUgZ3Vl
c3QuCisKIEtWTV9YRU5fQVRUUl9UWVBFX1VQQ0FMTF9WRUNUT1IKICAgU2V0cyB0aGUgZXhjZXB0
aW9uIHZlY3RvciB1c2VkIHRvIGRlbGl2ZXIgWGVuIGV2ZW50IGNoYW5uZWwgdXBjYWxscy4KIApk
aWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL2t2bV9ob3N0LmgKaW5kZXggNmFjNjFmODVlMDdiLi40YjJiNGVjZjNiNDYgMTAw
NjQ0Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKKysrIGIvYXJjaC94ODYv
aW5jbHVkZS9hc20va3ZtX2hvc3QuaApAQCAtMTAxNCw3ICsxMDE0LDcgQEAgc3RydWN0IG1zcl9i
aXRtYXBfcmFuZ2Ugewogc3RydWN0IGt2bV94ZW4gewogCWJvb2wgbG9uZ19tb2RlOwogCXU4IHVw
Y2FsbF92ZWN0b3I7Ci0JZ2ZuX3Qgc2hpbmZvX2dmbjsKKwlzdHJ1Y3QgZ2ZuX3RvX3Bmbl9jYWNo
ZSBzaGluZm9fY2FjaGU7CiB9OwogCiBlbnVtIGt2bV9pcnFjaGlwX21vZGUgewpkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL3hlbi5jIGIvYXJjaC94ODYva3ZtL3hlbi5jCmluZGV4IGRmZjJiZGY5
NTA3YS4uZGE0YmYyYzY0MDdmIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rdm0veGVuLmMKKysrIGIv
YXJjaC94ODYva3ZtL3hlbi5jCkBAIC0yMywxNiArMjMsMjEgQEAgREVGSU5FX1NUQVRJQ19LRVlf
REVGRVJSRURfRkFMU0Uoa3ZtX3hlbl9lbmFibGVkLCBIWik7CiAKIHN0YXRpYyBpbnQga3ZtX3hl
bl9zaGFyZWRfaW5mb19pbml0KHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuKQogeworCXN0cnVj
dCBnZm5fdG9fcGZuX2NhY2hlICpncGMgPSAma3ZtLT5hcmNoLnhlbi5zaGluZm9fY2FjaGU7CiAJ
Z3BhX3QgZ3BhID0gZ2ZuX3RvX2dwYShnZm4pOwogCWludCB3Y19vZnMsIHNlY19oaV9vZnM7CiAJ
aW50IHJldCA9IDA7CiAJaW50IGlkeCA9IHNyY3VfcmVhZF9sb2NrKCZrdm0tPnNyY3UpOwogCi0J
aWYgKGt2bV9pc19lcnJvcl9odmEoZ2ZuX3RvX2h2YShrdm0sIGdmbikpKSB7Ci0JCXJldCA9IC1F
RkFVTFQ7CisJaWYgKGdmbiA9PSBHUEFfSU5WQUxJRCkgeworCQlrdm1fZ2ZuX3RvX3Bmbl9jYWNo
ZV9kZXN0cm95KGt2bSwgZ3BjKTsKIAkJZ290byBvdXQ7CiAJfQotCWt2bS0+YXJjaC54ZW4uc2hp
bmZvX2dmbiA9IGdmbjsKKworCXJldCA9IGt2bV9nZm5fdG9fcGZuX2NhY2hlX2luaXQoa3ZtLCBn
cGMsIE5VTEwsIGZhbHNlLCB0cnVlLCBncGEsCisJCQkJCVBBR0VfU0laRSwgZmFsc2UpOworCWlm
IChyZXQpCisJCWdvdG8gb3V0OwogCiAJLyogUGFyYW5vaWEgY2hlY2tzIG9uIHRoZSAzMi1iaXQg
c3RydWN0IGxheW91dCAqLwogCUJVSUxEX0JVR19PTihvZmZzZXRvZihzdHJ1Y3QgY29tcGF0X3No
YXJlZF9pbmZvLCB3YykgIT0gMHg5MDApOwpAQCAtMjYwLDE1ICsyNjUsOSBAQCBpbnQga3ZtX3hl
bl9odm1fc2V0X2F0dHIoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3hlbl9odm1fYXR0ciAq
ZGF0YSkKIAkJYnJlYWs7CiAKIAljYXNlIEtWTV9YRU5fQVRUUl9UWVBFX1NIQVJFRF9JTkZPOgot
CQlpZiAoZGF0YS0+dS5zaGFyZWRfaW5mby5nZm4gPT0gR1BBX0lOVkFMSUQpIHsKLQkJCWt2bS0+
YXJjaC54ZW4uc2hpbmZvX2dmbiA9IEdQQV9JTlZBTElEOwotCQkJciA9IDA7Ci0JCQlicmVhazsK
LQkJfQogCQlyID0ga3ZtX3hlbl9zaGFyZWRfaW5mb19pbml0KGt2bSwgZGF0YS0+dS5zaGFyZWRf
aW5mby5nZm4pOwogCQlicmVhazsKIAotCiAJY2FzZSBLVk1fWEVOX0FUVFJfVFlQRV9VUENBTExf
VkVDVE9SOgogCQlpZiAoZGF0YS0+dS52ZWN0b3IgJiYgZGF0YS0+dS52ZWN0b3IgPCAweDEwKQog
CQkJciA9IC1FSU5WQUw7CkBAIC0yOTksNyArMjk4LDEwIEBAIGludCBrdm1feGVuX2h2bV9nZXRf
YXR0cihzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1feGVuX2h2bV9hdHRyICpkYXRhKQogCQli
cmVhazsKIAogCWNhc2UgS1ZNX1hFTl9BVFRSX1RZUEVfU0hBUkVEX0lORk86Ci0JCWRhdGEtPnUu
c2hhcmVkX2luZm8uZ2ZuID0ga3ZtLT5hcmNoLnhlbi5zaGluZm9fZ2ZuOworCQlpZiAoa3ZtLT5h
cmNoLnhlbi5zaGluZm9fY2FjaGUuYWN0aXZlKQorCQkJZGF0YS0+dS5zaGFyZWRfaW5mby5nZm4g
PSBncGFfdG9fZ2ZuKGt2bS0+YXJjaC54ZW4uc2hpbmZvX2NhY2hlLmdwYSk7CisJCWVsc2UKKwkJ
CWRhdGEtPnUuc2hhcmVkX2luZm8uZ2ZuID0gR1BBX0lOVkFMSUQ7CiAJCXIgPSAwOwogCQlicmVh
azsKIApAQCAtNjYxLDExICs2NjMsMTIgQEAgaW50IGt2bV94ZW5faHZtX2NvbmZpZyhzdHJ1Y3Qg
a3ZtICprdm0sIHN0cnVjdCBrdm1feGVuX2h2bV9jb25maWcgKnhoYykKIAogdm9pZCBrdm1feGVu
X2luaXRfdm0oc3RydWN0IGt2bSAqa3ZtKQogewotCWt2bS0+YXJjaC54ZW4uc2hpbmZvX2dmbiA9
IEdQQV9JTlZBTElEOwogfQogCiB2b2lkIGt2bV94ZW5fZGVzdHJveV92bShzdHJ1Y3Qga3ZtICpr
dm0pCiB7CisJa3ZtX2dmbl90b19wZm5fY2FjaGVfZGVzdHJveShrdm0sICZrdm0tPmFyY2gueGVu
LnNoaW5mb19jYWNoZSk7CisKIAlpZiAoa3ZtLT5hcmNoLnhlbl9odm1fY29uZmlnLm1zcikKIAkJ
c3RhdGljX2JyYW5jaF9zbG93X2RlY19kZWZlcnJlZCgma3ZtX3hlbl9lbmFibGVkKTsKIH0KLS0g
CjIuMzEuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
