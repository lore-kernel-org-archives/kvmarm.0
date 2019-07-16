Return-Path: <SRS0=eCDF=VN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C81C76195
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 17:44:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BA209217F9
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 17:44:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA209217F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EC264A4F4;
	Tue, 16 Jul 2019 13:44:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lb9n6bwqHkXf; Tue, 16 Jul 2019 13:44:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1484A525;
	Tue, 16 Jul 2019 13:44:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE9E64A4F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 13:43:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CP+bZMWY5knB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jul 2019 13:43:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 953FF4A4EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 13:43:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB28D2B;
 Tue, 16 Jul 2019 10:43:57 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EE163F71A;
 Tue, 16 Jul 2019 10:43:54 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
 Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Julien Thierry <julien.thierry@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] MAINTAINERS: Update my email address to @kernel.org
Date: Tue, 16 Jul 2019 18:43:08 +0100
Message-Id: <20190716174308.17147-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

SSB3aWxsIHNvb24gbG9zZSBhY2Nlc3MgdG8gbXkgQGFybS5jb20gZW1haWwgYWRkcmVzcywgc28g
bGV0J3MKdXBkYXRlIHRoZSBNQUlOVEFJTkVSUyBmaWxlIHRvIHBvaW50IHRvIG15IEBrZXJuZWwu
b3JnIGFkZHJlc3MsCmFzIHdlbGwgYXMgLm1haWxtYXAgZm9yIGdvb2QgbWVhc3VyZS4KCk5vdGUg
dGhhdCBteSBAYXJtLmNvbSBhZGRyZXNzIHdpbGwgc3RpbGwgd29yaywgYnV0IHNvbWVvbmUgZWxz
ZQp3aWxsIGJlIHJlYWRpbmcgd2hhdGV2ZXIgaXMgc2VudCB0aGVyZS4gRG9uJ3Qgc2F5IHlvdSBk
aWRuJ3Qga25vdyEKClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFy
bS5jb20+Ci0tLQoKTm90ZXM6CiAgICBZZXMsIEknbSBzZW5kaW5nIHRoaXMgZnJvbSBteSBBUk0g
YWRkcmVzcy4gVGhhdCdzIGludGVudGlvbmFsLgogICAgSSdsbCBwcm9iYWJseSBzZW5kIGl0IGFz
IHBhcnQgb2YgYSBwdWxsIHJlcXVlc3QgbGF0ZXIgaW4gdGhlCiAgICBjeWNsZSwgYnV0IHRoYXQn
cyBqdXN0IHNvIHRoYXQgcGVvcGxlIGtub3cgd2hhdCBpcyBjb21pbmcuCgogLm1haWxtYXAgICAg
fCAxICsKIE1BSU5UQUlORVJTIHwgOCArKysrLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2Vy
dGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvLm1haWxtYXAgYi8ubWFpbG1h
cAppbmRleCAwZmVmOTMyZGUzZGIuLjIzY2ZlZDJlMDE1YyAxMDA2NDQKLS0tIGEvLm1haWxtYXAK
KysrIGIvLm1haWxtYXAKQEAgLTEzMiw2ICsxMzIsNyBAQCBMaW51cyBMw7xzc2luZyA8bGludXMu
bHVlc3NpbmdAYzBkMy5ibHVlPiA8bGludXMubHVlc3NpbmdAYXNjb20uY2g+CiBMaSBZYW5nIDxs
ZW95YW5nLmxpQG54cC5jb20+IDxsZW9Aemgta2VybmVsLm9yZz4KIExpIFlhbmcgPGxlb3lhbmcu
bGlAbnhwLmNvbT4gPGxlb2xpQGZyZWVzY2FsZS5jb20+CiBNYWNpZWogVy4gUm96eWNraSA8bWFj
cm9AbWlwcy5jb20+IDxtYWNyb0BpbWd0ZWMuY29tPgorTWFyYyBaeW5naWVyIDxtYXpAa2VybmVs
Lm9yZz4gPG1hcmMuenluZ2llckBhcm0uY29tPgogTWFyY2luIE5vd2Frb3dza2kgPG1hcmNpbi5u
b3dha293c2tpQG1pcHMuY29tPiA8bWFyY2luLm5vd2Frb3dza2lAaW1ndGVjLmNvbT4KIE1hcmsg
QnJvd24gPGJyb29uaWVAc2lyZW5hLm9yZy51az4KIE1hcmsgWWFvIDxtYXJreWFvMDU5MUBnbWFp
bC5jb20+IDxtYXJrLnlhb0Byb2NrLWNoaXBzLmNvbT4KZGlmZiAtLWdpdCBhL01BSU5UQUlORVJT
IGIvTUFJTlRBSU5FUlMKaW5kZXggNjc3ZWY0MWNiMDEyLi5lZmYzZGNhNDg2OWQgMTAwNjQ0Ci0t
LSBhL01BSU5UQUlORVJTCisrKyBiL01BSU5UQUlORVJTCkBAIC0xMTYxLDcgKzExNjEsNyBAQCBG
OglpbmNsdWRlL3VhcGkvbGludXgvaWZfYXJjbmV0LmgKIAogQVJNIEFSQ0hJVEVDVEVEIFRJTUVS
IERSSVZFUgogTToJTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4KLU06CU1hcmMg
WnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+CitNOglNYXJjIFp5bmdpZXIgPG1hekBrZXJu
ZWwub3JnPgogTDoJbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnIChtb2RlcmF0
ZWQgZm9yIG5vbi1zdWJzY3JpYmVycykKIFM6CU1haW50YWluZWQKIEY6CWFyY2gvYXJtL2luY2x1
ZGUvYXNtL2FyY2hfdGltZXIuaApAQCAtODMwMyw3ICs4MzAzLDcgQEAgUzoJT2Jzb2xldGUKIEY6
CWluY2x1ZGUvdWFwaS9saW51eC9pcHguaAogCiBJUlEgRE9NQUlOUyAoSVJRIE5VTUJFUiBNQVBQ
SU5HIExJQlJBUlkpCi1NOglNYXJjIFp5bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgorTToJ
TWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KIFM6CU1haW50YWluZWQKIFQ6CWdpdCBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcC5naXQgaXJx
L2NvcmUKIEY6CURvY3VtZW50YXRpb24vSVJRLWRvbWFpbi50eHQKQEAgLTgzMjEsNyArODMyMSw3
IEBAIEY6CWtlcm5lbC9pcnEvCiBJUlFDSElQIERSSVZFUlMKIE06CVRob21hcyBHbGVpeG5lciA8
dGdseEBsaW51dHJvbml4LmRlPgogTToJSmFzb24gQ29vcGVyIDxqYXNvbkBsYWtlZGFlbW9uLm5l
dD4KLU06CU1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+CitNOglNYXJjIFp5bmdp
ZXIgPG1hekBrZXJuZWwub3JnPgogTDoJbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwogUzoJ
TWFpbnRhaW5lZAogVDoJZ2l0IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC90aXAvdGlwLmdpdCBpcnEvY29yZQpAQCAtODYzMyw3ICs4NjMzLDcgQEAgRjoJYXJj
aC94ODYvaW5jbHVkZS9hc20vc3ZtLmgKIEY6CWFyY2gveDg2L2t2bS9zdm0uYwogCiBLRVJORUwg
VklSVFVBTCBNQUNISU5FIEZPUiBBUk0vQVJNNjQgKEtWTS9hcm0sIEtWTS9hcm02NCkKLU06CU1h
cmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+CitNOglNYXJjIFp5bmdpZXIgPG1hekBr
ZXJuZWwub3JnPgogUjoJSmFtZXMgTW9yc2UgPGphbWVzLm1vcnNlQGFybS5jb20+CiBSOglKdWxp
ZW4gVGhpZXJyeSA8anVsaWVuLnRoaWVycnlAYXJtLmNvbT4KIFI6CVN1enVraSBLIFBvdWxvemUg
PHN1enVraS5wb3Vsb3NlQGFybS5jb20+Ci0tIAoyLjIwLjEKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
