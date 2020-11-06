Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB72C56201
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:44:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C409822243
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ola4f9kK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C409822243
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47D674B8AA;
	Fri,  6 Nov 2020 11:44:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 21jzwpDcxvrA; Fri,  6 Nov 2020 11:44:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 353F24B8BA;
	Fri,  6 Nov 2020 11:44:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37A3B4B8A7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:44:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CtZeB0D8DduK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 11:44:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 068944B8A6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:44:38 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DFEF821556;
 Fri,  6 Nov 2020 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604681078;
 bh=T36IPLbT9cJ/XPnSJhoaXKK5mtHaqKLZC6nvg9TC1Ek=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Ola4f9kKMahL1JQDf/UuLWtvgFviVPCONE9o/bIL9H3q8cKIg6gYkQ29h7DoGfk0A
 wT+LXaTpsF6jSgvlZ+29oDAbVIsJVUmo2D6MqUKgTwd1I6R/SdTGPqsiz6RsRNWP6J
 sGDWKgyrpAFGVN0VWI3FqJ4Hs3vIs+jORoCJfLqU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kb4qq-008FYW-3X; Fri, 06 Nov 2020 16:44:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/5] KVM: arm64: Fix build error in user_mem_abort()
Date: Fri,  6 Nov 2020 16:44:12 +0000
Message-Id: <20201106164416.326787-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201106164416.326787-1-maz@kernel.org>
References: <20201106164416.326787-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com,
 eric.auger@redhat.com, gshan@redhat.com, xu910121@sina.com,
 dave.martin@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 =?UTF-8?q?=E5=BC=A0=E4=B8=9C=E6=97=AD?= <xu910121@sina.com>,
 linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
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

RnJvbTogR2F2aW4gU2hhbiA8Z3NoYW5AcmVkaGF0LmNvbT4KClRoZSBQVUQgYW5kIFBNRCBhcmUg
Zm9sZGVkIGludG8gUEdEIHdoZW4gdGhlIGZvbGxvd2luZyBvcHRpb25zIGFyZQplbmFibGVkLiBJ
biB0aGF0IGNhc2UsIFBVRF9TSElGVCBpcyBlcXVhbCB0byBQTURfU0hJRlQgYW5kIHdlIGZhaWwK
dG8gYnVpbGQgd2l0aCB0aGUgaW5kaWNhdGVkIGVycm9yczoKCiAgIENPTkZJR19BUk02NF9WQV9C
SVRTXzQyPXkKICAgQ09ORklHX0FSTTY0X1BBR0VfU0hJRlQ9MTYKICAgQ09ORklHX1BHVEFCTEVf
TEVWRUxTPTMKCiAgIGFyY2gvYXJtNjQva3ZtL21tdS5jOiBJbiBmdW5jdGlvbiDigJh1c2VyX21l
bV9hYm9ydOKAmToKICAgYXJjaC9hcm02NC9rdm0vbW11LmM6Nzk4OjI6IGVycm9yOiBkdXBsaWNh
dGUgY2FzZSB2YWx1ZQogICAgIGNhc2UgUE1EX1NISUZUOgogICAgIF5+fn4KICAgYXJjaC9hcm02
NC9rdm0vbW11LmM6NzkxOjI6IG5vdGU6IHByZXZpb3VzbHkgdXNlZCBoZXJlCiAgICAgY2FzZSBQ
VURfU0hJRlQ6CiAgICAgXn5+fgoKVGhpcyBmaXhlcyB0aGUgaXNzdWUgYnkgc2tpcHBpbmcgdGhl
IGNoZWNrIG9uIFBVRCBodWdlIHBhZ2Ugd2hlbiBQVUQKYW5kIFBNRCBhcmUgZm9sZGVkIGludG8g
UEdELgoKRml4ZXM6IDJmNDBjNDYwMjFiYmIgKCJLVk06IGFybTY0OiBVc2UgZmFsbGJhY2sgbWFw
cGluZyBzaXplcyBmb3IgY29udGlndW91cyBodWdlIHBhZ2Ugc2l6ZXMiKQpSZXBvcnRlZC1ieTog
RXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBHYXZpbiBT
aGFuIDxnc2hhbkByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBr
ZXJuZWwub3JnPgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjAxMTAzMDAzMDA5
LjMyOTU1LTEtZ3NoYW5AcmVkaGF0LmNvbQotLS0KIGFyY2gvYXJtNjQva3ZtL21tdS5jIHwgMiAr
KwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva3ZtL21tdS5jIGIvYXJjaC9hcm02NC9rdm0vbW11LmMKaW5kZXggYzdjNmRmNjMwOWQ1Li5h
MTA5YzUwMDE4MjcgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL21tdS5jCisrKyBiL2FyY2gv
YXJtNjQva3ZtL21tdS5jCkBAIC03ODgsMTAgKzc4OCwxMiBAQCBzdGF0aWMgaW50IHVzZXJfbWVt
X2Fib3J0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgcGh5c19hZGRyX3QgZmF1bHRfaXBhLAogCX0K
IAogCXN3aXRjaCAodm1hX3NoaWZ0KSB7CisjaWZuZGVmIF9fUEFHRVRBQkxFX1BNRF9GT0xERUQK
IAljYXNlIFBVRF9TSElGVDoKIAkJaWYgKGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBp
bmcobWVtc2xvdCwgaHZhLCBQVURfU0laRSkpCiAJCQlicmVhazsKIAkJZmFsbHRocm91Z2g7Cisj
ZW5kaWYKIAljYXNlIENPTlRfUE1EX1NISUZUOgogCQl2bWFfc2hpZnQgPSBQTURfU0hJRlQ7CiAJ
CWZhbGx0aHJvdWdoOwotLSAKMi4yOC4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
